# from https://www.drupal.org/requirements/php#drupalversions
FROM drupal:7
STOPSIGNAL SIGWINCH

RUN apt-get update && apt-get upgrade -y

COPY apache2.conf /etc/apache2/apache2.conf
RUN chmod 644 /etc/apache2/apache2.conf

COPY settings-env.php /var/www/html/sites/default/settings.php
RUN chmod -w /var/www/html/sites/default/settings.php

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

RUN mkdir /var/www/html/sites/default/files

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]

