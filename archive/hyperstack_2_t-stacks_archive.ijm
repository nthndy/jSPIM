for (i=1; i<30; i++) {; 

selectWindow("c-elegans-test.tif");
run("Reduce Dimensionality...", "slices keep");
selectWindow("c-elegans-test.tif");
setSlice(60 * i + 1);

};
print(i);