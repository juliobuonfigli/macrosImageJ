//coeficientes de manders e interseccion TCSS threshold 
//Manders_2 solo considera el umbral de un canal y suma el otro

function TCSS_threshold(vector, unos)
{
umbral=255;
do { 
	showStatus("Thresholding...");
	umbral--;
	sR=0;
	for(i=0; i<unos; i++) 
		{
		if(vector[i]>=umbral)
			sR++;  
		}
	} while(sR<unos*0.48 && umbral>=1)
if(sR>unos*0.52){
do {
   showStatus("Thresholding...");
   umbral++;
   sR=0;
   for(i=0; i<unos; i++)
	   {
		if(vector[i]>=umbral)
			sR++;  
		}
	} while(sR>unos*0.52)
}
return umbral;
}


function convo(array, an, al, fu, r, f) 
{
if(fu=="Lineal") {e=1;}
if(fu=="Cuadratica") {e=2;}
if(fu=="Cubica") {e=3;}
if(fu=="Geometrica") {e=4;}
if(fu=="Aritmetica") {e=5;}

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
 			v=255-255*f*(d+1)/r;
 		if(v<0) v=0;
 		return v;
 		}
    
 cx= floor(w/2);
 cy= floor(h/2);
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
          
alP=2*r-1;
anP=2*r-1;
AN=an+anP;
AL=al+alP;

H=newArray(anP*alP);
G=newArray(an*al);
R=newArray(AN*AL);

i=0; j=0;
for(y=0; y<AL; y++) {
	for(x=0; x<AN; x++) {
		if(x<anP/2 || x>an+anP/2 || y<alP/2 || y>al+alP/2) {
			R[i]=0; i++; }
			else {
			R[i]=array[j]; i++; j++; } 
		}
	}

H=PSF(r, e, f);

N=0;
M=0;
j=0;
for(k=0; k<al*an; k++)
	{
	showStatus("Dispersing...");
	suma=0;
	i=0;
	for(n=N; n<N+alP; n++)
		{
		for(m=M; m<M+anP; m++)
			{
			pos=AN*n+m;
			suma=suma+H[i]*R[pos]/255;
			i++;
			}
		}
	M++;
	if(M>an-1)
		{M=0; N++;}
	G[j]=suma;
	j++;
	}
return G;
}

function renderizar(vector, w, h) {
 i=0;
 for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		setPixel(x, y, vector[i]);
		i++;
		}
	}
}

function promedio(vec, tam) {
	prom=0; 
	for(i=0; i<tam; i++) 
		prom=prom+vec[i];
	return prom/tam; 	}

function vectorizar(imagenAvectorizar, an, al, mask, unos)    // entran: imagen, w y h, el vector mascara y el umbral de senal                    
{
selectWindow(imagenAvectorizar);
vector=newArray(unos);
  i = 0;
  j=0;
  for (y=0; y<al; y++)
	{
	for (x=0; x<an; x++)
		{
		if(mask[i]==255) 
			{
			vector[j] = getPixel(x,y);
			j++;
			}
		i++;
		}
	}
return vector;
}


function VECTORIZAR(imagenAvectorizar, w, h)     //1: funcion para vectorizar imagenes                    
{
selectWindow(imagenAvectorizar);
vector=newArray(w*h);
  i = 0;
  for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		vector[i] = getPixel(x,y);
		i++;
		}
	}
return vector;
}

function contarUnos(ventana)                     
{
selectWindow(ventana);       
   a = newArray(w*h);
   i = 0;
   sumador=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		a[i] = getPixel(x,y);
		if(a[i]==255)
			sumador++;
		i++;
		}
	}
return sumador;
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
    
  Dialog.create("Correlation Tracking");                                                       
  Dialog.addChoice("Stack: ", figura);         
  Dialog.addChoice("Mascara: ", figura);          
  Dialog.addChoice("Coeficiente: ", newArray( "Pearson", "Intersection", "Manders", "Manders_2", "Overlap"));  
  Dialog.addCheckbox("Convolucionar", true);
  Dialog.addChoice("Funcion: ", newArray("Aritmetica", "Lineal", "Cuadratica", "Cubica", "Geometrica"));
  Dialog.addNumber("Radio: ", 5);
    
    Dialog.show();
   	st=Dialog.getChoice();
   	mas=Dialog.getChoice();
   	coefi=Dialog.getChoice();
    c=Dialog.getCheckbox();
	fu=Dialog.getChoice();
	rc=Dialog.getNumber();
 
    
