#Информация
В файле sample/sample.ldif содержится базовая структура записей. ldif-файл добавляется в образ на этапе билда, его импорт может быть произведен вручную (см. далее).
В папке instance хранится базовый конфиг для ApacheDS, его не нужно трогать без необходимости.
При выходе новой версии ApacheDS для добавления ее в образ необходимо:
1. При необходимости сделать бэкап текущей структуры записей.
2. Изменить переменные в докерфайле (в соответствии с новым названием скачиваемого с сайта пакета) и заново собрать образ.
3. Заменить файл sample.ldif на бэкап структуры из п.1.
4. Собрать образ.
#Build
docker build -t pmi/apacheds /ApacheDS-docker
#Запуск
docker run --name ldap -d -p 389:10389 pmi/apacheds
#Импорт базовой структуры из ldif-файла (опционально):
docker exec ldap ldapadd -v -h localhost:10389 -c -x -D uid=admin,ou=system -w secret -f /sample/sample.ldif
#Настройка
Логин и пароль админа:
uid=admin,ou=system 
secret 
Пароль должен быть изменен по этой инструкции https://directory.apache.org/apacheds/basic-ug/1.4.2-changing-admin-password.html