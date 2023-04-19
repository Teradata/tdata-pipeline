---create database teddybank as perm=1000000000;
SET session database teddybank;
CREATE TABLE Hyperparameters(id INTEGER not null, name Varchar(100),json_hyperparameters JSON(165535)) PRIMARY INDEX (id);
INSERT INTO Hyperparameters values(1, 'TD_BincodeFit', '{
  "db": "teddybank",
  "inputtable": "onehot_titanic_dataset",
  "dimensiontable": "bc_dimensionTable",
  "output_table": "abc",
  "output_table_type": "VOLATILE",
  "TargetColumns": "''age''",
  "MethodType": "''equal-width''",
  "NBins": "3",
  "LabelPrefix": "''separate prefix values''",
  "MinValueColumn": "''MinValue_''",
  "MaxValueCOlumn": "''MaxValue_''",
  "LabelColumn": "''Label''",
  "TargetColNames": "''ColumnName''"
}'); 

INSERT INTO Hyperparameters values(2, 'TD_OneHotEncodingFit', '{
"db": "teddybank",
  "inputtable": "customers",
  "inputtable_type": "Q",
  "dimensiontable_type": "",
  "dimensiontable": "ohe_dimensionTable",
  "IsInputDense": "''true''",
  "TargetColumn": "''gender'',''state_code'',''acct_type''",
  "OtherColumnName": "",
  "CategoricalValues": "''a'',''b''",
  "Approach": "''List''",
  "CategoryCounts": "2,6,3",
  "TargetColumnNames": "''column_name''",
  "CategoriesColumn": "''category''",
  "TargetAttributes": "",
  "AttributeColumn": "",
  "ValueColumn": "",
  "cat_table": "",
  "fit_partition": ""
}'); 

INSERT INTO Hyperparameters values(3, 'TD_OneHotEncodingTransform', '{
"db": "EFS",
  "inputtable": "customers",
  "inputtable_type": "Q",
  "IsDimension": "''true''",
  "IsInputDense": "''true''",
  "partition_fittable": "",
  "partition_inputtable": "",
  "fittable": "",
  "fittable_type": "Q"
}'); 
INSERT INTO Hyperparameters values(4, 'TD_OneHotEncodingFit', '{
"db": "EFS",
  "inputtable": "accounts",
  "dimensiontable": "",
  "IsInputDense": "''true''",
  "TargetColumn": "''acct_type''",
  "OtherColumnName": "''other''",
  "CategoricalValues": "''a'',''b''",
  "Approach": "''Auto''",
  "CategoryCounts": "6",
  "TargetColumnNames": "''column_name''",
  "CategoriesColumn": "''category''",
  "TargetAttributes": "",
  "AttributeColumn": "",
  "ValueColumn": "",
  "cat_table": "",
  "fit_partition": ""
}'); 

INSERT INTO Hyperparameters values(5, 'TD_OneHotEncodingTransform', '{
"db": "EFS",
  "inputtable": "accounts",
  "inputtable_type": "",
  "IsDimension": "''true''",
  "IsInputDense": "''true''",
  "partition_fittable": "",
  "partition_inputtable": "",
  "fittable": "",
  "fittable_type": ""
}'); 


create table ohe_dimensionTable (column_name VARCHAR(20) CHARACTER SET Latin NOT CASESPECIFIC,
 category VARCHAR(20) CHARACTER SET Latin NOT CASESPECIFIC);
insert into ohe_dimensionTable values('gender','F');
insert into ohe_dimensionTable values('gender','M');
insert into ohe_dimensionTable values('state_code','a');
insert into ohe_dimensionTable values('state_code','b');
insert into ohe_dimensionTable values('state_code','c');
insert into ohe_dimensionTable values('state_code','a');
insert into ohe_dimensionTable values('state_code','b');
insert into ohe_dimensionTable values('state_code','c');
insert into ohe_dimensionTable values('acct_type','Del');
insert into ohe_dimensionTable values('acct_type','Hyd');