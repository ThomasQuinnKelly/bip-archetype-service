# BIP Service Archetype Project

This repository is comprised of:

- An origin (or source) project from which new BIP Service projects can be created.
- A script that can be used to create the new BIP Service project.

A newly created artifact will contain a skeleton project with some rudimentary sample data objects demonstrating a simple use case.

To prepare and publish a new project for development, Tech Leads have only a couple straight forward tasks, as outlined below.

## Getting the BIP Archetype Service project

The root project directory hosts the `bip-archetype-service-origin` project. This project contains the Origin service app (that is, the "source" project) from which new BIP Service projects can be created.

1. Clone the project:

  - `$ cd ~/git`
  - `$ git clone https://github.com/department-of-veterans-affairs/bip-archetype-service`

2. Import into an appropriate IDE workspace.

  - It is not necessary to add the root directory (where the `gen.sh` script is) to your IDE. If you wish to do so, you will likely require a separate workspace just for that project.

  - To add the `bip-archetype-service-origin` project, import it to your IDE workspace as you would any other existing maven project.

## About The Origin Project

The `bip-archetype-service-origin` project contains the origin (or "source") project from which the archetype can be created. This project is based on the [bip-reference -person](https://github.com/department-of-veterans-affairs/bip-reference-person) project, with some sample features removed, and necessary naming genericized.

This project need only be modified when there are new features or capabilities to be included in a new generation of BIP Service projects.

See the [bip-archetype-service-origin README.md](./bip-archetype-service-origin/README.md) for details on modifying the Origin project.

## Generating a New Project

1. Update `gen.properties`. Read the comments in the properties file for each property. Existing property values provide examples of how they should appear.
2. Generate the new project and read at least the last few lines of the script output. Example from the command line:

  ```bash
  $ cd ~/git/bip-archetype-service
  $ chmod +x gen.sh # optional if the script is not yet executable
  $ ./gen.sh
  ```

3. Move the project to the desired local git directory. For example:

  ```bash
  $ cd ~/git/bip-archetype-service
  $ mv [new-project-dir] ~/git/[new-project-dir]
  ```

4. Make any desired changes, for example remove the sample objects, add real data objects, add skeleton API, add skeleton service methods/classes, etc.

5. Make an initial commit to publish to a GitHub branch. For an example of how to do this, see [git_newrepo](https://gist.github.com/c0ldlimit/4089101).
