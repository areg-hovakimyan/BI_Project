
## Main Files and Directories:

- **infrastructure_initiation**: Contains SQL scripts to set up the staging and dimensional tables in SQL Server.
- **pipeline_dimensional_data**: Includes Python scripts that implement the data pipeline logic, handle logging, and manage task execution.
- **queries**: Parametrized SQL queries for data transformation, used in the pipeline.
- **reports**: Contains the Power BI dashboard file (PBIX) created from the dimensional data warehouse.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/areg-hovakimyan/BI_Project
   ```

2. Install required Python packages:
   ```bash
   pip install -r requirements.txt
   ```

3. Set up the SQL Server environment and configure the `sql_server_config.cfg` file for your local setup.

4. Execute the `main.py` script to run the entire pipeline and populate the DDS with data.

5. Open the Power BI file (`Power_BI_Dashboard.pbix`) to explore the dashboard.

## Pipeline Workflow

1. **Database Creation**: The project begins with setting up the `ORDER_DDS` database and creating the necessary staging tables.
2. **ETL Process**: The pipeline extracts raw data from staging tables, transforms it using SQL-based scripts, and loads it into the dimensional tables (with surrogate keys and historical tracking).
3. **Fact Table Loading**: Fact tables are populated by merging data from dimension tables and staging tables.
4. **Error Handling**: Invalid rows are captured and stored in a separate fact error table for further investigation.
5. **Execution Log**: Every execution is logged with an execution ID for tracking the flow and debugging.

## Power BI Dashboard

The dashboard provides a comprehensive view of business metrics, with features such as:

- **Interactive Visualizations**: Includes trend graphs, categorical and tabular visualizations.
- **Filters and Slicers**: Multiple slicers for dynamic analysis.
- **DAX Measures**: Includes custom DAX measures for aggregations, including time intelligence and filtered calculations.
- **Drill-through and Tooltips**: Enhances user experience by allowing deeper insights into the data.

## Contributors

- Areg
- Albert
- Arutiun
- Davit
- Lusine

## License

This project is licensed under the MIT License.
