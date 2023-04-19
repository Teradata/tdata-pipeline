{% macro Bincoding_Transform(db, set_id, inputtable, inputtable_query, fit_output_table, fit_output_query, output_columns) %}
{% set hyperparameters_table = "Hyperparameters" %}
{%- if not hyperparameters_table|length == 0 -%} 
{% set hyperparameters = getHyperparameters(hyperparameters_table, set_id) %}
{% else %}
{% set hyperparameters = {'db':db, 'inputtable':inputtable, 'inputtable_query':inputtable_query,'fit_output_table':fit_output_table,'fit_output_query':fit_output_query,'output_columns':output_columns} %}

{%- endif -%}

SELECT * FROM TD_BincodeTransform (
{%- if hyperparameters_table['inputtable_query']|length  == 0 -%} 
{% set inputtable_type = isTableKind_T_Q(hyperparameters['db'],hyperparameters['inputtable']) %}

{%- if inputtable_type == "T" -%} 
ON {{hyperparameters['db']}}.{{hyperparameters['inputtable']}} AS InputTable
{% else %} 
ON {{hyperparameters['inputtable']}} AS InputTable
{%- endif -%}
{% else %}
ON ({{hyperparameters['inputtable_query']}}) AS InputTable
{%- endif -%}

{%- if hyperparameters_table['fit_output_query']|length == 0 -%} 
{% set fittable_type = isTableKind_T_Q(hyperparameters['db'],hyperparameters['fit_output_table']) %}
{%- if fittable_type == "T" -%} 
ON {{hyperparameters['db']}}.{{hyperparameters['fit_output_table']}} AS FitTable Dimension
{% else %} 
ON {{hyperparameters['fit_output_table']}} AS FitTable Dimension
{%- endif -%}
{% else %}
ON ({{hyperparameters_table['fit_output_query']}}) AS FitTable Dimension
{%- endif -%}
{{do }}
USING
Accumulate ({% for __ in output_columns %}'{{__}}'{%- if not loop.last -%}, {%- endif -%}{% endfor %})
) AS dt

{% endmacro %}