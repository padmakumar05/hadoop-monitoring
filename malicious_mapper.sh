

#!/bin/bash

THRESHOLD_NO_MAPPERS=  ## Define a threshold value for no of mappers. Above this value should trigger an alert.
EMAIL_GROUP=  ## Set the email address here to which the alert email should be sent.

#### The below steps are required, if you are running the cluster in secure mode.

SUPER_USER=  ### Provide the principal/user name which have super user privilege in your cluster. I am using "hdfs" user.
LOC_KEYTAB_FILE=  ## Provide the location where you have stored the keytab for the user 
REALM=REALMNAME=   ## Provide the realm name here

kinit -kt $LOC_KEYTAB_FILE SUPER_USER@$REALM

#### Find the list of jobs running on the cluster 


for i in `mapred  job -list | awk '$1 ~ /job_/ {print $1}'`

do

        ### Get the Application ID of the job
        application_id=$(mapred job -status $i | grep "Job Tracking URL" | cut -d'/' -f5)
        
        ### Get the User who ran the job 
        user=$(yarn application -status $application_id |  grep User | cut -d: -f2)
        
        ### Get the queue under which the job is running. In a secure cluster, this will help us to identify the user,queue/group who run a problem hive query.
        queue=$(yarn application -status $application_id |  grep Queue | cut -d: -f2)
        
        ### Get the number of mappers spawned on this job
        no_of_maps=$(mapred job -status $i | grep "Number of maps" | awk -F: '{print $2}');

        ### Check if the number of mappers spwawned is above threshold set
        if [ $no_of_maps -ge $THRESHOLD_NO_MAPPERS ]

        then
                ### IF the no of mappers is above the threshold, send an alert to the team.
                echo -e "Number of maps\t=\t$no_of_maps. \nJob ID\t=\t$i\n" | mail -s "[US Prod] WARNING: Malicious job found: User: $user: Queue:$queue application: $application_id" "$EMAIL_GROUP"

        fi;

done;
