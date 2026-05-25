# CDC-Debezium

Sinkronisasi data real-time dari **SQL Server → PostgreSQL** menggunakan **Debezium CDC** + **Apache Kafka**.

## Arsitektur

```
SQL Server (Laptop 1) → Debezium Source Connector → Kafka → Debezium Sink Connector → PostgreSQL (Laptop 2)
```

## Service

| Service | Port | Fungsi |
|---------|------|--------|
| Zookeeper | 2181 | Koordinasi Kafka |
| Kafka | 9092 | Message broker |
| Kafka Connect | 8083 | Menjalankan connector |
| PostgreSQL | 5432 | Database tujuan |
| Kafka UI | 8080 | Monitoring Kafka |

## Setup

```bash
# Build & jalankan semua container
docker compose up -d --build

# Register source connector (SQL Server)
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @sqlserver-source.json

# Register sink connector (PostgreSQL)
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @postgres-sink.json

# Cek status
curl -s http://localhost:8083/connectors/sqlserver-mahasiswa-source/status | jq .
curl -s http://localhost:8083/connectors/postgres-sink-test/status | jq .
```

## Mapping

| SQL Server (Sumber) | PostgreSQL (Tujuan) |
|---|---|
| Database: `Mahasiswa` | Database: `mahasiswa` |
| Tabel: `dbo.Siswa` | Tabel: `Siswa` |
| Kolom: `id_siswa, nama, jenis_kelamin, tanggal_lahir, alamat, kelas` | Kolom: sama |

## Prasyarat SQL Server

- CDC diaktifkan:
  ```sql
  EXEC sys.sp_cdc_enable_db;
  EXEC sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Siswa', @role_name = NULL;
  ```
- User `debezium_user` dengan akses `db_datareader` dan `VIEW CHANGE TRACKING`
- Koneksi via **Tailscale** antar laptop

## Monitoring

Buka **Kafka UI**: `http://localhost:8080`

## File Penting

| File | Deskripsi |
|------|-----------|
| `docker-compose.yaml` | Konfigurasi container |
| `Dockerfile` | Build image Kafka Connect + JDBC driver |
| `sqlserver-source.json` | Konfigurasi source connector SQL Server |
| `postgres-sink.json` | Konfigurasi sink connector PostgreSQL |
| `init.postgres.sql` | Inisialisasi tabel PostgreSQL |
