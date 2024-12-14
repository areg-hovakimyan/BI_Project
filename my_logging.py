import logging
import os

def setup_logger(execution_id, log_file='logs/logs_dimensional_data_pipeline.txt'):
    """
    Sets up a logger for the dimensional data flow.

    Args:
        execution_id (str): Unique ID for the pipeline execution.
        log_file (str): Path to the log file.

    Returns:
        Logger object: Configured logger.
    """
    # Ensure the log directory exists
    os.makedirs(os.path.dirname(log_file), exist_ok=True)

    # Create a custom formatter with the execution ID
    formatter = logging.Formatter(
        f'%(asctime)s - Execution ID: {execution_id} - %(levelname)s - %(message)s'
    )

    # Set up file handler
    file_handler = logging.FileHandler(log_file)
    file_handler.setFormatter(formatter)

    # Set up the logger
    logger = logging.getLogger(f'dimensional_data_flow_{execution_id}')
    logger.setLevel(logging.INFO)
    logger.addHandler(file_handler)

    # Add a console handler for real-time logging (optional)
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)

    return logger
