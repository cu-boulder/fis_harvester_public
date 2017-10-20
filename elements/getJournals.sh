export CLASSPATH=./sqljdbc41.jar 
export CLASSPATH=$CLASSPATH:.
java getJournals > fis_faculty_member_journals.dat
cp fis_faculty_member_journals.dat /usr/local/vivo/dat-files/cub-new-data
