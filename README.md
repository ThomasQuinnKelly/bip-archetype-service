# BIP Service Archetype Projects

This project contains two maven projects for creating and maintaining a Maven service archetype for the BIP Platform.

NOTE: When you clone this repo, you will get a `bip-service-archetype-root` folder that contains this README, and eventually will receive a script and properties file. This folder does not contain a POM, and will likely not be directly accessible from your IDE. During generation of an archetype, you will need to use your command line to access the `gensvc` script.

## The Origin Project

The `bip-archetype-service-origin` project contains the origin (or "source") project from which the archetype can be created. This project is based on the [bip-reference -person](https://github.com/department-of-veterans-affairs/bip-reference-person) project, with some sample features removed, and necessary naming genericized.

### Making Changes to the Origin Project

This project need only be modified when there are new features or capabilities to be included in a new generations of the `bip-archetype-service`. The steps required to generate the archetype and copy its files to the correct location are encoded in the `genarchetype.sh` script.

After reviewing the content below, please read the detailed information provided in [bip-archetype-service-origin README.md](./bip-archetype-service-origin/README.md).

Overview for changing the origin service and updating the archetype:

1. Clone the archetype project from GitHub: <https://github.com/department-of-veterans-affairs/bip-archetype-service>
2. Add the `bip-archetype-service-origin` project as an existing Maven Project to the workspace of your IDE.
3. Perform a `mvn clean install` on the project, ensuring that

  - the project builds without error from the command line and in your IDE

    - any build and IDE-related issues are resolved

  - the spring-boot server can successfully be started

  - the [localhost swagger page](http://localhost:8080/swagger-ui.html) responds as expected

4. Make the desired changes, keeping in mind that this is a _generic_ project

  - The naming convention for the project itself is _origin_ (or _Origin_, depending on context); full-text search for occurrences of this name
  - Anything related to data or pattern examples are named _sample_ (or _Sample_, depending on the context); full-text search for occurrences of this name

5. Test all changes by building the archetype - see instructions at [bip-archetype-service-origin/README.md](./bip-archetype-service-origin/README.md)

6. Build a test project from the archetype - see instructionsn at [bip-archetype-service/README.md](./bip-archetype-service/README.md)..

7. Run the test project and open its [localhost swagger page](http://localhost:8080/swagger-ui.html) to make sure everything functions as expected.

8. Delete the test project.

9. Manually push the changes from the command line:

  - `$ cd ~/git/bip-archetype-service-root`

  - `$ git add .`

  - `$ git commit -m "YOUR COMMIT COMMENT"`

## The Service Archetype Project

The `bip-archetype-service` project is somewhat ephemeral - it is deleted and recreated every time the "genarchetype" function in `bip-archetype-service-origin` is invoked - something that only occurs when changes are desired in the archetype.

The current incarnation of `bip-archetype-service` is the project from which new BIP Platform service projects are created. The steps required to generate a new project from the archetype are encoded in the `gensvc.sh` script.

See the [bip-archetype-service README.md](bip-archetype-service/README.md) for detailed information about creating a new project from the archetype.
