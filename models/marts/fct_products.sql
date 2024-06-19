
with products as (
    select  product_id,
            product_name,
            product_type,
            price,
            description 
    from {{ ref('stg_jaffle_shop__products') }}
)
,supplies as (
    
    select *
    from {{ ref('stg_jaffle_shop__supplies')}}

),
products_sold as (
    select products.*,
            min(ordered_at) as first_buy,
            max(ordered_at) as recient_buy,
            count(1) as total_buys,
            sum(tax_paid) as total_tax_paid_for_products,
            sum(order_total) as total_paid_for_products,
            count(distinct customer_id) as n_customer_buys,
            sum(supplies.cost) as supply_cost,
            sum(case when products.product_type='jaffle' then 1 else 0 end) as count_food_items,
            sum(case when products.product_type='beverage' then 1 else 0 end) as count_drink_items
    from products
        inner join (select product_id,order_id from {{ ref('stg_jaffle_shop__items') }}) items on products.product_id=items.product_id
        inner join (select *
                    from {{ ref('stg_jaffle_shop__orders') }}
                    ) orders on orders.order_id=items.order_id 
        inner join supplies on products.product_id=supplies.product_id
    group by 1,2,3,4,5
    )

select * from products_sold