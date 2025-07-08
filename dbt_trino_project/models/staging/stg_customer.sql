{{ config(materialized='view', tags=['staging']) }}

with source as (
    select * from {{ source('tpch', 'customer') }}
),
nation as (
    select * from {{ source('tpch', 'nation') }}
),
region as (
    select * from {{ source('tpch', 'region') }}
),
final as (
    select 
        c.custkey,
        c.name as customer_name,
        c.address,
        c.nationkey,
        n.name as nation_name,
        r.name as region_name,
        c.phone,
        c.acctbal,
        c.mktsegment,
        c.comment
    from source c
    left join nation n on c.nationkey = n.nationkey
    left join region r on n.regionkey = r.regionkey
)
select * from final