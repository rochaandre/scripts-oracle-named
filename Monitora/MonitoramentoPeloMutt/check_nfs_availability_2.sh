#--------------------------------------------------
# Parameters
#--------------------------------------------------
LOCAL_FOLDER=/tmp
NFS_FOLDER=$1

mv ${LOCAL_FOLDER}/test_file_0.txt ${NFS_FOLDER}/test_file_1.txt
mv ${NFS_FOLDER}/test_file_1.txt ${LOCAL_FOLDER}/test_file_2.txt