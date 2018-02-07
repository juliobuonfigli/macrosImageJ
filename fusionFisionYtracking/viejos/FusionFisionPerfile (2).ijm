frames=62;
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
pi=3.141592653589793;
dt=2*pi/24;
t=0;

//Normalizacion
run("8-bit");
rename("blanco");
run("Duplicate...", "title=masc duplicate");
run("Duplicate...", "title=final duplicate");
selectWindow("masc");
setAutoThreshold("Default dark");
setOption("BlackBackground", false);
run("Convert to Mask", "method=Default background=Dark calculate black");
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

//Perfiles
//en sentido horario desde las 3
for(i=1; i<25; i++)
	{
	selectWindow("final");
	run("Select None");
	x=(ow/2)*cos(t)+cx;
	y=(oh/2)*sin(t)+cy;
	//setPixel(x, y, 255);
	makePoint(x, y);
	run("Plot Z-axis Profile");
	rename("Interno");
	selectWindow("final");
	run("Select None");
	x=1.3*(ow/2)*cos(t)+cx;
	y=1.3*(oh/2)*sin(t)+cy;
	makePoint(x, y);
	//setPixel(x, y, 255);
	run("Plot Z-axis Profile");
	rename("Externo");
	run("Images to Stack", "name=Stack title=terno use");
	rename(i);
	t=t+dt;
	}

//Deberían ser 4 circulos o dos ensayos porque las vesiculas podrian saltearse 
//la velocidad y el tamaño de la vesículas me van a decir la cuan lejos deberían estar los dos ovalos
//La caantidad de puntos estaría definida por el tamaño de las vesículas full-width-at-half-maximum (FWHM)   




