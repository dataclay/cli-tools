# Command Line Interface Tools for Templater Pro + Bot
Templater ships with command line interface (CLI) control only if Bot functionality is available.  These files will help you get started using the CLI.  Invoking the CLI is a bit different on OSX than on Windows, so we've divided up the files between the two operating systems.

###Requirements for running Templater via the CLI
To successfully version an After Effects project ("AEP") file with Templater's command line interface, you should first have some resources contained in a single directory.

*	A working AEP file compatible with Templater
*	A valid data source containing versioning information for the AEP file
*	A `templater-options.json` file that specifies Templater's configuration and options in JSON format
*	A copy of the `Templater 2.jsxbin` file that was installed into After Effects' ScriptUI application folder.  This file is automatically copied to your project folder when you use the supplied batch script or AppleScript launch file.
*	A script file, provided by Dataclay, that launches Adobe After Effects.  These are found in this repository.
*	A *directory location* for Templater logging

Once you have these correctly setup with a single directory, you can begin to use Templater's CLI and successfully troubleshoot problems you encounter with it.

A typical project folder on Windows might look something like this:

```
\Weather Forecast
	FiveDay.aep
	\logs
  		templater.out
  		templater.log
  	\output
  		video1.avi
  		video2.avi
  		video3.avi
  		. . .
  		video200.avi
  	templater.bat
  	Templater 2.jsxbin
  	templater-options.json
```

And a typical project folder on OSX might look something like this:

	/Weather Forecast
		templater-CC2015.applescript
	  	FiveDay.aep
	  	/logs
	  		templater.out
	  		templater.log
	  	/output
	  		video1.mov
	  		video2.mov
	  		video3.mov
	  		. . .
	  		video200.mov
	  	Templater 2.jsxbin
	  	templater-options.json
	  	
#Configuring the Templater CLI
You configure the Templater CLI using the `templater-options.json` file.  This is a simple, JSON-formatted, text file that allows you to set specific options for Templater.  If you forget to specify a required key, or a key has an invalid value, Templater will report an error in your logs.  However, some of the keys will have default values if they are not specified.

Some of the more important keys for running the CLI are the following:

+ **log_location** [String] Specifies a path to a directory that Templater uses to output the `templater.out` and the `templater.log` files.  Do not use a path to a file for this key.  If you have an application that can examine a text buffer then use `templater.out`, but if you need to examine the logs using a standard text editor, use the `templater.log` file.  For example, if you could use the `tail -f templater.out` command on OSX to see what Templater is logging in real-time.

+ **tasks** [Boolean] A group of keys that specify what you want Templater to actually do.  The values for the keys in this group should only be `true` or `false`.  For example, if you want Templater to *only* Render, then set the `render` key to `true` and the others to `false`.

+ **prefs** [Mixed] A group of keys that configure Templater's preferences.  For the most part, all of these keys are self-explanatory, but please reference our documentation for more information.

+ **data_source** [String] Specifies an absolute path to a tabbed-delimited file, or a URL to a Google Sheet feed.  You can get the URL feed of a Google Sheet from the `Google Spreadsheet Setup` dialog launched by clicking the `Google` button found on the Templater panel within After Effects.

+ **aep** [String] Specifies an absolute path to the project file that is to be versioned using the specified with the `data_source`.

+ **row_start** & **row_end**  [Integer] Specifies the start row and end rows in the data source to begin versioning processes.

+ **output_location** [String] Specifies an absolute path to where Templater should output all renders that come out of the After Effects render queue.

+ **render_settings** & **output_module** [String] Specifies the Render Settings Template and Output Module Template used when Templater loads versioned compositions into the After Effects render queue.  The values for these keys are strings that should match the names as found in After Effects' `Render Setting Templates` and `Output Module Templates` dialog.

+ **save_on_completion** [Boolean] Specifies whether or not Templater should save the versioned project file after running its tasks.

+  **quit_on_completion** [Boolean] Specifies whether or not Templater should quit after running its tasks.
	  	

#Running the Templater CLI

###On Apple OSX
Invoking Templater via the command line on OSX involves the use of the `osascript` command which is the AppleScript interpreter for OSX.  Use one of the provided AppleScript files to launch the specific version of After Effects you want to use with Templater's CLI.  For example, if you want to launch Adobe After Effects CC 2014 with the CLI then choose `templater-CC2014.applescript`, but if you want to launch Adobe After Effects CC 2015 choose `templater-CC2015.applescript`.

The following is the general format for invoking Templater's CLI *from within a project directory* as outlined above. 

`osascript {AppleScript launch file} `

In practice, the actual command line would look like this if we wanted to launch AE CC2015

`osascript templater-CC2015.applescript`

Follow these steps to invoke Templater's CLI with After Effects CC 2015 on OSX:

1. Launch a Terminal session
2. Navigate to a directory that contains a Templater-compatible AEP file, a configured `templater-options.json` file, and the `templater-CC2015.applescript` file.
3. Type in `osascript templater-CC2015.applescript` and press Enter to have Templater interpret the configuration in the `templater-options.json` file and launch After Effects CC 2015.
4. Wait for Templater to complete it versioning tasks as specified within the `tasks` key of the `templater-options.json` file.  If you get unexpected results, consult the `templater.log` file to see any messages Templater logged.

###On Microsoft Windows
Invoking Templater via the command line on Windows involves the use of a provided Microsoft Batch file.  On Windows you can choose to launch After Effects with or without a graphical user interface ("gui").  You pass a command line parameter to the batch file to launch a specific version of After Effects you want to use with Templater.  For example, if you want to launch Adobe After Effects CC 2014 without a gui then use `templater "CC 2014"`, but if you want to launch Adobe After Effects CC 2015 *with* a gui then use `templater "CC2015" ui`.  If no command line arguments are passed to the batch file, then batch file will print out its usage statement.  

Follow these steps to invoke Templater's CLI with After Effects CC 2015 on Windows:

1. Start a command prompt
2. Navigate to a directory that contains a Templater-compatible AEP file, a configured `templater-options.json`  and the `template.bat` file.
3. Type `templater "CC 2015"` and press Enter to have have Templater interpret the configuration in the `templater-options.json` file and launch After Effects CC 2015.  A copy of `Templater 2.jsxbin` is added to your project directory.
4. Wait for Templater to complete versioning and tasks as specified within options' file `tasks` key.  If you get unexpected results, consult the `templater.log` file to see any messages Templater logged.

#Troubleshooting the Templater CLI

Templater CLI will not do anything run unless a proper logging location is setup within the `templater-options.json` file.  Please be sure that you specify an absolute path to an *existing directory* for the log location and not a path to a single file.  You should make use of either the `templater.out` or `templater.log` files to troubleshoot Templater's CLI. 
