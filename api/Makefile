SHELL := /bin/bash
SLS_DEBUG=*

clean:
	@echo "Cleaning..."
	rm -rf .serverless

deploy: clean
	@echo "Deploying..."
	cd ./$(REPO) && \
	npm install && \
	npm run build && \
	cd ../../ && \
	ENV=$(ENV) DOMAIN=$(DOMAIN) REPO=$(REPO) sls deploy

remove: clean
	@echo "Removing..."
	@echo "Domain: $(DOMAIN)"
	DOMAIN="$(DOMAIN)" REPO=$(REPO) sls remove
