# Spring Demo - REST API Project

A modern Spring Boot 3.3.2 REST API application demonstrating Spring Boot best practices with Java 22, Docker containerization, and CI/CD integration.

**Original Source:** https://spring.io/guides/gs/rest-service
**Purpose:** GitHub Continuous Integration Implementation with Docker and GitHub Actions

---

## 📋 Quick Summary

This is a production-ready Spring Boot REST API with two endpoints that demonstrate:
- RESTful web service design
- JSON response serialization
- Query parameter handling
- Thread-safe request counting
- Modern Java features (Records)
- Docker containerization
- Automated CI/CD pipeline

---

## 🔧 Tech Stack

- **Framework:** Spring Boot 3.3.2
- **Language:** Java 22
- **Build Tool:** Gradle 8.x with Wrapper
- **Server:** Embedded Apache Tomcat
- **JSON Processing:** Jackson (via Spring Boot Starter Web)
- **Testing:** JUnit 5, Spring Boot Test
- **Containerization:** Docker (OpenJDK 22)
- **CI/CD:** GitHub Actions

---

## 📁 Project Structure

```
spring-demo/
├── src/main/java/com/layesh/spring/demo/
│   ├── Application.java          # Main Spring Boot application
│   ├── GreetingController.java   # REST controller
│   └── Greeting.java             # Data model (Java Record)
├── src/main/resources/
│   └── application.properties    # Configuration
├── src/test/java/
│   └── ApplicationTests.java     # Integration tests
├── .github/workflows/
│   └── ci.yml                    # GitHub Actions pipeline
├── build.gradle                  # Build configuration
├── Dockerfile                    # Container definition
└── README.md
```

---

## 🎯 API Endpoints

### 1. Hello Endpoint (Plain Text)
```
GET /hello?name=YourName
```
- Returns: Plain text greeting
- Default: "Hello World!"
- Example: `GET /hello?name=John` → "Hello John!"

### 2. Greeting Endpoint (JSON)
```
GET /greeting?name=YourName
```
- Returns: JSON object with ID and message
- Includes auto-incrementing counter
- Default: `{"id": 1, "content": "Hello, World!"}`
- Example: `GET /greeting?name=Jane` → `{"id": 2, "content": "Hello, Jane!"}`

---

## 💻 Key Code Examples

### Application.java
Main entry point with embedded REST endpoint:

```java
package com.layesh.spring.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @GetMapping("/hello")
    public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
        return String.format("Hello %s!", name);
    }
}
```

**Key Points:**
- `@SpringBootApplication` - Enables auto-configuration and component scanning
- `@RestController` - Marks class as REST API controller
- `@GetMapping` - Maps HTTP GET requests to handler method
- `@RequestParam` - Binds query parameter with default value

---

### GreetingController.java
Dedicated controller with JSON response:

```java
package com.layesh.spring.demo;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetingController {

    private static final String template = "Hello, %s!";
    private final AtomicLong counter = new AtomicLong();

    @GetMapping("/greeting")
    public Greeting greeting(@RequestParam(value = "name", defaultValue = "World") String name) {
        return new Greeting(counter.incrementAndGet(), String.format(template, name));
    }
}
```

**Key Points:**
- `AtomicLong` - Thread-safe counter for concurrent requests
- Returns `Greeting` object (automatically serialized to JSON by Jackson)
- Demonstrates proper REST controller separation

---

### Greeting.java
Data model using modern Java Record:

```java
package com.layesh.spring.demo;

public record Greeting(long id, String content) {}
```

**Key Points:**
- Java Record (Java 14+) - Immutable data carrier
- Automatically generates: constructor, getters, equals(), hashCode(), toString()
- Concise syntax replacing traditional POJO boilerplate
- Perfectly suited for DTOs (Data Transfer Objects)

---

## 🚀 How to Run

### Using Gradle
```bash
# Build the project
./gradlew build

# Run the application
./gradlew bootRun

# Run tests
./gradlew test
```

### Using Java
```bash
# Build JAR
./gradlew build

# Run JAR
java -jar build/libs/spring.demo-0.0.1-SNAPSHOT.jar
```

