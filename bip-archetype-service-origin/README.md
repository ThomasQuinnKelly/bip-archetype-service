# BIP Service Archetype Origin Project

This project is the origin (or "source") project from which a legitimate archetype can be created for the BIP Platform. To be clear, this is not the archetype. This is a project from which one can create the archetype.

The `bip-archetype-service-origin` project is based on the `bip-reference-person` project, modified to provide a usable archetype.

## Why an Origin Project?

The intent is to provide a base project from which the `mvn archetype:create-from-project` mojo can be legitimately executed. It should create an archetype that will provide _basic_ code and configuration infrastructure to get a new project started quickly.

## What is in (and not in) this project?

Some capabilities that are provided in `bip-reference-person` for instructional purposes are omitted from the archetype. Also, beyond the necessary, this project does not attempt to anticipate the needs of projects that will be built on the BIP Platform. It provides the base code and config for core functionality, and provides starting points for unit tests, integration tests, and performance tests.

Included capabilities:

- Files for Jenkins, Helm, docker config of vault, consul, etc.
- Core code for basic application configuration, spring Application class, REST API provider, service impl, model transformation, validation, logging (including auditing), and exception handling.

Omitted capabilities:

- Partner Clients. For reasons of code reuse, consistent implementations, etc it is suggested that partner client code should reside in separate repositories to allow for consumption by other BIP projects. At a time when sufficient need becomes evident, partner client archetypes may be created.

  - The Feign Client code (REST client) and config have been removed.
  - The `bip-reference-partner-person` SOAP service project has been removed. It is worth noting that the service Helper class remains in the project as a template for SOAP client calls.

# Updating Origin and the Archetype

Before starting, two important notes regarding this process:

- The steps for updating the archetype have been encoded in the `genarchetype.sh` script. Depending on the changes made to the Origin project, it may be necessary to update the script.
- The `genarchetype.sh` script copies the README.md files from `bip-archetype-service-origin/archive` into the generated archetype project. If you need to make changes to these READMEs, do it in the archive folder, not the archetype project.

The origin project should only need to be updated when something new or different needs to be reflected in the BIP Service Archetype, for example, when

- service development coding patterns have changed
- configuration patterns have changed
- enhancements or new capabilities have been added to BIP services that should be part of the standard service project offering

To modify the archetype:

1. Clone the [bip-archetype-service](https://github.com/department-of-veterans-affairs/bip-archetype-service) repo
2. Ensure that the `bip-archetype-service-origin` project builds, that the project can be run as a spring-boot app, and that the [localhost swagger page](http://localhost:8080/swagger-ui.html) opens and responds as excpected.
3. Make the desired changes, testing to ensure the project is stable
4. Run `genarchetype.sh` to create the new `bip-archetype-service` project, and review its `pom.xml` and check the files under `src/main/resources/archetype-resources/`. Depending on the nature of the changes made in the steps above, it may be necessary to tweak the script.
5. Once the archetype project looks good, follow the instructions in [its README.md]() file to generate a test project to run and test. Tweak Origin until the archetype produces a usable test project.
6. When ready, make sure the `bip-archetype-service-root` and its two projects are tidy, and push it to the repo.
