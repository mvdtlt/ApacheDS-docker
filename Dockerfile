FROM debian:jessie

#############################################
# ApacheDS installation
#############################################

#Используемая версия и архитектура 
ENV APACHEDS_VERSION 2.0.0-M24
ENV APACHEDS_ARCH amd64

#Название .deb файла для скачивания с серверов apache
ENV APACHEDS_ARCHIVE apacheds-${APACHEDS_VERSION}-${APACHEDS_ARCH}.deb
ENV APACHEDS_DATA /var/lib/apacheds-${APACHEDS_VERSION}
#user&group
ENV APACHEDS_USER apacheds
ENV APACHEDS_GROUP apacheds
#Путь /var/lib/apacheds-${APACHEDS_VERSION} содержит runtime-информацию, поэтому используется как volume
VOLUME ${APACHEDS_DATA}

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get install -y ldap-utils procps openjdk-7-jre-headless curl \
    && curl http://www.eu.apache.org/dist//directory/apacheds/dist/${APACHEDS_VERSION}/${APACHEDS_ARCHIVE} > ${APACHEDS_ARCHIVE} \
    && dpkg -i ${APACHEDS_ARCHIVE} \
	&& rm ${APACHEDS_ARCHIVE}

#############################################
# ApacheDS bootstrap configuration
#############################################

ENV APACHEDS_INSTANCE default
ENV APACHEDS_BOOTSTRAP /bootstrap
#стандартный конфиг из папки instance
ADD instance/* ${APACHEDS_BOOTSTRAP}/conf/
 
#ldif файл с базовой структурой
ADD sample/* /sample/

RUN mkdir ${APACHEDS_BOOTSTRAP}/cache \
    && mkdir ${APACHEDS_BOOTSTRAP}/run \
    && mkdir ${APACHEDS_BOOTSTRAP}/log \
    && mkdir ${APACHEDS_BOOTSTRAP}/partitions \
    && chown -R ${APACHEDS_USER}:${APACHEDS_GROUP} ${APACHEDS_BOOTSTRAP}

ADD scripts/run.sh /run.sh
RUN chown ${APACHEDS_USER}:${APACHEDS_GROUP} /run.sh \
    && chmod u+rx /run.sh

#############################################
# ApacheDS wrapper command
#############################################
CMD ["/run.sh"]