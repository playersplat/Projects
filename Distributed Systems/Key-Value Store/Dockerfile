FROM ubuntu:latest

RUN apt-get update -y \
    && apt-get install -y python3-pip dos2unix \
    && pip3 install flask requests

WORKDIR /app

COPY assignment2.py /app/assignment2.py
COPY forward_instance.py /app/forward_instance.py
COPY entrypoint.sh /app/entrypoint.sh

# Convert any Windows-style line endings to Unix-style line endings
RUN dos2unix /app/entrypoint.sh && chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]