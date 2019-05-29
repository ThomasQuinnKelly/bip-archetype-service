#!/bin/sh

## turn on to assist debugging ##
#export PS4='[$LINENO] '
#set -x
##

### helpful values
cwd="`pwd`"
thisScript="$0"
args="$@"

# the maven version to give the generated archetype
archetypeVersion="0.0.1-SNAPSHOT"
# the maven groupId to give the generated archetype
archetypeGroupId="gov.va.bip.archetype"
# the project name / artifactId to give the generated archetype
archetypeServiceName="bip-archetype-service"
# the project name / artifactId of the origin project
archetypeOriginName="bip-archetype-service-origin"
# the name of the properties file to use for velocity replacements
archetypeProperties="genarchetype.properties"
# the package name from the Origin project that is to be replaced in the generated archetype
archetypePackageName="gov.va.bip.origin"
# any file extensions that should be included in the velocity replacement processes
archetypeFilteredExtensions="md,java,xml,properties,txt,yaml,yml,sh,json,tpl,jmx,csv,feature,."
# the target directory that the generated archetype is initially created in
archetypeTargetDir="target/generated-sources/archetype"

# the output log file name
archetypeLog="$cwd/genarchetype.log"
# used for the return status from programs executed by this script
returnStatus=0
# the initial value for the "skip origin build" command line argument
skipOriginBuild=-1

## get argument options off of the command line        ##
## optional parameter: array of command-line arguments ##
## scope: private (internal calls only)                ##
function get_args() {
	#  echo "args: $@"
	# while getopts ":hs" opt; do
	while getopts ":hs" opt; do
		case $opt in
			h)
				# echo "-h \> show help" >&2
				show_help
				;;
			s)
				# echo "-a \> skip Origin Build" >&2
				skipOriginBuild=0
				;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				echo "Press Ctrl+C to abort, Enter to continue " >&2
				read
				;;
		esac
	done
	# shift $((OPTIND -1))
}

## function to display help             ##
## scope: private (internal calls only) ##
function show_help() {
	echo "" 2>&1 | tee -a "$archetypeLog"
	echo "Build BIP Service Archetype project:  $thisScript [-h|s]" 2>&1 | tee -a "$archetypeLog"
	echo "  -s   skip building the Origin project" 2>&1 | tee -a "$archetypeLog"
	echo "  -h   this help" 2>&1 | tee -a "$archetypeLog"
	echo "" 2>&1 | tee -a "$archetypeLog"
	echo "Notes:" 2>&1 | tee -a "$archetypeLog"
	echo "* This script operates on local clone of https://github.com/department-of-veterans-affairs/bip-archetype-service" 2>&1 | tee -a "$archetypeLog"
	echo "* This script will delete $cwd/$archetypeServiceName" 2>&1 | tee -a "$archetypeLog"
	echo "  You may want to back it up!" 2>&1 | tee -a "$archetypeLog"
	echo "* A valid \"gensvc.properties\" file must exist in the same directory" 2>&1 | tee -a "$archetypeLog"
	echo "  as this script." 2>&1 | tee -a "$archetypeLog"
	echo "* It is recommended that a git credential helper be utilized to" 2>&1 | tee -a "$archetypeLog"
	echo "  eliminate authentication requests while executing. For more info see" 2>&1 | tee -a "$archetypeLog"
	echo "  https://help.github.com/articles/caching-your-github-password-in-git/" 2>&1 | tee -a "$archetypeLog"
	echo "" >&2
	echo "Examples:" >&2
	echo "  \$ $thisScript" >&2
	echo "  \$ $thisScript -s" >&2
	echo "" >&2
	# force exit
	exit_now
}

## function to exit immediately                      ##
## optional parameter: exit code to use, default = 0 ##
## optional parameter: exit message                  ##
## scope: private (internal calls only)              ##
function exit_now() {
	exit_code=$1
	exit_message=$2
	if [ -z $exit_code ]; then
		exit_code=0
	fi
	if [ "$exit_message" != "" ]; then
		# Fatal error signal 128+n
		echo "$exit_message" 2>&1 | tee -a "$archetypeLog"
	fi
	echo " See \"$archetypeLog\", search \"+>> \" for script actions." 2>&1 | tee -a "$archetypeLog"
	echo " Use \"./genarchetype.sh -h\" for script usage help." 2>&1 | tee -a "$archetypeLog"
	echo "------------------------------------------------------------------------" 2>&1 | tee -a "$archetypeLog"
	exit $exit_code
}

