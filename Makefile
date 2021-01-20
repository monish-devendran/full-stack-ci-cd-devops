PROJECT_ID=extended-legend-300803
ENV=staging

run-local:
	docker-compose up

create-tf-backend-bucket:
	gsutil mb -p $(PROJECT_ID) gs://$(PROJECT_ID)_terraform_state

terraform-create-workspace:
	cd terraform && \
	   terraform workspace new $(ENV)


terraform-init:
	cd terraform && \ 
	   terraform workspace select $(ENV) \ 
	   terraform init

#TF-ACTION=apply make terraform-action
TF-ACTION?=plan
terraform-action:
	cd terraform && \ 
	   terraform workspace select $(ENV) \ 
	   terraform $(TF_ACTION) \
	   -var-file="./environments/common.tfvars" \
	   -var-file="./environments/$(ENV)/config.tfvars"


