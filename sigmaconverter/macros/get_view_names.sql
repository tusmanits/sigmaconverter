{% macro get_view_names() %}

{% set get_views_query %}
select distinct
view
from public.fields
where view = 'distribution_centers'
{% endset %}

{% set results = run_query(get_views_query) %}

{{ log(results, info=True) }}


{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

{{log(results_list, info=True)}}

{{ return(results_list) }}

{% endmacro %}
