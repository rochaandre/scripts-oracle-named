#--------------------------------------------------
# Check availability and performance of NFS
#--------------------------------------------------
# Logic:
#   1. Create a TestFile0 with size 10 MB on local storage
#   2. Move the file to NFS as TestFile1
#   3. Move the file from NFS back to local storage as TestFile2 
#   4. If the file copy takes longer than 6 seconds, return "NFS FAIL"
#   5. If the final TestFile2 is not exactly 10 MB in size, return "NFS FAIL"
#   6. Otherwise, all is good and return "NFS SUCCESS"
#   7. Output should be a single line, to be parsed by OEM 13c Metric Extension
#   * Make sure to use fully qualified paths in the scripts
#   Parameter: share location NFS_FOLDER
#--------------------------------------------------

#--------------------------------------------------
# Parameters
#--------------------------------------------------
SLEEP_TIME=6
TEST_FILE_SIZE=10240
LOCAL_FOLDER=/tmp
NFS_FOLDER=$1

#--------------------------------------------------
# Create TestFile1 with a file size of TEST_FILE_SIZE
#--------------------------------------------------
rm -f ${LOCAL_FOLDER}/test_file_0.txt
dd if=/dev/zero of=${LOCAL_FOLDER}/test_file_0.txt count=1024 bs=${TEST_FILE_SIZE} > /dev/null 2>&1

#--------------------------------------------------
# Call script to copy file from local disk to NFS and back in the background
#--------------------------------------------------
nohup /stage/scripts/check_nfs_availability_2.sh $NFS_FOLDER > /dev/null 2>&1

#--------------------------------------------------
# Wait for a maximum of SLEEP_TIME seconds
#--------------------------------------------------
sleep ${SLEEP_TIME}

#--------------------------------------------------
# Check if file made it back in time and the right size
#--------------------------------------------------
VFILE=${LOCAL_FOLDER}/test_file_2.txt
if [[ -e "${VFILE}" ]]; then
  # Error means that file that is copied back from NFS is not the expected 10MB in size
  VSIZE=`du ${LOCAL_FOLDER}/test_file_2.txt | awk '{print $1}'`
  if [ ${VSIZE} -eq 10240 ]; then
    echo "NFS SUCCESS"
  else
    echo "NFS FAIL"
  fi
else
  # Error means that file is not copied back from NFS in under 2 seconds
  echo "NFS FAIL"
fi

#--------------------------------------------------
# Remove any temporary files
#--------------------------------------------------
rm -f ${LOCAL_FOLDER}/test_file_0.txt > /dev/null 2>&1
rm -f ${NFS_FOLDER}/test_file_1.txt   > /dev/null 2>&1
rm -f ${LOCAL_FOLDER}/test_file_2.txt > /dev/null 2>&1