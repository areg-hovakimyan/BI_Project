import configparser

def get_connection_string(config_path='sql_server_config.cfg'):
    config = configparser.ConfigParser()
    config.read(config_path)

    sql_config = config['sql_server']
    connection_string = (
        f"Driver={{ODBC Driver 17 for SQL Server}};"
        f"Server={sql_config['host']},{sql_config['port']};"
        f"Database={sql_config['database']};"
    )

    if 'user' in sql_config and 'password' in sql_config:
        connection_string += f"User ID={sql_config['user']};Password={sql_config['password']};"

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
