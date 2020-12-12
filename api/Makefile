
SHELL := /bin/bash
SLS_DEBUG=*
REPO=saintybalboa/aws-api-gateway-demo

clean:
	@echo "Cleaning..."
	rm -rf $(REPO) .serverless

deploy: clean
	@echo "Deploying..."
	git clone git@github.com:$(REPO).git $(REPO) && \
	cd ./$(REPO) && \
	git checkout $(COMMIT_HASH) && \
	npm install && \
	npm run build && \
	cd ../../ && \
	DOMAIN="$(DOMAIN)" HOSTED_ZONE_ID=$(HOSTED_ZONE_ID) REPO=$(REPO) sls deploy

remove: clean
	@echo "Removing..."
	@echo "Domain: $(DOMAIN)"
	DOMAIN="$(DOMAIN)" HOSTED_ZONE_ID=$(HOSTED_ZONE_ID) REPO=$(REPO) sls remove
