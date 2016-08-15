# Anaconda3 on Alpine Linux

This repository was inspired by the work done [over here](https://github.com/data-science/docker-alpine-anaconda)
and [by continuum.io](https://github.com/ContinuumIO/docker-images/tree/master/anaconda).

This was motivated mostly by a desire to pin down and know the exact version of everything
in the Python stack I was running. I've had a lot of instances lately of cloning something
that looked neat from github and having it not work because of dependency issues, or sharing
something with a coworker and having it not work because their environment was different.

This image contains nothing other than miniconda — you will need to install any dependencies you need yourself, presumably by inheriting from this image.

My recommended workflow would be:
- Always use `conda` to install anything that exists in the Anaconda repos.
- When using conda, always specify a version and use --no-update-deps.
```bash
conda install -y --no-update-deps ipython-notebook=4.0.4
```
- If there's anything you need that isn't in the conda repos, take the time to figure out if it has any dependencies that _are_ and install them using `conda`.
- Anything that needs to be installed from source (`pip`, `python setup.py install`) should go last.
