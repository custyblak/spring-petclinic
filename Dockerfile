FROM openjdk:24-ea-17-jdk-bullseye AS BUILD_IMAGE
RUN apt update && apt install maven -y
WORKDIR /usr/src/app/
COPY ./ /usr/src/app/
RUN mvn clean install -DskipTests

FROM openjdk:24-ea-17-jdk-bullseye
WORKDIR /usr/src/app/
COPY --from=BUILD_IMAGE /usr/src/app/target/spring-petclinic*.jar ./spring-petclinic-0.0.1.jar

CMD [ "java", "-jar", "spring-petclinic-0.0.1.jar" ]






