import uuid
from pipeline_dimensional_data.tasks import (
    create_tables,
    ingest_dimension_table,
    ingest_fact_table,
    ingest_fact_error_table
)

class DimensionalDataFlow:
    def __init__(self):
        self.execution_id = str(uuid.uuid4())

    def exec(self, connection_string, start_date, end_date):
        """
        Executes the data pipeline sequentially.
        Args:
            connection_string (str): Connection string to the database.
            start_date (str): Start date for data ingestion.
            end_date (str): End date for data ingestion.
        """
        print(f"Execution ID: {self.execution_id}")

        try:
            # Step 1: Create necessary tables
            print("Step 1: Creating tables...")
            create_tables(connection_string)

            # Step 2: Ingest data into dimension tables
            print("Step 2: Ingesting dimension tables...")
            dimension_scripts = [
                'update_dim_Region.sql',
                'update_dim_Suppliers.sql',
                'update_dim_Territories.sql',
                'update_dim_Categories.sql',
                'update_dim_Customers.sql',
                'update_dim_Shippers.sql',
                'update_dim_SOR.sql',
                'update_dim_Employees.sql',
                'update_dim_Products.sql'
            ]
            for script in dimension_scripts:
                ingest_dimension_table(connection_string, script)

            # Step 3: Ingest data into the FactOrders table
            print("Step 3: Ingesting FactOrders table...")
            ingest_fact_table(connection_string, start_date, end_date)

            # Step 4: Ingest data into the FactOrders_Error table
            print("Step 4: Ingesting FactOrders_Error table...")
            ingest_fact_error_table(connection_string, start_date, end_date)

            print("Pipeline execution completed successfully!")
        except Exception as e:
            print(f"Pipeline execution failed: {e}")
