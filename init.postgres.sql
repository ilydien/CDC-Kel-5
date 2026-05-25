CREATE TABLE IF NOT EXISTS Siswa (
    id_siswa INTEGER PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    jenis_kelamin VARCHAR(10),
    tanggal_lahir DATE,
    alamat VARCHAR(255),
    kelas VARCHAR(20)
);

COMMENT ON TABLE Siswa IS 'Tabel sinkron dari SQL Server via CDC Debezium';
COMMENT ON COLUMN Siswa.id_siswa IS 'Primary key dari SQL Server';
