FROM gradle:8.6-jdk21 AS build

WORKDIR /app

# Copy gradle files for dependency caching
COPY gradle/ gradle/
COPY build.gradle settings.gradle gradlew ./
RUN chmod +x ./gradlew

# Download dependencies
RUN ./gradlew dependencies --no-daemon

# Copy source code
COPY src/ src/

# Build the application
RUN ./gradlew build --no-daemon -x test

FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy build artifacts from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
