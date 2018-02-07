
macro "FuFi [f]" {

function normalizacion(img) {  //functions
selectWindow(img);
w=getWidth;
h=getHeight;
frames=nSlices;
run("Set Measurements...", "mean min redirect=None decimal=2");
run("Select None");
run("Measure");
max=getResult("Max", 0);
min=getResult("Min", 0);
run("Clear Results");
for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	for(y=0; y<h; y++)
   	 {
	 for(x=0; x<w; x++)
	 	{
	 	p=getPixel(x, y);
	 	setPixel(x, y, round(((p-min)*255)/(max-min))+1);
	 	}	
	  }
	}
}

function mult(img, cond, UM) {

selectWindow(img);
w=getWidth;
h=getHeight;
frames=nSlices;
run("Set Measurements...", "mean min redirect=None decimal=2");
run("Select None");
run("Measure");
max=getResult("Max", 0);
min=getResult("Min", 0);
run("Clear Results"); 	                                       
  	
selectWindow(img);
for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	for(y=0; y<h; y++)
   	 {
	 for(x=0; x<w; x++)
	 	{
	 	p=getPixel(x, y);
	 	setPixel(x, y, round(((p-min)*16)/(max-min))+1);
	 	}	
	  }
	}

newImage("multiplicador", "8-bit black", w, h, frames);
p1=newArray(w*h);
p2=newArray(w*h);

for(i=1; i<frames; i++)
	{
	selectWindow(img);
	j=0;
	setSlice(i);
	for(y=0; y<h; y++)
   	 {
	 for(x=0; x<w; x++)
	 	{
	 	p1[j]=getPixel(x, y);
	 	j++;
	 	}	
	  }
	 setSlice(i+1); j=0;
	 for(y=0; y<h; y++)
   	 	{
	 	 for(x=0; x<w; x++)
			{	 	
	 		p2[j]=getPixel(x, y);
	 		j++;
			}	
	  	}
	selectWindow("multiplicador");
	setSlice(i+1);
	j=0;
	for(y=0; y<h; y++)
   	 {
	 for(x=0; x<w; x++)
	 	{
	 	if(cond==true) {
	 		if(p2[j]/p1[j]>UM-1)
	 			setPixel(x, y, 9);
	 			else
	 			setPixel(x, y, 2);
	 			} else {
	 	setPixel(x, y, 3*p2[j]/p1[j]+1); }
   	    j++;
   	    }
	}
}
selectWindow("multiplicador");
setSlice(1);
run("Add...", "value=9 slice");
imageCalculator("Multiply stack", img, "multiplicador");
selectWindow("multiplicador");
close();
}


function poligono(esp, sep, CX, CY, t, dt, ow, oh, j, cond, DX, DY) {
xa=round(sep*(ow/2)*cos(t)+CX+DX);
ya=round(sep*(oh/2)*sin(t)+CY+DY);
xb=round(sep*(ow/2)*cos(t+dt)+CX+DX);
yb=round(sep*(oh/2)*sin(t+dt)+CY+DY);
xc=round(sep*(ow/2)*cos(t+2*dt)+CX+DX);
yc=round(sep*(oh/2)*sin(t+2*dt)+CY+DY);
XA=round(sep*esp*(ow/2)*cos(t)+CX+DX);
YA=round(sep*esp*(oh/2)*sin(t)+CY+DY);
XB=round(sep*esp*(ow/2)*cos(t+dt)+CX+DX);
YB=round(sep*esp*(oh/2)*sin(t+dt)+CY+DY);
XC=round(sep*esp*(ow/2)*cos(t+2*dt)+CX+DX);
YC=round(sep*esp*(oh/2)*sin(t+2*dt)+CY+DY);
if(cond==true)
makePolygon(xa,ya,xb,yb,xc,yc,XC,YC,XB,YB,XA,YA);
else
makePolygon(xa,ya,xc,yc,XC,YC,XA,YA);
}

function cbrt(w)                  
{
   x = w;
   y = 1;
   e = 0.000001;
  while(x - y > e)
  {
    x = (2*x + y)/3;
    y = w/(x*x);
  }
return x;
}