## function for pre-processing checks   ##
## no parameters                        ##
## scope: private (internal calls only) ##
function pre_processing() {
	echo "+>> pwd = `pwd`" 2>&1 | tee -a "$archetypeLog"
	if [ ! -d "$archetypeOriginName" ] || [ ! -f "$archetypeOriginName/pom.xml" ] || [ ! -d "$archetypeOriginName/bip-origin" ] || [ ! -d "$archetypeOriginName/bip-origin-inttest" ]; then
		exit_now 1 "*** FAILURE: valid directory $archetypeOriginName does not exist.";
	fi

	if [ ! -f "$archetypeProperties" ]; then
		echo "*** FAILURE: missing file $archetypeProperties." 2>&1 | tee -a "$archetypeLog"
		echo "   Values should be:" 2>&1 | tee -a "$archetypeLog"
		echo "     excludePatterns=**/target,**/.settings/**,**/.project,**/.classpath,**/apt_*,**/.springBeans,**/.factorypath,**.docker-jar*" 2>&1 | tee -a "$archetypeLog"
		echo "     package=__groupId__" 2>&1 | tee -a "$archetypeLog"
		echo "     groupId=$archetypeGroupId" 2>&1 | tee -a "$archetypeLog"
		echo "     artifactId=bip-origin-reactor" 2>&1 | tee -a "$archetypeLog"
		echo "     artifactName=Origin" 2>&1 | tee -a "$archetypeLog"
		echo "     artifactNameLowerCase=origin" 2>&1 | tee -a "$archetypeLog"
		echo "     artifactNameUpperCase=ORIGIN" 2>&1 | tee -a "$archetypeLog"
		exit_now 1 "";
	fi

	echo "+>> This script will delete $archetypeServiceName and recreate it from $archetypeOriginName" 2>&1 | tee -a "$archetypeLog"
	if [ -d "$archetypeServiceName" ]; then
		echo "*** If desired, back up the existing $archetypeServiceName project before continuing." 2>&1 | tee -a "$archetypeLog"
	fi
	echo "    Press Enter to continue, or Ctrl+C to abort: " 2>&1 | tee -a "$archetypeLog"
	read
	echo "" 2>&1 | tee -a "$archetypeLog"
}

## function to build the Origin project ##
## no parameters                        ##
## scope: private (internal calls only) ##
function build_origin() {
	if [ "$skipOriginBuild" -ne "0" ]; then
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$archetypeLog"
		echo "cd $cwd/$archetypeOriginName" 2>&1 | tee -a "$archetypeLog"
		# tee does not play well with some bash commands, so just redirect output to the log
		cd "$cwd/$archetypeOriginName" 2>&1 >> "$archetypeLog"
		echo "+>> pwd = `pwd`" 2>&1 | tee -a "$archetypeLog"

		echo "+>> (Re)Building the archetype origin project" 2>&1 | tee -a "$archetypeLog"
		# maven clean has proven unreliable in some scenarios, so making sure target is wiped
		echo "rm -rf \$(find . -name 'target' -type d -maxdepth 4 | sed 's:\.\/::g')" 2>&1 | tee -a "$archetypeLog"
		rm -rf $(find . -name 'target' -type d -maxdepth 4 | sed 's:\.\/::g')  2>&1 >> "$archetypeLog"
		# now we get reliable maven target output
		echo "mvn clean install" 2>&1 | tee -a "$archetypeLog"
		mvn clean install -e -X 2>&1 | tee -a "$archetypeLog"
		returnStatus="$?"
		if [ "$returnStatus" -eq "0" ]; then
			echo "[OK]" 2>&1 | tee -a "$archetypeLog"
		else
			exit_now $returnStatus "*** FAILURE: 'mvn clean install' failed."
		fi
	fi
}

