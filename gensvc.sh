#!/bin/sh

# useful variables
cwd=`pwd`
thisScript="$0"
thisFileName=$(echo "$thisScript" | rev | cut -d'/' -f1 | rev | cut -d'.' -f1)
args="$@"
# script variables
propertiesFile="$thisFileName.properties"
overwriteExisting=-1
generateLog="$cwd/$thisFileName.log"
# properties
# not required in properties file
archetypeCatalog="local"
interactiveMode="false"
archetypeGroupId="gov.va.bip.archetype.service"
archetypeArtifactId="bip-archetype-service"
# required in properties file
archetypeVersion=""
groupId=""
artifactId=""
version=""
artifactName=""
artifactNameLowerCase=""
artifactNameUpperCase=""
servicePort=""

## function to exit immediately         ##
## required parameter: exit code to use ##
## scope: private (internal calls only) ##
function exit_now() {
	#  5 = invalid command line argument
	#  6 = property not allocated a value
	# 10 = project directory already exists
	# 20 = a maven error occurred

	exit_code=$1
	if [ -z $exit_code ] || [ "$exit_code" -eq "0" ]; then
		exit_code="0"
	else
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$generateLog"
		echo " BUILD FAILED" 2>&1 | tee -a "$generateLog"
		echo "" 2>&1 | tee -a "$generateLog"
		# check exit codes
		if [ "$exit_code" -eq "5" ]; then
			# Invalie command line argument
			echo " ERROR: Invalid command-line argument \"-$OPTARG\" (use \"$thisScript -h\" for help) ... aborting immediately" 2>&1 | tee -a "$generateLog"
		elif [ "$exit_code" -eq "6" ]; then
			# One or more properties not set
			echo " ERROR: \"$propertiesFile\" does not provide values for the following properties:" 2>&1 | tee -a "$generateLog"
			echo "        $missingProperties" 2>&1 | tee -a "$generateLog"
		elif [ "$exit_code" -eq "7" ]; then
			# One or more properties not set
			echo " ERROR: \"$artifactId\" project already exists ... aborting immediately" 2>&1 | tee -a "$generateLog"
		elif [ "$exit_code" -eq "10" ]; then
			# One or more properties not set
			echo " ERROR: Directory \"$artifactId\" already exists. Delete the directory " 2>&1 | tee -a "$generateLog"
			echo "        or execute this generate script and properties in another directory. " 2>&1 | tee -a "$generateLog"
		elif [ "$exit_code" -eq "20" ]; then
			# A maven error occurred
			echo " FAILURE: 'mvn' exited with $mvnStatus" 2>&1 | tee -a "$generateLog"
		elif [ "$exit_code" -eq "126" ]; then
			# Permission problem or command is not an executable
			echo " ERROR: Invalid permissions or non-executable command ... aborting immediately" 2>&1 | tee -a "$generateLog"
		elif [ "$exit_code" -eq "127" ]; then
			# Possible problem with $PATH or a typo
			echo " ERROR: 'mvn' command not found (check \$PATH) ... aborting immediately" 2>&1 | tee -a "$generateLog"
		elif [ "$exit_code" -eq "130" ]; then
			# Ctrl+C was pressed
			echo " Interrupted (Ctrl_C) ... aborting immediately" 2>&1 | tee -a "$generateLog"
		elif [ "$exit_code" -ge "128" ]; then
			# Fatal error signal 128+n
			echo " FATAL error (signal $exit_code) ... aborting immediately" 2>&1 | tee -a "$generateLog"
		else
			# some unexpected error
			echo " Unexpected error code: $exit_code ... aborting immediately" 2>&1 | tee -a "$generateLog"
		fi
	fi
	echo "" 2>&1 | tee -a "$generateLog"
	echo " See \""$generateLog"\", search \"+>> \" for script actions." 2>&1 | tee -a "$generateLog"
	echo " Use \"./$thisScript -h\" for script usage help." 2>&1 | tee -a "$generateLog"
	echo "------------------------------------------------------------------------"2>&1 | tee -a "$generateLog"
	# exit
	exit $exit_code
}

