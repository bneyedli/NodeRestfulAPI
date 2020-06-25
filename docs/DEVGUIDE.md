# Overview
This project has been structured to use a simple reusable pattern throughout each stage of the deployment pipeline.
ie.
* $(STAGE)
	* $(STAGE)/Makefile
	* $(STAGE)/buildspec.yml
		* Defined actions for codebuild
	* $(STAGE)/$(TARGET)
		* $(STAGE)/Makefile-include
		* $(STAGE)/$(TARGET)/tests
			* $(STAGE)/Makefile-test-include

# Known Issues
In the current implementation there are helper scripts used througout the various stages. As such there are portablity limitations, future considerations will accomodate for this by executing the given stages inside containers themselves. This mimicks codebuild functionality and also serves to allow faster iterations on codebuild jobs locally on a platform that has tool and version parity.
