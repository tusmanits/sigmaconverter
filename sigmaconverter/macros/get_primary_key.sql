{% macro get_primary_key(view_name) %}

{% set get_primary_key_query %}
SELECT 
    UPPER(REPLACE(UPPER(name), '{{view_name}}.', '')) AS NAME
FROM PUBLIC.FIELDS
WHERE PRIMARY_KEY = 'True' AND UPPER(view) = '{{view_name}}'
{% endset %}

{% set results = dbt_utils.get_query_results_as_dict(get_primary_key_query) %}

{% set columns_list = [] %}

{% for NAME in results.NAME %}


{% set v = results.NAME[loop.index0]%}


{{ columns_list.append(v) }}


{% endfor %}

{% set columns_def = columns_list | first %}


{{log(columns_def, info = True)}}

{{ log(results, info=True) }}


{{ return (columns_def) }}

{% endmacro %}
