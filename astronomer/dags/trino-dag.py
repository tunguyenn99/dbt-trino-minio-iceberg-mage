import os
from datetime import datetime
from airflow import DAG
from cosmos import DbtTaskGroup, ProjectConfig, ExecutionConfig, ProfileConfig, RenderConfig
from cosmos.profiles import TrinoCertificateProfileMapping

# Define the DBT project path and executable path
dbt_project_path = "/usr/local/airflow/dags/dbt/dbt_trino_project"
dbt_executable_path = f"{os.environ['AIRFLOW_HOME']}/venv/bin/dbt"

project_config = ProjectConfig(dbt_project_path)
execution_config = ExecutionConfig(dbt_executable_path=dbt_executable_path)
profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=TrinoCertificateProfileMapping(
        conn_id="trino_conn",
        profile_args={"schema": "tpch"
                      , "catalog": "minio"
                      , "http_scheme": "http"}
    )
)

# This DAG will run the DBT tasks in a specific order using DbtTaskGroup by using `RenderConfig` to select specific tags for each step.
with DAG(
    dag_id="dbt_trino_project_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["dbt", "dbt_trino_project"],
) as dag:

    # Step 1: STAGING
    staging = DbtTaskGroup(
        group_id="staging",
        project_config=project_config,
        profile_config=profile_config,
        execution_config=execution_config,
        render_config=RenderConfig(
            select=["tag:staging"],
        ),
    )

    # Step 2: INTERMEDIATE
    intermediate = DbtTaskGroup(
        group_id="intermediate",
        project_config=project_config,
        profile_config=profile_config,
        execution_config=execution_config,
        render_config=RenderConfig(
            select=["tag:intermediate"],
        ),
    )

    # Step 3: MARTS
    marts = DbtTaskGroup(
        group_id="marts",
        project_config=project_config,
        profile_config=profile_config,
        execution_config=execution_config,
        render_config=RenderConfig(
            select=["tag:marts"],
        ),
    )

    # Pipeline dependencies
    staging >> intermediate >> marts