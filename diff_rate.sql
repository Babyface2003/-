
DROP VIEW IF EXISTS rate CASCADE;
DROP TABLE IF EXISTS traffic CASCADE;
DROP TABLE IF EXISTS credit CASCADE;



CREATE TABLE if not exists traffic(
	flowers_id BIGINT,
	tariff_type VARCHAR(255),
	tariff VARCHAR(255),
	start_date varchar(10),
	interval_probability_of_default VARCHAR(255),
	interval_initial_payment VARCHAR(255),
	rate NUMERIC(10,2),
	foreign key  (flowers_id) references flowers(id)
);


CREATE TABLE if not exists flowers(
id serial primary key ,
tariff_type VARCHAR(255)
);


CREATE TABLE if not exists credit(
	flowers_id BIGINT,
	deal_id BIGINT,
	interval_initial_payment VARCHAR(255),
	tariff_type VARCHAR(255),
	tariff VARCHAR(255),
	interval_probability_of_default VARCHAR(255),
	credit_date  varchar(10),
	rate_fact NUMERIC(10,2),
	foreign key  (flowers_id) references flowers(id)
);
  
COPY traffic
FROM 'D:\datebase\traffic.csv'
DELIMITER ';'
CSV
HEADER;

COPY credit
FROM 'D:\datebase\credit.csv'
DELIMITER ';'
CSV
HEADER;


insert into flowers (tariff_type)
values ('Ромашка'),('Лютик');

UPDATE credit
SET flowers_id = 
    CASE 
        WHEN tariff_type = 'Ромашка' THEN 1
        WHEN tariff_type = 'Лютик' THEN 2
        ELSE NULL 
    END;

UPDATE traffic
SET flowers_id = 
    CASE 
        WHEN tariff_type = 'Ромашка' THEN 1
        WHEN tariff_type = 'Лютик' THEN 2
        ELSE NULL 
    END;



(select flowers_id,
	credit.tariff_type,
	credit.tariff,
	credit.interval_probability_of_default,
	credit.interval_initial_payment,
   credit.rate_fact as rate_diff
FROM flowers
INNER JOIN credit on credit.flowers_id = flowers.id)
EXCEPT
(select flowers_id,
	traffic.tariff_type,
	traffic.tariff,
	traffic.interval_probability_of_default,
	traffic.interval_initial_payment,
   traffic.rate as rate_diff
FROM flowers
INNER JOIN traffic on flowers.id = traffic.flowers_id);



/*SELECT credit.deal_id,
    credit.rate_fact,
    traffic.rate,
    ABS(credit.rate_fact - traffic.rate) as rate_difference
FROM credit
INNER JOIN traffic ON traffic.tariff_type = credit.tariff_type
WHERE credit.rate_fact != traffic.rate
    AND credit.credit_date = traffic.start_date
  AND MAX(credit.credit_date)*/
