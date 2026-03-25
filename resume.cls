\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2026/01/16 Simple Chinese Resume]
\LoadClass[11pt]{article}

% =============================================================================
% 1. 核心宏包加载 (基础设施)
% =============================================================================
\setlength{\parindent}{0pt}      % 简历通常采用左对齐，全局禁用首行缩进
\RequirePackage{graphicx}        % 用于插入个人照片
\RequirePackage{xifthen}         % 提供强大的条件判断支持
\RequirePackage{fontawesome5}    % 图标库，支持更多现代社交与办公图标
\RequirePackage[dvipsnames]{xcolor} % 颜色自定义扩展
\RequirePackage{fontspec}        % 字体选择器 (需 XeLaTeX/LuaLaTeX 编译)
\RequirePackage{titlesec}        % 标题样式控制 (Section/Subsection)
\RequirePackage{enumitem}        % 精细化控制项目符号 (itemize/enumerate) 间距
\RequirePackage[super]{nth}      % 用于处理 1st, 2nd 等序数词
\RequirePackage{etoolbox}        % 提供列表循环工具 \docsvlist
\RequirePackage{environ}         % 环境处理增强

% =============================================================================
% 2. 视觉风格与排版变量 (一键调教区)
% =============================================================================
\definecolor{primary}{RGB}{35, 85, 135} % 主题色：专业深蓝色

% 垂直间距变量控制：修改此处数值可全局调整简历的“呼吸感”
\newlength{\headergap}       \setlength{\headergap}{-1.5ex}   % 补偿 minipage 顶部的强制留白
\newlength{\sectiontop}      \setlength{\sectiontop}{0.6ex}    % Section 标题上方的间距
\newlength{\sectionbottom}   \setlength{\sectionbottom}{0.8ex}  % Section 标题下方的间距
\newlength{\subsectiontop}   \setlength{\subsectiontop}{0.8ex}  % Subsection (如公司名) 上方间距
\newlength{\subsectionbottom}\setlength{\subsectionbottom}{0.4ex} % Subsection 下方间距
\newlength{\itemgap}         \setlength{\itemgap}{0.2em}       % 列表点 (bullets) 之间的行间距
\newlength{\rulethickness}   \setlength{\rulethickness}{1pt}   % 全局装饰横线的粗细

% 字体配置：基于 TeX Gyre Termes (Times New Roman 的优质替代品)
\setmainfont[
  Path = fonts/Main/ ,
  Extension = .otf ,
  UprightFont = *-regular ,
  BoldFont = *-bold ,
  ItalicFont = *-italic ,
  BoldItalicFont = *-bolditalic ,
  SmallCapsFont = Fontin-SmallCaps
]{texgyretermes}

% 页面布局配置
\RequirePackage[
	a4paper,
	left=0.7in, right=0.7in,  % 左右边距
	top=0.10in, bottom=0.5in, % 配合 \headergap 变量，实现极致的页面利用率
	nohead                    % 禁用页眉
]{geometry}

% =============================================================================
% 3. 标题与列表样式重定义
% =============================================================================
\setlist{noitemsep} % 禁用列表项之间的额外空行
\setlist[itemize]{
    topsep=\itemgap, 
    leftmargin=1.2pc, 
    parsep=\itemgap, 
    label=\color{primary}\small$\bullet$ % 列表点改为主题色实心圆
}
\setlist[enumerate]{topsep=\itemgap, leftmargin=1.2pc}

% 一级标题 (Section)：带主题色下划线，用于区分“教育背景”、“项目经历”等
\titleformat{\section}
  {\Large\bfseries\scshape\raggedright\color{primary}} 
  {}{0em}
  {}
  [\color{primary}\titlerule]
\titlespacing*{\section}{0cm}{\sectiontop}{\sectionbottom}

% 二级标题 (Subsection)：用于具体的“学校名”或“公司名”
\titleformat{\subsection}
  {\large\bfseries\raggedright}
  {}{0em}
  {}
\titlespacing*{\subsection}{0cm}{\subsectiontop}{\subsectionbottom}

% =============================================================================
% 4. 简历专用内容组件
% =============================================================================

% \datedsection 和 \datedsubsection：左侧显示标题，右侧显示日期
\newcommand{\datedsection}[2]{\section[#1]{#1 \hfill \normalfont\small #2}}
\newcommand{\datedsubsection}[2]{\subsection[#1]{#1 \hfill \normalfont\small #2}}
\newcommand{\datedline}[2]{{\par #1 \hfill \small #2 \par}}

% \role：用于展示具体的职位名/角色，并附带副标题（如技术栈）
\newcommand{\role}[2]{%
  {\par \normalfont #2 \hfill \textit{#1} \par}%
  \vspace{\subsectionbottom}% 引用统一间距变量
}

% \edu：教育背景专用，支持学校、院系/成绩、学位三栏水平排版
\newcommand{\edu}[3]{%
  \par\noindent
  \begin{minipage}[t]{0.38\textwidth} % 学校
    \raggedright \normalfont #1
  \end{minipage}%
  \hfill
  \begin{minipage}[t]{0.40\textwidth} % 院系或加权分
    \raggedright \sloppy \normalfont #2
  \end{minipage}%
  \hfill
  \begin{minipage}[t]{0.18\textwidth} % 学位
    \raggedleft \textit{#3}
  \end{minipage}%
  \par\vspace{\subsectionbottom} % 引用统一间距变量
}

% =============================================================================
% 5. 灵活个人信息栏 (flexibleHeader)
% =============================================================================

% 内部子组件：渲染单个信息项 (图标 + 标题 + 内容)
\newcommand{\renderHeaderItem}[3]{%
  \makebox[1.2em][c]{\color{primary}\small#1}\hspace{0.4em}\textbf{#2：}#3%
}

% 内部解析逻辑：处理 "图标/标题/内容" 这种输入格式
\def\parseHeaderItem#1/#2/#3{\renderHeaderItem{#1}{#2}{#3}}

% \flexibleHeader 主宏：
% 参数 #1: 姓名
% 参数 #2: 以逗号分隔的信息列表
% 参数 #3: 照片路径
\newcommand{\flexibleHeader}[3]{%
  \noindent
  \begin{minipage}[t]{0.80\textwidth}
    \vspace{\headergap}             % 将文字上移，紧凑展示
    {\Huge\bfseries\color{primary} #1 \par}
    \vspace{-0.2ex}
    {\color{primary}\rule{\linewidth}{\rulethickness}} % 姓名下方的装饰横线
    % \vspace{-\sectionbottom}         % 动态抵消下方列表的段首间距
    
    {\raggedright
    \setlength{\baselineskip}{1.5em} % 控制信息栏多行之间的行高
    \renewcommand{\do}[1]{%
      \makebox[0.49\linewidth][l]{   % 默认将信息分为左右两栏显示
        \parseHeaderItem##1%
      }
    }
    \docsvlist{#2}\par}
  \end{minipage}%
  \hfill
  \begin{minipage}[t]{0.18\textwidth}
    \vspace{\headergap} 
    \raggedleft
    \fboxsep=0pt
    \fboxrule=\rulethickness         % 边框粗细与装饰线保持一致
    \color{primary!30}               % 照片边框使用浅色主题色，不抢视觉中心
    \fbox{\includegraphics[width=\linewidth,height=3.2cm,keepaspectratio]{#3}}
  \end{minipage}
  \vspace{-0.4ex} 
}