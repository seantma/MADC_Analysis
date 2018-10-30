# Processing and extracting values from NODDI and 3dasl
#   - This script adopted heavily the use of `nilearn` and `nltools`
#   - This script was also prototyped using `hydrogen` in Atom
#
# Sean Ma, 9/25/2018, 10:51:25 AM
#
# NOTE::
# - figure out `pweave` and how it interacts /w `hydrogen: `
# - integrate `.Rmd` /w `.pmd`: https://github.com/nteract/hydrogen/issues/1165
# - use `dir()` to list variables
# - use `%reset` to clear all variables

# %% --- set working directory
import os
workdir = "/Users/tehsheng/Dropbox/DrD_Ext"
os.chdir(workdir)

# %% --- define files
# anat = "anatomy/reSlice_fromODI_ht1spgr.nii"
anat = "anatomy/ht1spgr.nii"
anat_betmask = "anatomy/ht1spgr_bet_mask.nii.gz"        # bet2 ht1spgr.nii ht1spgr_bet -m
roi_all = "all_rois.nii.gz"

# NODDI files
neurite1 = "DrD_Ext_DTI_scan1/DrD_Ext_scan1_ficvf.nii"
neurite2 = "DrD_Ext_DTI_scan2/reSlice_fromScan1_FICVF_DrD_Ext_scan2_ficvf.nii"
sub_img = "DrD_Ext_DTI_scan2/Scan2-1_ficvf.nii.gz"
noddi_array = [neurite1, neurite2]
noddi_dict = {
    'scan1': {'file':'neurite1', 'scan_indx':1, 'scan':'Scan1'},
    'scan2': {'file':'neurite2', 'scan_indx':2, 'scan':'Scan2'}
     }

# ASL files
asl1 = "DrD_Ext_ASL_scan1/vasc_3dasl/vasc_3dasl_scan1.nii"
asl2 = "DrD_Ext_ASL_scan2/vasc_3dasl/vasc_3dasl_scan2.nii"
asl_arrary = [asl1, asl2]
asl_dict = {
    'scan1': {'file':'asl1', 'scan_indx':1, 'scan':'Scan1'},
    'scan2': {'file':'asl2', 'scan_indx':2, 'scan':'Scan2'}
     }

# CBF files
cbf_asl1 = "DrD_Ext_ASL_scan1/vasc_3dasl/cbfmap_vasc_3dasl_scan1.nii"
cbf_asl2 = "DrD_Ext_ASL_scan2/vasc_3dasl/cbfmap_vasc_3dasl_scan2.nii"
cbf_asl1 = "DrD_Ext_ASL_scan1/vasc_3dasl/cbfmap_anat_mean100_vasc_3dasl_scan1.nii"
cbf_asl2 = "DrD_Ext_ASL_scan2/vasc_3dasl/cbfmap_anat_mean100_vasc_3dasl_scan2.nii"
cbf_array = [cbf_asl1, cbf_asl2]

# constructing whole file path
# `pathlib` more elegant for filename splitting
import pathlib
fp_asl1 = str(pathlib.PurePath(workdir, asl1))
fp_asl2 = str(pathlib.PurePath(workdir, asl2))

# %% --- define z axis cuts
import numpy as np
z_cut = np.arange(-16,56,8)
z_cut

### ===== Visualization section =====
# %% Visualization slices on the subject's own brain
from nilearn import plotting
from nilearn import image
from nltools.data import Brain_Data

# %% --- define roundup to hundreds function
import math
def roundup(x):
    return int(math.ceil(x / 100.0)) * 100

### ===== ROI section =====
# %% define function to create roi mask files
from nltools.mask import create_sphere

def roi_mask(x, y, z, label, size):
    mask = create_sphere([x, y, z], radius = size)
    mask.to_filename("_".join([label, str(size), "mm.nii"]))
    return mask

# %% --- Visualize ASL volume or CBF map with/without brain masking
# read in the perfusion volume in 3dasl
# coerce to `nltools::Brain_Data` for better background mask

# Loop for raw ASL images which includes perfusion wights & spin density
# for key, value in asl_dict.items():
#     img = image.index_img( eval(value['file']), 0 )     # index 0: 1st volume
#     img_title = [ value['file'], value['scan'], "PerfusionWeights" ]

# Loop for CBF calculated maps (code provided by Scott)
for file in cbf_array:
    # extract image filename for figure title use
    fname = pathlib.Path(file).stem
    img_title = ['CBF', fname]

    # skull-strip masking vs without
    img_BD_noMask = Brain_Data(file)
    img_BD_noMask.plot(anatomical=anat,
                       title=" - ".join(img_title + ['BDnoMask']),
                       output_file="_".join(img_title + ['BDnoMask']))

    img_BD = Brain_Data(file, mask=anat_betmask)         # applying skull-strip mask
    img_BD.plot(anatomical=anat,
                title=" - ".join(img_title + ['BDwithMask']),
                output_file="_".join(img_title + ['BDwithMask']))

    # --- Create & save roi spheres by looping over dataframe & later fslview
    # import roi spreadsheet /w `pandas`
    import pandas as pd
    roi_df = pd.read_csv('roi_5mm.csv')

    # initialize dataframe
    extract_df = pd.DataFrame()

    # inspired by https://stackoverflow.com/questions/43619896/python-pandas-iterate-over-rows-and-access-column-names
    for row in roi_df.itertuples():
        # saving and returning the roi mask created
        mask = roi_mask(row.x, row.y, row.z, row.label, row.size)

        # applying the roi mask on image of interest
        roi_img = img_BD.apply_mask(mask)

        # concatenate extracted neurite array into dataframe
        extract_df = pd.concat([extract_df, pd.DataFrame(roi_img.data, columns=[row.label])],
        axis = 1)

        # ortho views at roi coordinates on subject's brain instead of default axial plots
        # masked_img.plot()
        fig_label = "{0}, {1} mm sphere at [{2},{3},{4}]".format(row.label,str(row.size),row.x,row.y,row.z)
        file_label = "{0}_{1}mm_sphere.png".format(row.label, str(row.size))

        plotting.plot_stat_map(roi_img.to_nifti(),
                               bg_img=anat,
                               display_mode='ortho', cut_coords=[row.x, row.y, row.z],
                               draw_cross=False, dim=-1,
                               title=fig_label,
                               output_file=file_label)

    # plotting overlaid histograms /w pandas
    # extract_df.head()

    # !! somehow can't save the figure with `savefig` or any!!
    # from http://pandas.pydata.org/pandas-docs/stable/visualization.html#visualization-hist
    # extract_df.hist(alpha=0.5, bins=20, figsize=(12,10), sharex=True)

    # switched to this: https://plot.ly/pandas/histograms/
    # some bug , need to fix!!
    # h = extract_df.plot(kind='hist',
    #                     subplots=True, layout=(3,3),
    #                     sharex=True, sharey=True,
    #                     bins=20,
    #                     figsize=(12,10),
    #                     title=" - ".join(img_title + ['ROI extracts']))

    # try restarting program
    # fig= h[0].get_figure()
    # fig.savefig(h, 'test.png')

    # summarize extracted dataframe
    # fname = "{0}_{1}_ROI_extraction.csv".format(value['file'], value['scan'])
    extract_df.describe()
    extract_df.to_csv('ROI_extract_' + fname + '.csv')
    extract_df.describe().to_csv('Summary_ROI_extract_' + fname + '.csv')
