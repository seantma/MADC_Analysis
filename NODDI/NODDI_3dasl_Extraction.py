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

# %% --- Visualize histogram
# !!NOTE!! `Brain_Data()` will automatically mask a MNI mask if not defined !!
from matplotlib import pyplot
file = asl1
img = Brain_Data(file)
pyplot.hist(img.data[0], alpha=0.5, label='Perfusion weight')   # volume 0: perfusion weights
pyplot.hist(img.data[1], alpha=0.5, label='Spin density')       # volume 1: spin density
pyplot.legend(loc='upper right')
pyplot.show()

# %% --- Test data from nilearn.image
ni_img = image.load_img(asl1)
ni_img_data = ni_img.get_fdata()
ni_img_data.shape

asl1_perfw = image.index_img(asl1, 0)
print(asl1_perfw.header)

# %% --- Test writing out asl files for `Brain_Data` & `nilearn.image`
# masked by MNI mask from `Brain_Data`
perfw = img[0];
spin = img[1];
perfw.write('nltools_perfwght_scan1.nii.gz')
spin.write('nltools_spindense_scan1.nii.gz')

# no masking from `nilearn.image`
perfw = image.index_img(asl1, 0)
spin = image.index_img(asl1, 1)
perfw.to_filename('nilearn_perfwght_scan1.nii.gz')
spin.to_filename('nilearn_spindense_scan1.nii.gz')

# %% --- define roundup to hundreds function
import math
def roundup(x):
    return int(math.ceil(x / 100.0)) * 100

# %% --- visualize raw ASL images with no anatomy
for file in asl_array:
    for indx in [0, 1]:
        # read in the perfusion volume in 3dasl (index 0: 1st volume - perfusion weights)
        asl_img = image.index_img(file, indx)

        # extract image filename for figure title use
        fname = pathlib.Path(file).stem

        # extract max intensity from image data
        max_int = roundup(max(img.data[indx]))

        # plot the asl map subject's T1
        plotting.plot_roi(asl_img,
                          display_mode = 'z', cut_coords = z_cut,
                          bg_img = None,                # anat
                          threshold = 50,
                          dim = -1,                     # dimming the anatomy background
                          colorbar = True,
                          vmin = 50,                    # using `fsleyes` histogram
                          vmax = max_int,
                          # cmap = 'gist_gray',         #'binary',
                          output_file = "ASL_visual_{0}_vol{1}.png".format(fname,indx),
                          title = "GE 3dasl: {0} - volume {1}".format(fname,indx))

# %% Plot difference map between Scan2 - Scan1
# ERROR:: images do not have the same affine!!
# SEARCH:: whether coregistered functionals should have the same affine
# diff_img = image.math_img("img2 - img1",
#                           img2 = image.index_img(asl2, 0),
#                           img1 = image.index_img(asl1, 0))  # volume 0: perfusion weights

# using `fslmaths` instead
# inspired by https://unix.stackexchange.com/questions/227337
diff_fname = 'asl_diff_scan2-1'

import subprocess
subprocess.call('fslmaths {0} -sub {1} {2}'.format(asl2,asl1,diff_fname), shell=True)

# !!NEED TO TRY!! `ImCalc` in spm12

# visualizing the difference map - need to check if this is the right way!!
fname2 = pathlib.Path(asl2).stem
fname1 = pathlib.Path(asl1).stem

diff_img = image.index_img(diff_fname + '.nii.gz', 1)
diff_img_BD_mask = Brain_Data(diff_img, mask=anat_betmask)

plotting.plot_roi(diff_img_BD_mask.to_nifti(),
                  bg_img = anat,
                  display_mode = 'z', cut_coords = z_cut,
                  threshold = 50,
                  dim = -1,                     # dimming the anatomy background
                  colorbar = True,
                  output_file = "{0}_visual.png".format(diff_fname),
                  title = "ASL difference map: {0}.nii.gz".format(diff_fname))

# %% visualizing Scan2-Scan1 neurite density difference map
sub = image.load_img(sub_img)

plotting.plot_roi(sub, bg_img=anat, display_mode='z', dim=-1, threshold=0.5)

# %% --- visualize processed CBF maps with no anatomy - using `nilearn::image`
# `nilearn::image` seems too difficult to manipulate raw data matrix
for file in [cbf_asl1, cbf_asl2]:
    # read in the perfusion volume in 3dasl (index 0: 1st volume - perfusion weights)
    asl_img = image.load_img(file)

    # convert image matrix into data matrix
    # http://nipy.org/nibabel/nibabel_images.html
    # !!NOTE!! asl_img.get_fdata() is different than asl_img.get_fdata
    asl_img_data = np.asarray(asl_img.get_fdata())

    # extract image filename for figure title use
    fname = pathlib.Path(file).stem

    # extract max intensity from image data
    max_int = roundup(asl_img_data.max())

    # plot the asl map subject's T1
    plotting.plot_roi(asl_img,
                      display_mode = 'z', cut_coords = z_cut,
                      bg_img = anat,                # anat
                      threshold = 2,
                      dim = -1,                     # dimming the anatomy background
                      colorbar = True,
                      vmin = 5,                     # using `fsleyes` histogram
                      vmax = 100,                   # max_int:: need to find common between 2 images
                      # cmap = 'gist_rainbow',      #'binary',
                      output_file = "CBF_visual_{0}_noMask.png".format(fname),
                      title = "GE 3dasl CBF map: {0} - no Mask".format(fname))

