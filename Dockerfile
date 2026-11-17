# BUILD STAGE
ARG PYTHON_VERSION=3.8

FROM python:${PYTHON_VERSION} AS builder

WORKDIR /app

COPY src/requirements.txt ./

RUN pip install --upgrade pip && \
pip install --target=/install -r requirements.txt

# RUN STAGE
FROM python:${PYTHON_VERSION} AS runner

WORKDIR /app

COPY --from=builder /install /install

ENV PYTHONPATH=/install:/app/src
ENV PYTHONUNBUFFERED=1

COPY . .

RUN python src/manage.py migrate

EXPOSE 8080

CMD ["python", "src/manage.py", "runserver", "0.0.0.0:8080"]