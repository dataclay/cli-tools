# Command Line Interface Tools for Templater Bot
Templater ships with command line interface (CLI) control only if Bot functionality is available.  The files contained in this repository help get started using Templater's CLI.

<a id="requirements"></a>
## Requirements for running the Templater CLI

#### System Requirements
As of Templater version 2.1.8 users should invoke the Templater CLI via the `templater.ps1` file on Windows and `templater.sh` file on OSX.

>**NOTE**</br>Prior to Templater 2.1.8, the launcher script was written as a Microsoft Batch script for Windows, and an AppleScript file for OSX.  These have been deprecated and are no longer supported.  

</br>
>###### Windows Environment
> + Windows PowerShell.  Users should have privileges to run PowerShell scripts from the PowerShell prompt.

>##### OSX Environments
>+ Python—version 2.6 or later.  All recent versions of OSX already come bundled with Python.  Enter `python --version` at a new terminal prompt to verify installation—if you see a version number, Python is installed and ready.

#### Project Requirements
To version an After Effects project with Templater's command line interface, you should first have some required resources within your project's working directory, as follows:

*	Your Adobe After Effects project file that is already compatible with Templater.  In addition, the project file should open within After Effects without throwing up any error dialogs related to dependencies such as fonts, missing files, etc.
*	A [`templater-options.json`](https://github.com/dataclay/cli-tools/blob/master/Windows/templater-options.json) file that specifies Templater's configuration and options in JSON format
*	The CLI launcher script—either [`templater.ps1`](https://github.com/dataclay/cli-tools/tree/master/Windows/templater.ps1) for Windows Powershell or [`templater.sh`](https://github.com/dataclay/cli-tools/tree/master/Windows/templater.sh) provided for OSX Terminal.

On Windows, for example, a directory listing of a weather forecast project should include the following files at a bare minimum:

```
C:\Templates\WeatherForecast
	FiveDay.aep
	templater-options.json
  	templater.ps1
```
On OSX, the same weather forecast project directory listing should show:

```
~/Templates/WeatherForecast
    FiveDay.aep
    templater-options.json
    templater.sh
```
Once you have these files setup and within a single directory, you can use Templater's CLI to version your AEP file on demand and successfully troubleshoot problems you encounter with it.

## Configuring the Templater CLI
You configure the Templater CLI by editing the JSON-formatted [`templater-options.json`](https://github.com/dataclay/cli-tools/blob/master/Windows/templater-options.json) file.  If you forget to declare a required key, or a key has an invalid value, Templater will report an error in your logs.  Some keys will have default values if they are not specified in the file.

Note that on Windows, paths specified within the configuration file must be entered with a double-backslash like
	
	C:\\Templates\\Styles\\Modern\\WeatherForecast.aep

While paths on OSX must be entered with the forward slash like 
	
	/Users/dataclay/Templates/Styles/Modern/WeatherForecast.aep

You should [read documentation on Dataclay's support website](http://support.dataclay.com/content/how_to/cli/templater_cli_configuration_properties.htm) for detailed documentation on each property key, but here are some important keys for running the CLI:

##### **`log_location`**  :  *string*
>Specifies **a path to a directory** for multiple message and error log files.  Read `templater.out` when you want to inspect the log as Templater executes—for example with a command like `tail -f templater.out`.  Open `templater.log` if you need to examine the log using a standard text editor.

</br>
##### **``tasks``** : object
>An object with properties that specify what you want Templater to actually do.  The values for the keys in this group should only be `true` or `false`.  For example, if you want Templater to *only* Render, then set the `render` key to `true` and the others to `false`.

</br>
##### **``prefs``** : object
>A group of keys that configure Templater's preferences.  For the most part, all of these keys are self-explanatory, but please reference our documentation for more information.

</br>
##### **``data_source``** : string
>Specifies an absolute path to a tabbed-delimited file, a Google Sheet feed, or any URL that responds with properly formatted json object array.  You can get the URL feed of a Google Sheet from the `Google Spreadsheet Setup` dialog launched by clicking the `Google` button found on the Templater panel within After Effects.

</br>
##### **``aep``** : string
>Specifies an absolute path to the project file that is to be versioned using the specified with the `data_source`.

</br>
##### **``row_start``** & **``row_end``**  : integer
>Specifies the start row and end rows in the data source to begin versioning processes.

</br>
##### **``output_location``** : string
>Specifies an absolute path to where Templater should output all renders that come out of the After Effects render queue.

</br>
##### **``render_settings``** & **``output_module``** : string
>Specifies the Render Settings Template and Output Module Template used when Templater loads versioned compositions into the After Effects render queue.  The values for these keys are strings that should match the names as found in After Effects' *Render Setting Templates* and *Output Module Templates* dialog.

</br>
##### **``save_on_completion``** : boolean
>Specifies whether or not Templater should save the versioned project file after running its tasks.

</br>
##### **``quit_on_completion``** : boolean
>Specifies whether or not Templater should quit after running its tasks.
	  	

## Running the Templater CLI

Start Templater from the command line by entering the name of the launcher script file followed by some arguments.  If you don't supply the required arguments, the launcher script will output its usage, documentation, and examples.

Assuming your file system has a directory named `WeatherForecast` containing the required files as listed in [Requirements for running the Templater CLI](#requirements), and that the environment is running Adobe After Effects CC 2015, you would follow these steps to invoke Templater from the command line:

1. On Windows, start a new Powershell terminal.  On OSX, start a new terminal session.
2. Change into the `WeatherForecast` directory.  On Windows, use `cd C:\Templater\WeatherForecast` on OSX, use `cd ~/Templates/WeatherForecast` 
3. On Windows, at the Powershell prompt `>`, enter the following

	>```
	>PS C:\Templates\WeatherForecast> .\templater.ps1 -v 'CC 2015'
	>```
	
	On OSX, at the Terminal prompt `$`, enter the following
	
	>```
	>iMac:WeatherForecast dataclay$ templater.sh -v 'CC 2015' 
	>```

 

 ###### </br>NOTE
If the launcher file does not execute you may need to set its permissions.  On OSX, you can use `sudo chmod u+x templater.sh` to ensure `templater.sh` is executable for the current user.  On Windows, use the "Security" tab in the `File Properties` dialog to change the permissions of `templater.ps1` for the current user. 
4. Wait for Templater to configure according to the `templater-options.json` file and complete its versioning tasks with After Effects.
5. After processing is complete, the launcher script displays the last message logged to `templater.log`, as well as the last reported error as found in `templater.err`.
6. Begin troubleshooting if desired output is not found.  You should check the `templater-options.json` to double-check your configuration, and then inspect the `templater.log` and `templater.err` files to learn more about any issues Templater reports.

#### Templater Launcher Tool Help
Use `.\templater.ps1 -h` or `./templater.sh -h` to see information about options and arguments.  The following shows the help as it shows in Windows PowerShell 
>```
>	Templater Launcher from Dataclay
>
>	Desc:>>      Launches Templater for Adobe After Effects>      from the command line.  A supported version of>      After Effects is required to be installed on this>      machine for this launcher to work properly.>>   Usage:>>      .\templater.ps1 [-h] -v 'ae_version_string' [-ui] [-m]>>   Options:>>      -h>      Shows this documentation>>      -v | --version 'ae_version_string'>      The version of AE you want to use with Templater,>      where 'version_string' can be any of the following:>      'CC 2015' 'CC 2014' 'CC' 'CS6' 'CS5.5' 'CS5'.>>      -ui>      When used, Adobe After Effects launches with a user interface>>      -m>      If included, this causes AE to launch as a new, seperate,>      process.  This is useful if you want to simultaneously>      execute two or more versioning jobs with Templater.>>    Examples:>>        Launch without AE user interface>>          > .\templater.ps1 -v 'CC 2015'>          > .\templater.ps1 -v 'CS5'>>        Launch with AE user interface>>          > .\templater.ps1 -v 'CC 2005' -ui>          > .\templater.ps1 -v 'CS5' -ui>>        Launch new instance of AE without its user interface>>          > .\templater.ps1 -v 'CC 2015' -m
>          
```

## Troubleshooting the Templater CLI
The PowerShell and Bash script launchers report the last logged message and the last reported error after Templater completes execution.  Use these logs to help you troubleshoot the Templater CLI.  Messages are logged to `templater.log` while errors are logged to `templater.err`.  Errors are logged as single-line JSON objects.  The error object contains useful information that can be processed by other applications.

The following is an example of an error object that is output to `templater.err` when After Effects attempts to import a footage source file that is corrupt or not supported. 

```
{ 
    code     : 1001
  , desc     : "Error swapping footage source"
  , ae       : "Error: After Effects error: the file format module could not parse the file."
  , details  : "AE encountered an footage import issue with file B:\Dataclay\Sources\[TEMPLATER DOWNLOADS]\11137842_1428056637497122_561536778_n.jpg.  Try manually importing this file into AE to learn more."
  , reported : "2016-3-2 @ 14:50:46"
}
```

#### Definitions of properties in Templater error objects
##### **`code`**
>A numerical identifier for the reported error.  You can use the error code in the `quit_on_errors` array as defined in [`templater-options.json`](https://github.com/dataclay/cli-tools/blob/master/Windows/templater-options.json) file to force quit after effects on the first occurrence of that error code.

> ###### Error Code Descriptions
>| error code |              description              |
|----------:|:-------------------------------------|
| 1          | Error starting Temlpater application |
| 2          | Error initializing Templater CLI |
| 1001    | Error swapping footage source                                       |
| 1002    | Error downloading remote footage source                                       |
| 1003    | Could not find the footage file in network |
| 2001    | Command line execution error                                      |
| 2002       | CLI configuration file error                                       |
| 3001       | Error conforming row data                                       |
| 4001       | Google Open Authentication (OAuth) Error                                       |
| 4002       | Google Drive retrieval error                                       |
| 5001       | Templater layout engine error                                       |
| 6001       | HTTP request error                                        |

</br>
##### **``desc``**
>A short description of the reported error code

</br>
##### **``ae``**
>The message of the error thrown by After Effects, if any.

</br>
##### **``details``**
>Additional messaging for the specific error and also offers suggestions to troubleshoot the error.

</br>
##### **``reported``**
>A time stamp showing the date and time the error was reported

