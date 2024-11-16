import streamlit as st
from pinotdb import connect
import pandas as pd
from streamlit_autorefresh import st_autorefresh
import plotly.express as px
from datetime import datetime, time

### ------------------------------------------------------------------------ ###
### ------------------------------ Initilize ------------------------------- ###
### ------------------------------------------------------------------------ ###

# Set page config
st.set_page_config(page_title="Real-Time Web Shopping Analytics", layout="wide")

# Auto-refresh every 1 seconds
st_autorefresh(interval=1000)

# Connect to Pinot
conn = connect(host='172.16.1.100', port=8099, path='/query/sql', scheme='http')

# Define a reusable query function
def query_pinot(sql):
    cursor = conn.cursor()
    cursor.execute(sql)
    columns = [col[0] for col in cursor.description]
    data = pd.DataFrame(cursor.fetchall(), columns=columns)
    return data

# Page Header
st.title("Real-Time Web Shopping Analytics")
st.write("Monitor live shopping metrics and trends")

### ------------------------------------------------------------------------ ###
### --------------------------------- Filters ------------------------------ ###
### ------------------------------------------------------------------------ ###
# Filters in the Sidebar
st.sidebar.header("Filters")
selected_region = st.sidebar.selectbox(
    "Select Region", 
    ["All Regions"] + query_pinot("SELECT DISTINCT region_name FROM REGION_TABLE_REALTIME")['region_name'].tolist()
)
selected_product_group = st.sidebar.selectbox(
    "Select Product Group", 
    ["All Groups"] + query_pinot("SELECT DISTINCT product_group FROM PRODUCT_TABLE_REALTIME")['product_group'].tolist()
)

# Add date range filters in the sidebar
st.sidebar.subheader("Date Range")

start_date = st.sidebar.date_input("Start Date", value=pd.to_datetime('today') - pd.Timedelta(days=1))
end_date = st.sidebar.date_input("End Date", value=pd.to_datetime('today'))

# Combine date with time
start_datetime = datetime.combine(start_date, time(0, 0, 0))
end_datetime = datetime.combine(end_date, time(23, 59, 59))

### ------------------------------------------------------------------------ ###

# Build WHERE clause dynamically
region_filter_ = f"REGION_NAME = '{selected_region}'" if selected_region != "All Regions" else ""
product_group_filter_ = f"PRODUCT_GROUP = '{selected_product_group}'" if selected_product_group != "All Groups" else ""

filters = " AND ".join([f for f in [region_filter_, product_group_filter_] if f])
combine_filter = f"WHERE {filters}" if filters else ""

region_filter = f"WHERE {region_filter_}" if selected_region != "All Regions" else ""
region_filter_AND = f"AND {region_filter_}" if selected_region != "All Regions" else ""
product_group_filter = f"WHERE {product_group_filter_}" if selected_product_group != "All Groups" else ""
product_group_filter_AND = f"AND {product_group_filter_}" if selected_product_group != "All Groups" else ""
page_group_filter_ = f"WHERE PAGE_GROUP = '{selected_product_group}'" if selected_product_group != "All Groups" else ""


### ------------------------------------------------------------------------ ###

### ------------------------------------------------------------------------ ###
### -------------------------- Real-Time Metrics --------------------------- ###
### ------------------------------------------------------------------------ ###

st.markdown("## Key Performance Indicators")
st.markdown(" ")

total_pageviews = query_pinot(
    f"SELECT COUNT(*) as TOTAL_PAGEVIEWS FROM PageView "
)
total_sales = query_pinot(
    f"SELECT SUM(SALES_AMOUNT) AS TOTAL_SALES FROM EXTENTED_FLASHSALES_STREAM_REALTIME {combine_filter}"
)
total_users = query_pinot(
    f"SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_USERS FROM EXTENTED_FLASHSALES_STREAM_REALTIME {combine_filter}"
)

# Use columns with custom widths
col1, col2, col3 = st.columns(3)
col1.metric("Total Pageviews", f"{int(total_pageviews['TOTAL_PAGEVIEWS'][0]):,}")
col2.metric("Total Sales", f"฿ {total_sales['TOTAL_SALES'][0]:,.2f}")
col3.metric("Total Users", f"{int(total_users['TOTAL_USERS'][0]):,}")

st.markdown("---")

# Visualizations in Two-Column Layout
st.markdown("## Visualizations")
st.markdown(" ")

col1, col2 = st.columns(2)


### ------------------------------------------------------------------------ ###
### -------------------------- Visualize Chart ----------------------------- ###
### ------------------------------------------------------------------------ ###

# Sales Trends Over Time
with col1:
    st.markdown("### Sales Trends Over Time")
    sales_trends_query = f"""
    SELECT WINDOW_START, SUM(TOTAL_SALES) AS TOTAL_SALES
    FROM TOTAL_SALES_BY_PRODUCTGROUP_TUMBLING_WINDOW_REALTIME
    {product_group_filter}
    GROUP BY WINDOW_START
    ORDER BY WINDOW_START
    """
    sales_trends = query_pinot(sales_trends_query)
    sales_trends['WINDOW_START'] = pd.to_datetime(sales_trends['WINDOW_START'])
    fig_sales = px.line(
        sales_trends,
        x="WINDOW_START",
        y="TOTAL_SALES",
        labels={"WINDOW_START": "Time", "TOTAL_SALES": "Total Sales ($)"}
    )
    st.plotly_chart(fig_sales, use_container_width=True)

### ------------------------------------------------------------------------ ###

