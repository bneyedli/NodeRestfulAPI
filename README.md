# NodeRestfulAPI
Node Restful API PoC

# Usage
* Provision
Provision ECS/ECR and supporting Infra
	* ECS
```
$ cd provison
$ make provision PROVISION_TARGET=tf-node-rest-api-base
```
* Build
	* Local
```
$ cd build
$ make build BUILD_TARGET=docker-node-rest-api
```
	* Publish to ECR
```
$ make publish BUILD_TARGET=docker-node-rest-api
```
* Deploy
	* Local
	* ECS
```
$ make update test DEPLOY_TARGET=ecs-node-rest-api
```
## Example
### Bootstrapping
```
$ export PROVISION_TARGET=tf-node-rest-api-base
$ cd provision && make format plan provision test
$ cd build
# Build base images
$ for target in docker-ubuntu-base docker-ubuntu-web
do
   make build test BUILD_TARGET=${target}
done
cd build && make build test publish BUILD_TARGET=docker-node-rest-api
```
### Updating
```
$ export BUILD_TARGET=docker-node-rest-api PROVISION_TARGET=tf-node-rest-api-base DEPLOY_TARGET=ecs-node-rest-api
$ cd build && make build test publish 
$ cd provision && make format plan provision test
# updates need to be forced due to cluster constraints
$ cd deploy && make update-force test
```
### All at once
```
make stack
```

# Roadmap
* [ROADMAP.md](docs/ROADMAP.md)
	* [TODO.md](docs/TODO.md)

# Future Considerations
* API Gateway
* SimpleAD for directory authentication
* SSL Broker
* Dynamic DNS
* Slack Notifications
* Build Pipeline
	* CodeBuild
	* Branch Deployments
* Add diagrams

# Known Issues / Notes
* Inspec broken on Alpine Linux ( See [build/node-rest-api/Dockerfile-alpine](build/node-rest-api/Dockerfile-alpine) )
* Use credential helper for ecr login
* Use S3 & Dynamo for terraform state & locking
* https://pre-commit.com/
* Use spot instances with asg
* Investigate bazel for docker building
