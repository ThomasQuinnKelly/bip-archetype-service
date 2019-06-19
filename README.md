# BIP Service Archetype Project

This project **_is not_** a "maven archetype" because the `archetype:create-from-project` and `archetype:generate` mojos were not built for the task undertaken here, and they introduce a great deal of unnecessary complexity with unresolvable circular processes.

This project **_is_** an archetypal process from which an "origin" (or "source") project can be used to create the skeleton for a new BIP Service project.

This repository is comprised of:

- An origin (or source) project from which new BIP Service projects can be created.
- A script that can be used to create the new BIP Service project.

The newly created artifact will contain a skeleton project with some rudimentary sample data objects demonstrating a simple use case.

To prepare and publish a new project for development, Tech Leads have only a few straight forward tasks, as outlined below.

## Getting the BIP Archetype Service project

The root project directory hosts the `bip-archetype-service-origin` project. This project contains the Origin service app (that is, the "source" project) from which new BIP Service projects can be created.

1. Clone the project:

  - `$ cd ~/git`
  - `$ git clone https://github.com/department-of-veterans-affairs/bip-archetype-service`

2. Import into an appropriate IDE workspace.

  - It is not necessary to add the root directory (where the `gen.sh` script is) to your IDE. If you wish to do so, you will likely require a separate workspace just for that project.

  - To add the `bip-archetype-service-origin` project, import it to your IDE workspace as you would any other existing maven project.

## About The Origin Project

The `bip-archetype-service-origin` project contains the origin (or "source") project from which the new project can be created. This project is based on the [bip-reference -person](https://github.com/department-of-veterans-affairs/bip-reference-person) project, with some sample features removed, and necessary naming genericized.

This project need only be modified when there are new features or capabilities to be included in a new generation of BIP Service projects.

See the [bip-archetype-service-origin README.md](./bip-archetype-service-origin/README.md) for details on modifying the Origin project.

## Generating a New Project

The `gen.sh` script is central to generating a new project skeleton.

Script help can be displayed by executing `./gen.sh -h`

### Steps to generate a new skeleton project

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

5. Make an initial commit to publish to a GitHub branch. For an example of how to do this, see [git_newrepo](https://gist.github.com/c0ldlimit/4089101) - the only difference is that you may want to commit into some branch other than _master_.

# Getting Started With Your New Service Application

The [reference application](https://github.com/department-of-veterans-affairs/bip-reference-person) is a real functioning app  with concrete implementations of recommended code patterns. It provides examples for the fundamental capabilities that must exist in any BIP service application.
