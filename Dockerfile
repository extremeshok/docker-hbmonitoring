FROM centos:6
MAINTAINER Adrian Kriel <admin@extremeshok.com>

ENV OS_LOCALE="en_US.UTF-8"

ENV LANG=${OS_LOCALE}
ENV LANGUAGE=${OS_LOCALE}
ENV LC_ALL=${OS_LOCALE}

RUN yum install -y wget unzip gcc-c++ make nc

RUN echo "*** node ***"
RUN rpm -i https://rpm.nodesource.com/pub_0.10/el/6/x86_64/nodesource-release-el6-1.noarch.rpm
RUN yum install -y nodejs
RUN npm install -g forever

RUN echo "*** hbmonitoring ***"
RUN useradd -m nodemonit
RUN wget -O /tmp/hbmonitoring.zip http://install.hostbillapp.com/hbmonitoring/hbmonitoring_remote.zip
RUN mkdir -p /home/nodemonit/uptime
RUN unzip -o /tmp/hbmonitoring.zip -d /home/nodemonit/uptime
RUN chown -R nodemonit:nodemonit /home/nodemonit/uptime
RUN cd /home/nodemonit/uptime && su nodemonit -c "npm install"

RUN rm -f /tmp/* \
rm -rf /tmp/*.* \
yum clean -y all

EXPOSE 8082

WORKDIR /home/nodemonit/uptime/

# add local files
COPY ./rootfs/ /

RUN chmod 744 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
