##!/bin/bash
WORKSPACE_ID=$(aws amp create-workspace --alias adot-prometheus-for-ecs --query "workspaceId" --output text)

sed -e s/WORKSPACE/$WORKSPACE_ID/g \
-e s/REGION/$AWS_REGION/g \
< otel-collector-config.yaml.template \
> otel-collector-config.yaml

aws ssm put-parameter --name otel-collector-config --value file://otel-collector-config.yaml --type String
# NOT used in this fork, as the value that is injected in DISCOVERY_NAMESPACES_PARAMETER_NAME should be the value of the namespace
aws ssm put-parameter --name ECS-Namespaces --value ecs-services --type StringList

export WORKSPACE_ID