selectWindow(mas);
w = getWidth;               
h = getHeight;
vmas= VECTORIZAR(mas, w, h);
unos=contarUnos(mas);

selectWindow(st);
run("8-bit");
frames=nSlices+1;
C1=newArray(w*h);
C2=newArray(w*h);
colo=newArray(frames);
denC1=0;
//run("Duplicate...", "title=Original duplicate");

if(c==true) { 
	for(i=1; i<frames; i++)
	{
	setSlice(i);
	vec=VECTORIZAR(st, w, h);
	vec2=convo(vec, w, h, fu, rc, 1); 
	renderizar(vec2, w, h);
	} }

setSlice(1);
C1=vectorizar(st, w, h, vmas, unos);
denC1=0;

if(coefi=="Intersection") {
umb=TCSS_threshold(C1, w*h);
unosC1=0;
for(i=0; i<w*h; i++){
	if(C1[i]>=umb)
		unosC1++;  }

for(e=1; e<frames; e++)
	{
	setSlice(e);
	int=0;
	C2=vectorizar(st, w, h, vmas, unos);
	for(i=0; i<w*h; i++){
		if(C1[i]>=umb && C2[i]>=umb)
			int++; }
	colo[e-1]=int/unosC1;                             
	}			 
}

if(coefi=="Manders" || coefi=="Manders_2") {
umb=TCSS_threshold(C1, w*h);
sumC1=0;
for(i=0; i<w*h; i++){
	if(C1[i]>=umb)
		sumC1=sumC1+C1[i];  }

if(coefi=="Manders") {
for(e=1; e<frames; e++)
	{
	setSlice(e);
	man=0;
	C2=vectorizar(st, w, h, vmas, unos);
	for(i=0; i<w*h; i++){
		if(C1[i]>=umb && C2[i]>=umb)
			man=man+C1[i]; }
	colo[e-1]=man/sumC1;                             
	}			 
}	
if(coefi=="Manders_2") {
for(e=1; e<frames; e++)
	{
	setSlice(e);
	man=0;
	C2=vectorizar(st, w, h, vmas, unos);
	for(i=0; i<w*h; i++){
		if(C2[i]>=umb)
			man=man+C1[i]; }
	colo[e-1]=man/sumC1;                             
	}			 
}}	



 
if(coefi=="Overlap") {
for(i=0; i<unos; i++)
	denC1=denC1+C1[i]*C1[i];
for(e=1; e<frames; e++)
	{
	setSlice(e);
	C2=vectorizar(st, w, h, vmas, unos);
  	num=0;
	denC2=0;
	
	for(i=0; i<unos; i++)                                              
		{                                                                                     
		denC2=denC2+C2[i]*C2[i];
		num=num+C1[i]*C2[i];
		}
	colo[e-1]=num/sqrt(denC1*denC2);                             
	}
}

if(coefi=="Pearson") {
pr1=promedio(C1, unos);
for(i=0; i<unos; i++)
	denC1=denC1+(C1[i]-pr1)*(C1[i]-pr1);

for(e=1; e<frames; e++)
	{
	setSlice(e);
	C2=vectorizar(st, w, h, vmas, unos);
  	pr2=promedio(C2, unos);
  	num=0;
	denC2=0;
	for(i=0; i<unos; i++)                                              
		{                                                                                     
		denC2=denC2+(C2[i]-pr2)*(C2[i]-pr2);
		num=num+(C1[i]-pr1)*(C2[i]-pr2);
		}
	colo[e-1]=num/sqrt(denC1*denC2);                             
	}
}

 	a=newArray(frames);
	for(f=0; f<frames; f++)     
		a[f]=f+1;

//Plot.show("Plot"); 
//selectWindow("Plot");
Plot.create("Plot", "Frame", "correlacion"); 
	if(coefi=="Pearson") Plot.setLimits(0, frames-1, -1, 1);
	else Plot.setLimits(0, frames-1, 0, 1);
	Plot.setColor("black", "black");           
    Plot.setLineWidth(1);
    Plot.add("line", a, colo);
    //Plot.makeHighResolution("Plot",3.0,"disable");
//   print(umb+"    "+unosC1);

if(coefi=="Intersection") {
selectWindow(st);
run("Duplicate...", "duplicate");
rename("Binarizada");
selectWindow("Binarizada");
	for(e=1; e<frames; e++)
	{
	setSlice(e);
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			pix=getPixel(x, y);
			if(pix>=umb)
				setPixel(x, y, 255);
				else
				setPixel(x, y, 0);
			}
		}
	}
}