# %% --- visualize processed CBF maps with no anatomy - using Brain_Data()
# `nilearn::image` seems too difficult to manipulate raw data matrix
for file in cbf_array:
    # read in the perfusion volume in 3dasl (index 0: 1st volume - perfusion weights)
    asl_img_BD = Brain_Data(file, mask=anat_betmask)    # applying skull-strip mask

    # extract image filename for figure title use
    fname = pathlib.Path(file).stem
    img_title = ['CBF', fname]

    # plot the asl map over subject's T1
    asl_img_BD.plot(anatomical=anat,
                    title = " - ".join(img_title + ['BDwithMask']),
                    output_file = "_".join(img_title + ['BDwithMask']))

### ===== CBF map scaling section =====
# %% this code is adopted from Scott's `cbfmap.m` function
# while his code scales appropriately, there is no way of writing the image out
import numpy as np
import nibabel as nib

# extract just the data
perfw_mat = perfw.get_fdata()
spin_mat = spin.get_fdata()

# check our data again if matches prior histogram
# NOTE:: previous histogram read by `Brain_Data` is masked by MNI mask
pyplot.hist(perfw_mat.ravel())
pyplot.hist(spin_mat.ravel())

# creating masks
msk1 = np.where(perfw_mat == 0)   # pw==0; mask outside spiral coverage
msk2 = np.where(spin_mat < 200)     # pd<200; masks non-brain areas

# count number of elements matching criteria
perfw_mat.size
np.where(perfw_mat > 500)
(perfw_mat == 0).sum()
(spin_mat < 200).sum()

# parameter definitions
alpha = 0.9
ST = 2
T1t = 1.2
eff = 0.6
T1b = 1.6
LT = 1.5

NEX=3;

# post labelling delay
# PLD = 1.525;    # for UMMAP protocol
PLD = 2.025;    # for PTR protocol

# equation definitions
eqnum = (1 - np.exp(-ST/T1t)) * np.exp(PLD/T1b);
eqdenom = 2 * T1b *(1 - np.exp(-LT/T1b)) * eff * NEX;

# don't know what this is
SF = 32;

# final scaling factors
cbf = 6000 * alpha * (eqnum/eqdenom) * np.divide(perfw_mat, (SF * spin_mat));

np.divide(1, 0)

tt = np.divide(perfw_mat, (SF * spin_mat))

tt.shape
pyplot.hist(tt.ravel())


### ===== ROI section =====
# %% define function to create roi mask files
from nltools.mask import create_sphere

def roi_mask(x, y, z, label, size):
    mask = create_sphere([x, y, z], radius = size)
    mask.to_filename("_".join([label, str(size), "mm.nii"]))
    return mask

# %% --- visualizing the rois together on subject's brain
# using `fslmaths` : fslmaths L_ant_5_.nii -add L_mid_5_.nii -add L_post_5_.nii -add R_ant_5_.nii -add R_mid_5_.nii -add R_post_5_.nii -add R_CSF_3_.nii -add Corpus_Callosm_3_.nii all_rois.nii
rois = image.load_img(roi_all)

plotting.plot_roi(rois, bg_img=anat,
                  display_mode='z', cut_coords= [-14, -10, -6, -2, 2, 6],
                  cmap='bwr_r',         # http://nilearn.github.io/auto_examples/01_plotting/plot_colormaps.html
                  dim=-1,
                  output_file = "LR_LTC_ROI_visualization.png",
                  title = "L/R LTC ROIs visualization")

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


# ==== Test ground for playing ====
#
# %% plotting glass brain /w `nilearn`
import nilearn
from nilearn import plotting
plotting.plot_glass_brain(neurite1)

# %% testing smoothing on the image
from nilearn import image
smoothed_img = image.smooth_img(neurite1, fwhm=5)
plotting.plot_glass_brain(smoothed_img)

# %% loading image as `Nifti1Image` and header
img = image.load_img(neurite1)
print(img.header)
print(img.shape)

# %% visualizing glass brain /w `nltools`
from nltools.data import Brain_Data
from nilearn.plotting import plot_glass_brain
img_s1 = Brain_Data(neurite2)
plot_glass_brain(img_s1.to_nifti())
