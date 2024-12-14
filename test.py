from utils import load_and_execute_sql_file

config_file_path = 'pipeline_dimensional_data/sql_server_config.cfg'
sql_file_path = 'infrastructure_initiation/dimensional_database_creation.sql'
load_and_execute_sql_file(config_file_path, sql_file_path)
