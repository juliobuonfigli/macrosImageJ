
for(i=0; i<30; i++)
	{
	selectWindow("300.tif");
	Roi.move(round(random*360)+20, round(random*360)+20);
	run("Duplicate...", "duplicate");
	run("Split Channels");
	selectWindow("C1-300-1.tif");
	rename("tonta");
	runMacro("CC");
	selectWindow("Stack");
	rename("1");
	selectWindow("img");
	close();
	selectWindow("C2-300-1.tif");
	rename("tonta");
	runMacro("CC");
	run("Rotate 90 Degrees Right");
	rename("2");
	runMacro("ScramVsVanStense");
	selectWindow("img");
	close();
	selectWindow("1");
	close();
	selectWindow("2");
	close();
	}