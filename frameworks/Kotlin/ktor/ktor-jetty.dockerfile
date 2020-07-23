FROM gradle:6.5.1-jdk11 as gradle
WORKDIR /ktor-sources
COPY ktor-sources .
RUN ./gradlew publishJvmPublicationToMavenLocal -PreleaseVersion=1.0.0-benchmark -xdokka -xdokkaJavadoc
WORKDIR ..

FROM maven:3.6.1-jdk-11-slim as maven
WORKDIR /ktor
COPY --from=gradle /root/.m2 /root/.m2
COPY ktor/pom.xml pom.xml
COPY ktor/src src
RUN mvn clean package

FROM openjdk:11.0.3-jdk-stretch
WORKDIR /ktor
COPY --from=maven /ktor/target/tech-empower-framework-benchmark-1.0-SNAPSHOT-jetty-bundle.jar app.jar
CMD ["java", "-server","-XX:+UseNUMA", "-XX:+UseParallelGC", "-XX:+AggressiveOpts", "-XX:+AlwaysPreTouch", "-jar", "app.jar"]
