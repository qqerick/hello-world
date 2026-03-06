# Etapa 1: Preparación (usando UBI para cumplimiento de seguridad en OpenShift)
FROM image-registry.openshift-image-registry.svc:5000/openshift/ubi8-openjdk-17-runtime:1.12
USER root
COPY . /home/jboss/source
WORKDIR /home/jboss/source
# Si ya tienes el jar, este paso es solo para organizar
RUN ls -l target/*.jar
COPY --from=builder /home/jboss/source/target/*.jar /deployments/app.jar
EXPOSE 8080
USER 185
ENV JAVA_OPTIONS="-Djava.security.egd=file:/dev/./urandom"

CMD ["java", "-jar", "/deployments/app.jar"]
