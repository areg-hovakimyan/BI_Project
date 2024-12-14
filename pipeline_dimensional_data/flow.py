# flow.py
import pyodbc
import configparser
from datetime import datetime
import logging

class DataFlow:
    def __init__(self, config_path):
        self.config = self.load_config(config_path)
        self.setup_logging()

    def load_config(self, config_path):
        config = configparser.ConfigParser()
        config.read(config_path)
        return config['SQLServer']

    def setup_logging(self):
        logging.basicConfig(filename='data_flow.log', level=logging.INFO,
                            format='%(asctime)s - %(levelname)s - %(message)s')

    def exec(self, sql_file_path, start_date, end_date):
        try:
            conn_str = f"DRIVER={{self.config['Driver']}};SERVER={self.config['Server']};DATABASE={self.config['Database']};UID={self.config['User']};PWD={self.config['Password']}"
            sql_command = self.read_sql_file(sql_file_path)
            sql_command = sql_command.format(start_date=start_date, end_date=end_date)

            with pyodbc.connect(conn_str, timeout=10) as conn:
                cursor = conn.cursor()
                cursor.execute(sql_command)
                conn.commit()

            logging.info(f"Executed successfully: {sql_file_path}")
            return {'success': True}
        except Exception as e:
            logging.error(f"Error executing {sql_file_path}: {e}")
            return {'success': False}

    @staticmethod
    def read_sql_file(file_path):
        with open(file_path, 'r') as file:
            return file.read()
