FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf -y update \
 && dnf -y install \
    gcc-c++ \
    httpd-devel \
    libffi-devel \
    make \
    openssl-devel \
    python3 \
    python3-devel \    
    python3-pip \
    python3-setuptools \
    python3-wheel \
 && dnf clean all

RUN mkdir -p /app/server /app/logs /app/wsgi

WORKDIR /app/server

COPY ../requirements.txt /app/server/requirements.txt
RUN pip3 install -r /app/server/requirements.txt

# copy server
COPY . /app/server/
COPY . /app/server/bcrisktool

# copy additional wsgi config
COPY additional-configuration.conf /app/wsgi/additional-configuration.conf

# create ncianalysis user
RUN groupadd -g 4004 -o ncianalysis \
    && useradd -m -u 4004 -g 4004 -o -s /bin/bash ncianalysis

## building locally - need to provide aws credentials to use queue 

CMD mod_wsgi-express start-server /app/server/bcrisktool.wsgi \
    --user ncianalysis \
    --group ncianalysis \
    --compress-responses \
    --log-to-terminal \
    --access-log \
    --access-log-format "%h %{X-Forwarded-For}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined \
    --access-log-name access.log \
    --port 8120 \
    --server-root /app/wsgi \
    --document-root /app/server \
    --working-directory /app/server \
    --directory-index index.html \
    --mount-point /bcrisktool \
    --log-directory /app/logs \
    --rotate-logs \
    --error-log-name apache.log \
    --include-file /app/wsgi/additional-configuration.conf \
    --header-buffer-size 50000000 \
    --response-buffer-size 50000000 \
    --limit-request-body 5368709120 \
    --initial-workers 1 \
    --socket-timeout 900 \
    --queue-timeout 900 \
    --shutdown-timeout 900 \
    --graceful-timeout 900 \
    --connect-timeout 900 \
    --request-timeout 900 \
    --keep-alive-timeout 60 \
    # --max-clients 200 \
    --processes 3 \
    --threads 1 \
    --reload-on-changes 