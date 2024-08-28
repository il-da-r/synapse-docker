# Сервер Synapse (Matrix) c web-клиентом (Element) и admin-панелью (synapse-admin) + turn-сервер

Копируем все файлы вида filename.example в filename и заполняем своими данными.

При установке необходимо создать образец файла конфигурации сервера. Запускаем одноразовый контейнер, чтобы сгенерировать образец файла конфигурации.

```
docker compose run --rm -e SYNAPSE_SERVER_NAME=mydomain.com -e SYNAPSE_REPORT_STATS=no synapse generate
```

### Редактируем файл synapse/homeserver.conf

Разрешаем подключение с любого адреса на порт 8008:

```
listeners:
  - port: 8008
    bind_addresses:
      - '0.0.0.0'
```

меняем раздел ответственный за подключение к базе данных:

```
database:
  name: psycopg2
  txn_limit: 10000
  args:
    user: synapse
    password: passwordfordb
    database: synapse
    host: synapse_db
    port: 5432
    cp_min: 5
    cp_max: 10
```

Добавляем подключение к coturn:

```
turn_uris: [ "turn:domain.com:3478?transport=udp", "turn:domain.com:3478?transport=tcp" ]
turn_shared_secret: "secret"
turn_user_lifetime: 86400000
turn_allow_guests: False
```

### Получаем сертификаты letsencrypt

```
docker compose run --rm -p 80:80 -p 443:443 --entrypoint  "certbot certonly" certbot
```

### Запускаем остальные контейнеры

```
docker compose up -d
```

### Создаем первого пользователя 

Первого пользователя создаем с правами админа. Остальных можно будет создать в веб-интерфейсе

```
docker exec -it synapse /bin/bash
register_new_matrix_user -c /data/homeserver.yaml

```


### Сервисы доступны по следующим адресам:

Для клиента Elenment для устройств: mydomain.com
Была проблема при подключении к прямому домену без поддоменов с десктопного клиента. Поэтому сделал:  mydomain.com/element. Можно использовать на клиенте если Element считает Url домена не валидным.

Web-клиент:
https://mydomain.com/matrixclient

Админ-панель:
https://mydomain.com/matrixadmin
