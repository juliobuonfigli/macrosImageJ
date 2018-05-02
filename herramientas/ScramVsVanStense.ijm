//experimente de igual desviacion estandar colo van stensel y scrambling de objetos

macro "ST" {

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
/*
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
 
Dialog.create("ratatin ratatiti ban ban");                                                       
Dialog.addChoice("Stack 1:", figura);         
Dialog.addChoice("Stack 2:", figura);          
Dialog.addNumber("n: ", 50);
Dialog.show();
st1=Dialog.getChoice();
st2=Dialog.getChoice();
n=Dialog.getNumber(); */

selectWindow(st1);
n1=nSlices();
w=getWidth;
h=getHeight;
n=50;

colos=newArray(n);
setBatchMode(true);
a=newArray(w*h);
b=newArray(w*h);
a=VECTORIZAR(st1, w, h);
b=VECTORIZAR(st2, w, h);
den1=0;
den2=0;
for(i=0; i<w*h; i++)
	{
	den1=den1+a[i]*a[i];
	den2=den2+b[i]*b[i];
	}

for(i=0; i<n; i++)
	{
	a=newArray(w*h);
	b=newArray(w*h);
	selectWindow(st1);
	setSlice(round(random*(n1-1)+1));
	a=VECTORIZAR(st1, w, h);
	selectWindow(st2);
	//setSlice(1);
	setSlice(round(random*(n1-1)+1));
	b=VECTORIZAR(st2, w, h);
	num=0;
	for(j=0; j<w*h; j++)
		num=num+a[j]*b[j];
	colos[i]=num/sqrt(den1*den2);
	}

setBatchMode(false);
media=0;
de=0;
for(i=0; i<n; i++)
	media=media+colos[i];

media=media/n;	

for(i=0; i<n; i++)
	de=de+(colos[i]-media)*(colos[i]-media);

de=sqrt(de/(n-1));
print("Media: "+media+"   Desviacion: "+de);

}


  