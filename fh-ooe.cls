\ProvidesClass{fh-ooe}
% 
\RequirePackage{kvoptions}
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
% 
\hypersetup{bookmarksdepth=paragraph}
% 
\usetheme{FH-OOE}
% 
\setbeamersize{
  text margin left=10mm,
  text margin right=10mm,
  sidebar width left  = 0mm,
  sidebar width right = 0mm
}
%
% 
\let\orig@include\include
\renewcommand{\include}[2][.]{
  \setpath{#1}
  \orig@include{#1/#2}
}
% 
\newcommand{\setpath}[1]{%
  \graphicspath{{#1/}}%{#1/material/}{#1/images/}}%
  \def\pgfpath{#1/material/pgf/}%
  \svgsetup{inkscapepath=#1/images/svg-inkscape}
  \svgpath{{#1/}}%{#1/images/}}
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
    \setpath{#1}
    \app@exe{rm -f #1/\jobname.tmp}
    \app@exe{find #1 -maxdepth 1 -type f -name '*.tex' -not -path '*/sav/*' | sort | xargs cat >> #1/\jobname.tmp}%
%    \app@exe{ls #1/*.tex >> #1/out.tmp}%
%    \app@exe{find #1 -type f \\( -name '*.tex' \\) | sort | xargs cat >> #1/\jobname.tmp}%
%    \app@exe{ls #1/*.tex | xargs cat >> #1/\jobname.tmp}%
%    \app@exe{ls #1/*.tex | xargs -n1 /bin/bash -c 'echo "{" >> #1/\jobname.tmp ; cat "$@" >> #1/\jobname.tmp ; echo "}" >> #1/\jobname.tmp ;' ''}
    \InputIfFileExists{#1/\jobname.tmp}{}{}%
%    \AtEndDocument{\app@exe{rm -f #1/\jobname.tmp}}%
  }
\makeatother
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
