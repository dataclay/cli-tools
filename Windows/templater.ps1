param (
    [string]$ver
)

if (-not $ver) {
"
`tUsage:
`t`ttemplater.ps1 version [ui] [-m]

`tVersion options:
`t`t'CC 2015' 'CC2014' 'CC' 'CS6' 'CS5.5' 'CS5'

`tInclude option 'ui' to launch After Effects with a GUI

`tInclude option '-m' to launch After Effects as a new, separate,
`tprocess. This is useful if you want to simultaneously execute two
`tor more versioning jobs with Templater's CLI.

`tExamples:
`t`tTo launch CC 2015 without a GUI => .\templater.ps1 'CC 2015'
`t`tTo launch CC 2015 with a GUI    => .\templater.ps1 'CC 2015' ui
`t`tTo launch CS5 without a GUI     => .\templater 'CS5'
`t`tTo launch CS5 with a GUI        => .\templater 'CS5' ui
"
exit
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

$app_dir="C:\Program Files\Adobe\Adobe After Effects $ver\Support Files"
$panels="$app_dir\Scripts\ScriptUI Panels"
$templater_filename="Templater 2.jsxbin"
$templater_panel="$panels\$templater_filename"

if (!$args) {
    $ui = '-noui'
    $instance = ' '
} else {
    $ui = $args[1]
    $instance = $args[2]
}

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
$cmd_args = "$ui $instance -r  $PSScriptRoot\$templater_filename"

"
`t`tInvoking Adobe After Effects $ver =>
`t`t`t$cmd $ui $instance -r `"$PSScriptRoot\$templater_filename`"
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
"

`t`tTemplater messages and errors logged to =>
`t`t`t$log_path\templater.log
`t`t`t$log_path\templater.err

`t`tLast logged message =>
"
if (Test-Path "$log_path\templater.log"){
    Get-Content "$log_path\templater.log" | Select-Object -last 1
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