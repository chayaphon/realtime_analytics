import random
import mysql.connector
import time
from datetime import datetime, timedelta

# Database connection details
db_config = {
    'user': 'dads6005',
    'password': 'dads6005',
    'host': 'localhost',
    'port': 3306,
    'database': 'dads6005'
}

# Sample provinces and region id
province_ids = list(range(1, 77))
region_ids = list(range(1, 9))

# Function to generate random sale data
def generate_random_sale(cursor):
    ids = random.randint(10, 99)
    product_id = f'P{ids:02}'
    customer_id = random.randint(10000000, 99999999)
    province_id = random.choice(province_ids)
    region_id =  'Region_' + str(random.choice(region_ids))
    discount = round(random.uniform(5, 50), 2)
    original_price = round(random.uniform(100, 500), 2)
    sale_price = round(original_price * (1 - discount / 100), 2)
    quantity = random.randint(1, 10)
    sale_datetime = datetime.now() - timedelta(seconds=random.randint(0, 300))
    
    return (customer_id, province_id, region_id, product_id, discount,
            original_price, sale_price, quantity, sale_datetime)

# Function to insert the generated sale into flash_sales table
def insert_flash_sale(cursor, sale_data):
    sql = f"""
    INSERT INTO flash_sales 
    (customer_id, province_id, region_id, product_id, discount, 
     original_price, sale_price, quantity, sale_datetime)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    cursor.execute(sql, sale_data)

def main():
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()
    
    try:
        while True:
            # Generate and insert a random sale
            sale_data = generate_random_sale(cursor)
            if sale_data:
                insert_flash_sale(cursor, sale_data)
                connection.commit()
                print(f"Inserted sale: {sale_data}")
            
            # Wait before inserting the next sale
            time.sleep(random.uniform(0.1, 3))  # Inserts every 0.1 to 3 seconds
    except KeyboardInterrupt:
        print("Simulation stopped.")
    finally:
        cursor.close()
        connection.close()

if __name__ == "__main__":
    main()
