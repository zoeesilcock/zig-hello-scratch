FROM chainguard/zig:latest as builder

WORKDIR /opt/src/app

RUN mkdir -p /opt/src/app/src

COPY ./src/* ./src
COPY ./build.zig .
COPY ./build.zig.zon .

RUN zig build -Doptimize=ReleaseFast

FROM scratch

COPY --from=builder /opt/src/app/zig-out/bin/zig-hello-scratch /opt/bin/app/

ENTRYPOINT ["/opt/bin/app/zig-hello-scratch"]
