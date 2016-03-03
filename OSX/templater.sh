#!/bin/bash

show_usage() {

echo -e "\n\n	\033[1mTemplater Launcher for OSX from Dataclay\033[0m\n"
cat << EOF

	Desc:

		Launches Templater for Adobe After Effects
		from the command line.  A supported version of
		After Effects is required to be installed on this 
		machine for this launcher to work properly.  Python 
 		scripting language should be installed as well.

	Usage:

		templater.sh -v 'version_string' [-ui] [-m]

	Options:

		-v | --version
		The version of Adobe After Effects you want to use
		with Templater, where 'version_string' can be any of
		the following: 
		'CC 2015' 'CC 2014' 'CC' 'CS6' 'CS5.5' 'CS5'

		-ui 
		If specified, Adobe After Effects will launch with its
		graphical user interface

		-m
		If included, this causes After Effects to launch as a new,
		seperate, process.  This is useful if you want to simultaneously
		execute two or more versioning jobs with Templater.

	Examples:

		Launch without AE user interface
		  
		  $ templater.sh -v 'CC 2015'
		  $ templater.sh -v 'CS5'
		
		
		Launch with AE user interface
		  
		  $ templater.sh -v 'CC 2005' -ui
		  $ templater.sh -v 'CS5' -ui

		Launch new instance of AE without user interface

		  $ templater.sh -v 'CC 2015' -m

EOF
}

# Reset all variables that might be set by supplied arguments
version=" "
ui="-noui" 
new_instance=" "

#Parse arguments from command line
while :; do
    case $1 in
        -h|-\?|--help)   # Documentation / Usage Statement
            show_usage
            exit
            ;;
	-v | --version)
	   if [ -n "$2" ]; then
                version=$2
                shift
            else
                printf '\nTemplater CLI Launch Error: --version or -v option requires a non-empty argument.\n'
                printf '                            Use any one of the following arguments for the -v option\n'
                printf '                            \"CC 2015\", \"CC 2014\", \"CC\", \"CS6\", \"CS5.5\", \"CS5\"\n\n' 
                printf 'Use --help option to see description and usage examples\n\n'
                exit 1
            fi 
	    ;;
        -ui)
            ui=" "
            ;;
        -m)
	    new_instance="-m" 
	    ;;
	--) # End of all options.
            shift
            break
            ;;
        -?*)
            printf '\nTempalter CLI Launch Warning: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)  # Default case: If no more options then break out of the loop.
            break
    esac

    shift
done

if [ "$version" = " "  ]; then
  #printf "\nTemplater CLI Launch Error: please specify a version string with the -v or --version argument.\n\n"
  show_usage
  exit
fi

#Set constants
app_dir="/Applications/Adobe After Effects $version"
panels="/Scripts/ScriptUI Panels/"
templater_filename="Templater 2.jsxbin"

#Parse templater-options.json found in running directory
#NOTE: Requires python installed on environment
get_conf () {
    read -r -d '' get_cli_conf << EOM
import sys 
import json
with open("$PWD/templater-options.json") as f:
    read_data = f.read()
f.closed
cli_opts = json.loads(read_data)
print  cli_opts["$1"]
EOM

echo $(python -c "$get_cli_conf")

}

log=$(get_conf log_location)
aep=$(get_conf aep)
data_src=$(get_conf data_source)
output_dir=$(get_conf output_location)
output_mod=$(get_conf output_module)
ftg_dir=$(get_conf source_footage)
row_start=$(get_conf row_start)
row_end=$(get_conf row_end)
pfx=$(get_conf output_prefix)

echo "Log file is $log"
if [ "$log" == "" ] || [ "$log" == " " ]; then
	log=/private${TMPDIR}TemporaryItems
fi

read -r -d '' header << EOM
-----

	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*                                                               *   
	*            Templater CLI Launcher for OSX Terminal            *   
	*                                                               *   
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	Application Version =>
		Adobe After Effects $version

	CLI Configuration File =>
		$PWD/templater-options.json

	Using the following configuration =>
		Log Directory      => $log
		AE Project         => $aep
		Versioning Data    => $data_src
		Footage directory  => $ftg_dir
		Output directory   => $output_dir
		Output Module      => $output_mod
		Output Prefix      => $pfx
		Task Range         => $row_start through $row_end
EOM

echo "$header"

#Copy application jsxbin to project directory from After Effects app directory
echo ""
echo "	Initializing Project Directory =>"
echo "		Copying Templater Runtime"
cp -v "$app_dir$panels$templater_filename" "$PWD/$templater_filename"

#Magical osascript block to invoke After Effects!
echo ""
echo "	Invoking Adobe After Effects $version using command =>"
echo "		open -a 'Adobe After Effects $version' --args $ui $new_instance"
sleep 4
ae_app="Adobe After Effects $version"
open -a "$ae_app" --args $ui $new_instance

read -r -d '' ae_proc << EOM
tell application "Adobe After Effects $version"
    activate
    using terms from application "Adobe After Effects $version"
        DoScriptFile "$PWD/$templater_filename"
    end using terms from
end tell
EOM

echo ""
echo "	Now performing tasks in Adobe After Effects $version.  Please wait..."
echo ""
osascript -e "$ae_proc"

echo "	Templater messages and errors logged to =>"
echo "		$log/templater.log"
echo "		$log/templater.err"

#Display last log
echo " "
echo "	Last logged message =>"
if [ -f $log/templater.log ]; then
   cat "$log/templater.log" | grep "." | tail -1
else 
   echo "		[Empty Log]"
fi

#Display last error
echo " "
echo "	Last reported error =>"
if [ -s $log/templater.err ]; then
    cat "$log/templater.err" | grep "." | tail -1
else
    echo "		[No Errors]"
fi

echo ""
echo ""
