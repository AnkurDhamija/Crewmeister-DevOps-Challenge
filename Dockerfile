# Build Stage: Use a lightweight Maven image for building
FROM maven:3.8.5-openjdk-17-slim AS build

# Set the working directory
WORKDIR /app

# Copy only necessary files for dependency resolution
COPY pom.xml .


# Download dependencies to cache them
RUN mvn dependency:go-offline -B

# Copy the source code
COPY src ./src

# Build the application (skipping tests for faster builds)
RUN mvn clean package -DskipTests

# Runtime Stage: Use a minimal OpenJDK runtime image
FROM eclipse-temurin:17-jre-alpine

# Add a non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/crewmeisterchallenge-0.0.1-SNAPSHOT.jar /crewmeisterchallenge.jar

# Set permissions to the application JAR
RUN chown appuser:appgroup /crewmeisterchallenge.jar && chmod 500 /crewmeisterchallenge.jar

# Switch to the non-root user
USER appuser

# Expose the application's default port
EXPOSE 8090


# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "/crewmeisterchallenge.jar", "--spring.profiles.active=default"]
