import uuid
from pipeline_dimensional_data.tasks import create_tables

class DimensionalDataFlow:
    def __init__(self):
        self.execution_id = str(uuid.uuid4())  
    
    def exec(self, connection_string):
        print(f"Execution ID: {self.execution_id}")
        
        create_tables(connection_string)
