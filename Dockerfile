FROM golang:1.15 AS builder
WORKDIR /src
COPY go.* /src/

RUN go env -w GOPROXY=direct

# Ensure all dependencies are listed correctly
RUN go mod tidy

# Vendor the dependencies
RUN go mod vendor

RUN go mod download

COPY . .
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN CGO_ENABLED=0 GO111MODULE=on GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -a -mod=vendor -tags=netgo -o config-reloader cmd/main.go


FROM alpine:latest AS final
WORKDIR /home/prometheus-for-ecs
COPY --from=builder /src/config-reloader .
ENV GO111MODULE=on
ENTRYPOINT ["./config-reloader"]
