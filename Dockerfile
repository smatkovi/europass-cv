FROM ubuntu:bionic
LABEL maintainer="Prasad Tengse"
ENV DEBIAN_FRONTEND noninteractive

RUN groupadd --gid 1000 user \
        && useradd --uid 1000 --create-home --shell /bin/bash -g user user \
        && mkdir -p /home/user/europass \
        && chown -R 1000:1000 /home/user

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
            make \
            gosu \
            texlive texlive-latex-base \
            texlive-generic-extra \
            texlive-generic-recommended \
            texlive-xetex \
            texlive-font-utils \
            texlive-pstricks \
            texlive-pictures \
            texlive-fonts-recommended \
            texlive-latex-extra \
            texlive-lang-english \
            latexmk \
            lmodern \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

USER user
WORKDIR /home/user/
ENV USER user
COPY --chown=1000:1000 . europass-cv
RUN cd europass-cv && ./install.sh \
    && cd .. && rm -rf europass-cv/