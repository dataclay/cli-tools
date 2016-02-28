#!/bin/bash

#Set constants
app_dir="/Applications/Adobe After Effects $1"
panels="/Scripts/ScriptUI Panels/"
templater_filename="Templater 2.jsxbin"

if [ "$2" = "ui" ]
  then
    ui=""
  else
    ui="-noui"
fi

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

read -r -d '' header << EOM
-----

	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*                                                               *   
	*            Templater CLI Launcher for OSX Terminal            *   
	*                                                               *   
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	Application Version =>
		Adobe After Effects $1

	CLI Configuration File =>
		$PWD/templater-options.json

	Using the following configuration =>
		Log Directory		=> $log
		AE Project			=> $aep
		Versioning Data		=> $data_src
		Footage directory 	=> $ftg_dir
		Output directory 	=> $output_dir
		Output Module		=> $output_mod
		Output Prefix		=> $pfx
		Task Range			=> $row_start through $row_end
EOM

echo "$header"

#Copy application jsxbin to project directory from After Effects app directory
echo ""
echo "	Initializing Project Directory =>"
echo "		Copying Templater Runtime"
cp -v "$app_dir$panels$templater_filename" "$PWD/$templater_filename"

#Magical osascript block to invoke After Effects!
echo ""
echo "	Invoking Adobe After Effects $1 using command =>"
echo "		open -a 'Adobe After Effects $1' --args $ui"
sleep 4
open -a 'Adobe After Effects CC 2014' --args $ui

read -r -d '' ae_proc << EOM
tell application "Adobe After Effects $1"
    activate
    using terms from application "Adobe After Effects $1"
        DoScriptFile "$PWD/$templater_filename"
    end using terms from
end tell
EOM

echo ""
echo "	Now performing tasks in Adobe After Effects $1.  Please wait..."
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
