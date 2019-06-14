## SERVICES VARS ##
TAG_MYSQL 			= mysql
TAG_SOLR5			= solr5
IMAGE_MYSQL			= ${PROJECT_NAME}:${TAG_MYSQL}
IMAGE_SOLR5			= ${PROJECT_NAME}:${TAG_SOLR5}
CONTAINER_NAME_SOLR5 = ${PROJECT_NAME}_solr5
CONTAINER_NAME_MYSQL = ${PROJECT_NAME}_mysql

## MYSQL LOCAL VARS ##
MYSQL_ROOT_PASSWORD = 123456
DATABASES			= ${OWNER}_hybris_trails

## SERVICES TARGETS ##
build-services: ## Build all needed services
	@make build-mysql

build-mysql: ## Build docker image for mysql
	@docker build -f docker/mysql/Dockerfile -t $(IMAGE_MYSQL) docker/mysql/

clear-mysql:
	@for dbname in $(DATABASES); do \
		echo "DROP: $$dbname"; \
		docker exec -e MYSQL_PWD=${MYSQL_ROOT_PASSWORD} -i $(PROJECT_NAME)_mysql mysql -uroot -e "DROP DATABASE IF EXISTS $$dbname"; \
	done

restore-mysql:
	@make clear-mysql
	@cd docker/mysql/initdb && \
		find -iname '*.sql' \
		-exec docker exec -e MYSQL_PWD=${MYSQL_ROOT_PASSWORD} $(PROJECT_NAME)_mysql \
			sh -c 'mysql -uroot < docker-entrypoint-initdb.d/{}' \; \
		-exec echo {} \;

backup-db:
	$(eval DATE = `date +'%Y%m%d'`)
	$(eval VERSION := none)

	@mkdir -p ./tmp
	@for dbname in $(DATABASES); do \
		echo "DUMP: $$dbname"; \
		docker exec -it $(PROJECT_NAME)_mysql sh -c "mysqldump --triggers --routines --databases $$dbname" > ./tmp/$$dbname.sql; \
	done
	@sed -i 's/DEFINER=[^ ]* / /' ./tmp/*.sql