## function to create the bip-archetype-service project ##
## no parameters                                        ##
## scope: private (internal calls only)                 ##
function create_archetype() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$archetypeLog"
	echo "cd $cwd/$archetypeOriginName" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cd "$cwd/$archetypeOriginName" 2>&1 >> "$archetypeLog"
	echo "+>> pwd = `pwd`" 2>&1 | tee -a "$archetypeLog"

	if [ -d "./$archetypeTargetDir" ]; then
		echo "+>> Deleting existing ./$archetypeTargetDir directory" 2>&1 | tee -a "$archetypeLog"
		echo "rm -rf ./$archetypeTargetDir" 2>&1 | tee -a "$archetypeLog"
		# tee does not play well with some bash commands, so just redirect output to the log
		rm -rf "./$archetypeTargetDir" 2>&1 >> "$archetypeLog"
		returnStatus="$?"
		if [ "$returnStatus" -eq "0" ]; then
			echo "[OK]" 2>&1 | tee -a "$archetypeLog"
		else
			exit_now $returnStatus "*** FAILURE: could not delete $archetypeTargetDir."
		fi
	fi

	echo "+>> Creating the archetype in $archetypeTargetDir" 2>&1 | tee -a "$archetypeLog"
	echo -e "mvn archetype:create-from-project \x5c" 2>&1 | tee -a "$archetypeLog"
	echo -e "  -Darchetype.properties=../$archetypeProperties 	\x5c" 2>&1 | tee -a "$archetypeLog"
	echo -e "  -Darchetype.filteredExtentions=$archetypeFilteredExtensions \x5c" 2>&1 | tee -a "$archetypeLog"
	echo "  -DpackageName=$archetypePackageName" 2>&1 | tee -a "$archetypeLog"

	## NOTE: archetype.filteredExtentions is required to make create-from-project process non-java files.
	mvn archetype:create-from-project \
		-Darchetype.properties="../$archetypeProperties" \
		-Darchetype.filteredExtentions="$archetypeFilteredExtensions" \
		-DpackageName="$archetypePackageName" \
		-e -X 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: 'mvn archetype:create-from-project -D...' failed."
	fi
}

