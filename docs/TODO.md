# TODO -- v0.1.0
## Overview
* Build, test and harden docker image to specifications of inspec dev-sec linux-patch-baseline and linux-baseline.
* Publish qualified images to ECR repository.
* Provision, unit test and Document ECS and ECR infrastructure with terraform.
* Deploy, test and document images in ECS

## Tasks
* [ ] Build
	* [ ] Docker Image
		* [x] Secure
			* [x] Harden
		* [x] ECR
			* [x] Publish
		* [ ] Test
			* [ ] Unit Tests
			* [ ] Healthcheck
			* [x] Compliance
			* [x] Security Baseline
		* [ ] Document
			* [ ] Usage
			* [ ] Dev guide
* [ ] Provision
	* [x] Terraform
		* [x] ECR
		* [x] ECS
		* [ ] Secure
			* [ ] Best Practices
		* [ ] Test
			* [ ] Unit Tests
		* [ ] Document
			* [ ] Usage
			* [ ] Dev guide
				* [ ] TF Doc
* [ ] Deploy
	* [ ] ECS
		* [ ] Test
			* [ ] Unit Tests
		* [ ] Document
			* [ ] Usage
			* [ ] Dev guide
