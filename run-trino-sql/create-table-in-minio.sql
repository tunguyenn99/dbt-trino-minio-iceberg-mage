-- Xóa schema minio.tpch nếu đã tồn tại
DROP SCHEMA IF EXISTS minio.tpch

-- 📁 Tạo lại schema với đường dẫn tới bucket MinIO (đã được mount sẵn)
CREATE SCHEMA minio.tpch WITH (
  location = 's3a://tpch/'
)

-- CUSTOMER
-- Bước 1: Tạo bảng trong Iceberg (minio.tpch)
CREATE TABLE minio.tpch.customer AS
SELECT * FROM tpch.tiny.customer
WITH NO DATA  -- Tạo bảng nhưng không chèn dữ liệu

-- Bước 2: Insert dữ liệu
INSERT INTO minio.tpch.customer
SELECT * FROM tpch.tiny.customer

-- TƯƠNG TỰ

-- LINEITEM
CREATE TABLE minio.tpch.lineitem AS
SELECT * FROM tpch.tiny.lineitem
WITH NO DATA

INSERT INTO minio.tpch.lineitem
SELECT * FROM tpch.tiny.lineitem

-- NATION
CREATE TABLE minio.tpch.nation AS
SELECT * FROM tpch.tiny.nation
WITH NO DATA

INSERT INTO minio.tpch.nation
SELECT * FROM tpch.tiny.nation

-- ORDERS
CREATE TABLE minio.tpch.orders AS
SELECT * FROM tpch.tiny.orders
WITH NO DATA

INSERT INTO minio.tpch.orders
SELECT * FROM tpch.tiny.orders

-- PART
CREATE TABLE minio.tpch.part AS
SELECT * FROM tpch.tiny.part
WITH NO DATA

INSERT INTO minio.tpch.part
SELECT * FROM tpch.tiny.part

-- PARTSUPP
CREATE TABLE minio.tpch.partsupp AS
SELECT * FROM tpch.tiny.partsupp
WITH NO DATA

INSERT INTO minio.tpch.partsupp
SELECT * FROM tpch.tiny.partsupp

-- REGION
CREATE TABLE minio.tpch.region AS
SELECT * FROM tpch.tiny.region
WITH NO DATA

INSERT INTO minio.tpch.region
SELECT * FROM tpch.tiny.region

-- SUPPLIER
CREATE TABLE minio.tpch.supplier AS
SELECT * FROM tpch.tiny.supplier
WITH NO DATA

INSERT INTO minio.tpch.supplier
SELECT * FROM tpch.tiny.supplier
