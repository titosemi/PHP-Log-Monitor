#!/bin/sh

title="PHP Log Monitor"
log=""
icons=""
verbose=0
debug=0
system=""
notificator=""

init()
{
    UNAME=$(uname)
    if [[ "$UNAME" = Darwin ]]
    then
        system="osx"
        growl=$(ps -e | grep Growl | grep -v grep) 
        if [[ "$growl" != "" ]]
        then
            notificator="Growl"
        else
            errorNotificator "Growl"
            exit 1
        fi
    fi
}

loadLogFile()
{
    if [[ "$log" = "" ]]
    then
        autoloaded=1
        php=$(which php)
        unknownLog=0 
        if [[ "$system" = "osx" ]]
        then
            if [[ -L "$php" ]] || [[ -h "$php" ]]
            then
                # MAMP
                if [[ `dirname $(readlink $php)` = *MAMP* ]]
                then
                    log="/Applications/MAMP/logs/php_error.log"
                # No idea!
                else
                    errorLogAutoLoad
                    unknownLog=1
                fi
            # OSX distributed Apache
            else
                log="/var/log/apache2/php_errors.log"
            fi
        elif [[ "$system" = *Linux* ]]
        then
            log="/var/log/apache2/php_errors.log"
        fi
    fi

    if [[ "$unknownLog" = 1 ]]
    then
        enterNewLogFile
    else
        if [[ "$autoloaded" = 1 ]]
        then
            messageLogAutoLoaded
        fi
        checkLogFile
    fi

    messageLogLoaded

    setIconsPath

    if [[ "$debug" = 1 ]]
    then
        debugConfiguration
    fi
}

errorNotificator()
{
    echo ""
    echo "Error: None of the supported notificator was found on your system: $1"
    echo ""
}

errorLogAutoLoad()
{
    echo ""
    echo "Error: Unable to auto find where the php log file is."
    echo ""
}

errorLogNotExists()
{
    echo ""
    echo "Error: The given filename does not exists."
    echo ""
}

errorLogNotReadable()
{
    echo ""
    echo "Error: The given filename is not readable."
    echo ""
}

messageUsage()
{
    echo ""
    echo "Usage: \$ phplog-monitor [options]"
    echo ""
    echo "Options:"
    echo "  --log=filename  Specified the path of the php log file."
    echo "  --verbose       Display in console all messages logged in the php log file. IE. Stacktrace."
    echo "  --debug         Print some config variables"
    exit 1
}

messageLogAutoLoaded()
{
    echo ""
    echo "Auto loaded Log file. Reading from: $log"
    echo ""
}

messageLogLoaded()
{
    echo ""
    echo "Loaded Log file. Reading from: $log"
}

checkLogFile()
{
    if [[ ! -f "$log" ]] 
    then
        errorLogNotExists
        enterNewLogFile
    elif [[ ! -r "$log" ]]
    then
        errorLogNotReadable
        enterNewLogFile
    fi

}

enterNewLogFile()
{
    echo ""
    echo "Please enter the path where the php log file is located: "
    read -e log
    checkLogFile
}

setIconsPath()
{
    if [[ -L "$0" ]] || [[ -h "$0" ]]
    then
        icons="$(dirname $(readlink $0))";
    else
        icons="$(pwd)";
    fi 
}

parseTheLog()
{
    tail -n 0 -F $log | while read line
    do
        errorLevel=""

        if [[ `echo $line |grep "Fatal error"` ]]
        then
            errorLevel="Fatal error"
        elif [[ `echo $line |grep "Parse error"` ]] 
        then
            errorLevel="Parse error"
        elif [[ `echo $line |grep "Warning"` ]]
        then
            errorLevel="Warning"
        elif [[ `echo $line |grep "Notice"` ]] 
        then
            errorLevel="Notice"
        elif [[ `echo $line |grep "Deprecated"` ]]
        then
            errorLevel="Deprecated"
        fi
        
        if [ -n "$errorLevel" ]
        then
            case $notificator in
                "Growl") notifyGrowl "$line" "$errorLevel" ;;
            esac
        fi

        if [[ "$verbose" = 1 ]]
        then
            echo "$line"
        fi

    done

}

notifyGrowl()
{
    output="$(echo $1 | sed 's/"/*/g')";

    typeset message="$*"
    (osascript 2> /dev/null<<EOD
tell application "GrowlHelperApp"
set the allNotificationsList to {"Fatal error", "Parse error", "Warning", "Notice", "Deprecated"}
set the enabledNotificationsList to {"Fatal error", "Parse error", "Warning", "Notice", "Deprecated"}
register as application "${title}" all notifications allNotificationsList default notifications enabledNotificationsList icon of application "Terminal.app"
notify with name "$2" title "$2" description "${output}" image from location "file://${icons}/icons/$2.png" application name "${title}" sticky no priority 2
end tell
EOD
) &
}

debugConfiguration()
{
    echo "------------------------------"
    echo "|    DEBUG CONFIGURATION     |"
    echo "|----------------------------|"
    echo "| title:        $title"
    echo "| log:          $log"
    echo "| icons:        $icons"
    echo "| verbose:      $verbose"
    echo "| debug:        $debug"
    echo "| system:       $system"
    echo "| notificator:  $notificator"
    echo "| errorLevel:   $errorLevel"
    echo "------------------------------"
}

#{

for option in  $* 
do   
    case "$option" in
        --help | --usage) 
            messageUsage
            shift 
            ;;
        --verbose) 
            verbose=1 
            shift
            ;;
        --log*) 
            log="$(echo $option | sed 's/--log=//g')"
            shift 
            ;;
        --debug) 
            debug=1 
            shift 
            ;;
    esac
    shift
done

init
loadLogFile
parseTheLog
#}
