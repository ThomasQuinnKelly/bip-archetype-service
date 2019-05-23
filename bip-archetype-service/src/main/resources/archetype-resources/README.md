# BIP Service Archetype Origin Project

This project is the origin (or "source") project from which a legitimate archetype can be created for the BIP Platform. To be clear, this is not the archetype. This is a project from which one can create the archetype.

The `bip-archetype-service-origin` project is based on the `bip-reference-person` project, modified to provide a usable archetype.

Archetypes and their origins should never be deployed. They are tools for development only.

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

See the [root README](../README.md) for help getting the projects set up in your IDE.

Before starting modifications, two important notes regarding this process:

- No changes should ever be made in the `bip-archetype-service` project. It gets deleted every time a fresh archetype is generated from the Origin project.
- The steps for updating the archetype have been encoded in the `genarchetype.sh` script. Depending on the changes made to the Origin project, it may be necessary to update the script.
- The `genarchetype.sh` script copies the `.gitignore` and `*README.md` files from `bip-archetype-service-origin/archive` into the generated archetype project. If you need to make changes to these files, **do it in the archive folder**.

The origin project should only need to be updated when something new or different needs to be reflected in the BIP Service Archetype, for example, when

- service development coding patterns have changed
- configuration patterns have changed
- enhancements or new capabilities have been added to BIP services that should be part of the standard service project offering

## Making Changes to the Origin Project

1. Ensure that the `bip-archetype-service-origin` project builds, that the project can be run as a spring-boot app, and that the [localhost swagger page](http://localhost:8080/swagger-ui.html) opens and responds as excpected.
2. Make the desired changes, testing to ensure the project is stable
3. From the command line for example:

  - `$ cd ~/git/bip-archetype-service/bip-archetype-service-origin`
  - `genarchetype.sh` (runs the script to delete the `bip-archetype-service` directory and regenerate the archetype)

**NOTE** that if maven is unable to reach the nexus repo, or if the `bip-archetype-service*.jar` file does not yet exist for the maven version declared in the POM file, you will see WARN logs with related stack trace. This can typically be ignored.

1. Review `pom.xml` for the regenerated `bip-archetype-service` project, and check the files under `src/main/resources/archetype-resources/`. Depending on the nature of the changes made in the steps above, it may be necessary to tweak the `genarchetype.sh` script.

2. Once the archetype project looks good, follow the instructions in [the archetypes README.md](../biparchetype-service/README.md) file to generate a test project to run and test. Tweak the Origin project until the archetype produces a usable test project.

3. When ready, make sure the root `bip-archetype-service` and its two projects are tidy, and push the root project to the repo.
