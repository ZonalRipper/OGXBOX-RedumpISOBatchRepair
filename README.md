# OGXBOX-RedumpISOBatchRepair
Making use of the dd tool for windows created by John Newbigin (jnewbigin on Github)
This will repack the XBOX ISO files that are not being picked up correctly in tools like Qwix or Repackinator
After being repacked the ISO files should be identified correctly 

The bat file will allow the user to select a source folder and output folder and will loop through any .iso file in the source folder, repack the .iso to the output folder using the same filename but prefixed with [fixed]
it will ignore any .iso files that contain the text [fixed] in the file name to help stop any continous loops happnening when using the same output folder as the source folder

Thanks to John Newbigin for rawwrite/dd tool
https://uranus.chrysocome.net/linux/rawwrite/dd.htm

