#!/bin/sh

rm -rf go
mkdir go
cd go && go mod init github.com/muhammadchandra19/akira-go-proto  && \
go get github.com/golang/mock && \
go get github.com/google/gnostic && \
go get github.com/grpc-ecosystem/grpc-gateway/v2 && \
go get google.golang.org/genproto && \
go get google.golang.org/grpc  && \
go get google.golang.org/protobuf