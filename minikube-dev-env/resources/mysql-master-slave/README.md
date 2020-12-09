

```shell

kubectl run mysql-client --image=mysql:5.7 -i --rm --restart=Never --\
  mysql -h mysql-ms-0.mysql-ms <<EOF
CREATE DATABASE test;
CREATE TABLE test.messages (message VARCHAR(250));
INSERT INTO test.messages VALUES ('hello');
EOF

kubectl run mysql-client --image=mysql:5.7 -i --rm --restart=Never --\
  mysql -h mysql-ms-0.mysql-ms <<EOF
INSERT INTO test.messages VALUES ('world');
INSERT INTO test.messages VALUES ('shaohan');
INSERT INTO test.messages VALUES ('yk');
EOF

kubectl run mysql-client --image=mysql:5.7 -i -t --rm --restart=Never --\
  mysql -h mysql-ms-read -e "SELECT * FROM test.messages"

kubectl run mysql-client --image=mysql:5.7 -i -t --rm --restart=Never --\
  mysql -h mysql-ms-read -e "SELECT *, @@server_id FROM test.messages"

kubectl run mysql-client-loop --image=mysql:5.7 -i -t --rm --restart=Never --\
  bash -ic "while sleep 1; do mysql -h mysql-ms-read -e 'SELECT @@server_id,NOW()'; done"

```