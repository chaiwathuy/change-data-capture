FROM foogaro/fedora29-openjdk1.8.0.201.b098
RUN mkdir -p /opt/rh
WORKDIR /opt/rh
RUN curl -O http://downloads.jboss.org/infinispan/9.4.9.Final/infinispan-server-9.4.9.Final.zip
RUN unzip infinispan-server-9.4.9.Final.zip
RUN rm -rf infinispan-server-9.4.9.Final.zip
WORKDIR /opt/rh/infinispan-server-9.4.9.Final
RUN ./bin/add-user.sh -s -e -cw -u admin -p admin.2019
RUN ./bin/add-user.sh -s -e -cw -a -u user -p user.2019

RUN ls -la standalone/configuration


COPY local-caches-configuration.cli .
COPY local-caches.cli .
RUN ls -la
RUN cat standalone/configuration/standalone.xml
RUN ./bin/ispn-cli.sh --file=local-caches-configuration.cli
RUN ./bin/ispn-cli.sh --file=local-caches.cli
RUN ls -la standalone/configuration
RUN cat standalone/configuration/standalone.xml
RUN rm -rf standalone/configuration/standalone_xml_history
RUN ls -la standalone/configuration

#COPY listener-*.jar infinispan-listener.jar
#RUN ./bin/ispn-cli.sh --command="module add --name=com.foogaro.cdc.infinispan.listener --resources=infinispan-listener.jar --dependencies=org.infinispan"
#RUN sed -i 's/<dependencies>/<dependencies><module name=\"com.foogaro.cdc.infinispan.listener\"\/>/g' modules/system/add-ons/ispn/org/infinispan/ispn-9.4/module.xml
#RUN cat modules/system/add-ons/ispn/org/infinispan/ispn-9.4/module.xml

EXPOSE 8080 9990 11222
ENTRYPOINT ["./bin/standalone.sh"]
CMD ["-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
