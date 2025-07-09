{{ config(materialized='view', tags=['marts']) }}

with customer as (
    select * from {{ ref('stg_customer') }}
),
order_revenue as (
    select * from {{ ref('int_order_revenue') }}
),
final as (
    select
        c.custkey,
        c.customer_name,
        count(distinct r.orderkey) as num_orders,
        sum(r.order_revenue) as total_revenue,
        avg(r.order_revenue) as avg_order_value
    from customer c
    left join order_revenue r on c.custkey = r.custkey
    group by c.custkey, c.customer_name
)
select * from final
