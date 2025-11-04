FROM ghcr.io/jbboehr/handlebars.c/handlebarsc:alpine AS handlebars-base
FROM alpine:3.22

# ARG TARGETARCH

# In next iterations we'll add architecture
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="alpine" \
    OS_NAME="linux"

RUN apk add --no-cache bash yq-go wait4x unzip curl
COPY --from=handlebars-base /usr/local/bin/handlebarsc /usr/local/bin/handlebarsc
RUN INITOOL=initool-v1.0.0-9dc7574-linux-x86_64.zip ; \
    curl -SsLf https://github.com/dbohdan/initool/releases/download/v1.0.0/${INITOOL} -O ; \
    unzip ${INITOOL} ; mv initool /usr/local/bin/initool ; rm ${INITOOL}

RUN SCUTTLE_VERSION=v1.1.11 ; \
    SCUTTLE_URL=https://github.com/kvij/scuttle/releases/download/${SCUTTLE_VERSION}/scuttle-${OS_NAME}-${OS_ARCH}.zip ; \
    curl -SsLf ${SCUTTLE_URL} -O ; unzip scuttle-${OS_NAME}-${OS_ARCH}.zip ; mv scuttle /usr/local/bin/scuttle ; \
    rm scuttle-${OS_NAME}-${OS_ARCH}.zip

RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

ENV APP_VERSION="22" \
    IMAGE_REVISION="1"

USER 1001