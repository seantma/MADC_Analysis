### Notes on daducci/AMICO
10/9/2018, 4:44:24 PM

#### Issues
1. **ModuleNotFoundError: No module named 'core'** when `import amico`
    - originally thought it was due to `SPAMS` package installed incorrectly
    - tried re-install but there was still `wheels` error when installing on OSX
    - eventually used `conda install -c python-spams` as same error still persists after succussful installation of `SPAMS` on _Ubuntu 16.04_
    - did some digging on the Github::Issues and there was another similar question and the resolution was using `python2.7`
    - setting up `conda env` following https://conda.io/docs/user-guide/tasks/manage-python.html
    - `conda create -n py27 python=2.7 conda-forge`
