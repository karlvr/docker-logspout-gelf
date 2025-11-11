IMAGE=karlvr/logspout-gelf

.PHONY: build
build:
	docker buildx build --platform=linux/aarch64 --pull . -t $(IMAGE):latest
	docker buildx build --platform=linux/amd64 --pull . -t $(IMAGE):latest

.PHONY: push
push:
	docker push $(IMAGE):latest

.PHONY: run
run:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock $(IMAGE):latest
