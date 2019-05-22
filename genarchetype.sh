#!/bin/sh

## turn on to assist debugging ##
#export PS4='[$LINENO] '
#set -x
##

### helpful values
cwd="`pwd`"
thisScript="$0"
args="$@"

rootDir="bip-archetype-service-root"
archetypeVersion="0.0.1-SNAPSHOT"
archetypeGroupId="gov.va.bip.archetype"
archetypeServiceName="bip-archetype-service"
archetypeOriginName="bip-archetype-service-origin"
archetypeProperties="genarchetype.properties"
archetypePackageName="gov.va.bip.origin"
archetypeStatus=0
archetypeTargetDir="target/generated-sources/archetype"
archetypeLog="$cwd/genarchetype.log"

skipOriginBuild=false

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
				skipOriginBuild=true
				;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				echo "Press Ctrl+C to abort, Enter to continue " >&2
				read
				;;
		esac
	done
}

## function to display help             ##
## scope: private (internal calls only) ##
function show_help() {
	echo "" >&2
	echo "Build BIP Service Archetype project:  $thisScript [-h|s]" >&2
	echo "  -s   skip building the Origin project" >&2
	echo "  -h   this help" >&2
	echo "" >&2
	echo "Notes:" >&2
	echo "* This script operates on local clone of https://github.com/department-of-veterans-affairs/bip-archetype-service" >&2
	echo "* This script will delete $cwd/$archetypeServiceName" >&2
	echo "  You may want to back it up!" >&2
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
	if [ ! "$exit_message" == "" ]; then
		# Fatal error signal 128+n
		echo "$exit_message" 2>&1 | tee -a $archetypeLog
		echo "See '$archetypeLog' for details." 2>&1 | tee -a $archetypeLog
	fi
	exit $exit_code
}

## function for pre-processing checks   ##
## no parameters                        ##
## scope: private (internal calls only) ##
function pre_processing() {
	echo ">> pwd = `pwd`" 2>&1 | tee -a $archetypeLog
	if ! [[ "$cwd" == *"$rootDir"* ]]; then
		exit_now 1 "*** FAILURE, this script must be run from $rootDir.";
	fi
	if [ ! -d "$archetypeOriginName" ]; then
		exit_now 1 "*** FAILURE: directory $archetypeOriginName does not exist.";
	fi
	if [ ! -f "$archetypeProperties" ]; then
		echo "*** FAILURE: missing file $archetypeProperties." 2>&1 | tee -a $archetypeLog
		echo "   Values should be:" 2>&1 | tee -a $archetypeLog
		echo "     archetype.groupId=$archetypeGroupId" 2>&1 | tee -a $archetypeLog
		echo "     archetype.artifactId=$archetypeServiceName" 2>&1 | tee -a $archetypeLog
		echo "     archetype.version=$archetypeVersion" 2>&1 | tee -a $archetypeLog
		echo "     archetype.languages=java" 2>&1 | tee -a $archetypeLog
		exit_now 1 "";
	fi

	echo ">> This script will delete $archetypeServiceName and recreate it from $archetypeOriginName" 2>&1 | tee -a $archetypeLog
	if [ -d "$archetypeServiceName" ]; then
		echo "*** If desired, back up the existing $archetypeServiceName project before continuing." 2>&1 | tee -a $archetypeLog
	fi
	echo "    Press Enter to continue, or Ctrl+C to abort: " 2>&1 | tee -a $archetypeLog
	read
	echo "" 2>&1 | tee -a $archetypeLog
}

## function to build the Origin project ##
## no parameters                        ##
## scope: private (internal calls only) ##
function build_origin() {
	if [[ ! $skipOriginBuild ]]; then
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a $archetypeLog
		echo "cd $cwd/$archetypeOriginName" 2>&1 | tee -a $archetypeLog
		# tee does not play well with some bash commands, so just redirect output to the log
		cd $cwd/$archetypeOriginName 2>&1 >> $archetypeLog
		echo ">> pwd = `pwd`" 2>&1 | tee -a $archetypeLog

		echo ">> Building archetype origin project" 2>&1 | tee -a $archetypeLog
		# maven clean has proven unreliable in some scenarios, so making sure target is wiped
		echo "rm -rf \$(find . -name 'target' -type d -maxdepth 4 | sed 's:\.\/::g')"
		rm -rf $(find . -name 'target' -type d -maxdepth 4 | sed 's:\.\/::g')
		# now we get reliable maven target output
		echo "mvn clean install" 2>&1 | tee -a $archetypeLog
		mvn clean install 2>&1 | tee -a $archetypeLog
		archetypeStatus="$?"
		if [ "$archetypeStatus" -eq "0" ]; then
			echo "[OK]" 2>&1 | tee -a $archetypeLog
		else
			exit_now $archetypeStatus "*** FAILURE: 'mvn clean install' failed."
		fi
	fi
}

