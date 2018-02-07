macro "Detector de movimiento [d]" { 
function it(img, um, uM, vm) {
selectWindow(img);
frames=nSlices;
h=getHeight;
w=getWidth;
for(i=1; i<frames+1; i++)
	 {
	 setSlice(i);
	 for(y=0; y<h; y++)
	 	{	
		for(x=0; x<w; x++)
			{
			p=getPixel(x,y);
			if(p>uM)
				setPixel(x, y, 255);
				else
				{
				if(p>um && p<uM)
					setPixel(x, y, vm);
					else
					setPixel(x, y, 1);
				}
	 	  } 
	 }
}
}
function mult(img, cond, valor, w, h, frames, UM, coeficiente) {

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
	 			setPixel(x, y, valor);
	 			else
	 			setPixel(x, y, 1);
	 			} else {
	 	setPixel(x, y, coeficiente*p2[j]/p1[j]+1); }
   	    j++;
   	    }
	}
}
selectWindow("multiplicador");
setSlice(1);
run("Add...", "value=1 slice");
return "multiplicador";
}

id1=getImageID();          
tamano=0;
figura=newArray(nImages);
for(i=id1-10000; i<id1+10000; i++)
	{
	if(isOpen(i) && tamano<nImages)
		{
		selectImage(i);
		figura[tamano]=getTitle();
		tamano++;
		}		
	}


Dialog.create("Coso q detecta movimiento");                                                       
 
  Dialog.addChoice("Movimiento", figura);  
  Dialog.addNumber("Maximo de entrada:", 16);  
  Dialog.addCheckbox("Directo", true);
  Dialog.addNumber("Coeficeinte:", 2);  
  Dialog.addCheckbox("Directo constante", false);
  Dialog.addNumber("Valor de directo constante:", 3);  
  Dialog.addCheckbox("Inverso", false);
  Dialog.addNumber("Coeficeinte:", 1);  
  Dialog.addCheckbox("Inverso constante", false);
  Dialog.addNumber("Valor de inverso constante:", 3);     
  Dialog.addNumber("Umbral multiplicador constante:", 3);    
  Dialog.addCheckbox("Ternarizar", false);
  Dialog.addNumber("Umbral medio:", 20);  
  Dialog.addNumber("Umbral maximo:", 120);
  Dialog.addNumber("Valor medio:", 30);
  
       Dialog.show();
   	img=Dialog.getChoice();
   	MAX=Dialog.getNumber();
  D=Dialog.getCheckbox();
  coefD=Dialog.getNumber();
  DC=Dialog.getCheckbox();
  VDC=Dialog.getNumber();  
  I=Dialog.getCheckbox();
 coefI=Dialog.getNumber();
  IC=Dialog.getCheckbox();
  VIC=Dialog.getNumber(); 
  UM=Dialog.getNumber(); 
  IT=Dialog.getCheckbox();
  um=Dialog.getNumber();  
  uM=Dialog.getNumber();
  vm=Dialog.getNumber();

selectWindow(img);
w=getWidth;
h=getHeight;
frames=nSlices;
setBatchMode(true);
run("Set Measurements...", "mean min redirect=None decimal=2");
selectWindow(img);
run("Select None");
run("Measure");
max=getResult("Max", 0);
min=getResult("Min", 0);
//run("Clear Results"); 	                                       
  	
selectWindow(img);
for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	for(y=0; y<h; y++)
   	 {
	 for(x=0; x<w; x++)
	 	{
	 	p=getPixel(x, y);
	 	setPixel(x, y, round(((p-min)*MAX)/(max-min))+1);
	 	}	
	  }
	}

if(D==true) 
	{
	imgMD=mult(img, DC, VDC, w, h, frames, UM, coefD);
	selectWindow(imgMD);
	rename("MultDirecto");
	}
if(I==true) 
	{
	selectWindow(img);
	run("Reverse");
	imgMI=mult(img, IC, VIC, w, h, frames, UM, coefI);	
	selectWindow(imgMI);
	rename("MultInverso");
	selectWindow(img);
	run("Reverse");
	}
	
if(D==true)
	imageCalculator("Multiply stack", img,"MultDirecto");

if(I==true)
	{
	selectWindow(img);
	run("Reverse");	
	imageCalculator("Multiply stack", img,"MultInverso");
	selectWindow(img);
	run("Reverse");
	selectWindow("MultInverso");
	run("Reverse");
	}

if(IT==true)
	{
	selectWindow(img);
	it(img, um, uM, vm);
	}

setBatchMode("exit and display");
}	