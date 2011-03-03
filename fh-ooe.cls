\ProvidesClass{fh-ooe}

\RequirePackage{ifthen}
\RequirePackage[T1]{fontenc}

\newboolean{fh-ooe@ispresentation}
\setboolean{fh-ooe@ispresentation}{true}
\newboolean{fh-ooe@ishandout}
\setboolean{fh-ooe@ishandout}{false}
\newboolean{fh-ooe@istrans}
\setboolean{fh-ooe@istrans}{false}
\newboolean{fh-ooe@twoscreens}
\setboolean{fh-ooe@twoscreens}{false}

\DeclareOption{handout}{\setboolean{fh-ooe@ishandout}{true}}
\DeclareOption{trans}{\setboolean{fh-ooe@istrans}{true}}
\DeclareOption{article}{\setboolean{fh-ooe@ispresentation}{false}}
\DeclareOption{twoscreens}{\setboolean{fh-ooe@twoscreens}{true}}
%\DeclareOption{handout}{\PassOptionsToClass{handout}{beamer}\setboolean{fh-ooe@ishandout}{true}}
%\DeclareOption{trans}{\PassOptionsToClass{trans}{beamer}\setboolean{fh-ooe@isprint}{true}}
%\DeclareOption{article}{\setboolean{fh-ooe@ispresentation}{false}}
%\DeclareOption{draft}{\PassOptionsToClass{draft}{beamer}\PassOptionsToClass{draft}{article}}
%\DeclareOption{beamer}{\PassOptionsToClass{beamer}{beamer}}
%\DeclareOption{utf8}{\PassOptionsToClass{utf8}{beamer}}
%\DeclareOption{utf8x}{\PassOptionsToClass{utf8x}{beamer}}
%\DeclareOption{ucs}{\PassOptionsToClass{ucs}{beamer}}

\ProcessOptions

\ifthenelse{\boolean{fh-ooe@ispresentation}}{
  % Make beamer to not complain about pdfpagelabels
%  \PassOptionsToPackage{pdfpagelabels=false}{hyperref}
  \LoadClassWithOptions{beamer}[2010/06/21]
}{
  \LoadClassWithOptions{article}
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
\def\fhooe@handoutlayoutoptions{[a4paper,landscape,border shrink=5mm]}

\def\fhooe@printlayout{fhooe resize to}
\def\fhooe@printlayoutoptions{[a4paper,border shrink=5mm]}

\RequirePackage{pgfpages}

\pgfpagesdeclarelayout{fhooe resize to}
{
  \def\pgfpageoptionborder{0pt}
}
{
  \pgfpagesphysicalpageoptions
  {%
    logical pages=1,%
    physical height=\pgfpageoptionheight,%
    physical width=\pgfpageoptionwidth%
  }
  \pgfpageslogicalpageoptions{1}
  {%
    resized width=\pgfphysicalwidth,%
    resized height=\pgfphysicalheight,%
    border shrink=\pgfpageoptionborder,%
    center=\pgfpoint{.5\pgfphysicalwidth}{.73\pgfphysicalheight}%
  }%
}

\ifthenelse{\boolean{fh-ooe@istrans}}{
  \RequirePackage{pgfpages}
  \expandafter\pgfpagesuselayout\expandafter\fhooe@printlayout\fhooe@printlayoutoptions
}{}

\ifthenelse{\boolean{fh-ooe@ishandout}}{
  \RequirePackage{pgfpages}
  \expandafter\pgfpagesuselayout\expandafter\fhooe@handoutlayout\fhooe@handoutlayoutoptions
}{}

% \ifthenelse{\boolean{fh-ooe@twoscreens}}{
%   \RequirePackage{pgfpages}
%   \pgfpagesdeclarelayout{twoscreens}{
%     \beamer@twoscreenstexttrue
%     \nofiles
%   }{
%     \pgfpagesphysicalpageoptions{%
%       logical pages=2,
%       physical width=2960px,
%       physical height=1050px,
%       last logical shipout=1
%     }
%     \pgfpageslogicalpageoptions{1}{%
%       resized width=1400px,
%       resized height=1050px,
%       center=\pgfpoint{839.5px}{524.5px}
%     }%
%     \pgfpageslogicalpageoptions{2}
%     {%
%       resized width=1280px,
%       resized height=960px,
%       center=\pgfpoint{2320.5px}{537.5px},
%       copy from=1
%     }
%   }
%   \pgfpagesuselayout{twoscreens}
% %  \AtBeginDocument{\pgfpagescurrentpagewillbelogicalpage{2}}
% }{}

\mode<presentation>{\fhooe@presentationoptions}
\mode<handout>{\fhooe@handoutoptions}

\let\orig@include\include
\renewcommand{\include}[2][.]{
  \graphicspath{{#1/material/}}
  \def\javasourcepath{sources/#1/src}
  \def\cppsourcepath{c++sources/#1}
  \orig@include{#1/#2}
}

\def\includegraphicswrapper[{\includegraphics[}

\def\codelistingname{Listing}
\def\lstlistingname{\codefontsize \codelistingname}

\newcommand\inlinejavacode[1][]{\lstinline[style=eclipse-inline,language=java,#1]}

\newlength{\fhooe@lenaa}%

\newcommand{\includejavacode}[2][]{%
  \lstset{style=eclipse}%
  \settowidth{\fhooe@lenaa}{\lst@numberstyle{88}}%
  \addtolength{\fhooe@lenaa}{\lst@numbersep}%
  \write\srcf{\javasourcepath/#2}%
  \href{run:\javasourcepath/#2}{%
    \vbox{%
      \lstinputlisting[%
        language=java,%
        xleftmargin=\fhooe@lenaa,%
        caption=\codefontfamily #2,%
        #1
      ]{%
        \javasourcepath/#2%
      }%
    }%
  }\\%
}

\newcommand\inlinecppcode[1][]{\lstinline[style=eclipse-inline,language=c++,#1]}

\newcommand{\includecppcode}[2][]{%
  \lstset{style=eclipse,#1}%
  \settowidth{\fhooe@lenaa}{\lst@numberstyle{88}}%
  \addtolength{\fhooe@lenaa}{\lst@numbersep}%
  \write\srcf{\cppsourcepath/#2}%
  \href{run:\cppsourcepath/#2}{%
    \vbox{%
      \lstinputlisting[%
        language=c++,%
        xleftmargin=\fhooe@lenaa,%
        caption=\codefontfamily #2,%
        #1
      ]{%
        \cppsourcepath/#2%
      }%
    }%
  }\\%
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
 \gdef\fhooe@ArgI{{#1}}
 \documentRelay
}{
 \orig@enddocument
}

\newcommand{\documentRelay}[1][]
{
  \gdef\fhooe@ArgII{{#1}}
  \gdef\fhooe@maketitle{\relax}
  \gdef\fhooe@includeonlylecture{\relax}

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
  \fhooe@includeonlylecture
  \fhooe@maketitle
}

% Read options from file
\InputIfFileExists{fh-ooe.def.tex}{}{}
\InputIfFileExists{private.def.tex}{}{}
\InputIfFileExists{experimental.def.tex}{}{}
