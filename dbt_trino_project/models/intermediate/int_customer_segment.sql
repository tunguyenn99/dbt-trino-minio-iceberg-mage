{{ config(materialized='view', tags=['staging']) }}

with customer as (
    select * from {{ ref('stg_customer') }}
),
orders as (
    select * from {{ ref('stg_orders') }}
),
final as (
    select
        c.mktsegment,
        count(distinct c.custkey) as customer_count,
        count(distinct o.orderkey) as total_orders,
        sum(o.totalprice) as total_revenue
    from customer c
    left join orders o on c.custkey = o.custkey
    group by c.mktsegment
)
select * from final