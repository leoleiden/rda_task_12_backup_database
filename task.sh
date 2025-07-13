#! /bin/bash

# Ці змінні DB_USER та DB_PASSWORD передаються з команди docker exec

MYSQL_HOST="localhost"
DB_SOURCE="ShopDB"
DB_TARGET_RESERVE="ShopDBReserve"
DB_TARGET_DEVELOPMENT="ShopDBDevelopment"
BACKUP_FILE="/tmp/shopdb_backup.sql" # Тимчасовий файл всередині контейнера

echo "Виконується повне резервне копіювання ${DB_SOURCE} та відновлення до ${DB_TARGET_RESERVE} та ${DB_TARGET_DEVELOPMENT}..."

# 1. Виконати резервне копіювання бази даних ShopDB за допомогою mysqldump
# Використовуємо користувача 'backup' та його пароль
mysqldump --add-drop-table --host=${MYSQL_HOST} --user="${DB_USER}" --password="${DB_PASSWORD}" "${DB_SOURCE}" > "${BACKUP_FILE}"

# Перевірка, чи mysqldump був успішним
if [ $? -eq 0 ]; then
    echo "Резервне копіювання ${DB_SOURCE} успішне. ✅"

    # 2. Відновити дані до ShopDBReserve
    echo "Відновлення даних до ${DB_TARGET_RESERVE}..."
    mysql --host=${MYSQL_HOST} --user="${DB_USER}" --password="${DB_PASSWORD}" "${DB_TARGET_RESERVE}" < "${BACKUP_FILE}"

    if [ $? -eq 0 ]; then
        echo "Відновлення до ${DB_TARGET_RESERVE} успішне. ✅"
    else
        echo "Помилка при відновленні до ${DB_TARGET_RESERVE}. ❌"
        exit 1
    fi

    # 3. Відновити дані до ShopDBDevelopment
    echo "Відновлення даних до ${DB_TARGET_DEVELOPMENT}..."
    mysql --host=${MYSQL_HOST} --user="${DB_USER}" --password="${DB_PASSWORD}" "${DB_TARGET_DEVELOPMENT}" < "${BACKUP_FILE}"

    if [ $? -eq 0 ]; then
        echo "Відновлення до ${DB_TARGET_DEVELOPMENT} успішне. ✅"
    else
        echo "Помилка при відновленні до ${DB_TARGET_DEVELOPMENT}. ❌"
        exit 1
    fi

else
    echo "Помилка при повному резервному копіюванні ${DB_SOURCE}. ❌"
    exit 1
fi