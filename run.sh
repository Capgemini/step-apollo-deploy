#!/bin/bash
set +e

if [ ! -n "$WERCKER_APOLLO_DEPLOY_CLOUD" ];then
    fail 'Please specifiy the Apollo cloud provider.'
else
    CLOUD=${WERCKER_APOLLO_DEPLOY_CLOUD}
fi

if [ ! -n "$WERCKER_APOLLO_DEPLOY_TERRAFORM_VERSION" ];then
    fail 'Please specifiy the terraform version.'
else
    export TERRAFORM_VERSION=${WERCKER_APOLLO_DEPLOY_TERRAFORM_VERSION}
fi

if [ ! -n "$WERCKER_APOLLO_DEPLOY_ARTIFACT_NAME" ];then
    fail 'Please specifiy the terraform version.'
else
    export TF_VAR_atlas_artifact_master=${WERCKER_APOLLO_DEPLOY_ARTIFACT_NAME}
    export TF_VAR_atlas_artifact_slave=${WERCKER_APOLLO_DEPLOY_ARTIFACT_NAME}
fi

if [ ! -n "$WERCKER_APOLLO_DEPLOY_ARTIFACT_VERSION" ];then
    fail 'Please specifiy the terraform version.'
else
    export TF_VAR_atlas_artifact_version_master=${WERCKER_APOLLO_DEPLOY_ARTIFACT_VERSION}
    export TF_VAR_atlas_artifact_version_slave=${WERCKER_APOLLO_DEPLOY_ARTIFACT_VERSION}
fi

if [ -n "$WERCKER_APOLLO_DEPLOY_RUN_TESTS" ];then
    export APOLLO_serverspec_run_tests=${WERCKER_APOLLO_DEPLOY_RUN_TESTS}
    export APOLLO_serverspec_upload_folder=${WERCKER_APOLLO_DEPLOY_RUN_TESTS}
    export APOLLO_serverspec_tests_path=/tmp
fi

export APOLLO_PROVIDER=${CLOUD}

# Installing terraform.
mkdir terraform-package
pushd terraform-package
wget "https://dl.bintray.com/mitchellh/terraform/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
export PATH=$PATH:`pwd`
popd
terraform version

# Managing ssh keys.
pushd ~/.ssh
ssh-keygen -P "" -t rsa -f id_rsa_tmp -b 4096 -C "email@example.com"
export TF_VAR_key_file='~/.ssh/id_rsa_tmp.pub'
eval `ssh-agent -s`
ssh-add id_rsa_tmp
popd

# Deploy.
/bin/bash bootstrap/apollo-launch.sh
EXIT_CODE_LAUNCH=$?
echo 'yes' | /bin/bash bootstrap/apollo-down.sh
EXIT_CODE_DOWN=$?

if [ "${EXIT_CODE_LAUNCH}" -ne 0 ] || [ "${EXIT_CODE_DOWN}" -ne 0 ]
then  exit 1
fi

