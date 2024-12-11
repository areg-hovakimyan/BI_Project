from utils import execute_sql_script

def create_tables(connection_string):
    execute_sql_script(connection_string, 'infrastructure_initiation/dimensional_db_creation.sql')
    execute_sql_script(connection_string, 'infrastructure_initiation/staging_raw_table_creation.sql')
    execute_sql_script(connection_string, 'infrastructure_initiation/dimensional_db_table_creation.sql')
    print("Tables created successfully.")
