FROM registry.red-soft.ru/ubi7/ubi

ENV TZ=Asia/Yekaterinburg
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Устанавливаем пакеты
RUN dnf update -y && dnf install -y httpd createrepo yum-utils cronie redos-kernels-release redos-kernels6-release && dnf clean all

# Настраиваем httpd
RUN sed -i_lrepo_bak '/<Directory "\/var\/www\/html">/,/<\/Directory>/{/Includes/! s/^\([^#]*Options.*\).*$/\1 Includes/}' /etc/httpd/conf/httpd.conf

# Создаём структуру каталогов
RUN mkdir -p /var/www/html/repo/ && \
    mkdir -p /opt/repo-sync/ && \
    chmod 755 /opt/repo-sync && \
    chown -R apache:apache /var/www/html/repo/

# Копируем скрипт
COPY repo-sync.sh /opt/repo-sync/repo-sync.sh

# Настраиваем права
RUN chmod +x /opt/repo-sync/repo-sync.sh

# Настраиваем cron
RUN (crontab -l 2>/dev/null; echo "0 * * * * /opt/repo-sync/repo-sync.sh") | crontab -

EXPOSE 80/tcp

# Запускаем Apache и cron при старте контейнера
CMD ["sh", "-c", "httpd -DFOREGROUND & crond -n"]
