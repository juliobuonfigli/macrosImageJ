/*
 * Fusion-Fisson counter
 * Julio Buonfigli
 * Vacuolas de forma irregular
 * 
 */
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
	 	setPixel(x, y, p2[j]/p1[j]+1); }
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

frag=25; vd=8; sd=true; MO=false;  EIV=false;  cROI=false;                    //basic

Dialog.create("Fusion-Fission");                          //main dialog                       
  Dialog.addChoice("Stack:", figura); 
  Dialog.addNumber("Number of sections (up to 50): ", frag);
  Dialog.addNumber("Vesicle diameter (pixels): ", vd);
  Dialog.addCheckbox("Measure events inside vacuole", EIV);  
  Dialog.addCheckbox("Show sampling process", sd);
  Dialog.addCheckbox("Use current ROI manager list", cROI); 
  Dialog.addCheckbox("Settings", MO);  
  Dialog.show();
                                         
  img=Dialog.getChoice(); 
  frag=Dialog.getNumber(); 
  vd=Dialog.getNumber(); 
  EIV=Dialog.getCheckbox();
  sd=Dialog.getCheckbox();    
  cROI=Dialog.getCheckbox(); 
  MO=Dialog.getCheckbox();    

 
if(isOpen("Final")) {                       //stack and main ROI data
	selectWindow("Final");
	close(); }  
selectWindow(img);
run("Select None");
run("Duplicate...", "duplicate");
rename("Final");
run("8-bit");
w=getWidth();                    
h=getHeight();
frames=nSlices();
if(cROI==false) {
run("ROI Manager...");        
selectWindow("ROI Manager");
run("Close");  }
else {
roiManager("Select", 0);	
Roi.getCoordinates(xp, yp);
leng=lengthOf(xp);
for(i=0; i<(leng*frames); i++) {
	roiManager("Select", frames);	
	roiManager("Delete"); }
}

pi=3.141592653589793;           //default setting

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
eq=true; radiusUM=radiusUM; radiusM=radiusM; subt=40; NORM=true; EMO=true; CC=true; RC=5;                     //treatment   
if(EIV==false) {
	sep1=8; sep2=0; esp1=14; esp2=15; ra=2; ra2=1;} else {
	sep1=-30; sep2=0; esp1=12; esp2=15; ra=0.5; ra2=0;}                                                               //sampling
	
MAX=80; MEAN=2; ESE=true; ESO=false; EAE=true; EAO=false;                                                   //evaluation
BM=false;


  if(MO==true) {
  Dialog.create("Fusion-Fision");      
  Dialog.addMessage("SAMPLING");
  Dialog.addNumber("Inner ROI adjustment (pixels):", sep1);     
  Dialog.addNumber("Inner ROI thick (pixels):", esp1); 
  Dialog.addNumber("Separation between inner and outer ROI (pixels):", sep2);    
  Dialog.addNumber("Outer ROI thick (pixels):", esp2);
  Dialog.addNumber("Outer ROI arc length (inner ROI proportion): ", ra);
  Dialog.addMessage("EVALUATION"); 
  Dialog.addNumber("Movement detection radius (pixels)", RC);
  Dialog.addCheckbox("Subtract successive events of the same kind", ESE);
  Dialog.addCheckbox("Subtract successive events of the opposite kind", ESO);
  Dialog.addCheckbox("Subtract adjacent events of the same kind", EAE);
  Dialog.addCheckbox("Subtract adjacent events of the opposite kind", EAO); 
   Dialog.show();                         
  sep1=Dialog.getNumber(); 
  esp1=Dialog.getNumber(); 
  sep2=Dialog.getNumber(); 
  esp2=Dialog.getNumber(); 
  ra=Dialog.getNumber();
  RC=Dialog.getNumber();
  ESE=Dialog.getCheckbox();
  ESO=Dialog.getCheckbox();
  EAE=Dialog.getCheckbox();
  EAO=Dialog.getCheckbox();     }

