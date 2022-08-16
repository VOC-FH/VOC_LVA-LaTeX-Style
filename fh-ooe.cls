\ProvidesClass{fh-ooe}
% 
\RequirePackage{ifthen}
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
  \expandafter\PassOptionsToPackage
  \expandafter{\CurrentOption}{beamer}%
}

\ProcessKeyvalOptions*

\ifx\fhooe@article\@empty%
  \LoadClassWithOptions{beamer}
  \RequirePackage{fh-ooe.multiscreen}
\else
  \LoadClassWithOptions{\fhooe@article}
  \RequirePackage{beamerarticle}
  \RequirePackage{hyperref}
\fi

\hypersetup{bookmarksdepth=paragraph}

\usetheme{FH-OOE}
%
\RequirePackage[T2A, T1]{fontenc}
\RequirePackage{ucs}
\RequirePackage{pgfplots}
\RequirePackage{pgfplotstable}
\RequirePackage{filecontents}
\RequirePackage{varwidth}
\pgfplotsset{compat=1.13}
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
% 
\RequirePackage[siunitx]{circuitikz}
\AtBeginDocument{\sisetup{math-rm=\mathrm}}
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
\RequirePackage{multimedia}
% 
\newcommand{\mysound}[3][]{%
  \sound[#1]{#2}{\basesoundpath/\soundpath/#3}%
}%
% 
\def\basesoundpath{}
\def\setbasesoundpath#1{%
  \def\basesoundpath{#1}%
}%
% 
\def\soundpath{}
\def\setsoundpath#1{%
  \def\soundpath{#1}%
}%
% 
% 
\DeclareCaptionFont{cap-fh-ooe-red}{\color{fh-ooe-red}}
\captionsetup{format=default,justification=centering,labelformat=simple,labelfont={scriptsize,cap-fh-ooe-red},textfont=scriptsize}
% 
\newcommand{\degree}{\@dblarg\beamer@degree}
\long\def\beamer@degree[#1]#2{%
  \def\insertdegree{#2}%
  \def\insertshortdegree{#1}%
}
\degree{}
% 
\newcommand{\semester}{\@dblarg\beamer@semester}
\long\def\beamer@semester[#1]#2{%
  \def\insertsemester{#2}
  \def\insertshortsemester{#1}
}
\semester{}
% 
\let\orig@include\include
\renewcommand{\include}[2][.]{
  \graphicspath{{#1/material/}{#1/images/}}
  \def\pgfpath{#1/material/pgf/}
  \svgsetup{inkscapepath=./#1/images/svg-inkscape}
  \svgpath{{#1/images/}}
%  \def\cppsourcepath{c++sources/#1}
  \orig@include{#1/#2}
}
% 
\newcommand{\setpath}[1]{%
  \graphicspath{{#1/material/}}%
  \def\pgfpath{#1/material/pgf/}%
  \svgsetup{inkscapepath=./#1/images/svg-inkscape}
  \svgpath{{#1/images/}}
%  \def\cppsourcepath{c++sources/#1}%
}
% 
\def\includegraphicswrapper[{\includegraphics[}
% 
\def\pgfinput#1{\input{\pgfpath/#1.pgf}}
% 
\let\orig@lecture\lecture
\newcounter{lastframeoflastlecture}
\setcounter{lastframeoflastlecture}{0}
\renewcommand{\lecture}[3][]{
  \def\insertlecturenumbername{#2}
  \setcounter{lastframeoflastlecture}{\value{framenumber}}
  \date{\insertshortlecture}
  \orig@lecture[#1]{#2}{#3}
}
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
\makeatletter
\ifdefined\@@magyar@captionfix
\else
\let\@@magyar@captionfix\relax
\fi
\makeatother
% 
