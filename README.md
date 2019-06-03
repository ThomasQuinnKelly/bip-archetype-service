# BIP Service Archetype Project

## Getting the BIP Archetype Service project

The root project directory hosts the `bip-archetype-service-origin` project. This project contains the Origin service app (that is, the "source" project) from which new BIP Service projects can be created.

1. Clone the project:

  - `$ cd ~/git`
  - `$ git clone https://github.com/department-of-veterans-affairs/bip-archetype-service`

2. Import into appropriate IDE workspace.

  - It is not necessary to add the root directory (where the `gen.sh` script is) to your IDE. If you wish to do so, you will likely require a separate workspace just for that project.

  - To add the `bip-archetype-service-origin` project, import it to your IDE workspace as you would any other existing maven project.

## The Origin Project

The `bip-archetype-service-origin` project contains the origin (or "source") project from which the archetype can be created. This project is based on the [bip-reference -person](https://github.com/department-of-veterans-affairs/bip-reference-person) project, with some sample features removed, and necessary naming genericized.

This project need only be modified when there are new features or capabilities to be included in a new generation of BIP Service projects.

See the [bip-archetype-service-origin README.md](./bip-archetype-service-origin/README.md) for details on modifying the Origin project.

## Generating a New Project

From the command line:

```bash
$ cd ~/git/bip-archetype-service
    $ chmod +x gen.sh # optional if the script is not yet executable
    $ ./gen.sh -h
```

The help option (`-h`) will show the available options. The first time the script is run, it is suggested to not use any of the options, to ensure a complete and legitimate build. It is, of course, your option.