# Pageviews by Region
with col2:
    st.markdown("### Pageviews by Region")
    pageviews_region_query = f"""
    SELECT REGION_NAME, MAX(COUNT_VIEW) AS PAGEVIEWS
    FROM PAGEVIEWS_BY_REGION_TABLE_REALTIME
    {region_filter}
    GROUP BY REGION_NAME
    ORDER BY PAGEVIEWS DESC
    """
    pageviews_by_region = query_pinot(pageviews_region_query)
    fig_region = px.bar(
        pageviews_by_region,
        x="REGION_NAME",
        y="PAGEVIEWS",
        labels={"REGION_NAME": "Region", "PAGEVIEWS": "Pageviews"}
    )
    st.plotly_chart(fig_region, use_container_width=True) 

### ------------------------------------------------------------------------ ###

# Flash Sales Performance
with col1:
    # Flash Sales Overview by Product Group
    st.subheader("Flash Sales by Product Group (Tumbling)")

    # Build date filter clause
    date_filter = f"WINDOW_START BETWEEN '{start_datetime}' AND '{end_datetime}'"

    # Build the query to get total sales per product group and window start
    sales_by_product_group_query = f"""
    SELECT PRODUCT_GROUP, WINDOW_START, SUM(TOTAL_SALES) AS TOTAL_SALES
    FROM TOTAL_SALES_BY_PRODUCTGROUP_TUMBLING_WINDOW_REALTIME
    WHERE {date_filter}
    {product_group_filter_AND}
    GROUP BY PRODUCT_GROUP, WINDOW_START
    ORDER BY WINDOW_START
    LIMIT 1000
    """
    sales_by_product_group = query_pinot(sales_by_product_group_query)

    # Check if DataFrame is not empty
    if not sales_by_product_group.empty:
        # Convert WINDOW_START to datetime
        sales_by_product_group['WINDOW_START'] = pd.to_datetime(sales_by_product_group['WINDOW_START'])
        
        # Sort the data
        sales_by_product_group = sales_by_product_group.sort_values(['WINDOW_START', 'PRODUCT_GROUP'])
        
        # Plot the data using a bar chart
        fig_sales = px.bar(
            sales_by_product_group,
            x='WINDOW_START',
            y='TOTAL_SALES',
            color='PRODUCT_GROUP',
            barmode='group',
            labels={
                "WINDOW_START": "Time",
                "TOTAL_SALES": "Total Sales (฿)",
                "PRODUCT_GROUP": "Product Group"
            }
        )
        
        # Update layout for better visualization
        fig_sales.update_layout(
            xaxis_title='Time',
            yaxis_title='Total Sales (฿)',
            legend_title='Product Group',
            xaxis_tickformat='%Y-%m-%d %H:%M',
            bargap=0.2
        )
        
        # Display the chart
        st.plotly_chart(fig_sales, use_container_width=True)
    else:
        st.write("No data available for the selected date range.")
        
### ------------------------------------------------------------------------ ###

with col2:
    # Flash Sales Overview by Product Group
    st.subheader("Flash Sales by Region (Tumbling)")

    # Build the query to get total sales per product group and window start
    sales_by_region_query = f"""
    SELECT REGION_NAME, WINDOW_START, SUM(TOTAL_SALES) AS TOTAL_SALES
    FROM TOTAL_SALES_BY_REGION_TUMBLING_WINDOW_REALTIME
    WHERE {date_filter}
    {region_filter_AND}
    GROUP BY REGION_NAME, WINDOW_START
    ORDER BY WINDOW_START
    LIMIT 1000
    """
    sales_by_region = query_pinot(sales_by_region_query)

    # Check if DataFrame is not empty
    if not sales_by_region.empty:
        # Convert WINDOW_START to datetime
        sales_by_region['WINDOW_START'] = pd.to_datetime(sales_by_region['WINDOW_START'])
        
        # Sort the data
        sales_by_region = sales_by_region.sort_values(['WINDOW_START', 'REGION_NAME'])
        
        # Plot the data using a bar chart
        fig_region = px.bar(
            sales_by_region,
            x='WINDOW_START',
            y='TOTAL_SALES',
            color='REGION_NAME',
            barmode='group',
            labels={
                "WINDOW_START": "Time",
                "TOTAL_SALES": "Total Sales (฿)",
                "REGION_NAME": "Region"
            }
        )
        
        # Update layout for better visualization
        fig_region.update_layout(
            xaxis_title='Time',
            yaxis_title='Total Sales (฿)',
            legend_title='Region',
            xaxis_tickformat='%Y-%m-%d %H:%M',
            bargap=0.2
        )
        
        # Display the chart
        st.plotly_chart(fig_region, use_container_width=True)
    else:
        st.write("No data available for the selected date range.")

    
# with col2:
#     st.markdown("### Flash Sales Performance")
#     flash_sales_query = f"""
#     SELECT PRODUCT_NAME, SUM(SALES_AMOUNT) AS SALES_AMOUNT
#     FROM EXTENTED_FLASHSALES_STREAM_REALTIME
#     {combine_filter}
#     GROUP BY PRODUCT_NAME
#     ORDER BY SALES_AMOUNT DESC
#     LIMIT 5
#     """
#     flash_sales = query_pinot(flash_sales_query)
#     fig_flash = px.pie(
#         flash_sales,
#         names="PRODUCT_NAME",
#         values="SALES_AMOUNT"
#     )
#     st.plotly_chart(fig_flash, use_container_width=True)