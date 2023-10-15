download-depedencies:
	mkdir -p proto/google/api
	mkdir -p proto/openapiv3
	curl -L https://raw.githubusercontent.com/googleapis/googleapis/master/google/api/annotations.proto -o proto/google/api/annotations.proto
	curl -L https://raw.githubusercontent.com/googleapis/googleapis/master/google/api/http.proto -o proto/google/api/http.proto
	curl -L https://raw.githubusercontent.com/google/gnostic/main/openapiv3/annotations.proto -o proto/openapiv3/annotations.proto
	curl -L https://raw.githubusercontent.com/google/gnostic/main/openapiv3/OpenAPIv3.proto -o proto/openapiv3/OpenAPIv3.proto

generate-go: 
	make init-go
	chmod 777 go-script/proto-generator.sh
	go-script/proto-generator.sh

init-go:
	chmod 777 go-script/init-go.sh
	go-script/init-go.sh
