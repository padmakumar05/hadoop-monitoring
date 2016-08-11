#!/bin/bash


SUPPORT_EMAIL= ## To whom the email should be sent
TMP_HTML_LOC= ## Provide the path where you want to store the tmp html files.
THRESHOLD_TIME= ## Set the time in seconds, after which if any impala job found running will be considered as runaway job

for i in $(cat node_list.txt)
do
        count=0;
        curl -s --connect-timeout 3 http://$i:25000/queries > $TMP_HTML_LOC/impala_queries.html
        for j in $(grep -A 3 RUNNING $TMP_HTML_LOC/impala_queries.html | grep Details | cut -d= -f3 | sed "s/'>.*//")
        do
                w3m -dump_both "http://$i:25000/query_profile?query_id=$j" > $TMP_HTML_LOC/impala_query_details.html
                user=$(grep "User:" $TMP_HTML_LOC/impala_query_details.html | cut -d: -f2 | head -1)
                query_status=$(grep "Query Status" $TMP_HTML_LOC/impala_query_details.html | cut -d: -f2 )
                durat=$(grep "Duration:" $TMP_HTML_LOC/impala_query_details.html | cut -d: -f2 )
                start_time=$(grep "Start Time" $TMP_HTML_LOC/impala_query_details.html | awk '{print $4}' | cut -d'.' -f1)
                start_time_stamp=$(date -d $start_time +%s)
                current_time_stamp=$(date +%s)
                difference=$(( $current_time_stamp - $start_time_stamp ))
                if [ $difference -gt $THRESHOLD_TIME ]
                then
                        echo -e "The impala query submitted by user $user is running for $(expr $difference / 60 ):$(expr $difference % 60)). Please check it. \n $(sed -n '/Sql Statement/,/Coordinator/p' /data/scripts/impala_query_details.html | grep -v Coordinator)" | mail -s "Warning: $user Impala query running for more than $(expr $THRESHOLD_TIME / 60 )  mins" -r $SUPPORT_EMAIL "$SUPPORT_EMAIL"
                fi
        done
done
done