function igualar(w, h, frames) {
selectWindow("Final");
size=1/(w*h);
ipp=newArray(frames+1);
for(i=1; i<frames+1; i++)
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
for(i=1; i<frames+1; i++)
	ip=ip+ipp[i];
ip=ip/frames;

for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	fac=ip/ipp[i];
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			pix=getPixel(x,y);
			setPixel(x, y, pix*fac+1); 
			}
		}
	updateDisplay();
	}
}

id1=getImageID();          
tamano=0;

figura=newArray(nImages);
for(i=id1-1000; i<id1+1000; i++)
	{
	showStatus("Loading images...");
	if(isOpen(i) && tamano<nImages)
		{
		selectImage(i);
		figura[tamano]=getTitle();
		tamano++;
		}		
	}

Dialog.create("Fusion-Fission");                          //main dialog                       
 Dialog.addChoice("Stack:", figura); 
  Dialog.addNumber("Cell drift X:", 7); 
  Dialog.addNumber("Cell drift Y:", -5); 
  Dialog.addNumber("Vesicle diameter (pixels):", 12);  
  Dialog.addNumber("Step delay: ", 0);
  Dialog.addCheckbox("More options", false);  
   Dialog.show();
                                         
  img=Dialog.getChoice(); 
  dx=Dialog.getNumber();
  dy=Dialog.getNumber(); 
  vd=Dialog.getNumber(); 
  sd=Dialog.getNumber();
  MO=Dialog.getCheckbox();    
  
if(isOpen("Final")) {                       //stack and main ROI data
	selectWindow("Final");
	close(); }  
run("ROI Manager...");
selectWindow("ROI Manager");
run("Close");
selectWindow(img);
roiManager("Add");
run("Select None");
run("Duplicate...", "duplicate");
rename("Final");
run("8-bit");
w=getWidth();                    
h=getHeight();
frames=nSlices();
roiManager("Select", 0);
run("Set Measurements...", "centroid bounding redirect=None decimal=0");
run("Measure");
cx=getResult("X", 0);
cy=getResult("Y", 0);
ow=getResult("Width", 0);
oh=getResult("Height", 0);
run("Clear Results"); 
run("Select None");
roiManager("Select", 0);
roiManager("Rename", "main");

pi=3.141592653589793; 
perimetro=pi*(3*((ow+oh)/2)-sqrt((3*oh/2+ow/2)*(3*ow/2+oh/2)));       //default setting

eq=true;
if(vd>10) {
	radiusUM=4; 
	radiusM=4; }
	else {
		if(vd>7 && vd<10) {
			radiusUM=3; 
			radiusM=3; }
			else {
			radiusUM=2;
			radiusM=2;
		}
	}
subt=40;
NORM=true;
EMO=true;
CC=true; RC=10;
frag=round(perimetro/vd);
esp=0.23; 
esp2=0.2;
ra=2;
pol=true;
MAX=60;
MEAN=25;
ESE=true;
ESO=false;
EAE=true;
EAO=false;
BM=false;

