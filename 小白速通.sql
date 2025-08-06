 CREATE DATABASE `sql_tutorial`;
 SHOW DATABASES;
 USE `sql_tutorial`;

SET SQL_SAFE_UPDATES = 0;  
 CREATE TABLE `student`(
	`student_id` INT PRIMARY KEY,
	`name` VARCHAR(20),
	`major` VARCHAR(20),
    `score` INT
 );
 
 SELECT * FROM `student` 
 WHERE `major` IN('历史', '英语');
 
 INSERT INTO `student` VALUES(5, '小黄', '化学', 70);
 INSERT INTO `student` VALUES(4, '小蓝', '英语', 90);
 
 UPDATE `student`
 SET `major`='物理';
 
 DELETE FROM `student`;
 DROP TABLE `student`;
 
 
 -- 创建公司资料库表格
 CREATE TABLE `employee`(
 `employee_id` INT PRIMARY KEY,
 `name` VARCHAR(20),
 `birth_date` DATE,
 `sex` VARCHAR(1),
 `salary` INT,
 `branch_id` INT,
 `sup_id` INT
 );
 DROP TABLE `employee`;
 
 CREATE TABLE `branch`(
 `branch_id` INT PRIMARY KEY,
 `branch_name` VARCHAR(20),
 `manager_id` INT,
 FOREIGN KEY(`manager_id`) REFERENCES `employee`(`employee_id`) ON DELETE SET NULL                  -- 表格的外键可以是null，可以用ON DELETE SET NULL
 );
DROP TABLE `branch`;
ALTER TABLE `employee`
ADD FOREIGN KEY(`branch_id`)
REFERENCES `branch`(`branch_id`)
ON DELETE SET NULL;
ALTER TABLE `employee`
ADD FOREIGN KEY(`sup_id`)
REFERENCES `employee`(`employee_id`)
ON DELETE SET NULL;

 CREATE TABLE `client`(
 `client_id` INT PRIMARY KEY,
 `client_name` VARCHAR(20),
 `phone` VARCHAR(20)
 );
 
 CREATE TABLE `works_with`(
 `employee_id` INT,
 `client_id` INT,
 `total_sales` INT,
 PRIMARY KEY(`employee_id`, `client_id`),
 FOREIGN KEY(`employee_id`) REFERENCES `employee`(`employee_id`) ON DELETE CASCADE,                        -- 表格的主键不可为null，所以这里用ON DELETE CASCADE
 FOREIGN KEY(`client_id`) REFERENCES `client`(`client_id`) ON DELETE CASCADE
 );
 
 
 -- 新增公司资料
 INSERT INTO `branch` VALUES(1,'研发', NULL);
 INSERT INTO `branch` VALUES(2,'行政', NULL);
 INSERT INTO `branch` VALUES(3,'资讯', NULL);
 INSERT INTO `employee` VALUES(206, '小黄', '1998-10-08', 'F', 50000, 1, NULL);
 INSERT INTO `employee` VALUES(207, '小绿', '1985-09-16', 'M', 29000, 2, 206);
 INSERT INTO `employee` VALUES(208, '小黑', '2000-12-09', 'M', 35000, 3, 206);
 INSERT INTO `employee` VALUES(209, '小白', '1997-01-22', 'F', 39000, 3, 207);
 INSERT INTO `employee` VALUES(210, '小蓝', '1925-11-10', 'F', 84000, 1, 207);
 UPDATE `branch`
 SET `manager_id`= 206
 WHERE `branch_id`=1;
 UPDATE `branch`
 SET `manager_id`= 207
 WHERE `branch_id`=2;
 UPDATE `branch`
 SET `manager_id`= 208
 WHERE `branch_id`=3;
 INSERT INTO `client` VALUES(400, '阿狗', '254354335');
 INSERT INTO `client` VALUES(401, '阿猫', '25633899');
 INSERT INTO `client` VALUES(402, '旺来', '45354345');
 INSERT INTO `client` VALUES(403, '露西', '54354365');
 INSERT INTO `client` VALUES(404, '艾瑞克', '18783783');
 INSERT INTO `works_with` VALUES(206, 400, '70000');
 INSERT INTO `works_with` VALUES(207, 401, '24000');
 INSERT INTO `works_with` VALUES(208, 402, '9800');
 INSERT INTO `works_with` VALUES(208, 403, '24000');
 INSERT INTO `works_with` VALUES(210, 404, '87940');
 
 SELECT * FROM `employee`;
 SELECT * FROM `client`;
 SELECT * FROM `employee` ORDER BY `salary` DESC  LIMIT 3;
 SELECT * FROM `employee` ORDER BY `sex`;
 SELECT `name` FROM `employee`;
 SELECT DISTINCT `sex` FROM `employee`;
 SELECT DISTINCT `branch_id` FROM `branch`;
 
 -- aggregate functions 聚合函数
 SELECT COUNT(*) FROM `employee`;                                                   -- 员工人数
 SELECT COUNT(`sup_id`) FROM `employee`;                                            -- 非空sup_id资料笔数
 SELECT COUNT(*) FROM `employee` WHERE `birth_date`>'1970-01-01' AND `sex`='F';     -- 出生日期在此之后的女员工资料笔数
