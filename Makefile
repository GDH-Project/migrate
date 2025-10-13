# 환경 변수 로드
include .env
MIGRATION_DIR = migrations
MIGRATE_CLI = migrate -source file:./$(MIGRATION_DIR) -database $(DB_URL)

%:
	@true

ARG1 = $(word 2, $(MAKECMDGOALS))

.PHONY: create
create: # 마이그레이션 생성
	@if [ -z "$(ARG1)" ]; then \
	    echo "Error: 마이그레이션의 name 이 지정되지 않았습니다."; \
	    echo "(make create <마이그레이션명>)"; \
	    echo "ex) make create user"; \
		exit 1; \
	fi
	@migrate create -ext sql -dir $(MIGRATION_DIR) -seq $(ARG1)

.PHONY: up
up: # 마이그레이션 up 실행
#	@if [ -z "$(ARG1)" ]; then \
#		echo "Error: 마이그레이션의 타겟 번호가 지정되지 않았습니다."; \
#		echo "(make up 1 <마이그레이션 번호>)"; \
#		echo "ex) make up 1"; \
#		exit 1; \
#	fi
	@$(MIGRATE_CLI) up $(ARG1)

.PHONY: down
down: # 마이그레이션 down 실행
#	@if [ -z "$(ARG1)" ]; then \
#		echo "Error: 마이그레이션의 타겟 번호가 지정되지 않았습니다."; \
#		echo "(make down 1 <마이그레이션 번호>)"; \
#		echo "ex) make down 1"; \
#		exit 1; \
#	fi
	@$(MIGRATE_CLI) down $(ARG1)

.PHONY: force
force: # 마이그레이션 force 실행
	@if [ -z "$(ARG1)" ]; then \
		echo "Error: 마이그레이션의 타겟 번호가 지정되지 않았습니다."; \
		echo "(make force 1 <마이그레이션 번호>)"; \
		echo "ex) make force 1"; \
		exit 1; \
	fi
	@$(MIGRATE_CLI) force $(ARG1)

.PHONY: version
version: # 마이그레이션 상태 표시
	@$(MIGRATE_CLI) version