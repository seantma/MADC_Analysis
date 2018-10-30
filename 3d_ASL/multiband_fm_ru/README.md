<!--
@Author: Sean Ma <tehsheng>
@Date:   2017-11-29T13:45:30-05:00
@Email:  tehsheng@umich.edu
@Filename: README.md
@Last modified by:   tehsheng
@Last modified time: 2017-11-29T13:46:43-05:00
-->

## Fieldmap correction from fMRI Lab

Notes on using fMRI lab's fieldmap correction scripts.

### Krisanne's instructions on using the code

<blockquote>

Krisanne Litinas <klitinas@umich.edu>
Oct 20

to Scott, me, Benjamin
Hi Sean,

Download and extract the attached file.  The scripts/ subdirectory needs to be on your path, and the main script to run is multiband_fieldmap_correct_subject.sh.  Give it a subject directory, e.g.

`multiband_fieldmap_correct_subject.sh -s bmh14mci12345_06789`

You need to either have spm12 on your default matlab path, or tweak lines 47-48 in matchvdm.sh and lines 37-38 in fm_realign_unwarp.sh to reflect where spm is located on your machine.

Let me know of issues that come up.
</blockquote>
