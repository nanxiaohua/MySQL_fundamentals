-- 多表关系---------------------------------------------------------------------------------------------
-- 多对多关系(通过中间表维护)
create table student(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '姓名',
    no varchar(10) comment '学号'
)comment '学生表';
insert into student values(null, '黛绮丝', '2000100101'),(null,'谢逊', '2000100102'),(null, '殷天正','2000100103'),(null,'韦一笑','2000100104');
select * from student;

create table course(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '课程名称'
)comment '课程表';
insert into course values(null,'Java'),(null,'PHP'),(null,'MySQL'),(null,'Hadoop');
select * from course;

create table student_course(
    id int auto_increment comment '主键' primary key ,
    studentid int not null comment '学生ID',
    courseid int not null comment '课程ID',
    constraint fk_courseid foreign key (courseid) references course(id),
    constraint fk_studentid foreign key (studentid) references  student(id)
)comment '学生课程中间表';                                                                                                 -- 中间表至少包含两个外键对应其他两个表的主键
insert into student_course values(null,1,1),(null,1,2),(null,1,3),(null,2,2),(null,2,3),(null,3,4);                     -- 多对多关系的实现，靠中间表来维护【图形化界面中操作：右击中间表→diagrams→show diagrams/visualization】
select * from student_course;

-- 一对一关系
create table tb_user(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '姓名',
    age int comment '年龄',
    gender char(1) comment '1:男,2:女',
    phone char(11) comment '手机号'
) comment '用户基本信息表';
create table tb_user_edu(
    id int auto_increment primary key comment '主键ID',
    degree varchar(20) comment '学历',
    major varchar(50) comment '专业',
    primaryschool varchar(50) comment '小学',
    middleschool varchar(50) comment '中学',
    university varchar(50) comment '大学',
    userid int unique comment '用户ID',
    constraint fk_userid foreign key (userid) references tb_user(id)
)comment '用户教育信息表';                                                                                                 -- 加了外键userid，并且约束为unique以此保证是一对一关系
insert into tb_user values
    (null,'黄渤',45,'1','18800001111'),
    (null,'冰冰',35,'2','18800002222'),
    (null,'码云',55,'1','18800008888'),
    (null,'李彦宏',50,'1','18800009999');
insert into tb_user_edu values
    (null,'本科','舞蹈','静安区第一小学','静安区第一中学','北京舞蹈学院',1),
    (null,'硕士','表演','朝阳区第一小学','朝阳区第一中学','北京电影学院',2),
    (null,'本科','英语','杭州市第一小学','杭州市第一中学','杭州师范大学',3),
    (null,'本科','应用数学','阳泉第一小学','阳泉区第一中学','清华大学',4);
select * from tb_user;
select * from tb_user_edu;


-- 多表查询
create table dept1(
    id int auto_increment primary key comment '部门ID',
    name varchar(20) comment '部门名'
)comment '部门表';
insert into dept1 (name) values('研发部'),('市场部'),('财务部'),('销售部'),('总经办'),('人事部');
create table emp1(
    id int auto_increment primary key comment '员工ID',
    name varchar(20) not null comment '员工姓名',
    age int comment '年龄',
    job varchar(20) comment '职位',
    salary int comment '薪资',
    entrydate date comment '入职日期',
    managerid int comment '主管ID',
    dept_id int comment '所属部门ID',
    constraint  fk_dep_id foreign key (dept_id) references dept1(id)
)comment '员工表';
insert into emp1 values
                     (1,'金庸',66,'总裁',20000,'2000-01-01',null,5),
                     (2,'张无忌',20,'项目经理',12500,'2005-12-05',1,1),
                     (3,'杨逍',33,'开发',8400,'2000-11-03',2,1),
                     (4,'韦一笑',48,'开发',11000,'2002-02-05',2,1),
                     (5,'常遇春',43,'开发',10500,'2004-09-07',3,1),
                     (6,'小昭',19,'程序员鼓励师',6600,'2004-10-12',2,1),
                     (7,'灭绝',60,'财务总监',8500,'2002-09-12',1,3),
                     (8,'周芷若',19,'会计',48000,'2006-06-02',7,3),
                     (9,'丁敏君',23,'出纳',5250,'2009-05-13',7,3),
                     (10,'赵敏',20,'市场部总监',12500,'2004-10-12',1,2),
                     (11,'鹿杖客',56,'职员',3750,'2006-10-03',10,2),
                     (12,'鹤笔翁',19,'职员',3750,'2007-05-09',10,2),
                     (13,'方东白',19,'职员',5500,'2009-02-12',10,2),
                     (14,'张三丰',88,'销售总监',14000,'2004-10-12',1,4),
                     (15,'俞莲舟',38,'销售',4600,'2004-10-12',14,4),
                     (16,'宋远桥',40,'销售',4600,'2004-10-12',14,4),
                     (17,'陈友谅',42,null,2000,'2011-10-12',1,null);                                                     -- 数据准备
