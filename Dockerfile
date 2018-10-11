FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG JAR
COPY ${JAR} app.jar
ENTRYPOINT ["java","-jar", "app.jar"]