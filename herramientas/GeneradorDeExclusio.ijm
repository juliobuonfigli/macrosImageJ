
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


Dialog.create("Excluidas");                                                       
 
  Dialog.addChoice("Imagen: ", figura);  
  Dialog.addNumber("Numero de objetos: ", 10); 
  Dialog.addNumber("Radio de objetos: ", 5); 
  Dialog.addNumber("Valor de Pixel: ", 255);
  Dialog.addCheckbox("Agrandar Objetos", true); 
  Dialog.addNumber("Radio: ", 3); 

       Dialog.show();
   	img=Dialog.getChoice();
   	n=Dialog.getNumber();
   	radioTemplado=Dialog.getNumber();
    vp=Dialog.getNumber();
    ao=Dialog.getCheckbox();
   	radio=Dialog.getNumber();

selectWindow(img);
run("Duplicate...", "img2");
rename("img2");
selectWindow("img2");

run("Mean...", "radius=radioTemplado");
w=getWidth();
h=getHeight();
temp=newArray(w*h);
temp=VECTORIZAR("img2", w, h);  

newImage("Exclusion", "8-bit black", w, h, 1);

v=newArray(n);
vv=newArray(w*h);
for(i=0; i<w*h; i++)
	{
	if(temp[i]>0)
		vv[i]=true;
		else
		vv[i]=false;
	}
for(i=0; i<n; i++) {
	pos=round(random*(w*h));
		if(vv[pos]==false)
			{ v[i]=pos; vv[pos]=true; } 
			else
			{ i--; }
	}
	
selectWindow("Exclusion");
for(j=0; j<n; j++)
	{
	x=v[j]%w;
	y=floor(v[j]/w);
	setPixel(x, y, vp);
	}

selectWindow("Exclusion");
if(ao==true) {
run("Mean...", "radius=radio stack");
setThreshold(1, 255);
run("Convert to Mask"); }

selectWindow("img2");
close();