## function to clean up things in the archetype maven got wrong ##
## no parameters                                                ##
## scope: private (internal calls only)                         ##
function clean_archetype_files() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$archetypeLog"
	echo "cd $cwd/$archetypeOriginName" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cd "$cwd/$archetypeOriginName" 2>&1 >> "$archetypeLog"
	echo "+>> pwd = `pwd`" 2>&1 | tee -a "$archetypeLog"

	echo "+>> Cleaning up the created archetype in place: $archetypeTargetDir" 2>&1 | tee -a "$archetypeLog"

	#########################################################
	## NOTE sed *always* returns "0" as its exit code      ##
	##      regardless if it succeeds or not. If changes   ##
	##      are made to sed commands, you must check the   ##
	##      genarchetype.log (search "sed -i") to verify   ##
	##      that no sed error messages follow the command  ##
	#########################################################

	## clean up the archetype POM ##

	modFile="./$archetypeTargetDir/pom.xml"
	echo "+>> Fix $modfile in place"

	# replace archetype package/groupId
	oldVal="gov.va.bip.origin"
	newVal="gov.va.bip.archetype.service"
	echo "sed -i \"\" -e \'s/\'\"$oldVal\"\'/\'\"$newVal\"\'/g\' \"$modFile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$archetypeLog"
	# replace archetype name/artifactId
	oldVal="bip-origin-reactor-archetype"
	newVal="bip-archetype-service"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$archetypeLog"
	# replace archetype description
	oldVal="BIP Origin Service"
	newVal="BIP Service Archetype"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$archetypeLog"

	# delete the bad url tag # oldVal: slashes and double-quotes (and possibly commas) must be escaped
	oldVal="<url>https:\/\/github.com\/spring-projects\/spring-boot\/spring-boot-starter-parent\/bip-framework-parentpom\/bip-origin-reactor<\/url>"
	newVal=""
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$archetypeLog"
	# delete the scm tag
	oldVal="<scm>"
	newVal=""
	echo "sed -i \"\" -e '/'\"$oldVal\"'/d' \"$modFile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e '/'"$oldVal"'/d' "$modFile" 2>&1 >> "$archetypeLog"

	# replace the bad URLs # oldVal: slashes and double-quotes (and possibly commas) must be escaped
	oldVal="<url>https:\/\/projects.spring.io\/spring-boot\/#\/spring-boot-starter-parent\/bip-framework-parentpom\/bip-origin-reactor<\/url>"
	newVal="<repositories><!-- ADD REPOSITORIES HERE --><\/repositories>"
	echo "sed -i \"\" -e '/'\"$oldVal\"'/d' \"$modFile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e '/'"$oldVal"'/d' "$modFile" 2>&1 >> "$archetypeLog"
	# replace the scm end tag # oldVal: slashes and double-quotes (and possibly commas) must be escaped
	oldVal="<\/scm>"
	newVal="<pluginrepositories><!-- ADD PLUGIN REPOSITORIES HERE --><\/pluginrepositories>"
	echo "sed -i \"\" -e '/'\"$oldVal\"'/d' \"$modFile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e '/'"$oldVal"'/d' "$modFile" 2>&1 >> "$archetypeLog"

	# now also have to clean up after sed
	if [ -f "$modFile-e" ]; then
		echo "+>> Remove sed artifacts" 2>&1 | tee -a "$archetypeLog"
		echo "rm -fv $modFile-e" 2>&1 | tee -a "$archetypeLog"
		# tee does not play well with some bash commands, so just redirect output to the log
		rm -fv "$modFile-e" >> "$archetypeLog"
	fi

	## Clean up references ##

	## Can't find a way to include "no extension" files in mavens archetype:create-from-project filteredExtensions list
	modFile="./$archetypeTargetDir/src/main/resources/archetype-resources"
	echo "+>> Preparing $modFile extension-less files" 2>&1 | tee -a "$archetypeLog"

	# Jenkinsfile
	oldVal="bip-origin"
	newVal="__artifactId__"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile/Jenkinsfile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile/Jenkinsfile" 2>&1 >> "$archetypeLog"

	# Dockerfile
	oldVal="bip-origin"
	newVal="__artifactId__"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile/__rootArtifactId__/Dockerfile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile/__rootArtifactId__/Dockerfile" 2>&1 >> "$archetypeLog"

	# Because framework shares the same base package as services, need to go back and fix framework references
	# change "import ${package\}.framework" back to "import gov.va.bip.framework"
	echo "find $archetypeTargetDir/src -name '*.java' -type f -print0 | xargs -0 sed -i \"\" 's/import \${package\}.framework/import\ gov\.va\.bip\.framework/g'" 2>&1 | tee -a "$archetypeLog"
	find $archetypeTargetDir/src -name '*.java' -type f -print0 | xargs -0 sed -i "" 's/import ${package\}.framework/import\ gov\.va\.bip\.framework/g' 2>&1 >> "$archetypeLog"

	# fix archetype-metadata.xml to reflect upcoming directory changes
	modFile="./$archetypeTargetDir/src/main/resources/META-INF/maven/archetype-metadata.xml"
	echo "+>> Fix $modfile in place" 2>&1 | tee -a "$archetypeLog"
	# artifact id replacement
	oldVal="bip-origin"
	newVal="__rootArtifactId__"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$archetypeLog"
	# camelcase replacement
	oldVal="Origin"
	newVal="__artifactName__"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$archetypeLog"
	# lowercase replacement
	oldVal="origin"
	newVal="__artifactNameLowerCase__"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$archetypeLog"
	# uppercase replacement
	oldVal="ORIGIN"
	newVal="__artifactNameUpperCase__"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$archetypeLog"

	# fix the test properties to reflect the upcoming directory name changes
	modFile="./$archetypeTargetDir/src/test/resources/projects/basic/archetype.properties"
	echo "+>> Fix $modfile in place"
	# camelcase replacement
	oldVal="Origin"
	newVal="__artifactName__"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$archetypeLog"
	# lowercase replacement
	oldVal="origin"
	newVal="__artifactNameLowerCase__"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$archetypeLog"
	# uppercase replacement
	oldVal="ORIGIN"
	newVal="__artifactNameUpperCase__"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a "$archetypeLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$archetypeLog"

	## Make backup copies of maven files that ./gensvc.sh will have to modify ##

	# keep original of archetype-metadata.xml
	echo "+>> Make '*_ORIGINAL.xml' back up of archetype-metadata.xml" 2>&1 | tee -a "$archetypeLog"
	echo "cp -fv ./$archetypeTargetDir/src/main/resources/META-INF/maven/archetype-metadata.xml $./archetypeTargetDir/src/main/resources/META-INF/maven/archetype-metadata_ORIGINAL.xml" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -fv "./$archetypeTargetDir/src/main/resources/META-INF/maven/archetype-metadata.xml" "./$archetypeTargetDir/src/main/resources/META-INF/maven/archetype-metadata_ORIGINAL.xml" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: could not copy ./$archetypeTargetDir/src/main/resources/META-INF/maven/archetype-metadata.xml to ./$archetypeTargetDir/src/main/resources/META-INF/maven/archetype-metadata_ORIGINAL.xml"
	fi

	# keep original of archetype.properties
	echo "+>> Make '*_ORIGINAL.properties' back up of archetype.properties" 2>&1 | tee -a "$archetypeLog"
	echo "cp -fv ./$archetypeTargetDir/src/test/resources/projects/basic/archetype.properties ./$archetypeTargetDir/src/test/resources/projects/basic/archetype_ORIGINAL.properties" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -fv "./$archetypeTargetDir/src/test/resources/projects/basic/archetype.properties" "./$archetypeTargetDir/src/test/resources/projects/basic/archetype_ORIGINAL.properties" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: ./$archetypeTargetDir/src/test/resources/projects/basic/archetype.properties to ./$archetypeTargetDir/src/test/resources/projects/basic/archetype_ORIGINAL.properties"
	fi

	# keep original of Jenkinsfile
	echo "+>> Make 'Jenkinsfile_ORIGINAL' back up of Jenkinsfile" 2>&1 | tee -a "$archetypeLog"
	echo "cp -fv ./$archetypeTargetDir/src/main/resources/archetype-resources/Jenkinsfile ./$archetypeTargetDir/src/main/resources/archetype-resources/Jenkinsfile_ORIGINAL" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -fv "./$archetypeTargetDir/src/main/resources/archetype-resources/Jenkinsfile" "./$archetypeTargetDir/src/main/resources/archetype-resources/Jenkinsfile_ORIGINAL" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: could not copy ./$archetypeTargetDir/src/main/resources/archetype-resources/Jenkinsfile to ./$archetypeTargetDir/src/main/resources/archetype-resources/Jenkinsfile_ORIGINAL"
	fi

	# keep original of Dockerfile
	echo "+>> Make 'Dockerfile_ORIGINAL' back up of Dockerfile" 2>&1 | tee -a "$archetypeLog"
	echo "cp -fv ./$archetypeTargetDir/src/main/resources/archetype-resources/bip-origin/Dockerfile ./$archetypeTargetDir/src/main/resources/archetype-resources/bip-origin/Dockerfile_ORIGINAL" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -fv "./$archetypeTargetDir/src/main/resources/archetype-resources/bip-origin/Dockerfile" "./$archetypeTargetDir/src/main/resources/archetype-resources/bip-origin/Dockerfile_ORIGINAL" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: could not copy ./$archetypeTargetDir/src/main/resources/archetype-resources/bip-origin/Dockerfile to ./$archetypeTargetDir/src/main/resources/archetype-resources/bip-origin/Dockerfile_ORIGINAL"
	fi

	## Copy files from the archive folder ##

	# copy .gitignore
	echo "+>> Copy .gitignore file into the archetype" 2>&1 | tee -a "$archetypeLog"
	echo "cp -fv $cwd/$archetypeOriginName/archive/.gitignore ./$archetypeTargetDir/.gitignore" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -fv "$cwd/$archetypeOriginName/archive/.gitignore" "./$archetypeTargetDir/.gitignore" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: could not copy ./$archetypeOriginName/archive/.gitignore to ./$archetypeTargetDir/.gitignore"
	fi

	# copy the base README for new projects
	echo "+>> Copy basic README.md for new projects" 2>&1 | tee -a "$archetypeLog"
	echo "cp -fv $cwd/$archetypeOriginName/archive/$archetypeServiceName-newprojects-README.md ./$archetypeTargetDir/src/main/resources/archetype-resources/README.md" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -fv "$cwd/$archetypeOriginName/archive/$archetypeServiceName-newprojects-README.md" "./$archetypeTargetDir/src/main/resources/archetype-resources/README.md" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: ./$archetypeOriginName/archive/$archetypeServiceName-newprojects-README.md to ./$archetypeTargetDir/src/main/resources/archetype-resources/README.md"
	fi

	# copy the README for the archetype project
	echo "+>> Copy README.md for $archetypeServiceName archetype project" 2>&1 | tee -a "$archetypeLog"
	echo "cp -fv $cwd/$archetypeOriginName/archive/$archetypeServiceName-archetype-README.md ./$archetypeTargetDir/README.md" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -fv "$cwd/$archetypeOriginName/archive/$archetypeServiceName-archetype-README.md" "./$archetypeTargetDir/README.md" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: could not copy $cwd/$archetypeOriginName/archive/$archetypeServiceName-archetype-README.md to ./$archetypeTargetDir/README.md"
	fi

	## Remove unnecessary files from the generated archetype ##

	# remove archive directory
	echo "+>> Remove the archive directory from the archetype" 2>&1 | tee -a "$archetypeLog"
	echo "rm -rfv ./$archetypeTargetDir/src/main/resources/archetype-resources/archive" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	rm -rfv "./$archetypeTargetDir/src/main/resources/archetype-resources/archive" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: could not delete $archetypeTargetDir/archive/"
	fi

	# remove archetype target directory
	echo "+>> Remove the target directory from the archetype" 2>&1 | tee -a "$archetypeLog"
	echo "rm -rfv ./$archetypeTargetDir/target/" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	rm -rfv "./$archetypeTargetDir/target/" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: could not delete $archetypeTargetDir/archive/"
	fi
}

