-- Soal 1 
/*Dengan menggunakan data sales, lakukan query yang mengembalikan/menampilkan 
record Product buah yang hanya terjual di bulan 1-10 Januari 2021*/
SELECT 
    DISTINCT(product_name) AS produk_name,
    purchase_date
FROM 
    sales 
WHERE  
    purchase_date BETWEEN '2021-01-01' AND '2021-01-10'
ORDER BY purchase_date


-- Soal 2
/*Dengan menggunakan data sales, lakukan query yang mengembalikan/menampilkan 
record penjualan product Mangga serta Apel di store city 9*/
SELECT 
    * 
FROM 
    sales 
WHERE 
    product_name IN ('Mangga', 'Apel') AND store_city_id = 9
ORDER BY 2


-- Soal 3
/*Dengan menggunakan data sales, lakukan query yang mengembalikan/menampilkan record 
di tanggal berapa jumlah penjualan buah mangga paling sedikit ?*/
SELECT 
    purchase_date, quantity
FROM 
    sales 
WHERE
    product_name = 'Mangga'
ORDER BY 
    quantity

-- Soal 4
/*Dengan menggunakan data employees, lakukan query yang mengembalikan/menampilkan record 
seluruh gaji karyawan yang nama depannya mengandung huruf 'ba'*/
SELECT 
    first_name,
    salary_2020,
    salary_2021,
    salary_2022
FROM employees 
WHERE first_name LIKE '%Ba%'


-- Soal 5
/*Dengan menggunakan data employees, lakukan query yang mengembalikan/menampilkan 
record rata-rata gaji karyawan  per tahun, bulatkan 2 angka dibelakang koma*/
SELECT 
   ROUND(AVG(salary_2020), 2) avg_2020, 
   ROUND(AVG(salary_2021), 2) avg_2021, 
   ROUND(AVG(salary_2022), 2) avg_2022
FROM employees


-- Soal 6
/*Dengan menggunakan data employees, lakukan query yang mengembalikan/menampilkan record 
nama-nama karyawan yang bertempat di store Yogyakarta dan Jawa Barat*/
SELECT 
    CONCAT(t1.first_name,' ',t1.last_name) AS nama_karyawan,
    t2.region
FROM 
    employees t1 JOIN region t2 ON t1.store_city_id = t2.store_city_id
WHERE
    region IN ('Yogyakarta','Jawa Barat')
ORDER BY 2


-- Soal 7
/*Dengan menggunakan data sales lakukan query yang mengembalikan/menampilkan record
total quantity buah Mangga dan Apel selama 3 pekan setelah Hari Raya Idul Fitri 2022! 
Kolom yang hanya ditampilkan kolom nama produk dan total quantity nya ya!*/
SELECT 
    product_name, 
    SUM(quantity) AS total_quantity 
FROM 
    sales 
WHERE 
    (product_name IN ('Mangga', 'Apel'))
AND 
    purchase_date BETWEEN '2022-05-02' AND '2022-05-23'
GROUP BY 1


-- Soal 8
/*Dengan menggunakan data employee_data dan region_data lakukan query 
yang mengembalikan/menampilkan record seluruh karyawan yang bekerja di daerah Bali 
dan Yogyakarta, gunakan metode Subquery !*/
SELECT 
    *
FROM 
    employees 
WHERE 
    store_city_id IN (
            SELECT 
                store_city_id
            FROM region 
            WHERE region IN ('Bali','Yogyakarta')) 
ORDER BY 2


-- Soal 9
/*Dengan menggunakan data employees, lakukan query yang mengembalikan/menampilkan 
record jumlah karyawan berdasarkan kategori gaji nya di store 9 ditahun 2020. 
Kategori tersebut adalah LOWER, MIDDLE, dan HIGH. 
Untuk kategori LOWER di range : < 4000 ; MIDDLE : >= 4000 - 7000 ; HIGHER : > 7000*/
with cte as (
SELECT 
    employee_id,
    CASE 
        WHEN salary_2020 < 4000 THEN 'LOWER'
        WHEN salary_2020 BETWEEN 4000 AND 7000 THEN 'MIDDLE'
        ELSE 'HIGHER'
    END AS kategori
FROM employees
WHERE store_city_id = 9
GROUP BY employee_id
ORDER BY kategori)
SELECT 
    COUNT(kategori) AS jumlah_karyawan,
    kategori
FROM cte 
GROUP BY kategori


-- Soal 10
/*Dengan menggunakan data sales, lakukan query yang mengembalikan/menampilkan rata-rata total pendapatan di store Sumetera dan Kalimantan. Clue: gunakan metode WITH*/
WITH avg_pendapatan AS(
SELECT 
    SUM(t1.quantity*t1.price_per_kg) AS total_pendapatan,
    t1.product_name,
    t2.region
FROM 
    sales t1 JOIN region t2 ON t1.store_city_id = t2.store_city_id
WHERE region IN ('Sumatera', 'Kalimantan') GROUP BY product_name, region)

SELECT 
    ROUND(AVG(total_pendapatan), 2) AS avg_total_pendapatan, 
    region 
FROM avg_pendapatan 
GROUP BY region


-- Soal 11
/*Dengan menggunakan data sales, lakukan query yang mengembalikan/menampilkan rata-rata total pendapatan di store Yogyakarta dan Sulawesi pada tahun 2021. Clue: gunakan metode WITH*/
WITH avg_pendapatan AS(
SELECT 
    SUM(t1.quantity*t1.price_per_kg) AS total_pendapatan,
    t1.product_name,
    t2.region
FROM 
    sales t1 JOIN region t2 ON t1.store_city_id = t2.store_city_id
WHERE 
    region IN ('Sulawesi', 'Yogyakarta')
AND 
    t1.purchase_date BETWEEN '2021-01-01' AND '2021-12-31' 
GROUP BY product_name, region)

SELECT 
    ROUND(AVG(total_pendapatan), 2) AS avg_total_pendapatan, 
    region 
FROM avg_pendapatan 
GROUP BY region


-- Soal 12
/*Dengan menggunakan data sales dan region_data lakukan query yang mengembalikan/menampilkan record
total pendapatan dari hasil penjualan buah di luar pulau jawa dan jawa, kategorikan daerah berdasarkan pulaunya,
misal Bandung adalah termasuk dari pulau Jawa. Clue: kombinasikan antara metode Conditional Expression dan Subquery!*/
WITH cte AS(
    SELECT
        (t1.quantity*t1.price_per_kg) AS total_pendapatan,
        t2.region,
        CASE
            WHEN t2.region IN ('Sumatera', 'Sulawesi', 'Kalimantan','Bali') THEN 'Luar Pulau Jawa'
            ELSE 'Pulau Jawa'
        END AS kategori 
    FROM sales t1 JOIN region t2 ON t1.store_city_id = t2.store_city_id)
SELECT SUM(total_pendapatan), kategori FROM cte GROUP BY kategori
