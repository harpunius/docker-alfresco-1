FROM ubuntu
LABEL authors="Philippe Dubois,Tobias Sommer"
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    --no-install-recommends ubuntu-desktop \
    wget \
    curl \
    vim \
&& rm -rf /var/lib/apt/lists/*

# Get and run alfresco installer
RUN wget http://dl.alfresco.com/release/community/201707-build-00028/alfresco-community-installer-201707-linux-x64.bin \
&& chmod +x ./*.bin \
&& ./alfresco-community-installer-201707-linux-x64.bin --mode unattended --alfresco_admin_password admin --prefix /opt/alfresco \
&& rm ./alfresco-community-installer-201707-linux-x64.bin

# Make root readable by others
RUN chmod go+r /root

# Make all scripts (.py, .sh) in assets/ executable
COPY assets/ /
RUN find . -name '*.sh' -exec chmod +x {} \;
RUN find . -name '*.py' -exec chmod +x {} \;

RUN mv /opt/alfresco/tomcat/bin/setenv.sh /opt/alfresco/tomcat/bin/setenv.sh.back
RUN mv /setenv.sh /opt/alfresco/tomcat/bin/setenv.sh
RUN mv /opt/alfresco/alf_data /opt/alfresco/alf_data_back
RUN mkdir /opt/alfresco/alf_data

ENTRYPOINT ["/entry.sh"]