## function to display help             ##
## scope: private (internal calls only) ##
function show_help() {
	echo "" 2>&1 | tee -a "$generateLog"
	echo "Examples:" 2>&1 | tee -a "$generateLog"
	echo "  $thisScript -h" 2>&1 | tee -a "$generateLog"
	echo "      - show this help" 2>&1 | tee -a "$generateLog"
	echo "  $thisScript" 2>&1 | tee -a "$generateLog"
	echo "      - generate project using default generate.properties file" 2>&1 | tee -a "$generateLog"
	echo "  $thisScript -i myprops.properties" 2>&1 | tee -a "$generateLog"
	echo "      - generate using the specified properties file" 2>&1 | tee -a "$generateLog"
	echo "  $thisScript -o" 2>&1 | tee -a "$generateLog"
	echo "      - over-write project if it already exists under current directory" 2>&1 | tee -a "$generateLog"
	echo "  $thisScript -oi" 2>&1 | tee -a "$generateLog"
	echo "" 2>&1 | tee -a "$generateLog"
	echo "Notes:" 2>&1 | tee -a "$generateLog"
	echo "* Full instructions available in development branch at:" 2>&1 | tee -a "$generateLog"
	echo "  https://github.com/department-of-veterans-affairs/bip-archetype-service/" 2>&1 | tee -a "$generateLog"
	echo "* This script must be located in a directory that does not already" 2>&1 | tee -a "$generateLog"
	echo "  contain the project to be generated." 2>&1 | tee -a "$generateLog"
	echo "* A valid \"gensvc.properties\" file must exist in the same directory" 2>&1 | tee -a "$generateLog"
	echo "  as this script." 2>&1 | tee -a "$generateLog"
	echo "* It is recommended that a git credential helper be utilized to" 2>&1 | tee -a "$generateLog"
	echo "  eliminate authentication requests while executing. For more info see" 2>&1 | tee -a "$generateLog"
	echo "  https://help.github.com/articles/caching-your-github-password-in-git/" 2>&1 | tee -a "$generateLog"
	echo "" 2>&1 | tee -a "$generateLog"
	echo "" 2>&1 | tee -a "$generateLog"
	# if we are showing this, force exit
	exit_now
}

## get argument options off of the command line        ##
## required parameter: array of command-line arguments ##
## scope: private (internal calls only)                ##
function get_args() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$generateLog"

	echo "+>> Processing command-line arguments" 2>&1 | tee -a "$generateLog"

	# echo "args: \"$@\""
	#if [ "$@" -eq "" ]; then
	if [[ "$@" == "" ]]; then
		echo "+>> Using default properties file \"$propertiesFile\"" 2>&1 | tee -a "$generateLog"
	fi
	while getopts ":hio:" opt; do
		echo "+>> previous_opt value = $previous_opt"2>&1 | tee -a "$generateLog"
		echo "+>> current opt value = $opt"2>&1 | tee -a "$generateLog"
		case "$opt" in
			h)
				# echo "+>> -h > show help" 2>&1 | tee -a "$generateLog"
				show_help
				;;
			i)
				# echo "+>> -i > input properties file"2>&1 | tee -a "$generateLog"
				# remove spaces from the -i options argument
				propertiesFile=`echo "${OPTARG//[[:space:]]/}"`
				echo "+>> Using specified properties file \"$propertiesFile\"" 2>&1 | tee -a "$generateLog"
				;;
			o)
				# echo "+>> -o > overwrite" 2>&1 | tee -a "$generateLog"
				overwriteExisting=0
				echo "+>> Existing project will be deleted and recreated if it already exists" 2>&1 | tee -a "$generateLog"
				;;
			:)
				# check if option 2 (the "o" option) was the previously processed option - it has no arg
				if [ "$previous_opt" -ne "2" ]; then
					exit_now 5
				else
					overwriteExisting=0
					echo "+>> Existing project will be deleted and recreated if it already exists" 2>&1 | tee -a "$generateLog"
				fi
				;;
			\?)
				exit_now 5
				;;
		esac
		previous_opt="$opt"
	done
	# shift $((OPTIND -1))
}

