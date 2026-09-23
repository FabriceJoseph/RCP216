FROM mambaorg/micromamba:2.3.3

LABEL org.opencontainers.image.title="RCP216"
LABEL org.opencontainers.image.description="CNAM RCP216 - environnement de travail"
LABEL org.opencontainers.image.source="https://cedric.cnam.fr/vertigo/Cours/RCP216/"

WORKDIR /workspace

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /tmp/environment.yml

RUN micromamba create \
    --yes \
    --file /tmp/environment.yml \
    && micromamba clean --all --yes

ENV PATH=/opt/conda/envs/tprcp216/bin:$PATH

WORKDIR /workspace

