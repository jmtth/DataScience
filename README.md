# DataScience

This repository contains my work for the 42 Data Science piscine.

The piscine is organized as a progression through the main roles and topics of a data project: building the data infrastructure, storing and transforming data, analyzing it, and finally using it for data science work.

## Piscine Overview

The project is split into several days:

- Day 1: Data Engineer
- Day 2: Data Warehouse
- Day 3: Data Analyst
- Day 4: Data Scientist 1
- Day 5: Data Scientist 2

Each day focuses on a different step of the data workflow. The first day starts with the foundations: running a database, loading raw CSV files, and making the import process reproducible.

## Structure

```text
.
├── Data engineer/   Day 1 exercises
└── Data WareHouse/  Day 2 exercises
```

Other days will be added as the piscine progresses.

## Day 1: Data Engineer

The goal of the first day is to build a small PostgreSQL environment, connect administration tools to it, and load CSV datasets into tables in a repeatable way.

The exercises start with a simple database container, then move toward a more realistic workflow with persistent storage, mounted datasets, and shell scripts for imports.

### Focus

Day 1 covers:

- running PostgreSQL with Docker Compose;
- keeping database and pgAdmin data persistent between restarts;
- using Adminer and pgAdmin to inspect the database;
- mounting CSV files inside the containers so they can be imported reliably;
- creating tables that match the expected dataset structure;
- importing one CSV file or a full directory of CSV files with `psql` and `\copy`.

This is the base of a data engineering workflow: collect data, define a schema, load the data, and make the process reproducible.

### Day 1 Structure

```text
Data engineer/
├── ex00/  PostgreSQL container
├── ex01/  PostgreSQL with Adminer, pgAdmin, persistence, and CSV data mounts
├── ex02/  Single customer CSV import script
├── ex03/  Batch customer CSV import script
└── ex04/  Item CSV import script
```

### Exercises

#### Exercise 00: PostgreSQL Container

`ex00` starts the project with a minimal PostgreSQL service.

The database configuration is provided through environment variables:

- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`

This exercise is mainly about understanding how Docker Compose starts a database service and exposes it on the host.

#### Exercise 01: PostgreSQL, Adminer, and pgAdmin

`ex01` extends the setup with two administration interfaces:

- Adminer on port `8080`;
- pgAdmin on port `5050`.

The PostgreSQL service is connected to both tools through the `piscineds` Docker network. The database files are stored under `data/postgres`, and pgAdmin keeps its state under `data/pgadmin`.

CSV files are mounted read-only into the containers through `/data`. This is important because pgAdmin and PostgreSQL see the container filesystem, not the macOS filesystem directly.

#### Exercise 02: Import One Customer CSV

`ex02/table.sh` imports one customer CSV file into PostgreSQL.

By default, it looks for:

```text
/data/customer/data_2022_dec.csv
```

The table name is taken from the CSV filename without the `.csv` extension. For example:

```text
data_2022_dec.csv -> data_2022_dec
```

The script checks that the filename can safely become a SQL table name, creates the table with the expected customer schema, and imports the data with `\copy`.

#### Exercise 03: Import a Batch of Customer CSV Files

`ex03/automatic_table.sh` imports every `.csv` file found in `/data/customer`.

For each file, the script:

1. extracts the table name from the filename;
2. checks that the table name is valid;
3. skips the file if the table already exists;
4. creates the customer table;
5. imports the CSV content.

This makes the import process repeatable and avoids manually writing one command per month or dataset file.

#### Exercise 04: Import Item Data

`ex04/items_table.sh` imports item data from `/data/item/item.csv`.

It follows the same pattern as the customer import scripts, but uses a schema adapted to item metadata:

- `product_id`
- `category_id`
- `category_code`
- `brand`

### Useful Commands

Start the main environment from `Data engineer/ex01`:

```sh
docker compose up --build
```

Stop it:

```sh
docker compose down
```

Check that Docker Compose resolved the environment variables correctly:

```sh
docker compose config
```

Connect to PostgreSQL from the running container:

```sh
docker compose exec postgres psql -U jhervoch -d piscineds
```

Run an import script from inside the PostgreSQL container, depending on where the script is mounted or copied:

```sh
sh table.sh
sh automatic_table.sh
sh items_table.sh
```

### Data Engineering Notes

The important part of these exercises is not only starting PostgreSQL. The real objective is to build a clean loading process:

- keep configuration explicit and easy to inspect;
- separate persistent database state from source CSV files;
- make imports repeatable;
- validate table names before using them in SQL;
- avoid re-importing data when the target table already exists;
- use the database schema to make assumptions about the data visible.

At this stage, the scripts use predefined schemas for the expected CSV files. That is simpler and safer than guessing column types automatically, especially while learning how PostgreSQL imports work.

## Day 2: Data Warehouse

### Exercise 00: PostgreSQL Container

Reuse the PostgreSQL container from Day 1. 
The database is already running and can be used for the next exercises.

### Exercise 01: Join/concatenate all the data

Simple sql query to join all the data from the different tables `data_202*_***` into one table `customers`.