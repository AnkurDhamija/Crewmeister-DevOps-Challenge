FROM openjdk:17-jdk-alpine
COPY ./target/crewmeisterchallenge-0.0.1-SNAPSHOT.jar /crewmeisterchallenge.jar
EXPOSE 8090
ENTRYPOINT ["java", "-jar", "/crewmeisterchallenge.jar", "--spring.profiles.active=default" ]