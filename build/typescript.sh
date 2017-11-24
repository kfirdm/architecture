#!/usr/bin/env bash

mkdir -p ./dist/typescript

# generate js codes via grpc-tools
./node_modules/.bin/grpc_tools_node_protoc \
--js_out=import_style=commonjs,binary:./dist/typescript \
--grpc_out=./dist/typescript \
--plugin=protoc-gen-grpc=./node_modules/grpc-tools/bin/grpc_node_plugin \
-I ./interfaces \
./interfaces/*.proto ./interfaces/primitives/*.proto

# generate d.ts codes
./node_modules/grpc-tools/bin/protoc \
--plugin=protoc-gen-ts=./node_modules/.bin/protoc-gen-ts \
--ts_out=./dist/typescript \
-I ./interfaces \
./interfaces/*.proto ./interfaces/primitives/*.proto