## function to populate property vars from $propertiesFile ##
## scope: private (internal calls only)                    ##
function read_properties() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$generateLog"
	echo "cd $cwd" 2>&1 | tee -a "$generateLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cd "$cwd" 2>&1 >> "$generateLog"
	echo "+>> pwd = `pwd`" 2>&1 | tee -a "$generateLog"

	if [ ! -f "$propertiesFile" ]; then
		echo "*** ERROR File \"$propertiesFile\" is missing. Cannot generate the project." 2>&1 | tee -a "$generateLog"
		# invalid properties will be caught when validate_properties function is called
	else
		echo "" 2>&1 | tee -a "$generateLog"
		echo "+>> Reading project properties declared in $propertiesFile" 2>&1 | tee -a "$generateLog"

		# set up to parse property lines
		OIFS=$IFS
		IFS='='
		# read file
		# echo "△ start reading file"
		while read line
		do
			if [[ $line != *"#"* && $line != "" ]]; then
				# remove all whitespace from the line
				tuple=`echo "${line//[[:space:]]/}"`
				# get the key and value from the tuple
				theKey=$(echo "$tuple" | cut -d'=' -f 1)
				theVal=$(echo "$tuple" | cut -d'=' -f 2)
				echo "     tuple: $tuple" 2>&1 | tee -a "$generateLog"

				# assigning values cannot be done using declare or eval - this is what bash reduces us to ...
				if [[ "$theKey" == "archetypeCatalog" ]]; then archetypeCatalog=$theVal; fi
				if [[ "$theKey" == "interactiveMode" ]]; then interactiveMode=$theVal; fi
				if [[ "$theKey" == "archetypeGroupId" ]]; then archetypeGroupId=$theVal; fi
				if [[ "$theKey" == "archetypeArtifactId" ]]; then archetypeArtifactId=$theVal; fi
				if [[ "$theKey" == "archetypeVersion" ]]; then archetypeVersion=$theVal; fi
				if [[ "$theKey" == "groupId" ]]; then groupId=$theVal; fi
				if [[ "$theKey" == "artifactId" ]]; then artifactId=$theVal; fi
				if [[ "$theKey" == "version" ]]; then version=$theVal; fi
				if [[ "$theKey" == "artifactName" ]]; then artifactName=$theVal; fi
				if [[ "$theKey" == "artifactNameLowerCase" ]]; then artifactNameLowerCase=$theVal; fi
				if [[ "$theKey" == "artifactNameUpperCase" ]]; then artifactNameUpperCase=$theVal; fi
				if [[ "$theKey" == "servicePort" ]]; then servicePort=$theVal; fi
			fi
		done < "$cwd/$propertiesFile"
		IFS=OIFS
	fi
}

## function to validate property vars from $propertiesFile ##
## scope: private (internal calls only)                    ##
function validate_properties() {
	# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$generateLog"
	echo "+>> Validating project properties declared in $propertiesFile" 2>&1 | tee -a "$generateLog"

	missingProperties=""
	if [[ "$archetypeCatalog" == "" ]]; then missingProperties+="archetypeCatalog "; fi
	if [[ "$interactiveMode" == "" ]]; then missingProperties+="interactiveMode "; fi
	if [[ "$archetypeGroupId" == "" ]]; then missingProperties+="archetypeGroupId "; fi
	if [[ "$archetypeArtifactId" == "" ]]; then missingProperties+="archetypeArtifactId "; fi
	if [[ "$archetypeVersion" == "" ]]; then missingProperties+="archetypeVersion "; fi
	if [[ "$groupId" == "" ]]; then missingProperties+="groupId "; fi
	if [[ "$artifactId" == "" ]]; then missingProperties+=( "artifactId " ); fi
	if [[ "$version" == "" ]]; then missingProperties+=( "version " ); fi
	if [[ "$artifactName" == "" ]]; then missingProperties+=( "artifactName " ); fi
	if [[ "$artifactNameLowerCase" == "" ]]; then missingProperties+=( "artifactNameLowerCase " ); fi
	if [[ "$artifactNameUpperCase" == "" ]]; then missingProperties+=( "artifactNameUpperCase " ); fi
	if [[ "$servicePort" == "" ]]; then missingProperties+=( "servicePort " ); fi

	if [[ "$missingProperties" != "" ]]; then
		exit_now 6
	fi
}

