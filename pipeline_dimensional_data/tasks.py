from utils import execute_sql_script

def create_tables(connection_string):
    """
    Creates necessary database, staging tables, and dimensional tables.
    """
    execute_sql_script(connection_string, 'infrastructure_initiation/dimensional_database_creation.sql')
    execute_sql_script(connection_string, 'infrastructure_initiation/staging_raw_table_creation.sql')
    execute_sql_script(connection_string, 'infrastructure_initiation/dimensional_db_table_creation.sql')
    print("Tables created successfully.")

def ingest_dimension_table(connection_string, dimension_script):
    """
    Executes a script to ingest data into a dimension table.
    Args:
        connection_string (str): Connection string to the database.
        dimension_script (str): Path to the SQL script for dimension ingestion.
    """
    execute_sql_script(connection_string, f'pipeline_dimensional_data/queries/{dimension_script}')
    print(f"Ingested data into dimension table using {dimension_script}.")

def ingest_fact_table(connection_string, start_date, end_date):
    """
    Executes a script to ingest data into the FactOrders table.
    Args:
        connection_string (str): Connection string to the database.
        start_date (str): Start date for data ingestion.
        end_date (str): End date for data ingestion.
    """
    execute_sql_script(connection_string, 'pipeline_dimensional_data/queries/update_fact.sql', (start_date, end_date))
    print("Ingested data into FactOrders table.")

def ingest_fact_error_table(connection_string, start_date, end_date):
    """
    Executes a script to ingest faulty data into the FactOrders_Error table.
    Args:
        connection_string (str): Connection string to the database.
        start_date (str): Start date for error ingestion.
        end_date (str): End date for error ingestion.
    """
    execute_sql_script(connection_string, 'pipeline_dimensional_data/queries/update_fact_error.sql', (start_date, end_date))
    print("Ingested data into FactOrders_Error table.")
