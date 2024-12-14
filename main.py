# main.py
from pipeline_dimensional_data.flow import DataFlow

def main():
    data_flow = DataFlow('pipeline_dimensional_data/sql_server_config.cfg')
    
    # Example of executing a script to update dimensions
    result = data_flow.exec('pipeline_dimensional_data/queries/update_dim_Customers.sql', '2022-01-01', '2022-12-31')
    
    if result['success']:
        print("The operation was successful.")
    else:
        print("The operation failed. Check logs for details.")

if __name__ == "__main__":
    main()
