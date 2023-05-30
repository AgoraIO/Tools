FROM golang:1.20 AS builder

WORKDIR /go/src
COPY . .
RUN GOOS=linux CGO_ENABLED=0 GOARCH=amd64 go build -ldflags="-s -w" -o app server.go

FROM ubuntu:20.04

WORKDIR /app
ENV APP_ID=${APP_ID}
ENV APP_CERTIFICATE=${APP_CERTIFICATE}

COPY --from=builder /go/src/app ./

EXPOSE 8080

ENTRYPOINT ["./app"]
