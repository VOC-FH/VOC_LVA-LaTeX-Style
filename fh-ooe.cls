\ProvidesClass{fh-ooe}
% 
\RequirePackage{kvoptions}
\RequirePackage{etex}
% 
\SetupKeyvalOptions{
  family=fhooe,
  prefix=fhooe@
}

\DeclareStringOption{twoscreens}[1920x1080|1024x768]
\DeclareStringOption{article}[article]

\DeclareDefaultOption{
  \PassOptionsToClass{\CurrentOption}{beamer}%
}

\PassOptionsToClass{aspectratio=3218}{beamer}

\ProcessKeyvalOptions*

\PassOptionsToPackage{unicode}{hyperref}

\ifx\fhooe@article\@empty%
  \LoadClass{beamer}
  \RequirePackage{fh-ooe.multiscreen}
\else
  \LoadClass{article}
  \RequirePackage{beamerarticle}
  \RequirePackage{hyperref}
\fi

\hypersetup{bookmarksdepth=paragraph}

\usetheme{FH-OOE}
%
\setbeamersize{
  text margin left=10mm,
  text margin right=10mm,
  sidebar width left  = 0mm,
  sidebar width right = 0mm
}
%
\RequirePackage[utf8]{inputenc}
\RequirePackage[T2A, T1]{fontenc}
\RequirePackage{ucs}
\RequirePackage{pgfplots}
\RequirePackage{pgfplotstable}
\RequirePackage{varwidth}
\RequirePackage{tikz}
\RequirePackage{tikz-uml}
\RequirePackage{tikz-uml-extension}
\RequirePackage[lighttt]{lmodern}
\RequirePackage{listings-extension}
\RequirePackage[scriptsize]{subfigure}
\RequirePackage{caption}
\RequirePackage{xstring}
\RequirePackage{svg}
\RequirePackage[euler]{textgreek}
\RequirePackage{relsize}
\RequirePackage[siunitx]{circuitikz}
\RequirePackage{multirow}
\RequirePackage{fix-cm}
% 
\pgfplotsset{compat=1.13}
% 
% \AtBeginDocument{\sisetup{math-rm=\mathrm}} % https://tex.stackexchange.com/questions/403693/use-text-font-in-siunitx-instead-of-math-font
% 
\let\orig@num\num
\renewcommand\num[1][]{\orig@num[group-minimum-digits = 4, group-separator = {\,}, output-decimal-marker = {,}, #1]}
\newcommand\tnum[1][]{\num[mode=text, #1]}
% 
\let\orig@SI\SI
\renewcommand\SI[1][]{\orig@SI[group-minimum-digits = 4, group-separator = {\,}, output-decimal-marker = {,}, #1]}
\newcommand\TSI[1][]{\SI[mode=text, #1]}
\newcommand\tsi[1][]{\si[mode=text, #1]}
%
\DeclareCaptionFont{cap-fh-ooe-red}{\color{fh-ooe-red}}
\captionsetup{format=default,justification=centering,labelformat=simple,labelfont={scriptsize,cap-fh-ooe-red},textfont=scriptsize}
% 
\let\orig@include\include
\renewcommand{\include}[2][.]{
  \setpath{#1}
  \orig@include{#1/#2}
}
% 
\newcommand{\setpath}[1]{%
  \graphicspath{{#1/material/}{#1/images/}}%
  \def\pgfpath{#1/material/pgf/}%
  \svgsetup{inkscapepath=./#1/images/svg-inkscape}
  \svgpath{{#1/images/}}
}
% 
\def\includegraphicswrapper[{\includegraphics[}
% 
\def\pgfinput#1{\input{\pgfpath/#1.pgf}}
% 
\AtBeginDocument{%
  \fhooe@includeonlylecture%
}%
% 
\let\orig@document\document%
\let\orig@enddocument\enddocument%
% 
\renewenvironment{document}[1][]%
{%
  \gdef\fhooe@ArgI{{#1}}%
  \fhooe@documentRelay%
}{%
  \orig@enddocument%
}%

\newcommand{\fhooe@documentRelay}[1][]%
{%
  \gdef\fhooe@ArgII{{#1}}%
  \gdef\fhooe@maketitle{}%\relax}
  \gdef\fhooe@includeonlylecture{}%\relax}
%
  \ifthenelse{\expandafter\equal\fhooe@ArgI{with titlepage}}{%
    \gdef\fhooe@maketitle{\maketitle}%
    \ifthenelse{\expandafter\equal\fhooe@ArgII{}}%
    {}{%
      \gdef\fhooe@includeonlylecture{\expandafter\includeonlylecture\fhooe@ArgII}%
    }%
  }{%
    \ifthenelse{\expandafter\equal\fhooe@ArgI{without titlepage}}{%
      \ifthenelse{\expandafter\equal\fhooe@ArgII{}}%
      {}{%
        \gdef\fhooe@includeonlylecture{\expandafter\includeonlylecture\fhooe@ArgII}%
      }%
    }{%
      \ifthenelse{\expandafter\equal\fhooe@ArgII{}}{%
        \ifthenelse{\expandafter\equal\fhooe@ArgI{}}{%
          \gdef\fhooe@maketitle{\maketitle}%
        }{%
          \gdef\fhooe@includeonlylecture{\expandafter\includeonlylecture\fhooe@ArgI}%
        }%
      }{%
        \errormessage{Error: Wrong arguments to macro \noexpand\typeset}%
      }%
    }%
  }%
  \orig@document%
  \fhooe@maketitle%
}%
% 
\def\fhooepresentationoptions{\beamertemplatenavigationsymbolsempty}
% 
\mode<presentation>{\fhooepresentationoptions}
% 
% Read options from file
\InputIfFileExists{fh-ooe.def.tex}{}{}
\InputIfFileExists{experimental.def.tex}{}{}
\InputIfFileExists{private.def.tex}{}{}
% 
\makeatletter
  \def\app@exe{\immediate\write18}
  \def\inputAllFiles#1{%
    \app@exe{rm -f #1/\jobname.tmp}
    \app@exe{ls #1/*.tex | xargs cat >> #1/\jobname.tmp}%
%    \app@exe{ls #1/*.tex | xargs -n1 /bin/bash -c 'echo "{" >> #1/\jobname.tmp ; cat "$@" >> #1/\jobname.tmp ; echo "}" >> #1/\jobname.tmp ;' ''}
    \InputIfFileExists{#1/\jobname.tmp}{}{}%
    \AtEndDocument{\app@exe{rm -f #1/\jobname.tmp}}%
  }
\makeatother
%
\newenvironment{boxblock}[1]{%
  \begin{columns}%
    \begin{column}{#1}%
      \begin{block}%
      }{%
      \end{block}%
    \end{column}%
  \end{columns}%
}%
% 
\newenvironment{boxexampleblock}[1]{%
  \begin{columns}%
    \begin{column}{#1}%
      \begin{exampleblock}%
      }{%
      \end{exampleblock}%
    \end{column}%
  \end{columns}%
}%
% 
\newenvironment{boxalertblock}[1]{%
  \begin{columns}%
    \begin{column}{#1}%
      \begin{alertblock}%
      }{%
      \end{alertblock}%
    \end{column}%
  \end{columns}%
}%
% 
% 
% Temporary Fix
%\makeatletter
%\ifdefined\@@magyar@captionfix
%\else
%\let\@@magyar@captionfix\relax
%\fi
%\makeatother
% 
