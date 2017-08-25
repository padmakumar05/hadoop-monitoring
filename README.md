# hadoop-monitoring
This project is created to maintain a repository to monitor jobs running through different Hadoop services like Yarn, Impala, Hive etc

# Impala Monitoring Script

This script impala_mon.sh helps you to monitor Impala for any runaway jobs. This script queries the Impala daemons and find out if any jobs been running for more than the set threshold time (THRESHOLD_TIME) say 5 minutes. The output will be emailed to the SUPPORT_EMAIL email address. The sample email will look like this:

"The impala query submitted by user  USER is running for 45.5 mins. Plesase check it."

IMPORTANT: The node_list.txt file should contain the list of impala daemon node IP addresses or hostname seperated by newline. Also, make sure that you have "w3m" command installed in the box where you are running the script.

# Malicious Mapper Monitoring Script

The script malicious_mapper.sh, helps you to monitor mapreduce jobs which consumes a lot of resources. Most of the time the right indicator of such jobs is number of mappers. For example, such alerts will help us to take necessary action agains following scenarios:

    Huge number of mappers even though the target data is small. 
    Huge number of mappers because the query is run on a large table and not optimized

Such alerts will help us to work with the user or team to help them optimize the data(to put up a plan to make sure that the data splits size is equal to the dfs block size) or query. This will help us to make sure that the cluster resources are utilized in an optimized manner.

# Job Resource Monitoring Script

The script job_resource_mon.py, helps you to monitor the resource usage of each job which is running on the cluster. It will alert you if the script found a job which is using more resources than the threshold value you set.
