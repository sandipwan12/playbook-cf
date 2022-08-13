# commands
ANSIBLE=ansible
PLAYBOOK=ansible-playbook
 
# playbooks
CREATE_PLAYBOOK=create-archival-solution-setup.yml
DELETE_PLAYBOOK=delete-archival-solution-setup.yml
 
## set debug var
PLAYBOOK_DEBUG ?= 
## set ansible debug mode on if the DEBUG var is passed in
ifdef DEBUG
PLAYBOOK_DEBUG = -vvvv
endif
 
## check that the ENV_NAME var was passed in
check-env:
ifndef ENV_NAME
                $(error ENV_NAME is undefined)
endif
 
## check that the ENV_GIT_TAG var was passed in
#check-env-tag:
#ifndef ENV_GIT_TAG
#               $(error ENV_GIT_TAG is undefined)
#endif
 
## targets/rules for execution
 
execute: create-stack
# task "execute" : runs the create playbook with a given env repo. Used by the Jenkins.
# example use: "make execute ENV_NAME=nonprod", "make execute ENV_NAME=nonprod DEBUG=TRUE"
 
delete: get-env-config
                $(PLAYBOOK) -vvvv -i wis-archive-env-config-$(ENV_NAME)/inventory $(DELETE_PLAYBOOK)
# task "delete" : runs the delete playbook with a given env repo. Used by the Jenkins.
# example use: "make delete ENV_NAME=nonprod", "make delete ENV_NAME=nonprod DEBUG=TRUE"
 
## retrieves the environment inventory
get-env-config:
                rm -rf hello-env-config-$(ENV_NAME)
	            git clone https://github.com/sandipwan12/hello-env-config-$(ENV_NAME).git
 
create-stack: get-env-config
                $(PLAYBOOK) $(PLAYBOOK_DEBUG) -i hello-env-config-$(ENV_NAME)/inventory $(CREATE_PLAYBOOK)
