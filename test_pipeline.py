from pipeline_dimensional_data.flow import DimensionalDataFlow
from utils import get_connection_string

def test_pipeline():
    # Load the database connection string
    connection_string = get_connection_string('sql_server_config.cfg')

    # Set the date range for ingestion
    start_date = '2024-01-01'
    end_date = '2024-12-31'

    # Initialize the pipeline
    pipeline = DimensionalDataFlow()

    # Execute the pipeline
    pipeline.exec(connection_string, start_date, end_date)

if __name__ == "__main__":
    test_pipeline()
