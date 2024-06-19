with 

source as (

    select * from {{ source('jaffle_shop', 'items') }}

),

renamed as (

    select
        id as item_id,
        order_id,
        sku as product_id

    from source

)

select * from renamed
