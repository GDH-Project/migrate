# Database Schema 저장소

## 사전 준비

> 반드시 [migrate cli](https://github.com/golang-migrate/migrate/tree/master/cmd/migrate)와 `make`가 설치되어 있어야 한다.

시작하기 앞서 `.env` 파일에 DB_URL 항목을 작성한다.

```dotenv
DB_URL="postgresql://id:passwrd@host:port/db"
```

> ex) DB_URL="postgresql://psql:psql@localhost:5432/psql?sslmode=disable"

## 명령어

### make create <마이그레이션 작업명>

> 마이그레이션 파일을 만드는 명령어이다.

예시

```shell
make create user_trigger
```

위 명령어를 실행하면 `migrations`경로에 `XXXXXX_user_trigger_schema.down.sql, XXXXXX_user_trigger_schema.up.sql` 2개 파일이 만들어 진다.

`*.up.sql` 파일에는 새로 생성될 SQL를 작성하면 된다.
`*.down.sql` 파일에는 롤백시 적용할 SQL를 작성하면 된다.

### make up | make up <마이그레이션 갯수>

> db에 마이그레이션을 진행하는 명령어이다.
> 실패시 dirty 플래그가 지정된다.

모든 마이그레이션 진행

```shell
make up
```

마이그레이션 2개 진행

```shell
make up 2
```

### make down | make down <롤백 갯수>

> 마이그레이션을 롤백 하는 명령어이다.
> 실패시 force를 통해 버전을 강제 지정후 직접 스키마 차이를 처리해야 한다.

모든 롤백 진행

```shell
make down
```

롤백 2개 진행

```shell
make down 2
```

### make force <마이그레이션 파일 번호>

> 강제로 현재 version을 특정 버전으로 변경하고 dirty 플래그를 제거한다.
> 실제로 스키마가 변경되는게 아니기 때문에 down 실패시 발생한 오류는 직접 해결해야한다.

000002_** 버전 sql로 버전 고정

```shell
make force 2
```