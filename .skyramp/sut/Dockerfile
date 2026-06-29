FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/netbox

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY netbox/ ./netbox/
COPY .skyramp/sut/configuration.testbot.py ./netbox/netbox/configuration.py

RUN python netbox/manage.py collectstatic --no-input

EXPOSE 8080

CMD ["sh", "-c", "python netbox/manage.py migrate --no-input && exec gunicorn --bind 0.0.0.0:8080 --chdir netbox --workers 2 --timeout 120 netbox.wsgi"]
