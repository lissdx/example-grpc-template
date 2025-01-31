TOOLS_DIR := ${CURDIR}/.tools

SHARED_SCRIPTS_DIR=../../../scripts

GOCMD = go

######### SETUP/PRE-REQUIRED #########
.PHONY: prereq
prereq: go-tidy
	$(GOCMD) install \
				github.com/bufbuild/buf/cmd/buf \
				github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
				github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2 \
				google.golang.org/grpc/cmd/protoc-gen-go-grpc \
				google.golang.org/protobuf/cmd/protoc-gen-go
	$(GOCMD) mod tidy

######### PROTO GENERATION #########
.PHONY: generate
generate: clean
	../scripts/generate-proto.sh go

.PHONY: clean
clean:
	@find ./pkg -type f -name "*.pb.go" -delete
	@find ./pkg -type f -name "*.pb.gw.go" -delete
	@find ./pkg -type f -name "*.swagger.json" -delete
	@find ./pkg -type d -empty -not -path "./pkg" -delete

######### GO COMMAND #########
.PHONY: go-get
go-get:
	$(GOCMD) get ./...

.PHONY: go-tidy
go-tidy:
	$(GOCMD) mod tidy

.PHONY: go-get-all-update
go-get-all-update:
	$(GOCMD) get -u -t ./...

.PHONY: upgrade-all-dependencies
upgrade-all-dependencies: go-tidy go-get-all-update
	$(GOCMD) mod tidy