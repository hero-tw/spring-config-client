#!/bin/bash
export PATH=$PATH:/usr/local/bin
#Constants

REGION=us-east-1
REPOSITORY_NAME=config-demo-dev
CLUSTER=cluster-dev
FAMILY=`sed -n 's/.*"family": "\(.*\)",/\1/p' taskdef.json`
NAME=`sed -n 's/.*"name": "\(.*\)",/\1/p' taskdef.json`
SERVICE_NAME=${REPOSITORY_NAME}-service

`$(aws ecr get-login --no-include-email --region us-east-1)`

REPOSITORY_URI=`aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} --region ${REGION} | jq .repositories[].repositoryUri | tr -d '"'`

docker tag com.hero/demo:latest ${REPOSITORY_URI}:latest
docker tag com.hero/demo:latest ${REPOSITORY_URI}:${BUILD_NUMBER}
docker push ${REPOSITORY_URI}:latest
docker push ${REPOSITORY_URI}:${BUILD_NUMBER}

#Replace the build number and respository URI placeholders with the constants above
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" -e "s;%REPOSITORY_URI%;${REPOSITORY_URI};g" taskdef.json > ${NAME}-v_${BUILD_NUMBER}.json
#Register the task definition in the repository
aws ecs register-task-definition --family ${FAMILY} --cli-input-json file://${WORKSPACE}/${NAME}-v_${BUILD_NUMBER}.json --region ${REGION}
SERVICES=`aws ecs describe-services --services ${FAMILY} --cluster ${CLUSTER} --region ${REGION} | jq .failures[]`
#Get latest revision
echo "---------------------------------------------------------------"
echo "aws ecs describe-task-definition --task-definition ${FAMILY} --region ${REGION}"
aws ecs describe-task-definition --task-definition ${FAMILY} --region ${REGION} | jq .taskDefinition.revision | tail -1
echo "---------------------------------------------------------------"
REVISION=`aws ecs describe-task-definition --task-definition ${FAMILY} --region ${REGION} | jq .taskDefinition.revision | tail -1`
echo "Read revision ${REVISION}"

#Create or update service
if [ "$SERVICES" == "" ]; then
  echo "entered existing service"
  DESIRED_COUNT=`aws ecs describe-services --services ${FAMILY} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount`
  if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
  fi
  echo "aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${FAMILY} --task-definition ${FAMILY}:${REVISION} --desired-count ${DESIRED_COUNT}"
  aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${FAMILY} --task-definition ${FAMILY}:${REVISION} --desired-count ${DESIRED_COUNT}
else
  echo "entered new service"
  aws ecs create-service --service-name ${FAMILY} --desired-count 1 --task-definition ${FAMILY} --cluster ${CLUSTER} --region ${REGION}
fi