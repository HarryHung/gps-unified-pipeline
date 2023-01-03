FROM mambaorg/micromamba:1.1.0
COPY --chown=$MAMBA_USER:$MAMBA_USER environment_docker.yml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes

USER root
RUN apt-get update && apt-get install -y procps
USER $MAMBA_USER