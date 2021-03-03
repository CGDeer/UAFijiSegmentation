# UAFijiSegmentation
Repo for code used on UA HPC to segment 3D confocal data in FIJI for the Reigel Lab. 

# Overview of Project Goal
## The primary project goal of the code herein is to provide a method to segment and analyze multi channel lifext datasets from the Reigel team.  

# Required interface with the HPC:
## You will need to be familiar with using the open-on-demand interface for the University of Arizona HPC.  You can connect from you favorite browser (I use firefox): https://ood.hpc.arizona.edu/pun/sys/dashboard, which will place you at a login portal for university services.  Enter your netID and password as usual:
//!(https://github.com/CGDeer/UAFijiSegmentation/blob/Imgs/master/ood-dashboard.jpg?raw=true)
### For our purposes there are two functions to be familiar with on the OOD dashboard.   
1. You can add small files using the file transfer tab at the top right, this is fairly simple just click the tab and drag and drop your files to transfer them.
2. You can request time and and cores using the "Interactive Apps" drop down.  We will be asking for cores and time on Ocelote so click on Interactive Apps > Ocelote Desktop
- This will bring you to a form for requesting time, cores, gpus and the like.  Essentially it is the form version of a pbs script.  
-   For setup you will want an hour of time on one core to get the plugin setup done and to check for Fiji updates for your Fiji application. 
-   For actually running the scripts and analyzing data, ask for a minimum of 2.5 hours and 4 cores to run the analysis for a stack of images.  These values may need to change due to the size of your data set.
3. After submtting your request you may need to wait until the system is able to serve your request. Wait until the screen tells you the system is ready and then connect to the remote desktop


# Programs required:
## Fiji is just ImageJ that can be found here https://imagej.net/Fiji.  Fiji is  distribution of ImageJ that bundles common scientific image analysis plugins into the base ImageJ platform.
1. To work on the HPC you will want the linux 64 bit download.  
2. Move this download onto the HPC in your prefered method of file transfer, I found it easier to use the ondemand file browser that has documentation here: https://public.confluence.arizona.edu/display/UAHPC/Open+On+Demand#OpenOnDemand-FileBrowser.
- Note well that you do not need to use the HPC for the analysis and can use this for smaller image stacks.  However unless your computer has fairly good specs we reccomend against this as the all to common out of memory error may plague you if your data set is just a bit too big.

# Plugin required:
## Plugin: MorpholibJ that can be found here https://imagej.net/MorphoLibJ 
- IF this is the first time you are using the UA HPC Open On Demand Services, please visit https://public.confluence.arizona.edu/display/UAHPC/Job+Submission, to familiarize yourself with how to request nodes and time on the HPC.  
1. Request 2 hours on 4 cores minimum for analysis of a 1532 x 1532 x 171 (C3 x 57) image stack.  The analysis runs for about 1.5 hours, but the extra time gives you a chance to save any intermediates that aren't already saved by the scripts.
2. To install MorpholibJ, open your FIJI application, then click on Help>Update...
3. You may need the previous step twice, follow the onscreen instructions, until the ImageJ Updater window is opened.
4. Click on Manage Update Sites, then click on the check box of IJPB-plugins then close the Manage update sites window.
5. Then click Apply Changes, and restart FIJI.

# A note on the data structure used in analysis
## The Reigel team's data took the form of .lifext 
1.  .lifext can contain multiple image stacks within its directory
2.  For the purpose of this analysis, only the high resolution images (1532 x 1532) were used.  Each iamge stack focuses on one cell of interest, although fragments of other cells may be present in the image.

# Code Files

## A single .ijm script is currently included, refactored forms of this script have yet to be refactored and proofed. The following outline would be preserved between it and its descendents.
#### Step 0 How to run and Initialization lines
- follow the comments here to refactor the script to be with different datasets or entries within your lifext archive.  
#### Step 1
0. Open data
1. select the channel containing the cell of interest
2. threshold using Otsu's method, masking the result
3. find connected regions of that mask
4. select and keep only the largest connected region
5. analyze the region for volume statistics
6. save out the isolated volume as an ome.tif
#### Step 2
0. image subtract the isolated volume from the puncta volume setting all pixels not falling within the region to 0
1. find bright puncta within the remaining image, using faces and vertexes (ie connectivity =26)
2. use grey attribute 3d filtering on the mask to find puncta that are larger than 50
3. find connected regions within the remain signal
4. analyze the regions for puncta statistics
5. save out the image and the statistics file as .ome.tif and .csv respectively

## Running the scripts:
1. to run a script, retarget the path within the script to your data, and assign the correct filepath, data set, data set identifier, and series number through out the script then save it.  
2. Move your script to the HPC. Since you had a chance to rename it to whatever you wanted in the previous step, I will call your version of the script to yourscript.ijm
3. Request time as described in the note for plugins required, open your session then navigate to your Fiji folder on the hpc.
4. run Fiji, then click Plugins > Macros > Run...
- alternatively you could also use Plugins > Macros > Edit..., which will allow you to look at the code before running it.  This is useful if you cloned the directory from github to your hpc account and skipped step 1 of Running the code as you can edit the script's filepath, data set, data set identifiers, and series numbers directly in Fiji if you so wish.  This mode is also recommended if you need slightly different parameters for your analysis. 
5. select yourscript.ijm and then wait whilst the analysis executes.