if(MO==true) {
Dialog.create("Fusion-Fision");                              //secundary dialog                            
  Dialog.addMessage("STACK TREATMENT");
  Dialog.addCheckbox("Equalize stack", eq);
  Dialog.addNumber("Unsharp mask radius: ",  radiusUM);  
  Dialog.addNumber("Mean filter radius: ",  radiusM);
  Dialog.addNumber("Subtracting: ",  subt);
  Dialog.addCheckbox("Normalize", NORM);
  Dialog.addCheckbox("Enhance moving objects", EMO);
  Dialog.addCheckbox("Constant coeficient", CC);
  Dialog.addNumber("Radius: ",  RC);
  Dialog.addMessage("SAMPLING");
  Dialog.addNumber("Number of sections:", frag); 
  Dialog.addNumber("Inner ROI thick (main ROI radius proportion):", esp); 
  Dialog.addNumber("Outer ROI thick (main ROI radius proportion):", esp2);
  Dialog.addNumber("Outer ROI arc length (inner ROI proportion): ", ra);
  Dialog.addCheckbox("Polygonal inner ROI", pol);
  Dialog.addMessage("EVALUATION");
  Dialog.addNumber("Event maximum signal threshold: ", MAX);
  Dialog.addNumber("Event mean signal threshold: ", MEAN);
  Dialog.addCheckbox("Subtract successive events of the same kind", ESE);
  Dialog.addCheckbox("Subtract successive events of the opposite kind", ESO);
  Dialog.addCheckbox("Subtract adjacent events of the same kind", EAE);
  Dialog.addCheckbox("Subtract adjacent events of the opposite kind", EAO); 
  Dialog.addMessage("*************");
  Dialog.addCheckbox("Set BatchMode", BM); 
  Dialog.show();
                                     
  eq=Dialog.getCheckbox();
  radiusUM=Dialog.getNumber(); 
  radiusM=Dialog.getNumber();
  subt=Dialog.getNumber();
  NORM=Dialog.getCheckbox();
  EMO=Dialog.getCheckbox();
  CC=Dialog.getCheckbox();
  RC=Dialog.getNumber();
  frag=Dialog.getNumber(); 
  esp=Dialog.getNumber(); 
  esp=Dialog.getNumber(); 
  ra=Dialog.getNumber();
  pol=Dialog.getCheckbox();
  MAX=Dialog.getNumber();
  MEAN=Dialog.getNumber();
  ESE=Dialog.getCheckbox();
  ESO=Dialog.getCheckbox();
  EAE=Dialog.getCheckbox();
  EAO=Dialog.getCheckbox(); 
  BM=Dialog.getCheckbox();  }

if(BM==true) setBatchMode(true);
selectWindow("Final");
run("Select None");
if(eq==true) igualar(w, h, frames);                                          //treatments
if(radiusUM>0) run("Unsharp Mask...", "radius=radiusUM mask=0.99 stack");
if(radiusM>0) run("Mean...", "radius=radiusM stack");
if(subt>0) run("Subtract...", "value=subt stack");
if(NORM==true) normalizacion("Final");
if(EMO==true) mult("Final", CC, RC); 

dx=dx/frames; dy=dy/frames; 
v1=newArray(frag*frames); v2=newArray(frag*frames);  m1=newArray(frag*frames); m2=newArray(frag*frames); 
t=0; cont=0; cont2=1; esp=esp+1; esp2=esp2+1; dt=pi/frag;  
selectWindow("Final");
run("Select None"); 
run("Set Measurements...", "mean min redirect=None decimal=2");

for(i=1; i<frag+1; i++)    //sampling loop
	{
	DX=0; DY=0;
	for(j=1; j<frames+1; j++)   
		{
		DX=DX+dx;  DY=DY-dy;
		setSlice(j);
		poligono(esp, 1, cx, cy, t, dt, ow, oh, j, pol, DX, DY); 
		run("Measure");
		roiManager("Add");
		roiManager("Select", cont2);
		roiManager("Rename", i+"-"+j+"-"+1);
		v1[cont]=getResult("Mean", 0);
		m1[cont]=getResult("Max", 0);
		run("Clear Results"); 	wait(sd); 	run("Select None");  cont2++; 
		poligono(esp2, cbrt(esp)*esp, cx, cy, t-(ra-1)*dt, ra*dt, ow, oh, j, true, DX, DY);
		run("Measure");
		roiManager("Add");
		roiManager("Select", cont2);
		roiManager("Rename", i+"-"+j+"-"+2);
		v2[cont]=getResult("Mean", 0);
		m2[cont]=getResult("Max", 0);
		run("Clear Results"); 	wait(sd); 	run("Select None");  cont2++;
		cont++;
		}	
	t=t+2*dt;
	}

sal=newArray(frag*frames);  ev=newArray(frames*frag);   TRUE=newArray(frag*frames);	 
for(i=0; i<frag*frames; i++) {ev[i]=false; sal[i]=0; }

