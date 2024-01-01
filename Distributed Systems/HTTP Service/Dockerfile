# Specify Python 3.11
FROM python:3.11

# Set the workdirectory as httpserver
WORKDIR /httpserver

# Copy httpserver.py into container httperserver
COPY httpserver.py /httpserver/

# Open port 8090 for Assignment 1
EXPOSE 8090

# Runs httpserver.py when you run dockerfile
CMD ["python", "httpserver.py"]


#sudo docker build -t dockerfile .
#sudo docker run -p 8090:8090 dockerfile
