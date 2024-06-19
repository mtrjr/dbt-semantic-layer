with customer as (
    select customer_id,
        split(customer_name,' ')[0]::text first_name  ,
        split(customer_name,' ')[1]::text last_name_1 ,
        split(customer_name,' ')[2]::text last_name_2
    from {{ ref('stg_jaffle_shop__customers') }}
), customer_order as (
    select  customer.customer_id,
            customer.first_name,
            customer.last_name_1,
            customer.last_name_2,
            min(ordered_at) as first_buy,
            max(ordered_at) as recient_buy,
            count(1) as total_buys,
            sum(tax_paid) as total_tax_paid_for_products,
            sum(order_total) as total_paid_for_products,
            sum(case when IS_FOOD_ORDER then 1 else 0 end) has_order_any_food,
            sum(case when IS_DRINK_ORDER then 1 else 0 end) has_order_any_drink
    from customer
        inner join {{ ref('fct_orders') }} orders
        on customer.customer_id = orders.customer_id 
    group by customer.customer_id,
            customer.first_name,
            customer.last_name_1,
            customer.last_name_2
)

select customer_id,
first_name,
last_name_1,
last_name_2,
first_buy,
recient_buy,
total_buys,
total_tax_paid_for_products,
total_paid_for_products,
case when has_order_any_food>0 then true else false end has_order_any_food,
case when has_order_any_drink>0 then true else false end has_order_any_drink
from customer_order