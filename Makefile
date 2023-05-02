GREP = grep
SED = sed

ASDF_RELEASE ?= v$(shell curl -s https://api.github.com/repos/asdf-vm/asdf/releases | $(GREP) -oE 'tag_name": ".{1,15}",' | $(SED) 's/tag_name\": \"v//;s/\",//' | $(GREP) -vE '^(0\.[12]\.|0\.3\.0$$)' | $(SED) 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$$/.z/; G; s/\n/ /' | LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $$2}' | tail -n1)
DEBIAN_TAG ?= $(shell docker run --rm gcr.io/go-containerregistry/crane ls debian | $(GREP) -P '^bullseye-[0-9]+$$' | sort -r | head -n1)
VERSION ?= asdf-$(ASDF_RELEASE:v%=%)-$(DEBIAN_TAG)

REVISION ?= $(shell git rev-parse HEAD)
BUILDDATE ?= $(shell TZ=GMT date '+%Y-%m-%dT%R:%S.%03NZ')

IMAGE_NAME ?= debian-asdf
LOCAL_REPO ?= localhost:5000/$(IMAGE_NAME)
DOCKER_REPO ?= localhost:5000/$(IMAGE_NAME)
PLATFORM ?= linux/amd64

.PHONY: help
help:
	@echo "$(IMAGE_NAME)"
	@echo
	@echo Targets:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9._-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

define print-target
	@printf "Executing target: \033[36m$@\033[0m\n"
endef

.PHONY: all
all: build push
all: ## Build and push.

.PHONY: build
build: ## Build a local image without publishing artifacts.
	$(call print-target)
	docker buildx build --platform=$(PLATFORM) \
	--build-arg ASDF_RELEASE=$(ASDF_RELEASE) \
	--build-arg DEBIAN_TAG=$(DEBIAN_TAG) \
	--build-arg VERSION=$(VERSION) \
	--build-arg REVISION=$(REVISION) \
	--build-arg BUILDDATE=$(BUILDDATE) \
	--tag $(LOCAL_REPO) \
	.

.PHONY: push
push: ## Publish to container registry.
	$(call print-target)
	docker tag $(LOCAL_REPO) $(DOCKER_REPO):$(VERSION)
	docker push $(DOCKER_REPO):$(VERSION)
	docker tag $(LOCAL_REPO) $(DOCKER_REPO):asdf-$(ASDF_RELEASE:v%=%)
	docker push $(DOCKER_REPO):asdf-$(ASDF_RELEASE:v%=%)
	docker tag $(LOCAL_REPO) $(DOCKER_REPO):latest
	docker push $(DOCKER_REPO):latest

.PHONY: test
test: ## Test local image
	$(call print-target)
	docker run --platform=$(PLATFORM) --rm -t $(LOCAL_REPO) bash -c "asdf version" | $(GREP) ^v

.PHONY: info
info: ## Show information about version
	@echo "Version:           ${VERSION}"
	@echo "Revision:          ${REVISION}"
	@echo "Build date:        ${BUILDDATE}"