SELECT AVG(`salary`) FROM `employee`;                                               -- 员工平均薪水
SELECT SUM(`salary`) FROM `employee`;                                               -- 员工薪水总和
SELECT MAX(`salary`) FROM `employee`;                                               -- 最高薪水
SELECT MIN(`salary`) FROM `employee`;                                               -- 最低薪水

 -- wildcards 万用字元  %代表多个字元，_代表一个字元
 SELECT * FROM `client` WHERE `phone` LIKE '%335';                                  -- 电话号码尾数是335的客户资料
 SELECT * FROM `client` WHERE `phone` LIKE '254%';                                  -- 电话号码前三位是254的客户资料
 SELECT * FROM `client` WHERE `phone` LIKE '%354%';                                 -- 电话号码中有354的客户资料
 SELECT * FROM `client` WHERE `client_name` LIKE '艾%';                             -- 姓艾的客户资料
 SELECT * FROM `employee` WHERE `birth_date` LIKE '_____12%';                       -- 生日在12月的员工资料
 
 -- union 联集
 SELECT `name` FROM `employee`
 UNION
 SELECT `client_name` FROM `client`                                                  -- 员工名字联结客户名字
 UNION
 SELECT `branch_name` FROM `branch`;                                                 -- 再联结branch_name(n个属性联结n个属性，且资料形态要一致)
 SELECT `employee_id` AS `total_id`, `name` AS `total_name` FROM `employee`
 UNION
 SELECT `client_id`, `client_name` FROM `client`;                                    -- 员工id和员工名字联结客户id和客户名字(修改联结后的属性名称)
 SELECT `salary` AS `total_money` FROM `employee`
 UNION
 SELECT `total_sales` FROM `works_with`;                                             -- 员工薪水联结销售金额(修改联结后的属性为total_name)
 
 -- 连接
 INSERT INTO `branch` VALUES(4, '偷懒', NULL);
 SELECT * FROM `employee` JOIN `branch`
 ON `employee_id` = `manager_id`;                                                    -- 两表JOIN(基于条件)，取全部属性资料
 SELECT `employee`.`employee_id`, `employee`.`name`, `branch`.`branch_name`
 FROM `employee` JOIN `branch`
 ON `employee`.`employee_id`=`branch`.`manager_id`;                                  -- 两表JOIN(基于条件)，取部门经理id、名字、部门名字
 SELECT `employee`.`employee_id`, `employee`.`name`, `branch`.`branch_name`
 FROM `employee` LEFT JOIN `branch`
 ON `employee`.`employee_id`=`branch`.`manager_id`;                                  -- 两表JOIN之后的表：左部分是employee的表(不管条件都会回传)，右部分是branch的表(基于条件)
 SELECT `employee`.`employee_id`, `employee`.`name`, `branch`.`branch_name`
 FROM `employee` RIGHT JOIN `branch`
 ON `employee`.`employee_id`=`branch`.`manager_id`;                                  -- 两表JOIN之后的表：左部分是employee的表(基于条件)，右部分是branch的表(不管条件都会回传)
 
 -- subquery 子查询
 SELECT `name` FROM `employee`
 WHERE `employee_id` =(
	SELECT `manager_id` FROM `branch`
	WHERE `branch_name`='研发'
);                                                                                   -- 搜寻语句里套另一个搜寻语句
 
 SELECT `name` FROM `employee`
 WHERE `employee`.`employee_id` IN(
	SELECT `employee_id` FROM `works_with`
	WHERE `total_sales`>50000
 );                                                                                  -- 子查询的结果是多笔资料，用IN
 
 -- ON DELETE(ON DELETE SET NULL表示当其对应表中无资料时返回本表对应的属性数据为null，ON DELETE CASCADE表示当其对应表中无资料时删除本表对应的属性资料)
 DELETE FROM `employee`
 WHERE `employee_id`= 207;
 SELECT * FROM `branch`;
 SELECT * FROM `works_with`;                                                         --
 

 
 
 
 
 
 
 
 
 
 show databases;
 use mysql;
 show tables;
 select * from user;
 
 
 
 
 
 
 
 
 
 
 
