#!/bin/sh
set -eu

CSV_DIR="${CSV_DIR:-/data/item}"
DB_USER="${DB_USER:-jhervoch}"
DB_NAME="${DB_NAME:-piscineds}"

# Valeur par défaut du fichier CSV à importer
# sinon, utilisez le premier argument passé au script
file="${1:-item.csv}"
table_name="$(basename "$file" .csv)"
csv_path="$CSV_DIR/$file"

case "$file" in
    *.csv)
        ;;
    *)
        echo "Invalid CSV file name: $file" >&2
        exit 1
        ;;
esac

case "$file" in
    */*)
        echo "CSV file name must not contain a path: $file" >&2
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

if [ ! -d "$CSV_DIR" ]; then
    echo "Directory $CSV_DIR does not exist, nothing to import."
    exit 0
fi

if [ ! -f "$csv_path" ]; then
    echo "File $csv_path does not exist, nothing to import."
    exit 0
fi

echo "Importing $file into table $table_name"

if psql -U "$DB_USER" -d "$DB_NAME" -tAc "SELECT to_regclass('public.$table_name');" | grep -qx "$table_name"; then
    echo "Table $table_name already exists, skipping import."
    exit 0
fi

psql -U "$DB_USER" -d "$DB_NAME" -c "
    CREATE TABLE $table_name (
        product_id integer NOT NULL,
        category_id bigint NULL,
        category_code text NULL,
        brand character varying(50) NULL
    );
"

psql -U "$DB_USER" -d "$DB_NAME" -c "\copy $table_name FROM '$csv_path' WITH CSV HEADER DELIMITER ',';"
