# Use the official OpenJDK image with Java 22
FROM openjdk:22-jdk-slim

# Expose the port that the Spring Boot app will run on
EXPOSE 8080

# Copy the built JAR file from the previous image stage
COPY ./build/libs/spring.demo-0.0.1-SNAPSHOT.jar /usr/app/

# Set the working directory inside the container
WORKDIR /usr/app

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "spring.demo-0.0.1-SNAPSHOT.jar"]
