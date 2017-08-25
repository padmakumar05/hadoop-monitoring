#!/usr/bin/python
import sys
import subprocess
import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
import re

#VCORES = Provide total vcores in your cluster. Provide a float number like 0.00
#TOT_MEM = Total memory allocated to YARN. Provide a float number like 0.00
#THRESHOLD = A valid threshold to identify the job as using more resources. Provide a value like 0.00
#SUPPORT_EMAIL = your support group email or your email

VCORES = 
TOT_MEM = 
THRESHOLD = 
SUPPORT_EMAIL = ""

def send_email(job_id,username,queuename,cpu_usage,mem_usage):
	fromaddr = SUPPORT_EMAIL
	toaddr = SUPPORT_EMAIL
	msg = MIMEMultipart()
	msg['From'] = fromaddr
	msg['To'] = toaddr
	msg['Subject'] = "High Resource Usage by Job: %s Username: %s Queue: %s" %(job_id,username,queuename)
	body = "<html> <body> <style> table, th, td {     border: 1px solid black;    border-collapse: collapse; }  th, td {  padding: 5px; } th {  text-align: left; }  </style> <p><b>Hi Team,</b></p> <p>This job is using too much resource:</p> <p><table><th>Details</th><th>Value</th></th> <tr><td>Job ID</td><td>%s</td></tr> <tr><td>Username</td><td>%s</td></tr> <tr><td>Queue Name</td><td>%s</td></tr> <tr><td>CPU Used</td><td>%s</td></tr> <tr><td>Memory Used</td><td>%s</td></tr>  </p> </body> </html>" %(job_id,username,queuename,cpu_usage,mem_usage)
	msg.attach(MIMEText(body, 'html'))
	server = smtplib.SMTP('you_SMTP_server', 25)
	text = msg.as_string()
	server.sendmail(fromaddr, toaddr, text)



def run_cmd(args_list):
    proc = subprocess.Popen(args_list, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE)
    (output, errors) = proc.communicate()
    if proc.returncode:
        raise RuntimeError(
            'Error running command: %s. Return code: %d, Error: %s' % (
                ' '.join(args_list), proc.returncode, errors))
    return (output, errors)


	
(output, error) = run_cmd(['mapred','job','-list'])
for lines in [i for i in output.split('\n') if i.startswith('job')]:
	job_id = lines.strip().split('\t')[0]
	username = lines.strip().split('\t')[3]
	queuename = lines.strip().split('\t')[4]
	cpu_usage = float(lines.strip().split('\t')[6])
	mem_usage_tmp =  re.sub(r'M','',lines.strip().split('\t')[8])
	mem_usage = float(mem_usage_tmp)
	if cpu_usage / VCORES > THRESHOLD or mem_usage / TOT_MEM > THRESHOLD:
		send_email(job_id,username,queuename,cpu_usage,mem_usage)
