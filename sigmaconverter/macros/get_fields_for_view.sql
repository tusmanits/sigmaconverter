{% macro get_fields_for_view(view_name) %}

{% set get_fields_query %}
SELECT
    TRIM(UPPER(REPLACE(UPPER(NAME), '{{view_name}}.', ''))) AS COLUMN_NAME, 
    TRIM(UPPER(REPLACE(UPPER(SQL), '${TABLE}.', ''))) AS COLUMN_SQL
FROM PUBLIC.FIELDS
WHERE UPPER(VIEW) = '{{view_name}}' AND UPPER(TYPE) NOT LIKE UPPER('DATE%')
{% endset %}

{% set results = dbt_utils.get_query_results_as_dict(get_fields_query) %}

{{ log(results, info=True) }}

{% set columns_list = [] %}

{% for COLUMN_NAME in results.COLUMN_NAME %}

{% set COL_NAME = results.COLUMN_NAME[loop.index0] %}
{% set COL_SQL = results.COLUMN_SQL[loop.index0] %}

{%- set col -%}
{% if COL_NAME == COL_SQL %}
{{COL_SQL}}
{% else %}
{{COL_SQL}} AS {{COL_NAME}}
{% endif %}
{%- endset-%}

{{ columns_list.append(col) }}

{% endfor %}

{% set columns_def = columns_list | join (',') %}


{{log(columns_def, info = True)}}




{{ return (columns_def) }}

{% endmacro %}
