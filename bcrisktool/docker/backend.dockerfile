FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf -y update \
 && dnf -y install \
    gcc-c++ \
    glibc-langpack-en \
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

RUN mkdir -p /app/server /app/client

COPY bcrisktool/server /app/server

RUN pip3 install -r /app/server/requirements.txt

COPY bcrisktool/client /app/client

COPY rat-commons /app/client/rat-commons

RUN chown -R apache:apache /app

CMD mod_wsgi-express start-server /app/server/bcrisktool.wsgi \
    --user apache \
    --group apache \
    --compress-responses \
    --log-to-terminal \
    --access-log \
    --access-log-format "%h %{X-Forwarded-For}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined \
    --document-root /app/client \
    --working-directory /app/server \
    --include-file /app/server/wsgi-httpd.conf
