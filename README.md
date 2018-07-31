# LaTeX class for Europass CV

The eu­ropass class is LaTeX im­ple­men­ta­tion of the  (the "Europass CV") as rec­om­mended by the Euro­pean Com­mis­sion.

## How to install on Linux

You need `epstopdf` provided by `texlive-font-utils` package for this to work.

```sh
git clone https://github.com/tprasadtp/europass-cv.git
cd europass-cv
./install
```

> It is necessary to have `*.eps-converted-to.pdf` files for `eps` file in the installed directory. the bash script `install` takes care of converting eps to pdf, installing it in the location and updating the tex database.

## Use

Provides class `europass-cv` and `coveletter`. See examples for more info.

```tex
\documentclass[english,logo,notitle,totpages,utf8]{europass-cv}
```

> Use for europass-cv-compact layout

```tex
\documentclass[english,logo,notitle,totpages,utf8]{europass-cv-compact}
```

## Use with hyperref

For use with hyperref to include file metadata and to hide bookmarks and links use hyperref.

```tex
\usepackage[pdftex,
pdfauthor={Prasad Tengse},
pdftitle={Title},
pdfsubject={Subject},
pdfkeywords={keywords},
pdfproducer={Latex with hyperref on TeXstudio / Travis},
pdfcreator={pdflatex},
bookmarks=false,
colorlinks=true,
urlcolor=navyblue]{hyperref}
```

## License

This is a derived work under the terms of the LaTeX project public license (LPPL). It is based  europecv.cls which is part of the europecv package by Nicola Vitacolonna. A copy of europecv, including the unmodified version of europecv.cls is available  from http://www.ctan.org/tex-archive/macros/latex/contrib/europecv. under LPPL. For icons see [icons](#icons-and-license)

## Based on

`https://ctan.org/tex-archive/macros/latex/contrib/europecv`

## Windows
Place the files in
C:\Users\<user name>\Appdata\Local\MikTex\<number>\tex\latex\local\

## Icons and license

* Icons are made by Freepik from www.flaticon.com under [Flaticon Basic License](https://file000.flaticon.com/downloads/license/license.pdf).
* If for some reason icons do not render, use PNG icons in the png directory.

[![Analytics](https://ga-beacon.prasadt.com/UA-101760811-3/github/europass-cv?flat)](https://prasadt.com/google-analytics-beacon)
