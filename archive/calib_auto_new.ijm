//need to create a directory with the multidimensional zt stack split into individual images
data = File.openDialog("Choose a File");		//select multidimensional zt stack
dataset_name = File.getName(data);
directory = File.getParent(data);
stack_directory = directory + '/z_stacks';
File.makeDirectory(stack_directory);			//making new directory for seperated constituent z-stacks from the original multidimensional image
run("TIFF Virtual Stack...", "open=" + data);
getDimensions(width, height, channels, slices, frames);
// NEED TO INPUT FRAME NUMBER VARIABLES, Z NUMBER VARIABLES
	for (j=0; j<frames; j++) {; 				// this loop takes a multidimensional zt stack and splits it into stacks of z, WOULD WORK IF STARTED ON 0 BUT DONT WANT THAT NAMING CONV				
	selectWindow(dataset_name);
	setSlice(slices * j + 1);
	run("Reduce Dimensionality...", "slices keep");
	z_stack_name = "z_stack_" + (j + 1) + '_' + dataset_name ;
	rename(z_stack_name);
	save_name = stack_directory + '/' + z_stack_name;
	saveAs("Tiff", save_name);
	close(z_stack_name);
	selectWindow(dataset_name);
	};
	file_list = getFileList(stack_directory); 		// retrieves names of all separated z stacks
		for (j=0; j<lengthOf(file_list); j++) {;	// this loop selects all of the images in the z_stack folder and realigns each frame in the subsequent loop  
		file_name = file_list[j];
		file_location = stack_directory + '/' + file_name;
		//open(file_location);
		run("TIFF Virtual Stack...", "open=" + file_location );
			for (i=1; i<slices + 1; i++) {; 
			selectWindow(file_name);
			setSlice(i);
			pixel_shift = 2* (i - 1);
			canvas_height = height - (2* (i - 1));			// calculating the realignment amounts
			run("Make Substack...", "slices=" + i);  //select sequential slices to edit, rather than just realigning the first slice repeatedly
			//selectWindow("Substack (1)");				// substack is realigned single image from zstack, unnecessary to select
			run("Canvas Size...", "width=" + width + " height=" +( height - (2* (i-1)))+ " position=Top-Center"); //need way of measuring canvas dimensions and auto parsing that into script
			rename(i);
			run("Canvas Size...", "width=" + width + " height=" + height + " position=Bottom-Center"); //resizing to original dimensions for stack rebuilding
			};
		close(file_name); 								//closing the original zstack
		run("Images to Stack");							//making new realigned zstack from realigned images open
		new_file_name = 'realigned_' + file_name;
		rename(new_file_name);
		new_directory = stack_directory + '/realigned';
		File.makeDirectory(new_directory);
		save_location = new_directory + '/' + new_file_name;
		saveAs("Tiff", save_location);
		close(new_file_name);
		};
run_command = "open=" + save_location + ' sort use"'
run("Image Sequence...", run_command);
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + slices + " frames=" + frames + " display=Color");
final_save = directory + "/realigned_" + dataset_name;
saveAs("Tiff", final_save);