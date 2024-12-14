import configparser
import pyodbc
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_connection_string(config_path='sql_server_config.cfg'):
    """
    Reads the configuration file to construct a connection string for SQL Server.
    """
    try:
        config = configparser.ConfigParser()
        config.read(config_path)

        if 'sql_server' not in config:
            raise KeyError("Missing 'sql_server' section in configuration file.")

        sql_config = config['sql_server']
        connection_string = (
            f"Driver={{ODBC Driver 17 for SQL Server}};"
            f"Server={sql_config['host']},{sql_config['port']};"
            f"Database={sql_config['database']};"
        )

        if 'user' in sql_config and 'password' in sql_config:
            connection_string += f"User ID={sql_config['user']};Password={sql_config['password']};"

        return connection_string

    except Exception as e:
        logging.error(f"Error while reading connection string: {e}")
        raise

def execute_sql_script(connection_string, script_path, parameters=None):
    """
    Executes a SQL script from a file against a SQL Server database.
    
    Args:
        connection_string (str): The connection string for the database.
        script_path (str): Path to the SQL script file.
        parameters (tuple): Parameters for the SQL query, if any.
    """
    try:
        with open(script_path, 'r', encoding='utf-8') as file:
            query = file.read()

        with pyodbc.connect(connection_string) as conn:
            cursor = conn.cursor()
            if parameters:
                cursor.execute(query, parameters)
            else:
                cursor.execute(query)
            conn.commit()
            logging.info(f"Successfully executed script: {script_path}")

    except FileNotFoundError:
        logging.error(f"SQL script not found: {script_path}")
        raise

    except pyodbc.Error as e:
        logging.error(f"Database error while executing {script_path}: {e}")
        raise

    except Exception as e:
        logging.error(f"Unexpected error while executing {script_path}: {e}")
        raise
