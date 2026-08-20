# Usamos una imagen base oficial de Java basada en Red Hat UBI (Universal Base Image)
FROM registry.access.redhat.com/ubi9/openjdk-17-runtime:1.18
USER root
# Si ya tienes el jar, este paso es solo para organizar
RUN ls -ltr /
RUN pwd

COPY --chown=185:0 target/*.jar /deployments/app.jar
RUN ls -ltr
#COPY --from=builder /home/jboss/source/target/*.jar /deployments/app.jar
EXPOSE 8080
USER 185
ENV JAVA_OPTIONS="-Djava.security.egd=file:/dev/./urandom"

CMD ["java", "-jar", "/deployments/app.jar"]

