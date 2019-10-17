path = getDirectory("Choose a Directory");
dir_list = '' ;
list = getFileList(path); 										//lists all items, folders and files, in selected path/dataset
	for (i=0; i<list.length; i++) { 							
          if (endsWith(list[i], "/"))
              dir_list = Array.concat(dir_list,list[i]);		//stores all folders/positions of selected path/dataset, also counts files 
}
																//now i have a list of the folders/positions with the t stacks in them, need to take this folder list and for dir_list[1] i need to take file_list[1] and open
	for (i = 1; i < dir_list.length; i++) { 					//iterating over all positions to extract first frame and make into z stack
		position_folder = path + dir_list[i]; 					//defining position folder
		file_list = getFileList(position_folder);				//getting files from that folder
			for (j = 0; j < file_list.length; j++) {
				if (file_list[j] != "metadata.txt") {
				file_path = position_folder + file_list[j];				//defining path to get file[1] ie t=1
				run("TIFF Virtual Stack...", "open=" + file_path);		//opening virtual stack of file
				frame_folder = path + "Frame-" + j;						//naming new folder for z-stacks
				File.makeDirectory(frame_folder);						//making new folder for z-stacks
				save_name = frame_folder + "/" + file_list[j];			//making save path for frame[j] stack
				saveAs("tiff", save_name); 								//saving frame[j] there
				close();
				}
			}
}
frame_folder_list = '';																
list = getFileList(path)												//get refreshed list of all files in main dir
for (n = 0; n<list.length; n++) {
	if (startsWith(list[n], "Frame-")) {				
		frame_folder_list = Array.concat(frame_folder_list,list[n]);	//get new list of only the frame folders
	}
}
command_str = '';																												// defining string used to concatenate
for (k = 1; k < frame_folder_list.length; k++) { 																				//k=1 bc first entry in fflist is empty
	file_list = getFileList(path + frame_folder_list[k]);																		//get list of files inside frame folder (ie z stack)
	path_str = '"open=/home/nathan/data/jSPIM/2019_10_02/beads_3/' + frame_folder_list[k] + file_list[1] + ' sort use"';		//defining where the zstack is 
	run("Image Sequence...", path_str);																							//opening zstack
	
			frame_str = frame_folder_list[k];															//parsing frame directory name to a string to edit "/" out of
			str_length = lengthOf(frame_str) - 1;
			frame_str = substring(frame_str, 0, str_length);
			command_str = command_str + 'image' + k + '=' + frame_str + ' ';							//defining string of images to parse to concatenation command
	}
open_str = '"open ';
str = open_str + command_str + '"';
run("Concatenate...", str);																	  			//concatenation of zstack into hyperstack
frames = frame_folder_list.length - 1 ;																	//could be taken out and replaced with getDimensions
slices = nSlices / frames ;																				// the two numbers (5,1) in these two lines are dependent on the fact that ive already run part of the whole hyperstack compiling algorithm so will have to take that out once i integrate this with other part
str =  '"order=xyczt(default) channels=1 slices=' + slices + ' frames=' + frames + ' "';
run("Stack to Hyperstack...", str);	
final_save_path = path + '/hyperstack.tif';
saveAs("tiff", final_save_path);
