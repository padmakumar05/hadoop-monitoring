# hadoop-monitoring
This project is created to maintain a repository to monitor jobs running through different Hadoop services like Yarn, Impala, Hive etc

# Impala Monitoring Script

This script impala_mon.sh helps you to monitor Impala for any runaway jobs. This script queries the Impala daemons and find out if any jobs been running for more than the set threshold time (THRESHOLD_TIME) say 5 minutes. The output will be emails to the SUPPORT_EMAIL email address. The sample email will look like this:

"The impala query submitted by user  USER is running for 45.5 mins. Plesase check it."

IMPORTANT: The node_list.txt file should contain the list of impala daemon node IP addresses or hostname seperated by newline.
