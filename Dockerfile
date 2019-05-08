FROM centos:6
MAINTAINER Adrian Kriel <admin@extremeshok.com>

ENV OS_LOCALE="en_US.UTF-8"

ENV LANG=${OS_LOCALE}
ENV LANGUAGE=${OS_LOCALE}
ENV LC_ALL=${OS_LOCALE}

WORKDIR /tmp/

RUN yum install -y wget

RUN wget -O - http://install.hostbillapp.com/hbmonitoring/install.sh | /bin/bash

EXPOSE 8082

# add local files
COPY ./rootfs/ /

RUN chmod 744 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
