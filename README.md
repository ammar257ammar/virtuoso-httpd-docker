# Virtuoso-httpd docker image with data loader

This repository is made to create a docker image that can run both Virtuoso and Apache web server in one container. It also facilitate data import into Virtuoso using custom-made bash script.



## Step 1 - Clone this repository

```bash
git clone https://github.com/ammar257ammar/virtuoso-httpd-docker.git

cd virtuoso-httpd-docker
```



## Step 2 - Build the docker image

```bash
docker build -t virtuoso-httpd .
```



## Step 3 - Run the docker container

Before running the container, make sure to create two folders: the first "PATH_TO_VIRTUOSO_DATA_FOLDER" is to store Virtuoso databases so you don't lose the graphs after importing them when the docker image is stopped (i.e. persistence). The second folder "PATH_TO_VIRTUOSO_IMPORT_FOLDER" is the location of RDF files that need to be imported into Virtuoso (the data loading tool will look for RDF files in this location which is mapped to /import inside the docker image).

Also, don't forget to replace "PASSWORD_HERE" with the password you set for Virtuoso.

For the first time you run the container, the password you should use is "dba". Then, you can change it from the web interface "http://localhost:8890" and replace it in the next run for the container.

```bash
docker run --name virtuoso-httpd \
    -p 8890:8890 -p 1111:1111 \
    -p 8080:80 -p 443:443 \
    -e DBA_PASSWORD=PASSWORD_HERE \
    -e SPARQL_UPDATE=true \
    -e DEFAULT_GRAPH=http://example.com \
    -v PATH_TO_VIRTUOSO_DATA_FOLDER:/data \
    -v PATH_TO_VIRTUOSO_IMPORT_FOLDER:/import \
    -d virtuoso-httpd
```



## Step 4 (Optional) - Loading data

If you need to import RDF data into Virtuoso, just make sure the RDF file is in the directory you already mapped to /import in the run command (step 3). Then run the following command from terminal (make sure to change to file name and the graph IRI where you want to load the data under in Virtuoso):

```bash
docker exec -i virtuoso-httpd bash -c "/load.sh FILE_TO_IMPORT GRAPH_IRI /data/load.log dba"
```



