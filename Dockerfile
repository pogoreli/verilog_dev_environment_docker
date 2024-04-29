FROM ubuntu:20.04

# Set non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && \
    apt-get install -y wget tar make nano python3 python3-pip perl curl sudo

RUN pip3 install teroshdl
RUN pip3 install cocotb

# Download OSS CAD Suite
RUN wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2024-04-14/oss-cad-suite-linux-x64-20240414.tgz -O oss-cad-suite.tgz

# Extract OSS CAD Suite
RUN tar -xzf oss-cad-suite.tgz -C /opt/
ENV PATH="/opt/oss-cad-suite/bin:${PATH}"

# Set the working directory
WORKDIR /usr/src/app

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN code-server --install-extension teros-technology.teroshdl
RUN code-server --install-extension beardedbear.beardedtheme

COPY settings.json /root/.local/share/code-server/User/settings.json
# Expose the code-server port
EXPOSE 8080

# Command to run code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none"]


# https://github.com/TerosTechnology/vscode-terosHDL

# ~/.local/share/code-server/extensions/teros-technology.teroshdl-2.0.13-universal