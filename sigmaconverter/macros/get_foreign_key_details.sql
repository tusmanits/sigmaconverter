{% macro get_foreign_key_ddl(view_name) %}

{% set get_foreign_key_query %}

WITH FOREIGN_KEY_JOIN_DATA AS 
(
    SELECT
      UPPER(SPLIT_PART(FOREIGN_KEY, '.', 1)) AS TARGET_TABLE_NAME,
      UPPER(SPLIT_PART(FOREIGN_KEY, '.', 2)) AS TARGET_TABLE_KEY,
      UPPER(NAME) AS SOURCE_TABLE_NAME,
      NULL AS SOURCE_TABLE_KEY,
      TRUE AS FOREIGN_KEY_JOIN_FLAG
    FROM PUBLIC.JOINS
    WHERE NULLIF(FOREIGN_KEY, 'None') IS NOT NULL
), SQL_ON_JOIN_DATA_RAW AS (
  SELECT NAME, DEPENDENT_FIELDS, RELATIONSHIP, SQL_ON, FOREIGN_KEY FROM PUBLIC.JOINS
  WHERE NULLIF(FOREIGN_KEY, 'None') IS NULL AND NULLIF(NULLIF(SQL_ON, ''), 'None') IS NOT NULL
),
SQL_ON_JOIN_DATA AS (
  SELECT
      (
        CASE 
            WHEN LOWER(RELATIONSHIP) = 'many_to_one' 
            THEN (
              CASE 
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1))
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1))
              END)
            WHEN LOWER(RELATIONSHIP) = 'one_to_many' THEN UPPER(NAME)
            WHEN LOWER(RELATIONSHIP) = 'one_to_one' 
            THEN (
              CASE 
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1))
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1))
              END)
        END
      ) AS TARGET_TABLE_NAME,
      (
        CASE 
            WHEN LOWER(RELATIONSHIP) = 'many_to_one' 
            THEN (
              CASE 
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 2))
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 2))
              END)
            WHEN LOWER(RELATIONSHIP) = 'one_to_many' 
            THEN (
              CASE 
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1)) = UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 2))
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1)) = UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 2))
              END)
            WHEN LOWER(RELATIONSHIP) = 'one_to_one' 
            THEN (
              CASE 
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 2))
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 2))
              END)
        END
      ) AS TARGET_TABLE_KEY,
      (
        CASE 
            WHEN LOWER(RELATIONSHIP) = 'many_to_one' THEN UPPER(NAME)
            WHEN LOWER(RELATIONSHIP) = 'one_to_many' 
            THEN (
              CASE 
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1))
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1))
              END)
            WHEN LOWER(RELATIONSHIP) = 'one_to_one' THEN UPPER(NAME)
        END
      ) AS SOURCE_TABLE_NAME,
      (
        CASE 
            WHEN LOWER(RELATIONSHIP) = 'many_to_one' 
            THEN (
              CASE 
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1)) = UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 2))
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1)) = UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 2))
              END)
            WHEN LOWER(RELATIONSHIP) = 'one_to_many' 
            THEN (
              CASE 
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 2))
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1)) <> UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 2))
              END)
            WHEN LOWER(RELATIONSHIP) = 'one_to_one' 
            THEN (
              CASE 
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 1)) = UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 1)), '.', 2))
                WHEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 1)) = UPPER(NAME) THEN UPPER(SPLIT_PART(UPPER(SPLIT_PART(DEPENDENT_FIELDS, ',', 2)), '.', 2))
              END)
        END
      ) AS SOURCE_TABLE_KEY,
      FALSE AS FOREIGN_KEY_JOIN_FLAG 
    FROM SQL_ON_JOIN_DATA_RAW
)
SELECT
      TARGET_TABLE_NAME,
      TARGET_TABLE_KEY,
      SOURCE_TABLE_NAME,
      SOURCE_TABLE_KEY,
      FOREIGN_KEY_JOIN_FLAG
FROM FOREIGN_KEY_JOIN_DATA
UNION
SELECT
      TARGET_TABLE_NAME,
      TARGET_TABLE_KEY,
      SOURCE_TABLE_NAME,
      SOURCE_TABLE_KEY,
      FOREIGN_KEY_JOIN_FLAG
FROM SQL_ON_JOIN_DATA
WHERE UPPER(TARGET_TABLE_NAME) = UPPER('{{view_name}}')

{% endset %}

{% set results = dbt_utils.get_query_results_as_dict(get_foreign_key_query) %}

{{log(results, info = True)}}

{% set columns_list = [] %}

{% for NAME in results.TARGET_TABLE_NAME %}

{%- set target_table_name = results.TARGET_TABLE_NAME[loop.index0] -%}
{%- set target_table_key = results.TARGET_TABLE_KEY[loop.index0] -%}
{%- set source_table_name = results.SOURCE_TABLE_NAME[loop.index0] -%}
{%- set source_table_key = results.SOURCE_TABLE_KEY[loop.index0] -%}
{%- set foreign_key_join_flag = results.FOREIGN_KEY_JOIN_FLAG[loop.index0] -%}


{%- if foreign_key_join_flag -%}
    {%- set source_table_key = get_primary_key(source_table_name) -%}
{%- endif -%}


{%- set foreign_key_ddl -%}
ALTER TABLE {{ target_table_name }} ADD FOREIGN KEY({{ target_table_key }}) REFERENCES {{ source_table_name }} ({{ source_table_key }}) NOT ENFORCED
{%- endset -%}


{{ columns_list.append(foreign_key_ddl) }}


{% endfor %}

{% set columns_def = columns_list | join (';') %}


{{log(columns_def, info = True)}}


{{ return (columns_def) }}

{% endmacro %}
