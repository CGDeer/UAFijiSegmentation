
run("Bio-Formats Importer", "open=[C:/Users/Christine Deer/Downloads/Microglia Pilot Project/CC_PFC3_layer3(1).lifext] autoscale color_mode=Default group_files rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT contains=[] name=[C:/Users/Christine Deer/Downloads/Microglia Pilot Project/CC_PFC3_layer3(1).lifext] series_2");
selectWindow("CC_PFC3_layer3(1).lifext - C=1");
selectWindow("CC_PFC3_layer3(1).lifext - C=0");
run("MultiThresholder", "Otsu");
run("MultiThresholder", "otsu");
run("MultiThresholder", "Otsu");
run("MultiThresholder", "Otsu apply");
run("Find Connected Regions", "allow_diagonal display_one_image display_results regions_for_values_over=100 minimum_number_of_points=1 stop_after=-1");
run("Bio-Formats Exporter", "save=[C:/Users/Christine Deer/Downloads/Microglia Pilot Project/CC_PFC_3_layer3/All_Connected_Regions.ome.tif] export compression=Uncompressed");
run("Keep Largest Label");
selectWindow("All connected regions");
selectWindow("All-largest");
run("Analyze Regions 3D", "volume surface_area mean_breadth sphericity euler_number bounding_box centroid equivalent_ellipsoid ellipsoid_elongations max._inscribed surface_area_method=[Crofton (13 dirs.)] euler_connectivity=C26");
saveAs("Results", "C:/Users/Christine Deer/Downloads/Microglia Pilot Project/CC_PFC_3_layer3/All-largest-morpho.csv");
run("Bio-Formats Exporter", "save=[C:/Users/Christine Deer/Downloads/Microglia Pilot Project/CC_PFC_3_layer3/All_Largest.ome.tif] export compression=Uncompressed");
run("Invert", "stack");
rename("Inverted Mask");

imageCalculator("Subtract create stack", "CC_PFC3_layer3(1).lifext - C=1","Inverted Mask");
selectWindow("Result of CC_PFC3_layer3(1).lifext - C=1");
rename("CC_PFC3_layer3(1).lifext - C=1  Isolate");
run("Bio-Formats Exporter", "save=[C:/Users/Christine Deer/Downloads/Microglia Pilot Project/CC_PFC_3_layer3/CC_PFC3_Layer3_isolated_Volume_C1]");
run("MultiThresholder", "Otsu");
run("MultiThresholder", "otsu");
run("MultiThresholder", "Minimum apply");


run("Find Connected Regions", "allow_diagonal display_one_image display_results regions_for_values_over=100 minimum_number_of_points=20 stop_after=-1");


selectWindow("All connected regions");
run("Analyze Regions 3D", "volume surface_area mean_breadth sphericity euler_number bounding_box centroid equivalent_ellipsoid ellipsoid_elongations max._inscribed surface_area_method=[Crofton (13 dirs.)] euler_connectivity=C26");
saveAs("Results", "C:/Users/Christine Deer/Downloads/Microglia Pilot Project/CC_PFC_3_layer3/All-Connected-Regions_Isolate_spots.csv");
selectWindow("CC_PFC3_layer3(1).lifext - C=2");
imageCalculator("Subtract create stack", "CC_PFC3_layer3(1).lifext - C=2","Inverted Mask");
selectWindow("Result of CC_PFC3_layer3(1).lifext - C=2");
run("MultiThresholder", "Minimum");
run("MultiThresholder", "minimum");
run("MultiThresholder", "Minimum");
run("MultiThresholder", "Minimum apply");

run("Bio-Formats Exporter", "save=[C:/Users/Christine Deer/Downloads/Microglia Pilot Project/CC_PFC_3_layer3/C2_Isolated_Spots]");

close();
rename("C2_Isolated_Spots");
run("Find Connected Regions", "allow_diagonal display_one_image display_results regions_for_values_over=100 minimum_number_of_points=20 stop_after=-1");
rename("C2_All connected regions");
run("Bio-Formats Exporter", "save=[C:/Users/Christine Deer/Downloads/Microglia Pilot Project/CC_PFC_3_layer3/C2_All_Connected_Regions]");
run("Analyze Regions 3D", "volume surface_area mean_breadth sphericity euler_number bounding_box centroid equivalent_ellipsoid ellipsoid_elongations max._inscribed surface_area_method=[Crofton (13 dirs.)] euler_connectivity=C26");
saveAs("Results", "C:/Users/Christine Deer/Downloads/Microglia Pilot Project/CC_PFC_3_layer3/C2_All_Connected_Isolated_Spots.csv");
