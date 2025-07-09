{{ config(materialized='view', tags=['staging']) }}

with orders as (
    select * from {{ ref('stg_orders') }}
),
lineitems as (
    select * from {{ ref('stg_lineitem') }}
),
final as (
    select
        o.orderkey,
        o.custkey,
        o.order_date,
        o.orderpriority,
        sum(l.gross_revenue) as order_revenue,
        count(*) as item_count
    from orders o
    join lineitems l on o.orderkey = l.orderkey
    group by o.orderkey, o.custkey, o.order_date, o.orderpriority
)
select * from final