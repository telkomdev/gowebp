FROM golang:1.12.5-alpine3.9

# Input file
ENV INPUT_FILE_NAME a.png
ENV OUTPUT_FILE_NAME b.webp

# Add args
ARG APP_NAME=gowebp
ARG LOG_DIR=/${APP_NAME}/logs

# env build packages
ARG BUILD_PACKAGES="git wget make"

# Create folder logs 
RUN mkdir -p ${LOG_DIR}

# Set the Current Working Directory inside the container
WORKDIR /usr/app

# Add the source code
ENV SRC_DIR=/usr/app/

# create volume data
RUN mkdir data

# Environment Variables
ENV LOG_FILE_LOCATION=${LOG_DIR}/app.log

COPY . $SRC_DIR

RUN apk update && apk add --no-cache --update libpng-dev libjpeg-turbo-dev giflib-dev tiff-dev autoconf automake gcc g++ $BUILD_PACKAGES \
    && CGO_ENABLED=0 GOOS=linux go build -ldflags '-w -s' -a -o app github.com/telkomdev/gowebp/cmd/gowebp \
    && wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.3.tar.gz \
    && tar -xvzf libwebp-1.0.3.tar.gz \
    && mv libwebp-1.0.3 libwebp \
    && rm libwebp-1.0.3.tar.gz \
    && cd libwebp \
    && ./configure --enable-everything \
    && make \
    && make install \
    && apk del $BUILD_PACKAGES

RUN rm -rf libwebp

# Copy environment variable to source dir
COPY .env $SRC_DIR.env

EXPOSE 9000

VOLUME [ "/data" ]

ENTRYPOINT ["sh", "-c", "./app /data/${INPUT_FILE_NAME} /data/${OUTPUT_FILE_NAME}"]
