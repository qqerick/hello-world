# Etapa 1: Preparación (usando UBI para cumplimiento de seguridad en OpenShift)
FROM registry.redhat.io/ubi8/openjdk-11:latest AS builder
USER root
COPY . /home/jboss/source
WORKDIR /home/jboss/source
# Si ya tienes el jar, este paso es solo para organizar
RUN ls -l target/*.jar

# Etapa 2: Imagen de ejecución (ligera)
FROM openjdk-21:latest
LABEL maintainer="DevOps Team"

# Copiamos solo el artefacto de la etapa anterior
COPY --from=builder /home/jboss/source/target/*.jar /deployments/app.jar

EXPOSE 8080
USER 185
ENV JAVA_OPTIONS="-Djava.security.egd=file:/dev/./urandom"

CMD ["java", "-jar", "/deployments/app.jar"]
