FROM openjdk:11-jdk as build
COPY McKessonEnterpriseRootCA1.crt $JAVA_HOME/lib/security
RUN \
    cd $JAVA_HOME/lib/security \
    && keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias ldapcert -file McKessonEnterpriseRootCA1.crt
VOLUME /tmp
COPY . .
RUN ./gradlew clean build
FROM openjdk:11-jdk
WORKDIR /app
COPY --from=build build/libs/*.jar app.jar
ARG JAR_FILE
ENTRYPOINT ["java", "-jar", "app.jar"]
EXPOSE 8080