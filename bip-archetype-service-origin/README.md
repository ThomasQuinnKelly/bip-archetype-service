# BIP Service Archetype Origin Project

This project is the origin (or "source") project from which a new BIP Service project can be created.

This Origin project should never be deployed to any server. It is a tool to ease the creation of a new service project.

## What is in (and not in) this project?

Some capabilities that are provided in [bip-reference-person](https://github.com/department-of-veterans-affairs/bip-reference-person) for instructional purposes are omitted from the Origin project. Also, beyond the necessary, this project does not attempt to anticipate the needs of projects that will be built on the BIP Platform. It provides the base code and config for core functionality, and provides starting points for unit tests, integration tests, and performance tests.

Included capabilities:

- Files for Jenkins, Helm, docker config of vault, consul, etc.
- Core code for basic application configuration, spring Application class, REST API provider, service impl, model transformation, validation, logging (including auditing), and exception handling.

Omitted capabilities:

- Partner Clients. For reasons of code reuse and consistent implementation, it is suggested that partner client code should reside in separate repositories to allow for consumption by other BIP projects. At a time when sufficient need becomes evident, partner client Origin project(s) may be created.

  - The Feign Client code (REST client) and config have been removed.
  - The `bip-reference-partner-person` SOAP service project has been removed. It is worth noting that the service Helper class remains in the project as a template for SOAP client calls.

# Updating the Origin Project

## Before starting modifications

Be aware that:

- The `gen.sh` script - in the newly created project directory - copies `archive/bip-archetype-service-newprojects-README.md` over top of this very README. If you need to make changes to that file, **change the README in the `bip-archetype-service-origin/archive` folder** so it can be included in future projects. You may need to manually copy it other existing new project(s).

The Origin project should only need to be updated when something new or different needs to be reflected in the typical new BIP Service projects, for example, when

- service development coding patterns have changed
- configuration patterns have changed
- dependency technologies have changed (e.g. during upgrades of spring-boot, hystrix, etc)
- enhancements or new capabilities have been added to BIP services that should be part of the standard service project offering

## Making Changes to the Origin Project

1. Ensure that the `bip-archetype-service-origin` project builds, that the project can be run as a spring-boot app, and that the [localhost swagger page](http://localhost:8080/swagger-ui.html) opens and responds as expected.
2. Make the desired changes, testing the project as you would with any spring-boot application.
3. Remember that the new project README is in the `bip-archetype-service-origin/archive` folder, so make any necessary changes to that file.
4. Use the `./gen.sh` script to generate the MyTest project (using the default `gen.properties`), testing the generated project as you would with any spring-boot application.
