
Dialog.create("Vesiculas");                                                       
 
  Dialog.addChoice("Movimiento", newArray("Browniano", "Confinado", "Direccionado_aleatorio", "Direccion_unica"));  
  Dialog.addNumber("Numero de objetos: ", 50000); 
  Dialog.addNumber("Paso: ", 1); 
  Dialog.addNumber("Cortes: ", 1); 
  Dialog.addNumber("Alto: ", 300); 
  Dialog.addNumber("Ancho: ", 300); 
  Dialog.addNumber("Valor de Pixel: ", 255);
  Dialog.addCheckbox("Agrandar Objetos", false); 
  Dialog.addNumber("Radio: ", 2); 

       Dialog.show();
   	movement=Dialog.getChoice();
   	n=Dialog.getNumber();
   	step=Dialog.getNumber();
    FRAMES=Dialog.getNumber();
   	H=Dialog.getNumber();
   	W=Dialog.getNumber();
   	vp=Dialog.getNumber();
   	ao=Dialog.getCheckbox();
   	radio=Dialog.getNumber();

newImage(movement, "8-bit black", W, W, FRAMES);

w=getWidth;
h=getHeight;
frames=nSlices;

function pa(w, h, n) {
v=newArray(n);
vv=newArray(w*h);
for(i=0; i<w*h; i++)
	vv[i]=false;
for(i=0; i<n; i++) {
	p=round(random*(w*h));
		if(vv[p]==false)
			{ v[i]=p; vv[p]=true; } 
			else
			{ i--; }
	}
return v;
}

v=pa(w, h, n);
v[0]=208;
//v[1]=1336;
//v[2]=2013;

if(movement=="Browniano") {
for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	for(j=0; j<n; j++)
		{
		x=v[j]%w;
		y=floor(v[j]/w);
		pix=getPixel(x, y);
		setPixel(x, y, pix+vp);
		x1=round((2*random-1)*step);
		//if(random>0.8)
		x=x+x1;
		y1=round((2*random-1)*step);
		//if(random>0.8) 
		y=y+y1;
		if(x>=w) {x=0;}
		if(x<0) {x=w-1;}
		if(y>=h) {y=0;}
		if(y<0) {y=h-1;}
		v[j]=y*w+x;		
		}
	}
}		

if(movement=="Direccionado_aleatorio" || movement=="Direccion_unica" ) {
Ye=newArray(n);
Xe=newArray(n);

if(movement=="Direccionado_aleatorio") {
for(i=0; i<n; i++) 	{
	do {
	Ye[i]=round((2*random-1)*step);
	Xe[i]=round((2*random-1)*step);
	} while(Ye[i]==0 && Xe[i]==0) } }

if(movement=="Direccion_unica") {
do { 
	ii=round((2*random-1)*step);
	jj=round((2*random-1)*step); 
	} while(ii==0 && jj==0)
for(i=0; i<n; i++) 	{
	Ye[i]=ii; 	Xe[i]=jj;
	} }

for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	for(j=0; j<n; j++)
		{
		x=v[j]%w;
		y=floor(v[j]/w);
		pix=getPixel(x, y);
		setPixel(x, y, pix+vp);
		x=x+Xe[j];
		y=y+Ye[j];
		if(x>=w) {x=0;}
		if(x<0) {x=w-1;}
		if(y>=h) {y=0;}
		if(y<0) {y=h-1;}
		v[j]=y*w+x;
		}
	}
}		

if(movement=="Confinado") {
V=newArray(n);
for(i=0; i<n; i++)
	V[i]=v[i];
for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	for(j=0; j<n; j++)
		{
		x=v[j]%w;
		y=floor(v[j]/w);
		pix=getPixel(x, y);
		setPixel(x, y, pix+vp);
		if(i%2==0){
			STEP=round(random*step);
			x1=round((2*random-1)*STEP);
			x=x+x1;
			y1=round((2*random-1)*STEP);
			y=y+y1; 		
			if(x>=w) {x=0;}
			if(x<0) {x=w-1;}
			if(y>=h) {y=0;}
			if(y<0) {y=h-1;}
			v[j]=y*w+x;	}
			else
			{v[j]=V[j];}		
		}
	}
}		

if(ao==true) {
run("Mean...", "radius=radio stack");
setThreshold(1, 255);
run("Convert to Mask", "method=Default background=Light"); }


		