select * from dept1;
select * from emp1;
select * from emp1, dept1;                                                                                              -- 笛卡尔积(出现17*6=102条记录)
select * from emp1, dept1 where emp1.dept_id=dept1.id;                                                                  -- 加where条件(外键=主键)消除无效的笛卡尔积，陈友谅无dept_id,也就没有对应的记录
-- 内连接(两表交集)
select emp1.name,dept1.name from emp1, dept1 where emp1.dept_id=dept1.id;                                               -- 用隐式内连接实现：查询每一个员工的姓名，及关联的部门名称
select e.name, d.name from emp1 e, dept1 d where e.dept_id=d.id;                                                        -- 若在from里给表起了别名，那么在where里限定字段时只能用别名不能用原名(因为执行顺序from>where,from里已经起了别名)
select e.name, d.name from emp1 e inner join dept1 d on e.dept_id=d.id;                                        -- 用显式内连接实现：查询每一个员工的姓名，及关联的部门名称(inner可省)
-- 外连接(一表全部数据，另一表对应数据)
select e.*,d.name from emp1 e left outer join dept1 d on d.id = e.dept_id;                                    -- 查询emp1表所有数据，及对应的部门信息(左外连接：查询左表所有数据及左右表交集部分)(outer可省)
select e.*,d.* from emp1 e right outer join dept1 d on d.id = e.dept_id;                                       -- 查询dept1表所有数据，及对应的员工信息(右外连接：查询右表所有数据及左右表交集部分)
select d.*,e.* from emp1 e right outer join dept1 d on d.id = e.dept_id;                                       -- 同上，要注意select里左右表的顺序影响返回的结果
select d.*,e.* from dept1 d left outer join emp1 e on d.id = e.dept_id;                                        -- 为什么项目开发中左外连接用的更多(因为右外连接可以改成左外连接)
-- 自连接(必须起别名。可以是内/外连接)
select a.name, b.name from emp1 a,emp1 b where a.managerid=b.id;                                                        -- 查询员工及其所属主管的名字。把emp1看成两张表(员工表表a和主管表表b)(自连接必须起别名)
select a.name '员工姓名',b.name '主管姓名' from emp1 a join emp1 b on a.managerid=b.id;                                    -- 同上，只是给结果表的字段起了别名
select a.name '员工',b.name '主管' from emp1 a left join emp1 b on a.managerid=b.id;                                      -- 查询所有员工及其领导的名字，若员工没有领导也要查询出来
-- 联合查询
select name,salary,age from emp1 where salary<5000 or age >50;
select * from emp1 where salary<5000
union
select * from emp1 where age>50;                                                                                        -- 将两次查询的结果合并(注意两次查询字段数要一致，注意union和union all的不同)

