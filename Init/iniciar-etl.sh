#!/usr/bin/expect

# Obter o IP público
set IP_PUBLICO [exec curl -s http://checkip.amazonaws.com]


# Iniciar o contêiner Java, caso não esteja rodando
spawn sudo docker start container-etl
expect "container-etl"

# Iniciar o comando para rodar o JAR dentro do contêiner
spawn bash -c "sudo docker exec -i container-etl java -jar /app/beyond_ETL/ETLbba/target/BeyondETL.jar"

expect -re "TOKEN_SLACK:" {
    send "\r"
}

expect -re "BD_HOST:" {
    send "$IP_PUBLICO\r"
}

expect -re "BD_DATABASE:" {
    send "beyond_db\r"
}

expect -re "BD_PASSWORD:" {
    send "urubu100\r"
}

expect -re "BD_PORT:" {
    send "3306\r"
}

expect -re "BUCKET_NAME:" {
    send "bu-beyond-etl\r"
}

expect -re "BD_USER:" {
    send "root\r"
}

# Esperar o processo terminar
interact
