#!/bin/sh

PROTO_DIR=proto
OUTPUT_DIR=go

rm -rf ${OUTPUT_DIR}/modules

echo "Generatin proto for modules:"
for module_path in ${PROTO_DIR}/modules/*/; do
  module=$(basename ${module_path})

  for version_path in ${PROTO_DIR}/modules/${module}/*/; do
    version=$(basename ${version_path})

    for domain_path in ${PROTO_DIR}/modules/${module}/${version}/*/; do
      domain=$(basename ${domain_path})

      echo "$domain, $domain_path"
        protoc -I ${PROTO_DIR} \
        --go_out=${OUTPUT_DIR} \
        --go_opt=paths=source_relative \
        --go-grpc_out=${OUTPUT_DIR} \
        --go-grpc_opt=paths=source_relative \
        ${domain_path}*.proto
    done
  done
done

cd go
echo "generating mock service"
for module_path in modules/*/; do
  module=$(basename ${module_path})

  for version_path in modules/${module}/*/; do
    version=$(basename ${version_path})

    for domain_path in modules/${module}/${version}/*/; do
      domain=$(basename ${domain_path})
      mock_dir=modules/${module}/${version}/${domain}/mock
      
      echo "$mockdir"


      for proto_path in modules/${module}/${version}/${domain}/*; do
        proto=$(basename ${proto_path})

        echo "mock, $proto, $proto_path"
        if echo "${proto_path}" | grep -Eq '.*\_grpc\.pb\.go'; then
          mkdir -p ${mock_dir}
          mockgen -source=${proto_path} -package=mock > ${mock_dir}/${proto%_grpc.pb.go}_mock.go
        fi
      done

        # echo " Done."
      # done
    done
  done
done
go mod tidy && go mod vendor