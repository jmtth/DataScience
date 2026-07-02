#!/bin/sh
CSV_DIR="/data/customer"
DB_USER="jhervoch"
DB_NAME="piscineds"

file="data_2022_dec.csv"
table_name="$(basename "$file" .csv)"
csv_path="$CSV_DIR/$file"

echo "Importing $file into table $table_name"

psql -U "$DB_USER" -d "$DB_NAME" -c "
    CREATE TABLE IF NOT EXISTS $table_name (
        event_time date NOT NULL,
        event_type character(50) NOT NULL,
        product_id integer NOT NULL,
        price real NOT NULL,
        user_id bigint NOT NULL,
        user_session uuid
    );
"

psql -U "$DB_USER" -d "$DB_NAME" -c "\copy $table_name FROM '$csv_path' WITH CSV HEADER DELIMITER ',';"