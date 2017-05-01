FROM frolvlad/alpine-glibc:alpine-3.4
USER root

ENV CONDA_VERSION 4.2.12
ENV CONDA_SHA1 f43e58f0f2d2f64dcd4924edb8fbd4f4654db086

# We need to install openssl so that wget can fetch from HTTPS
RUN apk update && \
    apk add --no-cache openssl

RUN apk add --no-cache tini

# If the checksum doesn't match, build will fail. Note, though, that this only runs
# when this RUN or something above it changes, which shouldn't happen much.

RUN wget https://repo.continuum.io/miniconda/Miniconda3-$CONDA_VERSION-Linux-x86_64.sh && \
    echo "${CONDA_SHA1}  Miniconda3-$CONDA_VERSION-Linux-x86_64.sh" > miniconda.sha1 && \
    if [ $(sha1sum -c miniconda.sha1 | awk '{print $2}') != "OK" ] ; then exit 1; fi

# Install anaconda dependencies.

RUN apk add --no-cache bash libstdc++

# Actually install anaconda. We are pinning the anaconda version for trackability!

RUN  mkdir -p /opt && \
     bash ./Miniconda3-$CONDA_VERSION-Linux-x86_64.sh -b -p /opt/anaconda && \
     echo "conda ==${CONDA_VERSION}" >> /opt/anaconda/conda-meta/pinned

ENV PATH "/bin:/sbin:/opt/anaconda/bin:/usr/bin"

RUN rm Miniconda3-$CONDA_VERSION-Linux-x86_64.sh

RUN conda install -y conda=${CONDA_VERSION}

ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "/bin/bash" ]
