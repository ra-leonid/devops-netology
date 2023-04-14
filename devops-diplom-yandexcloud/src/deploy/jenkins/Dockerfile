FROM jenkins/inbound-agent:3107.v665000b_51092-5

# Install docker client
ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 23.0.3
USER root
RUN curl -fsSL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" \
  | tar -xzC /usr/local/bin --strip=1 docker/docker