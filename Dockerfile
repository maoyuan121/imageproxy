FROM golang:1.16 as build
LABEL maintainer="Will Norris <will@willnorris.com>"

## 创建用户 -u 指定用户 id, go 为用户名
RUN useradd -u 1001 go

WORKDIR /app

COPY go.mod go.sum ./
COPY third_party/envy/go.mod ./third_party/envy/
RUN go mod download

COPY . .

## -v 打印出被编译的包名
RUN CGO_ENABLED=0 GOOS=linux go build -v ./cmd/imageproxy

FROM scratch

COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /app/imageproxy /app/imageproxy

USER go

##  (as default parameters to ENTRYPOINT)
CMD ["-addr", "0.0.0.0:8080"]

ENTRYPOINT ["/app/imageproxy"]

EXPOSE 8080
