import configparser

def get_connection_string(config_path='sql_server_config.cfg'):
    config = configparser.ConfigParser()
    config.read(config_path)
    
    sql_config = config['SQLServer']
    connection_string = (
        f"Driver={sql_config['Driver']};"
        f"Server={sql_config['Server']};"
        f"Database={sql_config['Database']};"
    )
    
    # Add authentication details
    if 'User' in sql_config and 'Password' in sql_config:
        connection_string += f"User ID={sql_config['User']};Password={sql_config['Password']};"
    
    return connection_string

def execute_sql_script(connection_string, script_path):
    import pyodbc
    with open(script_path, 'r') as file:
        query = file.read()

    with pyodbc.connect(connection_string) as conn:
        cursor = conn.cursor()
        cursor.execute(query)
        conn.commit()

    print(f"Executed script: {script_path}")
