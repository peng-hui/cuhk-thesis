Updated by Penghui Li to sync with SecLab/[die](https://github.com/tsgates/die) template. There are lots of useful commands defined in cmds.tex. You can also find a synchronized version on [Overleaf]().

``` txt
├── Makefile
├── README.md
├── p.tex > main tex file of the thesis
├── hdr.tex > headers including title, etc.
├── abstract-zh.tex > abstract in Chinese
├── abstract.tex > abstract in English
├── dedication.tex
├── chapter.tex > main text
├── ack.tex > acknledgement
├── code > code snippets
├── fig > figures
├── pkgs.tex 
├── p.bib > bibtex
├── bin > scripts
├── cmds.tex > self-defined latex command
└── rev.tex
```

There are several notes:
* To enable latex compilation in your local host, you need have text-live installed. You might also need some more packages.
* The build script might abort before the references are successfully linked. You might need to build twice (i.e., run `make` twice).
* You might reuse the content in your previous papers in the thesis.
It is likely your several papers cite the same resources with difference keys.
Please make sure to de-duplicate the bibtex entries ultimately. 
There are multiple online websites that can help do the job.
* Similarly, you also need to change the labels/refs in your tex files. You can use a simple regular expression to handle this.
* You also need to adjust the location of code or figures.
* A problem related to the left quote raised when using minted for the code styles, especially when Chinese characters are involved. I took a walkaround by chaning the code/fmt style file.

The scripts under bin/ come from various sources and the credit should go to their original developers.

----
A PhD Thesis submitted to CUHK
---------------------------------------------
Author: [ZHENG Fan](https://github.com/izhengfan)

## Install dependencies

The tex source file depends on several latex packages.
Check the `dependence_texlive` target in `Makefile` for the package list.

If using TexLive, you can run the `tlmgr install ...` command in `Makefile` to
install the required packages, or directly execute command `make dependence_texlive`
in Unix terminals.
Note that TexLive installed via `apt install` in Ubuntu gives an unusable `tlmgr`,
and one good solution is to uninstall it and reinstall TexLive
via the tool in https://tug.org/texlive/quickinstall.html.
   
If using MikTex, required packages will be automatically installed during building.


## Build PDF

Build the thesis using the xelatex engine.
On Unix/Linux, just use the Makefile to build, i.e. in terminal:

    make

If not on Unix/Linux, help yourself.
