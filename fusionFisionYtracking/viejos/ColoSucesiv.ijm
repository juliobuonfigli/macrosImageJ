// funcion que genera esta aplicación da indicios de la dinámica de movimiento del fluoróforo de la misma forma que el MSD (mean square displacement) 
//siendo muy útil en casos donde es dificil de usar tracking por cuestiones técnicas
//voy usar la funcion de dispersar que va a ir como piña

w = getWidth;              
h = getHeight; 
rename("Final");

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


run("8-bit");
frames=62;
C1=newArray(w*h);
C2=newArray(w*h);
colo=newArray(frames);
denC1=0;

setSlice(1);
C1=VECTORIZAR("Final", w, h);
for(i=0; i<w*h; i++)
	denC1=denC1+C1[i]*C1[i];

for(e=2; e<frames; e++)
	{
	setSlice(e);
	C2=VECTORIZAR("Final", w, h);
  	num=0;
	denC2=0;
	
	for(i=0; i<w*h; i++)                                              
		{                                                                                     
		denC2=denC2+C2[i]*C2[i];
		num=num+C1[i]*C2[i];
		}
	colo[e-1]=num/sqrt(denC1*denC2);                             
	}

 	a=newArray(frames);
	for(f=0; f<frames; f++)     
		a[f]=f+1;

Plot.create("Plot", "Frame", "Overlap"); 
	Plot.setLimits(0, frames, 0, 1);  
	Plot.setColor("black", "black");           
    Plot.add("line", a, colo);
    //Plot.makeHighResolution("Plot",3.0,"disable");
   
