#!/usr/bin/bash

fileLog=memory.log

function createLog {
    cd ${HOME}/Desktop/AltSchool/script
    touch ${fileLog}
}

function memoryCheck {
    echo "Memory Usage Log for $(date)" >> ${fileLog}
    echo "+-------------------------------+" >> ${fileLog}
    echo >> ${fileLog}

    free -m >> ${fileLog}
    echo "+-------------------------------+" >> ${fileLog}
    echo >> ${fileLog}
}

function logWipe {
    cd ${HOME}/Desktop/AltSchool/script

    rm -rf ${fileLog}
}

function sendMail {
    sendmail davidoluwatobi41@gmail.com  < ${fileLog}
}

createLog
memoryCheck
sendMail
logWipe