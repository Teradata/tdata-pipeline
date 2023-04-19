{% macro getColumns(dbname, table_name) %}
    {% set query %}    
    SELECT columnname FROM dbc.columns WHERE databasename = {{dbname}} AND tablename = {{table_name}};
    {% endset %}
        {{ log(query, true) }}
    {% set queryresult = run_query(query) %}
    {% if execute %}
    {% set queryresult = queryresult.columns[0].values() %}
    {% else %}
    {% set queryresult = [] %}
    {% endif %}
    {{ return (queryresult) }}
{% endmacro %}