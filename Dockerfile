FROM quay.io/debezium/connect:latest

USER root

# Buat direktori jika belum ada
RUN mkdir -p /kafka/libs

# Download JDBC driver PostgreSQL
RUN curl -o /kafka/libs/postgresql-42.7.3.jar https://jdbc.postgresql.org/download/postgresql-42.7.3.jar

# Beri permission
RUN chmod 644 /kafka/libs/postgresql-42.7.3.jar

# Kembali ke user kafka
USER kafka

# Set classpath tambahan
ENV CLASSPATH=/kafka/libs/*
