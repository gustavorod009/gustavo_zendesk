from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from google.cloud import bigquery
from datetime import datetime, timedelta
import json
import requests
import pandas as pd

# Define default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 2, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# DAG definition
dag = DAG(
    'etl_subscription_data',
    default_args=default_args,
    schedule_interval='@daily',
    catchup=False
)


# Extract Function
def extract_data():
    """Simulating extraction from API or File."""
    with open('./etl.json', 'r') as file:
        data = json.load(file)
    return data['list']



# Transform Function
def transform_data(**kwargs):
    """Transforms JSON data into DataFrame for loading."""
    ti = kwargs['ti']
    data = ti.xcom_pull(task_ids='extract')
    records = []

    for entry in data:
        sub = entry['subscription']
        cust = entry['customer']

        records.append({
            'subscription_id': sub['id'],
            'customer_id': sub['customer_id'],
            'status': sub['status'],
            'billing_period': sub['billing_period'],
            'billing_period_unit': sub['billing_period_unit'],
            'current_term_start': sub['current_term_start'],
            'current_term_end': sub['current_term_end'],
            'total_dues': sub['total_dues'],
            'currency_code': sub['currency_code'],
            'customer_name': f"{cust['first_name']} {cust['last_name']}",
            'company': cust['company'],
            'email': cust['email'],
            'billing_city': cust['billing_address']['city'],
            'billing_country': cust['billing_address']['country']
        })

    df = pd.DataFrame(records)
    df.to_csv('/tmp/transformed_data.csv', index=False)


# Load Function (Incremental Loading using BigQuery MERGE)
load_sql = """
MERGE `dev-copilot-449717-q7.zendesk.subscriptions` T
USING `dev-copilot-449717-q7.zendesk.temp_subscriptions` S
ON T.subscription_id = S.subscription_id
WHEN MATCHED THEN
  UPDATE SET
    status = S.status,
    total_dues = S.total_dues,
    current_term_start = S.current_term_start,
    current_term_end = S.current_term_end
WHEN NOT MATCHED THEN
  INSERT (subscription_id, customer_id, status, billing_period, billing_period_unit, 
          current_term_start, current_term_end, total_dues, currency_code, 
          customer_name, company, email, billing_city, billing_country)
  VALUES (S.subscription_id, S.customer_id, S.status, S.billing_period, S.billing_period_unit, 
          S.current_term_start, S.current_term_end, S.total_dues, S.currency_code, 
          S.customer_name, S.company, S.email, S.billing_city, S.billing_country);
"""

extract_task = PythonOperator(
    task_id='extract',
    python_callable=extract_data,
    dag=dag
)

transform_task = PythonOperator(
    task_id='transform',
    python_callable=transform_data,
    provide_context=True,
    dag=dag
)

load_task = BigQueryInsertJobOperator(
    task_id='load',
    configuration={
        "query": {
            "query": load_sql,
            "useLegacySql": False
        }
    },
    dag=dag
)

extract_task >> transform_task >> load_task
