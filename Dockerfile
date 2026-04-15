# ---------- Stage 1: Builder ----------
FROM python:3.13-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY ./app /app


# ---------- Stage 2: Runtime ----------
FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# CHANGE WORKDIR
WORKDIR /code

RUN useradd -m appuser

# Copy Python libs
COPY --from=builder /usr/local/lib/python3.13 /usr/local/lib/python3.13

# Copy binaries (uvicorn etc.)
COPY --from=builder /usr/local/bin /usr/local/bin

# app inside /code/app
COPY --from=builder /app /code/app

USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]