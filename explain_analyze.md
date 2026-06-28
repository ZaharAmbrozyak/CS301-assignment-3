## Запит
```
explain analyze
select
    o.order_id,
    p.product_name,
    o.quantity,
    o.price,
    o.quantity * o.price as item_total
from order_items o
join products p on o.product_id = p.product_id
where o.order_id = 2;
```

## Результат:
```
Hash Join  (cost=27.09..41.32 rows=7 width=274) (actual time=0.076..0.083 rows=3.00 loops=1)
  Hash Cond: (p.product_id = o.product_id)
  Buffers: shared hit=2 dirtied=1
  ->  Seq Scan on products p  (cost=0.00..13.00 rows=300 width=222) (actual time=0.028..0.030 rows=5.00 loops=1)
        Buffers: shared hit=1 dirtied=1
  ->  Hash  (cost=27.00..27.00 rows=7 width=28) (actual time=0.034..0.034 rows=3.00 loops=1)
        Buckets: 1024  Batches: 1  Memory Usage: 9kB
        Buffers: shared hit=1
        ->  Seq Scan on order_items o  (cost=0.00..27.00 rows=7 width=28) (actual time=0.012..0.015 rows=3.00 loops=1)
              Filter: (order_id = 2)
              Rows Removed by Filter: 8
              Buffers: shared hit=1
Planning:
  Buffers: shared hit=9
Planning Time: 0.336 ms
Execution Time: 0.125 ms
```

## Пояснення
БД використовує Hash Join для об'єднання таблиць. Для цього виконується Seq Scan на таблиці продуктів та таблиці order_items. В order_items був виконаний фільтер order_id = 2, тоді прибрали 8 рядків і залишили лише один. 
Бд вирішила використати Seq scan, тому-що для малих обсягів даних він оптимальніший, ніж Index Scan. Запит зайняв 0.125 ms, хоча планувалося 0.336 ms 