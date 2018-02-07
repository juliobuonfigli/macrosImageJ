
run("ROI Manager...");
selectWindow("ROI Manager");
run("Close");
roiManager("Add");
roiManager("Select", 0);
run("Set Measurements...", "centroid bounding redirect=None decimal=0");
run("Measure");
ow=getResult("Width", 0);
oh=getResult("Height", 0);
run("Clear Results"); 
pi=3.141592653589793; 
p=0.06;

perimetro=0.85*pi*(3*(0.06*(ow+oh)/2)-sqrt((0.06*3*oh/2+0.06*ow/2)*(0.06*3*ow/2+0.06*oh/2)));
print(perimetro);