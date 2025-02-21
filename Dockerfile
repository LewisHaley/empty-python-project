FROM python:3.13.2-slim-bookworm

ARG USER=dev
ARG UID=1000
ARG GID=1000

RUN groupadd --gid=${GID} ${USER} \
    && useradd --gid=${GID} --uid=${UID} --create-home ${USER}

RUN apt-get update -y \
    && apt-get install \
        make \
    && apt-get clean

USER ${USER}
WORKDIR /home/${USER}

ARG REQUIREMENTS
COPY --chown=${USER} ${REQUIREMENTS} /tmp/${REQUIREMENTS}
RUN pip install \
        --user \
        --requirement=/tmp/${REQUIREMENTS} \
        --no-cache \
        --no-warn-script-location \
        --progress-bar=off \
        --only-binary=:all: \
    && rm -f /tmp/${REQUIREMENTS}

COPY --chown=${USER} . /tmp/project
RUN pip install \
        --user \
        --no-cache \
        --no-warn-script-location \
        --progress-bar=off \
        /tmp/project \
    && rm -rf /tmp/project
