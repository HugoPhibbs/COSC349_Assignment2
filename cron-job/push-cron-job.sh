aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 503722977011.dkr.ecr.ap-southeast-2.amazonaws.com

docker build -t cron-job -f DockerfileCronjob .

docker tag cron-job:latest 503722977011.dkr.ecr.ap-southeast-2.amazonaws.com/cron-job:latest

docker push 503722977011.dkr.ecr.ap-southeast-2.amazonaws.com/cron-job:latest


