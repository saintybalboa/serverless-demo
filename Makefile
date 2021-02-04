SHELL := /bin/bash
SLS_DEBUG=*

checkout-repo:
	@echo "Checking out branch/commit hash '$(COMMIT_HASH)' in repository '$(REPO)' in $(SERVICE) ..."
	rm -rf $(SERVICE)/$(REPO)
	git clone git@github.com:$(REPO).git $(SERVICE)/$(REPO) && \
	cd ./$(SERVICE)/$(REPO) && \
	git checkout $(COMMIT_HASH)

create-cert:
	@echo "Creating certificate for $(DOMAIN) in $(CERT_REGION) ..."
	DOMAIN="$(DOMAIN)" HOSTED_ZONE_ID=$(HOSTED_ZONE_ID) CERT_REGION=$(CERT_REGION) sls create-cert --config helpers/certificate.yml

remove-cert:
	@echo "Removing certificate for $(DOMAIN) from $(CERT_REGION) ..."
	DOMAIN="$(DOMAIN)" HOSTED_ZONE_ID=$(HOSTED_ZONE_ID) CERT_REGION=$(CERT_REGION) sls remove-cert --config helpers/certificate.yml