## function to check pre-build requirements                 ##
## scope: private (internal calls only)                     ##
function pre_build() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$generateLog"
	echo "cd $cwd" 2>&1 | tee -a "$generateLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cd "$cwd" 2>&1 >> "$generateLog"
	echo "+>> pwd = `pwd`" 2>&1 | tee -a "$generateLog"

	## Remove old project, or abort ##

	echo "+>> Performing pre-build checks" 2>&1 | tee -a "$generateLog"
	if [ -d "$artifactId" ]; then
		if [ "$overwriteExisting" -eq "0" ]; then
			echo "+>> Over-writing existing $artifactId project" 2>&1 | tee -a "$generateLog"
			echo "rm -rf $artifactId/" 2>&1 | tee -a "$generateLog"
			# tee does not play well with some bash commands, so just redirect output to the log
			rm -rf "$artifactId/" 2>&1 >> "$generateLog"
		else
			exit_now 7
		fi
	fi

	## Clean up the META-INF/maven/archetyp-metadata.xml ##

	##########################################################
	## NOTE: sed *always* returns "0" as its exit code      ##
	##       regardless if it succeeds or not. If changes   ##
	##       are made to sed commands, you must check the   ##
	##       genarchetype.log (search "sed -i") to verify   ##
	##       that no sed error messages follow the command  ##
	##########################################################

	echo "cd $cwd/$archetypeArtifactId" 2>&1 | tee -a "$generateLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cd "$cwd/$archetypeArtifactId" 2>&1 >> "$generateLog"
	echo "+>> pwd = `pwd`" 2>&1 | tee -a "$generateLog"

	modFile="src/main/resources/META-INF/maven/archetype-metadata.xml"

	echo "+>> Preparing $modFile" 2>&1 | tee -a "$generateLog"
	# camelcase replacement
	oldVal="Origin"
	newVal="$artifactName"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$generateLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$generateLog"
	# lowercase replacement
	oldVal="origin"
	newVal="$artifactNameLowerCase"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$generateLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$generateLog"
	# uppercase replacement
	oldVal="ORIGIN"
	newVal="$artifactNameUpperCase"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$generateLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$generateLog"

	echo "+>> Content of $modFile"
	cat "$modFile" 2>&1 >> "$generateLog"
	echo "< EOF"
	echo ""

	## Clean up the maven projects/basic/archetype.properties ##

	modFile="src/test/resources/projects/basic/archetype.properties"

	echo "+>> Preparing $modFile" 2>&1 | tee -a "$generateLog"
	# default package replacement
	oldVal="it.pkg"
	newVal="$groupId"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$generateLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$generateLog"
	# default version replacement
	oldVal="0.1-SNAPSHOT"
	newVal="$version"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$generateLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$generateLog"
	# default artifactId replacement
	oldVal="basic"
	newVal="$artifactId"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' \"$modFile\"" 2>&1 | tee -a "$generateLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$generateLog"
	# default groupId replacement
	oldVal="archetype.it"
	newVal="$groupId"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a "$generateLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$generateLog"
	# camelcase replacement
	oldVal="Origin"
	newVal="$artifactName"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a "$generateLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$generateLog"
	# lowercase replacement
	oldVal="origin"
	newVal="$artifactNameLowerCase"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a "$generateLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$generateLog"
	# uppercase replacement
	oldVal="ORIGIN"
	newVal="$artifactNameUpperCase"
	echo "sed -i \"\" -e 's/'\"$oldVal\"'/'\"$newVal\"'/g' $modFile" 2>&1 | tee -a "$generateLog"
	sed -i "" -e 's/'"$oldVal"'/'"$newVal"'/g' "$modFile" 2>&1 >> "$generateLog"

	echo "+>> Content of $modFile"
	cat "$modFile" 2>&1 >> "$generateLog"
	echo "< EOF"
	echo ""
}