-- 子查询
-- (1)标量子查询
select id from dept1 where name ='销售部';
select * from emp1 where dept_id=4;
select * from emp1 where dept_id = (select id from dept1 where name ='销售部');                                          -- 查询销售部的所有员工信息(括号里面是子查询)(子查询的返回结果只有一条记录，就叫标量子查询)
select * from emp1 where entrydate>(select entrydate from emp1 where name='方东白');                                     -- 查询方东白入职之后的员工信息(子查询仍是标量子查询，所以其前可以用><=)
-- (2)列子查询
select * from emp1 where dept_id in (select id from dept1 where name='销售部'OR name='市场部');                           -- 查询销售部和市场部的所有员工信息
select salary from emp1 where dept_id=(select id from dept1 where name='财务部');
select * from emp1 where salary > all(select salary from emp1 where dept_id=(select id from dept1 where name='财务部')); -- 查询比财务部所有人工资都高的员工信息(> all)
select * from emp1 where salary > max(select salary from emp1 where dept_id=(select id from dept1 where name='财务部')); -- max是聚合函数，后面跟的是数值集合/字段名，而列子查询的返回结果是一列值而非数值集合
select * from emp1 where salary > (select max(salary) from emp1 where dept_id=(select id from dept1 where name='财务部'));-- 检查sql语句，可以一层层执行子查询，同时注意语法的规范(这里把周芷若的48000改为4800，下面统一)
select * from emp1 where salary > any(select salary from emp1 where dept_id=(select id from dept1 where name='研发部'));  -- 查询比研发部其中任意一人工资高的员工信息(子查询是列子查询，前面用in/not in/any/some/all)(any可替换为some)
-- (3)行子查询 
select salary,managerid from emp1 where name='张无忌';
select * from emp1 where (salary,managerid)=(12500,1);
select * from emp1 where (salary,managerid)=(select salary,managerid from emp1 where name='张无忌');                     -- 查询与张无忌的薪资及所属领导相同的员工信息
-- (4)表子查询
select job,salary from emp1 where name='鹿杖客' or name='宋远桥';
select * from emp1 where (job,salary) in (select job,salary from emp1 where name='鹿杖客' or name='宋远桥');               -- 查询与鹿杖客、宋远桥的职位和薪资相同的员工信息
-- eg 查询入职日期是2006-01-01之后的员工信息，及其部门信息
select * from emp1 where entrydate>'2006-01-01';
select * from (select * from emp1 where entrydate>'2006-01-01') a left join dept1 on a.dept_id=dept1.id;                -- 上个语句所生成的表作from的子查询，左外连接dept1表(因上语句的结果表全部信息都要，右边要补对应的部门信息，所以用左外连接)
select a.*,d.* from (select * from emp1 where entrydate>'2006-01-01') a left join dept1 d on a.dept_id=d.id;            -- 起别名之后之后注意执行顺序之后的部分都要改别名。select部分仍然可以直接用*


