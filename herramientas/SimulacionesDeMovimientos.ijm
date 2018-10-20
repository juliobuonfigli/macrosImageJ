
Dialog.create("Vesiculas");                                                       
 
  Dialog.addChoice("Movimiento: ", newArray("Browniano", "Confinado", "Direccionado_aleatorio", "Direccion_unica", "Superdifusivo"));  
  Dialog.addNumber("Numero de objetos: ", 15); 
  Dialog.addCheckbox("Paso constante", true); 
  Dialog.addNumber("Paso: ", 5); 
  Dialog.addNumber("Probabilidad de movimiento: ", 0.2); 
  Dialog.addNumber("Cortes: ", 1); 
  Dialog.addNumber("Alto: ", 30); 
  Dialog.addNumber("Ancho: ", 30); 
  Dialog.addNumber("Valor de Pixel: ", 255);
  Dialog.addCheckbox("Agrandar Objetos", false); 
  Dialog.addNumber("Radio: ", 4); 

       Dialog.show();
   	movement=Dialog.getChoice();
   	n=Dialog.getNumber();
   	pc=Dialog.getCheckbox();
   	step=Dialog.getNumber();
    pm=Dialog.getNumber();
    FRAMES=Dialog.getNumber();
   	H=Dialog.getNumber();
   	W=Dialog.getNumber();
   	vp=Dialog.getNumber();
   	ao=Dialog.getCheckbox();
   	radio=Dialog.getNumber();

pm=1-pm;
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
//v[0]=500;
//v[1]=1336;
//v[2]=2013;

if(movement=="Browniano" || movement=="Superdifusivo") {
for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	for(j=0; j<n; j++)
		{
		x=v[j]%w;
		y=floor(v[j]/w);
		pix=getPixel(x, y);
		setPixel(x, y, pix+vp);
		alfa=random*2*PI;
		if(movement=="Superdifusivo") alfa=random*PI;
		if(pc==false) 
			STEP=random*step;
			else
			STEP=step;
		y1=round(STEP*sin(alfa));
		x1=round(STEP*cos(alfa));	
		if(random>=pm) {
		x=x+x1;
		y=y+y1; }
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
	alfa=random*2*PI;
	if(pc==false) STEP=step*random;
	else STEP=step;
	Ye[i]=round(STEP*sin(alfa));
	Xe[i]=round(STEP*cos(alfa));
		}
	}

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
		if(random>=pm) {
		x=x+Xe[j];
		y=y+Ye[j]; }
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
			if(random>=pm) {x=x+x1;}
			y1=round((2*random-1)*STEP);
			if(random>=pm) {y=y+y1;}
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
run("Convert to Mask"); }


		