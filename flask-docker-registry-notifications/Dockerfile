FROM python:alpine
RUN mkdir -p /opt/app
COPY . /opt/app
WORKDIR /opt/app
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python", "app.py"]
EXPOSE 6000
