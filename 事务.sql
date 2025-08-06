-- ------------------------ 事务操作------------------------------------------------------------------
drop table account;
create table account(
    id int auto_increment primary key comment'主键ID',
    name varchar(10) comment'姓名',
    money int comment'余额'
)comment'账户表';
insert into account values(null,'张三',2000),(null,'李四',2000);                                                          -- 数据准备-- 恢复数据
select * from account;

-- 转账操作(张三给李四转账1000)
-- (1)查询张三账户余额
select * from account where name='张三';
-- (2)将张三账户余额-1000
update account set money=money-1000 where name='张三';
程序执行报错...
-- (3)将李四账户的余额+1000
update account set money=money+1000 where name='李四';                                               -- 加了“程序抛出异常”，(一般自上而下执行SQL语句)就会发现张三余额-1000但李四没有+1000(因为卡在“程序抛出异常”)，因此要将这三条语句放在一个事务内(现在的三条sql语句各是一个事务)



SET SQL_SAFE_UPDATES = 0;                                                                            -- MySQL中用于“临时禁用安全更新模式” (默认:set SQL_SAFE_UPDATE=1是“启用安全更新模式”)
update account set money=2000 where name='张三' or name='李四';
update account set money=2000;
update account set money=2000 where name in('张三','李四');                                          -- (三种方法)恢复account表中两人的money均为2000。这里的in是一个多用途操作符：可以用在子查询前，也可以直接用于值列表
select * from account;



select @@autocommit;    -- 查看事务提交方式：1为自动提交（默认，每条SQL语句作为一个独立事务提交），0为手动提交
set @@autocommit=0;     -- 设置为手动提交。重点注意：只要设置了手动提交，此后任何的语句执行操作必须要commit
-- (1)查询张三账户余额
select * from account where name='张三';
-- (2)将张三账户余额-1000
update account set money=money-1000 where name='张三';
-- (3)将李四账户的余额+1000
update account set money=money+1000 where name='李四';

-- 提交事务(事务操作正常，就可以执行commit操作了)
commit;                                                                                                                 -- 设置手动提交→进行正常转账的事务操作→执行成功点commit→刷新account表可看到转账成功(数据变更)
-- 回滚事务(事务操作异常，要执行rollback操作)
rollback;                                                                                                               -- 先恢复张三李四都是2000的数据，设置手动提交→进行异常转账的事务操作→执行有问题点rollback→刷新account表可看到转账失败(数据未变均为2000)




-- 不修改事务提交方式，如何控制事务？介绍第二种方式：手动地开启、提交、回滚事务
set @@autocommit=1;    -- 设置/恢复为默认的自动提交
select @@autocommit;   -- 检查是否设置成功
start transaction;     -- 开启事务
-- (1)查询张三账户余额
select * from account where name='张三';
-- (2)将张三账户余额-1000
update account set money=money-1000 where name='张三';
程序执行报错...
-- (3)将李四账户的余额+1000
update account set money=money+1000 where name='李四';
commit;               -- 事务执行成功则提交事务
rollback;             -- 事务执行失败则回滚事务                                                                             -- 这里只演示了事务操作异常的例子：start transaction和事务操作一起执行(发现抛出异常)→rollback→刷新account表可看到数据未变【注：执行事务异常操作后若没执行rollback，表数据不会变。因为一旦执行了开始事务，就必须有闭环操作commit/rollback，否则这一系列的操作不会生效】


select * from account;


-- --事务隔离级别----------------------------------------------------------------------------------
select @@transaction_isolation;                               -- 查看事务隔离级别(MySQL默认的是repeatable read)
set session transaction isolation level read uncommitted;     -- 设置当前会话界面(session)的事务隔离级别(transaction isolation level)
set session transaction isolation level repeatable read;      -- 把当前会话界面的事务隔离级别改回默认
-- 开两个客户端(开两个命令行windows+r→cmd)模拟并发事务




