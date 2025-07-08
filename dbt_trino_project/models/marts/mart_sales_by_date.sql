{{ config(materialized='table', tags=['marts']) }}

with revenue as (
    select 
        orderkey, order_date, order_revenue
    from {{ ref('int_order_revenue') }}
),
final as (
    select
        order_date,
        count(distinct orderkey) as total_orders,
        sum(order_revenue) as total_revenue
    from revenue
    group by order_date
)
select * from final
