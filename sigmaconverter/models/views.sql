{%- set SOURCE_SCHEMA = 'PUBLIC' -%} 

{%- set TARGET_SCHEMA = 'EXPLORE' -%}

{%- set view_names = get_view_names() -%}

{{log("Views: " ~ view_names, info=True)}}

#Loop through all the fields
{%- for VIEW_NAME in view_names -%}


{{ log("Running for : " ~ VIEW_NAME) }}


{%- set TABLE_FIELDS = get_fields( VIEW_NAME ) -%}

{%- set PRIMARY_KEY = get_primary_key( VIEW_NAME ) -%}

{%- set TABLE_DDL -%}

USE SCHEMA {{ TARGET_SCHEMA }};

CREATE OR REPLACE TABLE {{ VIEW_NAME }} 
(
{{ TABLE_FIELDS }}
);

ALTER TABLE {{ VIEW_NAME }} ADD PRIMARY KEY ( {{ PRIMARY_KEY }} );

{%- endset -%}

{{ log(TABLE_DDL, info=True) }}


{%- set result = run_query(TABLE_DDL)-%}

{{ log(result, info=True) }}


{%- endfor -%}


{%- for VIEW_NAME in view_names -%}


{{ log("View: " ~ VIEW_NAME) }}


{%- set FOREIGN_KEY = get_foreign_key_ddl( VIEW_NAME ) -%}


{%- set FOREIGN_KEY_DDL -%}

USE SCHEMA {{ TARGET_SCHEMA }};

{{ FOREIGN_KEY }}


{%- endset -%}

{{ log(FOREIGN_KEY_DDL, info=True) }}


{%- set result = run_query(FOREIGN_KEY_DDL)-%}

{{ log(result, info=True) }}


{%- endfor -%}



{%- for VIEW_NAME in view_names -%}


{{ log("View: " ~ VIEW_NAME) }}


{%- set VIEW_FIELDS = get_fields_for_view( VIEW_NAME ) -%}

{%- set INSERT_INTO_TABLE -%}

USE SCHEMA {{ TARGET_SCHEMA }};

BEGIN;
INSERT INTO {{TARGET_SCHEMA}}.{{VIEW_NAME}}
SELECT

{{ VIEW_FIELDS }}

FROM {{ SOURCE_SCHEMA }}.{{ VIEW_NAME }};
COMMIT;
{%- endset -%}

{{ log(INSERT_INTO_TABLE, info=True) }}


{%- set result = run_query(INSERT_INTO_TABLE)-%}

{{ log(result, info=True) }}


{%- endfor -%}