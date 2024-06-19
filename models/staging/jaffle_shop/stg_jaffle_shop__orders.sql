with 

source as (

    select * from {{ source('jaffle_shop', 'orders') }}

),

renamed as (

    select
        id as order_id,
        customer as customer_id,
        ordered_at,
        store_id,
        subtotal,
        {{cents_to_dollars(column_name='tax_paid' ,precision=4)}} as tax_paid,
        {{cents_to_dollars(column_name='order_total',precision=4)}} as order_total 
    from source

)

select * from renamed
