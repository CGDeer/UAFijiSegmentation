//To run the script, open Fiji and click on Plugins > Macros > Run...
//Then select your script from the file directory.

//Step 1 Phase 0 Open your data, this will change for every data set used.  Change the path root to where you have saved your data:
//ie: open=/home/u22/cgdeer/CC_PFC1_Layer3(1).lifext  changes to open=/home/u**/yourUserName/[...] where ** is the number for your home directory and 
//if using data from a different lifext, change the name CC_PFC1_layer3(1).lifext to the new filename.
//then find all instances of PFC1_series_2 and replace with the new image identifier and series number where indicated in the comments
//N.B. for all steps we assume that C=0 is the channel containing the neural cell of interest, and C=1 is channel containing puncta signal.
run("Bio-Formats Importer", "open=/home/u22/cgdeer/CC_PFC1_layer3(1).lifext autoscale color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT series_2");


//Step 1 Phase 1 select the channel with the cell of interest, if you are changing the dataset change the file name.  In our case c=0 is the channel with the neuronal cell 
//of interest which we intend to theshold and select for to provide an inclusive mask for other channels that contain markers for puncta of interest. 
selectWindow("CC_PFC1_layer3(1).lifext - C=0");

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
rename("C0_PFC1_series_2_Largest_Isolate");

//Step 1 Phase 6 save out volume in ome.tif
//replace series number here and image identifier

run("Bio-Formats Exporter", "save=[C0_PRC1_series_2_Largest_Isolate.ome.tif] export compression=uncompressed");
run("Bio-Formats Exporter", "save=/home/u22/cgdeer/CO_PFC1_series_2_Largest_Isolate");


//Step 2 Phase 0 Isolate signal of a channel using the isolated volume of the cell of interest
//replace series number and image identifier
imageCalculator("Subtract create stack", "CC_PFC1_layer3(1).lifext - C=1","C0_PFC1_series_2_Largest_Isolate");

//Step 2 Phase 1 Find the bright points in the remaining signal, using face and vertex conectivity, note I have not changed dynamic settings so this is a place 
//to explore in the future
run("Extended Min & Max 3D", "operation=[Extended Maxima] dynamic=10 connectivity=26");


//Step 2 Phase 2 Used on a binary image this step will filter the spots identified in the previous step, separating out spots smaller than 50.
run("Gray Scale Attribute Filtering 3D", "operation=Opening attribute=Volume min=50 connectivity=26");

//Step 2 Phase 3 Similarly to Step 1 Phase 3, this will create regions of connected voxels.
run("Find Connected Regions", "allow_diagonal display_one_image display_results regions_for_values_over=50 minimum_number_of_points=1 stop_after=-1");


// Step 2 Phase 4 Will give measurements of each region defined in Step 2 Phawe 3
run("Analyze Regions 3D", "volume surface_area mean_breadth sphericity euler_number bounding_box centroid equivalent_ellipsoid ellipsoid_elongations max._inscribed surface_area_method=[Crofton (13 dirs.)] euler_connectivity=C26");

// Step 2 Phase 5 saves out both the output of Step 2 Phase 4 and its image result.
//replace series and dataset identifier
saveAs("Results", "/home/u22/cgdeer/Process2_CC_PFC1_Layers3(1).csv");
run("Bio-Formats Exporter", "save=/home/u22/cgdeer/Process2_CC_PFC1_Layer3(1)_result.ome.tif export compression=Uncompressed");
