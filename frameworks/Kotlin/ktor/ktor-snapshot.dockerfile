FROM gradle:7.1.1-jdk11 as gradle
WORKDIR /ktor-sources
COPY ktor-sources .
RUN ./gradlew publishJvmPublicationToMavenLocal -PreleaseVersion=1.0.0-benchmark
WORKDIR ..

FROM maven:3.6.1-jdk-11-slim as maven
WORKDIR /ktor
COPY --from=gradle /root/.m2 /root/.m2
COPY ktor-snapshot/pom.xml pom.xml
COPY ktor-snapshot/src src
RUN mvn clean package -q

FROM openjdk:11.0.3-jdk-stretch
WORKDIR /ktor
COPY --from=maven /ktor/target/tech-empower-framework-benchmark-1.0-SNAPSHOT-netty-bundle.jar app.jar

EXPOSE 9090

CMD ["java", "-server","-XX:+UseNUMA", "-XX:+UseParallelGC", "-XX:+AggressiveOpts", "-XX:+AlwaysPreTouch", "-jar", "app.jar"]
