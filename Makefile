SHELL := /bin/bash
SLS_DEBUG=*

create-cert:
	@echo "Creating certificate for $(DOMAIN) in $(CERT_REGION) ..."
	DOMAIN="$(DOMAIN)" HOSTED_ZONE_ID=$(HOSTED_ZONE_ID) CERT_REGION=$(CERT_REGION) sls create-cert --config helpers/certificate.yml

remove-cert:
	@echo "Removing certificate for $(DOMAIN) from $(CERT_REGION) ..."
	DOMAIN="$(DOMAIN)" HOSTED_ZONE_ID=$(HOSTED_ZONE_ID) CERT_REGION=$(CERT_REGION) sls remove-cert --config helpers/certificate.yml

