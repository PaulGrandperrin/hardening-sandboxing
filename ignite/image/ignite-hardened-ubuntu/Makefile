
RELEASE ?= 20.04

all: build

build:
	docker build \
		-t paulgrandperrin/ignite-ubuntu:${RELEASE} \
		-t paulgrandperrin/ignite-ubuntu:latest \
		--build-arg RELEASE=${RELEASE} \
		.

push: build
	docker login
	docker push paulgrandperrin/ignite-ubuntu

