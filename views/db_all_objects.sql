#
# Name: db_all_objects
# Author: YJ
# Date: 2016.08.08
# Desc: show list of objects within each schema
#
# MariaDB [sys]> select * from db_all_objects;# 
# +--------------------+-------------+---------------------------------------+
# | schema_name        | object_type | object_name                           |
# +--------------------+-------------+---------------------------------------+
# | information_schema | SYSTEM VIEW | ALL_PLUGINS                           |
# | information_schema | SYSTEM VIEW | APPLICABLE_ROLES                      |
# ...
# | sys                | INDEX(BTREE) | PRIMARY(workload_sql_text)           |
# | sys                | PROCEDURE    | workload_proc_run_snapshot           |
# | sys                | EVENT        | workload_event_schedule              |
# +--------------------+-------------+---------------------------------------+
# 
CREATE OR REPLACE
ALGORITHM=UNDEFINED
DEFINER = 'root'@'localhost'
SQL SECURITY INVOKER
VIEW `db_all_objects`
AS
SELECT table_schema AS schema_name
      ,table_type   AS object_type
      ,table_name   AS object_name
  FROM information_schema.tables
UNION ALL
SELECT DISTINCT table_schema AS schema_name
               ,concat('INDEX(', index_type, ')') AS object_type
               ,concat(index_name, '(', table_name, ')') AS object_name
  FROM information_schema.statistics
UNION ALL
SELECT routine_schema AS schema_name
      ,routine_type   AS object_type
      ,routine_name   AS object_name
  FROM information_schema.routines
UNION ALL
SELECT trigger_schema AS schema_name
      ,'TRIGGER' AS object_type
      ,trigger_name AS object_name
  FROM information_schema.triggers
UNION ALL
SELECT event_schema AS schema_name, 'EVENT' AS object_type, event_name AS object_name
  FROM information_schema.events
;