## function to rename "origin" directories to the new name  ##
##     should be able to do this in the command for         ##
##         mvn archetype:create-from-project -D...          ##
##     but can't figure it out (or just not possible)       ##
## no parameters                                            ##
## scope: private (internal calls only)                     ##
function rename_archetype_origin_dirs() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$archetypeLog"
	echo "cd $cwd/$archetypeOriginName/$archetypeTargetDir" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cd "$cwd/$archetypeOriginName/$archetypeTargetDir" 2>&1 >> "$archetypeLog"
	echo "+>> pwd = `pwd`" 2>&1 | tee -a "$archetypeLog"

	echo "+>> Renaming directories in place: $archetypeTargetDir" 2>&1 | tee -a "$archetypeLog"

	dirArray=(`find ./src -name '*origin*' -type d -maxdepth 4 | sed 's:\.\/::g'`)
	echo "+>> Found directories to rename: ${dirArray[@]}" 2>&1 | tee -a "$archetypeLog"
	echo "" 2>&1 | tee -a "$archetypeLog"
	for d in "${dirArray[@]}"
	do
		echo "mv -f -v $d \${$d//bip-origin/__rootArtifactId__}" 2>&1 | tee -a "$archetypeLog"
		# tee does not play well with some bash commands, so just redirect output to the log
		mv -f -v "$d" "${d//bip-origin/__rootArtifactId__}" 2>&1 >> "$archetypeLog"
		returnStatus="$?"
		if [ "$returnStatus" -eq "0" ]; then
			echo "[OK]" 2>&1 | tee -a "$archetypeLog"
		else
			exit_now $returnStatus "*** FAILURE: could not rename directory $d."
		fi
	done
}

