\ProvidesClass{fh-ooe}

\RequirePackage{ifthen}
\RequirePackage[T1]{fontenc}

\newboolean{fh-ooe@ispresentation}
\setboolean{fh-ooe@ispresentation}{true}
\newboolean{fh-ooe@ishandout}
\setboolean{fh-ooe@ishandout}{false}
\newboolean{fh-ooe@isprint}
\setboolean{fh-ooe@isprint}{false}

\DeclareOption{handout}{\PassOptionsToClass{handout}{beamer}\setboolean{fh-ooe@ishandout}{true}}
\DeclareOption{print}{\PassOptionsToClass{trans}{beamer}\setboolean{fh-ooe@isprint}{true}}
\DeclareOption{article}{\setboolean{fh-ooe@ispresentation}{false}}
\DeclareOption{draft}{\PassOptionsToClass{draft}{beamer}\PassOptionsToClass{draft}{article}}
\DeclareOption{beamer}{\PassOptionsToClass{beamer}{beamer}}
\ProcessOptions

\ifthenelse{\boolean{fh-ooe@ispresentation}}
{
  % Make beamer to not complain about pdfpagelabels
  \PassOptionsToPackage{pdfpagelabels=false}{hyperref}
  \LoadClass{beamer}
}
{
  \LoadClass{article}
  \RequirePackage{beamerarticle}
}

\RequirePackage[lighttt]{lmodern}
\RequirePackage{listings}

\usetheme{FH-OOE}

\newcommand{\degree}{\@dblarg\beamer@degree}
\long\def\beamer@degree[#1]#2{%
  \def\insertdegree{#2}%
  \def\insertshortdegree{#1}%
}
\degree{}

\newcommand{\semester}{\@dblarg\beamer@semester}
\long\def\beamer@semester[#1]#2{%
  \def\insertsemester{#2}
  \def\insertshortsemester{#1}
}
\semester{}

\def\fhooe@handoutoptions{\setbeamercolor{background canvas}{bg=black!2}}
\def\fhooe@presentationoptions{\beamertemplatenavigationsymbolsempty}

\def\fhooe@handoutlayout{4 on 1}
\def\fhooe@handoutlayoutoptions{[a4paper,border shrink=5mm,landscape]}

\def\fhooe@printlayout{resize to}
\def\fhooe@printlayoutoptions{[a4paper,border shrink=5mm,landscape]}

% Read options from file
\InputIfFileExists{fh-ooe.def.tex}{}{}
\InputIfFileExists{private.def.tex}{}{}

\ifthenelse{\boolean{fh-ooe@isprint}}
{
  \RequirePackage{pgfpages}
  \expandafter\pgfpagesuselayout\expandafter\fhooe@printlayout\fhooe@printlayoutoptions
}
{}

\ifthenelse{\boolean{fh-ooe@ishandout}}
{
  \RequirePackage{pgfpages}
  \expandafter\pgfpagesuselayout\expandafter\fhooe@handoutlayout\fhooe@handoutlayoutoptions
}
{}

\mode<presentation>{\fhooe@presentationoptions}
\mode<handout>{\fhooe@handoutoptions}

\let\orig@include\include
\renewcommand{\include}[2][.]
{
  \graphicspath{{#1/material/}}
  \def\sourcepath{sources/#1/src}
  \orig@include{#1/#2}
}

\def\lstlistingname{\scriptsize Listing}
\newcommand{\includecode}[2][]
{
  \write\srcf{\sourcepath/#2}
  \href{run:\sourcepath/#2}{
    \lstinputlisting[#1]{\sourcepath/#2}
  }
}

\let\orig@lecture\lecture
\newcounter{lastframeoflastlecture}
\setcounter{lastframeoflastlecture}{0}
\renewcommand{\lecture}[3][]{
  \setcounter{lastframeoflastlecture}{\value{framenumber}}
  \date{\insertshortlecture}
  \orig@lecture[#1]{#2}{#3}
}

\AtBeginDocument{\newwrite\srcf\openout\srcf=\jobname.src\write\srcf{\jobname.pdf}}
\AtEndDocument{\closeout\srcf}

\let\orig@document\document
\let\orig@enddocument\enddocument

\renewenvironment{document}[1][]
{
  \def\fhooe@ArgI{{#1}}%
  \documentRelay
}{
  \orig@enddocument
}

\newcommand{\documentRelay}[1][]
{
  \def\fhooe@ArgII{{#1}}
  \gdef\fhooe@maketitle{\relax}

  \ifthenelse{\expandafter\equal\fhooe@ArgI{with titlepage}}
  {
    \gdef\fhooe@maketitle{\maketitle}
    \ifthenelse{\expandafter\equal\fhooe@ArgII{}}
    {}
    {
      \expandafter\includeonlylecture\fhooe@ArgII
    }
  }
  {
    \ifthenelse{\expandafter\equal\fhooe@ArgI{without titlepage}}
    {
      \ifthenelse{\expandafter\equal\fhooe@ArgII{}}
      {}
      {
        \expandafter\includeonlylecture\fhooe@ArgII
      }
    }
    {
      \ifthenelse{\expandafter\equal\fhooe@ArgII{}}
      {
        \ifthenelse{\expandafter\equal\fhooe@ArgI{}}
        {
          \gdef\fhooe@maketitle{\maketitle}
        }
        {
          \expandafter\includeonlylecture\fhooe@ArgI
        }
      }
      {
        \errormessage{Error: Wrong arguments to macro \noexpand\typeset}
      }
    }
  }

  \orig@document
  \fhooe@maketitle
}
