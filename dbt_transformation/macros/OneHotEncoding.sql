{% macro Onehotencoding_Fit(db,id, inputtable) %}
        {% set hyperparameters_table = "Hyperparameters" %}
        {% set hyperparameters = getHyperparameters(db,hyperparameters_table, id) %}
        {%- if not inputtable|length  == 0 -%}  {% set _= hyperparameters.update({'inputtable' : inputtable}) %}{%- endif -%}
                
        SELECT * from TD_OneHotEncodingFit(
            {{do }}
            
            {%- if not hyperparameters['inputtable_type']  == "Q" -%} 
         
            {% set inputtable_type = isTableKind_T_Q(hyperparameters['db'],hyperparameters['inputtable']) %}
            {%- if inputtable_type == "T" -%} 
            ON {{hyperparameters['db']}}.{{hyperparameters['inputtable']}} AS InputTable
            {% else %} 
            ON {{hyperparameters['inputtable']}} AS InputTable
            {%- endif -%}
            {% else %}
            ON ({{hyperparameters['inputtable']}}) AS InputTable
            {%- endif -%}{{do }}{%- if not hyperparameters['fit_partition']|length == 0 -%} {{do }}PARTITION BY {{hyperparameters['fit_partition']}} {%- endif -%}
                        {{do }}
            {%- if not hyperparameters['dimensiontable']|length == 0 -%}
            {%- if not hyperparameters['dimensiontable_type']  == "Q" -%} 
            {% set dimensiontable_type = isTableKind_T_Q(hyperparameters['db'],hyperparameters['dimensiontable']) %}
            {{do }}
            {%- if dimensiontable_type == "T" -%} 
            ON {{hyperparameters['db']}}.{{hyperparameters['dimensiontable']}} AS CategoryTable Dimension
            {% else %} 
            ON {{hyperparameters['dimensiontable']}} AS CategoryTable Dimension
            {%- endif -%}
            {% else %}
            ON ({{hyperparameters['dimensiontable']}}) AS CategoryTable Dimension
            {%- endif -%}{%- endif -%}
            {{do }}
            USING
            IsInputDense({{hyperparameters['IsInputDense']}})
        {%- if hyperparameters['IsInputDense'] == "'true'" -%}
            TargetColumn({{hyperparameters['TargetColumn']}})
            Approach({{hyperparameters['Approach']}})
        {%- if not hyperparameters['Approach'] == "'Auto'"  -%}
        {% set targcols = hyperparameters['TargetColumn'].split(',') %}
        {% set targcolcount = targcols | length %}
        {%- if targcolcount == 1 -%} 
            CategoricalValues({{hyperparameters['CategoricalValues']}})
        {% else %}
            TargetColumnNames ({{hyperparameters['TargetColumnNames']}})
            CategoriesColumn ({{hyperparameters['CategoriesColumn']}})
        {%- endif -%}{%- endif -%}
        {%- if not hyperparameters['OtherColumnName'] == "" -%}
            OtherColumnName({{hyperparameters['OtherColumnName']}})
        {%- endif -%}
            CategoryCounts({{hyperparameters['CategoryCounts']}})
        {% else %}
            TargetAttributes({{hyperparameters['TargetAttributes']}})
        {%- if not hyperparameters['OtherAttributesNames'] == "''" -%}
            OtherAttributesNames({{hyperparameters['OtherAttributesNames']}})
        {%- endif -%}
            AttributeColumn({{hyperparameters['AttributeColumn']}})
            ValueColumn({{hyperparameters['ValueColumn']}})
        {%- endif -%}
 ) as dt
 {% endmacro %}







 {% macro Onehotencoding_Transform(db, id, inputtable, inputtable_type, partition_inputtable, fittable, fittable_type,partition_fittable,isDimension) %}
{% set hyperparameters_table = "Hyperparameters" %}
{%- if not id|length == 0 -%} 
{% set hyperparameters = getHyperparameters(db,hyperparameters_table, id) %}
{% else %}
{% set hyperparameters = {'db':db, 'inputtable':inputtable, 'inputtable_type':inputtable_type,'partition_inputtable':partition_inputtable,'fittable':fittable,'fittable_type':fittable_type,'partition_fittable':partition_fittable,'isDimension':isDimension } %}
{%- endif -%}
{%- if not inputtable|length  == 0 -%}  {% set _= hyperparameters.update({'inputtable' : inputtable}) %}{%- endif -%}
{%- if not fittable|length  == 0 -%}  {% set _= hyperparameters.update({'fittable' : fittable}) %}{%- endif -%}
{%- if not inputtable|length  == 0 -%}  {% set _= hyperparameters.update({'inputtable' : inputtable}) %}{%- endif -%}
SELECT * from TD_OneHotEncodingTransform(
{{do }}
{%- if not hyperparameters['inputtable_type']  == "Q" -%} 
{% set inputtable_type = isTableKind_T_Q(hyperparameters['db'],hyperparameters['inputtable']) %}
{%- if inputtable_type == "T" -%} 
ON {{hyperparameters['db']}}.{{hyperparameters['inputtable']}} AS InputTable
{% else %} 
ON {{hyperparameters['inputtable']}} AS InputTable
{%- endif -%}
{% else %}
   
ON ({{hyperparameters['inputtable']}}) AS InputTable

{%- endif -%}
{{do }}{%- if not hyperparameters['partition_inputtable']|length == 0 -%} PARTITION BY {{hyperparameters['partition_inputtable']}}{%- endif -%}
{%- if not hyperparameters['fittable_type'] == "Q" -%} 
{% set fittable_type = isTableKind_T_Q(hyperparameters['db'],hyperparameters['fittable']) %}
{%- if fittable_type == "T" -%} 
ON {{hyperparameters['db']}}.{{hyperparameters['fittable']}} AS FitTable 
{% else %} 
ON {{hyperparameters['fittable']}} AS FitTable 
{%- endif -%}
{% else %}
ON ({{hyperparameters['fittable']}}) AS FitTable 
{%- endif -%}
 {%- if hyperparameters['IsDimension'] == "'true'" -%}{{do }} DIMENSION {% else %} {%- if not hyperparameters['partition_fittable']|length == 0 -%} PARTITION BY {{hyperparameters['partition_fittable']}}{%- endif -%}{%- endif -%}
{{do }}
USING
IsInputDense({{hyperparameters['IsInputDense']}})
) as dt


{% endmacro %}