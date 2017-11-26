#!/usr/bin/env bash

mkdir -p ./dist

./node_modules/protobufjs/bin/pbjs \
  -p ./node_modules/protobufjs \
  -t json \
  ./interfaces/*.proto > \
  ./dist/protos.json

# todo: add step to create index.d.ts from protos.json
