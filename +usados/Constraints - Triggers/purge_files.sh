################################################################
# Prog Name:  purge_files.sh 
# Author :    Raj Gutta
# Purpose:    Removes unwanted files older than one week 
# Input Arguments: Accepts SID name as an argument. When no arguments
#                  are passed, checks for all SID's in oratab 
# Notes:      .aud, audit files created by connect internal 
#             .trc, trace files 
#             core, core dump files
##################################################################

# Get environment variables
funct_get_vars() {
ORA_HOME=`sed /#/d ${ORATABDIR}|grep -i ${ORA_SID}|nawk -F ":" '{print $2}'`

if [ x$ORA_HOME = 'x' ]; then
  echo `date` >> $LOGFILE
  echo "PURGE_FAIL: Can't get ORACLE_HOME for $ORA_SID" >> $LOGFILE
  exit 1
fi

ORACLE_HOME=$ORA_HOME
}

# Purge unwanted files older than one week
funct_purge_files() {
 find $ORACLE_HOME/rdbms/audit/ -name "*.aud" -atime +3 -exec rm -f {} \;
 find $ORACLE_HOME/admin/bdump/ -name "*.trc" -atime +3 -exec rm -f {} \;
 find $ORACLE_HOME/admin/udump/ -name "*.trc" -atime +3 -exec rm -f {} \;
 find $ORACLE_HOME/admin/cdump/ -name "core*" -atime +1 -exec rm -rf {} \;
}

funct_chk_bkup_dir(){
 LOGFILE="${LOGDIR}/${ORA_SID}.log"
}

#::::::::::::::::::::::::::
#  Main
#::::::::::::::::::::::::::
# Set up the environment

TOOLS="/u01/oracomn/admin/my_dba"
DYN_DIR="${TOOLS}/DYN_FILES"
LOGDIR="${TOOLS}/localog"
ORATABDIR=/var/opt/oracle/oratab

funct_chk_bkup_dir
if [ $# = 1 ]; then

   ORA_SID=$1
   funct_get_vars 
   funct_purge_files 

elif [ $# = 0 ]; then

   for ORA_SID in `sed /#/d ${ORATABDIR}|awk -F:  '{print $1}'`
   do
       funct_get_vars 
       funct_purge_files 
   done

else
 echo " Error, accepts zero or one aruments only"
fi