-- 实操------------------------------------------------------------------------------------------------
create table salgrade(
    grade int,
    losal int,
    hisal int
)comment '薪资等级表';
insert into salgrade values(1,0,3000),(2,3001,5000),(3,5001,8000),(4,8001,10000),(5,10001,15000),(6,15001,20000),(7,20001,25000),(8,25001,30000);-- 数据准备，与emp1和dept1表联查
select * from salgrade;
-- 1.查询员工的姓名、年龄、职位、部门信息(隐式内连接)
select e.name,e.age,e.job,d.name from emp1 e,dept1 d where e.dept_id=d.id;                                              -- 隐式内连接：多张表之间用逗号分隔，用where
-- 2.查询年龄小于30岁的员工的姓名、年龄、职位、部门信息(显式内连接)
select e.name,e.age,e.job,d.name from (select * from emp1 where age<30) e join dept1 d on e.dept_id=d.id;               -- 显式内连接：用join on
select * from emp1 where age<30;
select e.name,e.age,e.job,d.name from emp1 e join dept1 d on e.dept_id=d.id where e.age<30;                    -- 两种方法均可
-- 3.查询拥有员工的部门ID、部门名称
select * from dept1 where id in (select distinct dept_id from emp1);
select distinct dept_id from emp1 where dept_id in (select id from dept1);
select * from dept1 where id in(select distinct dept_id from emp1 where dept_id in (select id from dept1));             -- 思路1：先把emp1中dept_id字段取出(默认非空)返回一列，用select...from dept1加上where，上语句作为列子查询
select distinct d.* from emp1 e join dept1 d on e.dept_id=d.id;                                                -- 思路2：问题简化为：两表中dept_id和id有交集的id部分，也就是两表交集————内连接，此处用显式内连接
select distinct d.* from emp1 e,dept1 d where e.dept_id=d.id;                                                           -- 此处用隐式内连接，select里直接用d.id,d.name，这里简化为d.*
-- 4.查询所有年龄大于40岁的员工，及其归属的部门名称；如果员工没有分配部门，也要展示出来
select * from emp1 where age>40;
select e.name,d.name from (select * from emp1 where age>40) e left join dept1 d on e.dept_id=d.id;                      -- 没有...也要展示————外连接。思路1：先筛＞40的员工，得到的结果表左外连接dept1
select e.name,d.name from emp1 e left join dept1 d on e.dept_id=d.id where e.age>40;                          -- 思路2：emp1左外连接dept1之后再筛年龄＞40的员工
-- 5.查询所有员工的工资等级
select e.name,s.grade from emp1 e left join salgrade s on e.salary between s.losal and s.hisal;                         -- 思路1：e外连接s(因为e的所有员工信息都要展示出来)，连接条件是e的salary数值在s的losal和hisal之间
select name,salary from emp1;
select e.name,s.grade from emp1 e,salgrade s where e.salary>=s.losal and e.salary<=s.hisal;                             -- 思路2：因为e的所有员工都有salary值，s也是，内连接其实也可以。(此处用隐式内连接)
select e.name,s.grade from emp1 e,salgrade s where e.salary between s.losal and s.hisal;
select e.name,s.grade from emp1 e join salgrade s on e.salary>=s.losal && e.salary<=s.hisal;                            -- (此处为显式内连接)
-- 6.查询研发部所有员工的信息及工资等级
-- 思路1：e左外连接d再筛'研发部'(取员工信息)，其结果表再左外连接s表(取等级信息)(连接条件:salary between...and...)
select * from emp1 e left join dept1 d on e.dept_id=d.id;
select e.* from emp1 e left join dept1 d on e.dept_id=d.id where d.name='研发部';
select m.*,s.grade from (select e.* from emp1 e left join dept1 d on e.dept_id=d.id where d.name='研发部') m left join salgrade s on m.salary between s.losal and s.hisal;        -- 联查n张表至少需要n-1个联查条件(两张表两张表的联查)
select a.*,s.grade from (select e.* from emp1 e join dept1 d on e.dept_id=d.id where d.name='研发部') a left join salgrade s on a.salary between s.losal and s.hisal;             -- e表和d表内连接再筛选(需用显式内连接。因为如果用隐式内连接where，筛选也要用到where，两个where会报错)，合成的a表再左外连接s表(连接条件a.salary between s.losal and s.hisal)
-- 思路2：先筛研发部的所有员工信息，其结果表再左外连接s表
select * from emp1 where dept_id =(select id from dept1 where name='研发部');
select m.*,s.grade from (select * from emp1 where dept_id =(select id from dept1 where name='研发部')) m left join salgrade s on m.salary between s.losal and s.hisal;
-- 自我总结：多表联查无非就是两两表之间的连接(内连接外连接，内连接注意用隐式where还是显式join...on...，后面如果有筛选条件where则用显式join)
-- 思路3：三张表隐式内连接(因为三张表相关连接字段的数据都非空所以可用内连接)(e和d的连接条件是dept_id=id，e和s的连接条件是salary在区间)
select e.*, s.grade
from emp1 e,
     dept1 d,
     salgrade s
where e.dept_id = d.id
  and (e.salary between s.losal and s.hisal)
  and d.name = '研发部';                 -- 长语句可格式化命令行(选中语句右击reformat code)                 -- n个表隐式内连接，where之后的至少n-1个条件用and连接

-- 7.查询研发部员工的平均工资
-- 思路1：先在d表取研发部id,再在e表取avg(salary)
select avg(salary) from emp1 e where e.dept_id=(select id from dept1 where name='研发部');
-- 思路2：思路1用到子查询，思路2用e和d内连接，再筛选出研发部，取avg(salary)【注：内连接已经用到where，再筛研发部又要条件查询，多个条件之间用and连接】
select avg(e.salary) from emp1 e,dept1 d where e.dept_id=d.id and d.name='研发部';
-- 8.查询工资比灭绝高的员工信息
-- 思路：先取灭绝工资(得到单个值)；【此处为标量子查询，注意子查询前的类型操作符】
select * from emp1 where salary >(select salary from emp1 where name='灭绝') ;
select salary from emp1 where name='灭绝';
-- 9.查询比平均薪资高的员工信息
-- 思路：先取平均工资(得到单个值，又涉及标量子查询，其前操作符<>=)
select avg(salary) from emp1;
select * from emp1 where salary>(select avg(salary) from emp1);

