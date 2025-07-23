#!/bin/bash

DESTDIR="/var/www/html/repo/red-os-7.3"
REPOIDS="base updates kernels kernels6"
LOG_DIR="/opt/repo-sync/logs"
LOG_FILE="$LOG_DIR/repo-sync-$(date +%Y%m%d).log"
WORKERS=4

mkdir -p "$LOG_DIR"
exec >> "$LOG_FILE" 2>&1

# Логирование начала
echo "###########################################"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Начало синхронизации"
echo "Используемые репозитории: $REPOIDS"

dnf clean all

if ! dnf makecache; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Ошибка: не удалось обновить кеш метаданных"
  exit 1
fi

for REPOID in $REPOIDS; do
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Обработка репозитория: $REPOID"

  if [[ -d $DESTDIR/$REPOID/.repodata ]]; then
    rm -rf $DESTDIR/$REPOID/.repodata
  fi

  if ! reposync --repo $REPOID \
    --newest-only \
    --downloadcomps \
    --download-metadata \
    --delete \
    -p $DESTDIR; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Предупреждение: проблемы с синхронизацией $REPOID"
  fi

  if [[ -f $DESTDIR/$REPOID/comps.xml ]]; then
    createrepo --update $DESTDIR/$REPOID -g comps.xml --workers $WORKERS
  else
    createrepo --update $DESTDIR/$REPOID --workers $WORKERS
  fi
done

echo "$(date '+%Y-%m-%d %H:%M:%S') - Синхронизация успешно завершена"
echo "###########################################"
