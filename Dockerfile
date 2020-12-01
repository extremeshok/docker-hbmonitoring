FROM centos:8
MAINTAINER Adrian Kriel <admin@extremeshok.com>

ENV OS_LOCALE="en_US.UTF-8"

ENV LANG=${OS_LOCALE}
ENV LANGUAGE=${OS_LOCALE}

RUN dnf -y module enable nodejs:10

RUN dnf -y install nodejs redhat-lsb wget unzip nmap

RUN npm install forever -g

RUN echo "*** node ***" \
&& rpm -i https://rpm.nodesource.com/pub_0.10/el/6/x86_64/nodesource-release-el6-1.noarch.rpm \
&& yum install -y nodejs \
&& npm install -g forever

RUN echo "*** hbmonitoring ***" \
&& useradd -m nodemonit \
&& wget -O /tmp/hbmonitoring.zip http://install.hostbillapp.com/hbmonitoring/hbmonitoring_remote.zip \
&& mkdir -p /home/nodemonit/uptime \
&& unzip -o /tmp/hbmonitoring.zip -d /home/nodemonit/uptime \
&& chown -R nodemonit:nodemonit /home/nodemonit/uptime \
&& cd /home/nodemonit/uptime && su nodemonit -c "npm install"

RUN rm -f /tmp/hbmonitoring.zip

RUN cd /home/nodemonit/uptime \
&& su nodemonit -c "npm install"

EXPOSE 8082

WORKDIR /home/nodemonit/uptime/

# add local files
COPY ./rootfs/ /

RUN chmod 744 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
