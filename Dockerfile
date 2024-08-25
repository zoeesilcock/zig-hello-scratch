FROM chainguard/zig:latest as builder

WORKDIR /opt/src/app

RUN mkdir -p /opt/src/app/src

COPY ./src/* ./src
COPY ./build.zig .
COPY ./build.zig.zon .

RUN zig build -Doptimize=ReleaseFast

RUN echo "appuser:x:10001:10001:App User:/:/sbin/nologin" > /etc/minimal-passwd

FROM scratch

WORKDIR /opt/bin/app
COPY --from=builder /opt/src/app/zig-out/bin/zig-hello-scratch /opt/bin/app/

COPY --from=builder /etc/minimal-passwd /etc/passwd
USER appuser

ENTRYPOINT ["/opt/bin/app/zig-hello-scratch"]
