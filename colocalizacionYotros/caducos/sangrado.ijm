macro "sangrado [s]" 
{

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
  
  Dialog.create("Limpiar");                                                       
  Dialog.addChoice("Fuente:", figura);         
  Dialog.addChoice("Sangrada:", figura);          
  Dialog.addChoice("Mascara:", figura);    
  Dialog.addCheckbox("Segun coeficiente de sangrado", false);
  Dialog.addNumber("Coeficiente: ", 1);
  Dialog.addChoice("Profundidad: ", newArray("8-bit", "16-bit")); 
       Dialog.show();
   	fuente=Dialog.getChoice();
   	sangrada=Dialog.getChoice();
   	mascara=Dialog.getChoice();
	co=Dialog.getCheckbox();
	coef=Dialog.getNumber();
	profundidad=Dialog.getChoice();
 	

setBatchMode(true);

if(profundidad=="8-bit") {
selectWindow(mascara);
run("Select None");
selectWindow(fuente);
run("8-bit");
run("Select None");
selectWindow(sangrada);
run("8-bit");
run("Select None"); }
else {
selectWindow(mascara);
run("Select None");
selectWindow(fuente);
run("16-bit");
run("Select None");
selectWindow(sangrada);
run("16-bit");
run("Select None"); }

w = getWidth;               
h = getHeight;

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


unosMascara=contarUnos(mascara);
f=newArray(unosMascara);
s=newArray(unosMascara);

i=0;
for(y=0; y<h; y++)
	{
	for(x=0; x<w; x++)
		{
		selectWindow(mascara);
		e=getPixel(x, y);
		if(e==255)
			{
			selectWindow(fuente);
			f[i]=getPixel(x, y);
			selectWindow(sangrada);
			s[i]=getPixel(x, y);
			i++;
			}
		}
	}

Coef=0;
		
for(j=0; j<unosMascara; j++)
	Coef=Coef+s[j]/f[j];


Coef=Coef/unosMascara;

if(co==true)
	Coef=coef;

F=VECTORIZAR(fuente, w, h);
S=VECTORIZAR(sangrada, w, h);
R=newArray(w*h);

for(k=0; k<w*h; k++)
	R[k]=S[k]-Coef*F[k];

titulo=Coef;

if(profundidad=="8-bit")
newImage(titulo, "8-bit random", w, h, 1);
else
newImage(titulo, "16-bit random", w, h, 1);
	
selectWindow(titulo);
i=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		setPixel(x,y, R[i]);
		i++;
		}
	} 
setBatchMode("exit and display"); 

}

































































