imgimg# Processing and extracting values from NODDI and 3dasl
#   - This script adopted heavily the use of `nilearn` and `nltools`
#   - This script was also prototyped using `hydrogen` in Atom
#
# Sean Ma, 9/25/2018, 10:51:25 AM
#
# NOTE::
# - figure out `pweave` and how it interacts /w `hydrogen: `
# - integrate `.Rmd` /w `.pmd`: https://github.com/nteract/hydrogen/issues/1165

# %% --- set working directory
import os
workdir = "/Users/tehsheng/Dropbox/DrD_Ext"
os.chdir(workdir)

# %% --- define files
# anat = "anatomy/reSlice_fromODI_ht1spgr.nii"
anat = "anatomy/ht1spgr.nii"
anat_betmask = "anatomy/ht1spgr_bet_mask.nii.gz"        # bet2 ht1spgr.nii ht1spgr_bet -m
roi_all = "all_rois.nii.gz"

neurite1 = "DrD_Ext_DTI_scan1/DrD_Ext_scan1_ficvf.nii"
neurite2 = "DrD_Ext_DTI_scan2/reSlice_fromScan1_FICVF_DrD_Ext_scan2_ficvf.nii"
sub_img = "DrD_Ext_DTI_scan2/Scan2-1_ficvf.nii.gz"
neurite_array = [neurite1, neurite2]

asl1 = "DrD_Ext_ASL_scan1/vasc_3dasl/vasc_3dasl_scan1.nii"
asl2 = "DrD_Ext_ASL_scan2/vasc_3dasl/vasc_3dasl_scan2.nii"
asl_array = [asl1, asl2]

# %% --- define z axis cuts
import numpy as np
z_cut = np.arange(-16,56,8)
z_cut

### ===== Visualization section =====
# %% Visualization slices on the subject's own brain
from nilearn import plotting
from nilearn import image
from nltools.data import Brain_Data
# `pathlib` more elegant for filename splitting
import pathlib

# %% --- Visualize histogram
from matplotlib import pyplot
file = asl1
img = Brain_Data(file)
pyplot.hist(img.data[0], alpha=0.5, label='Spin density')
pyplot.hist(img.data[1], alpha=0.5, label='Perfusion weight')
pyplot.legend(loc='upper right')
pyplot.show()

# %% --- define roundup to hundreds function
import math
def roundup(x):
    return int(math.ceil(x / 100.0)) * 100

# %% --- visualize raw ASL images with no anatomy
for file in asl_array:
    for indx in [0, 1]:
        # read in the perfusion volume in 3dasl (index 1: 2nd volume)
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

### ===== ROI section =====
# %% define function to create roi mask files
from nltools.mask import create_sphere

def roi_mask(x, y, z, label, size):
    mask = create_sphere([x, y, z], radius = size)
    mask.to_filename("_".join([label, str(size), ".nii"]))
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

# %% --- Visualize ASL volume with/without brain masking
# read in the perfusion volume in 3dasl (index 1: 2nd volume)
# coerce to `nltools``Brain_Data` for better background mask
img = image.index_img(asl1, 0)
img_title = ["ASL", "Scan1", "Perfusion weights"]

# skull-strip masking vs without
img_BD_noMask = Brain_Data(img)
img_title.append('NoMask')
img_BD_noMask.plot(anatomical=anat,
                   title=" - ".join(img_title),
                   output_file="_".join(img_title))

img_BD = Brain_Data(img, mask=anat_betmask)
img_title.pop()                 #remove previous insert
img_title.append('withMask')
img_BD.plot(anatomical=anat,
            title=" - ".join(img_title),
            output_file="_".join(img_title))

# %% --- Create & save roi spheres by looping over dataframe & later fslview
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
    plotting.plot_stat_map(roi_img.to_nifti(),
                           bg_img=anat,
                           display_mode='ortho', cut_coords=[row.x, row.y, row.z],
                           draw_cross=False, dim=-1,
                           title=fig_label)

# %% plotting overlaid histograms /w pandas
# extract_df.head()

# !! somehow can't save the figure with `savefig` or any!!
# from http://pandas.pydata.org/pandas-docs/stable/visualization.html#visualization-hist
extract_df.hist(alpha=0.5, bins=20, figsize=(12,10), sharex=True)

# switched to this: https://plot.ly/pandas/histograms/
h = extract_df.plot(kind='hist',
                subplots=True, layout=(3,3),
                sharex=True, sharey=True,
                bins=20,
                figsize=(12,10)).get_figure()

# try restarting program
fig= h[0].get_figure()
fig.savefig(h, 'test.png')


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
