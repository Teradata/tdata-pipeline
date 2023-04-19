{% macro isTableKind_T_Q(dbname, table_name) %}
    {% set query %}
            SELECT count(*) from dbc.TablesV where TableName='{{table_name}}' and DataBaseName='{{dbname}}';
    {% endset %}
    {% set queryresult = run_query(query) %}
    {% if execute %}
    {%- if queryresult.rows[0][0] > 0 -%}{% set kind = 'T' %}
    {% else %}
        {% set kind = 'A' %}
    {% endif %}
    {% endif %}
    {{ return (kind) }}
{% endmacro %}