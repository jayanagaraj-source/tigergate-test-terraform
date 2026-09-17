# Deliberately insecure Dockerfile for IaC scanner testing.
FROM ubuntu:18.04
# Runs as root (no USER directive) - CKV/DS rule
RUN apt-get update && apt-get install -y curl
# Secret baked into image layer
ENV AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# Remote piped to shell
RUN curl -sL http://example.com/install.sh | sh
ADD https://example.com/app.tar.gz /app/
EXPOSE 22
CMD ["/app/run.sh"]
