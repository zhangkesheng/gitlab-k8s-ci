FROM docker:dind

# Install requirements
RUN apk update && \
  apk add -U openssl curl tar gzip bash ca-certificates && \
  update-ca-certificates && \
  wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk && \
  apk add glibc-2.23-r3.apk && \
  rm glibc-2.23-r3.apk

# Ruby is required for reading CI_ENVIRONMENT_URL from .gitlab-ci.yml
RUN apk add ruby git

# Install kubectl

RUN wget "https://dl.k8s.io/v1.8.4/kubernetes-client-linux-amd64.tar.gz" && \
  tar -xzvf kubernetes-client-linux-amd64.tar.gz && \
  cp kubernetes/client/bin/kube* /usr/bin/ && \
  chmod +x /usr/bin/kubectl && \
  kubectl version --client

# Install deploy scripts
ENV PATH=/opt/kubernetes-deploy:$PATH
# Registry config
ENV REGISTRY_ADDR="registry.cn-hangzhou.aliyuncs.com"
ENV USER_NAME=
ENV PASSWORD=
# Kubernetes config
ENV KUBE_URL="https://192.168.10.64:6443"
ENV KUBE_TOKEN=""
ENV KUBE_NAMESPACE="default"
ENV KUBE_CA_PEM=""

COPY / /opt/kubernetes-deploy/
RUN ln -s /opt/kubernetes-deploy/run /usr/bin/deploy && \
  which deploy && \
  which build

ENTRYPOINT []
CMD []
