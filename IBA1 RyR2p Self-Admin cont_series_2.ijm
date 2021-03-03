//Step 0 Running and Initialization 
//To run this script, open on demand for ocelote, with 2 hours and 4 cores.  
//Open FIJI on your interactive HPC session, Plugins>Macros>edit
//select the script from your directory, and then hit run.
 
//To refactor this to work on a different dataset,
//change 'FilePath' to your xdisk allocation after moving your .lifext into that location
//change 'FileName' to match the name of the .lifext file.
//change  the numeral of 'SeriesNumber' to match desired the entry in the .lifext archive
//change the numeral of series_2 in Step 1 Phase 0 to match the desired entry in the .lifext archive.

FilePath = "/home/u22/cgdeer/";
FileName = "IBA1 RyR2p Self-Admin cont";
SeriesNumber= "series_2";



//DO NOT CHANGE these lines as they are constructions to use the initialization information to reduce the amount of changes one must make to change the script to refactor to another file or entry.

InputExtension= ".lifext";
FPNE= FilePath + FileName + InputExtension;
FNE= FileName + InputExtension;
CSV1= FilePath + FileName + SeriesNumber + "CellStats.csv";
OME1= FilePath + FileName + SeriesNumber + "CellImage.ome.tiff";
CSV2= FilePath + FileName + SeriesNumber + "puncta.csv";
OME2= FilePath + FileName + SeriesNumber + "puncta.ome.tiff";
FileNameNoSpace= replace(FileName, " ", ""); 
//print(FileNameNoSpace);


//Step 1 Phase 0 Open your data, you will STILL need to change the series number by hand in the next line of code
run("Bio-Formats Importer", "open=[FPNE] autoscale color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT series_2");

//Step 1 Phase 1 select the channel with the cell of interest
selectWindow(FNE +" - C=0");

//Step 1 Phase 2 Threshold step, using the autothreshold method.  The output from these lines will be a binary mask
setAutoThreshold("Default");
setAutoThreshold("Otsu");
setOption("BlackBackground", false);
run("Convert to Mask", "method=Otsu background=Dark calculate");

//Step 1 Phase 3 Connect mask slice by slice, splitting the mask into separate regions
run("Find Connected Regions", "allow_diagonal display_one display_results regions_for_values_over=100 minimum_number_of_points=1 stop_after=-1");

//checkpoint during development. saves out the output of the previous step as an ome.tif
//run("Bio-Formats Exporter", "save=[All_Connected_Regions.ome.tif] export compression=Uncompressed");

//Step 1 Phase 4 Selects only the largest region, discards the smaller regions.
run("Keep Largest Label");
//Step 1 Phase 5 Retreival of region data.  There should only be one line of infomation as the previous step removes all other volumes.
run("Analyze Regions 3D", "volume surface_area mean_breadth sphericity euler_number bounding_box centroid equivalent_ellipsoid ellipsoid_elongations max._inscribed surface_area_method=[Crofton (13 dirs.)] euler_connectivity=C26");
saveAs("Results", CSV1);

selectWindow(FileNameNoSpace +"-largest");
//Step 1 Phase 6 save out volume in ome.tif
//replace series number here
run("Bio-Formats Exporter", "save=[OME1] export compression=Uncompressed");

//rename("IBA1 RyR2p Self-Admin cont_series_2_Largest_Isolate");
//invert the positive for image calculation.
run("Invert", "stack");
//run("Bio-Formats Exporter", "save=[C0_IBA1 RyR2p Self-Admin cont_series_2.ome.tif] export compression=uncompressed");
//run("Bio-Formats Exporter", "save=/home/u22/cgdeer/IBA1 RyR2p Self-Admin cont_series_2");  //this line was covered by line 

//Step 2 Phase 0 Isolate signal of a channel using the isolated volume of the cell of interest
//replace series number
img1= FNE + " - C=1";
img2= FileNameNoSpace + "-largest";
imageCalculator("Subtract create stack", img1, img2);

//Step 2 Phase 1 Find the bright points in the remaining signal, using face and vertex conectivity, note I have not changed dynamic settings so this is a place 
//to explore in the future
run("Extended Min & Max 3D", "operation=[Extended Maxima] dynamic=10 connectivity=26");

//Step 2 Phase 2 Used on a binary image this step will filter the spots identified in the previous step, separating out spots smaller than 50.
run("Gray Scale Attribute Filtering 3D", "operation=Opening attribute=Volume min=50 connectivity=26");

//Step 2 Phase 3 Similarly to Step 1 Phase 3, this will create regions of connected voxels.
run("Find Connected Regions", "allow_diagonal display_one_image display_results regions_for_values_over=50 minimum_number_of_points=1 stop_after=-1");

// Step 2 Phase 4 Will give measurements of each region defined in Step 2 Phase 3
run("Analyze Regions 3D", "volume surface_area mean_breadth sphericity euler_number bounding_box centroid equivalent_ellipsoid ellipsoid_elongations max._inscribed surface_area_method=[Crofton (13 dirs.)] euler_connectivity=C26");

// Step 2 Phase 5 saves out both the output of Step 2 Phase 4 and its image result.

saveAs("Results", CSV2);
selectWindow("All connected regions");
run("Bio-Formats Exporter", "save=[OME2] export compression=Uncompressed");
