#!/usr/bin/bash

fileLog=memory.log
timeCheck=$(date +%H)

# gets email from secret file
email=$(< ${HOME}/.secret)

# creates a file <memory.log>
function createLog {
    touch ${fileLog}
}

# keeps a log of requested info <memory usage>
function memoryCheck {
    echo "Memory Usage Log for $(date)" >> ${fileLog}
    echo "+-------------------------------+" >> ${fileLog}
    echo >> ${fileLog}

    free -m >> ${fileLog}
    echo "+-------------------------------+" >> ${fileLog}

    echo >> ${fileLog}
}

# deletes the log file 
function logWipe {
    rm -rf ${fileLog}
}

# sends a mail containing the contents of memory.log the to assigned email address
function sendMail {
    sendmail ${email} < ${fileLog}
}

function funcCall {
    cd ${HOME}/Desktop/AltSchool/script

    # does nothing if memory.log exists else it creates it 
    if test -f ${fileLog};
        then :
    else
       createLog
    fi

    memoryCheck

    # checks if it's midnight (12 am) before running the functions
    if [ ${timeCheck} = 00 ];
        then sendMail && logWipe
    else 
        :
    fi
}

funcCall