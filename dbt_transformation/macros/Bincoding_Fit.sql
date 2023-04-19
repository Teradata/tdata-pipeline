{% macro Bincoding_Fit(set_id) %}
        {% set hyperparameters_table = "Hyperparameters" %}
        {% set hyperparameters = getHyperparameters(hyperparameters_table, set_id) %}
        {% set inputtable_type = isTableKind_T_Q(hyperparameters['db'],hyperparameters['inputtable']) %}
        
      {% set query %}          
        SELECT * FROM TD_BincodeFit(
            {{do }}
            {%- if inputtable_type == "T" -%} 
            ON {{hyperparameters['db']}}.{{hyperparameters['inputtable']}} as INPUTTABLE
            {% elif inputtable_type == "A" %} 
            ON {{hyperparameters['inputtable']}} AS InputTable
            {% else %}
            ON ({{hyperparameters['inputtable']}}) as INPUTTABLE
            {%- endif -%}
        {%- if hyperparameters['MethodType'] == "'equal-width'" -%}
            {%- if not hyperparameters['output_table'] == "''" -%}{{do }}
            OUT {{hyperparameters['output_table_type']}} TABLE OutputTable ({{hyperparameters['output_table']}}){%- endif -%}
            {{do }}
            USING
            TargetColumns({{hyperparameters['TargetColumns']}})
            MethodType({{hyperparameters['MethodType']}})
            NBins({{hyperparameters['NBins']|int}})
            {%- if not hyperparameters['output_table'] == "''" -%} 
            LabelPrefix ({{hyperparameters['LabelPrefix']}}){%- endif -%}

        {% else %}
            {% set dimension_table_type = isTableKind_T_Q(hyperparameters['db'], hyperparameters['dimensiontable'] ) %}
            {%- if dimension_table_type == "T" -%} 
            ON {{hyperparameters['db']}}.{{hyperparameters['dimensiontable']}} AS FITINPUT Dimension
            {% elif dimension_table_type == "A" %} 
            ON {{hyperparameters['dimensiontable']}} AS FITINPUT Dimension
            {% else %}
            ON ({{hyperparameters['dimensiontable']}}) AS FITINPUT Dimension
            {%- endif -%}
            {{do }}
            USING 
            TargetColumns({{hyperparameters['TargetColumns']}})
            MethodType({{hyperparameters['MethodType']}})
            MinValueColumn({{hyperparameters['MinValueColumn']}})
            MaxValueCOlumn({{hyperparameters['MaxValueCOlumn']}})
            LabelColumn({{hyperparameters['LabelColumn']}})
            TargetColNames({{hyperparameters['TargetColNames']}})
        {%- endif -%}
) AS dt
    {% endset %}
    {{ return (query) }}
{% endmacro %}