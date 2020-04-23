# NodeRestfulAPI
Node Restful API PoC

# Usage
* Provision
Provision ECS/ECR and supporting Infra
	* ECS
```
$ cd provison
$ make provision PROVISION_TARGET=tf-infra
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
$ export BUILD_TARGET=node-rest-api PROVISION_TARGET=tf-infra
cd build && make build publish test
cd provision && make format plan provision
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
* Gate publish step if compliance tests fail

# Known Issues / Notes
* Inspec broken on Alpine Linux ( See [build/node-rest-api/Dockerfile-alpine](build/node-rest-api/Dockerfile-alpine) )
* Use credential helper for ecr login
* Use S3 & Dynamo for terraform state & locking
* https://pre-commit.com/
* Use spot instances with asg
* ~~ Running plan immediately after a destroy renders: ~~
```
Error: error creating capacity provider: ClientException: The specified capacity provider already exists. To change the configuration of an existing capacity provider, update the capacity provider.
```
  * ~~ Capacity provider name seems to hang around after a destroy despite being absent from the console or cli, renaming is a workaround ~~
    * ~~ Capacity providers are immutable, will conditionally import on creation ~~ 
	    * ~~ importing doesn't work as any change triggers a replacement which it cannot do, adding suffix to name ~~
		    * not required for ec2
