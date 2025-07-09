{{ config(materialized='view', tags=['staging']) }}

select * from {{ source('tpch', 'nation') }}