# Base image
FROM ubuntu:latest

ARG VERSION=0.8.1

# Create the user bitcoin and give it sudo capabilities
RUN apt update -y && apt install -y sudo software-properties-common curl tar git build-essential libtool autotools-dev autoconf libssl-dev libboost-all-dev

# Copy the bash scripts to the docker image
COPY ./install.sh /usr/local/bin/install.sh

# Run the script to install 'ord' binary
RUN chmod +x /usr/local/bin/install.sh &&\
    install.sh --tag ${VERSION} --target x86_64-unknown-linux-gnu &&\
    sudo mv $HOME/bin/ord /usr/local/bin/ord

# Prevents `VOLUME $DIR/index-data/` being created as owned by `root`
RUN mkdir -p "$DIR/index-data/"

# Expose volume containing all `index-data` data
VOLUME $DIR/index-data/

# REST interface
EXPOSE 8080

# Set the entrypoint
ENTRYPOINT ["ord"]

CMD ["--data-dir", "/index-data", "server", "--http-port=8080"]
