\ProvidesClass{fh-ooe}

\RequirePackage{ifthen}
\RequirePackage{kvoptions}
\RequirePackage{etex}

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
  \LoadClassWithOptions{beamer}[2010/06/21]
  \RequirePackage{fh-ooe.multiscreen}
\else
  \LoadClassWithOptions{\fhooe@article}
  \RequirePackage{beamerarticle}
  \RequirePackage{hyperref}
\fi

\hypersetup{bookmarksdepth=paragraph}

\usetheme{FH-OOE}

\RequirePackage[T1]{fontenc}
\RequirePackage{tikz}
\RequirePackage{tikz-uml}
\RequirePackage{tikz-uml-extension}
\RequirePackage[lighttt]{lmodern}
\RequirePackage{listings}
\RequirePackage[scriptsize]{subfigure}
\RequirePackage{caption}
\RequirePackage{xstring}

\DeclareCaptionFont{cap-fh-ooe-red}{\color{fh-ooe-red}}
\captionsetup{format=default,justification=centering,labelformat=simple,labelfont={scriptsize,cap-fh-ooe-red},textfont=scriptsize}

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

\let\orig@include\include
\renewcommand{\include}[2][.]{
  \graphicspath{{#1/material/}}
  \def\pgfpath{#1/material/pgf/}
  \def\javasourcepath{sources/#1/src}
  \def\cppsourcepath{c++sources/#1}
  \orig@include{#1/#2}
}

\newcommand{\setpath}[1]{%
  \graphicspath{{#1/material/}}%
  \def\pgfpath{#1/material/pgf/}%
  \def\javasourcepath{sources/#1/src}%
  \def\cppsourcepath{c++sources/#1}%
}

\def\includegraphicswrapper[{\includegraphics[}

\def\codelistingname{Listing}
\def\lstlistingname{\codelistingname}


\newcommand{\addsourcefile}[1]{%
  \write\srcf{#1}%
}

\newlength{\fhooe@lenaa}%

\newcommand\inlinejavacode[1][]{\lstinline[style=eclipse-inline,language=java,#1]}

\lstnewenvironment{javacode}[1][]{
  \codefontsize
  \lstset{style=eclipse,language=java,#1}%
  \lstset{xleftmargin=\lst@numbersep}%
}{}

\newcommand{\includejavacodenostar}[2][]{%
  \addsourcefile{\javasourcepath/#2}%
  \href{run:\javasourcepath/#2}{%
    \hspace*{-\@itemdepth\leftmargin}%
    \vbox{%
      \lstinputlisting[%
        language=java,%
        style=eclipse,%
        xleftmargin=\lst@numbersep,%
        caption=\codefontfamily #2,%
        #1%
      ]{%
        \javasourcepath/#2%
      }%
    }%
  }%
}%

\newcommand{\includejavacodestar}[2][]{%
  \hspace*{-\@itemdepth\leftmargin}%
  \vbox{%
    \lstinputlisting[%
      language=java,%
      style=eclipse,%
      xleftmargin=\lst@numbersep,%
      #1
    ]{%
      \javasourcepath/#2%
    }%
  }%
}%


\newcommand{\includejavacode}{\@ifstar
  \includejavacodestar%
  \includejavacodenostar%
}

\newcommand{\includejavacodeinpackagenostar}[3][]{%
  \StrSubstitute{#2}{.}{/}[\mydef]%
  \expandafter\addsourcefile\expandafter{\expandafter\javasourcepath\expandafter/\mydef/#3}%
  \href{run:\javasourcepath/\mydef/#3}{%
    \hspace*{-\@itemdepth\leftmargin}%
    \vbox{%
      \lstinputlisting[%
        language=java,%
        style=eclipse,%
        xleftmargin=\lst@numbersep,%
        caption=\codefontfamily #3,%
        #1
      ]{%
        \javasourcepath/\mydef/#3%
      }%
    }%
  }%
%  \StrSubstitute{#2}{.}{/}[\mydef]%
%  \codefontsize%
%  \lstset{style=eclipse}%
%  \settowidth{\fhooe@lenaa}{\lst@numberstyle{88}}%
%  \addtolength{\fhooe@lenaa}{\lst@numbersep}%
%  \expandafter\addsourcefile\expandafter{\expandafter\javasourcepath\expandafter/\mydef/#3}%
%  \href{run:\javasourcepath/\mydef/#3}{%
%    \vbox{%\hbox{%
%      \lstinputlisting[%
%        language=java,%
%        xleftmargin=\fhooe@lenaa,%
%        caption=\codefontfamily #3,%
%        #1
%      ]{%
%        \javasourcepath/\mydef/#3%
%      }%
%    }%}%
%  }%\\%
}%

\newcommand{\includejavacodeinpackagestar}[3][]{%
  \StrSubstitute{#2}{.}{/}[\mydef]%
  \hspace*{-\@itemdepth\leftmargin}%
  \vbox{%
    \lstinputlisting[%
      language=java,%
      style=eclipse,%
      xleftmargin=\lst@numbersep,%
      #1
    ]{%
      \javasourcepath/\mydef/#3%
    }%
  }%
%  \StrSubstitute{#2}{.}{/}[\mydef]%
%  \codefontsize%
%  \lstset{style=eclipse}%
%  \settowidth{\fhooe@lenaa}{\lst@numberstyle{88}}%
%  \addtolength{\fhooe@lenaa}{\lst@numbersep}%
%  \vbox{%\hbox{%
%    \lstinputlisting[%
%      language=java,%
%      xleftmargin=\fhooe@lenaa,%
%      #1
%    ]{%
%      \javasourcepath/\mydef/#3%
%    }%
%  }%}%
}

\newcommand{\includejavacodeinpackage}{\@ifstar
  \includejavacodeinpackagestar%
  \includejavacodeinpackagenostar%
}

\newcommand\inlinecppcode[1][]{\lstinline[style=eclipse-inline,language=c++,#1]}

\lstnewenvironment{cppcode}[1][]{
  \lstset{style=eclipse,language=c++,#1}%
  \lstset{xleftmargin=\lst@numbersep}%
}{}

\newcommand{\@cppcoderangerelay}[3][]{%
  \edef\@eargs{[linerange=#2-#2,firstnumber=#2,\@begarg,#1]{#3}}
  \def\@endcmd{\expandafter\includecppcode\@eargs}
  \newcommand\range[3][]{%
    \edef\@rargs{[linerange=##2-##3,firstnumber=##2,#1,caption=,\@begarg,##1]{#3}}
    \expandafter\includecppcode\@rargs
  }
  \edef\@sargs{[linerange=1-1,caption=,\@begarg]{#3}}
  \expandafter\includecppcode\@sargs%
}

\newenvironment{cppcoderange}[1][]{%
  \def\@begarg{#1}%
  \@cppcoderangerelay%
}{
  \@endcmd%
  \ignorespacesafterend%
}%

\newcommand{\includecppcode}[2][]{%
  \addsourcefile{\cppsourcepath/#2}%
  \href{run:\cppsourcepath/#2}{%
    \vbox{
      \lstinputlisting[%
        language=c++,%
        style=eclipse,%
        xleftmargin=\lst@numbersep,%
        resetmargins=true,%
        caption=\codefontfamily #2,%
        #1%
      ]{%
        \cppsourcepath/#2%
      }%
    }%
  }%
%  \codefontsize
%  \lstset{style=eclipse,#1}%
%  \settowidth{\fhooe@lenaa}{\lst@numberstyle{88}}%
%  \addtolength{\fhooe@lenaa}{\lst@numbersep}%
%  \addsourcefile{\cppsourcepath/#2}%
%  \href{run:\cppsourcepath/#2}{%
%    \makebox[\linewidth][l]{
%      \lstinputlisting[%
%        language=c++,%
%        xleftmargin=\fhooe@lenaa,%
%        caption=\codefontfamily #2,%
%        #1
%      ]{%
%        \cppsourcepath/#2%
%      }%
%    }
%  }
}

\lstnewenvironment{cppapi}[1][]{
  \lstset{%
    style=eclipse,
    language=c++,
    basicstyle=\normalsize\codefontfamily,
    resetmargins=true,
    xleftmargin=\lst@numbersep,
    numbers=none,
    #1
  }%
}{}

\def\pgfinput#1{\input{\pgfpath/#1.pgf}}

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
  \gdef\fhooe@ArgI{{#1}}
  \fhooe@documentRelay
}{
  \orig@enddocument
}

\newcommand{\fhooe@documentRelay}[1][]
{
  \gdef\fhooe@ArgII{{#1}}
  \gdef\fhooe@maketitle{}%\relax}
  \gdef\fhooe@includeonlylecture{}%\relax}

  \ifthenelse{\expandafter\equal\fhooe@ArgI{with titlepage}}{
    \gdef\fhooe@maketitle{\maketitle}
    \ifthenelse{\expandafter\equal\fhooe@ArgII{}}
    {}{
      \gdef\fhooe@includeonlylecture{\expandafter\includeonlylecture\fhooe@ArgII}
    }
  }{
    \ifthenelse{\expandafter\equal\fhooe@ArgI{without titlepage}}{
      \ifthenelse{\expandafter\equal\fhooe@ArgII{}}
      {}{
        \gdef\fhooe@includeonlylecture{\expandafter\includeonlylecture\fhooe@ArgII}
      }
    }{
      \ifthenelse{\expandafter\equal\fhooe@ArgII{}}{
        \ifthenelse{\expandafter\equal\fhooe@ArgI{}}{
          \gdef\fhooe@maketitle{\maketitle}
        }{
          \gdef\fhooe@includeonlylecture{\expandafter\includeonlylecture\fhooe@ArgI}
        }
      }{
        \errormessage{Error: Wrong arguments to macro \noexpand\typeset}
      }
    }
  }

  \orig@document
%  \fhooe@maketitle
  \fhooe@includeonlylecture
}

\def\fhooepresentationoptions{\beamertemplatenavigationsymbolsempty}

\mode<presentation>{\fhooepresentationoptions}

% Read options from file
\InputIfFileExists{fh-ooe.def.tex}{}{}
\InputIfFileExists{private.def.tex}{}{}
\InputIfFileExists{experimental.def.tex}{}{}
