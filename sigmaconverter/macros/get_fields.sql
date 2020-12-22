{% macro get_fields(view_name) %}

{% set get_fields_query %}
select name, type
from public.fields
where view = '{{view_name}}'
{% endset %}

{% set results = dbt_utils.get_query_results_as_dict(get_fields_query) %}

{{ log(results, info=True) }}

{% endmacro %}
