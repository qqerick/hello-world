# Usamos una imagen base oficial de Java basada en Red Hat UBI (Universal Base Image)
FROM registry.access.redhat.com/ubi9/openjdk-17-runtime:1.18

# Definir variables de entorno
ENV JAVA_HOME=/usr/lib/jvm/jre-17-openjdk \
    CUSTOM_CERT_PATH=/deployments/certs/mi-certificado.crt \
    KEYSTORE_PATH=/deployments/certs/custom-cacerts.jks \
    KEYSTORE_PASSWORD=changeit

USER root

# Crear directorio para certificados y asignar propiedad al UID del usuario sin privilegios
# Red Hat OpenShift usa UID dinámico, por lo que asignamos permisos al grupo 0 (root-group)
RUN mkdir -p /deployments/certs && \
    chown -R 185:0 /deployments/certs && \
    chmod -R g+rwX /deployments/certs

# Copiar el certificado y la aplicación JAR al contenedor
COPY --chown=185:0 mi-certificado.crt ${CUSTOM_CERT_PATH}
COPY --chown=185:0 target/*.jar /deployments/app.jar

# Volver al usuario sin privilegios (UID 185 es el usuario 'jboss/default' en UBI)
USER 185

# Importar el certificado al Truststore JKS durante la construcción del contenedor
RUN keytool -importcert -trustcacerts \
    -file ${CUSTOM_CERT_PATH} \
    -alias mi-certificado-ca \
    -keystore ${KEYSTORE_PATH} \
    -storepass ${KEYSTORE_PASSWORD} \
    -noprompt

EXPOSE 8080

# Ejecutar la aplicación Java apuntando al nuevo Truststore con las CAs personalizadas
ENTRYPOINT ["java", \
            "-Djavax.net.ssl.trustStore=/deployments/certs/custom-cacerts.jks", \
            "-Djavax.net.ssl.trustStorePassword=changeit", \
            "-jar", "/deployments/app.jar"]
