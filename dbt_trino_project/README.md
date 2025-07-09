# 📊 DBT Trino Project – TPC-H Model with Iceberg

Đây là dự án DBT sử dụng adapter Trino để kết nối với hệ thống Trino + Iceberg. Mục tiêu là mô hình hóa dữ liệu từ bộ TPC-H (trong schema `tpch`) theo 3 tầng staging – intermediate – marts theo chuẩn Kimball.

---

## ⚙️ Cài đặt DBT và khởi tạo dự án

### 1. Cài đặt DBT với Trino adapter

```bash
pip install dbt-core dbt-trino==1.8.0
```

> Yêu cầu Python >= 3.8 và dbt-trino==1.8.0

---

### 2. Khởi tạo project DBT (nếu bạn tạo mới)

```bash
dbt init dbt_trino_project
```

- Chọn adapter: `trino`
- Tạo thư mục chứa models, seeds, macros,...

---

## 🔑 Cấu hình `profiles.yml`

Tạo file `profiles.yml` tại `~/.dbt/profiles.yml` hoặc cung cấp đường dẫn `--profiles-dir`.

Ví dụ:

```yaml
dbt_trino_project:
  outputs:
    dev:
      type: trino
      method: none
      user: tunguyenn99
      password: ''
      database: minio
      host: localhost
      port: 8088
      schema: tpch
      threads: 4

    prod:
      type: trino
      method: none
      user: tunguyenn99
      password: ''
      database: minio
      host: localhost
      port: 8088
      schema: tpch
      threads: 4

  target: dev
```

> 🧠 Nếu bạn chạy trong container Mage, đổi `host: localhost` thành `host: trino-coordinator`.

---

## 📂 Cấu trúc thư mục

```
dbt_trino_project/
├── dbt_project.yml
├── profiles.yml         # (nếu dùng trong Mage)
├── sample-profiles.yml  # (dùng trong .dbt/profiles.yml ở $home)
├── models/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
├── macros/
└── README.md
```

---

## 🧪 Các lệnh DBT thường dùng

```bash
dbt debug               # Kiểm tra kết nối
dbt run                 # Chạy toàn bộ model
dbt test                # Chạy các test
dbt build               # = run + test + snapshot
dbt run --select staging.*
dbt run --select tag:intermediate
```

---

## 📦 Materialization

Toàn bộ models mặc định dùng `materialized: view` (dễ debug và tiết kiệm storage). Bạn có thể override trong từng model nếu cần tạo table:

```sql
{{ config(materialized='table') }}
```

---

## 📚 Tài liệu tham khảo

- [DBT Docs](https://docs.getdbt.com/)
- [dbt-trino adapter](https://github.com/starburstdata/dbt-trino)
- [Trino + Iceberg setup](https://trino.io/)
