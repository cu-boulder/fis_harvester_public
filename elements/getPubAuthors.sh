export CLASSPATH=./sqljdbc41.jar 
export CLASSPATH=$CLASSPATH:.
java getPubAuthors > fis_faculty_authorships.dat
cp fis_faculty_authorships.dat /usr/local/vivo/dat-files/cub-new-data
