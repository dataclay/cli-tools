on run argv
    
    set tmpl to "Templater 2.jsxbin"
    set panels to "/Applications/Adobe After Effects CS6/Scripts/ScriptUI Panels/"

    tell application "Finder"
        set current_path to POSIX path of (container of (path to me) as string)
    end tell

    do shell script "cp -f '" & panels & tmpl & "' '" & current_path & tmpl & "'"
    
    set scriptFile to (current_path & tmpl)
    
    tell application "Adobe After Effects CS6"
        activate
        using terms from application "Adobe After Effects CS6"
            DoScriptFile scriptFile
        end using terms from
    end tell
    
end run

