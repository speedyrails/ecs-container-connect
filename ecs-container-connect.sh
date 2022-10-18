#!/bin/bash

ECS_CLUSTER_NAME="Production"



echo -e "AWS Profile To Use: ${AWS_DEFAULT_PROFILE}"

CONFIRMATION_ANSWER=""

while [[ "$CONFIRMATION_ANSWER" != "YES" ]]; do
    read -r -p "Do you want to run the script using this AWS Profile? [YES/NO]: " CONFIRMATION_ANSWER

    if [ "$CONFIRMATION_ANSWER" == "YES" ]; then
        echo -e ""
        break
    elif [ "$CONFIRMATION_ANSWER" == "NO" ]; then
        echo -e "Script Canceled."
        echo -e "Set the AWS_DEFAULT_PROFILE variable with the correct AWS Profile and run the script again."
        exit 0
    fi
done

echo -e "*** Listing the ECS services in the ECS Cluster ${ECS_CLUSTER_NAME}\n"

aws ecs list-services --cluster ${ECS_CLUSTER_NAME} | jq -r '.serviceArns[]'

echo -e ""

read -r -p "Enter the service to be used from the previous list: " ECS_SERVICE

echo -e "\n*** Listing running tasks for service ${ECS_SERVICE}\n"

aws ecs list-tasks --cluster ${ECS_CLUSTER_NAME} --service-name ${ECS_SERVICE} --desired-status RUNNING | jq -r '.taskArns[]'

echo -e ""

read -r -p "Enter the task from the previous list to connect to: " ECS_TASK

aws ecs execute-command --cluster ${ECS_CLUSTER_NAME} --task ${ECS_TASK} --command "/bin/bash" --interactive
