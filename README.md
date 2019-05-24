# BIP Service Archetype Projects

This project contains two maven projects for creating and maintaining a Maven service archetype for the BIP Platform.

NOTE: When you clone this repo, you will get a root `bip-service-archetype` folder that contains this README, and eventually will receive a script and properties file. This folder does not contain a POM, and will likely not be directly accessible from your IDE. During generation of an archetype, you will need to use your command line to access the `gensvc` script.

Maven documentation for archetype:create-from-project and archetype:generate is abysmal, and is sometimes misleading _**or just plain wrong**_. Unfortunately internet search is not your friend either, as most of the posts out there are for ancient versions or are also wrong. Nonetheless, here are some links that can get your _guess-try-guess-again_ adventures ...

**General**

Maven Archetype Plugin: <https://maven.apache.org/archetype/maven-archetype-plugin/index.html>

GitHub source: <https://github.com/apache/maven-archetype/tree/maven-archetype-3.1.0>

**Create from project**

Docs for create-from-project: <https://maven.apache.org/archetype/maven-archetype-plugin/create-from-project-mojo.html>

Somewhat helpful blog entry: <https://intellectualcramps.wordpress.com/2011/04/15/maven-archetype-creation-tips/>

Maven catalog: <https://maven.apache.org/archetype/maven-archetype-plugin/examples/generate-alternative-catalog.html>

**Generate**

Docs for generate: <https://maven.apache.org/archetype/maven-archetype-plugin/generate-mojo.html>

## Getting the BIP Archetype Service project

Because this project hosts two separate maven projects, setting up a workspace _may_ be different than usual, depending on what IDE you are using.

1. Clone the project:

  - `$ cd ~/git`
  - `$ git clone https://github.com/department-of-veterans-affairs/bip-archetype-service`

2. To get the root project into your IDE, you will likely need to create separate workspaces, one for the root `bip-archetype-service` project for access to the scripts and this README, and another for the `bip-archetype-service-origin` and `bip-archetype-service` projects so maven can be executed properly on them.

  - For the root project:

    - Start (or open) a `bip-archetype-service-root` (or similar name expressing that it is for the root archetype project) workspace
    - Select _File > Import... > General > Existing Projects into Workspace_
    - In the Import Folder dialog, use _Browse_ to select your root `~/git/bip-archetype-service` folder.

      - The _Projects_ list should display one project (make sure _Options > Search for nested projects_ is **un-clicked**)

    - Click _Finish_ to import the directory

    - NOTE that the maven integrations will not work for the origin and archetype in this workspace, so eclipse will report errors. Ignore them, as java/maven work should be done in a different workspace.

  - For the java/maven projects:

    - Start (or open) a `bip-archetype-service` workspace
    - Select _File > Import... > Maven > Existing Maven Projects_
    - Click _Next_ and use _Browse_ to select `~/git/bip-archetype-service-origin`
    - Select the presented projects from the _Projects_ list, and click _Finish_
    - REPEAT the above _File > Import_ steps for the `~/git/bip-archetype-service` project

3. Each workspace will now contain the relevant projects for the two types of activities you will need to undertake: maintain the root scripts and files; modify/run/test the maven projects.

## The Origin Project

The `bip-archetype-service-origin` project contains the origin (or "source") project from which the archetype can be created. This project is based on the [bip-reference -person](https://github.com/department-of-veterans-affairs/bip-reference-person) project, with some sample features removed, and necessary naming genericized.

This project need only be modified when there are new features or capabilities to be included in a new generation of the `bip-archetype-service`. The steps required to generate the archetype and copy its files to the correct location are encoded in the `genarchetype.sh` script.

See the [bip-archetype-service-origin README.md](./bip-archetype-service-origin/README.md) for details on modifying the Origin project.

## The Service Archetype Project

The `bip-archetype-service` project is somewhat ephemeral - it is deleted and recreated every time the "genarchetype" function in `bip-archetype-service-origin` is invoked - something that only occurs when changes are desired in the archetype.

The current incarnation of `bip-archetype-service` is the project from which new BIP Platform service projects are created. The steps required to generate a new project from the archetype are encoded in the `gensvc.sh` script.

See the [bip-archetype-service README.md](bip-archetype-service/README.md) for detailed information about creating a new project from the archetype.
