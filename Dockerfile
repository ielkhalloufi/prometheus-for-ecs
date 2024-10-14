FROM golang:1.15 as builder
WORKDIR /src
COPY go.* /src/
RUN go env -w GOPROXY=direct
RUN go mod download
RUN go mod vendor
COPY . .
RUN go mod vendor
RUN CGO_ENABLED=0 GO111MODULE=on go build -a -mod=vendor -tags=netgo -o config-reloader cmd/main.go

FROM alpine:latest AS final
WORKDIR /home/prometheus-for-ecs
COPY --from=builder /src/config-reloader .
ENV GO111MODULE=on
ENTRYPOINT ["./config-reloader"]