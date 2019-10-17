for (i=1; i<60; i++) {;
selectWindow("c-elegans_test_1-0.tif");
//setSlice(1);
pixel_shift = 2* (i - 1);
canvas_height = 410 - (2* (i - 1));
run("Make Substack...", "delete slices=1");
selectWindow("Substack (1)");
run("Canvas Size...", "width=410 height=" +(410 - (2* (i-1)))+ " position=Top-Center");
rename(i);
run("Canvas Size...", "width=410 height=410 position=Bottom-Center");
}; //test
\\close("c-elegans_test_1-0.tif")
\\run("Images to Stack");