for(e=1; e<frag*frames-1; e++)   //evaluation loop
	{
	if(m1[e]>MAX && v1[e]>MEAN) 
		{
		ev[e]=true;
		if(m2[e-1]>MAX && m2[e+1]<MAX)
			{
			sal[e]=1; TRUE[e]=true; 
			}
			else 
			{
			if(m2[e+1]>MAX && m2[e-1]<MAX)
				{
				sal[e]=-1; TRUE[e]=true;
				}
				else 
				{
				TRUE[e]=false;	
				if(v2[e+1]<v2[e-1])
					sal[e]=1;
					else
					sal[e]=-1;
				}
			}
		}	
	}
	
for(i=0; i<frag*frames; i++)  {                               //subtract false events
	if(i%frames==0 || (i+1)%frames==0 || (i+2)%frames==0)
		ev[i]=false; }

if(ESE==true) {
for(i=1; i<frames*frag; i++) {      
	if(sal[i-1]==1 && sal[i]==1 && (i-1)%frames!=0)
		ev[i-1]=false;
	if(sal[i-1]==-1 && sal[i]==-1 && (i-1)%frames!=0)
		ev[i-1]=false; } }

if(ESO==true) {
for(i=1; i<frames*frag; i++) {     
	if(sal[i-1]==-1 && sal[i]==1 && (i-1)%frames!=0)
		ev[i-1]=false;
	if(sal[i-1]==1 && sal[i]==-1 && (i-1)%frames!=0)
		ev[i-1]=false; } }

if(EAE==true) {
for(i=1; i<frames*frag-frames; i++) {   
	if(sal[i]==1 && sal[i+frames]==1)
		ev[i]=false;
	if(sal[i]==-1 && sal[i+frames]==-1)
		ev[i]=false; } }

if(EAO==true) {
for(i=1; i<frames*frag-frames; i++) {    
	if(sal[i]==-1 && sal[i+frames]==1)
		ev[i]=false;
	if(sal[i]==-1 && sal[i+frames]==1)
		ev[i]=false; } }

selectWindow("Results");
run("Close");

titulo1 = "Results";                      // Analytical and graphic results                  
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if(isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");
print(f, "\\Headings: section\t slice\t event\t calification\t intensity");

contador=1;
for(i=0; i<frag*frames; i++)
	{
	if(sal[i]==1) out="fU"; else out="fI";
	if(TRUE[i]==false) rated="notRated"; else rated="RATED";
	if(ev[i]==true)
	print(f, (floor(i/frames)+1)+"\t    "+contador+"\t    "+out+"\t    "+rated+"\t    "+v1[i]);
	contador++;
	if(contador==frames)  contador=0;
	}

titulo3 = "Summary";                                            
titulo4 = "["+titulo3+"]";
  b = titulo4;
 if(isOpen(titulo4))
    print(b, "\\Clear");
 else
run("Table...", "name="+titulo3+" width=250 height=600");
print(b, "\\Headings: section\t fusions\t fissions\t notRated\t signalDensity");

toti=newArray(frag);
totFus=0; totFis=0; totNocal=0;
for(i=0; i<frag; i++)
	{
	fusiones=0; fisiones=0; noCal=0; toti[i]=0; 
	for(j=i*frames+1; j<i*frames+frames; j++)
		{
		if(ev[j]==true) 
			{
			if(sal[j]==1 && TRUE[j]==true) fusiones++;	
			if(sal[j]==-1 && TRUE[j]==true) fisiones++;	
			if(sal[j]!=0 && TRUE[j]==false) noCal++;	
			}
		toti[i]=toti[i]+v2[j]/frames;
		}
	totFus=totFus+fusiones;
	totFis=totFis+fisiones;
	totNocal=totNocal+noCal;
	print(b, i+1+"\t    "+fusiones+"\t    "+fisiones+"\t    "+noCal+"\t    "+toti[i]);
	}
print(b, "Total"+"\t    "+totFus+"\t    "+totFis+"\t    "+totNocal);

setForegroundColor(255, 255, 255);
selectWindow("Final");
roiDraw=newArray(frag);
for(i=0; i<2*frag; i++) {
roiManager("Select", i*frames+1);	
if(getSliceNumber()==1) roiManager("Draw");
roiManager("Select", i*frames+2);	
if(getSliceNumber()==1) roiManager("Draw"); 
}
run("Select None");
if(BM==true) setBatchMode("exit and display");
}
