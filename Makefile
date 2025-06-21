BLUE:=$(shell printf "\033[0;34m")
GREEN:=$(shell printf "\033[0;32m")
YELLOW:=$(shell printf "\033[1;33m")
RED:=$(shell printf "\033[0;31m")
RESET:=$(shell printf "\033[0m")

CHECK=✅
ERROR=❌
INFO=ℹ️
ROCKET=🚀

GRADLE=./gradlew

.PHONY: help
help:
	@echo "${BLUE}Transactional Outbox Demo - Available Commands:${RESET}"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "${YELLOW}%-20s${RESET} %s\n", $$1, $$2}'

.PHONY: docker-build
docker-build: ## Build the application Docker image
	@echo "${BLUE}${ROCKET} Building application Docker image...${RESET}"
	docker compose build app
	@echo "${GREEN}${CHECK} Application Docker image built successfully!${RESET}"

.PHONY: docker-up
docker-up: ## Start all Docker containers
	@echo "${BLUE}${ROCKET} Starting Docker containers...${RESET}"
	@if ! command -v docker >/dev/null 2>&1; then \
		echo "${RED}${ERROR} Docker is not installed${RESET}"; \
		exit 1; \
	fi
	docker compose up -d
	@echo "${GREEN}${CHECK} Docker containers started successfully!${RESET}"
	@echo "${YELLOW}${INFO} Kafka is available at localhost:29092${RESET}"
	@echo "${YELLOW}${INFO} Redpanda Console is available at http://localhost:8080${RESET}"
	@echo "${YELLOW}${INFO} Application is available at http://localhost:8084${RESET}"

.PHONY: docker-down
docker-down: ## Stop and remove all Docker containers
	@echo "${BLUE}${INFO} Stopping Docker containers...${RESET}"
	docker compose down -v
	@echo "${GREEN}${CHECK} Docker containers stopped successfully!${RESET}"

.PHONY: docker-ps
docker-ps: ## List running Docker containers
	@echo "${BLUE}${INFO} Listing running Docker containers...${RESET}"
	docker compose ps

.PHONY: docker-logs
docker-logs: ## Show Docker container logs (use SERVICE=container_name for specific container)
	@echo "${BLUE}${INFO} Showing Docker container logs...${RESET}"
	@if [ -z "$(SERVICE)" ]; then \
		docker compose logs -f; \
	else \
		docker compose logs -f $(SERVICE); \
	fi

.PHONY: docker-restart
docker-restart: ## Restart all Docker containers
	@echo "${BLUE}${ROCKET} Restarting Docker containers...${RESET}"
	docker compose down
	docker compose up -d
	@echo "${GREEN}${CHECK} Docker containers restarted successfully!${RESET}"

.PHONY: create-connector
create-connector: ## Create the Debezium connector for PostgreSQL
	@echo "${BLUE}${ROCKET} Creating connector...${RESET}"
	@status_code=$$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" --data @connector-config.json http://localhost:8083/connectors); \
	if [ $$status_code -eq 201 ]; then \
		echo "${GREEN}${CHECK} Connector created successfully! (HTTP $$status_code)${RESET}"; \
	else \
		echo "${RED}${ERROR} Failed to create connector. (HTTP $$status_code)${RESET}"; \
		exit 1; \
	fi

.PHONY: call-demo
call-demo: ## Send a POST request to the demo endpoint
	@echo "${BLUE}${ROCKET} Sending POST request to demo endpoint...${RESET}"
	@status_code=$$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:8084/demo); \
	if [ $$status_code -eq 202 ]; then \
		echo "${GREEN}${CHECK} Request successful! (HTTP $$status_code)${RESET}"; \
	else \
		echo "${RED}${ERROR} Request failed. (HTTP $$status_code)${RESET}"; \
		exit 1; \
	fi
