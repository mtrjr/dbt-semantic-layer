with 

orders as (
    
    select * from {{ ref('stg_jaffle_shop__orders')}}

),

products as (
    
    select * from {{ ref('fct_products')}}

),
items as (
    
    select * from {{ ref('stg_jaffle_shop__items')}}

),

order_products_summary as (

    select
        items.order_id,
        products.order_cost,
        products.count_food_items,
        products.count_drink_items
    from products
        inner join items on products.product_id=items.product_id
    group by 1,2,3,4

),


compute_booleans as (
    select

        orders.*,
        count_food_items > 0 as is_food_order,
        count_drink_items > 0 as is_drink_order,
        order_cost

    from orders
    
    left join order_products_summary on orders.order_id = order_products_summary.order_id
)

select * from compute_booleans