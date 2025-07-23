# redos-repo-sync

![Docker](https://img.shields.io/badge/Docker-✓-blue.svg)
![RedOS 7.3](https://img.shields.io/badge/RedOS-7.3-green.svg)

Docker-контейнер для синхронизации репозиториев RedOS 7.3

Настройки и скрипт взяты из [База знаний Red-Soft](https://redos.red-soft.ru/base/):

* [Установка и настройка docker](https://redos.red-soft.ru/base/redos-7_3/7_3-administation/7_3-containers/7_3-docker-install/)
* [Создание локального репозитория](https://redos.red-soft.ru/base/redos-7_3/7_3-administation/7_3-repo/7_3-create-repo/)
* [Настройка синхронизации локального репозитория](https://redos.red-soft.ru/base/redos-7_3/7_3-administation/7_3-repo/7_3-update-repo/)

## Возможности

- Автоматическая ежечасная синхронизация репозиториев RedOS:
  - Base (основной)
  - Updates (обновления)
  - Kernels (ядро)
  - Kernels6 (ядро 6 версии)
- HTTP-сервер для доступа к репозиториям
- Подробное логирование
- Оптимизировано для RedOS 7.3

## Быстрый старт

### 1. Сборка Docker-образа

```bash
sudo docker build -t redos-repo-sync .
```

### 2. Запуск контейнера

```bash
sudo docker run -d --name redos-repo-container -p 80:80 redos-repo-sync
```

### 3. Проверка работы

Проверить статус контейнера:
```bash
sudo docker ps
```

Просмотреть логи синхронизации:
```bash
sudo docker logs redos-repo-container
```

## Настройка

### Репозитории
По умолчанию синхронизируются следующие репозитории:
- base (основной)
- updates (обновления)
- kernels (ядро)
- kernels6 (ядро 6 версии)

### Логи
Логи хранятся в:
```
/opt/repo-sync/logs/repo-sync-YYYYMMDD.log
```

### Расписание синхронизации
Синхронизация выполняется ежечасно через cron.

## Технические детали

### Контейнер включает:
- Веб-сервер Apache
- Инструменты reposync и createrepo
- Конфигурации репозиториев RedOS
- Часовой пояс Asia/Yekaterinburg (Екатеринбург)

### Порт:
- 80/tcp (HTTP-доступ к репозиторию)

## Обслуживание

Для ручного запуска синхронизации:
```bash
sudo docker exec redos-repo-container /opt/repo-sync/repo-sync.sh
```

## Требования
- Docker
- Система, совместимая с RedOS 7.3

---

> **Примечание**: Протестировано на RedOS 7.3. Для других версий может потребоваться корректировка идентификаторов репозиториев.
