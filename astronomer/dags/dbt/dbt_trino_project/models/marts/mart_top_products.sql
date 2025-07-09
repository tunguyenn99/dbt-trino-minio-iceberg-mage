{{ config(materialized='view', tags=['marts']) }}

with profit as (
    select * from {{ ref('int_product_profitability') }}
),
part as (
    select * from {{ ref('stg_part') }}
),
final as (
    select
        p.partkey,
        p.name as part_name,
        sum(profit.revenue) as total_revenue,
        sum(profit.profit) as total_profit
    from profit
    join part p on profit.partkey = p.partkey
    group by p.partkey, p.name
)
select * from final
