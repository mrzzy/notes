# SQL
Notes on SQL compiled from [Mode tutorial on SQL](https://mode.com/sql-tutorial/introduction-to-sql)


## SQL Basics
Comments:

```sql
-- single line comment
/*
multiline comment
*/
```

### SELECT 
`SELECT` queries data `FROM` a table

```sql
SELECT <columns ...> FROM <table>
````

- `AS` allows the renaming of columns queried:

```sql
SELECT a_very_long_and_tedious_to_type_age_column AS age
FROM person
```

- `LIMIT` allows us to limit the number of rows returned.

- `ORDER BY <column,...>` allows us to sort values. Append `ASC`/`DESC` to sort by ascending or descending order.

- `DISTINCT` selects unique rows only.

- math can be done in SQL statements:
```sql
SELECT 
  x1,y1,x2,y2, 
  ABS(y1 - y2) * ABS(x1 - y2) AS area
FROM coordinates
```

#### WHERE
`WHERE` allows us to apply a filter to the results returned

```sql
-- Query all persons older than 30.
SELECT * FROM person
WHERE age > 30
```

SQL operators:

| Operator |  Description |
| --- | --- |
| `=` | Equality check |
| `<>` or `!=` | Not Equal check |
| `>`/`>=` | Greater/Greater or Equal check |
| `<`/`<=` | Less than/Less than or Equal check |
| `LIKE` | Match value by pattern using `%` as wildcard for one or more chars,`_` for single char. |
| `BETWEEN a AND b` | Value between `a` and `b` |
| `IN` | Check membership of value in a set of values. |
| `AND`/`OR`/`NOT` | Boolean operators. |
| `IS NULL`/`IS NOT NULL` | Check if value is/is not NULL. (`= NULL` does not work in SQL for some reason.) |

> Use `()` to guide operator precedence

## SQL Intermediate
### Aggregation 
Aggregation compute a single value from a set of values using a aggreation function (ie `MAX()`:

```SQL
-- Get the latest timestamp where james was recorded in the entry_log
SELECT MAX(timestamp)
FROM entry_log
WHERE name = "james"
```

Aggregation functions SQL:

| Aggregation Func | Description |
| --- | --- |
| `COUNT()` | Count the number of values is the set. |
| `COUNT(DISTINCT)` | Count the number of **unique** values is the set. |
| `MAX()`/`MIN()` | Find the max or min value in the set. |
| `AVG()` | Find the mean/average value in set. |
| `SUM()` | Find the sum of all values in set. |


### GROUP BY
`GROUP BY <column,...>` groups rows with the same value for the given column together.
This allows aggreations to be performed on each group.

```sql
-- Get the average debt owned by age
SELECT age, AVG(debt)
FROM ledger
GROUP BY age
```

> `ORDER BY` and `LIMIT` happens after `GROUP BY` when used together.

#### HAVING
`WHERE` but for aggregated columns

```sql
-- Find ages where average debt is higher than 40k
SELECT age, AVG(debt)
FROM ledger
GROUP BY age
HAVING AVG(debt) > 40000
```

### CASE
Case is SQL's conditionals:

```sql
-- Find and count no. suspicious entries between 11pm and 4am for each name
SELECT 
    name,
    COUNT(
        CASE 
            WHEN hour BETWEEN 23 AND 4 THEN true
            ELSE false
        END
    )
GROUP BY name
FROM entry_log
```

### JOIN
`JOIN` allows the combination of columns of 2 tables based on some condition.

```sql
-- Find entry logs of people have debt higher than 40k
SELECT *
FROM entry_log
INNER JOIN ledger
ON ledger.name = entry_log.name -- AND can be used for additional conditions
WHERE ledger.debt > 40000
```

Types of joins:
- `INNER JOIN` only returns rows that have matches in both tables.
- `LEFT JOIN` returns all rows on left table, only matches on the right table.
- `RIGHT JOIN` returns all rows on right table, only matches on the left table.
- `FULL OUTER JOIN` returns all rows on both right and left tables.

### Subqueries
Subqueries are nested SQL queries in another SQL query:
- Subqueries run before the parent SQL nestee SQL query

Used with `WHERE`:

```sql
-- Find entry logs of people have debt higher than 40k
SELECT *
FROM entry_log
WHERE name IN (
    SELECT name FROM ledger
    WHERE debt > 40000
)
```

### UNION
`UNION` allows the append of rows of 1 table to another table, returning only distinct rows.
    - `UNION ALL` returns all rows of the append, duplicates and all.

```
SELECT *
FROM ledger_part1

UNION ALL

SELECT *
FROM ledger_part2
```

