import pyodbc
import configparser

def load_config(config_path):
    """
    Loads database configuration from a .cfg file.
    
    Args:
        config_path (str): Path to the configuration file.
    
    Returns:
        dict: Database connection parameters.
    """
    config = configparser.ConfigParser()
    config.read(config_path)
    # Assuming section 'SQLServer' exists and contains necessary details
    db_config = config['SQLServer']
    return db_config

def read_sql_file(file_path):
    """
    Reads an SQL file from the given path and returns the SQL command as a string.

    Args:
        file_path (str): The file path to the SQL script.

    Returns:
        str: The content of the SQL file as a single string.
    """
    with open(file_path, 'r') as file:
        sql_command = file.read()
    return sql_command

def execute_sql_script(conn_str, sql_command):
    """
    Executes the given SQL command on the database specified by the connection string.

    Args:
        conn_str (str): Database connection string.
        sql_command (str): SQL command to execute.

    Returns:
        None
    """
    try:
        # Establishing the connection
        with pyodbc.connect(conn_str, timeout=10) as conn:
            # Creating a cursor object using the cursor() method
            cursor = conn.cursor()
            # Executing the SQL command
            cursor.execute(sql_command)
            # Committing the transaction
            conn.commit()
            print("SQL script executed successfully.")
    except Exception as e:
        print(f"An error occurred: {e}")

def load_and_execute_sql_file(config_path, file_path):
    """
    Loads SQL commands from a file and executes them on a database using config.

    Args:
        config_path (str): Path to the database configuration file.
        file_path (str): Path to the SQL file to be executed.

    Returns:
        None
    """
    # Load database configuration
    db_config = load_config(config_path)
    # Create connection string
    conn_str = f'DRIVER={db_config["Driver"]};SERVER={db_config["Server"]};DATABASE={db_config["Database"]};UID={db_config["User"]};PWD={db_config["Password"]}'
    # Reading SQL from file
    sql_command = read_sql_file(file_path)
    # Executing SQL
    execute_sql_script(conn_str, sql_command)
