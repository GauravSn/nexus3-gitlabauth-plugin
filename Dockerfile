FROM maven:3.5.2 as builder
MAINTAINER cbuchart@auchan.fr
COPY . /build
WORKDIR /build
RUN mvn clean package

FROM sonatype/nexus3:3.17.0
USER root
RUN mkdir -p /opt/sonatype/nexus/system/fr/auchan/nexus3-gitlabauth-plugin/1.1.0/
COPY --from=builder /build/target/nexus3-gitlabauth-plugin-1.1.0.jar /opt/sonatype/nexus/system/fr/auchan/nexus3-gitlabauth-plugin/1.1.0/
COPY --from=builder /build/target/feature/feature.xml /opt/sonatype/nexus/system/fr/auchan/nexus3-gitlabauth-plugin/1.1.0/nexus3-gitlabauth-plugin-1.1.0-features.xml
COPY --from=builder /build/pom.xml /opt/sonatype/nexus/system/fr/auchan/nexus3-gitlabauth-plugin/1.1.0/nexus3-gitlabauth-plugin-1.1.0.pom
RUN echo '<?xml version="1.0" encoding="UTF-8"?><metadata><groupId>fr.auchan</groupId><artifactId>nexus3-gitlabauth-plugin</artifactId><versioning><release>1.1.0</release><versions><version>1.1.0</version></versions><lastUpdated>20170630132608</lastUpdated></versioning></metadata>' > /opt/sonatype/nexus/system/fr/auchan/nexus3-gitlabauth-plugin/maven-metadata-local.xml
RUN echo "mvn\:fr.auchan/nexus3-gitlabauth-plugin/1.1.0 = 200" >> /opt/sonatype/nexus/etc/karaf/startup.properties

USER nexus