## function to execute the maven archetype:generate command ##
## scope: private (internal calls only)                     ##
function generate_project() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$generateLog"
	echo "cd $cwd/$archetypeArtifactId" 2>&1 | tee -a "$generateLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cd "$cwd/$archetypeArtifactId" 2>&1 >> "$generateLog"
	echo "+>> pwd = `pwd`" 2>&1 | tee -a "$generateLog"

	echo "+>> Executing:" 2>&1 | tee -a "$generateLog"
	echo "  mvn archetype:generate \\" 2>&1 | tee -a "$generateLog"
	echo "  -DarchetypeCatalog=$archetypeCatalog \\" 2>&1 | tee -a "$generateLog"
	echo "  -DinteractiveMode=$interactiveMode \\" 2>&1 | tee -a "$generateLog"
	echo "  -DarchetypeGroupId=$archetypeGroupId \\" 2>&1 | tee -a "$generateLog"
	echo "  -DarchetypeArtifactId=$archetypeArtifactId \\" 2>&1 | tee -a "$generateLog"
	echo "  -DarchetypeVersion=$archetypeVersion \\" 2>&1 | tee -a "$generateLog"
	echo "  -DgroupId=$groupId \\" 2>&1 | tee -a "$generateLog"
	echo "  -DartifactId=$artifactId \\" 2>&1 | tee -a "$generateLog"
	echo "  -Dversion=$version \\" 2>&1 | tee -a "$generateLog"
	echo "  -DartifactName=$artifactName \\" 2>&1 | tee -a "$generateLog"
	echo "  -DartifactNameLowerCase=$artifactNameLowerCase \\" 2>&1 | tee -a "$generateLog"
	echo "  -DartifactNameUpperCase=$artifactNameUpperCase \\" 2>&1 | tee -a "$generateLog"
	echo "  -DservicePort=$servicePort" 2>&1 | tee -a "$generateLog"

	mvn archetype:generate\
		-DarchetypeCatalog="$archetypeCatalog" \
		-DinteractiveMode="$interactiveMode" \
		-DarchetypeGroupId="$archetypeGroupId" \
		-DarchetypeArtifactId="$archetypeArtifactId" \
		-DarchetypeVersion="$archetypeVersion" \
		-DgroupId="$groupId" \
		-DartifactId="$artifactId" \
		-Dversion="$version" \
		-DartifactName="$artifactName" \
		-DartifactNameLowerCase="$artifactNameLowerCase" \
		-DartifactNameUpperCase="$artifactNameUpperCase" \
		-DservicePort="$servicePort" \
		-Dgoals=package \
		-e -X 2>&1 | tee -a "$generateLog"
	mvnStatus="$?"
	if [ "$mvnStatus" -ne "0" ]; then
		# 	echo "------------------------------------------------------------------------" 2>&1 | tee -a "$generateLog"
		# 	echo " BUILD SUCCESS" 2>&1 | tee -a "$generateLog"
		# elif [ "$mvnStatus" -ge "126" ]; then
		# 	exit_now $mvnStatus
		# else
		exit_now 20
	fi

}

## function to perform post-build activities                ##
## scope: private (internal calls only)                     ##
function post_creation() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "$generateLog"
	echo "+>> Performing post-build activities" 2>&1 | tee -a "$generateLog"

	## Reset the archetype-metadata.xml and archetype.properties files ##

	echo "cd $cwd/$archetypeArtifactId" 2>&1 | tee -a "$generateLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cd "$cwd/$archetypeArtifactId" >> "$generateLog" 2>&1
	echo "+>> pwd = `pwd`" 2>&1 | tee -a "$generateLog"

	modDir="src/main/resources/META-INF/maven"
	echo "cp -fv $modDir/archetype-metadata_ORIGINAL.xml $modDir/archetype-metadata.xml" 2>&1 | tee -a "$generateLog"
	cp -fv "$modDir/archetype-metadata_ORIGINAL.xml" "$modDir/archetype-metadata.xml"  >> "$generateLog" 2>&1

	modDir="src/test/resources/projects/basic"
	echo "cp -fv $modDir/archetype_ORIGINAL.properties $modDir/archetype.properties" 2>&1 | tee -a "$generateLog"
	cp -fv "$modDir/archetype_ORIGINAL.properties" "$modDir/archetype.properties"  >> "$generateLog" 2>&1

	## Ensure no './.git' repo directory ##

	echo "cd $cwd/$artifactId" 2>&1 | tee -a "$generateLog"
	# tee does not play well with some bash commands, so just redirect output to the log
	cd "$cwd/$artifactId" >> "$generateLog" 2>&1
	echo "+>> pwd = `pwd`" 2>&1 | tee -a "$generateLog"

	if [ -d "./.git" ]; then
		echo "rm -rf ./.git" 2>&1 | tee -a "$generateLog"
		# tee does not play well with some bash commands, so just redirect output to the log
		rm -rf ./.git 2>&1 >> "$generateLog"
	fi
	#  cd "$cwd/$artifactId" >> "$generateLog" 2>&1
	#  sed -i -- 's/__rootArtifactId__/'$artifactId'/g' pom.xml >> "$generateLog" 2>&1
	#  rm pom.xml-- >> "$generateLog" 2>&1
	cd "$cwd" >> "$generateLog" 2>&1
}

####################################
### Script execution begins here ###
####################################

## output header info, get the log started ##
echo ""  2>&1 | tee "$generateLog"
echo "=========================================================================" 2>&1 | tee -a "$generateLog"
echo "Generate a BIP Service App project" 2>&1 | tee -a "$generateLog"
echo "=========================================================================" 2>&1 | tee -a "$generateLog"
echo "" 2>&1 | tee -a "$generateLog"

## call each function in order ##
get_args $args
read_properties
validate_properties
pre_build
#read -p "+>>>>>> AFTER SED COMMANDS "
generate_project
post_creation
exit_now 0
