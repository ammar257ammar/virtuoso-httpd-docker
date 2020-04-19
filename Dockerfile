FROM tenforce/virtuoso:1.3.2-virtuoso7.2.5.1 as virtuoso

FROM httpd:2.4 as apache

FROM ubuntu:18.04

USER root

COPY --from=virtuoso /usr/local/virtuoso-opensource /usr/local/virtuoso-opensource

COPY --from=virtuoso /dump_nquads_procedure.sql /dump_nquads_procedure.sql

COPY --from=virtuoso /clean-logs.sh /clean-logs.sh

COPY --from=virtuoso /virtuoso.sh /virtuoso.sh

COPY --from=apache /usr/local/apache2 /usr/local/apache2

COPY --from=apache /usr/local/bin/httpd-foreground /usr/local/bin/httpd-foreground

COPY ./virtuoso.ini /virtuoso.ini

COPY ./load.sh /load.sh

COPY entrypoint.sh /entrypoint.sh

RUN chmod 755 virtuoso.sh
RUN chmod 755 load.sh
RUN chmod 755 entrypoint.sh

RUN apt-get update && \
    apt-get install -yq libreadline7 openssl crudini && \
    ln -s /lib/x86_64-linux-gnu/libreadline.so.7.0 /lib/x86_64-linux-gnu/libreadline.so.6 && \
    apt-get install -yq libssl1.0-dev && \
    apt-get install -yq --no-install-recommends \
		libapr1-dev \
		libaprutil1-dev \
		libaprutil1-ldap

ENV PATH /usr/local/virtuoso-opensource/bin/:$PATH
ENV PATH /usr/local/apache2/bin:$PATH

VOLUME /data
WORKDIR /data
EXPOSE 8890 1111 80 443
 
ENTRYPOINT ["/entrypoint.sh"]
