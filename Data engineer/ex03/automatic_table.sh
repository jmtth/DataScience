#!/bin/sh
set -eu

CSV_DIR="${CSV_DIR:-/data/customer}"
DB_USER="${DB_USER:-jhervoch}"
DB_NAME="${DB_NAME:-piscineds}"

if [ ! -d "$CSV_DIR" ]; then
    echo "Directory $CSV_DIR does not exist, nothing to import."
    exit 0
fi

imported=0

for file in "$CSV_DIR"/*.csv; do
    [ -f "$file" ] || continue
    imported=1
    filename="$(basename "$file")"
    table_name="$(basename "$file" .csv)"
    csv_path="$file"

    case "$filename" in
        *.csv)
            ;;
        *)
            echo "Invalid CSV file name: $filename" >&2
            exit 1
            ;;
    esac

    case "$table_name" in
        [a-zA-Z_][a-zA-Z0-9_]*)
            ;;
        *)
            echo "Invalid table name: $table_name" >&2
            exit 1
            ;;
    esac

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

if [ "$imported" -eq 0 ]; then
    echo "No CSV file found in $CSV_DIR, nothing to import."
fi
