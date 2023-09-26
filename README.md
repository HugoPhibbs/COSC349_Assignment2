# Event Calendar

- This repo contains code to launch a website called "EventCalendar", which allows users to create and manage events
  associated with the University of Otago

## Deploying to cloud platforms

### Prerequisites:

- Please make sure that you have valid AWS credentials specified in your .aws configuration file
- Make sure you have npm, Terraform, the AWS cli and ansible
- Add a `.env` file to the top level of the directory for your aws credentials, should look like:

```
AWS_ACCESS_KEY=XXXX
AWS_SECRET_KEY=XXXX
```

- Assuming that you have the provided SSH key (the .pem file) and that its in the top level project directory. You will
  need to make it visible to your local ssh client
- On windows:
```shell
icacls "event-calendar.pem" /grant "Users:(RX)"  
```
- On Unix systems:
```shell
chmod 400 event-calendar.pem
```

- Deployment of this app requires a step by step deploy process.

### Deploying the express app

- To deploy just the express app using the Serverless framework, enter:

```shell
npm run deploy-express
```

### Deploying the remaining services

#### Pushing cron-job image

- Before actually deploying the Cron-Job, if you have made any changes to the code of the cron job module, you will need
  to push the new changes to the container registry. To do this run the commands (one after the other):

```shell
aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 503722977011.dkr.ecr.ap-southeast-2.amazonaws.com

docker build -t cron-job -f ./cron-job/DockerfileCronjob .

docker tag cron-job:latest 503722977011.dkr.ecr.ap-southeast-2.amazonaws.com/cron-job:latest 

docker push 503722977011.dkr.ecr.ap-southeast-2.amazonaws.com/cron-job:latest 
```

#### Deploy with Terraform

- To then deploy the EC2, RDS and Cron-job via Terraform, use:

```shell
terraform init

terraform apply
```

### Project directories

- `express-server` contains a Node.js project for the backend express.js API
- `react-app` contains a Node.js project for the frontend React app
- `mysql-db` contains any configuration scripts of the MySQL RDS DB
- `cron-job` contains a micro project to run a cron-job within a container.