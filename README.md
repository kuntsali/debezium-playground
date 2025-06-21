# Transactional Outbox Demo

A demonstration project implementing the Transactional Outbox pattern with Spring Boot, PostgreSQL, Debezium and Kafka.

## Tech Stack

- **Spring Boot** 
- **PostgreSQL**
- **Kafka**
- **Debezium**

## Setup & Run

### Prerequisites

- Docker and Docker Compose
- JDK 21
- Gradle (or use included wrapper)

### Quick Start

1. Build the application:
```bash
make docker-build
```

2. Start the environment:
```bash
make docker-up
```

3. Test the application by sending a request:
```bash
make call-demo
```

4. View logs:
```bash
# All containers
make docker-logs

# Specific container
make docker-logs SERVICE=app
```

5. Stop everything:
```bash
make docker-down
```

### Available Commands

Run `make help` to see all available commands.

## How It Works

1. REST endpoint receives requests
2. Service creates data in the main table and the outbox table in a single transaction
3. Debezium PostgreSQL connector captures changes from the outbox table via PostgreSQL's logical replication
4. Events are published to Kafka topics

## Monitoring

- **Redpanda Console**: http://localhost:8080
- **Application**: http://localhost:8084
- **Kafka Connect**: http://localhost:8083

## Project Structure

- `src/main/java` - Java source code
- `src/main/resources/db/migration` - Flyway database migrations
- `connector-config.json` - Debezium connector configuration
- `docker-compose.yml` - Container configuration
- `Dockerfile` - Dockerfile for application
