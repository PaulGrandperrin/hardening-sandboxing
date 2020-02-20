KERNEL_BRANCH ?= 5.5

GREGKH_REF ?= $(shell git ls-remote --exit-code git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git refs/heads/linux-${KERNEL_BRANCH}.y| cut -c1-12)
ANTHRAXX_REF ?= $(shell git ls-remote --exit-code https://github.com/anthraxx/linux-hardened.git refs/heads/${KERNEL_BRANCH}| cut -c1-12)

all: build

build:
	docker build \
		-t paulgrandperrin/ignite-hardened-kernel:${KERNEL_BRANCH}-gregkh_${GREGKH_REF}-anthraxx_${ANTHRAXX_REF} \
		-t paulgrandperrin/ignite-hardened-kernel:${KERNEL_BRANCH} \
		-t paulgrandperrin/ignite-hardened-kernel:latest \
		--build-arg GREGKH_REF=${GREGKH_REF} \
		--build-arg ANTHRAXX_REF=${ANTHRAXX_REF} \
		.

push: build
	docker login
	docker push paulgrandperrin/ignite-hardened-kernel

