{% macro get_view_fields(view_name) %}

{% set get_fields_query %}
select 
    UPPER(REPLACE(UPPER(name), '{{view_name}}.', '')) AS NAME, 
    UPPER(
    CASE 
        WHEN TYPE = 'number' THEN 'NUMBER(38,10)'
        WHEN TYPE = 'string' THEN 'VARCHAR'
        WHEN TYPE LIKE '%date%' THEN 'DATETIME'
    END)
    AS TYPE
from public.fields
where UPPER(view) = '{{view_name}}'
{% endset %}

{% set results = dbt_utils.get_query_results_as_dict(get_fields_query) %}

{% set columns_list = [] %}

{% for NAME in results.NAME %}


{% set v = results.NAME[loop.index0] ~ ' ' ~ results.TYPE[loop.index0] %}


{{ columns_list.append(v) }}


{% endfor %}

{% set columns_def = columns_list | join (',') %}


{{log(columns_def, info = True)}}

{{ log(results, info=True) }}


{{ return (columns_def) }}

{% endmacro %}
