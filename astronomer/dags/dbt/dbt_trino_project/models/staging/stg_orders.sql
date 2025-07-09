{{ config(materialized='view', tags=['staging']) }}

with source as (
    select * from {{ source('tpch', 'orders') }}
),
final as (
    select
        orderkey,
        custkey,
        orderstatus,
        totalprice,
        cast(orderdate as date) as order_date,
        orderpriority,
        clerk,
        shippriority,
        comment
    from source
)
select * from final