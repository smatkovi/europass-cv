FROM ubuntu:bionic-20191010
LABEL maintainer="Prasad Tengse"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
            make \
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
            ghostscript \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 user \
        && useradd --uid 1000 --create-home --shell /bin/bash -g user user \
        && mkdir -p /home/user/{europass,cv} \
        && chown -R 1000:1000 /home/user \
        && apt-get update \
        && apt-get install wget rsync ca-certificates -y -qq --no-install-recommends \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && USER=user \
        && GROUP=user \
        && wget -q https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz \
        && tar -C /usr/local/bin -xzf fixuid-0.4-linux-amd64.tar.gz \
        && rm -f fixuid-0.4-linux-amd64.tar.gz \
        && apt-get purge -y wget ca-certificates \
        && apt-get -y -qq autoremove \
        && chown root:root /usr/local/bin/fixuid \
        && chmod 4755 /usr/local/bin/fixuid \
        && mkdir -p /etc/fixuid \
        && printf "user: %s\ngroup: %s\n" "$USER" "$GROUP" > /etc/fixuid/config.yml

USER user
WORKDIR /home/user/
ENV USER user
COPY --chown=1000:1000 . europass-cv
RUN cd europass-cv && ./install.sh \
    && cd .. && rm -rf europass-cv/
USER root
ENTRYPOINT [ "fixuid" ]
