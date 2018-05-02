
for(i=0; i<100; i++)
	{
	X=round(random*360)+20;
	Y=round(random*360)+20;	
	selectWindow("toto");
	Roi.move(X, Y);
	selectWindow("tota");
	Roi.move(X, Y);
	runMacro("ScramVSvs");
	}