## function to create the bip-archetype-service project ##
## no parameters                                        ##
## scope: private (internal calls only)                 ##
function create_archetype() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a $archetypeLog
	echo "cd $cwd/$archetypeOriginName" 2>&1 | tee -a $archetypeLog
	# tee does not play well with some bash commands, so just redirect output to the log
	cd $cwd/$archetypeOriginName 2>&1 >> $archetypeLog
	echo ">> pwd = `pwd`" 2>&1 | tee -a $archetypeLog

	if [ -d "$archetypeTargetDir" ]; then
		echo ">> Deleting existing $archetypeTargetDir directory" 2>&1 | tee -a $archetypeLog
		echo "rm -rf $archetypeTargetDir" 2>&1 | tee -a $archetypeLog
		# tee does not play well with some bash commands, so just redirect output to the log
		rm -rf "$archetypeTargetDir" 2>&1 >> $archetypeLog
		archetypeStatus="$?"
		if [ "$archetypeStatus" -eq "0" ]; then
			echo "[OK]" 2>&1 | tee -a $archetypeLog
		else
			exit_now $archetypeStatus "*** FAILURE: could not delete $archetypeTargetDir."
		fi
	fi

	echo ">> Creating the archetype in $archetypeTargetDir" 2>&1 | tee -a $archetypeLog
	echo "mvn archetype:create-from-project -Darchetype.properties=../$archetypeProperties -DpackageName=$archetypePackageName" 2>&1 | tee -a $archetypeLog
	mvn archetype:create-from-project -Darchetype.properties=../$archetypeProperties -DpackageName=$archetypePackageName 2>&1 | tee -a $archetypeLog
	archetypeStatus="$?"
	if [ "$archetypeStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a $archetypeLog
	else
		exit_now $archetypeStatus "*** FAILURE: 'mvn archetype:create-from-project -Darchetype.properties=$archetypeProperties' failed."
	fi
}

