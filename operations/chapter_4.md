# 簡易手順書 4章

# トランザクションとは何か？

## 概要
- SQLを実行してみる

## SQLを実行してみる

### トランザクションではない場合
```
mysql -h 127.0.0.1 -u batch_user -pbatch batch_dev
delete from ranks;
delete from users;
insert into users (id, name) values (1, 'ユーザーA');
insert into users (id, name) values (2, 'ユーザーB');

(別のターミナルで)
mysql -h 127.0.0.1 -u batch_user -pbatch batch_dev
select * from users;

```

### トランザクションを使う場合
```
mysql -h 127.0.0.1 -u batch_user -pbatch batch_dev
begin;
insert into users (id, name) values (3, 'ユーザーC');
insert into users (id, name) values (4, 'ユーザーD');
update users set name = 'ユーザー1' where id = 1;
delete from users where id = 2;
insert into user_scores (user_id, score, received_at) values (1, 10, NOW());
select * from users;

(別のターミナルで)
mysql -h 127.0.0.1 -u batch_user -pbatch batch_dev
select * from users;

(前のターミナルに戻って)
commit;

(別のターミナルで)
select * from users;
```

### ロールバックを試す

```
mysql -h 127.0.0.1 -u batch_user -pbatch batch_dev

delete from users;
insert into users (id, name) values (1, 'ユーザーA');
insert into users (id, name) values (2, 'ユーザーB');

begin;
insert into users (id, name) values (3, 'ユーザーC');
insert into users (id, name) values (4, 'ユーザーD');
update users set name = 'ユーザー1' where id = 1;
delete from users where id = 2;
insert into user_scores (user_id, score, received_at) values (1, 10, NOW());
select * from users;

rollback;

select * from users;
```

### タイムアウトを発生させてみる

```
(ターミナルA)

begin;
update users set name = 'ユーザー123' where id = 1;

(ターミナルB)
begin;
update users set name = 'ユーザー111' where id = 1;
ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction
```

### デッドロックを発生させてみる

```
(ターミナルA)

begin;
update users set name = 'ユーザー123' where id = 1;

(ターミナルB)
begin;
update users set name = 'ユーザー234' where id = 2;

(ターミナルA)
update users set name = 'ユーザー222' where id = 2;

(ターミナルB)
update users set name = 'ユーザー111' where id = 1;
ERROR 1213 (40001): Deadlock found when trying to get lock; try restarting transaction
```
