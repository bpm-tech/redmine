#/bin/sh

DUMPFILE="./redmine_dev.sql"
mysql -u redmine -h mysql -D redmine_development -p < ${DUMPFILE}
