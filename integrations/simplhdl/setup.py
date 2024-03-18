from setuptools import setup, find_packages
#from src.importlistparser import __version__


setup(
    name='SimplHDL-chipgen',
    description='Chipgen generator plugin for SimplHDL',
    version=0.1,
    package_dir={'': 'src'},
    packages=find_packages('src'),
    entry_points={
        'simplhdl.plugins': [
            'generator=chipgen'],
    },
    install_requires=[
        #'pySVModel==0.3.5',
        #'pyEDAA.ProjectModel==0.4.3',
        'SimplHDL',
    ],
)
