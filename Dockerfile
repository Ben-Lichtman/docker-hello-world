# Build container
FROM benlichtman/rust-musl-builder as builder

# Build project
COPY . .
ARG BINARY
RUN echo "Building project" && \
cargo build --release && \
mkdir output && \
mv target/release/$BINARY output/output_bin && \
strip output/output_bin

# Deploy container
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
WORKDIR /home/deploy
COPY --from=builder /home/build/output/output_bin .

ENTRYPOINT ["./output_bin"]
