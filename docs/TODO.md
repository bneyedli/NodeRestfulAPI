# TODO -- v0.1.0
## Acceptance criteria
* containerize this app (https://github.com/academind/node-restful-api-tutorial)
* Provision the application onto ECS
* Plan app instrumentation for metrics
* Plan authentication strategy
* Plan scaling strategy
## Overview
* Build, test and harden docker image to specifications of inspec dev-sec linux-patch-baseline and linux-baseline.
* Publish qualified images to ECR repository.
* Provision, unit test and Document ECS and ECR infrastructure with terraform.
* Deploy, test and document images in ECS

## Tasks
* [x] Build
	* [x] Docker Image
		* [x] Secure
			* [x] Harden
		* [x] ECR
			* [x] Publish
		* [x] Test
			* [x] Unit Tests
			* [x] Healthcheck
			* [x] Compliance
			* [x] Security Baseline
		* [x] Document
			* [x] Usage
			* [x] Dev guide
* [ ] Provision
	* [x] Terraform
		* [x] ECR
		* [x] ECS
		* [x] IAM
		* [ ] Secure
			* [ ] Best Practices
			* [x] Security Groups
		* [x] Test
			* [x] Unit Tests
		* [ ] Document
			* [x] Usage
			* [x] Dev guide
			* [ ] TF Doc
* [x] Deploy
	* [x] ECS
		* [x] Test
			* [x] Unit Tests
		* [x] Document
			* [x] Usage
			* [x] Dev guide