### Using Docker
```bash
# Build Docker image
docker build -t spring-demo .

# Run container
docker run -p 8080:8080 spring-demo
```

### Access the Application
- Hello Endpoint: http://localhost:8080/hello
- Greeting Endpoint: http://localhost:8080/greeting

---

## 🧪 Testing

### ApplicationTests.java
```java
package com.layesh.spring.demo;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ApplicationTests {

    @Test
    void contextLoads() {
    }
}
```

**Key Points:**
- `@SpringBootTest` - Loads full application context for integration testing
- Verifies Spring Boot configuration is valid
- Foundation for adding more comprehensive tests

---

## 🐳 Docker Configuration

### Dockerfile
```dockerfile
FROM openjdk:22-jdk-slim
WORKDIR /app
COPY build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Key Points:**
- Uses official OpenJDK 22 slim image (lightweight)
- Exposes port 8080 (Spring Boot default)
- Single-stage build (requires pre-built JAR)

---

## ⚙️ CI/CD Pipeline

GitHub Actions workflow (`.github/workflows/ci.yml`) automatically:

1. **Triggers on:**
   - Push to `master` branch
   - Pull requests

2. **Build Steps:**
   - Checkout code
   - Setup JDK 22 (Eclipse Temurin)
   - Cache Gradle dependencies
   - Build with Gradle
   - Build and push Docker image to Docker Hub
   - Submit dependencies for Dependabot tracking

---

## 📊 Configuration

### build.gradle
```gradle
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.3.2'
    id 'io.spring.dependency-management' version '1.1.6'
}

group = 'com.layesh'
version = '0.0.1-SNAPSHOT'

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(22)
    }
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}
```

### application.properties
```properties
spring.application.name=spring.demo
```

---

## 🎓 Interview Talking Points

### Spring Boot Concepts
- **Auto-configuration:** Spring Boot automatically configures beans based on classpath
- **Embedded Server:** No need for external Tomcat - server is bundled in JAR
- **Starter Dependencies:** `spring-boot-starter-web` includes Spring MVC, Tomcat, Jackson
- **Convention over Configuration:** Minimal setup required

### REST API Design
- **HTTP Methods:** Using GET for read operations
- **Query Parameters:** Optional parameters with default values
- **Content Negotiation:** Automatic JSON serialization via Jackson
- **Stateless:** Each request is independent (counter is for demo purposes)

### Modern Java Features
- **Records:** Immutable data carriers (Java 14+)
- **Type Inference:** `var` keyword support (Java 10+)
- **Text Blocks:** Multi-line string literals (Java 15+)

### Thread Safety
- **AtomicLong:** Lock-free thread-safe counter
- **Concurrent Requests:** Spring handles multiple requests with thread pool

### DevOps Best Practices
- **Containerization:** Docker for consistent deployment
- **CI/CD:** Automated builds and deployments
- **Dependency Management:** Gradle for reproducible builds
- **Version Control:** Git with feature branches

---

## 🔍 Testing the API

### Using curl
```bash
# Test hello endpoint
curl http://localhost:8080/hello
curl http://localhost:8080/hello?name=Interview

# Test greeting endpoint
curl http://localhost:8080/greeting
curl http://localhost:8080/greeting?name=SpringBoot
```

### Expected Responses
```bash
# /hello
Hello World!
Hello Interview!

# /greeting
{"id":1,"content":"Hello, World!"}
{"id":2,"content":"Hello, SpringBoot!"}
```

---

## 📚 Additional Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Building a RESTful Web Service](https://spring.io/guides/gs/rest-service)
- [Spring Boot with Docker](https://spring.io/guides/gs/spring-boot-docker)
- [Java Records Guide](https://docs.oracle.com/en/java/javase/22/language/records.html)

---

## 📝 Notes

- Project is a **SNAPSHOT** version (0.0.1-SNAPSHOT) - indicates active development
- Uses latest Spring Boot 3.x (requires Java 17+)
- Java 22 features enabled but can be downgraded if needed
- Production-ready structure suitable for microservices architecture
