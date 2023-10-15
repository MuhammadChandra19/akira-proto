#!/bin/sh

PROTO_DIR=proto
OUTPUT_DIR=go

rm -rf ${OUTPUT_DIR}/modules

echo "Generatin proto for modules:"
for module_path in ${PROTO_DIR}/modules/*/; do
  module=$(basename ${module_path})

  for domain_path in ${PROTO_DIR}/modules/${module}/*/; do
    domain=$(basename ${domain_path})

    for version_path in ${PROTO_DIR}/modules/${module}/${domain}/*/; do
      version=$(basename ${version_path})

      for api_path in ${PROTO_DIR}/modules/${module}/${domain}/${version}/; do
        api=$(basename ${api_path})

        # input: ../proto/modules/module-name/domain-name/version/api-type/xxx.proto
        # output:
        #   - modules/module-name/domain-name/version/api-type/xxx.pb.go
        #   - modules/module-name/domain-name/version/api-type/xxx_grpc.pb.go

        echo -n "  $api_path..., $api"
        protoc -I ${PROTO_DIR} \
        --go_out=${OUTPUT_DIR} \
        --go_opt=paths=source_relative \
        --go-grpc_out=${OUTPUT_DIR} \
        --go-grpc_opt=paths=source_relative \
        ${api_path}/*.proto

        # input: modules/module-name/domain-name/version/api-type/xxx_grpc.pb.go
        # output:
        #   - modules/module-name/domain-name/version/api-type/mock/xxx_mock.go
        cd go

        mock_dir=modules/${module}/${domain}/${version}/mock
        for proto_path in modules/${module}/${domain}/${version}/*; do
          proto=$(basename ${proto_path})
          if echo "${proto_path}" | grep -Eq '.*\_grpc\.pb\.go'; then
            mkdir -p ${mock_dir}
            mockgen -source=${proto_path} -package=mock > ${mock_dir}/${proto%_grpc.pb.go}_mock.go
          fi
        done

        echo " Done."
      done
    done
  done
done


go mod tidy && go mod vendor