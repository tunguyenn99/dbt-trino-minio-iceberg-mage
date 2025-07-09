# 🧙‍♂️ Mage Quickstart – Tích hợp với `dbt_trino_project`

Đây là hướng dẫn từng bước để tích hợp [Mage](https://github.com/mage-ai/mage-ai) — một công cụ orchestrator mạnh mẽ — vào dự án `dbt_trino_project`, giúp bạn dễ dàng chạy `dbt run`, `dbt build`, `dbt test`,... trong pipeline có giao diện trực quan.

---

## 📦 1. Clone Mage Quickstart Template

```bash
git clone https://github.com/mage-ai/compose-quickstart.git mage-quickstart \
&& cd mage-quickstart \
&& cp dev.env .env && rm dev.env
```

> 📝 `mage-quickstart` là bộ khởi động chính thức của Mage, dùng Docker Compose.

---

## ⚙️ 2. Cấu hình `.env`

Mở file `.env` và sửa thành:

```env
PROJECT_NAME=run_dbt_trino
ENV=dev
```

| Biến | Ý nghĩa |
|------|--------|
| `PROJECT_NAME` | Tên pipeline sẽ xuất hiện trong Mage UI |
| `ENV` | Môi trường sử dụng (dev / prod / staging) |

---

## 🔧 3. Cập nhật `docker-compose.yml`

Trong service `magic`, thêm:

```yaml
volumes:
  - .:/home/src/
  - ../dbt_trino_project:/home/src/run_dbt_trino/dbt/  # Mount thư mục DBT vào trong Mage
```

> ✅ Mục đích: Mage sẽ thấy dự án DBT tại `/home/src/run_dbt_trino/dbt`, để bạn có thể gọi `dbt run`, `dbt test`,... trong pipeline.

---

### 🕸️ Kết nối với Trino qua Docker network

Mage cần truy cập được container Trino → bạn phải gắn Mage vào đúng Docker network. Thêm vào `docker-compose.yml`:

```yaml
networks:
  - trino-network
```

Và khai báo ở cuối file:

```yaml
networks:
  trino-network:
    external: true
    name: dbt-trino-minio-iceberg_trino-network
```

| Mục đích | Giải thích |
|---------|------------|
| `external: true` | Dùng mạng Docker đã tạo từ hệ thống Trino |
| `name:` | Chính xác tên mạng được Docker Compose đặt ra khi bạn chạy Trino ( `docker network ls`)  |


**Notes**: Cũng có thể tìm `name` bằng lệnh docker terminal sau:

```bash
docker inspect trino-coordinator | grep -A10 Networks
```

---

## 🚀 4. Chạy Mage

```bash
docker compose up --build
```

Truy cập giao diện Mage tại:  
🔗 http://localhost:6789

---

## 🧠 5. Cấu hình DBT trong Mage UI

Vào pipeline `run_dbt_trino`, tạo block kiểu `dbt`:

- **DBT Project Path**: `/home/src/run_dbt_trino/dbt`
- **Profiles Path**: `/home/src/run_dbt_trino/dbt` (hoặc nơi bạn để `profiles.yml`)
- **Command**: `run`, `build`, `test`,...
- **Flags**: `--select model_name` nếu cần

---

## 📄 Lưu ý khi mount `profiles.yml` cho Mage + DBT

Sau khi bạn đã mount thư mục `dbt_trino_project` vào container Mage, **hãy kiểm tra kỹ rằng file `profiles.yml` cũng được mount theo**. Đây là file cấu hình giúp dbt biết cách kết nối tới Trino.

---

### ✅ Ví dụ nội dung `profiles.yml`

```yaml
dbt_trino_project:
  outputs:
    dev:
      type: trino
      method: none  
      user: tunguyenn99
      password: '' 
      database: minio
      host: trino-coordinator # <<== Đổi tên host từ localhost sang trino-coordinator do đã mở kết nối mạng docker
      port: 8088
      schema: tpch
      threads: 4

    prod:
      type: trino
      method: none
      user: tunguyenn99
      password: ''
      database: minio
      host: trino-coordinator # <<== Đổi tên host từ localhost sang trino-coordinator do đã mở kết nối mạng docker
      port: 8088
      schema: tpch
      threads: 4

  target: dev
```

---

## 🧪 6. Kiểm tra

Chạy thử `dbt debug` hoặc `dbt run` trong block Mage. Nếu kết nối với Trino thành công và model hợp lệ, bạn sẽ thấy kết quả ngay.

---

## ✅ Kết luận

Với setup trên, bạn đã:

- Orchestrate được `dbt_trino_project` bằng Mage UI
- Tích hợp Mage vào mạng của Trino/MinIO/Hive để phân tích dữ liệu
- Chạy được pipelines chuẩn hóa, có thể mở rộng dễ dàng