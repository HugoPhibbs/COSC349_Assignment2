# Event Calendar

- This repo contains code to launch a website called "EventCalendar", which allows users to create and manage events
  associated with the University of Otago

## Deploying to cloud platforms

### Prerequisites:

- Please make sure that you have valid AWS credentials specified in your .aws configuration file
- Make sure you have npm, Terraform, the AWS cli and puppet bolt
- Add a `.env` file to the top level of the directory for your aws credentials, should look like:

```
AWS_ACCESS_KEY=XXXX
AWS_SECRET_KEY=XXXX
```

- Assuming that you have the provided SSH key (the .pem file) and that its in the top level project directory. You will
  need to make it visible to your local ssh client
- On Unix systems:

```shell
chmod 400 event-calendar.pem
```
- On Windows systems (make sure to substitute `<USERNAME>` for your Windows username)
```shell
icacls event-calendar.pem /inheritance:r /grant:r "<USERNAME>:R"
```

- Deployment of this app requires a step by step deploy process.

### Deploy with Terraform

- To then deploy the React and Cron-Job EC2 instances, along with the RDS DB, run:

```shell
terraform init --upgrade
# Enter 'yes' when prompted
terraform apply 
```

#### Notes:
- Make sure that the value of `DB_HOST` specified in the `.env` files in both the `cron-job` and `express-server` directories is up-to-date with what is printed when you run `terraform apply`


### Deploying the express app

- Note: This must be done *after* deploying with Terraform

- To deploy just the express app using the Serverless framework, enter:

```shell
cd express-server
npm run install-deploy
```


### Provisioning

- After deployment, you will need to provision the RDS DB and the EC2 instances.
- The Terraform file prints out the DNS addresses of the React and Cron-Job EC2 instances, use these for the next steps

#### Provisioning the React instance:

- First copy over contents from the project directory to the ec2 instance with:

```shell
scp -i "event-calendar.pem" -r ./react-app admin@<react-app-public-dns>:~
```

- Then SSH into the instance with, making sure to replace <host> with the host of the EC2

```shell
ssh -i "event-calendar.pem" admin@<react-app-public-dns>
```

- To actually provision and run the instance, enter:

```shell
cd ./react-app
chmod +x provision_react.sh
./provision_react
```

#### Provisioning the Cron-Job instance

- Similarly copy over contents from the project directory to the ec2 instance with:

```shell
scp -i "event-calendar.pem" -r ./cron-job admin@<cron-job-public-dns>:~
```

- Then SSH into the instance with:

```shell
ssh -i "event-calendar.pem" admin@<cron-job-public-dns>
```

- To actually provision and run the instance, enter:

```shell
cd ./cron-job
chmod +x provision_cron_job.sh
./provision_cron_job
```

#### Provisioning the DB

- To provision the DB, i.e. create the actual production database, you will need to first jump into the CRON job DB,
  then provision it from there

- First copy over the necessary sql scripts from your local machine to the cron-job ec2 with:

```shell
 scp -i "event-calendar.pem" -r ./sql-scripts admin@<cron-job-public-dns>:~/
```

- Then ssh into the cron-job ec2 using the same command as above
- Now enter these commands, one after the other, make sure they all are successful before going onto the next. Enter the
  DB password when necessary, a popup should ask you if you want to uninstall MariaDB, click yes to this.

```shell
cd ./sql-scripts
chmod +x setup-db.sh
./setup-db.sh
cd ../
rm -r sql-scripts/
```


### Teardown
- To remove the Express lambda function, enter:
```shell
serverless remvoe
```
- To remove the other deployed services, enter:
```shell
terraform destroy
```

### Project directories

- `express-server` contains a Node.js project for the backend express.js API
- `react-app` contains a Node.js project for the frontend React app
- `mysql-db` contains any configuration scripts of the MySQL RDS DB
- `cron-job` contains a micro project to run a cron-job within a container.