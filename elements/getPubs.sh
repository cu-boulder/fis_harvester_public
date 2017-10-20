export CLASSPATH=./sqljdbc41.jar 
export CLASSPATH=$CLASSPATH:.
java getPubs > fis_faculty_pubs.dat
cp fis_faculty_pubs.dat /usr/local/vivo/dat-files/cub-new-data
