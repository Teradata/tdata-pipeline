{% macro getInputSet(table_name, set_id) %}
    {% set query %}
            select * from {{ref(table_name)}} where Set_id = {{set_id}};
    {% endset %}
    {% set queryresult = run_query(query) %}
    {% if execute %}
    {{ return (queryresult.rows[0]) }}
    {%- endif -%}
{% endmacro %}