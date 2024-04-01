1. ` docker image build -t custom-kafka:3.4 . `
2. ` docker container run -it --rm --network env-setup_default --name kafka-cli custom-kafka:3.4`