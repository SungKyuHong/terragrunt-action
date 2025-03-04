# Dockerfile used in execution of Github Action
FROM gruntwork/terragrunt:0.2.0
LABEL maintainer="Gruntwork <info@gruntwork.io>"

ENV MISE_CONFIG_DIR=~/.config/mise
ENV MISE_STATE_DIR=~/.local/state/mise
ENV MISE_DATA_DIR=~/.local/share/mise
ENV MISE_CACHE_DIR=~/.cache/mise
ENV ASDF_HASHICORP_TERRAFORM_VERSION_FILE=.terraform-version

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list && \
apt-get update && \
apt-get install -y docker-ce-cli
VOLUME ["/var/run/docker.sock"]

COPY ["./src/main.sh", "/action/main.sh"]

ENTRYPOINT ["/action/main.sh"]