selectWindow("Final");
run("Select None");
if(eq==true) igualar(w, h, frames);                                          //treatments
if(radiusUM>0) run("Unsharp Mask...", "radius=radiusUM mask=0.99 stack");
if(radiusM>0) run("Mean...", "radius=radiusM stack");
if(subt>0) run("Subtract...", "value=subt stack");
if(NORM==true) normalizacion("Final");
if(cROI==false) {
run("Duplicate...", "duplicate");
rename("mainROIs");
selectWindow("mainROIs");
run("Mean...", "radius=8 stack");
for(f=1; f<frames+1; f++) {
	setSlice(f);
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			pp=getPixel(x,y);
			if(pp>3)
				setPixel(x, y, 255);
				else
				setPixel(x, y, 0);
			}
		}
	}
if(getPixel(w/2, h/2)==255) run("Invert", "stack");

dt=pi/frag;  cont2=0;
X=newArray(50); Y=newArray(50); 
selectWindow("mainROIs");

for(j=1; j<frames+1; j++)    //main ROIs
	{
	setSlice(j);
	t=0; CONT=0; previous=w/2;
	for(i=0; i<frag; i++)
		{
		run("Select None");
		cont=0;
		do
			{
			cont++;
			xc=round(cont*cos(t)+w/2);
			yc=round(cont*sin(t)+h/2);
			pValue=getPixel(xc, yc);
			}
		while(pValue==0)// && cont<previous+10) 
		previous=cont;
		X[CONT]=xc;	Y[CONT]=yc;
		t=t+2*dt;
		CONT++;
		}
	for(e=frag; e<50; e++) {  X[e]=xc; 	Y[e]=yc; }
	run("Select None");
	makePolygon(X[0], Y[0], X[1], Y[1], X[2], Y[2], X[3], Y[3], X[4], Y[4], X[5], Y[5], X[6], Y[6], X[7], Y[7], X[8], Y[8], X[9], Y[9], X[10], Y[10], X[11], Y[11], X[12], Y[12], X[13], Y[13], X[14], Y[14], X[15], Y[15], X[16], Y[16], X[17], Y[17], X[18], Y[18], X[19], Y[19], X[20], Y[20], X[21], Y[21], X[22], Y[22], X[23], Y[23], X[24], Y[24], X[25], Y[25], X[26], Y[26], X[27], Y[27], X[28], Y[28], X[29], Y[29], X[30], Y[30], X[31], Y[31], X[32], Y[32], X[33], Y[33], X[34], Y[34], X[35], Y[35], X[36], Y[36], X[37], Y[37], X[38], Y[38], X[39], Y[39], X[40], Y[40], X[41], Y[41], X[42], Y[42], X[43], Y[43], X[44], Y[44], X[45], Y[45], X[46], Y[46], X[47], Y[47], X[48], Y[48], X[49], Y[49]);
	roiManager("Add");
	roiManager("Select", cont2);
	roiManager("Rename", j);
	cont2++;
	}
}

if(EMO==true) mult("Final", CC, RC); 
v1=newArray(frag*frames+1); v2=newArray(frag*frames+1);  m1=newArray(frag*frames+1); m2=newArray(frag*frames+1); 
t=0; cont=0;  dt=pi/frag; cont2=frames; per=newArray(frames); area=newArray(frames);
selectWindow("Final");
run("Select None"); 
run("Set Measurements...", "area mean min perimeter redirect=None decimal=2");

