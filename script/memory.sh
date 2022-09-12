#!/usr/bin/bash

cd ${HOME}/Desktop/AltSchool/script

file=memory.log

touch ${file}

echo "Memory Usage Log for $(date)" >> ${file}
echo "+-------------------------------+" >> ${file}
echo >> ${file}

free -m >> ${file}
echo "+-------------------------------+" >> ${file}
echo >> ${file}