
SHELL=/bin/bash
SUDO=sudo
IMG_DH=wolnosciowiec/dokuwiki
IMG_QUAY=quay.io/riotkit/dokuwiki
PUSH=true

help:
	@grep -E '^[a-zA-Z\-\_0-9\.@]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: ## Build all versions
	set -xe; \
	for version in $$(find ./versions -type f -name '*.json'); do \
		make build VERSION=$$(basename -s .json $$version); \
		make clean; \
	done

build: ## Build a specifc version (VERSION parameter required. Possible values: old-stable, snapshot, stable. See "versions" directory)
	set -xe; \
	./notify.sh "$SLACK_URL" "Building dokuwiki version: ${VERSION}"; \
	\
	url=$$(jq -r '.URL' versions/${VERSION}.json); \
	from=$$(jq -r '.FROM_IMAGE' versions/${VERSION}.json); \
	\
	wget $$url -O ./application.tar.gz; \
	\
	real_version=$$(tar --list --no-recursion --file=./application.tar.gz --exclude="*/*");\
	real_version=$${real_version/splitbrain-dokuwiki-/}; \
	real_version=$${real_version/dokuwiki-/}; \
	real_version=$${real_version/\//}; \
	tag=${VERSION}-$${real_version}; \
	\
	${SUDO} docker build . -f ./Dockerfile --build-arg VERSION=$$tag --build-arg FROM_IMAGE=$$from -t ${IMG_DH}:$${tag}; \
	${SUDO} docker tag ${IMG_DH}:$${tag} ${IMG_QUAY}:$${tag}; \
	\
	${SUDO} docker tag ${IMG_DH}:$${tag} ${IMG_DH}:${VERSION}; \
	${SUDO} docker tag ${IMG_DH}:$${tag} ${IMG_QUAY}:${VERSION}; \
	\
	${SUDO} docker tag ${IMG_DH}:$${tag} ${IMG_DH}:latest; \
	${SUDO} docker tag ${IMG_DH}:$${tag} ${IMG_QUAY}:latest; \
	\
	\
	\
	if [[ "${PUSH}" == "true" ]]; then \
		${SUDO} docker push ${IMG_DH}:$${tag}; \
		${SUDO} docker push ${IMG_QUAY}:$${tag}; \
		\
		${SUDO} docker push ${IMG_DH}:${VERSION}; \
		${SUDO} docker push ${IMG_QUAY}:${VERSION}; \
		\
		${SUDO} docker push ${IMG_DH}:latest; \
		${SUDO} docker push ${IMG_QUAY}:latest; \
	fi; \
	\
	./notify.sh "${SLACK_URL}" "[OK] built dokuwiki version: $${tag}"


clean: ## Clean up build files
	rm -f ./Dockerfile application.tar.gz
