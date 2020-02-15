ARG SOURCE=debian:buster
FROM ${SOURCE} AS builder

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates git build-essential flex bison bc libssl-dev libelf-dev \
	&& rm -rf /var/lib/apt/lists/*

# this first fetch is independent of the refs we actually want to build so that its layer can be cached
RUN git init /root/linux && cd /root/linux \
	&& git remote add stable git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git \
	&& git remote add hardened https://github.com/anthraxx/linux-hardened.git \
	&& git fetch --all -q

WORKDIR /root/linux

ARG STABLE_REF
ARG HARDENED_REF
# the previous fetch might come from an old cached layer, we fetch again to be sure to have our refs available.
# also, we use the refs arguments to make sure this cache layer is dependent on their values.
RUN git fetch --all -q && git show -s ${STABLE_REF} ${HARDENED_REF}

ARG GIT_EMAIL="builder@localhost"
ARG GIT_NAME="builder"
RUN git config --global user.email ${GIT_EMAIL} && git config --global user.name ${GIT_NAME} \
	&& git checkout -b hardened ${HARDENED_REF} && git rebase ${STABLE_REF}

COPY config-* ./
RUN ./scripts/kconfig/merge_config.sh -m -r -O . config-firecracker config-hardened config-other \
	&& make olddefconfig \
	&& make vmlinux -j8

RUN cp vmlinux .config /boot/ && mkdir -p /lib/modules
FROM scratch
COPY --from=builder /boot /boot
COPY --from=builder /lib/modules /lib/modules
