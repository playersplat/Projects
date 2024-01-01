FROM python:3.8-slim
WORKDIR /usr/src/app
COPY . .
RUN pip install --no-cache-dir flask requests
EXPOSE 8090
ENV FLASK_APP=assign3.py
CMD ["flask", "run", "--host=0.0.0.0", "--port=8090"]