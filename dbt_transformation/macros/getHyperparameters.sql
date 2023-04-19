{% macro getHyperparameters(dbname,table_name, set_id) %}
{% set query %}
            SELECT json_hyperparameters from {{dbname}}.Hyperparameters where id = {{set_id}};;
    {% endset %}
    {% set queryresult = run_query(query) %}
    {% if execute %}
    {% set queryresult = fromjson(queryresult.columns[0].values()[0]) %}
    {% else %}
    {% set queryresult = {} %}
    {% endif %}
    {{ return (queryresult) }}
{% endmacro %}