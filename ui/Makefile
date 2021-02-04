
SHELL := /bin/bash
SLS_DEBUG=*

clean:
	@echo "Cleaning..."
	rm -rf .serverless

download-sls-deployment-state-files:
	@echo "Checking '$(BUCKET)' bucket exists..."
	@if aws s3api head-bucket --bucket "$(BUCKET)" 2>/dev/null; then\
		echo "Downloading Serverless deployment state files...";\
		aws s3 sync s3://$(BUCKET)/.serverless .serverless --delete;\
	fi

deploy: clean download-sls-deployment-state-files
	@echo "Deploying..."
	cd ./$(REPO) && \
	npm install && \
	npm run build && \
	cd ../../ && \
    BUCKET=$(BUCKET) DOMAIN=$(DOMAIN) API_BASE_URL=$(API_BASE_URL) REPO=$(REPO) sls

	@echo "Uploading Serverless deployment state files"
	aws s3 sync .serverless s3://$(BUCKET)/.serverless --delete

remove: clean download-sls-deployment-state-files
	@echo "Removing..."
	@echo "Bucket: $(BUCKET)"
	sls remove
