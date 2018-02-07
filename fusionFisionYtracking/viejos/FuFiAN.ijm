
macro "FuFi [f]" {

function poligono(fA, fA2, sepin, sepex, CX, CY, t, dt, ow, oh, j, pot) {
xa=pow(fA2, pot)*(ow/2)*cos(t+sepin*dt)+CX[j];
ya=pow(fA2, pot)*(oh/2)*sin(t+sepin*dt)+CY[j];
xb=pow(fA2, pot)*(ow/2)*cos(t+dt)+CX[j];
yb=pow(fA2, pot)*(oh/2)*sin(t+dt)+CY[j];
xc=pow(fA2, pot)*(ow/2)*cos(t+(2-sepin)*dt)+CX[j];
yc=pow(fA2, pot)*(oh/2)*sin(t+(2-sepin)*dt)+CY[j];
XA=pow(fA2, pot)*fA*(ow/2)*cos(t+sepex*dt)+CX[j];
YA=pow(fA2, pot)*fA*(oh/2)*sin(t+sepex*dt)+CY[j];
XB=pow(fA2, pot)*fA*(ow/2)*cos(t+dt)+CX[j];
YB=pow(fA2, pot)*fA*(oh/2)*sin(t+dt)+CY[j];
XC=pow(fA2, pot)*fA*(ow/2)*cos(t+(2-sepex)*dt)+CX[j];
YC=pow(fA2, pot)*fA*(oh/2)*sin(t+(2-sepex)*dt)+CY[j];
makePolygon(xa,ya,xb,yb,xc,yc,XC,YC,XB,YB,XA,YA);
}

function igualar(w, h, frames) {
selectWindow("Final");
size=1/(w*h);
ipp=newArray(frames);
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
}

function umbral(w, h, frames, umb) {
selectWindow("Final");
for(i=1; i<frames; i++)
	{
	setSlice(i);
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			pix=getPixel(x,y);
			if(pix<umb)
				setPixel(x, y, 0); 
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

Dialog.create("Fusion-Fision");                                                          
 Dialog.addChoice("Load stack:", figura); 
  Dialog.addCheckbox("Cell drift", true); 
    //Dialog.addNumber("Origin: ", 0);
  Dialog.addCheckbox("Equalization", true); 
  Dialog.addCheckbox("Thresholding", true); 
  Dialog.addNumber("Threshold: ", 0);  
  Dialog.addCheckbox("Unsharp Mask", true); 
  Dialog.addNumber("radius: ", 4);
  Dialog.addNumber("mask weight (0-1): ", 0.8);
  Dialog.addNumber("Step delay: ", 0);
  Dialog.addCheckbox("More optioons", true);  //fragmentacion y demás y opciones de drift
 Dialog.show();

                                               
  img=Dialog.getChoice(); 
  drift=Dialog.getCheckbox(); 
    //Dialog.addNumber("Origin: ", 0);
  eq=Dialog.getCheckbox(); 
  Thresholding=Dialog.getCheckbox(); 
  threshold=Dialog.getNumber();  
  um=Dialog.getCheckbox(); 
  radius=Dialog.getNumber();
  mw=Dialog.getNumber();
  sd=Dialog.getNumber();
  mo=Dialog.getCheckbox();  //fragmentacion y demás y opciones de drift

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

pi=3.141592653589793; 
frag=24;                      //fragmentación de anillos. 
dt=pi/frag;                //intervalo
fA=1.10;                     //espesor de anillo
fA2=1.06;                  //separacion entre anillos internos y externo
sepin=0;               //separacion entre segmentos de anillo interno
sepex=0;               //separación entre vertices externos del anillo externo
t=0;

if(eq==true) igualar(w, h, frames);
if(Thresholding==true) umbral(w, h, frames, threshold);
if(um==true) run("Unsharp Mask...", "radius=radius mask=mw stack");

CX=newArray(frames+1);
CY=newArray(frames+1);
if(drift==true)
{
selectWindow("Final");                 
run("Select None");
run("Duplicate...", "title=Nodo duplicate");
run("Unsharp Mask...", "radius=12 mask=0.99 stack");
setAutoThreshold("Minimum dark");
setOption("BlackBackground", false);
run("Convert to Mask", "method=Minimum background=Dark calculate");
ZZ=1.15;
makeOval(cx-ZZ*ow/2, cy-ZZ*oh/2, ZZ*ow, ZZ*oh);
run("Make Inverse");
setForegroundColor(0, 0, 0);
for(i=1; i<frames; i++)
	{
	setSlice(i);
	run("Fill", "slice");
	}
run("Select None");
run("Median...", "radius=1 stack");
run("Invert", "stack");
//run("Close-", "stack");
run("Fill Holes", "stack");
run("Watershed", "stack");
run("Invert", "stack");
run("Set Measurements...", "centroid redirect=None decimal=2");
for(i=1; i<frames; i++)
	{
	setSlice(i);
	//doWand(CX[i-1], CY[i-1]);
	doWand(cx, cy);
	run("Measure");
	CX[i]=getResult("X", i-1);
	CX[i]=round(CX[i]);
	CY[i]=getResult("Y", i-1);
	CY[i]=round(CY[i]);
	//wait(60);
	}
selectWindow("Nodo");
//close();
run("Clear Results");
}
else
{
for(i=1; i<frames; i++)
	{
	CX[i]=cx;
	CY[i]=cy;
	}
}
v1=newArray(frag*frames);
v2=newArray(frag*frames);
v3=newArray(frag*frames);
v4=newArray(frag*frames);
v5=newArray(frag*frames);
cont=0;
run("Set Measurements...", "mean redirect=None decimal=2");
selectWindow("Final");
for(i=1; i<frag+1; i++)     // lazo principal
	{
	run("Select None");
	for(j=1; j<frames+1; j++)   //lazo de cuadrante interno
		{
		setSlice(j);
		run("Select None");
		poligono(fA, fA2, sepin, sepex, CX, CY, t, dt, ow, oh, j, 0);
		if(j==1)
			roiManager("Add");
		run("Measure");   
		v1[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); 	wait(sd); 	run("Select None");
		poligono(fA, fA2, sepin, sepex, CX, CY, t, dt, ow, oh, j, 1);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v2[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); run("Select None");
		poligono(fA, fA2, sepin, sepex, CX, CY, t, dt, ow, oh, j, 2);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v3[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); run("Select None");
		poligono(fA, fA2, sepin, sepex, CX, CY, t, dt, ow, oh, j, 3);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v4[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); run("Select None");
		poligono(fA, fA2, sepin, sepex, CX, CY,  t, dt, ow, oh, j, 4);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v5[cont]=getResult("Mean", 0)/255;
		run("Clear Results");  	wait(sd);
			
		cont++;
	}	
	t=t+2*dt;
}

c=1;

titulo1 = "Results";                                            
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if (isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");

print(f, "\\Headings: n1\t n2\t n3\t n4\t n5");

for(r=0; r<frag*frames-1; r++) {
		if(r%frames==0) {
			//print("--------------"+((r/frames)+1)+"--------------");
			pv1=0; 	pv2=0; 	pv3=0; pv4=0; pv5=0;
			for(i=r; i<r+frames; i++) {
				pv1=pv1+v1[i]; 	pv2=pv2+v2[i]; 	pv3=pv3+v3[i]; pv4=pv4+v4[i]; 	pv5=pv5+v5[i];   }
			pv1=pv1/frames;	pv2=pv2/frames; pv3=pv3/frames;	pv4=pv4/frames; pv5=pv5/frames;	
		//print(pvi+"       "+pvm+"      "+pve);	
		if(pv1==0){pv1=1;}
		if(pv2==0){pv2=1;}
		if(pv3==0){pv3=1;}
		if(pv4==0){pv4=1;}
		if(pv5==0){pv5=1;}
		c++;
		}	
		else {	
		//print(f, pvi+"\t    "+pvm+"\t    "+pve);
		/*en1=(vi[r]/pvi)-(vi[r-1]/pvi);
		en2=(vm[r]/pvm)-(vm[r-1]/pvm);
		en3=(ve[r-1]/pve)-(ve[r]/pve);*/
		/*en5=(v5[r]/pv5-v5[r-1]/pv5);//+(v5[r-1]/pv5-v5[r]/pv5)+(v5[r]/pv5-v5[r+1]/pv5);
		en4=(v4[r]/pv4-v4[r-1]/pv4);//+(v4[r-1]/pv4-v4[r]/pv4)+(v5[r]/pv4-v4[r+1]/pv4);
		en3=(v3[r]/pv3-v3[r-1]/pv3);//+(v3[r-1]/pv3-v3[r]/pv3)+(v3[r]/pv3-v3[r+1]/pv3);
		en2=(v2[r]/pv2-v2[r-1]/pv2);//+(v2[r-1]/pv2-v2[r]/pv2)+(v2[r]/pv2-v2[r+1]/pv2);
		en1=(v1[r]/pv1-v1[r-1]/pv1);//+(v1[r-1]/pv1-v1[r]/pv1)+(v1[r]/pv1-v1[r+1]/pv1);*/
		en5=(v5[r]-v5[r-1]);//+(v5[r-1]/pv5-v5[r]/pv5)+(v5[r]/pv5-v5[r+1]/pv5);
		en4=(v4[r]-v4[r-1]);//+(v4[r-1]/pv4-v4[r]/pv4)+(v5[r]/pv4-v4[r+1]/pv4);
		en3=(v3[r]-v3[r-1]);//+(v3[r-1]/pv3-v3[r]/pv3)+(v3[r]/pv3-v3[r+1]/pv3);
		en2=(v2[r]-v2[r-1]);//+(v2[r-1]/pv2-v2[r]/pv2)+(v2[r]/pv2-v2[r+1]/pv2);
		en1=(v1[r]-v1[r-1]);//+(v1[r-1]/pv1-v1[r]/pv1)+(v1[r]/pv1-v1[r+1]/pv1);
		//en3=(ve[r-1])-(ve[r]);
		//en4=(vi[r]/pve)-(ve[r]/pve);
		/*pelo=newArray(en1, en2, en3, en4, en5);
		cond1=false; cond2=false; cond=false;
		for(uu=0; uu<5; uu++) {
			if(pelo[uu]>0.18) cond1=true;
			if(pelo[uu]<-0.18) cond2=true; }
		if(cond1==true || cond2==true) cond=true;
		if(cond==true) {*/
			print(f, floor((r/frames)+1)+"\t  "+c);//+"\t  "+"-------"); //+"\t  "+"-------");
			print(f, en1+"\t    "+en2+"\t    "+en3+"\t    "+en4+"\t    "+en5); //}
 	if(c>frames-1) 
 		c=1;
 		else
 		c++;
 	}}

}

/*
wNo1=newArray(2,4,5,,76,,);

wNs1=newArray(
wNs2=newArray(

for(e=0; e<frames*frag; e++)
	{
	sNo1=sigmoide(wNo1[0]*e1[e]+wNo1[1]*e2[e]+wNo1[2]*e3[e]+wNo1[3]*e4[e]+wNo1[4]*e5[e]);
	sNo2=sigmoide(wNo2[0]*e1[e]+wNo2[1]*e2[e]+wNo2[2]*e3[e]+wNo2[3]*e4[e]+wNo2[4]*e5[e]);
	sNo3=sigmoide(wNo3[0]*e1[e]+wNo3[1]*e2[e]+wNo3[2]*e3[e]+wNo3[3]*e4[e]+wNo3[4]*e5[e]);
	sNo4=sigmoide(wNo4[0]*e1[e]+wNo4[1]*e2[e]+wNo4[2]*e3[e]+wNo4[3]*e4[e]+wNo4[4]*e5[e]);
	sNo5=sigmoide(wNo5[0]*e1[e]+wNo5[1]*e2[e]+wNo5[2]*e3[e]+wNo5[3]*e4[e]+wNo5[4]*e5[e]);
	sNo6=sigmoide(wNo6[0]*e1[e]+wNo6[1]*e2[e]+wNo6[2]*e3[e]+wNo6[3]*e4[e]+wNo6[4]*e5[e]);
	sNs1[e]=sigmoide(sNo1*wNs1[0]+sNo2*wNs1[1]+sNo3*wNs1[2]+sNo4*wNs1[3]+sNo5*wNs1[4]+sNo6*wNs1[5]);
	sNs2[e]=sigmoide(sNo1*wNs2[0]+sNo2*wNs2[1]+sNo3*wNs2[2]+sNo4*wNs2[3]+sNo5*wNs2[4]+sNo6*wNs2[5]);

	if(sNs1[e]>0.5 || sNs1[e]>0.5) {
		if(sNs1[e]>0.5 && sNs1[e]<0.5) {
			ev[e]="fU";}
			else {
			if(sNs1[e]<0.5 && sNs1[e]>0.5) {
				ev[e]="fI"; }
				else {
				ev[e]="NC"; }}
	if(frame>frames-1) frame=1; else frame++;
print(f, floor(e/frames)+1,  frame, ev[e], (v2[e]+v3[e]+v4[e]+v5[e])*255/4
				
				}
			else {ev[e]="n" }	
}
for(i=0; i<frag; i++)
	{
	fusiones=0;
	for(j=i*frames; j<i*frames+frames; j++)
		{
		if(ev[j]=fU; fusiones ++;		
		}
	print(
	}
*/