# syntax=docker/dockerfile:1.4

# ────────────────
# 1️⃣ Builder 스테이지: git 설치 + private repo 설치
# ────────────────
FROM python:3.12-slim AS builder

WORKDIR /build

# Git 설치
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*
#
## GitHub private repo 설치 (BuildKit secret 사용)
RUN --mount=type=secret,id=git_token \
    pip install --target=/build/ch-python-common --no-cache-dir \
    git+https://$(cat /run/secrets/git_token)@github.com/connexio-h/ch-python-common.git

# git 설치 aws 2023 linux 전용
#RUN microdnf install git -y && microdnf clean all

#ARG GH_TOKEN
#RUN pip install --no-cache-dir --target=/build/ch-python-common git+https://$GH_TOKEN@github.com/connexio-h/ch-python-common.git


# ────────────────
# 2️⃣ Final Lambda 스테이지: 라이브러리만 복사
# ────────────────
FROM public.ecr.aws/lambda/python:3.12

WORKDIR /var/task

# builder에서 설치된 라이브러리만 복사
COPY --from=builder /build/ch-python-common /var/lang/lib/python3.12/site-packages

# Lambda 핸들러 코드
COPY main.py .

CMD ["main.lambda_handler"]
