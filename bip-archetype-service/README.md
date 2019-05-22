# BIP Service Archetype Project

The `bip-archetype-service` project is somewhat ephemeral - it is deleted and recreated every time the `bip-archetype-service-origin` generate function is invoked.

This project is, however, the project from which new BIP Platform service projects are created.

## Creating a new project from the archetype

The steps to generate a new project from the archetype are encoded in the `gensvc.sh` script. The script makes use of the `gensvc.properties` file to set the packaging and naming of the generated project. Only a few steps are required to start your new project folder.

1. Ensure correct values exist in the `gensvc.properties` file. If you are testing the archetype, you may leave the properties as they are already set.
2. From the root of the archetype projects, execute the `gensvc.sh` script.
3. Run the spring-boot server for the newly created project and open its [localhost swagger page](http://localhost:8080/swagger-ui.html) page to ensure everything responds as expected.
4. Move the new project directory (and all its files) to the root of your local git directory.
5. Run `$ git init` on the new project, and push it to the GitHub repo.
