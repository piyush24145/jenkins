FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg nodejs npm docker.io && \
    update-ca-certificates

USER jenkins