-- 10.查询低于本部门平均工资的员工信息
select * from emp1 e left join dept1 d on e.dept_id=d.id;
-- 思路：先查询指定部门的平均薪资(将emp1看成两张表)
select avg(salary) from emp1 e where e.dept_id=1;
select avg(salary) from emp1 e where e.dept_id=2;
select * from emp1 e2 where salary<(select avg(salary) from emp1 e1 where e1.dept_id=e2.dept_id);                       -- 执行顺序：由内向外的from→where→group by→having→select→order by→limit。这个SQL查询是关联子查询：对于外层查询的每一行，子查询都会根据当前行的dept_id计算对应部门的平均薪资。外层表和子查询表是逻辑上的同一表，但没有显式连接操作，而是通过子查询动态关联。自连接是同一表的显式连接(join... on...)
-- 自我总结：关联子查询的执行顺序：从外层查询的e2表开始遍历，对每一行(员工记录)都会传递关联值和执行子查询计算平均薪资，然后比较薪资。然后保留或废弃当前行，继续处理下一行直到遍历完e2表。    结论:外层逐行查询→为每行触发子查询→比较→过滤
select e.* from emp1 e join (select dept_id, avg(salary) as avg_salary from emp1 group by dept_id) dept_avg on e.dept_id=dept_avg.dept_id where e.salary < dept_avg.avg_salary;   -- 在这个查询中，子查询里avg(salary)必须起别名，避免外层查询引用的聚合函数的意义不明

select *,(select avg(salary) from emp1 e1 where e1.dept_id=e2.dept_id) from emp1 e2 where salary<(select avg(salary) from emp1 e1 where e1.dept_id=e2.dept_id);  -- 验证：取各部门的平均薪资(将各部门平均薪资放在结果表最后一列)，自己验证结果表是否正确

-- 11.查询所有的部门信息，并统计部门的员工人数
select id,name, id '人数' from dept1;                                                                                    -- 用表现有id字段重建一列(统计人数)，要起上别名
select count(*) from emp1 where dept_id=1;
select d.*, (select count(*) from emp1 e where e.dept_id=d.id)'人数' from dept1 d;                               -- select之后部分也允许有子查询

-- 12.查询所有学生的选课情况，展示出学生名称、学号、课程名称
select * from student;
select * from student_course;
select * from course;
-- 思路1：三张表连接条件(s.id=sc.studentid,sc.courseid=c.id)通过两两表之间的连接条件消除无效笛卡尔积
select s.name,s.no,c.name from student s,student_course sc,course c where s.id=sc.studentid and sc.courseid=c.id;
-- 思路2：两表(隐内连接)合并后的表再和其他表(隐内连接)合并时，有时报错重复字段(只有再和第三张表再合并时触发)，是因刚开始的两表合并表有字段相同，起别名或者根据最终需求删除冗余字段即可
select name,no from student;
select s.name,s.no from student s,student_course sc where s.id=sc.studentid;
select m.name,m.no,c.name from (select s.name,s.no,sc.courseid from student s,student_course sc where s.id=sc.studentid) m,course c where m.courseid=c.id;
-- 思路3：思路2是s和sc连接的合成表，再去连接c；思路3是s连接sc和c的合成表
select * from student_course sc,course c where sc.courseid=c.id;
select s.name,s.no,m.name from student s,(select sc.studentid,c.name from student_course sc,course c where sc.courseid=c.id) m where s.id=m.studentid;   -- 如果子查询是上一个sql语句，会报错“重复字段id”，所以这里对子查询语句进行修改——删除无关字段。(当然也可以起别名，不过子查询的字段太多，不一一起了)
select s.name,s.no,m.c_name from student s,
	(select sc.studentid sc_studentid, sc.courseid sc_courseid, c.id c_id, c.name c_name from student_course sc,course c where sc.courseid=c.id) m 
	where s.id=m.sc_studentid;                                                                                                                            -- 喏，这就是对于子查询生成合成表的字段起别名(小小注意：执行顺序在后的部分也要改别名)



