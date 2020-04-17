
RELEASE ?= 20.04

all: build

build:
	docker build \
		-t paulgrandperrin/ignite-hardened-ubuntu:${RELEASE} \
		-t paulgrandperrin/ignite-hardened-ubuntu:latest \
		--build-arg RELEASE=${RELEASE} \
		.

push: build
	docker login
	docker push paulgrandperrin/ignite-hardened-ubuntu

