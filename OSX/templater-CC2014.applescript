on run argv
    
    set tmpl to "Templater 2.jsxbin"
    set panels to "/Applications/Adobe After Effects CC 2014/Scripts/ScriptUI Panels/"

    try
        set ui to (item 1 of argv)
    on error
        set ui to false
    end try

    tell application "Finder"
        set current_path to POSIX path of (container of (path to me) as string)
    end tell
    
    do shell script "cp -f '" & panels & tmpl & "' '" & current_path & tmpl & "'"

    set scriptFile to (current_path & tmpl)
    
    if ui is not equal to "ui" then
        do shell script "open -a 'Adobe After Effects CC 2014' --args -noui"
    end if

    tell application "Adobe After Effects CC 2014"
        activate
        using terms from application "Adobe After Effects CC 2014"
            DoScriptFile scriptFile
        end using terms from
    end tell
    
end run

