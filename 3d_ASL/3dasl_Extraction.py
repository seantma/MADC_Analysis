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
workdir = "/Users/tehsheng/Dropbox/ASL_pilot"
os.chdir(workdir)

# `pathlib` more elegant for filename splitting
import pathlib

# %% --- define files
# anat = "anatomy/reSlice_fromODI_ht1spgr.nii"
anat = "t1mprage_208.nii"
anat_betmask = "bet_t1mprage_208_mask.nii"        # bet2 ht1spgr.nii ht1spgr_bet -m

# CBF files
cbfmap = "cbfmap_anat_mean100_vasc_3dasl.nii"

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
    # mask.to_filename("_".join([label, str(size), "mm.nii"]))
    return mask

# %% --- Visualize ASL volume or CBF map with/without brain masking
# read in the perfusion volume in 3dasl
# coerce to `nltools::Brain_Data` for better background mask

# --- Create & save roi spheres by looping over dataframe & later fslview
# import roi spreadsheet /w `pandas`
import pandas as pd

# %% Loop over subjects
# inspired by https://stackoverflow.com/questions/43619896/python-pandas-iterate-over-rows-and-access-column-names
for dirname in next(os.walk('.'))[1]:

    # constructing whole file path
    fp_anat = str(pathlib.PurePath(workdir, dirname, anat))
    fp_anat_betmask = str(pathlib.PurePath(workdir, dirname, anat_betmask))
    fp_cbfmap = str(pathlib.PurePath(workdir, dirname, cbfmap))

    # constructing image title
    img_title = ['CBF', dirname]

    # skull-strip masking vs without
    img_BD_noMask = Brain_Data(fp_cbfmap)
    img_BD_noMask.plot(anatomical = fp_anat,
                       title=" - ".join(img_title + ['BDnoMask']),
                       output_file="_".join(img_title + ['BDnoMask']))

    img_BD = Brain_Data(fp_cbfmap, mask = fp_anat_betmask) # applying skull-strip mask
    img_BD.plot(anatomical = fp_anat,
                title=" - ".join(img_title + ['BDwithMask']),
                output_file="_".join(img_title + ['BDwithMask']))

    # read in subject-specific roi.csv file
    subj_roi_df = pd.read_csv(str(pathlib.PurePath(workdir, dirname, 'LRTC_roi_10mm.csv')))

    # initialize extraction dataframe
    extract_df = pd.DataFrame()

    # iterating roi.csv file within each subject's folder
    for row in subj_roi_df.itertuples():

        # saving and returning the roi mask created
        mask = roi_mask(row.x, row.y, row.z, row.label, row.size)

        # applying the roi mask on image of interest
        roi_img = img_BD.apply_mask(mask)

        # concatenate extracted neurite array into dataframe
        extract_df = pd.concat([extract_df,pd.DataFrame(roi_img.data, columns=[row.Subject+'_'+row.label])],axis = 1)

        # ortho views at roi coordinates on subject's brain instead of default axial plots
        # masked_img.plot()
        fig_label = "{0}, {1} mm sphere at [{2},{3},{4}]".format(row.label,str(row.size),row.x,row.y,row.z)
        file_label = "{0}_{1}_{2}mm_sphere.png".format(row.Subject, row.label, str(row.size))

        plotting.plot_stat_map(roi_img.to_nifti(),
                               bg_img = fp_anat,
                               display_mode = 'ortho', cut_coords = [row.x, row.y, row.z],
                               draw_cross = False, dim = -1,
                               title = fig_label,
                               output_file = file_label)

        # summarize extracted dataframe
        extract_df.describe()
        extract_df.to_csv('ROI_extract_ASL_pilot.csv')
        extract_df.describe().to_csv('Summary_ROI_extract_ASL_pilot.csv')
