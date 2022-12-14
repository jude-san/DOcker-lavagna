#! /bin/sh

check=""

is_db_up() {
  echo "Checking if DB is up ..."
  check=$(nc -z -n -v $MYSQL_HOST $MYSQL_PORT 2>&1 | grep open)
  echo $check
}

start_up() {
  java -Xms64m -Xmx128m -Ddatasource.dialect="${DB_DIALECT}" \
    -Ddatasource.url="${DB_URL}" \
    -Ddatasource.username="${DB_USER}" \
    -Ddatasource.password="${DB_PASS}" \
    -Dspring.profiles.active="${SPRING_PROFILE}" \
  	-jar lavagna-jetty-console.war --headless
}

is_db_up

while [ -z "$check" ]; do
  # check again
  echo "Waiting for 5s ..."
  sleep 5s
  is_db_up
done

start_up