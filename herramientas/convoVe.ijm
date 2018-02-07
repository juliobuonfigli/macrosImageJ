//le trabaja con vector en vez de imagen y le agregue modificaciones de frontera

macro "ConvolutionStack [c]" 
{

function modFrontera(img, r) {
 selectWindow(img);
 for (y=0; y<al; y++)
	{
	for (x=0; x<an; x++)
		{
		coef1=1; coef2=1;
		if(x>an-r)
			coef1=2-(an-x)/r;
		if(x<r-1)
			coef1=2-(x+1)/r;
		if(y<r-1)
			coef2=2-(y+1)/r;
		if(y>al-r)
			coef2=2-(al-y)/r;
		coef=coef1*coef2;
		setPixel(x, y, getPixel(x, y)*coef);
		i++;
		}
	}
}
function PSF(r, e, f)
	{
 	w=2*r-1;
 	h=2*r-1;
 	vec=newArray(w*h);
 	function func(r, d, e, f) 
 		{
 		if(e==1)
 			v=255/(d+1);
 		if(e==2)
 			v=255/(d*d+1);
 		if(e==3)
 			v=255/(d*d*d+1);
 		if(e==4)
 			v=255/pow(2, d);
 		if(e==5)
 			v=255-255*f*(d)/r;
 		return v;
 		}
    
 cx= floor(w/2);
 cy= floor(h/2);
 //r=11; 
 v=0;
 cont=0;
 for (y = 0; y < h; y++) {
    for (x = 0; x < w; x++) {
       d = sqrt(pow(cx - x, 2) + pow(cy - y, 2));
		if (d >= r) 
        	v=0;
    	else 
        	v=func(r, d, e, f);       
       	vec[cont]=v;
       	cont++;
    }
}
return vec;
}

function VECTORIZAR(imagenAvectorizar, an, al)     //1: funcion para vectorizar imagenes                    
{
selectWindow(imagenAvectorizar);
vector=newArray(an*al);
  i = 0;
  for (y=0; y<al; y++)
	{
	for (x=0; x<an; x++)
		{
		vector[i] =getPixel(x,y);
		i++;
		}
	}
return vector;
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
	
Dialog.create("Convolucion");                                                       
  Dialog.addChoice("f:", figura);         
  Dialog.addChoice("f:", newArray("Aritmetica", "Cuadratica", "Cubica", "Geometrica", "Lineal")); 
  Dialog.addNumber("Radio: ", 8);          
  Dialog.addNumber("Factor: ", 1); 
  Dialog.addCheckbox("Intensificar frontera", false);
 
       Dialog.show();
 	img=Dialog.getChoice();
   	fu=Dialog.getChoice();
    r=Dialog.getNumber();
   	f=Dialog.getNumber(); 
	MF=Dialog.getCheckbox();


if(fu=="Lineal") {e=1;}
if(fu=="Cuadratica") {e=2;}
if(fu=="Cubica") {e=3;}
if(fu=="Geometrica") {e=4;}
if(fu=="Aritmetica") {e=5;}

alP=2*r-1;
anP=2*r-1;

selectWindow(img);
an = getWidth;               
al = getHeight;
AN=an+anP;
AL=al+alP;
selectWindow(img);
run("Duplicate...", "title=Green");

if(MF==true) modFrontera(img, r);

H=newArray(anP*alP);
G=newArray(an*al);

H=PSF(r, e, f);

selectWindow(img);
run("Duplicate...", "title=img2");
run("Canvas Size...", "width=AN height=AL position=Center zero");
tota=newArray(AN*AL);
tota=VECTORIZAR("img2", AN, AL);

N=0;
M=0;
j=0;
for(k=0; k<al*an; k++)
	{
	suma=0;
	i=0;
	for(n=N; n<N+alP; n++)
		{
		for(m=M; m<M+anP; m++)
			{
			pos=AN*n+m;
			suma=suma+H[i]*tota[pos]/255;
			i++;
			}
		}
	M++;
	if(M>an-1)
		{M=0; N++;}
	G[j]=suma;
	j++;
	}

selectWindow(img);
i=0;
for (y=0; y<al; y++)
	{
	for (x=0; x<an; x++)
		{
		setPixel(x, y, G[i]);
		i++;
		}
	}                
updateDisplay();


selectWindow("Green");
close();
selectWindow("img2");
close(); }
