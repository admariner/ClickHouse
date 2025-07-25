---
description: 'The File table engine keeps the data in a file in one of the supported
  file formats (`TabSeparated`, `Native`, etc.).'
sidebar_label: 'File'
sidebar_position: 40
slug: /engines/table-engines/special/file
title: 'File Table Engine'
---

# `File` table engine

The File table engine keeps the data in a file in one of the supported [file formats](/interfaces/formats#formats-overview) (`TabSeparated`, `Native`, etc.).

Usage scenarios:

- Data export from ClickHouse to file.
- Convert data from one format to another.
- Updating data in ClickHouse via editing a file on a disk.

:::note
This engine is not currently available in ClickHouse Cloud, please [use the S3 table function instead](/sql-reference/table-functions/s3.md).
:::

## Usage in ClickHouse Server {#usage-in-clickhouse-server}

```sql
File(Format)
```

The `Format` parameter specifies one of the available file formats. To perform
`SELECT` queries, the format must be supported for input, and to perform
`INSERT` queries – for output. The available formats are listed in the
[Formats](/interfaces/formats#formats-overview) section.

ClickHouse does not allow specifying filesystem path for `File`. It will use folder defined by [path](../../../operations/server-configuration-parameters/settings.md) setting in server configuration.

When creating table using `File(Format)` it creates empty subdirectory in that folder. When data is written to that table, it's put into `data.Format` file in that subdirectory.

You may manually create this subfolder and file in server filesystem and then [ATTACH](../../../sql-reference/statements/attach.md) it to table information with matching name, so you can query data from that file.

:::note
Be careful with this functionality, because ClickHouse does not keep track of external changes to such files. The result of simultaneous writes via ClickHouse and outside of ClickHouse is undefined.
:::

## Example {#example}

**1.** Set up the `file_engine_table` table:

```sql
CREATE TABLE file_engine_table (name String, value UInt32) ENGINE=File(TabSeparated)
```

By default ClickHouse will create folder `/var/lib/clickhouse/data/default/file_engine_table`.

**2.** Manually create `/var/lib/clickhouse/data/default/file_engine_table/data.TabSeparated` containing:

```bash
$ cat data.TabSeparated
one 1
two 2
```

**3.** Query the data:

```sql
SELECT * FROM file_engine_table
```

```text
┌─name─┬─value─┐
│ one  │     1 │
│ two  │     2 │
└──────┴───────┘
```

## Usage in ClickHouse-local {#usage-in-clickhouse-local}

In [clickhouse-local](../../../operations/utilities/clickhouse-local.md) File engine accepts file path in addition to `Format`. Default input/output streams can be specified using numeric or human-readable names like `0` or `stdin`, `1` or `stdout`. It is possible to read and write compressed files based on an additional engine parameter or file extension (`gz`, `br` or `xz`).

**Example:**

```bash
$ echo -e "1,2\n3,4" | clickhouse-local -q "CREATE TABLE table (a Int64, b Int64) ENGINE = File(CSV, stdin); SELECT a, b FROM table; DROP TABLE table"
```

## Details of Implementation {#details-of-implementation}

- Multiple `SELECT` queries can be performed concurrently, but `INSERT` queries will wait each other.
- Supported creating new file by `INSERT` query.
- If file exists, `INSERT` would append new values in it.
- Not supported:
  - `ALTER`
  - `SELECT ... SAMPLE`
  - Indices
  - Replication

## PARTITION BY {#partition-by}

`PARTITION BY` — Optional.  It is possible to create separate files by partitioning the data on a partition key. In most cases, you don't need a partition key, and if it is needed you generally don't need a partition key more granular than by month. Partitioning does not speed up queries (in contrast to the ORDER BY expression). You should never use too granular partitioning. Don't partition your data by client identifiers or names (instead, make client identifier or name the first column in the ORDER BY expression).

For partitioning by month, use the `toYYYYMM(date_column)` expression, where `date_column` is a column with a date of the type [Date](/sql-reference/data-types/date.md). The partition names here have the `"YYYYMM"` format.

## Virtual columns {#virtual-columns}

- `_path` — Path to the file. Type: `LowCardinality(String)`.
- `_file` — Name of the file. Type: `LowCardinality(String)`.
- `_size` — Size of the file in bytes. Type: `Nullable(UInt64)`. If the size is unknown, the value is `NULL`.
- `_time` — Last modified time of the file. Type: `Nullable(DateTime)`. If the time is unknown, the value is `NULL`.

## Settings {#settings}

- [engine_file_empty_if_not_exists](/operations/settings/settings#engine_file_empty_if_not_exists) - allows to select empty data from a file that doesn't exist. Disabled by default.
- [engine_file_truncate_on_insert](/operations/settings/settings#engine_file_truncate_on_insert) - allows to truncate file before insert into it. Disabled by default.
- [engine_file_allow_create_multiple_files](/operations/settings/settings.md#engine_file_allow_create_multiple_files) - allows to create a new file on each insert if format has suffix. Disabled by default.
- [engine_file_skip_empty_files](/operations/settings/settings.md#engine_file_skip_empty_files) - allows to skip empty files while reading. Disabled by default.
- [storage_file_read_method](/operations/settings/settings#engine_file_empty_if_not_exists) - method of reading data from storage file, one of: `read`, `pread`, `mmap`. The mmap method does not apply to clickhouse-server (it's intended for clickhouse-local). Default value: `pread` for clickhouse-server, `mmap` for clickhouse-local.
