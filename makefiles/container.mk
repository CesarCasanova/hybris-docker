## CONTAINER VARS ##
TAG_DEV			= dev
DOCKER_NETWORK 	= $(OWNER)_network
CONTAINER_NAME 	= $(PROJECT_NAME)_backend
IMAGE_RUNTIME	= $(PROJECT_NAME):$(TAG_DEV)

## USER PERMISSION
USERNAME_LOCAL  ?= "$(shell whoami)"
UID_LOCAL  		?= "$(shell id -u)"
GID_LOCAL  		?= "$(shell id -g)"

## CONTAINER TARGETS ##
build: ## Build docker image for development: make build
	@docker build -f docker/runtime/Dockerfile \
		--build-arg USERNAME_LOCAL=$(USERNAME_LOCAL) \
		--build-arg UID_LOCAL=$(UID_LOCAL) \
		--build-arg GID_LOCAL=$(UID_LOCAL) \
		-t $(IMAGE_RUNTIME) docker/runtime/

up: verify_network ## Start the project: make up
	@docker-compose -p $(PROJECT_NAME) up -d
	@make log

down: ## Destroy the project: make down
	@docker-compose -p $(PROJECT_NAME) down

log: ## Show project logs: make log
	@docker logs -f  $(CONTAINER_NAME)

ssh: ## Access the docker container: make ssh
	@docker run -it --rm -v "${PWD}/${APP_DIR}":/src/${APP_DIR} --entrypoint="" $(IMAGE_RUNTIME) bash

task:
	@docker run -it --rm \
		-u ${UID_LOCAL}:${GID_LOCAL} \
		-v "${PWD}/${APP_DIR}":/src/${APP_DIR} \
		-w "/src/${APP_DIR}/bin/platform" \
		--net $(DOCKER_NETWORK) \
		--entrypoint="" $(IMAGE_RUNTIME) \
		sh -c '. ./setantenv.sh && ant $(TASK)'

clean:
	@docker run -it --rm \
		-u ${UID_LOCAL}:${GID_LOCAL} \
		-v "${PWD}/${APP_DIR}":/src/${APP_DIR} \
		-w "/src/${APP_DIR}/bin/platform" \
		--net $(DOCKER_NETWORK) \
		--entrypoint="" $(IMAGE_RUNTIME) \
		sh -c '. ./setantenv.sh && ant clean'

all:
	@docker run -it --rm \
		-u ${UID_LOCAL}:${GID_LOCAL} \
		-v "${PWD}/${APP_DIR}":/src/${APP_DIR} \
		-w "/src/${APP_DIR}/bin/platform" \
		--net $(DOCKER_NETWORK) \
		--entrypoint="" $(IMAGE_RUNTIME) \
		sh -c '. ./setantenv.sh && ant all'

initialize:
	@docker run -it --rm \
		-u ${UID_LOCAL}:${GID_LOCAL} \
		-v "${PWD}/${APP_DIR}":/src/${APP_DIR} \
		-w "/src/${APP_DIR}/bin/platform" \
		--net $(DOCKER_NETWORK) \
		--entrypoint="" $(IMAGE_RUNTIME) \
		sh -c '. ./setantenv.sh && ant initialize'

remove:
	@docker-compose rm -v
