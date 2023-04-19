from datetime import timedelta
from feast import BigQuerySource, FeatureView, Entity, ValueType, FileSource,Field
import yaml
from feast_teradata.offline.teradata_source import TeradataSource
import os
import getpass as gp
from teradataml import create_context, remove_context, get_context
from teradataml import DataFrame, copy_to_sql, in_schema
from teradataml import db_list_tables, db_drop_table
from feast.types import Float64, Int64, Float32


dbload = yaml.safe_load(open("./feature_store.yaml"))["offline_store"]["database"]

#DBT generated dataset source
DBT_source = TeradataSource( database=dbload, table=f"Analytic_Dataset", timestamp_field="event_timestamp")

#Define Analytic Dataset entity
customer = Entity(name = "customer", join_keys = ['cust_id'])

#Analytic Dataset feature view
ads_fv = FeatureView(name="ads_fv",entities=[customer],source=DBT_source, schema=[
        Field(name="age", dtype=Int64),
        Field(name="income", dtype=Int64),
        Field(name="q1_trans_cnt", dtype=Float32),
        Field(name="q2_trans_cnt", dtype=Float32),
        Field(name="q3_trans_cnt", dtype=Float32),
    ],)
