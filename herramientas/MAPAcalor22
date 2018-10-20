macro "Mapa de calor [m]" 
{

function PROMEDIO(vector, w, h)     //1: funcion para vectorizar imagenes                    
{
suma=0;  
for (i=0; i<h*w; i++)
	suma=suma+vector[i];
prom=suma/(w*h);
return prom;
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
  
  Dialog.create("Mapa de calor");                                                       
  Dialog.addChoice("Canal 1:", figura);         
  Dialog.addChoice("Canal 2:", figura);          
  Dialog.addChoice("Imagen:", newArray("Rainbow RGB", "Rainbow Smooth", "Rainbow Bands", "royal", "Ratio", "smart", "temp", "Yellow Hot", "Magenta Hot", "Orange Hot", "Red Hot", "Red-Cyan"));    
  Dialog.addChoice("Metodo:", newArray("Correlacion", "Intensidad")); 
   Dialog.addChoice("Entrada:", newArray("8 bit", "32 bit")); 
   Dialog.addCheckbox("Igualar promedio de intensidades", 1);

       Dialog.show();
   	rojo=Dialog.getChoice();
   	verde=Dialog.getChoice();
   	color=Dialog.getChoice();
	metodo=Dialog.getChoice();   
	entrada=Dialog.getChoice();
        IP=Dialog.getCheckbox();
	

selectWindow(rojo);
run("Select None");
selectWindow(verde);
run("Select None");

w = getWidth;               
h = getHeight;

selectWindow(rojo);	                    
  r = newArray(w*h);
  i = 0;
  for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		r[i] = getPixel(x,y);
		i++;
		}
	}
	

selectWindow(verde);	
  v = newArray(h*w);
  i=0;
  for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		v[i] = getPixel(x,y);
		i++;
		}
	}

numRV=newArray(w*h);
pv=PROMEDIO(v, w, h);
pr=PROMEDIO(r, w, h);

if(IP==1)
	{	
for(i=0; i<w*h; i++)                                           // hago que la intensidad promedio de la imagen sea igual a la intensidad promedio seteada                  
	v[i]=round(v[i]*(pr/pv));
	}


if(metodo=="Intensidad")
	{
	if(entrada=="32 bit")
		{	
		for(i=0; i<w*h; i++)                                              
			numRV[i]=255*2*(r[i]*v[i])/(abs(r[i])+abs(v[i]));
		}
		else
		{
		for(i=0; i<w*h; i++)                                              
			numRV[i]=2*(r[i]*v[i])/(abs(r[i])+abs(v[i]));
		}
	}

if(metodo=="Correlacion")
	{
	if(entrada=="32 bit")
		{
		for(i=0; i<w*h; i++)                                              
			numRV[i]=255-255*abs(r[i]-v[i]);               
		}
		else
		{
		for(i=0; i<w*h; i++)                                              
			numRV[i]=255-abs(r[i]-v[i]);               
		}
	}

newImage("Mapa", "8-bit black", w, h, 1);

selectWindow("Mapa");
i=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		setPixel(x,y, numRV[i]);
		i++;
		}
	}
run(color);

updateDisplay();



}
