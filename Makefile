OPERATOR_NAME  := grafana-operator
VERSION := $(shell date +%Y%m%d%H%M)
ACCOUNT = ${ACCOUNT:-tsloughter}
IMAGE := $(ACCOUNT)/$(OPERATOR_NAME)

.PHONY: install_deps build build-image

install_deps:
	glide install

build:
	rm -rf bin/%/$(OPERATOR_NAME)
	go build -v -i -o bin/$(OPERATOR_NAME) ./cmd

bin/%/$(OPERATOR_NAME):
	rm -rf bin/%/$(OPERATOR_NAME)
	GOOS=$* GOARCH=amd64 go build -v -i -o bin/$*/$(OPERATOR_NAME) ./cmd

build-image: bin/linux/$(OPERATOR_NAME)
	docker build . -t $(IMAGE):$(VERSION)
