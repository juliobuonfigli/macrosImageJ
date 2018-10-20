 macro "CC" 
{

/*
id1=getImageID();          //identificaci�n de IDs
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
	}*/

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
Dialog.create("Stack de van stenseel");                                                       
 
  Dialog.addChoice("Imagen: ", figura);
  Dialog.addCheckbox("En Y", false);  
   Dialog.show();
   	img=Dialog.getChoice();
    enY=Dialog.getCheckbox();
*/
enY=false;

selectWindow("img");
rename("img");
w=getWidth();
h=getHeight();
temp=newArray(w*h);
temp=VECTORIZAR("img", w, h);  

newImage("Coco", "8-bit black", w, h, 1);
final=newArray(w*h);
	j=0;
	ini=round(random*w*h);
	i=ini;
	while(i<w*h+ini)
		{
		if(i>=w*h)
			pos=i-w*h;
		else
			pos=i;
		final[j]=temp[pos];	
		j++;
		i++;
		}
	


selectWindow("Coco");
cont=0;
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
		
	        	setPixel(x, y, final[cont]); 
			cont++;
			//print(X);
			}
		}

	

}



    