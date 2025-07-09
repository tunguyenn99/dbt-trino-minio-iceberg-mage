{{ config(materialized='view', tags=['staging']) }}

with lineitems as (
    select * from {{ ref('stg_lineitem') }}
),
partsupp as (
    select * from {{ ref('stg_partsupp') }}
),
final as (
    select
        l.partkey,
        l.suppkey,
        sum(l.extendedprice * (1 - l.discount)) as revenue,
        sum(l.quantity * ps.supplycost) as cost,
        sum(l.extendedprice * (1 - l.discount)) - sum(l.quantity * ps.supplycost) as profit
    from lineitems l
    left join partsupp ps on l.partkey = ps.partkey and l.suppkey = ps.suppkey
    group by l.partkey, l.suppkey
)
select * from final