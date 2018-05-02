//probabilidad hipergeométrica para colocalizacion

function FAC(x)
	{
	if(x==0) x=1; else {
	for(i=x-1; i>0; i--)
		x=x*i; }
	return x;
	}

function BinCoef(n, k)
	{
	res=FAC(n)/(FAC(k)*FAC(n-k));
	return res;	
	}

function HG(d, n, N, x)  //funcion hipergeometrica
	{
	res=BinCoef(d, x)*BinCoef(N-d, n-x)/BinCoef(N, n);
	return res;
	}

function aHG(d, n, N, x)  //funcion hipergeometrica acumulada
	{
	res=0;
	for(i=x; i<n+1; i++)
		res=res+HG(d, n, N, i);
	return res; 	
	}

Dialog.create("Load relationships");                    //ventana de carga de relaciones                                                      
  Dialog.addNumber("x (coincidencias): ", 2);   
  Dialog.addNumber("N (dimension en pixels): ", 121); 
  Dialog.addNumber("d (pixels de un canal): ", 2);   
  Dialog.addNumber("n (pixels del otro canal): ", 40); 
  Dialog.addCheckbox("Acumulada: ", true); 
Dialog.show();
  	x1=Dialog.getNumber();
	N1=Dialog.getNumber();
	d1=Dialog.getNumber();
	n1=Dialog.getNumber();
	cb=Dialog.getCheckbox();

if(cb==false)
print(HG(d1, n1, N1, x1));
else
print(aHG(d1, n1, N1, x1));
	