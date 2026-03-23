# spring-test

A Spring Boot 4 application with REST API, PostgreSQL (via JDBC + Hibernate), and Kafka integration.

## Tech Stack

- Java 25
- Spring Boot 4
- Spring Web MVC
- Spring Data JPA / Hibernate
- PostgreSQL 17
- Apache Kafka 4
- Lombok

## Prerequisites

Choose one of the two infrastructure options:

| Tool | Local dev | Kubernetes |
|------|-----------|------------|
| Docker / Podman + Compose | required | — |
| kubectl + minikube | — | required |
| Java 25 | required | required |
| Maven 3.x (or use `./mvnw`) | required | required |

## Running locally with Docker / Podman Compose

### 1. Start infrastructure

```bash
docker compose up -d
# or
podman-compose up -d
```

This starts:
- PostgreSQL 17 on `localhost:5432`
- Kafka broker on `localhost:9092`

### 2. Build and run the application

```bash
./mvnw spring-boot:run
```

### 3. Stop infrastructure

```bash
docker compose down
# or
podman-compose down
```

---

## Running with Kubernetes (minikube)

### 1. Start minikube and deploy dependencies

```bash
./scripts/start.sh
```

This starts minikube and deploys PostgreSQL and Kafka into the cluster, waiting until both are ready.

### 2. Build and run the application

Configure your `application.properties` to point to the minikube services, then:

```bash
./mvnw spring-boot:run
```

### 3. Stop minikube

```bash
./scripts/stop.sh
```

---

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Verify the application is running |

### Example

```bash
curl http://localhost:8080/health
# OK
```

---

## Project Structure

```
.
├── docker-compose.yml          # Local infrastructure (Postgres + Kafka)
├── k8s/
│   ├── postgres.yml            # Kubernetes Postgres deployment
│   └── kafka.yml               # Kubernetes Kafka deployment
├── scripts/
│   ├── start.sh                # Start minikube + deploy dependencies
│   └── stop.sh                 # Stop minikube
└── src/
    └── main/
        ├── java/org/hejnaluk/springtest/
        └── resources/
            └── application.properties
```
