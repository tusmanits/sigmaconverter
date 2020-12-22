#{%- set view_names = get_view_names() -%}

#{{log(view_names, info=True)}}


{%- set fields = get_fields('distribution_centers') -%}
