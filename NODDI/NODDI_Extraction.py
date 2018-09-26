# Playing /w `nilearn` and `nltools`
# Using `hydrogen` in Atom
#
# Sean Ma, 9/25/2018, 10:51:25 AM

# %% set working directory
import os
workdir = "/Users/tehsheng/Dropbox/DrD_Ext"
os.chdir(workdir)

# %% define files
neurite1 = "DrD_Ext_DTI_scan1/DrD_Ext_scan1_ficvf.nii"
neurite2 = "DrD_Ext/DrD_Ext_DTI_scan2/reSlice_fromScan1_FICVF_DrD_Ext_scan2_ficvf.nii"
anat = "anatomy/reSlice_fromODI_ht1spgr.nii"

# %% plotting glass brain /w `nilearn`
import nilearn
from nilearn import plotting
plotting.plot_glass_brain(neurite1)

# %% testing smoothing on the image
from nilearn import image
smoothed_img = image.smooth_img(neurite1, fwhm=5)
plotting.plot_glass_brain(smoothed_img)

# %% loading image as `Nifti1Image`
img = image.load_img(neurite1)
print(img.header)
print(img.shape)

# %% visualizing glass brain /w `nltools`
from nltools.data import Brain_Data
from nilearn.plotting import plot_glass_brain
img_s1 = Brain_Data(neurite1)
plot_glass_brain(img_s1.to_nifti())

# %% importing roi spreadsheet /w `pandas`
import pandas as pd
roi_df = pd.read_csv('roi_5mm.csv')

# %% define function to create roi mask files
def roi_mask(x, y, z, label, size):
    mask = create_sphere([x, y, z], radius = size)
    mask.to_filename("_".join([label, str(size), ".nii"]))
    return

# %% looping over dataframe to create & save sphere for roi masked_img_s1 & later fslview
from nltools.mask import create_sphere
# r_mask = create_sphere([32, 24, -11], radius = 15)
# r_mask.to_filename('15mm_mask.nii')
# inspired by https://stackoverflow.com/questions/43619896/python-pandas-iterate-over-rows-and-access-column-names
for row in roi_df.itertuples():
    roi_mask(row.x, row.y, row.z, row.label, row.size)

# %% applying mask to image of interest
masked_img_s1 = img_s1.apply_mask(r_mask)
masked_img_s1.plot()

# %% plot the masked image with histogram distributions
import seaborn as sns
len(masked_img_s1.data)
sns.distplot(masked_img_s1.data)

# %% plotting on individual brain instead of standard brain
masked_img_s1.plot(anatomical = anat)

# %% read in neurite from scan2 and generate histogram for comparison
img_s2 = Brain_Data(neurite2)
masked_img_s2 = img_s2.apply_mask(r_mask)
masked_img_s2.plot()
masked_img_s2.plot(anatomical = anat)

len(masked_img_s2.data)
sns.distplot(masked_img_s2.data)
