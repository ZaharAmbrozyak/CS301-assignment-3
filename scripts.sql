create or replace function calculate_order(order_id int)
returns numeric as $$
declare
    total numeric(10,2);
begin
    select coalesce(sum(quantity * price), 0) into total
    from order_items
    where order_id = order_id;
    
    return total;
end;
$$ language plpgsql;

