macro "Fusion-fision análisis [z]"   
{
//setBatchMode("true");

// Coordenadas de ovalo y otras variables
frames=30;
run("Set Measurements...", "centroid bounding redirect=None decimal=0");
run("Measure");
cx=getResult("X", 0);
cy=getResult("Y", 0);
ow=getResult("Width", 0);
oh=getResult("Height", 0);
run("Clear Results"); 
run("Select None");
w = getWidth;              
h = getHeight;
size=1/(w*h);
ipp=newArray(frames);


//Normalizacion
run("8-bit");
rename("blanco");
run("Duplicate...", "title=masc duplicate");
run("Duplicate...", "title=final duplicate");
selectWindow("masc");
setAutoThreshold("Default dark");
setOption("BlackBackground", false);
run("Convert to Mask", "method=Default background=Dark calculate black");
//imageCalculator("AND stack", "blanco","masc");
imageCalculator("AND create stack", "blanco","masc");
selectWindow("blanco");
close();
selectWindow("masc");
close();


for(i=1; i<frames; i++)
	{
	setSlice(i);
	ipp[i]=0;
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			ipp[i]=ipp[i]+getPixel(x,y);
			}
		}
	ipp[i]=ipp[i]*size;
	}

ip=0;
for(i=1; i<frames; i++)
	ip=ip+ipp[i];
	
ip=ip/frames;

selectWindow("Result of blanco");
close();
selectWindow("final");

for(i=1; i<frames; i++)
	{
	setSlice(i);
	fac=ip/ipp[i];
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			pix=getPixel(x,y);
			setPixel(x, y, pix*fac); 
			}
		}
	updateDisplay();
	}


// Coordenadas de inclusion
run("8-bit");
rename("Fuente");
run("Duplicate...", "title=Nodo duplicate");
selectWindow("Nodo");
run("Unsharp Mask...", "radius=6 mask=0.99 stack");
setAutoThreshold("Minimum dark");
run("Convert to Mask", "method=Minimum background=Dark calculate black");
makeOval(round(cx-ow/2), round(cy-oh/2), ow, oh);
run("Make Inverse");
for(i=1; i<frames; i++)
	{
	setSlice(i);
	run("Fill", "slice");
	}
run("Invert", "stack");
run("Close-", "stack");
run("Fill Holes", "stack");
run("Watershed", "stack");
CX=newArray(frames+1);
CY=newArray(frames+1);
run("Set Measurements...", "centroid redirect=None decimal=2");
for(i=1; i<frames; i++)
	{
	setSlice(i);
	doWand(cx, cy);
	run("Measure");
	CX[i]=getResult("X", i-1);
	CX[i]=round(CX[i]-ow/2);
	CY[i]=getResult("Y", i-1);
	CY[i]=round(CY[i]-oh/2);
	}
selectWindow("Nodo");
close();
run("Clear Results");

//Genera imagen final
selectWindow("Fuente");
setForegroundColor(0, 0, 0);
for(i=1; i<frames; i++)
	{
	setSlice(i);
	makeOval(CX[i], CY[i], ow, oh);
	run("Make Inverse");
	run("Fill", "slice");
	}
updateDisplay();


//Medicion y grafica 
selectWindow("Fuente");
run("Select None");
run("Set Measurements...", "mean redirect=None decimal=9");
for(i=1; i<frames; i++)
	{
	setSlice(i);
	run("Measure");
	}

newImage("Intensidad Relativa", "8-bit black", frames, 100, 1);
for(i=1; i<frames; i++)
	{
	y=round(100*getResult("Mean", i-1));
	setPixel(i, y, 255);
	}
run("Flip Vertically");

//setBatchMode("exit and display");
}



	