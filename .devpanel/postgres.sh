#!/usr/bin/env bash

#Update.
time sudo apt-get update

# Prepare so it works in devpanel also.
sudo apt -y install curl ca-certificates apt-transport-https
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
. /etc/os-release
sudo sh -c "echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
sudo apt-get update

#== Install postgresql on the host.
echo 'PostgreSQL is not installed. Installing it now.'
time sudo apt-get install -y postgresql postgresql-17-pgvector postgresql-client
#== Make it less promiscuous in DDEV only.
if env | grep -q DDEV_PROJECT; then
  sudo chmod 0755 /usr/bin
  sudo chmod 0755 /usr/sbin
  #== Start the PostgreSQL service.
  env PATH="/usr/sbin:/usr/bin:/sbin:/bin" sudo service postgresql start
else
  #== Start the PostgreSQL service.
  sudo service postgresql start
fi
#== Create the user.
sudo su postgres -c "psql -c \"CREATE ROLE db WITH LOGIN PASSWORD 'db';\""
#== Create the database.
sudo su postgres -c "psql -c \"CREATE DATABASE db WITH OWNER db ENCODING 'UTF8' LC_COLLATE='C' LC_CTYPE='C' TEMPLATE template0;\""
#== Enable pgvector extension.
sudo su postgres -c "psql -d db -c \"CREATE EXTENSION IF NOT EXISTS vector;\""

# Make sure that php has pgsql installed.
sudo apt install -y libpq-dev
sudo -E docker-php-ext-install pgsql

# Reload Apache if it's running.
if $PECL_UPDATED && sudo /etc/init.d/apache2 status > /dev/null; then
  sudo /etc/init.d/apache2 reload
fi
