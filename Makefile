PROJECT_ID=extended-legend-300803
ENV=staging

####

define get-secret
$(shell gcloud secrets versions access latest --secret=$(1) --project=$(PROJECT_ID))
endef

####

run-local:
        docker-compose up
		
create-tf-backend-bucket:
        gsutil mb -p $(PROJECT_ID) gs://$(PROJECT_ID)_terraform_state
		
terraform-create-workspace:
        cd terraform && \
           terraform workspace new $(ENV)

terraform-init:
        cd terraform && \
        terraform workspace select $(ENV) && \
        terraform init

TF_ACTION?=plan
terraform-plan:
	cd terraform && \
	terraform workspace select $(ENV) && \
	terraform $(TF_ACTION) \
	-var-file="./environments/common.tfvars" \
	-var-file="./environments/$(ENV)/config.tfvars" \
        -var="mongodbatlas_private_key=$(call get-secret,mongodbatlas_private_key)" \
        -var="atlas_user_password=$(call get-secret,atlas_user_password_$(ENV))" \
        -var="cloudflare_api_token=$(call get-secret,cloudflare_api_token)" \


###
SSH_STRING=dmonish3@storybook-app-vm-$(ENV)
ZONE=us-central1-a
VERSION=latest
LOCAL_TAG=storybook-app:$(VERSION)
REMOTE_TAG=gcr.io/$(PROJECT_ID)/$(LOCAL_TAG)
CONTAINER_NAME=storybook-api
ssh:
        gcloud compute ssh $(SSH_STRING) \
        --project=$(PROJECT_ID) \
        --zone=us-$(ZONE)

ssh-cmd:
        gcloud compute ssh $(SSH_STRING) \
        --project=$(PROJECT_ID) \
        --zone=us-$(ZONE) \
        --command="$(CMD)"


build:
        docker build -t $(LOCAL_TAG) .

push:
        #changing tag to push to gcr
        docker tag $(LOCAL_TAG) $(REMOTE_TAG)
        docker push $(REMOTE_TAG)

deploy:
        $(MAKE) ssh-cmd CMD='docker-credential-gcr configure-docker'
        $(MAKE) ssh-cmd CMD='docker pull $(REMOTE_TAG)'
        -$(MAKE) ssh-cmd CMD='docker container stop $(CONTAINER_NAME)'
        -$(MAKE) ssh-cmd CMD='docker container rm $(CONTAINER_NAME)'
        $(MAKE) ssh-cmd='docker container run -d --name=$(CONTAINER_NAME) \
                --restart=unless-stopped \
                -p 80:3000 \
                -e PORT=3000 \
                -e'

