from pipeline_dimensional_data.flow import DimensionalDataFlow
from logging import setup_logger
import sys

def main(start_date, end_date):
    """
    Main function to create and execute the dimensional data flow pipeline.

    Args:
        start_date (str): Start date for data ingestion.
        end_date (str): End date for data ingestion.
    """
    try:
        # Create a unique execution ID for this pipeline run
        execution_id = "dimensional-data-flow"

        # Set up the logger
        logger = setup_logger(execution_id)
        
        logger = DimensionalDataFlow.execution

        logger.info("Starting pipeline execution...")

        # Create an instance of DimensionalDataFlow and execute it
        flow = DimensionalDataFlow()
        flow.exec(start_date, end_date)

        logger.info("Pipeline execution completed successfully!")

    except Exception as e:
        logger.exception("Pipeline execution failed")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python main.py <start_date> <end_date>")
        sys.exit(1)

    start_date = sys.argv[1]
    end_date = sys.argv[2]

    main(start_date, end_date)
