#!/bin/sh
CSV_DIR="/data/customer"
DB_USER="jhervoch"
DB_NAME="piscineds"

if [ ! -d "$CSV_DIR" ]; then
    echo "Directory $CSV_DIR does not exist, nothing to import."
    exit 0
fi

for file in "$CSV_DIR"/*.csv; do
    [ -f "$file" ] || continue
	table_name="$(basename "$file" .csv)"
    csv_path="$file"
    echo "Importing $file into table $table_name"

    if psql -U "$DB_USER" -d "$DB_NAME" -tAc "SELECT to_regclass('public.$table_name');" | grep -qx "$table_name"; then
        echo "Table $table_name already exists, skipping import."
        continue
    fi

    psql -U "$DB_USER" -d "$DB_NAME" -c "
        CREATE TABLE $table_name (
            event_time date NOT NULL,
            event_type character(50) NOT NULL,
            product_id integer NOT NULL,
            price real NOT NULL,
            user_id bigint NOT NULL,
            user_session uuid
        );
    "

    psql -U "$DB_USER" -d "$DB_NAME" -c "\copy $table_name FROM '$csv_path' WITH CSV HEADER DELIMITER ',';"
done