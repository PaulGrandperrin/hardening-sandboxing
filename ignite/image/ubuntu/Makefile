all: build

build:
	docker build \
		-t paulgrandperrin/ignite-ubuntu:20.04 \
		-t paulgrandperrin/ignite-ubuntu:latest \
		--build-arg RELEASE=20.04 \
		https://raw.githubusercontent.com/weaveworks/ignite/master/images/ubuntu/Dockerfile

push: build
	docker login
	docker push paulgrandperrin/ignite-ubuntu

