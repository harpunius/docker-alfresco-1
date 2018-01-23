# docker-alfresco

Generate a docker Ubuntu based image for Alfresco Community v5.2.0 with Alfresco Share v5.2.f (see http://dl.alfresco.com/release/community/201707-build-00028/alfresco-community-installer-201707-linux-x64.bin) 

## Description

The Dockerfile builds from "dockerfile/ubuntu" see https://hub.docker.com/_/ubuntu/
 
- Installs "ubuntu-desktop" required for Alfresco transformation
- Dockerfile defines an "ENTRYPOINT" performing following configurations when container is started first:
	- Reduces system.content.orphanProtectDays to 1. Goal, saving space by reducing how long "orphan" content is kept.
	- Disable "deletedContentBackupListener" transferring deleted content files to "contentstore.deleted" no need
	 to empty the folder manually to recuperate physical space.
	- modifinitpass.sh reinitialize the initial repo password or "admin" to value of the ALFRESCO_PASWORD env variable
         passed when container initialy started
    - tunesolr.sh disable solr encryption between solr and alfresco for small cpu gain. solr and alfresco backend 
         are installed on same server.
    - starts Alfresco
    - Environment variables having name starting with "ALF_xxx" that are passed using the -e options will be copied or value updated in "alfresco-global.properties". 
       Example: -e ALF_22=share.protocol=https will indicate that protocol for share is https and configuration line will be inserted or updated accordingly in "alfresco-global.properties"
- Subsequent container start is only starting Alfresco adding or updating configuration passed using -e ALF_xxx=conf line.
- The possibility to start postgresql container separately from the alfresco (tomcat) container
- Configured [alfrescoprotectnode](https://github.com/pdubois/alfrescoprotectnode) to protect some "well known" nodes against accidental deletion.

## To generate the image from "Dockerfile"

```
cd _folder-containing-Dockerfile_
sudo docker build -t _image-name_ .
```

Examples:

```
sudo docker build -t alfresco-5.2.0 .
```

## Storing index, content and database outside of containers

The approach applied is to use dedicated container for volume sharing between host and container. 

### Step 1:

Decide where to locate your content, index and database files on your host and create directory for it.

Example:

```
mkdir /var/alf_data
```

### Step 2:
The same can be achieved using a single command "docker-compose":

A ***"your-docker-compose.yml"*** can be used as follows

```
version: '3'
services:
   alfresco:
       image: "pdubois/docker-alfresco:master"
       volumes:
        - /var/alf_data:/opt/alfresco/alf_data
```

Adjust the volume value to indicate your index, content and DB files location on your host.

```
sudo docker-compose -f your-docker-compose.yml up
```
