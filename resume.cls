\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2026/01/16 Simple Chinese Resume]
\LoadClass[11pt]{article}

% disable indent globally
\setlength{\parindent}{0pt}
% some general improvements, defines the XeTeX logo
% \RequirePackage{xltxtra}
\RequirePackage{graphicx}
% use xifthen
\RequirePackage{xifthen}
% use fontawesome
\RequirePackage{fontawesome}
% use xcolor for customizing color
\RequirePackage[dvipsnames]{xcolor}
\definecolor{primary}{RGB}{35, 85, 135} % 定义专业深蓝色
% loading fonts
\RequirePackage{fontspec}
% Main document font
\setmainfont[
  Path = fonts/Main/ ,
  Extension = .otf ,
  UprightFont = *-regular ,
  BoldFont = *-bold ,
  ItalicFont = *-italic ,
  BoldItalicFont = *-bolditalic ,
  SmallCapsFont = Fontin-SmallCaps
]{texgyretermes}

\RequirePackage[
	a4paper,
	left=0.7in,
	right=0.7in,
	top=0.30in,
	bottom=0.5in,
	nohead
]{geometry}

\RequirePackage{titlesec}
\RequirePackage{enumitem}
\setlist{noitemsep}
\setlist[itemize]{topsep=0.2em, leftmargin=1.2pc, parsep=0.2em, label=\color{primary}\small$\bullet$}
\setlist[enumerate]{topsep=0.2em, leftmargin=1.2pc}
\RequirePackage[super]{nth}

\titleformat{\section}
  {\Large\bfseries\scshape\raggedright\color{primary}} 
  {}{0em}
  {}
  [\color{primary}\titlerule]
\titlespacing*{\section}{0cm}{0.5ex}{1ex}

\titleformat{\subsection}
  {\large\bfseries\raggedright}
  {}{0em}
  {}
\titlespacing*{\subsection}{0cm}{0.8ex}{0.4ex}

\newcommand{\datedsection}[2]{
  \section[#1]{#1 \hfill \normalfont\small #2}
}
\newcommand{\datedsubsection}[2]{
  \subsection[#1]{#1 \hfill \normalfont\small #2}
}
\newcommand{\datedline}[2]{
  {\par #1 \hfill \small #2 \par}
}

% =========================
% 个人信息区（Header）
% =========================

% 姓名：左对齐，大号小型大写，使用主色，突出但不浮夸
\newcommand{\name}[1]{%
  {\Huge\bfseries\scshape\color{primary} #1\par}
  \vspace{0.6ex}
}

% 联系方式：无衬线字体 + FontAwesome 图标，信息紧凑
% 参数：#1 手机，#2 邮箱
\newcommand{\contactInfo}[2]{
  {\sffamily\small\color{black!70}
    \faPhone\ #1 \quad
    \faEnvelope\ #2
  \par}
  \vspace{0.4ex}
}

% 其他信息（如学校 / 专业 / 求职方向 / GitHub）
% 最多 4 项，使用分隔点，字号略小于联系方式
\newcommand{\otherInfo}[4]{%
  {\sffamily\small\color{black!65}
    #1%
    \ifthenelse{\isempty{#2}}{}{ \textperiodcentered\ #2}%
    \ifthenelse{\isempty{#3}}{}{ \textperiodcentered\ #3}%
    \ifthenelse{\isempty{#4}}{}{ \textperiodcentered\ #4}%
  \par}
  \vspace{0.6ex}
}

% 信息区分隔线：细线，弱化存在感，仅作视觉分区
\newcommand{\headerRule}{%
  \vspace{0.6ex}
  {\color{primary!40}\hrule height 0.6pt}
  \vspace{1.2ex}
}

\newcommand{\role}[2]{%
  {\par \normalfont #2 \hfill \textit{#1} \par}%
  \vspace{0.5ex}%
}

% ==============================
% 简历顶部个人信息栏（优化版）
% ==============================
% 参数说明：
% #1 姓名, #2 基本信息(如：年龄·21岁·中共党员), #3 电话, #4 邮箱, #5 照片路径
\newcommand{\resumeHeader}[5]{%
  \noindent
  \begin{minipage}[t]{0.78\textwidth} % 左侧文字区占 78%
    \vspace{0pt} 
    
    \begin{tabular}{@{}l@{}}
      \Large\bfseries\color{primary} 个人信息 \\[-2pt]
      \color{primary}\rule{\linewidth}{0.6pt}  % \linewidth 自动等于表格宽度
    \end{tabular}

    \vspace{1.8ex}
    
    \renewcommand{\arraystretch}{1.5} % 调节行高
    \hspace{-1em}
        \begin{tabular}{@{} l @{\hspace{3em}} l @{}}
          \makebox[2.2em][r]{\Large\faUser}\kern0.3em \textbf{姓名：} #1 
          & \makebox[2.2em][r]{\faBirthdayCake}\kern0.3em \textbf{出生年月：} {#2} \\
          
          \makebox[2.2em][r]{\faEnvelope}\kern0.3em \textbf{邮箱：} #3 
          & \makebox[2.2em][r]{\Large\faPhone}\kern0.3em \textbf{联系方式：} #4 \\
        \end{tabular}
  \end{minipage}%
  \hfill
  \begin{minipage}[t]{0.23\textwidth} % 右侧照片区占 23%
    \vspace{0pt}
    \raggedleft
    \fboxsep=0pt % 边框与图片无间距
    \fboxrule=0.5pt % 照片边框粗细
    \color{primary!30}
    \fbox{\includegraphics[width=\linewidth, height=3.3cm, keepaspectratio]{#5}}
  \end{minipage}
  % \vspace{-1ex}
}


