# What is this repository for?

This is a suite of BIP projects for

<span color="red">add project purpose here</span>

.

# Project Breakdown

1. <span color="red">add github URLs to any partner projects, and brief description here</span>

2. [**artifactId**](https://github.com/department-of-veterans-affairs/__artifactId__/tree/master/__artifactId__): Service implementation project. This project demonstrates the recommended design patterns, configuration pointers, and coding examples. It shows how to produce a documented endpoint, how to register the app with Consul, how to use secrets from Vault, how to implement a Hystrix circuit breaker, how to get and use loggers, etc. The design consists of three layers:

  - The Provider (or "web") layer contains the REST endpoints and model, JSR 303 annotations in the resource class and the model, and the use of an adapter class to transform models and call the service interface.
  - The Domain (or "service") layer contains business validation, business logic, client helpers to call Partner services and process the returned data, and exception handling.
  - The Partner (or "client") layer performs partner client model transformation, calls to partner client interfaces, and response handling.

3. [**artifactId**-inttest](https://github.com/department-of-veterans-affairs/__artifactId__/tree/master/__artifactId__-inttest): Contains the integration tests using the framework Test Library (Spring Rest Template, Cucumber libraries, and other capabilities). It includes test cases that run against the service endpoints.

4. [**artifactId**-perftest](https://github.com/department-of-veterans-affairs/__artifactId__/tree/master/__artifactId__-perftest): Contains performance JMX test scripts for Apache JMeter that run against the service endpoints.

For examples and documentation about how projects are structured, configured, and developed on the BIP Platform:

- [BIP Framework](https://github.com/department-of-veterans-affairs/bip-framework)
- [BIP Reference - Person service](https://github.com/department-of-veterans-affairs/bip-reference-person)

# How to build and test?

The fastest way to get set up is to visit the [Quick Start Guide](https://github.com/department-of-veterans-affairs/bip-reference-person/blob/master/docs/quick-start-guide.md).

# Contribution guidelines

If you or your team wants to contribute to this repository, then fork the repository and follow the steps to create a PR for our upstream repo to review and commit the changes: [Creating a pull request from a fork](https://help.github.com/articles/creating-a-pull-request-from-a-fork/)

# Local Development

Instructions on running the application on a local workstation can be found in the [local-dev README](local-dev)
