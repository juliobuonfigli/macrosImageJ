function elMayor(vec, l)
	{
	m=0;
	for(i=0; i<l; i++) {
		if(vec[i]>m)
			m=vec[i];  }
	return m;
	}

function elMenor(vec, l)
	{
	m=255*255;
	for(i=0; i<l; i++) {
		if(vec[i]<m)
			m=vec[i];  }
	return m;
	}

function normalizacion(vec, l) 
	{
	max=elMayor(vec, l);
	min=elMenor(vec, l);
	for(i=0; i<l; i++)
		vec[i]=round(((vec[i]-min)*255)/(max-min))+1;
	}


function renderize(vec, img)
	{
	selectWindow(img);
	w=getWidth; h=getHeight; 
	i=0;
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++) 
			{
			setPixel(x, y, vec[i]); 
			i++; 
			}
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

function TripleMAYOR(r, v, a, l)
	{
	vec=newArray(l);
	for (i=0; i<l; i++)
		{
		if(r[i]>=v[i] && r[i]>=a[i])
			vec[i]=r[i];
		else
			{
			if(v[i]>=r[i] && v[i]>=a[i])
				vec[i]=v[i];
			else
				vec[i]=a[i];
			}
		}
	return vec;
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
                 
 Dialog.create("MD");                  //ventana de carga de relaciones                                                      
  Dialog.addChoice("Rojo: ", figura);  
  Dialog.addChoice("Verde: ", figura); 
  Dialog.addChoice("Azul: ", figura);
    
	Dialog.show();
	red=Dialog.getChoice();
	green=Dialog.getChoice();
	blue=Dialog.getChoice();


selectWindow(red);
rename("Red");
run("8-bit");
selectWindow(green);
rename("Green");
run("8-bit");
selectWindow(blue);
rename("Blue");
run("8-bit");
w=getWidth;
h=getHeight;
l=w*h;
r=newArray(w*h);
v=newArray(w*h);
a=newArray(w*h);
r=VECTORIZAR("Red", w, h);
v=VECTORIZAR("Green", w, h);
a=VECTORIZAR("Blue", w, h);
normalizacion(r, l);
normalizacion(v, l);
normalizacion(a, l);
md=TripleMAYOR(r, v, a, l);
newImage("MD", "8-bit black", w, h, 1);
renderize(md, "MD");
