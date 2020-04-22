# NodeRestfulAPI
Node Restful API PoC

# Usage
* Provision
Provision ECS/ECR and supporting Infra
	* ECS
```
$ cd provison
$ make provision PROVISION_TARGET=node-rest-api
```
* Build
	* Local
```
$ cd build
$ make build BUILD_TARGET=node-rest-api
```
	* Publish to ECR
```
$ make publish BUILD_TARGET=node-rest-api
```
* Deploy
	* Local
	* ECS
## Example
```
$ export BUILD_TARGET=node-rest-api PROVISION_TARGET=node-rest-api
cd build && make build publish test
cd provision && make format plan provision
```

# Roadmap
* [ROADMAP.md](docs/ROADMAP.md)
	* [TODO.md](docs/TODO.md)

# Known Issues / Notes
* Inspec broken on Alpine Linux ( See [build/node-rest-api/Dockerfile-alpine](build/node-rest-api/Dockerfile-alpine) )
* Use credential helper for ecr login
* Use S3 & Dynamo for terraform state & locking
* https://pre-commit.com/
* Use spot instances with asg
