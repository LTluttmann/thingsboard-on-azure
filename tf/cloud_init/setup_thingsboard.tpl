#!/bin/bash
sudo apt update

# --------------- setup java ---------------
sudo apt --fix-broken -y install

sudo apt -y install openjdk-11-jdk

sudo update-alternatives --config java


# --------------- setup thingsboard ---------------
wget https://github.com/thingsboard/thingsboard/releases/download/v3.5.1/thingsboard-3.5.1.deb
sudo dpkg -i thingsboard-3.5.1.deb

# config
# DB Configuration 
sudo tee -a /etc/thingsboard/conf/thingsboard.conf > /dev/null <<EOT
export DATABASE_TS_TYPE=sql
export SPRING_DATASOURCE_URL=jdbc:postgresql://${postgres_server_name}.postgres.database.azure.com:5432/thingsboard
export SPRING_DATASOURCE_USERNAME=${postgres_user}
export SPRING_DATASOURCE_PASSWORD=${postgres_pw}
# Specify partitioning size for timestamp key-value storage. Allowed values: DAYS, MONTHS, YEARS, INDEFINITE.
export SQL_POSTGRES_TS_KV_PARTITIONING=MONTHS
EOT

sudo tee -a /etc/thingsboard/conf/thingsboard.conf > /dev/null <<EOT
export TB_QUEUE_TYPE=rabbitmq
export TB_QUEUE_RABBIT_MQ_USERNAME=${rabbitmq_user}
export TB_QUEUE_RABBIT_MQ_PASSWORD=${rabbitmq_pw}
export TB_QUEUE_RABBIT_MQ_HOST=${rabbit_host}
export TB_QUEUE_RABBIT_MQ_PORT=5672
EOT

sudo /usr/share/thingsboard/bin/install/install.sh
sudo service thingsboard start