with 

source as (

    select * from {{ source('jaffle_shop', 'supplies') }}

),

renamed as (

    select
        id as supply_id,
        name as supply_name,
        cost,
        perishable,
        sku as product_id

    from source

)

select * from renamed
