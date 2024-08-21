FROM php:5.6-apache

RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    sed -i 's/security.debian.org\/debian-security/archive.debian.org\/debian-security/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y apt-utils iputils-ping openssh-client rsync netcat cron sudo --no-install-recommends

RUN ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N ""

COPY index.php /var/www/html/index.php
COPY cronjob /etc/cron.d/cronjob
COPY date.sh /usr/local/bin/date.sh
COPY ./backup/backup.sh /usr/local/bin/backup.sh

RUN chown -R www-data:www-data /var/www/html/
RUN chmod 777 /usr/local/bin/date.sh
RUN chmod 0644 /etc/cron.d/cronjob
RUN chmod +x /usr/local/bin/backup.sh

RUN crontab /etc/cron.d/cronjob

EXPOSE 80

CMD ["/bin/bash", "-c", "service cron start && apache2-foreground"]