for(j=0; j<frag; j++)
	{
	for(i=1; i<frames+1; i++)
		{
		setSlice(i);
		roiManager("Select", i-1);
		run("Measure"); 
		per[i-1]=getResult("Preim.", 0);
		area[i-1]=getResult("Area", 0);
		run("Clear Results");
		Roi.getCoordinates(xp, yp);
		run("Select None");
		xa=xp[j]+sep1*cos(t);  ya=yp[j]+sep1*sin(t);
		XB=xp[j]+(esp1+sep1)*cos(t); YB=yp[j]+(esp1+sep1)*sin(t);
		xb=xp[j+1]+sep1*cos(t+2*dt); yb=yp[j+1]+sep1*sin(t+2*dt);	
		XA=xp[j+1]+(esp1+sep1)*cos(t+2*dt); YA=yp[j+1]+(esp1+sep1)*sin(t+2*dt);
		if(j==frag-1) {
		xb=xp[0]+sep1*cos(t+2*dt); yb=yp[0]+sep1*sin(t+2*dt);	
		XA=xp[0]+(esp1+sep1)*cos(t+2*dt); YA=yp[0]+(esp1+sep1)*sin(t+2*dt); }
		makePolygon(xa, ya, xb, yb, XA, YA, XB, YB);
		run("Measure");
		roiManager("Add");
		roiManager("Select", cont2);
		roiManager("Rename", j+1+"-"+i+"-"+1);
		v1[cont]=getResult("Mean", 0);
		m1[cont]=getResult("Max", 0);
		run("Clear Results"); 	cont2++;
		if(sd==true) wait(5);
		run("Select None");
		xa=xp[j]+(esp1+sep1+sep2)*cos(t-ra*dt); ya=yp[j]+(esp1+sep1+sep2)*sin(t-ra*dt);
		XB=xp[j]+(esp1+sep1+sep2+esp2)*cos(t-ra2*dt); YB=yp[j]+(esp1+sep1+sep2+esp2)*sin(t-ra2*dt);
		xb=xp[j+1]+(esp1+sep1+sep2)*cos(t+2*ra*dt); yb=yp[j+1]+(esp1+sep1+sep2)*sin(t+2*ra*dt);	
		XA=xp[j+1]+(esp1+sep1+sep2+esp2)*cos(t+2*ra2*dt); YA=yp[j+1]+(esp1+sep1+sep2+esp2)*sin(t+2*ra2*dt);
		if(j==frag-1) {
		xb=xp[0]+(esp1+sep1+sep2)*cos(t+2*ra*dt); yb=yp[0]+(esp1+sep1+sep2)*sin(t+2*ra*dt);	
		XA=xp[0]+(esp1+sep1+sep2+esp2)*cos(t+2*ra2*dt); YA=yp[0]+(esp1+sep1+sep2+esp2)*sin(t+2*ra2*dt); }
		makePolygon(xa, ya, xb, yb, XA, YA, XB, YB); 
		run("Measure");
		roiManager("Add");
		roiManager("Select", cont2);
		roiManager("Rename", j+1+"-"+i+"-"+2);
		v2[cont]=getResult("Mean", 0);
		m2[cont]=getResult("Max", 0);
		run("Clear Results");  cont2++;
		if(sd==true) wait(5);
		run("Select None");
		cont++;
		}
	t=t+2*dt;
	}

sal=newArray(frag*frames);  ev=newArray(frames*frag);   TRUE=newArray(frag*frames);	 
for(i=0; i<frag*frames; i++) {ev[i]=false; sal[i]=0; }

if(EIV==false)
{
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
}
else
{
for(e=1; e<frag*frames-1; e++)   //evaluation loop
	{
	if(m2[e]>MAX && v2[e]>MEAN) 
		{
		ev[e]=true;
		if(m1[e-1]>MAX && m1[e+1]<MAX)
			{
			sal[e]=1; TRUE[e]=true; 
			}
			else 
			{
			if(m1[e+1]>MAX && m1[e-1]<MAX)
				{
				sal[e]=-1; TRUE[e]=true;
				}
				else 
				{
				TRUE[e]=false;	
				if(v1[e+1]<v1[e-1])
					sal[e]=1;
					else
					sal[e]=-1;
				}
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
mayor=0;
for(i=0; i<frames; i++) {
	if(area[i]>mayor)
		mayor=area[i]; }
run("Select None");

a=newArray(frames); for(i=0; i<frames; i++) a[i]=i;
Plot.create("Plot", "Frame", "Size"); 
Plot.setLimits(0, frames, 0, mayor);  
Plot.setColor("red", "red");           
Plot.add("line", a, area);
if(isOpen("mainROIs")) {
selectWindow("mainROIs");
close(); }
}