## function to clean up things in the archetype maven got wrong ##
## no parameters                                                ##
## scope: private (internal calls only)                         ##
function clean_archetype_files() {
	tempArchDir="$archetypeTargetDir"

	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a $archetypeLog
	echo "cd $cwd/$archetypeOriginName" 2>&1 | tee -a $archetypeLog
	# tee does not play well with some bash commands, so just redirect output to the log
	cd $cwd/$archetypeOriginName 2>&1 >> $archetypeLog
	echo ">> pwd = `pwd`" 2>&1 | tee -a $archetypeLog

	echo ">> Cleaning up the created archetype in place: $tempArchDir" 2>&1 | tee -a $archetypeLog

	## clean up the archetype POM ##

	modFile="$tempArchDir/pom.xml"
	# wrong archetype package/groupId
	oldVal="gov.va.bip.origin"
	newVal="gov.va.bip.archetype.service"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a $archetypeLog
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' $modFile 2>&1 | tee -a $archetypeLog
	# wrong archetype name/artifactId
	oldVal="bip-origin-reactor-archetype"
	newVal="bip-archetype-service"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a $archetypeLog
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' $modFile 2>&1 | tee -a $archetypeLog
	# wrong archetype description
	oldVal="BIP Origin Service"
	newVal="BIP Service Archetype"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a $archetypeLog
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' $modFile 2>&1 | tee -a $archetypeLog
	# scrub the bad URLs # oldVal: slashes and double-quotes (and possibly commas) must be escaped
	oldVal="<url>https:\/\/projects.spring.io\/spring-boot\/#\/spring-boot-starter-parent\/bip-framework-parentpom\/bip-origin-reactor<\/url>"
	newVal=" "
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a $archetypeLog
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' $modFile 2>&1 | tee -a $archetypeLog
	# scrub the scm tags
	oldVal="<scm>"
	newVal=" "
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a $archetypeLog
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' $modFile 2>&1 | tee -a $archetypeLog
	# scrub the scm tags # oldVal: slashes and double-quotes (and possibly commas) must be escaped
	oldVal="<\/scm>"
	newVal=" "
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a $archetypeLog
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' $modFile 2>&1 | tee -a $archetypeLog
	# scrub the scm url # oldVal: slashes and double-quotes (and possibly commas) must be escaped
	oldVal="<url>https:\/\/github.com\/spring-projects\/spring-boot\/spring-boot-starter-parent\/bip-framework-parentpom\/bip-origin-reactor<\/url>"
	newVal=" "
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a $archetypeLog
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' $modFile 2>&1 | tee -a $archetypeLog
	# now also have to clean up after sed
	if [ -f "$modFile-e" ]; then
		echo ">> Remove sed artifacts" 2>&1 | tee -a $archetypeLog
		echo "rm -f $modFile-e" 2>&1 | tee -a $archetypeLog
		# tee does not play well with some bash commands, so just redirect output to the log
		rm -f "$modFile-e" >> $archetypeLog
	fi

	## Remove unnecessary files from the generated archetype ##

	echo ">> Remove the archive directory from the archetype" 2>&1 | tee -a $archetypeLog
	echo "rm -rf $archetypeServiceName/archive/" 2>&1 | tee -a $archetypeLog
	# tee does not play well with some bash commands, so just redirect output to the log
	rm -rf $archetypeServiceName/archive/ 2>&1 >> $archetypeLog
	archetypeStatus="$?"
	if [ "$archetypeStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a $archetypeLog
	else
		exit_now $archetypeStatus "*** FAILURE: could not delete $archetypeServiceName/archive/"
	fi
}

## function to rename "origin" directories to the new name  ##
##     should be able to do this in the command for         ##
##         mvn archetype:create-from-project -D...          ##
##     but can't figure it out (or just not possible)       ##
## no parameters                                            ##
## scope: private (internal calls only)                     ##
function rename_archetype_origin_dirs() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a $archetypeLog
	echo "cd $cwd/$archetypeOriginName/$archetypeTargetDir" 2>&1 | tee -a $archetypeLog
	# tee does not play well with some bash commands, so just redirect output to the log
	cd $cwd/$archetypeOriginName/$archetypeTargetDir 2>&1 >> $archetypeLog
	echo ">> pwd = `pwd`" 2>&1 | tee -a $archetypeLog

	echo ">> Renaming directories in place: $archetypeTargetDir" 2>&1 | tee -a $archetypeLog

	dirArray=(`find ./src -name '*origin*' -type d -maxdepth 4 | sed 's:\.\/::g'`)
	echo ">> Found directories to rename: ${dirArray[@]}" 2>&1 | tee -a $archetypeLog
	echo "" 2>&1 | tee -a $archetypeLog
	for d in "${dirArray[@]}"
	do
		echo "mv $d \${$d//origin/newname}" 2>&1 | tee -a $archetypeLog
		# tee does not play well with some bash commands, so just redirect output to the log
		mv $d ${d//origin/__artifactNameLowerCase__} 2>&1 >> $archetypeLog
		archetypeStatus="$?"
		if [ "$archetypeStatus" -eq "0" ]; then
			echo "[OK]" 2>&1 | tee -a $archetypeLog
		else
			exit_now $archetypeStatus "*** FAILURE: could not rename directory $d."
		fi
	done
}

## function to delete the old archetype directory ##
## no parameters                                  ##
## scope: private (internal calls only)           ##
function delete_old_archetype() {
	if [ -d $cwd/$archetypeServiceName ]; then
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a $archetypeLog
		echo ">> Deleting old $archetypeServiceName directory" 2>&1 | tee -a $archetypeLog
		echo "rm -rf $cwd/$archetypeServiceName" 2>&1 | tee -a $archetypeLog
		# tee does not play well with some bash commands, so just redirect output to the log
		rm -rf $cwd/$archetypeServiceName 2>&1 >> $archetypeLog
		archetypeStatus="$?"
		if [ "$archetypeStatus" -eq "0" ]; then
			echo "[OK]" 2>&1 | tee -a $archetypeLog
		else
			exit_now $archetypeStatus "*** FAILURE: could not delete directory $cwd/$archetypeServiceName."
		fi
	fi
}

## function to copy the new archetype to bip-archetype-service ##
## no parameters                                               ##
## scope: private (internal calls only)                        ##
function copy_archetype() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a $archetypeLog
	echo "cd $cwd/$archetypeOriginName" 2>&1 | tee -a $archetypeLog
	# tee does not play well with some bash commands, so just redirect output to the log
	cd $cwd/$archetypeOriginName 2>&1 >> $archetypeLog
	echo ">> pwd = `pwd`" 2>&1 >> $archetypeLog

	echo ">> Make directory ../$archetypeServiceName" 2>&1 | tee -a $archetypeLog
	echo "mkdir ../$archetypeServiceName" 2>&1 | tee -a $archetypeLog
	# tee does not play well with some bash commands, so just redirect output to the log
	mkdir ../$archetypeServiceName 2>&1 >> $archetypeLog
	archetypeStatus="$?"
	if [ "$archetypeStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a $archetypeLog
	else
		exit_now $archetypeStatus "*** FAILURE: could not create ../bip-archetype-service"
	fi

	echo ">> Copy archetype files to ../$archetypeServiceName" 2>&1 | tee -a $archetypeLog
	echo "cp -R -f $archetypeTargetDir/* ../$archetypeServiceName" 2>&1 | tee -a $archetypeLog
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -R -f $archetypeTargetDir/* ../$archetypeServiceName 2>&1 >> $archetypeLog
	archetypeStatus="$?"
	if [ "$archetypeStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a $archetypeLog
	else
		exit_now $archetypeStatus "*** FAILURE: could not copy $archetypeTargetDir/* to ../$archetypeServiceName"
	fi
}

## function to prepare to install the archetype in the local m2 repo ##
## no parameters                                                     ##
## scope: private (internal calls only)                              ##
function pre_install_copies() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a $archetypeLog
	echo "" 2>&1 | tee -a $archetypeLog
	echo "cd $cwd" 2>&1 | tee -a $archetypeLog
	# tee does not play well with some bash commands, so just redirect output to the log
	cd $cwd 2>&1 >> $archetypeLog
	echo ">> pwd = `pwd`" 2>&1 | tee -a $archetypeLog

	echo ">> Copy documentation files into archetype" 2>&1 | tee -a $archetypeLog

	echo ">> Copy basic README.md for new projects" 2>&1 | tee -a $archetypeLog
	echo "cp -f $archetypeOriginName/archive/$archetypeServiceName-project-README.md $archetypeServiceName/src/main/resources/archetype-resources/README.md" 2>&1 | tee -a $archetypeLog
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -f $archetypeOriginName/archive/$archetypeServiceName-project-README.md $archetypeServiceName/src/main/resources/archetype-resources/README.md 2>&1 >> $archetypeLog
	archetypeStatus="$?"
	if [ "$archetypeStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a $archetypeLog
	else
		exit_now $archetypeStatus "*** FAILURE: could not copy $archetypeOriginName/archive/* to destination"
	fi

	echo ">> Copy README.md for $archetypeServiceName project" 2>&1 | tee -a $archetypeLog
	echo "cp -f $archetypeOriginName/archive/bip-archetype-service-README.md $archetypeServiceName/README.md" 2>&1 | tee -a $archetypeLog
	# tee does not play well with some bash commands, so just redirect output to the log
	cp -f $archetypeOriginName/archive/bip-archetype-service-README.md $archetypeServiceName/README.md 2>&1 >> $archetypeLog
	archetypeStatus="$?"
	if [ "$archetypeStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a $archetypeLog
	else
		exit_now $archetypeStatus "*** FAILURE: could not copy $archetypeOriginName/archive/* to destination"
	fi
}

## function to install the archetype in the local m2 repo ##
## no parameters                                          ##
## scope: private (internal calls only)                   ##
function install_archetype() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a $archetypeLog
	echo "" 2>&1 | tee -a $archetypeLog
	echo "cd $archetypeServiceName" 2>&1 | tee -a $archetypeLog
	# tee does not play well with some bash commands, so just redirect output to the log
	cd $archetypeServiceName 2>&1 >> $archetypeLog
	echo ">> pwd=`pwd`" 2>&1 | tee -a $archetypeLog

	echo ">> Install the archetype" 2>&1 | tee -a $archetypeLog
	echo "mvn install" 2>&1 | tee -a $archetypeLog
	mvn install 2>&1 | tee -a $archetypeLog
	archetypeStatus="$?"
	if [ "$archetypeStatus" -eq "0" ]; then
		echo "[OK]" 2>&1 | tee -a $archetypeLog
	else
		exit_now $archetypeStatus "*** FAILURE, 'mvn install' failed."
	fi
}

####################################
### Script execution begins here ###
####################################

## output header info, get the log started ##
echo "" 2>&1 | tee $archetypeLog
echo "=========================================================================" 2>&1 | tee -a $archetypeLog
echo "Generate $archetypeServiceName" 2>&1 | tee -a $archetypeLog
echo "=========================================================================" 2>&1 | tee -a $archetypeLog
echo "" 2>&1 | tee -a $archetypeLog

## call each function in order ##
get_args $args
pre_processing
build_origin
create_archetype
clean_archetype_files
rename_archetype_origin_dirs
delete_old_archetype
copy_archetype
pre_install_copies
install_archetype

## success message (didn't exit_now anwhere along the way) ##
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a $archetypeLog
echo ">> SUCCESS - archetype project created: $archetypeServiceName" 2>&1 | tee -a $archetypeLog
echo "   See '$archetypeLog' for details."
echo "   To generate a new service project:" 2>&1 | tee -a $archetypeLog
echo "   - a gensvc.* has been copied into the ../ (should be your git root)" 2>&1 | tee -a $archetypeLog
echo "   - ensure values in gensvc.properties are correct" 2>&1 | tee -a $archetypeLog
echo "   - ensure gensvc.sh is executable:" 2>&1 | tee -a $archetypeLog
echo "     \$ chmod +x gensvc.sh" 2>&1 | tee -a $archetypeLog
echo "   - execute gensvc.sh" 2>&1 | tee -a $archetypeLog
echo "     \$ ./gensvc.sh" 2>&1 | tee -a $archetypeLog
echo "" 2>&1 | tee -a $archetypeLog

cd $cwd
