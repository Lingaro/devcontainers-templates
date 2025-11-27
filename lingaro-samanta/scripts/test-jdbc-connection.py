#!/usr/bin/env python3
"""Test JDBC connection to MariaDB from PySpark"""

import os
from pyspark.sql import SparkSession

# Get JDBC connection details from environment or use defaults
jdbc_url = os.environ.get('DB_URL', 'jdbc:mariadb://mariadb:3306/sam')
jdbc_user = os.environ.get('DB_USER', 'sam')
jdbc_password = os.environ.get('DB_PASSWORD', 'sampass')

print(f"Testing JDBC connection to: {jdbc_url}")

# Create Spark session
spark = SparkSession.builder \
    .appName("JDBC Connection Test") \
    .master("local[*]") \
    .getOrCreate()

try:
    # Test basic connection
    df = spark.read \
        .format("jdbc") \
        .option("url", jdbc_url) \
        .option("user", jdbc_user) \
        .option("password", jdbc_password) \
        .option("query", "SELECT VERSION() as version, DATABASE() as db, USER() as user, CAST(NOW() AS CHAR) as timestamp") \
        .load()
    
    print("\n✅ JDBC Connection successful!")
    print("\nConnection details:")
    df.show(truncate=False)
    
    # Test listing tables via information_schema to avoid driver-specific SHOW wrapping
    db_name = os.environ.get('MYSQL_DATABASE', os.environ.get('DB_NAME', 'sam'))
    tables_query = f"SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE FROM information_schema.tables WHERE TABLE_SCHEMA = '{db_name}'"
    tables = spark.read \
        .format("jdbc") \
        .option("url", jdbc_url) \
        .option("user", jdbc_user) \
        .option("password", jdbc_password) \
        .option("query", tables_query) \
        .load()
    
    print("\nTables in database:")
    tables.show(truncate=False)
    
    print("\n✅ All JDBC tests passed!")
    
except Exception as e:
    print(f"\n❌ JDBC Connection failed: {e}")
    import traceback
    traceback.print_exc()
finally:
    spark.stop()
