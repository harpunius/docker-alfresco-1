#!/bin/bash
# setting values for all the "-e ALF_xxx=..." parameters provided at startup
set -e
for thing in `env`
do
 if [[ $thing == ALF_* ]]; then
# replace the "\075" when equal is escaped (see tutum)
    thingreplaced=`echo -e $thing`
# getting the value of the parameter
     val=`echo -e  "$thingreplaced" | awk -F "=" '{print $1}'`
# getting the name value of the configuration variable passed as parameter
     name=`echo -e "${!val}" | awk -F "\.EQ\.|=" '{print $1}'`
     echo "name:$name"
     varvalue=`echo -e "${!val}" | awk -F "\.EQ\.|=" '{print $2}'`
     echo "varvalue:$varvalue"
# test if varvalue already configured in alfresco-global.properties
     if grep -q ^$name= /opt/alfresco/tomcat/shared/classes/alfresco-global.properties
     then
        sed -i "/opt/alfresco/tomcat/shared/classes/alfresco-global.properties" -e "s/$name=.*/$name=$varvalue/g"
    else
        echo  "$name=$varvalue" >> "/opt/alfresco/tomcat/shared/classes/alfresco-global.properties"
    fi
 fi
done
