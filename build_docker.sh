
docker build -t picorv32 .

docker -D run --rm -v $(pwd)/firmware:/build picorv32 make -C /build

cp firmware/firmware.hex ./