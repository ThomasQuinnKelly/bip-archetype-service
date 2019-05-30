# BIP Service Archetype Origin Project

This project is the origin (or "source") project from which a legitimate archetype can be created for the BIP Platform. To be clear, this is not the archetype. This is a project from which one can create the archetype.

The `bip-archetype-service-origin` project is based on the `bip-reference-person` project, modified to provide a usable archetype.

Archetypes and their origins should never be deployed. They are tools for development only.

## Why an Origin Project?

The intent is to provide a base project from which the `mvn archetype:create-from-project` mojo can create a viable archetype. The intent is to create an archetype that will provide _basic_ code and configuration infrastructure to get a new project started quickly.

## What is in (and not in) this project?

Some capabilities that are provided in `bip-reference-person` for instructional purposes are omitted from the archetype. Also, beyond the necessary, this project does not attempt to anticipate the needs of projects that will be built on the BIP Platform. It provides the base code and config for core functionality, and provides starting points for unit tests, integration tests, and performance tests.

Included capabilities:

- Files for Jenkins, Helm, docker config of vault, consul, etc.
- Core code for basic application configuration, spring Application class, REST API provider, service impl, model transformation, validation, logging (including auditing), and exception handling.

Omitted capabilities:

- Partner Clients. For reasons of code reuse and consistent implementation, it is suggested that partner client code should reside in separate repositories to allow for consumption by other BIP projects. At a time when sufficient need becomes evident, partner client archetypes may be created.

  - The Feign Client code (REST client) and config have been removed.
  - The `bip-reference-partner-person` SOAP service project has been removed. It is worth noting that the service Helper class remains in the project as a template for SOAP client calls.

# Updating Origin and the Archetype

See the [root README](../README.md) for help getting the projects set up in your IDE.

## Before starting modifications

Be aware that:

- No changes should ever be made in the `bip-archetype-service` project. It gets deleted every time a fresh archetype is generated from the Origin project.
- The steps for updating the archetype have been encoded in the `genarchetype.sh` script. Depending on the changes made to the Origin project, it may be necessary to update the script.
- The `genarchetype.sh` script copies the `.gitignore` and `*README.md` files from `bip-archetype-service-origin/archive` into the generated archetype project. If you need to make changes to these files, **change the files in the /archive folder** or your work will be lost.
- Adding or refactoring POMs, yaml/properties, java files/packages _may_ have an impact on the `genarchetype.sh` and `gensvc.sh` scripts. Any change in the origin project triggers the possibility of having to edit the scripts.

The origin project should only need to be updated when something new or different needs to be reflected in the BIP Service Archetype, for example, when

- service development coding patterns have changed
- configuration patterns have changed
- enhancements or new capabilities have been added to BIP services that should be part of the standard service project offering

## Making Changes to the Origin Project

1. Ensure that the `bip-archetype-service-origin` project builds, that the project can be run as a spring-boot app, and that the [localhost swagger page](http://localhost:8080/swagger-ui.html) opens and responds as expected.
2. Make the desired changes, testing to ensure the project as you would with any spring-boot application.
3. Remember that the archetype READMEs and gitignore are in the `/archive` folder.

## Recreating the Archetype

### Background

The `genarchetype.sh` script performs almost all the steps to create a viable archetype. Within the script,

- maven creates the initial archetype in the `bip-archetype-service-origin/target/generated-sources/archetype/` directory.
- the generated files are modified to complete the tasks that the `archetype:create-from-project` mojo was not able to
- copies the archetype directory to the `bip-archetype-service` project location.

### Steps

1. If desired, back up the `bp-archetype-service` project directory to some arbitrary place on your hard drive, as it gets deleted and recreated every time the archetype is recreated.
2. Run the script to create the archetype:

  - `$ cd ~/git/bip-archetype-service/bip-archetype-service-origin`

    - `$ chmod +x genarchetype.sh` # if necessary, make the script executable

  - `$ ./genarchetype.sh` # delete the `bip-archetype-service` directory and regenerate the archetype

    - make any necessary changes in bip-archetype-service/pom.xml `<repositories>` and `<pluginrepositories>` sections - this should be the only manual change required

3. Review the `bip-archetype-service` project to ensure it was created properly. Depending on the nature of the changes made in the steps above, it may be necessary to tweak the `genarchetype.sh` script. Issues to check for:

  - full-text search the project for "origin" (case insensitive) - the only references should be legitimate URLs or references in the README files
  - full-text search the project for "import ${package}.framework" to ensure the find-and-replace worked correctly
  - check the directory names and files under `src/main/resources/archetype-resources/`.

4. Once the archetype project looks good, follow the instructions in [the archetypes README.md](../biparchetype-service/README.md) file to generate a test project to run and test. Tweak the Origin project until the archetype produces a usable test project.

5. When ready, make sure the root `bip-archetype-service` and its two projects are tidy, and push the root project to the repo.
