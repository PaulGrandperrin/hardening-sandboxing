KERNEL_BRANCH ?= 5.5

STABLE_REF ?= $(shell git ls-remote --exit-code git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git refs/heads/linux-${KERNEL_BRANCH}.y| cut -c1-12)
HARDENED_REF ?= $(shell git ls-remote --exit-code https://github.com/anthraxx/linux-hardened.git refs/heads/${KERNEL_BRANCH}| cut -c1-12)

all: build

build:
	docker build \
		-t paulgrandperrin/ignite-kernel-hardened:${KERNEL_BRANCH}-${STABLE_REF}-${HARDENED_REF} \
		-t paulgrandperrin/ignite-kernel-hardened:${KERNEL_BRANCH} \
		-t paulgrandperrin/ignite-kernel-hardened:latest \
		--build-arg STABLE_REF=${STABLE_REF} \
		--build-arg HARDENED_REF=${HARDENED_REF} \
		.

push: build
	docker login
	docker push paulgrandperrin/ignite-kernel-hardened

