# UAFijiSegmentation
Repo for code used on UA HPC to segment 3D confocal data in FIJI 

# Overview of Project Goal
## The primary project goal of the code herein is to provide a method to segment and analyze multi channel lifext datasets from the Reigel team.  

# Programs required:
## Fiji is just ImageJ that can be found here https://imagej.net/Fiji.  Fiji is  distribution of ImageJ that bundles common scientific image analysis plugins into the base ImageJ platform.
1. To work on the HPC you will want the linux 64 bit download.  
2. Move this download onto the HPC in your prefered method of file transfer, I found it easier to use the ondemand file browser that has documentation here: https://public.confluence.arizona.edu/display/UAHPC/Open+On+Demand#OpenOnDemand-FileBrowser.
- Note well that you do not need to use the HPC for the analysis and can use this for smaller image stacks.  However unless your computer has fairly good specs we reccomend against this as the all to common out of memory error may plague you if your data set is just a bit too big.

# Plugin required:
## With Plugin: MorpholibJ that can be found here https://imagej.net/MorphoLibJ 
- IF this is the first time you are using the UA HPC Open On Demand Services, please visit https://public.confluence.arizona.edu/display/UAHPC/Job+Submission, to familiarize yourself with how to request nodes and time on the HPC.  
1. Request 2 hours on 4 nodes minimum for analysis of a 1532 x 1532 x 171 (C3 x 57) image stack.  The analysis runs for about 1.5 hours, but the extra time gives you a chance to save any intermediates that aren't already saved by the scripts.
2. To install MorpholibJ, open your FIJI application, then click on Help>Update...
3. You may need the previous step twice, follow the onscreen instructions, until the ImageJ Updater window is opened.
4. Click on Manage Update Sites, then click on the check box of IJPB-plugins then close the Manage update sites window.
5. Then click Apply Changes, and restart FIJI.

# A note on the data structure used in analysis
## The Reigel team's data took the form of .lifext 
1.  .lifext can contain multiple image stacks within its directory
2.  For the purpose of this analysis, only the high resolution images (1532 x 1532) were used.  Each iamge stack focuses on one cell of interest, although fragments of other cells may be present in the image.

# Code Files

## Both .ijm script files contained within follow the general 2 step outline:
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
5 save out the image and the statistics file as .ome.tif and .csv respectively

## There are currently two script files included within this repo.  They follow the same general structure but have comments that acheive different goals.  
### Process2_Macro_v0.1.ijm 's comments give instructions that would target a different .lifext dataset.  To target a completely different file format: 
1. If you are using a file type other than .lifext you will need to get the I/O formatting from the macro recorder.
2. To do this, open FIJI, click on Plugins > Macros > Record
3. Then click on Plugins > Bio-Formats > Bio-Formats Importer
4. Select the file you wish to open.
5. Replace the line to open your data with what the recorder reads out. Then continue on to replace the data identifier and if applicapble the series number throughout the script.

### Process2_Macro_v0.1_alt.1.ijm comments give instructions on how to target a different image within a .lifext database.  

# Running the Code:
1. to run either script, retarget the path within the script to your data, and assign the correct data set identifier and series number through out the script then save it.
2. Request time as described in the note for plugins required, open your session then navigate to your Fiji folder on the hpc.
3. run Fiji, then click Plugins > Macros > Run...
- alternatively you could also use Plugins > Macros > Edit..., which will allow you to look at the code before running it.
4. select yourscript.ijm and then wait whilst the analysis executes.
