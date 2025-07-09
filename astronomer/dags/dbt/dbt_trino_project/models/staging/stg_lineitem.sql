{{ config(materialized='view', tags=['staging']) }}

with source as (
    select * from {{ source('tpch', 'lineitem') }}
),
final as (
    select
        orderkey,
        partkey,
        suppkey,
        linenumber,
        quantity,
        extendedprice,
        discount,
        tax,
        extendedprice * (1 - discount) as gross_revenue,
        returnflag,
        linestatus,
        shipdate,
        commitdate,
        receiptdate,
        shipinstruct,
        shipmode,
        comment
    from source
)
select * from final