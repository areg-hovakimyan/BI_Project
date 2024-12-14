import configparser
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

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
    Executes the given SQL command using SQLAlchemy.

    Args:
        conn_str (str): SQLAlchemy connection string.
        sql_command (str): SQL command to execute.

    Returns:
        None
    """
    try:
        # Creating an engine and connecting to the database
        engine = create_engine(conn_str)
        with engine.connect() as connection:
            result = connection.execute(sql_command)
            # Commit if needed (SQLAlchemy commits DDL auto but DML needs explicit commit)
            connection.commit()
            print(f"SQL script executed successfully, affected {result.rowcount} rows.")
    except Exception as e:
        print(f"An error occurred: {e}")

def load_and_execute_sql_file(config_path, file_path):
    """
    Loads SQL commands from a file and executes them on a database using SQLAlchemy.

    Args:
        config_path (str): Path to the database configuration file.
        file_path (str): Path to the SQL file to be executed.

    Returns:
        None
    """
    # Load database configuration
    db_config = load_config(config_path)
    # Create SQLAlchemy connection string
    conn_str = f'mssql+pyodbc://{db_config["User"]}:{db_config["Password"]}@{db_config["Server"]}/{db_config["Database"]}?driver={db_config["Driver"]}'
    # Reading SQL from file
    sql_command = read_sql_file(file_path)
    # Executing SQL
    execute_sql_script(conn_str, sql_command)
