##!/bin/bash
#
# Delete AMP workspace
#
aws amp delete-workspace --workspace-id $WORKSPACE_ID
#
# Delete SSM parameters
#
aws ssm delete-parameter --name otel-collector-config
# NOT used in this fork, as the value that is injected in DISCOVERY_NAMESPACES_PARAMETER_NAME should be the value of the namespace
aws ssm delete-parameter --name ECS-Namespaces


