FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    wget \
    gnupg \
    sudo

# Add Erlang Solutions repository
RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
RUN dpkg -i erlang-solutions_2.0_all.deb
RUN apt-get update

# Install Erlang
RUN sudo apt-get install -y esl-erlang 

# Install the necessary tools for EUnit
RUN apt-get install -y \
    elixir \
    erlang-parsetools \
    erlang-dev \
    erlang-eunit \
    erlang-dialyzer \
    erlang-tools \
    erlang-xmerl \
    erlang-inets \
    erlang-ssl \
    erlang-public-key \
    erlang-asn1 \
    erlang-runtime-tools \
    erlang-crypto \
    erlang-syntax-tools \
    erlang-mnesia \
    erlang-observer 

# Define an ARG for the Gleam version
ARG GLEAM_VERSION=1.1.0

# Download and install the precompiled Gleam binary for x86_64 Linux with musl libc
RUN curl -fsSL https://github.com/gleam-lang/gleam/releases/download/v${GLEAM_VERSION}/gleam-v${GLEAM_VERSION}-x86_64-unknown-linux-musl.tar.gz \
    | tar -xzC /usr/local/bin gleam

# Create a non-root user and set directory permissions
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} developer && \
    useradd -u ${UID} -g developer -m developer

# Set the working directory and permissions
WORKDIR /app
RUN chown developer:developer /app
USER developer

# Verify Gleam installation
RUN gleam --version
