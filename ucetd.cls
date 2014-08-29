\NeedsTeXFormat{LaTeX2e}[1995/06/01]
\ProvidesClass{ucetd}[2014/08/28 University of Chicago Electronic Theses and Dissertations]

%%%%%%%%%%%%%%%%%%%%%%%%% Helper commands %%%%%%%%%%%%%%%%%%%%%%%%%

% These commands deal with options that set variables
\newcommand{\etdDeclVarArg}[2]{\newcommand{#1}{#2}}
\newcommand{\etdVarArg}[3]{\DeclareOption{#2}{\renewcommand{#1}{#3}}}

% These commands deal with options that execute latex
\newcommand{\etdDeclArg}[2]{#2}
\newcommand{\etdArg}[2]{\DeclareOption{#1}{#2}}

% Declare a super class and pass it remaining unprocessed arguments
\newcommand{\etdSuperClass}[2]{
	\DeclareOption*{\PassOptionsToClass{\CurrentOption}{#1}}
	\ProcessOptions\relax
	\LoadClass[#2]{#1}
}

% Default copyright text
\newcommand{\etdCopyrightText}{
	\null\vfill
	\centerline{Copyright \copyright\ \number\year\ by \@author}
	\centerline{All Rights Reserved}
	\vskip 15pt\relax
}

% Preliminary sections following the table of contents and preceding the body are front matter
\newcommand{\etdFrontMatter}[1]{
	\chapter*{#1}
	\addcontentsline{toc}{chapter}{#1}
}

% Special front matter that appears before the table of contents
\newcommand{\etdPreTOCMatter}[1]{
	\chapter*{}
	\thispagestyle{empty}
	\begin{center}
		#1
	\end{center}
}

% Starts the main matter of the document
\newcommand{\etdMainMatter}{
	\clearpage
	% Switch to arabic numbers on pages
	\pagenumbering{arabic}
}

% Commands to follow the title page
\newcommand{\etdPostTitle}{
	% Setup page numbering
	\pagenumbering{roman}
	\addtocounter{page}{1}
}

% UC ETD title page format
\newcommand{\etdTitlePage} {
	\begin{titlepage}
		\begin{center}
			\rule{0in}{0.55in} % Artificial extra [old=0.95in] margin. Why not vspace?
			THE UNIVERSITY OF CHICAGO\\
			\vspace{0.8in}
			\MakeUppercase{\@title}\\
			\vspace{0.8in}
			A DISSERTATION SUBMITTED TO\\
			THE FACULTY OF THE DIVISION OF THE \MakeUppercase{\@division}\\
			IN CANDIDACY FOR THE DEGREE OF\\
			\MakeUppercase{\@degree}\\
			\ \\
			DEPARTMENT OF \MakeUppercase{\@department}\\
			\vspace{0.8in}
			BY\\
			\MakeUppercase{\@author}\\
			\vspace{0.8in}
			CHICAGO, ILLINOIS\\
			\MakeUppercase{\@date}
			\vspace*{0.45in}
		\end{center}
	\end{titlepage}
}

%UC ETD title page defaults
\def\@title{\textbf{Title??}}
\def\@division{Physical Sciences}  % Probably correct for the majority of students using LaTeX
\def\@degree{Doctor of Philosophy}
\def\@department{\textbf{Department Name (e.g., Mathematics)??}}
\def\@author{\textbf{Author's name??}}
\def\@date{\textbf{June 1985??}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%
%% Load required packages
%%

% Use the T1 font Latin Modern instead of the default Computer Modern:
\RequirePackage{lmodern}

% Double-spacing commands:
\RequirePackage{setspace}[1998/04/8]

% A useful package for modifying existing commands and environments:
\RequirePackage{etoolbox}

% A change to the equation number assumes this package has been loaded.
\RequirePackage{amsmath}

% A useful package for changing the behavior of list environments (enumerate, itemize, description)
% This package will be loaded for real later; to load it before the superclass causes an error.
%\RequirePackage{enumitem}

%%
%% Default Settings
%%

% Default font point size
\newcommand{\etdDefaultPointSize}{12pt}

% Default line spacing
%\newcommand{\etdDefaultSpacing}{\setstretch{1.37}}
\newcommand{\etdDefaultSpacing}{\doublespacing}

% Parent document class
\newcommand{\etdParentClass}{report}

% Adds to the margin size (initially 1in)
\newcommand{\etdMarginAdjust}{0.0in}
\newcommand{\etdHeadingMarginAdjust}{0.0in}


%%
%% Declare arguments/options
%%

% Chapter Style Options
\newcommand{\etdChapterStyle}[1]{\MakeUppercase{#1}}
\DeclareOption{plainchapterheads}{\renewcommand{\etdChapterStyle}[1]{#1}}

% Options for setting point size
\etdDeclVarArg{\etdPtSize}{\etdDefaultPointSize}
\etdVarArg{\etdPtSize}{10pt}{10pt}
\etdVarArg{\etdPtSize}{11pt}{11pt}
\etdVarArg{\etdPtSize}{12pt}{12pt}

% Option for using letter paper
\etdArg{letterpaper}{\PassOptionsToClass{letterpaper}{report}}

% Options to set spacing
\etdDeclVarArg{\etdSpacing}{\etdDefaultSpacing}
\etdVarArg{\etdSpacing}{doublespace}{\doublespacing}
\etdVarArg{\etdSpacing}{defaultspace}{\etdDefaultSpacing}
\etdVarArg{\etdSpacing}{onehalfspace}{\onehalfspace}
\etdVarArg{\etdSpacing}{singlespace}{\singlespace}

% Options to set chapter head style
\newcommand{\etdChapterHeadFormat}[1]{\MakeUppercase{#1}}
\etdArg{plainchaptertitles}{\renewcommand{\etdChapterHeadFormat}[1]{#1}}
\etdArg{capschaptertitles}{\newcommand{\etdChapterHeadFormat}[1]{\MakeUppercase{#1}}}

% Option for "safe" use only (avoid fancy changes to spacing and $$):
\newif\ifetd@safe
\etd@safefalse
\etdArg{safe}{\etd@safetrue}

%%
%% Load superclass for document
%%

\etdSuperClass{\etdParentClass}{\etdPtSize}


%%
%% Do some init stuff
%%

% Ported from old file, sets up spacing between footnotes
\RequirePackage[splitrule]{footmisc}
\setlength{\footnotesep}{\baselineskip}
\let\oldfootnoterule = \footnoterule
\renewcommand{\footnoterule}{\kern 0.4\footnotesep\oldfootnoterule\kern-0.4\footnotesep}
\renewcommand{\@makefntext}[1]{\noindent\makebox[2.5em][r]{\@thefnmark.\ }#1}

% Setup default size of math text
\AtBeginDocument{\DeclareMathSizes{12}{12}{10}{8}}

% Redefine \normalsize, \small, and \footnotesize to avoid playing with the 
% displaymath spacing, which is a little bit delicate. Only the 12pt-options are used, 
% for simplicity. These definitions are copied from those of report.cls, but with the 
% code to modify displaymath spacing eliminated.
\renewcommand{\normalsize}{%
    \@setfontsize\normalsize\@xiipt{14.5}%
    \let\@listi\@listI
}
\renewcommand{\small}{%
   \@setfontsize\small\@xipt{13.6}%
   \def\@listi{\leftmargin\leftmargini
               \topsep 9\p@ \@plus3\p@ \@minus5\p@
               \parsep 4.5\p@ \@plus2\p@ \@minus\p@
               \itemsep \parsep}%
}
\renewcommand{\footnotesize}{%
   \@setfontsize\footnotesize\@xpt\@xiipt
   \def\@listi{\leftmargin\leftmargini
               \topsep 6\p@ \@plus2\p@ \@minus2\p@
               \parsep 3\p@ \@plus2\p@ \@minus\p@
               \itemsep \parsep}%
}

% Require that equation numbers always be the same size. This only works
% if amsmath has been loaded.
\renewcommand{\maketag@@@}[1]{\hbox{\m@th\normalsize\normalfont#1}}%

% Record the "classic" baselineskip before changing it to double-spacing
\newdimen\etdOldBaselineskip
\etdOldBaselineskip=\baselineskip%
\newdimen\etdNormalSep

% Setup spacing
\etdSpacing

% Compute "normal separation"
\etdNormalSep=\dimexpr\baselineskip-0.9\etdOldBaselineskip\relax

% Use traditional line separation parameters when switching to single-spacing
\appto\singlespacing{\lineskiplimit=0pt%
    \lineskip=1pt%
    }
    
\def\etd@singleSpaceExtras{%
    \lineskiplimit=0pt%
    \lineskip=1pt%
    \ifetd@safe\else
        \abovedisplayskip=0pt%
        \belowdisplayskip=0pt%
    \fi
}
    
\AtBeginEnvironment{singlespace}{%
    \etd@singleSpaceExtras
    }

\AtBeginEnvironment{singlespace*}{%
    \etd@singleSpaceExtras
    }

% Make the quote, quotation, and (various kinds of) list environments use single-spacing
\BeforeBeginEnvironment{quote}{\par\begin{singlespace*}}
\AfterEndEnvironment{quote}{\end{singlespace*}}

\BeforeBeginEnvironment{quotation}{\par\begin{singlespace*}}
\AfterEndEnvironment{quotation}{\end{singlespace*}}

\BeforeBeginEnvironment{itemize}{\par\begin{singlespace*}}
\AfterEndEnvironment{itemize}{\end{singlespace*}}

\BeforeBeginEnvironment{enumerate}{\par\begin{singlespace*}}
\AfterEndEnvironment{enumerate}{\end{singlespace*}}

\BeforeBeginEnvironment{description}{\par\begin{singlespace*}}
\AfterEndEnvironment{description}{\end{singlespace*}}

\RequirePackage{enumitem}
% partopsep is additional space added above a list that begins a new paragraph. 
% Unfortunately, after the preceeding changes, every list begins a new paragraph,
% so this should no longer be meaningful.
\setlist{partopsep=0pt}

% Alter some LaTeX defaults for better treatment of figures:
    % See p.105 of "TeX Unbound" for suggested values.
    % See pp. 199-200 of Lamport's "LaTeX" book for details.
    %   General parameters, for ALL pages:
    \renewcommand{\topfraction}{0.9}	% max fraction of floats at top
    \renewcommand{\bottomfraction}{0.8}	% max fraction of floats at bottom
    %   Parameters for TEXT pages (not float pages):
    \setcounter{topnumber}{2}
    \setcounter{bottomnumber}{2}
    \setcounter{totalnumber}{4}     % 2 may work better
    \setcounter{dbltopnumber}{2}    % for 2-column pages
    \renewcommand{\dbltopfraction}{0.9}	% fit big float above 2-col. text
    \renewcommand{\textfraction}{0.07}	% allow minimal text w. figs
    %   Parameters for FLOAT pages (not text pages):
    \renewcommand{\floatpagefraction}{0.7}	% require fuller float pages
	% N.B.: floatpagefraction MUST be less than topfraction !!
    \renewcommand{\dblfloatpagefraction}{0.7}	% require fuller float pages
    


%%%%%%%%%%%%%%%% Vertical spacing for displayed math %%%%%%%%%%%%%%%%%%

\ifetd@safe

	\AtBeginDocument{%
	    \abovedisplayshortskip=0pt%
	    \belowdisplayshortskip=0pt%
	    \abovedisplayskip=4pt%
	    \belowdisplayskip=4pt%
	    \lineskiplimit=0pt%
	    \lineskip=6pt%
	    \jot=0pt%
	    }
	

\else
	
	% Set new defaults for the spacing when symbols are tall, and also above and below displayed math.
	\AtBeginDocument{%
	    \abovedisplayshortskip=0pt%
	    \belowdisplayshortskip=0pt%
	    \abovedisplayskip=3pt%
	    \belowdisplayskip=3pt%
	    \lineskiplimit=3pt%
	    \lineskip=3pt%
	    \jot=0pt%
	    }
	
	% Change the spacing between lines within displayed math. This also affects what happens above and below it.
	% WARNING: None of this will work correctly if the TEX primitive $$ is used for displayed math
	% rather than \[...\] or the ams environments (or even eqnarray).
	\everydisplay{\lineskiplimit=0.9\etdNormalSep%
	    \lineskip=\etdNormalSep%
	    \normallineskiplimit=\etdNormalSep%
	    \let\strut@=\relax%
	    \setbox\strutbox=\hbox{\vrule height12pt depth4pt width0pt}%
	    \aftergroup\etdBelowDisplay%
	    }
	\def\etdBelowDisplay{%
	    \let\oldBaselineskip=\baselineskip%
	    \baselineskip=0pt%
	    \par\rule{0pt}{0pt}%
	    \vskip-1ex%
	    \let\baselineskip=\oldBaselineskip%
	    \noindent%
	    }
	
	% Redefine $$ to work like \[ ... \] so that the above code still works.
	{
	\gdef\etd@inactiveDollar{$}
	\catcode`\$=\active
	\gdef\etd@DDollar{%
	        \ifinner
	            \expandafter\@firstoftwo
	        \else
	            \expandafter\@secondoftwo
	        \fi
	        \etd@inactiveDollar
	        \etd@DDollarOuter
	    }
	\gdef\etd@DDollarOuter${%
	        \ifmmode%
	            \let\next=\]%
	        \else%
	            \let\next=\[%
	        \fi%
	        \next%
	    }
	\protected\gdef${\new@ifnextchar$\etd@DDollar\etd@inactiveDollar}
	}
	\AtBeginDocument{\catcode`\$=\active
	    \@ifpackageloaded{tikz}%
	    {\preto\tikzpicture{\catcode`$=3}%
	     \preto\tikz{\catcode`$=3}}%
	     {}%
	}

\fi

%%%%%%%%%%%%%%%%%%%%%%%%% User Commands %%%%%%%%%%%%%%%%%%%%%%%%%%

% Define text to go on the dedication/copyright/epigraph page

% Usage:
%	\dedication{dedication text}
\newcommand{\dedication}[1]{\newcommand{\etdDedicationText}{#1}}
% Usage:
%	\epigraph{epigraph text}
\newcommand{\epigraph}[1]{\newcommand{\etdEpigraphText}{#1}}

% Output a dedication/copyright/epigraph page
\newcommand{\makededication}{\etdPreTOCMatter{\etdDedicationText}}
\newcommand{\makecopyright}{\etdPreTOCMatter{\etdCopyrightText}}
\newcommand{\makeepigraph}{\etdPreTOCMatter{\etdEpigraphText}}

% Begin an abstract or acknowledgements page
\renewcommand{\abstract}{\etdFrontMatter{Abstract}}
\renewcommand{\endabstract}{}
\newcommand{\acknowledgments}{\etdFrontMatter{Acknowledgments}}

% Start the main thesis body
\newcommand{\mainmatter}{\etdMainMatter}

% Bibliography
% The command to show the bibliography is \makebibliography
%
% If using bibtex, the command \makebibliography takes a single argument: a list of 
% all the reference files (not including the .bib suffix)
%
% If using biblatex, the command \makebibliography takes no arguments. Instead, the 
% files should be specified using \addbibresource as usual.
\AtBeginDocument{%
    \@ifpackageloaded{biblatex}{%
        \newcommand{\makebibliography}{%
            \newpage
            \addcontentsline{toc}{chapter}{References}
            \begin{singlespace}
                \printbibliography
            \end{singlespace}
        }
    }{% else: biblatex not loaded
        \newcommand{\makebibliography}[1]{
            \newpage
            \addcontentsline{toc}{chapter}{References}
            \begin{singlespace}
                \bibliography{#1}
            \end{singlespace}
        }
    }
}


% This command causes a line to be added at the end of the table of contents
% designating a supplementary file (e.g., a video).
\newcommand{\supplementaryfile}[2][(supplementary file)]{%
    \AtEndEnvironment{document}{%
        \addtocontents{toc}{\protect\contentsline{supplementaryfile}{#2}{#1}}%
    }%
}

%
% Title page related commands
%
\def\etd@space{ } % Used to issue warnings below.

% Basic information
\renewcommand{\title}[1]{\gdef\@title{#1}}
\renewcommand{\author}[1]{\gdef\@author{#1}}
\newcommand{\department}[1]{\gdef\@department{#1}}
\let\departmentname=\department%% An alternative provided for consistency
\ifetd@safe\else
	\newcommand{\division}[1]{\gdef\@division{#1}%% Deprecated: Use \divisionname
	    \ClassWarning{ucetd}{The \protect\division\etd@space command is deprecated, since it might^^J% 
	    potentially conflict with a math macro.^^J%
	    Use \protect\divisionname\etd@space instead}
	}
	\newcommand{\degree}[1]{\gdef\@degree{#1}%% Deprecated: Use \degreename
	    \ClassWarning{ucetd}{The \protect\degree\etd@space command is deprecated, since it might^^J%
	    conflict with a math macro (e.g., the \protect\degree\etd@space macro defined by mathabx).^^J%
	    Use \protect\degreename\etd@space instead}
	}
\fi
\newcommand{\divisionname}[1]{\gdef\@division{#1}}% An alternative that avoids conflict with a possible math macro called \division
\newcommand{\degreename}[1]{\gdef\@degree{#1}}% An alternative that avoids conflict with a possible math macro called \degree
\renewcommand{\date}[1]{\gdef\@date{#1}}

% Output title page
\renewcommand{\maketitle}{
	\etdTitlePage
	\etdPostTitle
}

% You MUST call this command where the title would normally be if you omit the title page
\newcommand{\omittitle}{\etdPostTitle}

%%%%%%%%%%%%%% Double-spaced list environments %%%%%%%%%%%%%%%%%%%%%%

%Defined using enumitem
\newlist{enumerateDS}{enumerate}{4}
\setlist[enumerateDS,1]{label=\arabic*.}
\setlist[enumerateDS,2]{label=(\alph*)}
\setlist[enumerateDS,3]{label=\roman*.}
\setlist[enumerateDS,4]{label=\Alph*.}
\setlist[enumerateDS]{nosep}

\newlist{itemizeDS}{itemize}{4}
\setlist[itemizeDS,1]{label=\textbullet}
\setlist[itemizeDS,2]{label=\normalfont\bfseries\textendash}
\setlist[itemizeDS,3]{label=\textasteriskcentered}
\setlist[itemizeDS,4]{label=\textperiodcentered}
\setlist[itemizeDS]{nosep}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%% Patch \degree to avoid conflicts with mathabx package, which defines \degree to be a circle symbol
%% This patch may have unforeseen consequences, so the 'safe' option disables it.
%% To use the mathabx package with the 'safe' option, comment out the earlier line defining degree, 
%% and use \degreename instead of \degree in your document.
%%
\ifetd@safe\else
	\let\etd@old@onefilewithoptions=\@onefilewithoptions
	\def\etd@PackageNameDefinesDegree{mathabx}
	\def\@onefilewithoptions#1[#2][#3]#4{%
	        \def\etd@temp{#1}%
	        % If mathabx is to be loaded, then temporarily undefine degree
	        \ifx\etd@temp\etd@PackageNameDefinesDegree
	            \let\etd@degree=\degree
	            \let\degree=\relax%
	        \fi
	        % Load whatever package was supposed to be loaded
	        \etd@old@onefilewithoptions{#1}[#2][#3]{#4}%
	        % If mathabx was just loaded, then save the new definition of degree to be restored after the preamble
	        \ifx\etd@temp\etd@PackageNameDefinesDegree
	            \global\let\etd@mathabx@degree=\degree
	            \let\degree=\etd@degree
	            \AtEndPreamble{\let\degree=\etd@mathabx@degree}%
	        \fi
	    }
\fi

%%%%%%%%%%%%%%%%%%%%%%%%% Internal Formatting %%%%%%%%%%%%%%%%%%%%%%%%%
%
% The following was mostly ported from ccw_chithesis_YH with a few modifications
%


% Chapter/Section formatting
\renewcommand{\@makechapterhead}[1]{{

        \setlength{\topmargin}{0.5in}  	% really 1.5in, added by bph
                                      			% to meet OAP standards
        \normalfont\large\bfseries
        \begin{center}
        \etdChapterStyle{\@chapapp{ \thechapter}}  %  CHAPTER # or APPENDIX
        
        
        \etdChapterStyle{#1}                       %     TITLE OF CHAPTER
        \end{center}
        \setlength{\topmargin}{0in}   % back to 1in

}}
\renewcommand{\@makeschapterhead}[1]{{  
        \setlength{\topmargin}{0.5in}   % really 1.5in, added by bph
                                        % to meet OAP standards
        \normalfont\large\bfseries
        \begin{center}
        \etdChapterHeadFormat{#1}                       %     TITLE OF CHAPTER
        \end{center}
        \setlength{\topmargin}{0in}   % back to 1in
}}

% Ported from report.cls and edited to make the contents line will include the prefix "Chapter" 
% or "Appendix" as appropriate. The original had some additional code designed to 
% handle two-column documents; this code was not ported.
\def\@chapter[#1]#2{%
    \ifnum \c@secnumdepth >\m@ne
        \refstepcounter{chapter}%
        \typeout{\@chapapp\space\thechapter.}%
        \addcontentsline{toc}{chapter}{\@chapapp{ \thechapter}\hspace{1em}#1}%
    \else
        \addcontentsline{toc}{chapter}{#1}%
    \fi
    \chaptermark{#1}%
    \addtocontents{lof}{\protect\addvspace{10\p@}}%
    \addtocontents{lot}{\protect\addvspace{10\p@}}%
    \@makechapterhead{#2}%
    \@afterheading%
    }

% Ported from report.cls and edited to make the contents line will include the prefix "Part" 
% and to omit the page number from the page introducing the part.
% The original had some additional code designed to 
% handle two-column documents; this code was not ported.
\def\@part[#1]#2{%
    \ifnum\c@secnumdepth >-2\relax
        \refstepcounter{part}%
        \addcontentsline{toc}{part}{Part{} \thepart\hspace{1em}#1}%
    \else
        \addcontentsline{toc}{part}{#1}%
    \fi
    \markboth{}{}%
    {\thispagestyle{empty}%
     \centering
     \interlinepenalty \@M
     \normalfont
     \ifnum \c@secnumdepth >-2\relax
       \huge\bfseries \partname\nobreakspace\thepart
       \par
       \vskip 20\p@
     \fi
     \Huge \bfseries #2\par}%
    \@endpart}

\renewcommand\section{\@startsection {section}{1}{\z@}%
                                {-3.5ex \@plus -1ex \@minus -.2ex}%
                                {2.3ex \@plus.2ex}%
                                {\normalfont\large\bfseries\centering}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                {-3.25ex\@plus -1ex \@minus -.2ex}%
                                {1.5ex \@plus .2ex}%
                                {\normalfont\large\itshape\centering}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                {-3.25ex\@plus -1ex \@minus -.2ex}%
                                {1.5ex \@plus .2ex}%
                                {\normalfont\large}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                {3.25ex \@plus1ex \@minus.2ex}%
                                {-1em}%
                                {\normalfont\normalsize\bfseries}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                {3.25ex \@plus1ex \@minus .2ex}%
                                {-1em}%
                                {\normalfont\normalsize\itshape}}

% Command to add a line to the table of contents for a part.
\renewcommand*\l@part[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth plus 2em%% The "plus 2em" allows a "ragged right" setup for long part names
      \parfillskip -\@pnumwidth
      \leavevmode
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      {\bf \etdChapterHeadFormat{#1}}\nobreak
      \hfil \nobreak\hb@xt@\@pnumwidth{\hss}\par
      \penalty\@highpenalty
    \endgroup
  \fi}

% Command to add a line to the table of contents for a chapter.
\renewcommand*\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth plus 2em%% The "plus 2em" allows a "ragged right" setup for long chapter names
      \parfillskip -\@pnumwidth
      \leavevmode
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      \etdChapterHeadFormat{#1}\nobreak
% CCW: The following 3 lines add dots to the chapter TOC listings
      \leaders\hbox{$\m@th
        \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
        mu$}\hfill
      \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}
  
% This is copied with modifications from the \l@chapter command definition. 
% It adds a line to the table of contents for a supplementary file.
\newcommand*\l@supplementaryfile[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth plus 2em%% The "plus 2em" allows a "ragged right" setup for long titles
      \parfillskip -\@pnumwidth
      \leavevmode
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      \etdChapterHeadFormat{#1}\nobreak
% CCW: The following 3 lines add dots to the chapter TOC listings
      \leaders\hbox{$\m@th
        \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
        mu$}\hfill
      \hfil \nobreak{#2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}
 
% Change names of table of contents and bibliography

\renewcommand{\contentsname}{Table of Contents}
\renewcommand{\bibname}{References}

% Change the margins to fit requirements

%%\setlength{\oddsidemargin}{-0.325in}  % really 1.5in
%%\setlength{\evensidemargin}{-0.325in}  % really 1.5in
%\setlength{\oddsidemargin}{0.in}
%\setlength{\evensidemargin}{0.in}
%%\setlength{\textwidth}{6.875in}
%\setlength{\textwidth}{6.5in}
%%\setlength{\topmargin}{0.in}   % really 1in
%\setlength{\headheight}{-0.375in}
%\setlength{\headsep}{0.in}
%%\setlength{\textheight}{8.5in}
%\setlength{\textheight}{9.3in}
%\setlength{\footskip}{0.3in}

%%%%%%
%% Completely re-doing margins --mvz
%% Further modifications --ces
%%%%%%


% The bottom margin is also affected by the footskip
% i.e. the length of the page has the following markers:
% top of text at 1.00in, bottom of text at 10.00in-\baselineskip,
% page number at 10.00in, bottom of page at 11.00in

% The distance between the page number and the bottom of the text
% should be at least as great as the distance between two adjacent lines
\setlength{\footskip}{\baselineskip}

% Main text box is the width/height of the paper minus 2in
\setlength{\textwidth}{6.5in}
\setlength{\textheight}{\dimexpr 9.00in-\footskip} % + footskip = 9.00in

% Only the left and top margins can be defined
% 1in is added to given values
\setlength{\topmargin}{0.0in}
\setlength{\evensidemargin}{0.0in}
\setlength{\oddsidemargin}{0.0in}

% The top margin is also affected by the headhight and headsep
\setlength{\headheight}{0.0in}
\setlength{\headsep}{0.0in}


% Making sure absolutely nothing passes the right margin
%\setlength{\hfuzz}{0.0pt}

% Allow for stretching to avoid overfull hboxes
\setlength{\emergencystretch}{0.5\textwidth}

% Changing where the page numbers go on pages that aren't the first
% page of a chapter.

%\pagestyle{myheadings}
%\pagestyle{plain}
%\markright{}

% Make the table of contents, etc.,  single spaced
%
% bph added lists of tables/figures to table of contents.
% CCW fixed bug where multipage LOT/LOF were listed in TOC with wrong
% page number.
%
% CES set high pretolerance to reduce hyphenation within the TOC

\let\oldtableofcontents = \tableofcontents
\renewcommand{\tableofcontents}{
  \begin{singlespace}\pretolerance=500
    \oldtableofcontents
  \end{singlespace}
}

% The following defines the list of tables and figures and removes any
% indentations. If your latex compiler has different default options, you'll
% need to change the following.

\renewcommand*{\l@table}{\@dottedtocline{1}{0em}{2.3em}}
\let\oldlistoftables = \listoftables
\renewcommand{\listoftables}{
  \begin{singlespace}
    % This works b/c multiple \newpage's are treated as one
    \newpage
    \addcontentsline{toc}{chapter}{List of Tables}
    \oldlistoftables 
  \end{singlespace}
}

\renewcommand*{\l@figure}{\@dottedtocline{1}{0em}{2.3em}}
\let\oldlistoffigures = \listoffigures
\renewcommand{\listoffigures}{
  \begin{singlespace}
    % This works b/c multiple \newpage's are treated as one
    \newpage
    \addcontentsline{toc}{chapter}{List of Figures}
    \oldlistoffigures 
  \end{singlespace}
}


