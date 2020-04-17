KERNEL_BRANCH ?= 5.6

GREGKH_REF ?= $(shell git ls-remote --exit-code git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git refs/heads/linux-${KERNEL_BRANCH}.y| cut -c1-12)
ANTHRAXX_REF ?= $(shell git ls-remote --exit-code https://github.com/anthraxx/linux-hardened.git refs/heads/${KERNEL_BRANCH}| cut -c1-12)

all: build

config-firecracker:
	curl https://raw.githubusercontent.com/firecracker-microvm/firecracker/master/resources/microvm-kernel-x86_64.config -o config-firecracker

build: config-firecracker
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

clean:
	rm -rf config-firecracker
