# Processing and extracting values from NODDI and 3dasl
#   - This script adopted heavily the use of `nilearn` and `nltools`
#   - This script was also prototyped using `hydrogen` in Atom
#
# Sean Ma, 9/25/2018, 10:51:25 AM
#
# NOTE::
# - figure out `pweave` and how it interacts /w `hydrogen: `
# - integrate `.Rmd` /w `.pmd`: https://github.com/nteract/hydrogen/issues/1165

# %% set working directory
import os
workdir = "/Users/tehsheng/Dropbox/DrD_Ext"
os.chdir(workdir)

# %% define files
neurite1 = "DrD_Ext_DTI_scan1/DrD_Ext_scan1_ficvf.nii"
neurite2 = "DrD_Ext_DTI_scan2/reSlice_fromScan1_FICVF_DrD_Ext_scan2_ficvf.nii"
# anat = "anatomy/reSlice_fromODI_ht1spgr.nii"
anat = "anatomy/ht1spgr.nii"
roi_all = "all_rois.nii.gz"
sub_img = "DrD_Ext_DTI_scan2/Scan2-1_ficvf.nii.gz"
asl1 = "DrD_Ext_ASL_scan1/vasc_3dasl/vasc_3dasl_scan1.nii"
asl2 = "DrD_Ext_ASL_scan2/vasc_3dasl/vasc_3dasl_scan2.nii"

# %% define z axis cuts
import numpy as np
z_cut = np.arange(-16,56,8)
z_cut

# %% Visualization on the subject's own brain
from nilearn import plotting
from nilearn import image
# `pathlib` more elegant for filename splitting
import pathlib

for asl in [asl1, asl2]:
    # read in the perfusion volume in 3dasl (index 1, 2nd volume)
    asl_img = image.index_img(asl, 1)
    # split up the file path for figure title use
    file = pathlib.Path(asl).stem
    # plot the asl map subject's T1
    plotting.plot_roi(asl_img,
                      bg_img = anat,
                      display_mode = 'z', cut_coords = z_cut,
                      threshold = 50,
                      dim = -1,                     # dimming the anatomy background
                      colorbar = True,
                      vmin = 50, vmax = 1000,
                      output_file = "ASL_visual_{0}.png".format(file),
                      title = "ASL file: {0}".format(file))

# %% Plot difference map between Scan2 - Scan1
# ERROR: 2 images need to have the same affine!! More strict than `fslmaths`!!
# diff_img = image.math_img("img2 - img1",
#                           img2 = image.index_img(asl2, 1),
#                           img1 = image.index_img(asl1, 1))
# using `fslmaths` instead
import subprocess
fp_asl1 = str(pathlib.PurePath(workdir, asl1))
fp_asl2 = str(pathlib.PurePath(workdir, asl2))
diff_img = 'asl_diff_scan2-1'

# inspired by https://unix.stackexchange.com/questions/227337
subprocess.call('fslmaths {0} -sub {1} {2}'.format(asl2,asl1,diff_img), shell=True)

fname2 = pathlib.Path(asl2).stem
fname1 = pathlib.Path(asl1).stem

# visualizing the difference map - need to check if this is the right way!!
plotting.plot_roi(image.index_img(diff_img+'.nii.gz', 1),
                  bg_img = anat,
                  display_mode = 'z', cut_coords = z_cut,
                  threshold = 50,
                  dim = -1,                     # dimming the anatomy background
                  colorbar = True,
                  # output_file = "ASL_visual_{0}.png".format(file),
                  title = "ASL difference map: {0} - {1}".format(fname2, fname1))