## function to delete the old archetype directory ##
## no parameters                                  ##
## scope: private (internal calls only)           ##
function delete_old_archetype() {
	if [ -d $cwd/$archetypeServiceName ]; then
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$archetypeLog"
		echo "+>> Deleting old $archetypeServiceName directory" 2>&1 | tee -a "$archetypeLog"
		echo "rm -rf $cwd/$archetypeServiceName" 2>&1 | tee -a "$archetypeLog"
		# tee does not play well with some bash commands, so just redirect output to the log
		rm -rf "$cwd/$archetypeServiceName" 2>&1 >> "$archetypeLog"
		returnStatus="$?"
		if [ "$returnStatus" -eq "0" ]; then
			echo "[OK]" 2>&1 | tee -a "$archetypeLog"
		else
			exit_now $returnStatus "*** FAILURE: could not delete directory $cwd/$archetypeServiceName."
		fi
	fi
}

## function to copy the new archetype to bip-archetype-service ##
## no parameters                                               ##
## scope: private (internal calls only)                        ##
function copy_archetype() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$archetypeLog"
	echo "cd $cwd/$archetypeOriginName" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cd "$cwd/$archetypeOriginName" 2>&1 >> "$archetypeLog"
	echo "+>> pwd = `pwd`" 2>&1 | tee -a "$archetypeLog"

	## Copy the generated-sources/archetype directory, then rename it to the correct name ##
	## Doing it this way due to behavior of cp in this situation                          ##

	echo "+>> Copy archetype files to $archetypeServiceName" 2>&1 | tee -a "$archetypeLog"
	echo "cp -R -f ./$archetypeTargetDir ../" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -R -f "./$archetypeTargetDir" "../" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: could not copy ./$archetypeTargetDir/* to ../"
	fi

	echo "+>> Rename directory ../archetype" 2>&1 | tee -a "$archetypeLog"
	echo "mv -f -v ../archetype ../$archetypeServiceName" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	mv -f -v "../archetype" "../$archetypeServiceName" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: could not rename ../archetype to ../$archetypeServiceName"
	fi

	## for some reason, above copy does NOT copy $archetypeTargetDir/.gitignore, so will do it manually here ##
	echo "+>> Copy .gitignore file into the archetype" 2>&1 | tee -a "$archetypeLog"
	echo "cp -f ./$archetypeTargetDir/.gitignore ../$archetypeServiceName/.gitignore" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -f "./$archetypeTargetDir/.gitignore" "../$archetypeServiceName/.gitignore" 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE: could not copy ./$archetypeTargetDir/.gitignore to ../$archetypeServiceName/.gitignore"
	fi
}

## function to install the archetype in the local m2 repo ##
## no parameters                                          ##
## scope: private (internal calls only)                   ##
function install_archetype() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$archetypeLog"
	echo "" 2>&1 | tee -a "$archetypeLog"
	echo "cd $cwd/$archetypeServiceName" 2>&1 | tee -a "$archetypeLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cd "$cwd/$archetypeServiceName" 2>&1 >> "$archetypeLog"
	echo "+>> pwd=`pwd`" 2>&1 | tee -a "$archetypeLog"

	echo "+>> Install the archetype" 2>&1 | tee -a "$archetypeLog"
	echo "mvn install" 2>&1 | tee -a "$archetypeLog"
	mvn install -e -X 2>&1 >> "$archetypeLog"
	returnStatus="$?"
	if [ "$returnStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a "$archetypeLog"
	else
		exit_now $returnStatus "*** FAILURE, 'mvn install' failed."
	fi
}

####################################
### Script execution begins here ###
####################################

## output header info, get the log started ##

echo "" 2>&1 | tee "$archetypeLog"
echo "=========================================================================" 2>&1 | tee -a "$archetypeLog"
echo "Generate $archetypeServiceName" 2>&1 | tee -a "$archetypeLog"
echo "=========================================================================" 2>&1 | tee -a "$archetypeLog"
echo "" 2>&1 | tee -a "$archetypeLog"

## call each function in order ##

get_args $args
pre_processing
build_origin
create_archetype
clean_archetype_files
rename_archetype_origin_dirs
delete_old_archetype
copy_archetype
install_archetype

## success message (didn't exit_now anwhere along the way) ##

cd "$cwd"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$archetypeLog"
echo "+>> Archetype project created: $archetypeServiceName" 2>&1 | tee -a "$archetypeLog"

echo "   To generate a new service project:" 2>&1 | tee -a "$archetypeLog"
echo "   - ensure values in gensvc.properties are correct" 2>&1 | tee -a "$archetypeLog"
echo "   - ensure gensvc.sh is executable:" 2>&1 | tee -a "$archetypeLog"
echo "     \$ chmod +x gensvc.sh" 2>&1 | tee -a "$archetypeLog"
echo "   - execute gensvc.sh" 2>&1 | tee -a "$archetypeLog"
echo "     \$ ./gensvc.sh" 2>&1 | tee -a "$archetypeLog"
echo "" 2>&1 | tee -a "$archetypeLog"
echo " ##################################################################################" 2>&1 | tee -a "$archetypeLog"
echo " ## NOTE                                                                         ##" 2>&1 | tee -a "$archetypeLog"
echo " ## You must manually edit the root archetype /pom.xml to add <repository> tags. ##" 2>&1 | tee -a "$archetypeLog"
echo " ## These can be copied from any other BIP reactor project.                      ##" 2>&1 | tee -a "$archetypeLog"
echo " ## SEE: https://github.com/department-of-veterans-affairs/bip-archetype-service ##"
echo " ##################################################################################" 2>&1 | tee -a "$archetypeLog"
echo "" 2>&1 | tee -a "$archetypeLog"
exit_now 0
