import pyodbc
import configparser
from utils import read_sql_file, execute_sql_script

def load_config(config_path='pipeline_dimensional_data/sql_server_config.cfg'):
    """
    Loads the database configuration from a .cfg file.
    """
    config = configparser.ConfigParser()
    config.read(config_path)
    db_config = config['SQLServer']
    return db_config

def execute_update(db_config, file_name):
    """
    Executes an SQL update script from the specified file on the database.
    """
    try:
        conn_str = f'DRIVER={db_config["Driver"]};SERVER={db_config["Server"]};DATABASE={db_config["Database"]};UID={db_config["User"]};PWD={db_config["Password"]}'
        file_path = f'pipeline_dimensional_data/queries/{file_name}'
        sql_command = read_sql_file(file_path)
        execute_sql_script(conn_str, sql_command)
        return {'success': True, 'file': file_name}
    except Exception as e:
        print(f"Error executing {file_name}: {e}")
        return {'success': False, 'file': file_name}

def update_all_dimensions(db_config):
    """
    Updates all dimension tables sequentially, stopping if an error occurs.
    """
    dimension_files = [
        'update_dim_Categories.sql', 'update_dim_Customers.sql', 'update_dim_Employees.sql',
        'update_dim_Products.sql', 'update_dim_Region.sql', 'update_dim_Shippers.sql',
        'update_dim_SOR.sql', 'update_dim_Suppliers.sql', 'update_dim_Territories.sql'
    ]
    
    results = []
    for file_name in dimension_files:
        result = execute_update(db_config, file_name)
        results.append(result)
        if not result['success']:
            print(f"Failed to update with {file_name}, stopping further updates.")
            break
    return results

if __name__ == "__main__":
    config = load_config()
    update_results = update_all_dimensions(config)
    for result in update_results:
        if result['success']:
            print(f"Successfully updated from {result['file']}")
        else:
            print(f"Failed update from {result['file']}")
