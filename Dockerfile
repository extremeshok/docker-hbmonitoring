FROM centos:6
MAINTAINER Adrian Kriel <admin@extremeshok.com>

ENV OS_LOCALE="en_US.UTF-8"

ENV LANG=${OS_LOCALE}
ENV LANGUAGE=${OS_LOCALE}
ENV LC_ALL=${OS_LOCALE}

RUN yum install -y wget unzip gcc-c++ make
# git openssl-devel redhat-lsb

RUN echo "*** mongodb ***" \
echo -e "[10gen]\nname=10gen Repository\nbaseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64\ngpgcheck=0\nenabled=1\n" >> /etc/yum.repos.d/10gen.repo \
yum install -y mongo-10gen mongo-10gen-server \
echo 'nohttpinterface = true' >> /etc/mongod.conf \
service mongod restart \
chkconfig mongod on

RUN echo "*** node ***" \
rpm -i https://rpm.nodesource.com/pub_0.10/el/6/x86_64/nodesource-release-el6-1.noarch.rpm \
yum install -y nodejs

#download script, unzip it
RUN echo "*** hbmonitoring ***" \
useradd -m nodemonit \
cd /tmp \
wget -O /tmp/hbmonitoring.zip http://install.hostbillapp.com/hbmonitoring/hbmonitoring_remote.zip \
mkdir -p /home/nodemonit/uptime \
unzip -o /tmp/hbmonitoring.zip -d /home/nodemonit/uptime \
chown -R nodemonit:nodemonit /home/nodemonit/uptime \
rm -f /tmp/hbmonitoring.zip \
cd /home/nodemonit/uptime \
su nodemonit -c "npm install"

EXPOSE 8082

WORKDIR /home/nodemonit/uptime/

# add local files
COPY ./rootfs/ /

RUN chmod 744 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
