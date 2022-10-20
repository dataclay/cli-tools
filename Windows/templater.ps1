Param (
    [string]$v = " ",
    [switch]$ui = $false,
    [switch]$m  = $false,
    [switch]$h  = $false
)

$usage = @'


    Desc:   

        Launches Templater for Adobe After Effects
        from the command line.  The launcher always 
        uses the latest Templater runtime installed to
        the targeted version of After Effects. A supported
        version of After Effects is required to be
        installed on this machine for this launcher
        to work properly.

    Usage:

        .\templater.ps1 -v 'ae_version_string' [-ui] [-m]

    Options:

        -h
        Shows this documentation

        -v | --version 'ae_version_string'
        The version of AE you want to use with Templater, 
        where 'version_string' can be any of the following: 
        '2023' '2022' '2021' '2020' 'CC 2019' 'CC 2018' 'CC 2017' 
        'CC 2015.3' 'CC 2015' 'CC 2014' 'CC' 'CS6' 'CS5.5' 'CS5'

        -ui 
        If specified, Adobe After Effects will launch with its
        graphical user interface.  Required if you want to use 
        Templater Bot functionality.

        -m
        If included, this causes AE to launch as a new, seperate,
        process.  This is useful if you want to simultaneously
        execute two or more versioning jobs with Templater.

    Examples:

        Launch without AE user interface
          
          > .\templater.ps1 -v '2023'
          > .\templater.ps1 -v 'CC 2019'
          > .\templater.ps1 -v 'CS5'
        
        
        Launch with AE user interface
          
          > .\templater.ps1 -v '2023' -ui
          > .\templater.ps1 -v 'CC 2019' -ui
          > .\templater.ps1 -v 'CS5' -ui


        Launch new instance of AE without its user interface

          > .\templater.ps1 -v '2023' -m
          > .\templater.ps1 -v 'CC 2019' -m

'@


if ([string]::IsNullorWhitespace($v) -or $h -eq $true) {
    $usage
exit
}

if ($v -ne "2023" -and $v -ne "2022" -and $v -ne "2021" -and $v -ne "2020" -and $v -ne "CC 2019" -and $v -ne "CC 2018" -and $v -ne "CC 2017" -and $v -ne "CC 2015.3" -and $v -ne "CC 2015" -and $v -ne "CC 2014" -and $v -ne "CC" -and $v -ne "CS6" -and $v -ne "CS5.5" -and $v -ne "CS5") {
"
`t`tTemplater CLI Error: Please specify a valid string for the version of After Effects you want to launch. Use -h for more information.
"
exit
}

if ($ui -eq $false) {
    $ui_switch = "-noui"
} else {
    $ui_switch = " "
}

if ($m -eq $false) {
    $m_switch = " "
} else {
    $m_switch = "-m"
}

# Read templater-options.json file if it exists
if (Test-Path "$PSScriptRoot\templater-options.json"){
   
    $opts = Get-Content "$PSScriptRoot\templater-options.json"
    $conf = $opts -join "`n" | ConvertFrom-Json
    
    $log_path   = $conf.log_location
    $aep_file   = $conf.aep
    $data_src   = $conf.data_source
    $output_dir = $conf.output_location
    $output_mod = $conf.output_module
    $ftg_dir    = $conf.source_footage
    $row_start  = $conf.row_start
    $row_end    = $conf.row_end
    $pfx        = $conf.output_prefix

} else {

    echo "`nTemplater CLI configuration file 'templater-options.json' file not found.`nSee you next time :)"
    exit

}

$app_dir="C:\Program Files\Adobe\Adobe After Effects $v\Support Files"
$panels="$app_dir\Scripts\ScriptUI Panels"

#Retrieve the latest Templater runtime from targeted AE version
$panel_paths = (Get-ChildItem -Path "$panels\Templater*").FullName
$panel_versions = @()
foreach ($panel_file in $panel_paths) {
    $path_arr = $panel_file.split('\')
    $panel_versions += ($path_arr[$path_arr.count -1].Substring(10,1))
}
$latest_panel_version = ($panel_versions | Measure-Object -Max).Maximum;

$templater_filename ="Templater $latest_panel_version.jsxbin"
$templater_panel="$panels\$templater_filename"

"`t`t* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
`t`t*                                                               *
`t`t*    Templater CLI Launcher for Microsoft Windows Powershell    *
`t`t*                                                               *
`t`t* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

`t`tAdobe After Effects executable
`t`t`t$app_dir\afterfx.exe

`t`tCLI configuration file =>
`t`t`t$PSScriptRoot\templater-options.json

`t`tUsing following configuration =>
`t`t`tLog Dir         : $log_path
`t`t`tAE Project      : $aep_file
`t`t`tVersioning Data : $data_src
`t`t`tFootage Dir     : $ftg_dir
`t`t`tOutput Dir      : $output_dir
`t`t`tOutput Module   : $output_mod
`t`t`tOutput Prefix   : $pfx
`t`t`tTask Range      : $row_start through $row_end

`t`tInitializing Project Directory =>
`t`t`tCopying `"$app_dir\$templater_filename`" to `"$PSScriptRoot\$templater_filename`""
Copy-Item -Force $templater_panel "$PSScriptRoot\$templater_filename"

$cmd = "$app_dir\afterfx.exe"
$cmd_args = "$ui_switch $m_switch -r  $PSScriptRoot\$templater_filename"

"
`t`tInvoking Adobe After Effects $v =>
`t`t`t$cmd $ui_switch $m_switch -r `"$PSScriptRoot\$templater_filename`"
"

$scriptblock = {

    param($cmd, $cmd_args)

    $process = New-Object system.Diagnostics.Process

    $si = New-Object System.Diagnostics.ProcessStartInfo
    $si.FileName = $cmd
    $si.Arguments = $cmd_args
    $si.UseShellExecute = $false
    $si.RedirectStandardOutput = $true

    $process.StartInfo = $si
    $process.Start() | Out-Null

    do {
        Write-Host `t`t`t $process.StandardOutput.ReadLine()
    } until ($process.HasExited)

}

Invoke-Command -ScriptBlock $scriptblock -ArgumentList $cmd, $cmd_args

if ([string]::IsNullorWhitespace($log_path)) {
    $log_path = $env:TEMP
}

"

`t`tTemplater messages and errors logged to =>
`t`t`t$log_path\templater.log
`t`t`t$log_path\templater.err

`t`tTail end of log =>
"
if (Test-Path "$log_path\templater.log"){
    Get-Content "$log_path\templater.log" | Select-Object -last 5
} else {
    "`t`t`t[No log messages]"
}
"
`t`tLast reported error =>
"
if (Test-Path "$log_path\templater.err"){
    Get-Content "$log_path\templater.err" | Select-Object -last 1
} else {
    "`t`t`t[No error messages]"
    "0"
}