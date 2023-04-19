{% macro getValues(dbname, table_name, column_name) %}
    {% set query %}
            SELECT distinct {{column_name}} from {{dbname}}.{{table_name}};
    {% endset %}
        {{ log(query, true) }}

    {% set queryresult = run_query(query) %}
    {% if execute %}
    {% set queryresult = queryresult.columns[0].values() %}
     {{ log(queryresult, true) }}
    {% else %}
    {% set queryresult = [] %}
    {% endif %}
    {{ return (queryresult) }}
{% endmacro %}