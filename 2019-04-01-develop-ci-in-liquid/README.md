# 2019-04-01 develop-ci in Liquid

`develop-ci` is the current CI-build and deploy on Liquid for the `develop` branch of CIP (awaiting moving inside the firewall).

It is a two step process - building and deploying.  This is currently being investigated and scripted.

# Building the CIP image

When a commit is pushed to Bitbucket, the following happens

* Bitbucket follows a webhook pointing inside the `cip-test/develop-ci` _build configuration_ at https://master.int.liquid.tdk.dk/console/project/cip-test/browse/builds/develop-ci triggering a new build if it is the `develop` branch.
* The `registry.centos.org/dotnet/dotnet-21-centos7` Docker base image is pulled.
* The CIP source tree is cloned from Bitbucket
* The Dockerfile in the CIP source tree is executed (see log under individual build)

  The resulting image is pushed to the `cip-test/develop-ci` _image stream_ at https://master.int.liquid.tdk.dk/console/project/cip-test/browse/images/develop-ci

# Deploying the CIP image

When a new image is available in the `cip-test/develop-ci` image stream, the following happens:

* The `cip-test/develop-ci` _service_ at https://master.int.liquid.tdk.dk/console/project/cip-test/browse/services/develop-ci is triggered.  
* Each pod managed by the service is told to restart itself with the configuration listed in the `cip-test/develop-ci` _deployment_ at https://master.int.liquid.tdk.dk/console/project/cip-test/browse/dc/develop-ci 
* Each individual deployment then allows scaling up and down

The _route_ at https://master.int.liquid.tdk.dk/console/project/cip-test/browse/routes/develop-ci configures how to reach the service - here http://develop-ci-cip-test.int.liquid.tdk.dk/ - this is typically not changed each deployment.

Terminology:  The _service_ load balances the pods.  The _deployment_ describes what to put in the pods.  The _route_ enables a way to access the service in front of the pods.

# What do we have in place for Liquid?

* `develop` branch is automatically built and deployed to Liquid when updated.
* Good understanding on what happens in `registry.centos.org/dotnet/dotnet-21-centos7` (which is intended to work together with the `s2i` tool which our work builds on).  This is quite complex and not intended for developers.
* Understanding of the `oc` command line tool - necessary for scripting things.

# What don't we have in place for Liquid?

* Automatic builds of all branches.
* Automatic copying of Docker images to https://console.registry.liquid.tdk.dk/registry
* Deployment of Docker images in https://console.registry.liquid.tdk.dk/registry into Production.
* Good understanding of scaling.
* Centralized logging (Logstash etc)
* Performance analytics
* Health checks
