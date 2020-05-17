.PHONY: build
build:
	docker build . -t karlvr/logspout-gelf

.PHONY: push
push:
	docker push karlvr/logspout-gelf
