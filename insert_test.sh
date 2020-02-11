echo "----------------"
echo "Program start..."
echo "----------------"

# We create the new collection of RGBSets for JPG images
collname="testjpg"
echo ""
echo "-----------------------"
echo "Creating collections..."
rasql -q "create collection $collname RGBSet" --user rasadmin --passwd rasadmin
echo "Collection created!"
echo "-------------------"
echo ""

# We get the current working directory
currentdir=$(pwd)
# String that we want to concatenate
jpgstring="/Images/JPG"
# Folders for later executions
tiffstring="/Images/TIFF"
pgmstring="/Images/PGM"
ppmstring="/Images/PPM"

# Result of the concatenated string, image folder
ifolder="$currentdir$jpgstring"

# Now we will print the execution times of various files
echo "-------------------------------------"
echo "Calculating insert execution times..."
echo "-------------------------------------"

# We create a counter for the files that will be evaluated
counter=1

for filename in $(ls "$ifolder")
do
	# We print the file path
	filepath="$ifolder/$filename"
	# We get the file size
	filesize=$(stat -c%s "$filepath")
	# We print the file name and file size
	echo "------------------------------------------------------------"
	echo "File #$counter: Filename = $filename; Size = $filesize bytes"
	echo "------------------------------------------------------------"
	eval "file $filepath"
	echo ""

	command="time rasql -q 'insert into "$collname" values decode(\$1)' -f $filepath --user rasadmin --passwd rasadmin"

	# We run the insert into the collection
	eval "$command"	

	# End of the file evaluation
	echo ""
	echo "End of File #$counter"
	echo "---------------------"

	# We add a space for better clarity
	echo ""

	# We increment the counter
	let "counter++"

done;

echo "---------------------------------"
echo "Insert time calculation finished!"
echo "---------------------------------"
echo ""

# We delete the created collections
echo "--------------------"
echo "Dropping collections"
rasql -q "drop collection $collname" --user rasadmin --passwd rasadmin
echo "Collections dropped!"
echo "--------------------"