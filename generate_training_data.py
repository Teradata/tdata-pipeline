import yaml
import pandas as pd
from datetime import timedelta,datetime
from feast import Entity, Field, FeatureView,FeatureService, PushSource,RequestSource, FileSource,FeatureStore
from feast.on_demand_feature_view import on_demand_feature_view
from feast.types import Float64, Int64, Float32
from feast_teradata.offline.teradata_source import TeradataSource
import os
import getpass as gp
from teradataml import create_context, remove_context, get_context
from teradataml import DataFrame, copy_to_sql, in_schema
from teradataml import db_list_tables, db_drop_table
#from feature_repo.feature_views import ads_fv


dbload = yaml.safe_load(open("./feature_repo/feature_store.yaml"))["offline_store"]
con = create_context(host=dbload['host'],username = dbload['user'], password = dbload['password'], database = dbload['database'])
print("Connection established")

# Get training data
def get_Training_Data():
    # Initialize a FeatureStore with our current repository's configurations
    store = FeatureStore(repo_path="feature_repo")
    
    entitydf = DataFrame('Analytic_Dataset').to_pandas()
    entitydf.reset_index(inplace=True)
    entitydf = entitydf[['cust_id','event_timestamp']]
    training_data = store.get_historical_features(
        entity_df=entitydf,
        features=[
        "ads_fv:age"
        ,"ads_fv:income"
        ,"ads_fv:q1_trans_cnt"
        ,"ads_fv:q2_trans_cnt"
        ,"ads_fv:q3_trans_cnt" 
        ],
        full_feature_names=True
    ).to_df()

    return training_data

copy_to_sql(get_Training_Data(), table_name = 'training_data', if_exists = 'replace')
