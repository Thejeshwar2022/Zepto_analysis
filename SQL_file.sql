
--CREATING THE TABLE 
drop table if exists zepto;

create table zepto(
	 sku_id SERIAL primary key,
	 Category varchar(12),
	 name varchar(150) not null,
	 mrp NUMERIC(5,2), 
	 discountPercent NUMERIC(5,2),
	 availableQuantity INTEGER,
	 discountedSellingPrice NUMERIC(8,2),
	 weightInGms INTEGER,
	 outOfStock BOOLEAN,
	 quantity INTEGER
);

--Alterations according to the errors
    ALTER TABLE zepto
    ALTER COLUMN Category type varchar(120) ; 

	 ALTER TABLE zepto
    ALTER COLUMN mrp type NUMERIC(8,2) ; 

--Data exploration

--count the rows
select 
	count(*) 
from 
	zepto;
--null values
select 
	*
from 
	zepto
where 
	Category is null
	or
    name is null
	or 
	mrp is null
	or 
	discountPercent is null
	or
	availableQuantity is null
	or 
	discountedSellingPrice is null
	or 
	weightInGms is null
	or
	outOfStock is null
	or
	quantity is null;

--different product category
select 
	distinct Category 
from 
	zepto 
group by
	Category;

--products instock or outof stock
select
	outofstock,
	count(sku_id)
from 
	zepto
group by 
	outofstock;

--product names present in multiple times
select 
	name,
	count(sku_id) as "number of SKU's"
from
	zepto
group by 
	name
having 
	count(sku_id) > 1
order by
	count(sku_id) desc;

--Data cleaning

--Product with price = 0

select 
	*
from 
	zepto
where 
	mrp = 0 or discountedsellingprice = 0 ;

-- deleting those rows
delete from zepto 
where mrp = 0 ;

--converting paise to rupees
update zepto
set 
	mrp = mrp/100.0,
	discountedsellingprice = discountedsellingprice/100.0;

--Business insights 
--Q1: Find the top 10 best value products based on the discount product?
SELECT 
	DISTINCT name,
	mrp,
	discountpercent
FROM
	zepto
ORDER BY 
	discountpercent DESC
LIMIT  10;

--Q2: What are the products with high mrp but out of stock?

SELECT 
	DISTINCT name,
	mrp
FROM zepto
WHERE 
	outofstock = TRUE and mrp >300
ORDER BY 
	mrp DESC;
	
--Q3: Calculate the estimated revenue for the each category?

SELECT 
	 category,
	 sum(discountedsellingprice * availablequantity) AS total_revenue
FROM 
	zepto
GROUP BY category
ORDER BY total_revenue;

--Q4: Find all the products where mrp is greater than rs500 and discount is less than 10%?

select 
	distinct name,
	mrp,
	discountpercent
from
	zepto
where
	mrp > 500 AND discountpercent < 10
order by
	mrp desc,
	discountpercent desc;

--Q5: Identify the top 5 categories offering the highest average discount percentage?

select 
	category,
	round(avg(discountpercent),2)AS discount_price	
from 
	zepto
group by 
	category
order by 
	discount_price DESC
limit 5;

--Q6: Find the price per gram for products above 100g and sort by best value?

select
	distinct name,
	weightingms,
	discountedsellingprice,
	round(discountedsellingprice/weightingms,2) AS price_per_gram
from zepto
where weightingms >= 100
order by price_per_gram ;

--Q7: Group the products into categories like low, medium, Bulk?

select 
	distinct name,
	weightingms,
	CASE WHEN weightingms < 1000 then 'low'
	     WHEN weightingms < 5000 then 'medium'
		 ELSE 'bulk'
		 END AS weight_in_grams
from 
	zepto
order by 
	weightingms desc;

--Q8: What is the total inventory weight per category?

select 
	category,
	sum(weightingms * availablequantity) as total_weight
from 
	zepto
group by 
	category
order by 
	total_weight;










