// funcion que genera esta aplicación da indicios de la dinámica de movimiento del fluoróforo de la misma forma que el MSD (mean square displacement) 
//siendo muy útil en casos donde es dificil de usar tracking por cuestiones técnicas
//voy usar la funcion de dispersar que va a ir como piña

function convo(img, fu, r, f) 
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
 		return v;
 		}
    
 cx= floor(w/2);
 cy= floor(h/2);
// r=11; 
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

selectWindow(img);
an = getWidth;               
al = getHeight;
AN=an+anP;
AL=al+alP;

H=newArray(anP*alP);
G=newArray(an*al);

H=PSF(r, e, f);

selectWindow(img);
run("Duplicate...", "title=img2 duplicate");
run("Canvas Size...", "width=AN height=AL position=Center zero");
frames=nSlices;

for(t=1; t<frames+1; t++)
{
selectWindow("img2");
setSlice(t);

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
			suma=suma+H[i]*getPixel(m+alP/2, n+anP/2)/255;
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
setSlice(t);
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
}}

function promedio(vec, tam) {
	prom=0; 
	for(i=0; i<tam; i++) 
		prom=prom+vec[i];
	return prom/tam; 	}


function umbralizar(um) {
selectWindow(st);
for(i=1; i<frames; i++)
	{
	setSlice(i);
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			pix=getPixel(x,y);
			if(pix<um)
				setPixel(x, y, 0); 
			}
		}
	updateDisplay();
	}
}


function normalizar(pi) {
selectWindow(st);
for(i=1; i<frames; i++)
	{
	setSlice(i);
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			pix=getPixel(x,y);
			setPixel(x, y, pix*pi/ipp[i]); 
			}
		}
	updateDisplay();
	}
selectWindow("img2");
close();
}

function igualar() {
selectWindow(st);

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
  Dialog.addChoice("Coeficiente: ", newArray("Pearson", "Overlap"));  
  Dialog.addCheckbox("Igualar", false);
  Dialog.addCheckbox("Normalizar", false);
  Dialog.addNumber("Intensidad promedio: ", 40);
  Dialog.addCheckbox("Restar", false);
  Dialog.addNumber("valor: ", 40);
  Dialog.addCheckbox("Umbralizar", false);
  Dialog.addNumber("Umbral: ", 25);
  Dialog.addCheckbox("Filtrar", false);
  Dialog.addNumber("Radio: ", 4);
  Dialog.addNumber("Peso: ", 0.90);
  Dialog.addCheckbox("Convolucionar", true);
  Dialog.addChoice("Funcion: ", newArray("Aritmetica", "Lineal", "Cuadratica", "Cubica", "Geometrica"));
  Dialog.addNumber("Radio: ", 12);
  Dialog.addChoice("Orden: ", newArray("inurfc", "inrufc", "inufrc"));  
  
    Dialog.show();
   	st=Dialog.getChoice();
   	mas=Dialog.getChoice();
   	coefi=Dialog.getChoice();
   	ig=Dialog.getCheckbox();
   	n=Dialog.getCheckbox();
   	pi=Dialog.getNumber();
   	r=Dialog.getCheckbox();
   	va=Dialog.getNumber();
   	u=Dialog.getCheckbox();
	um=Dialog.getNumber();
	f=Dialog.getCheckbox();
	rf=Dialog.getNumber();
	pf=Dialog.getNumber();
	c=Dialog.getCheckbox();
	fu=Dialog.getChoice();
	rc=Dialog.getNumber();
    o=Dialog.getChoice();
    
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

size=1/(w*h);
ipp=newArray(frames);
for(i=1; i<frames; i++)
	{
	setSlice(i);
	ipp[i]=0;
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			ipp[i]=ipp[i]+getPixel(x,y);
		}
	ipp[i]=ipp[i]*size;
	}


if(o=="inurfc") { 
if(ig==true) { igualar(); }  
if(n==true) { normalizar(pi); }
if(u==true) { umbralizar(um); }
if(r==true) { selectWindow(st); run("Subtract...", "value=va stack"); }
if(f==true) { selectWindow(st); run("Unsharp Mask...", "radius=rf mask=pf stack"); }
if(c==true) { convo(st, fu, rc, 1); }
//run("Convolve...", "text1=[0 0 4 6 7 7 7 6 4 0 0\n0 5 7 11 14 15 14 11 7 5 0\n4 7 13 20 28 31 28 20 13 7 4\n6 11 20 35 54 63 54 35 20 11 6\n7 14 28 54 95 127 95 54 28 14 7\n7 15 31 63 127 255 127 63 31 15 7\n7 14 28 54 95 127 95 54 28 14 7\n6 11 20 35 54 63 54 35 20 11 6\n4 7 13 20 28 31 28 20 13 7 4\n0 5 7 11 14 15 14 11 7 5 0\n0 0 4 6 7 7 7 6 4 0 0\n] normalize stack"); }
}
	
if(o=="inrufc") { 
if(ig==true) { igualar(); }  
if(n==true) { normalizar(pi); }
if(r==true) { selectWindow(st); run("Subtract...", "value=va stack"); }
if(u==true) { umbralizar(um); }
if(f==true) { selectWindow(st); run("Unsharp Mask...", "radius=rf mask=pf stack"); }
if(c==true) {  convo(st, fu, rc, 1); }
	//run("Convolve...", "text1=[0 0 4 6 7 7 7 6 4 0 0\n0 5 7 11 14 15 14 11 7 5 0\n4 7 13 20 28 31 28 20 13 7 4\n6 11 20 35 54 63 54 35 20 11 6\n7 14 28 54 95 127 95 54 28 14 7\n7 15 31 63 127 255 127 63 31 15 7\n7 14 28 54 95 127 95 54 28 14 7\n6 11 20 35 54 63 54 35 20 11 6\n4 7 13 20 28 31 28 20 13 7 4\n0 5 7 11 14 15 14 11 7 5 0\n0 0 4 6 7 7 7 6 4 0 0\n] normalize stack");}
}

if(o=="inufrc") { 
if(ig==true) { igualar(); }  
if(n==true) { normalizar(pi); }
if(u==true) { umbralizar(um); }
if(f==true) { selectWindow(st); run("Unsharp Mask...", "radius=rf mask=pf stack"); }
if(r==true) { selectWindow(st); run("Subtract...", "value=va stack"); }
if(c==true) { convo(st, fu, rc, 1); }
	//run("Convolve...", "text1=[0 0 4 6 7 7 7 6 4 0 0\n0 5 7 11 14 15 14 11 7 5 0\n4 7 13 20 28 31 28 20 13 7 4\n6 11 20 35 54 63 54 35 20 11 6\n7 14 28 54 95 127 95 54 28 14 7\n7 15 31 63 127 255 127 63 31 15 7\n7 14 28 54 95 127 95 54 28 14 7\n6 11 20 35 54 63 54 35 20 11 6\n4 7 13 20 28 31 28 20 13 7 4\n0 5 7 11 14 15 14 11 7 5 0\n0 0 4 6 7 7 7 6 4 0 0\n] normalize stack");}
}

setSlice(1);
C1=vectorizar(st, w, h, vmas, unos);
denC1=0;

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
	Plot.setLimits(0, frames-1, -1, 1);
	Plot.setColor("black", "black");           
    Plot.setLineWidth(1);
    Plot.add("line", a, colo);
    //Plot.makeHighResolution("Plot",3.0,"disable");
   
