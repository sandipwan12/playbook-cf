# Tibco-Archival-Solution-Setup-Playbook
 
This playbook create and configures the AWS resources required for Tibco Archival solution.
 
## Repository Structure
 
## Makefile
 
This file orchestrates a series of ansible tasks that are configured. It also lists out any input dependencies in-prior, required to execute the mentioned tasks.
 
## Jenkinsfile
 
Jenkinsfile is used by the jenkins server to orchestrate the pipeline, running the tasks(make) from the Makefile
 
## CloudFormation templates
 
### archival-solution_cloudformation.yml
 
This is the core template which is reponsible for provisioning and configuration of all the resources:
 
- Creates and KMS keys for lambda and S3 and their alias.
- Creates 4 S3 buckets.
  - Archival source bucket
  - Archival bucket
  - TempRetrieval bucket
  - Retrieval bucket
- Creates service role for lambda and assignes it necessary permissions.
- Creates EFS filesystem and all its mountpoints and accesspoint
- Creates 2 lambda functions.
  - Archival lambda
  - Retrieval lambda
- Configures event for Archival lambda
- Configures the necessary permissions for S3 buckets to all limited access and to meet the compliance standards.
- Create and configure the lambda security group
 
## Vars
 
- **main.yml**
 
This file contains variables that are specific to this project. Other variables that are required to configure the project and the environment are picked from the git repositories [NON-PROD](https://github.aus.thenational.com/wis-ansible/wis-archive-env-config-nonprod) or [PROP](https://github.aus.thenational.com/wis-ansible/wis-archive-env-config-prod) depending on the environment specified.
 
## Ansible playbooks
 
a. **create-archival-solution-setup.yml**
 
This is the playbook that starts the orchestrates by calling an cloudformation template that provisions all the AWS resources for tibco archival solutions.
 
```yaml
- name: launching an tibco {{ application_name }}-ansible-cloudformation stack
    cloudformation:
      stack_name: "tibco-{{ tibco_env_name }}-app-{{ application_name }}-cloudformation"
      state: present
      region: "{{ region }}"
      disable_rollback: true
      termination_protection: yes
      template_body: "{{ lookup('template', 'archival_solution_cloudformation.yml') }}"
      template_parameters:
        AWSAccountName: "{{ aws_account_name }}"
    register: application_name
```
 
b. **delete-archival-solution-setup.yml\***
 
This playbook helps in deleting all the AWS resources that were created as part of the create playbook.
 
```yaml
- name: delete an tibco {{ application_name }}-ansible-cloudformation stack
    cloudformation:
      stack_name: "tibco-{{ tibco_env_name }}-app-{{ application_name }}-cloudformation"
      state: absent
```
 
## How to use this repository
 
### Operational Usage
 
Operational usage of this repository is restricted to the CICD tool - Jenkins used by the team.
 
| Key            | Value                                                                                                                        |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| URL (Non-prod) | [https://phoenix.nonprod.wealthint.awsnp.national.com.au:8081](https://phoenix.nonprod.wealthint.awsnp.national.com.au:8081) |
| URL (Prod)     | [https://phoenix.prod.wealthint.aws.national.com.au:8081](https://phoenix.prod.wealthint.aws.national.com.au:8081)           |
| Folder name    | wis-archive                                                                                                                  |
 
### Addtional Flags to assist
 
Enable playbook debug output:
 
`ENV_NAME=nonprod DEBUG=true make execute`
 
Specify alternate git branch
 
`ENV_NAME=nonprod ENV_GIT_TAG=newfeature make execute-test`
 
### Dependencies
 
- Non-prod environment config
  - [https://github.aus.thenational.com/wis-ansible/wis-archive-env-config-nonprod](https://github.aus.thenational.com/wis-ansible/wis-archive-env-config-nonprod)
- Prod environment config
  - [https://github.aus.thenational.com/wis-ansible/wis-archive-env-config-prod](https://github.aus.thenational.com/wis-ansible/wis-archive-env-config-prod)
- Archival lambda
  - [https://github.aus.thenational.com/wis-ansible/wis-archive-lambda](https://github.aus.thenational.com/wis-ansible/wis-archive-lambda)
- Retrieval lambda
  - [https://github.aus.thenational.com/wis-ansible/wis-retrieve-lambda](https://github.aus.thenational.com/wis-ansible/wis-retrieve-lambda)
 
