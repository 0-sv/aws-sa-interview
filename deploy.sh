#!/bin/bash

CANDIDATENAME="Sebastiaan Verbeek"
STACKNAME="sa-assignment"

OLD="aws-sa-cloudformation-v20190724.yaml"
NEW="aws-sa-cloudformation-v20190724-TROUBLESHOOTED.yaml"

DIR="file://$(pwd)"

REGION="eu-west-1"

if ! aws cloudformation validate-template --template-body=$DIR/$OLD &>/dev/null; then
    echo "There are some errors with your $OLD template. \
        Please run aws cloudformation validate-template outside this script." && \
    exit 1;
fi

if ! aws cloudformation validate-template --template-body=$DIR/$NEW &>/dev/null; then
    echo "There are some errors with your $OLD template. \
        Please run aws cloudformation validate-template outside this script." && \
    exit 1;
fi

if [[ $(aws configure get region) != $REGION ]]; then
    aws configure set region $REGION
fi

aws cloudformation create-stack \
        --stack-name=$STACKNAME \
        --template-body="$DIR/$OLD" \
        --parameters="ParameterKey=CandidateName,ParameterValue=$CANDIDATENAME" 2>/dev/null && exit 1;

aws cloudformation update-stack --stack-name=$STACKNAME \
    --template-body="$DIR/$NEW" \
    --parameters="ParameterKey=CandidateName,ParameterValue=$CANDIDATENAME" 