# %% visualize raw ASL images with no anatomy
for asl in [asl1, asl2]:
    # read in the perfusion volume in 3dasl (index 1, 2nd volume)
    asl_img = image.index_img(asl, 1)
    # split up the file path for figure title use
    file = pathlib.Path(asl).stem
    # plot the asl map subject's T1
    plotting.plot_roi(asl_img,
                      display_mode = 'z', cut_coords = z_cut,
                      bg_img = None,
                      threshold = 50,
                      dim = -1,                         # dimming the anatomy background
                      colorbar = True,
                      vmin = 50, vmax = 1000, #200,     # using `fsleyes` histogram
                      # cmap = 'gist_gray',             #'binary',
                      output_file = "ASL_visual_{0}_vol1.png".format(file),
                      title = "GE 3dasl: {0} - volume 1".format(file))


# %% importing roi spreadsheet /w `pandas`
import pandas as pd
roi_df = pd.read_csv('roi_5mm.csv')

# %% define function to create roi mask files
from nltools.mask import create_sphere

def roi_mask(x, y, z, label, size):
    mask = create_sphere([x, y, z], radius = size)
    mask.to_filename("_".join([label, str(size), ".nii"]))
    return mask

# %% looping over dataframe to create & save sphere for roi masked_img_s1 & later fslview
# initialize dataframe
neurite_df = pd.DataFrame()

# r_mask = create_sphere([32, 24, -11], radius = 15)
# r_mask.to_filename('15mm_mask.nii')
# inspired by https://stackoverflow.com/questions/43619896/python-pandas-iterate-over-rows-and-access-column-names
for row in roi_df.itertuples():
    # saving and returning the roi mask created
    mask = roi_mask(row.x, row.y, row.z, row.label, row.size)

    # applying the mask on image of interest
    masked_img_s1 = img_s1.apply_mask(mask)

    # concatenate extracted neurite into dataframe
    neurite_df = pd.concat([neurite_df, pd.DataFrame(masked_img_s1.data, columns=[row.label])],
                           axis = 1)

    # plotting ortho views at roi coordinates on subject's brain instead of default axial plots
    # masked_img_s1.plot()
    fig_label = "{0}, {1} mm sphere at [{2},{3},{4}]".format(row.label,str(row.size),row.x,row.y,row.z)
    plotting.plot_stat_map(masked_img_s1.to_nifti(), bg_img=anat,
                           display_mode='ortho', cut_coords=[row.x, row.y, row.z],
                           draw_cross=False, dim=-1,
                           title=fig_label)

# %% try using functional programming `apply` to solve this
 # def noddi_extract(row, neurite):
     # read in NODDI image
     # img_s1 = Brain_Data(neurite1

for neu in [neurite1, neurite2]:
    img = image.load_img(neu)
    print(img.shape)

for indx,item in enumerate([neurite1, neurite2]):
    print(indx, item)

# %%
neurite_df
neurite_df.describe()
neurite_df.to_csv('nuerite_scan2.csv')
neurite_df.describe().to_csv('nuerite_scan2_Summary.csv')

# %% visualizing the rois altogether on subject's brain
# NOTE:: using `plot_roi`
# using `fslmaths` : fslmaths L_ant_5_.nii -add L_mid_5_.nii -add L_post_5_.nii -add R_ant_5_.nii -add R_mid_5_.nii -add R_post_5_.nii -add R_CSF_3_.nii -add Corpus_Callosm_3_.nii all_rois.nii
rois = image.load_img(roi_all)

plotting.plot_roi(rois, bg_img=anat, display_mode='z', dim=-1)

# %% visualizing Scan2-Scan1 neurite density difference map
sub = image.load_img(sub_img)

plotting.plot_roi(sub, bg_img=anat, display_mode='z', dim=-1, threshold=0.5)


# %% plot the masked image with histogram distributions
import seaborn as sns
len(masked_img_s1.data)
sns.distplot(masked_img_s1.data)

# %% read in neurite from scan2 and generate histogram for comparison
img_s2 = Brain_Data(neurite2)
masked_img_s2 = img_s2.apply_mask(r_mask)
masked_img_s2.plot()
masked_img_s2.plot(anatomical = anat)

len(masked_img_s2.data)
sns.distplot(masked_img_s2.data)

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
