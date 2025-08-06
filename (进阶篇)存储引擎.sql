-- 查询建表语句
show create table account;                                                                                              -- MySQL默认存储引擎：InnoDB

-- 查看当前数据库支持的存储引擎
show engines;

-- 创建表 my_myisam,并指定MyISAM存储引擎
create table my_myisam(
    id int,
    name varchar(10)
)engine=MyISAM;

-- 创建表my_memory,指定Memory存储引擎
create table my_memory(
    id int,
    name varchar(10)
)engine=Memory;

show variables like 'innodb_file_per_table';                                                                            -- 如果打开，说明每张表对应每个表空间文件


















































