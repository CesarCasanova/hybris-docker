.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:

## GENERAL VARS ##
ENV 			?= dev
OWNER 			= lumingo
SERVICE_NAME 	= trails
APP_DIR  		= hybris

## RESULT_VARS ##
DOCKER_NETWORK 	= ${OWNER}_network
PROJECT_NAME 	= ${OWNER}-${ENV}-${SERVICE_NAME}

## INCLUDE TARGETS ##
include makefiles/container.mk
include makefiles/services.mk

## DEVELOPER TARGETS ##
development: build build-services ## Prepare the project for development: make development
	@echo "The development environment is ready and running"

verify_network:
	@if [ -z $$(docker network ls | grep $(DOCKER_NETWORK) | awk '{print $$2}') ]; then\
		(docker network create $(DOCKER_NETWORK));\
	fi

## HELP TARGET ##
help:
	@printf "\033[31m%-22s %-59s %s\033[0m\n" "Target" " Help" "Usage"; \
	printf "\033[31m%-22s %-59s %s\033[0m\n"  "------" " ----" "-----"; \
	grep -hE '^\S+:.*## .*$$' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' | sort | awk 'BEGIN {FS = ":"}; {printf "\033[32m%-22s\033[0m %-58s \033[34m%s\033[0m\n", $$1, $$2, $$3}'
