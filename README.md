# Home Todo - Under Construction

# Under Construction

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

Copy database.yml from database.yml.sample

```
cp config/database.yml.sample config/database.yml
```

Add datbase credentials to config/database.yml

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Docker Build and Run

## Docker Build and Run

1. Build image
`docker build -t home_todo .`
2. Run image
```
docker run -it --rm --name home_todo -p 3000:3000 \
  -e SECRET_KEY_BASE=<<Your Secret Key Base>> \
  -e DATABASE_URL="mysql2://<<Your User>>:<<Your Password>>@host.docker.internal/home_todo_production" \
  -e RAILS_SERVE_STATIC_FILES=true \
  home_todo
```

* ...
