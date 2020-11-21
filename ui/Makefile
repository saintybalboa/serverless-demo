
SHELL := /bin/bash
SLS_DEBUG=*
DOMAIN=msswebdevelopment.com
BUCKET=nextjs-demo-bucket-$(DOMAIN_PREFIX)
REPO_FOLDER=nextjs-demo

clean:
	@echo "Cleaning..."
	rm -rf $(REPO_FOLDER) .serverless

download-sls-deployment-state-files:
	@echo "Checking '$(BUCKET)' bucket exists..."
	@if aws s3api head-bucket --bucket "$(BUCKET)" 2>/dev/null; then\
		echo "Downloading Serverless deployment state files...";\
		aws s3 sync s3://$(BUCKET)/.serverless .serverless --delete;\
	fi

deploy: clean download-sls-deployment-state-files
	@echo "Deploying..."
	git clone git@github.com:saintybalbooa/$(REPO_FOLDER).git && \
	cd ./$(REPO_FOLDER) && \
	git checkout $(COMMIT_HASH) && \
	npm install && \
	npm run build && \
	cd ../ && \
    BUCKET=$(BUCKET) DOMAIN_PREFIX=$(DOMAIN_PREFIX) DOMAIN=$(DOMAIN) API_BASE_URL=$(API_BASE_URL) sls

	@echo "Uploading Serverless deployment state files"
	aws s3 sync .serverless s3://$(BUCKET)/.serverless --delete

remove: clean download-sls-deployment-state-files
	@echo "Removing..."
	@echo "Bucket: $(BUCKET)"
	@echo "Domain: $(DOMAIN_PREFIX).$(DOMAIN)"
	sls remove
