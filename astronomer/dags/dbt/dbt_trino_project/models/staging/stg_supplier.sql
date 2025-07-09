{{ config(materialized='view', tags=['staging']) }}

with source as (
    select * from {{ source('tpch', 'supplier') }}
),
nation as (
    select * from {{ source('tpch', 'nation') }}
),
region as (
    select * from {{ source('tpch', 'region') }}
),
final as (
    select 
        s.suppkey,
        s.name as supplier_name,
        s.address,
        s.nationkey,
        n.name as nation_name,
        r.name as region_name,
        s.phone,
        s.acctbal,
        s.comment
    from source s
    left join nation n on s.nationkey = n.nationkey
    left join region r on n.regionkey = r.regionkey
)
select * from final