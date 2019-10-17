close("*")
path = "/home/nathan/data/jSPIM/2019_10_02/beads_3/"; //getDirectory("Choose a Directory")
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
slices = list.length - 7;																				// the two numbers (5 and 1) in these two lines are dependent on the fact that ive already run part of the whole hyperstack compiling algorithm so will have to take that out once i integrate this with other part
str =  '"order=xyczt(default) channels=1 slices=' + slices + ' frames=' + frames + ' "';
run("Stack to Hyperstack...", str);		
final_save_path = path + '/hyperstack.tif';
saveAs("tiff", final_save_path);															