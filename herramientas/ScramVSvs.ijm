//experimente de igual desviacion estandar colo van stensel y sacrambling de objetos
macro "vs" {

function VECTORIZAR(imagenAvectorizar, an, al)                     
{
selectWindow(imagenAvectorizar);
vector=newArray(an*al);
  i = 0;
  for (y=0; y<al; y++)
	{
	for (x=0; x<an; x++)
		{
		vector[i] = getPixel(x,y);
		i++; 
		}
	}
return vector;
}

function UNOS(mascara, an, al)
{
selectWindow(mascara); 
unos=0;
for (y=0; y<al; y++)
	{
	for (x=0; x<an; x++)
		unos++;
	}
return unos;
}

function RECORTAR(canal, masc, an, al, unos)                   
{
vector=newArray(unos);
  j=0;
  for (i=0; i<an*al; i++)
	{
	if(masc[i]>0)
		{
		vector[j]=canal[i];
		j++;
		}
	}
return vector;
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
 
Dialog.create("Poner el mismo ROI en ambos canales");                                                       
Dialog.addChoice("Red:", figura);         
Dialog.addChoice("Green:", figura);          
Dialog.addNumber("n: ", 50);
Dialog.addNumber("W maximo: ", 100);
Dialog.addNumber("H maximo: ", 100);
Dialog.addNumber("Tolerancia: ", 0.2);
Dialog.show();
red=Dialog.getChoice();
green=Dialog.getChoice();
n=Dialog.getNumber(); 
mW=Dialog.getNumber();
mH=Dialog.getNumber();
tol=Dialog.getNumber();


setBatchMode(true);
selectWindow(red);
w=getWidth;
h=getHeight;
run("Set Measurements...", "mean redirect=None decimal=2");

MASK=newArray(w*h);
run("Create Mask");
unos=UNOS("Mask", w, h);
MASK=VECTORIZAR("Mask", w, h);

selectWindow(red);
run("Measure"); 
MEANr=getResult("Mean", 0);
run("Clear Results");
RED=VECTORIZAR(red, w, h);

selectWindow(green);
run("Measure"); 
MEANg=getResult("Mean", 0);
run("Clear Results");
GREEN=VECTORIZAR(green, w, h);

colos=newArray(n);
rojo=newArray(unos);
verde=newArray(unos);
rojo=RECORTAR(RED, MASK, w, h, unos);
verde=RECORTAR(GREEN, MASK, w, h, unos);
den1=0;
den2=0;
for(i=0; i<unos; i++)
	{
	den1=den1+rojo[i]*rojo[i];
	den2=den2+verde[i]*verde[i];
	}

selectWindow("Mask");
close();

for(i=0; i<n; i++)
	{
	rojo=newArray(unos);
	verde=newArray(unos);
	showStatus(i);
	selectWindow(red);
	do 
		{
		X=round(random*(w-mW));
	    Y=round(random*(h-mH));
	    Roi.move(X, Y);
		run("Measure"); 
		mean=getResult("Mean", 0);
		run("Clear Results");
		} while(mean<MEANr-tol || mean>MEANr+tol) 
	run("Create Mask");
	MASK=VECTORIZAR("Mask", w, h);
	rojo=RECORTAR(RED, MASK, w, h, unos);
	selectWindow("Mask");
	close();
	selectWindow(green);
	do 
		{
		X=round(random*(w-mW));
	    Y=round(random*(h-mH));
	    Roi.move(X, Y);
		run("Measure"); 
		mean=getResult("Mean", 0);
		run("Clear Results");
		} while(mean<MEANg-tol || mean>MEANg+tol) 
	run("Create Mask");
	MASK=VECTORIZAR("Mask", w, h);
	verde=RECORTAR(GREEN, MASK, w, h, unos);
	selectWindow("Mask");
	close();
    num=0;
    for(j=0; j<unos; j++)
		num=num+rojo[j]*verde[j];
	colos[i]=num/sqrt(den1*den2);
	}

media=0;
de=0;
for(i=0; i<n; i++)
	media=media+colos[i];

media=media/n;	

for(i=0; i<n; i++)
	de=de+(colos[i]-media)*(colos[i]-media);

de=sqrt(de/(n-1));
print("Media: "+media+"   Desviacion: "+de);
	
setBatchMode(false);

}