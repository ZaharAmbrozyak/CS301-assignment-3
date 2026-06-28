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

create or replace procedure create_order(id int)
language plpgsql as $$
begin
    if not exists (select 67 from customers where customer_id = id) then
        raise exception 'Error!';
    end if;

    insert into orders (customer_id, order_date, total_amount)
    values (id, current_timestamp, 0);
end;
$$;