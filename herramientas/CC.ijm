 macro "CC" 
{


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
	}

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


Dialog.create("Stack de van stenseel");                                                       
 
  Dialog.addChoice("Imagen: ", figura);
  Dialog.addCheckbox("En Y", false);  
   Dialog.show();
   	img=Dialog.getChoice();
    enY=Dialog.getCheckbox();

//enY=false;

//selectWindow("1-18000.tif");
selectWindow(img);
rename("img");
w=getWidth();
h=getHeight();
temp=newArray(w*h);
temp=VECTORIZAR("img", w, h);  

newImage("Stack", "8-bit black", w, h, w);

selectWindow("Stack");
for(z=1; z<w+1; z++)
	{
	setSlice(z);
	cont=0;
	r1=round(random*w);
	r2=round(random*h);
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			if(x+r1<w)
				X=x+r1;
			else
				X=x+r1-w;
			if(y+r2<h)
				Y=y+r2;
			else
				Y=y+r2-h;
			vp=floor(cont/w)*w+cont%w;
	       	setPixel(X, Y, temp[vp]); 
			cont++;
			//print(X);
			}
		}
	}
/*
k=0;
selectWindow("Stack");
for(z=1; z<w+1; z++)
	{
	setSlice(z);
	cont=0;
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			if(x<k)
				X=x+(w-k);
				else
				X=abs(x-k);
			vp=floor(cont/w)*w+cont%w;
	        if(enY==true)
	        	setPixel(y, X, temp[vp]); 
			else
				setPixel(X, y, temp[vp]); 
			cont++;
			//print(X);
			}
		}
	if(k>w)
		k=0;
	k++;
	}*/

}



    