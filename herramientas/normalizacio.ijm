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
	m=255;
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

function renderize(vec, mask, img)
	{
	selectWindow(img);
	w=getWidth; h=getHeight; 
	i=0; c=0;
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++) 
			{
			if(mask[i]==255)
				{
				setPixel(x, y, vec[c]); 
				c++; 
				}
			i++;
			}
		}
	}

function vectorizar(r, mask, n)
	{
	vec=newArray(n);
	c=0;
	for(i=0; i<w*h; i++)
		{
		if(mask[i]==255)
			{
			vec[c]=r[i];	
			c++;		
			}
		}
	return vec;
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

function CONTEO(mask)
	{
	n=0;
	for(i=0; i<w*h; i++) {
		if(mask[i]==255)
			n++; }
	return n;
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
  
               
 Dialog.create("NORMALIZACION");                  //ventana de carga de relaciones                                                      
  Dialog.addChoice("Canal: ", figura);  
  Dialog.addChoice("Mascara: ", figura); 
     
	Dialog.show();
	canal=Dialog.getChoice();
	masc=Dialog.getChoice();
	
 
selectWindow(canal);
w=getWidth;
h=getHeight;


run("Duplicate...", "title=Canal");
selectWindow(masc);
run("Duplicate...", "title=Mascara");
c=newArray(w*h); m=newArray(w*h);
c=VECTORIZAR("Canal", w, h); 
m=VECTORIZAR("Mascara", w, h);
unos=CONTEO(m);
C=newArray(unos);
C=vectorizar(c, m, unos);
normalizacion(C, unos);
renderize(C, m, "Canal");


