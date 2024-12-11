from utils import get_connection_string
from pipeline_dimensional_data.flow import DimensionalDataFlow

if __name__ == "__main__":
    connection_string = get_connection_string()
    
    pipeline = DimensionalDataFlow()
    pipeline.exec(connection_string)
