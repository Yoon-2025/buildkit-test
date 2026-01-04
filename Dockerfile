# syntax=docker/dockerfile:1.4
FROM public.ecr.aws/lambda/python:3.12

RUN bash -c "echo hihi" && sleep 3

RUN --mount=type=secret,id=git_token \
    bash -c 'if [ -f /run/secrets/git_token ]; then echo "SECRET_OK"; else echo "SECRET_MISSING"; fi' && sleep 5

#WORKDIR /var/task
#
## git 설치
#RUN microdnf install git -y && microdnf clean all
#
## GitHub private repo 설치 (BuildKit secret 사용)
#
#RUN --mount=type=secret,id=git_token \
#    pip install --no-cache-dir git+https://$(cat /run/secrets/git_token)@github.com/connexio-h/ch-python-common.git
#
#COPY main.py .
#
#CMD ["main.lambda_handler"]
