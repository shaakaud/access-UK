"###############################################################################################
"  
"       Filename:  c.vim
"  
"    Description:  C/C++-IDE. Write programs by inserting complete statements, comments, idioms 
"                  code snippets, templates and comments.
"                  Compile, link and run one-file-programs without a makefile.
"                  See also help file csupport.txt .
"  
"   GVIM Version:  6.0+
"  
"  Configuration:  There are some personal details which should be configured 
"                   (see the files README.csupport and csupport.txt).
"  
"         Author:  Dr.-Ing. Fritz Mehner, FH Südwestfalen, 58644 Iserlohn, Germany
"          Email:  mehner@fh-swf.de
"  
"        Version:  see variable  g:C_Version  below 
"       Revision:  07.08.2005
"        Created:  04.11.2000
"        License:  GPL (GNU Public License)
"        
"------------------------------------------------------------------------------
" 
" Prevent duplicate loading: 
" 
if exists("g:C_Version") || &cp
 finish
endif
let g:C_Version= "3.8.1"  							" version number of this script; do not change
"        
"###############################################################################################
"
"  Global variables (with default values) which can be overridden.
"          
" Platform specific items:
" - root directory
" - characters that must be escaped for filenames
" 
let	s:MSWIN =		has("win16") || has("win32")     || has("win32") || 
							\ has("win64") || has("win32unix") || has("win95")
" 
if	s:MSWIN
	"
	let s:root_dir	  = $VIM.'\vimfiles\'
  let s:escfilename = ' %#'
  let s:escfilename = ''
	"
else
	"
	let s:root_dir	  = $HOME.'/.vim/'
  let s:escfilename = ' \%#[]'
	"
endif
"
"  Key word completion is enabled by the filetype plugin 'c.vim'
"  g:C_Dictionary_File  must be global
"          
if !exists("g:C_Dictionary_File")
  let g:C_Dictionary_File = s:root_dir.'wordlists/c-c++-keywords.list,'.
        \                   s:root_dir.'wordlists/k+r.list,'.
        \                   s:root_dir.'wordlists/stl_index.list'
endif
"
"  Modul global variables (with default values) which can be overridden.
"
let s:C_AuthorName     = ""
let s:C_AuthorRef      = ""
let s:C_Email          = ""
let s:C_Company        = ""
let s:C_Project        = ""
let s:C_CopyrightHolder= ""
"
let  s:C_Root          = '&C\/C\+\+.'           " the name of the root menu of this plugin
"
let s:C_LoadMenus      = "yes"
" 
let s:C_CodeSnippets   = s:root_dir.'codesnippets-c/'
"                     
let s:C_CExtension     = "c"                    " C file extension; everything else is C++
if	s:MSWIN
	let s:C_CCompiler      = "gcc.exe"            " the C   compiler
	let s:C_CplusCompiler  = "g++.exe"            " the C++ compiler
	let s:C_ObjExtension   = ".obj"               " file extension for objects (leading point required)
	let s:C_ExeExtension   = ".exe"               " file extension for executables (leading point required)
else
	let s:C_CCompiler      = "gcc"                " the C   compiler
	let s:C_CplusCompiler  = "g++"                " the C++ compiler
	let s:C_ObjExtension   = ".o"                 " file extension for objects (leading point required)
	let s:C_ExeExtension   = ""                   " file extension for executables (leading point required)
endif
let s:C_CFlags         = "-Wall -g -O0 -c"      " compiler flags: compile, don't optimize
let s:C_LFlags         = "-Wall -g -O0"         " compiler flags: link   , don't optimize
let s:C_Libs           = "-lm"                  " libraries to use
let s:C_Comments       = "yes"
let s:C_MenuHeader     = "yes"
"  
"   ----- template files ---- ( 1. set of templates ) ----------------
let s:C_Template_Directory       = s:root_dir."plugin/templates/"
"
"   ----- C template files ---- ( 1. set of templates ) --------------
let s:C_Template_C_File          = "c-file-header"
let s:C_Template_Class           = "c-class-description"
let s:C_Template_Frame           = "c-frame"
let s:C_Template_Function        = "c-function-description"
let s:C_Template_H_File          = "h-file-header"
let s:C_Template_Method          = "c-method-description"
"   
"   ----- C++ template files -- ( 2. set of templates ) --------------
"   ----- If this set is empty the toggle will not appear. -
let s:Cpp_Template_C_File        = "cpp-file-header"
let s:Cpp_Template_Class         = "cpp-class-description"
let s:Cpp_Template_Frame         = "cpp-frame"
let s:Cpp_Template_Function      = "cpp-function-description"
let s:Cpp_Template_H_File        = "hpp-file-header"
let s:Cpp_Template_Method        = "cpp-method-description"
"   
"   ----- C++ class templates ----------------------------------------
let s:C_Class                    = "c-class"
let s:C_ClassUsingNew            = "c-class-using-new"
let s:C_TemplateClass            = "c-template-class"
let s:C_TemplateClassUsingNew    = "c-template-class-using-new"
let s:C_ErrorClass               = "c-error-class"
let s:Cpp_Class                  = "cpp-class"
let s:Cpp_ClassUsingNew          = "cpp-class-using-new"
let s:Cpp_TemplateClass          = "cpp-template-class"
let s:Cpp_TemplateClassUsingNew  = "cpp-template-class-using-new"
let s:Cpp_ErrorClass             = "cpp-error-class"
let s:C_OutputGvim               = "vim"
let s:C_XtermDefaults            = "-fa courier -fs 12 -geometry 80x24"
let s:C_LineEndCommColDefault    = 49
"
"------------------------------------------------------------------------------
"
"  Look for global variables (if any), to override the defaults.
"  
function! C_CheckGlobal ( name )
  if exists('g:'.a:name)
    exe 'let s:'.a:name.'  = g:'.a:name
  endif
endfunction    " ----------  end of function C_CheckGlobal ----------
"
call C_CheckGlobal("C_AuthorName         ")
call C_CheckGlobal("C_AuthorRef          ")
call C_CheckGlobal("C_Email              ")
call C_CheckGlobal("C_Company            ")
call C_CheckGlobal("C_Project            ")
call C_CheckGlobal("C_CopyrightHolder    ")
call C_CheckGlobal("C_Root               ")
call C_CheckGlobal("C_LoadMenus          ")
call C_CheckGlobal("C_CodeSnippets       ")
call C_CheckGlobal("C_CExtension         ")
call C_CheckGlobal("C_ObjExtension       ")
call C_CheckGlobal("C_ExeExtension       ")
call C_CheckGlobal("C_CCompiler          ")
call C_CheckGlobal("C_CplusCompiler      ")
call C_CheckGlobal("C_CFlags             ")
call C_CheckGlobal("C_LFlags             ")
call C_CheckGlobal("C_Libs               ")
call C_CheckGlobal("C_Comments           ")
call C_CheckGlobal("C_Template_Directory ")
call C_CheckGlobal("C_Template_C_File    ")
call C_CheckGlobal("C_Template_Class     ")
call C_CheckGlobal("C_Template_Frame     ")
call C_CheckGlobal("C_Template_Function  ")
call C_CheckGlobal("C_Template_H_File    ")
call C_CheckGlobal("C_Template_Method    ")
call C_CheckGlobal("Cpp_Template_C_File  ")
call C_CheckGlobal("Cpp_Template_Class   ")
call C_CheckGlobal("Cpp_Template_Frame   ")
call C_CheckGlobal("Cpp_Template_Function")
call C_CheckGlobal("Cpp_Template_H_File  ")
call C_CheckGlobal("Cpp_Template_Method  ")
"
call C_CheckGlobal("C_Class                  ")
call C_CheckGlobal("C_ClassUsingNew          ")
call C_CheckGlobal("C_TemplateClass          ")
call C_CheckGlobal("C_TemplateClassUsingNew  ")
call C_CheckGlobal("C_ErrorClass             ")
call C_CheckGlobal("Cpp_Class                ")
call C_CheckGlobal("Cpp_ClassUsingNew        ")
call C_CheckGlobal("Cpp_TemplateClass        ")
call C_CheckGlobal("Cpp_TemplateClassUsingNew")
call C_CheckGlobal("Cpp_ErrorClass           ")
call C_CheckGlobal("C_OutputGvim             ")
call C_CheckGlobal("C_XtermDefaults          ")
"
call C_CheckGlobal("C_MenuHeader             ")
call C_CheckGlobal("C_LineEndCommColDefault  ")
"
"----- some variables for internal use only -----------------------------------
"
let s:C_ClassName         = ""     " remember class name ; initially empty

if s:C_Comments=="yes"
  let s:C_Com1          = '/*'     " C-style : comment start 
  let s:C_Com2          = '*/'     " C-style : comment end
else
  let s:C_Com1          = '//'     " C++style : comment start 
  let s:C_Com2          = ''       " C++style : comment end
endif
"
" set default geometry if not specified 
" 
if match( s:C_XtermDefaults, "-geometry\\s\\+\\d\\+x\\d\\+" ) < 0
	let s:C_XtermDefaults	= s:C_XtermDefaults." -geometry 80x24"
endif
"
" characters that must be escaped for filenames
"
"------------------------------------------------------------------------------
"  C : C_InitC
"  Initialization of C support menus
"------------------------------------------------------------------------------
"
function! C_InitC ()
	"
	"===============================================================================================
	"----- Menu : C --------------------------------------------------------------------------------
	"===============================================================================================
	"
	if s:C_Root != ""
		if s:C_MenuHeader == "yes"
			exe "amenu  ".s:C_Root.'<Tab>C\/C\+\+   <Esc>'
			exe "amenu  ".s:C_Root.'-Sep00-         :'
		endif
	endif
	"
	"===============================================================================================
	"----- Menu : C-Comments -----------------------------------------------------------------------
	"===============================================================================================
	"
	if s:C_MenuHeader == "yes"
		exe "amenu  ".s:C_Root.'&Comments.Comments<Tab>C\/C\+\+             <Esc>'
		exe "amenu  ".s:C_Root.'&Comments.-Sep00-                            :'
	endif
	exe "amenu <silent> ".s:C_Root.'&Comments.line\ e&nd\ comm\.\ \/*\ *\/   <Esc><Esc><Esc>:call C_LineEndComment("/*  */")<CR>$2hi'
	exe "vmenu <silent> ".s:C_Root.'&Comments.line\ e&nd\ comm\.\ \/*\ *\/   <Esc><Esc><Esc>:call C_MultiLineEndComments("/*  */")<CR>$2hi'

	exe "amenu <silent> ".s:C_Root.'&Comments.line\ &end\ comm\.\ \/\/       <Esc><Esc><Esc>:call C_LineEndComment("// ")<CR>A' 
	exe "vmenu <silent> ".s:C_Root.'&Comments.line\ &end\ comm\.\ \/\/       <Esc><Esc><Esc>:call C_MultiLineEndComments("// ")<CR>A'

	exe "amenu <silent> ".s:C_Root.'&Comments.Set\ End\ Comm\.\ Co&l\.       <Esc><Esc>:call C_GetLineEndCommCol()<CR>'
	
	exe "amenu          ".s:C_Root.'&Comments.mult&iline\ comm\.\ \/*\ *\/     <Esc><Esc>o/*<CR>/<Esc>kA<Space>'
	exe "vmenu <silent> ".s:C_Root.'&Comments.mult&iline\ comm\.\ \/*\ *\/     <Esc><Esc>:call C_CodeComment("v","yes")<CR><Esc>:nohlsearch<CR>'

	exe "amenu  ".s:C_Root.'&Comments.-SEP10-                              :'
	exe "amenu <silent> ".s:C_Root.'&Comments.code\ ->\ comment\ \/&*\ *\/   <Esc><Esc>:call C_CodeComment("a","yes")<CR><Esc>:nohlsearch<CR>'
	exe "vmenu <silent> ".s:C_Root.'&Comments.code\ ->\ comment\ \/&*\ *\/   <Esc><Esc>:call C_CodeComment("v","yes")<CR><Esc>:nohlsearch<CR>'
	exe "amenu <silent> ".s:C_Root.'&Comments.code\ ->\ comment\ &\/\/       <Esc><Esc>:call C_CodeComment("a","no")<CR><Esc>:nohlsearch<CR>'
	exe "vmenu <silent> ".s:C_Root.'&Comments.code\ ->\ comment\ &\/\/       <Esc><Esc>:call C_CodeComment("v","no")<CR><Esc>:nohlsearch<CR>'
	exe "amenu <silent> ".s:C_Root.'&Comments.c&omment\ ->\ code         <Esc><Esc>:call C_CommentCode("a")<CR><Esc>:nohlsearch<CR>'
	exe "vmenu <silent> ".s:C_Root.'&Comments.c&omment\ ->\ code         <Esc><Esc>:call C_CommentCode("v")<CR><Esc>:nohlsearch<CR>'
	
	exe "amenu          ".s:C_Root.'&Comments.-SEP0-                  :'
	exe "amenu <silent> ".s:C_Root.'&Comments.&frame\ comment         <Esc><Esc>:call C_CommentTemplates("frame")<CR>'
	exe "amenu <silent> ".s:C_Root.'&Comments.f&unction\ description  <Esc><Esc>:call C_CommentTemplates("function")<CR>'
	exe "amenu          ".s:C_Root.'&Comments.-SEP1-                  :'
	exe "amenu <silent> ".s:C_Root.'&Comments.&method\ description    <Esc><Esc>:call C_CommentTemplates("method")<CR>'
	exe "amenu <silent> ".s:C_Root.'&Comments.cl&ass\ description     <Esc><Esc>:call C_CommentTemplates("class")<CR>'
	exe "amenu          ".s:C_Root.'&Comments.-SEP2-                  :'
	exe "amenu <silent> ".s:C_Root.'&Comments.C\/C\+\+-file\ header   <Esc><Esc>:call C_CommentTemplates("cheader")<CR>'
	exe "amenu <silent> ".s:C_Root.'&Comments.H-file\ header          <Esc><Esc>:call C_CommentTemplates("hheader")<CR>'
	exe "amenu          ".s:C_Root.'&Comments.-SEP3-                  :'
	"
	"----- Submenu : C-Comments : file sections  -------------------------------------------------------------
	"
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.<Tab>C\/C\+\+            <Esc>'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.-Sep0-                   :'
	"
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.&Header\ File\ Includes  '
				\'<Esc><Esc>:call C_CommentSection("HEADER FILE INCLUDES")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.Local\ &Macros           '
				\'<Esc><Esc>:call C_CommentSection("MACROS  -  LOCAL TO THIS SOURCE FILE")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.Local\ &Type\ Def\.      '
				\'<Esc><Esc>:call C_CommentSection("TYPE DEFINITIONS  -  LOCAL TO THIS SOURCE FILE")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.Local\ &Data\ Types      '
				\'<Esc><Esc>:call C_CommentSection("DATA TYPES  -  LOCAL TO THIS SOURCE FILE")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.Local\ &Variables        '
				\'<Esc><Esc>:call C_CommentSection("VARIABLES  -  LOCAL TO THIS SOURCE FILE")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.Local\ &Prototypes       '
				\'<Esc><Esc>:call C_CommentSection("PROTOTYPES  -  LOCAL TO THIS SOURCE FILE")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.&Exp\.\ Function\ Def\.  '
				\'<Esc><Esc>:call C_CommentSection("FUNCTION DEFINITIONS  -  EXPORTED FUNCTIONS")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.&Local\ Function\ Def\.  '
				\'<Esc><Esc>:call C_CommentSection("FUNCTION DEFINITIONS  -  LOCAL TO THIS SOURCE FILE")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.-SEP6-                   :'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.Local\ &Class\ Def\.     '
				\'<Esc><Esc>:call C_CommentSection("CLASS DEFINITIONS  -  LOCAL TO THIS SOURCE FILE")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.E&xp\.\ Class\ Impl\.    '
				\'<Esc><Esc>:call C_CommentSection("CLASS IMPLEMENTATIONS  -  EXPORTED CLASSES")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.L&ocal\ Class\ Impl\.    '
				\'<Esc><Esc>:call C_CommentSection("CLASS IMPLEMENTATIONS  -  LOCAL CLASSES")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.-SEP7-                   :'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.&All\ sections,\ C       '
				\'<Esc><Esc>:call C_Comment_C_SectionAll1()<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&C\/C\+\+-file\ sections.All\ &sections,\ C++     '
				\'<Esc><Esc>:call C_Comment_C_SectionAll2()<CR>0i'
	"
	"
	"----- Submenu : H-Comments : file sections  -------------------------------------------------------------
	"
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.<Tab>C\/C\+\+                  <Esc>'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.-Sep0-                         :'
	"'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.&Header\ File\ Includes    '
				\'<Esc><Esc>:call C_CommentSection("HEADER FILE INCLUDES")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.Exported\ &Macros          '
				\'<Esc><Esc>:call C_CommentSection("EXPORTED MACROS")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.Exported\ &Type\ Def\.     '
				\'<Esc><Esc>:call C_CommentSection("EXPORTED TYPE DEFINITIONS")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.Exported\ &Data\ Types     '
				\'<Esc><Esc>:call C_CommentSection("EXPORTED DATA TYPES")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.Exported\ &Variables       '
				\'<Esc><Esc>:call C_CommentSection("EXPORTED VARIABLES")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.Exported\ &Funct\.\ Decl\. '
				\'<Esc><Esc>:call C_CommentSection("EXPORTED FUNCTION DECLARATIONS")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.-SEP4-                     :'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.E&xported\ Class\ Def\.    '
				\'<Esc><Esc>:call C_CommentSection("EXPORTED CLASS DEFINITIONS")<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.-SEP5-                     :'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.&All\ sections,\ C         '
				\'<Esc><Esc>:call C_Comment_H_SectionAll1()<CR>0i'
	exe "amenu  ".s:C_Root.'&Comments.&H-file\ sections.All\ &sections,\ C++       '
				\'<Esc><Esc>:call C_Comment_H_SectionAll2()<CR>0i'
	"
	exe "amenu  ".s:C_Root.'&Comments.-SEP8-                        :'
	"
	"----- Submenu : C-Comments : keyword comments  ----------------------------------------------------------
	"
	exe "amenu  ".s:C_Root.'&Comments.&KEYWORD+comm\..<Tab>C\/C\+\+     <Esc>'
	exe "amenu  ".s:C_Root.'&Comments.&KEYWORD+comm\..-Sep0-            :'
	exe "amenu  ".s:C_Root.'&Comments.&KEYWORD+comm\..\:&BUG\:          <Esc><Esc>$<Esc>:call C_CommentClassified("BUG")     <CR>kgJ$F:la'
	exe "amenu  ".s:C_Root.'&Comments.&KEYWORD+comm\..\:&COMPILER\:     <Esc><Esc>$<Esc>:call C_CommentClassified("COMPILER")<CR>kgJ$F:la'
	exe "amenu  ".s:C_Root.'&Comments.&KEYWORD+comm\..\:&TODO\:         <Esc><Esc>$<Esc>:call C_CommentClassified("TODO")    <CR>kgJ$F:la'
	exe "amenu  ".s:C_Root.'&Comments.&KEYWORD+comm\..\:T&RICKY\:       <Esc><Esc>$<Esc>:call C_CommentClassified("TRICKY")  <CR>kgJ$F:la'
	exe "amenu  ".s:C_Root.'&Comments.&KEYWORD+comm\..\:&WARNING\:      <Esc><Esc>$<Esc>:call C_CommentClassified("WARNING") <CR>kgJ$F:la'
	exe "amenu  ".s:C_Root.'&Comments.&KEYWORD+comm\..\:&new\ keyword\: <Esc><Esc>$<Esc>:call C_CommentClassified("")        <CR>kgJf:a'
	"
	"----- Submenu : C-Comments : special comments  ----------------------------------------------------------
	"
	exe "amenu  ".s:C_Root.'&Comments.&special\ comm\..<Tab>C\/C\+\+         <Esc>'
	exe "amenu  ".s:C_Root.'&Comments.&special\ comm\..-Sep0-                :'
	exe "amenu  ".s:C_Root.'&Comments.&special\ comm\..&EMPTY                <Esc><Esc>$<Esc>:call C_CommentSpecial("EMPTY")                    <CR>kgJA'
	exe "amenu  ".s:C_Root.'&Comments.&special\ comm\..&FALL\ THROUGH        <Esc><Esc>$<Esc>:call C_CommentSpecial("FALL THROUGH")             <CR>kgJA'
	exe "amenu  ".s:C_Root.'&Comments.&special\ comm\..&IMPL\.\ TYPE\ CONV   <Esc><Esc>$<Esc>:call C_CommentSpecial("IMPLICIT TYPE CONVERSION") <CR>kgJA'
	exe "amenu  ".s:C_Root.'&Comments.&special\ comm\..&NOT\ REACHED\        <Esc><Esc>$<Esc>:call C_CommentSpecial("NOT REACHED")              <CR>kgJA'
	exe "amenu  ".s:C_Root.'&Comments.&special\ comm\..&TO\ BE\ IMPL\.       <Esc><Esc>$<Esc>:call C_CommentSpecial("REMAINS TO BE IMPLEMENTED")<CR>kgJA'
	exe "amenu  ".s:C_Root.'&Comments.&special\ comm\..-SEP81-               :'
	exe "amenu  ".s:C_Root.'&Comments.&special\ comm\..constant\ type\ is\ &long\ (L)              <Esc><Esc>$<Esc>:call C_CommentSpecial("constant type is long")<CR>kgJA'
	exe "amenu  ".s:C_Root.'&Comments.&special\ comm\..constant\ type\ is\ &unsigned\ (U)          <Esc><Esc>$<Esc>:call C_CommentSpecial("constant type is unsigned")<CR>kgJA'
	exe "amenu  ".s:C_Root.'&Comments.&special\ comm\..constant\ type\ is\ unsigned\ l&ong\ (UL)   <Esc><Esc>$<Esc>:call C_CommentSpecial("constant type is unsigned long")<CR>kgJA'

	"
	exe "amenu  ".s:C_Root.'&Comments.-SEP9-                     :'
	"
	exe " menu  ".s:C_Root.'&Comments.&date                   a<C-R>=strftime("%x")<CR>'
	exe "imenu  ".s:C_Root.'&Comments.&date                    <C-R>=strftime("%x")<CR>'
	exe " menu  ".s:C_Root.'&Comments.date\ &time             a<C-R>=strftime("%x %X %Z")<CR>'
	exe "imenu  ".s:C_Root.'&Comments.date\ &time              <C-R>=strftime("%x %X %Z")<CR>'

	"
	"----- Submenu : C-Comments : Tags  ----------------------------------------------------------
	"
	exe "amenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).<Tab>C\/C\+\+     <Esc>'
	exe "amenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).-Sep0-            :'
	"
	exe "amenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).&AUTHOR           a'.s:C_AuthorName."<Esc>"
	exe "amenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).AUTHOR&REF        a'.s:C_AuthorRef."<Esc>"
	exe "amenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).&COMPANY          a'.s:C_Company."<Esc>"
	exe "amenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).C&OPYRIGHTHOLDER  a'.s:C_CopyrightHolder."<Esc>"
	exe "amenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).&EMAIL            a'.s:C_Email."<Esc>"
	exe "amenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).&PROJECT          a'.s:C_Project."<Esc>"
                                       
	exe "imenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).&AUTHOR           <Esc>a'.s:C_AuthorName
	exe "imenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).AUTHOR&REF        <Esc>a'.s:C_AuthorRef
	exe "imenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).&COMPANY          <Esc>a'.s:C_Company
	exe "imenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).C&OPYRIGHTHOLDER  <Esc>a'.s:C_CopyrightHolder
	exe "imenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).&EMAIL            <Esc>a'.s:C_Email
	exe "imenu  ".s:C_Root.'&Comments.ta&gs\ (plugin).&PROJECT          <Esc>a'.s:C_Project
	"
	if			s:Cpp_Template_C_File     != "" || 
				\	s:Cpp_Template_Class      != "" || 
				\	s:Cpp_Template_Frame      != "" || 
				\	s:Cpp_Template_Function   != "" || 
				\	s:Cpp_Template_H_File     != "" || 
				\	s:Cpp_Template_Method     != "" 

		exe "amenu  ".s:C_Root.'&Comments.-SEP11-                    :'
		exe "amenu  ".s:C_Root.'&Comments.&vim\ modeline             <Esc><Esc>:call C_CommentVimModeline()<CR>'
		exe "amenu  ".s:C_Root.'&Comments.-SEP12-                    :'
		if s:C_Comments == 'yes' 
			exe "amenu  <silent>  ".s:C_Root.'&Comments.st&yle\ C\ ->\ C\+\+   <Esc><Esc>:call C_Toggle_C_Cpp()<CR>'
		else
			exe "amenu  <silent>  ".s:C_Root.'&Comments.st&yle\ C\+\+\ ->\ C   <Esc><Esc>:call C_Toggle_C_Cpp()<CR>'
		endif
		"
	endif
	"===============================================================================================
	"----- Menu : C-Statements ---------------------------------------------------------------------
	"===============================================================================================
	"
	if s:C_MenuHeader == "yes"
		exe "amenu  ".s:C_Root.'St&atements.Statements<Tab>C\/C\+\+     <Esc>'
		exe "amenu  ".s:C_Root.'St&atements.-Sep00-                      :'
	endif
	"
	exe "amenu  ".s:C_Root.'St&atements.&if                         <Esc><Esc>oif (  )<Esc>F(la'
	exe "vmenu  ".s:C_Root."St&atements.&if                         DOif (  )<Esc>p:exe \"normal =\".(line(\"'>\")-line(\".\")-1).\"+\"<CR>kf(la"


	exe "amenu  ".s:C_Root.'St&atements.if\ &else                   <Esc><Esc>oif (  )<CR>else<Esc>1kf)hi'
	exe "vmenu  ".s:C_Root."St&atements.if\\ &else                   DOif (  )<CR>else<Esc>P:exe \"normal =\".(line(\"'>\")-line(\".\")-2).\"+\"<CR>kf(la"
	"-----------------------------        ^-- these backslashes have to be doubled 
	"
	exe "amenu  ".s:C_Root.'St&atements.i&f\ \{\ \}                 <Esc><Esc>oif (  )<CR>{<CR>}<Esc>2kf(la'
	exe "vmenu  ".s:C_Root."St&atements.i&f\\ \{\\ \}               DOif (  )<CR>{<CR>}<Esc>Pk=%k<Esc>f(la"
	"
	exe "amenu  ".s:C_Root.'St&atements.if\ \{\ \}\ e&lse\ \{\ \}       <Esc><Esc>oif (  )<CR>{<CR>}<CR>else<CR>{<CR>}<Esc>5kf(la'
	exe "vmenu  ".s:C_Root."St&atements.if\\ \{\\ \}\\ e&lse\\ \{\\ \}   DOif (  )<CR>{<CR>}<CR>else<CR>{<CR>}<Esc>3kPk=%k<Esc>f(la"
	"
	exe "amenu  ".s:C_Root.'St&atements.f&or                        <Esc><Esc>ofor ( ; ;  )<Esc>2F;i'
	exe "vmenu  ".s:C_Root."St&atements.f&or                        DOfor ( ; ;  )<Esc>p:exe \"normal =\".(line(\"'>\")-line(\".\")-1).\"+\"<CR>kf(la"
	"
	exe "amenu  ".s:C_Root.'St&atements.fo&r\ \{\ \}                <Esc><Esc>ofor ( ; ;  )<CR>{<CR>}<Esc>2kf;i'
	exe "vmenu  ".s:C_Root."St&atements.fo&r\\ \{\\ \}              DOfor ( ; ;  )<CR>{<CR>}<Esc>Pk=%k<Esc>f;i"
	"
	exe "amenu  ".s:C_Root.'St&atements.w&hile                      <Esc><Esc>owhile (  )<Esc>F(la'
	exe "vmenu  ".s:C_Root."St&atements.w&hile                      DOwhile (  )<Esc>p:exe \"normal =\".(line(\"'>\")-line(\".\")-1).\"+\"<CR>kf(la"
	"
	exe "amenu  ".s:C_Root.'St&atements.&while\ \{\ \}              <Esc><Esc>owhile (  )<CR>{<CR>}<Esc>2kf(la'
	exe "vmenu  ".s:C_Root."St&atements.&while\\ \{\\ \}            DOwhile (  )<CR>{<CR>}<Esc>Pk=%k<Esc>f(la"
	"
	exe "amenu  ".s:C_Root.'St&atements.&do\ \{\ \}\ while          <Esc><Esc>:call C_DoWhile("a")<CR><Esc>3jf(la'
	exe "vmenu  ".s:C_Root.'St&atements.&do\ \{\ \}\ while          <Esc><Esc>:call C_DoWhile("v")<CR><Esc>f(la'
	"
	exe "amenu  ".s:C_Root.'St&atements.&switch                     <Esc><Esc>:call C_CodeSwitch()<Esc>f(la'
	"
	exe "amenu  ".s:C_Root.'St&atements.&case                       <Esc><Esc>ocase 0:<Tab><CR>break;<CR><Esc>2kf0s'
	exe "vmenu  ".s:C_Root."St&atements.&case                       DOcase 0:<Tab><CR>break;<CR><Esc>kPk<Esc>:exe \"normal =\".(line(\"'>\")-line(\".\")-1).\"+\"<CR>f0s"
	"
	"
	exe "amenu  ".s:C_Root.'St&atements.&\{\ \}                     <Esc><Esc>o{<CR>}<Esc>O'
	exe "vmenu  ".s:C_Root."St&atements.&\{\\ \}                  	DO{<CR>}<Esc>Pk=%<Esc>"
	"                                      
	exe "amenu  ".s:C_Root.'St&atements.-SEP1-                      :'
	"
	"----- Submenu : C-Idioms: standard library -------------------------------------------------------
	"'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..<Tab>C\/C\+\+  <Esc>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..-Sep0-         :'
	"
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..&assert\.h     <Esc><Esc>o#include<Tab><assert.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..&ctype\.h      <Esc><Esc>o#include<Tab><ctype.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..&errno\.h      <Esc><Esc>o#include<Tab><errno.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..&float\.h      <Esc><Esc>o#include<Tab><float.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..&limits\.h     <Esc><Esc>o#include<Tab><limits.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..l&ocale\.h     <Esc><Esc>o#include<Tab><locale.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..&math\.h       <Esc><Esc>o#include<Tab><math.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..set&jmp\.h     <Esc><Esc>o#include<Tab><setjmp.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..s&ignal\.h     <Esc><Esc>o#include<Tab><signal.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..stdar&g\.h     <Esc><Esc>o#include<Tab><stdarg.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..st&ddef\.h     <Esc><Esc>o#include<Tab><stddef.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..&stdio\.h      <Esc><Esc>o#include<Tab><stdio.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..stdli&b\.h     <Esc><Esc>o#include<Tab><stdlib.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..st&ring\.h     <Esc><Esc>o#include<Tab><string.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ S&td\.Lib\..&time\.h       <Esc><Esc>o#include<Tab><time.h>'
	"
	exe "amenu  ".s:C_Root.'St&atements.#include\ C&99.<Tab>C\/C\+\+         <Esc>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ C&99.-Sep0-                :'
	exe "amenu  ".s:C_Root.'St&atements.#include\ C&99.&complex\.h           <Esc><Esc>o#include<Tab><complex.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ C&99.&fenv\.h              <Esc><Esc>o#include<Tab><fenv.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ C&99.&inttypes\.h          <Esc><Esc>o#include<Tab><inttypes.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ C&99.is&o646\.h            <Esc><Esc>o#include<Tab><iso646.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ C&99.&stdbool\.h           <Esc><Esc>o#include<Tab><stdbool.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ C&99.s&tdint\.h            <Esc><Esc>o#include<Tab><stdint.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ C&99.tg&math\.h            <Esc><Esc>o#include<Tab><tgmath.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ C&99.&wchar\.h             <Esc><Esc>o#include<Tab><wchar.h>'
	exe "amenu  ".s:C_Root.'St&atements.#include\ C&99.wct&ype\.h            <Esc><Esc>o#include<Tab><wctype.h>'
	"
	exe "amenu  ".s:C_Root.'St&atements.-SEP2-                          :'
	exe "amenu  ".s:C_Root.'St&atements.#include\ &\<\.\.\.\>           <Esc><Esc>o#include<Tab><><Esc>i'
	exe "amenu  ".s:C_Root.'St&atements.#include\ \"&\.\.\.\"           <Esc><Esc>o#include<Tab>""<Esc>i'
	exe "amenu  ".s:C_Root.'St&atements.&#define                        <Esc><Esc>:call C_PPDefine()<CR>f<Tab>a'
	exe "amenu  ".s:C_Root.'St&atements.#&undef                         <Esc><Esc>:call C_PPUndef()<CR>f<Tab>a'
	"
	exe "amenu  ".s:C_Root.'St&atements.#if\ #else\ #endif\ (&1)      <Esc><Esc>:call C_PPIfElse("if"    ,"a") <CR>ji'
	exe "amenu  ".s:C_Root.'St&atements.#ifdef\ #else\ #endif\ (&2)   <Esc><Esc>:call C_PPIfElse("ifdef" ,"a") <CR>ji'
	exe "amenu  ".s:C_Root.'St&atements.#ifndef\ #else\ #endif\ (&3)  <Esc><Esc>:call C_PPIfElse("ifndef","a") <CR>ji'
	exe "amenu  ".s:C_Root.'St&atements.#ifndef\ #def\ #endif\ (&4)   <Esc><Esc>:call C_PPIfDef (         "a") <CR>2ji'
	"
	exe "vmenu  ".s:C_Root.'St&atements.#if\ #else\ #endif\ (&1)      <Esc><Esc>:call C_PPIfElse("if"    ,"v") <CR>'
	exe "vmenu  ".s:C_Root.'St&atements.#ifdef\ #else\ #endif\ (&2)   <Esc><Esc>:call C_PPIfElse("ifdef" ,"v") <CR>'
	exe "vmenu  ".s:C_Root.'St&atements.#ifndef\ #else\ #endif\ (&3)  <Esc><Esc>:call C_PPIfElse("ifndef","v") <CR>'
	exe "vmenu  ".s:C_Root.'St&atements.#ifndef\ #def\ #endif\ (&4)   <Esc><Esc>:call C_PPIfDef (         "v") <CR>'
	"
	"
	"===============================================================================================
	"----- Menu : C-Idioms -------------------------------------------------------------------------
	"===============================================================================================
	"
	if s:C_MenuHeader == "yes"
		exe "amenu          ".s:C_Root.'&Idioms.Idioms<Tab>C\/C\+\+       <Esc>'
		exe "amenu          ".s:C_Root.'&Idioms.-Sep00-                   :'
	endif
	exe "amenu <silent> ".s:C_Root.'&Idioms.&function                   <Esc><Esc>:call C_CodeFunction("a")<CR>'
	exe "vmenu <silent> ".s:C_Root.'&Idioms.&function                   <Esc><Esc>:call C_CodeFunction("v")<CR>'
	exe "amenu <silent> ".s:C_Root.'&Idioms.s&tatic\ function           <Esc><Esc>:call C_CodeFunction("sa")<CR>w'
	exe "vmenu <silent> ".s:C_Root.'&Idioms.s&tatic\ function           <Esc><Esc>:call C_CodeFunction("sv")<CR>w'
	exe "amenu <silent> ".s:C_Root.'&Idioms.&main                       <Esc><Esc>:call C_CodeMain()<CR>3jA'

	exe "amenu          ".s:C_Root.'&Idioms.-SEP1-                      :'
	exe "amenu          ".s:C_Root.'&Idioms.for(x=&0;\ x<n;\ x\+=1)     <Esc><Esc>:call C_CodeFor("up"  )<CR>a'
	exe "amenu          ".s:C_Root.'&Idioms.for(x=&n-1;\ x>=0;\ x\-=1)  <Esc><Esc>:call C_CodeFor("down")<CR>a'
	
	exe "amenu          ".s:C_Root.'&Idioms.-SEP2-                      :'
	exe "amenu <silent> ".s:C_Root.'&Idioms.&enum\+typedef              <Esc><Esc>:call C_EST("enum")<CR>jo'
	exe "amenu <silent> ".s:C_Root.'&Idioms.&struct\+typedef            <Esc><Esc>:call C_EST("struct")<CR>jo'
	exe "amenu <silent> ".s:C_Root.'&Idioms.&union\+typedef             <Esc><Esc>:call C_EST("union")<CR>jo'
	exe "amenu          ".s:C_Root.'&Idioms.-SEP3-                      :'
	"
	exe " menu          ".s:C_Root.'&Idioms.&printf                     <Esc><Esc>oprintf ("\n");<Esc>F\i'
	exe " menu          ".s:C_Root.'&Idioms.s&canf                      <Esc><Esc>oscanf ("", & );<Esc>F"i'
	exe "imenu          ".s:C_Root.'&Idioms.&printf                     printf ("\n");<Esc>F\i'
	exe "imenu          ".s:C_Root.'&Idioms.s&canf                      scanf ("", & );<Esc>F"i'
	"
	exe "amenu          ".s:C_Root.'&Idioms.-SEP4-                           :'
	exe "amenu <silent> ".s:C_Root.'&Idioms.p=ca&lloc\(n,sizeof(type)\)  <Esc><Esc>:call C_CodeMalloc("c")<CR>i'
	exe "amenu <silent> ".s:C_Root.'&Idioms.p=m&alloc\(sizeof(type)\)    <Esc><Esc>:call C_CodeMalloc("m")<CR>i'
	exe "amenu <silent> ".s:C_Root.'&Idioms.si&zeof(\ \)                     isizeof(  )<Esc>hi'
	exe "vmenu <silent> ".s:C_Root.'&Idioms.si&zeof(\ \)                     disizeof(  )<Esc>hPa'
	exe "amenu          ".s:C_Root.'&Idioms.-SEP5-                           :'
	exe "amenu <silent> ".s:C_Root.'&Idioms.open\ &input\ file           <Esc><Esc>:call C_CodeFopenRead()<CR>jf"a'
	exe "amenu <silent> ".s:C_Root.'&Idioms.open\ &output\ file          <Esc><Esc>:call C_CodeFopenWrite()<CR>jf"a'
"	exe "imenu          ".s:C_Root.'&Idioms.-SEP7-                       :'
	"
	"===============================================================================================
	"----- Menu : Snippets -------------------------------------------------------------------------
	"===============================================================================================
	"
	if s:C_MenuHeader == "yes"
		exe "amenu           ".s:C_Root.'S&nippets.Snippets<Tab>C\/C\+\+       <Esc>'
		exe "amenu           ".s:C_Root.'S&nippets.-Sep00-                      :'
	endif
	if s:C_CodeSnippets != ""
		exe "amenu  <silent> ".s:C_Root.'S&nippets.&read\ code\ snippet   <C-C>:call C_CodeSnippet("r")<CR>'
		exe "amenu  <silent> ".s:C_Root.'S&nippets.&write\ code\ snippet  <C-C>:call C_CodeSnippet("w")<CR>'
		exe "vmenu  <silent> ".s:C_Root.'S&nippets.&write\ code\ snippet  <C-C>:call C_CodeSnippet("wv")<CR>'
		exe "amenu  <silent> ".s:C_Root.'S&nippets.&edit\ code\ snippet   <C-C>:call C_CodeSnippet("e")<CR>'
		exe " menu  <silent> ".s:C_Root.'S&nippets.-SEP1-									:'
	endif
	exe " menu  <silent> ".s:C_Root.'S&nippets.&pick\ up\ prototype   	<C-C>:call C_ProtoPick("n")<CR>'
	exe "vmenu  <silent> ".s:C_Root.'S&nippets.&pick\ up\ prototype   	<C-C>:call C_ProtoPick("v")<CR>'
	exe " menu  <silent> ".s:C_Root.'S&nippets.&insert\ prototype(s)  	<C-C>:call C_ProtoInsert()<CR>'
	exe " menu  <silent> ".s:C_Root.'S&nippets.&clear\ prototype(s)			<C-C>:call C_ProtoClear()<CR>'
	exe " menu  <silent> ".s:C_Root.'S&nippets.&show\ prototype(s)			<C-C>:call C_ProtoShow()<CR>'

	"
	"===============================================================================================
	"----- Menu : C++ ------------------------------------------------------------------------------
	"===============================================================================================
	"
	if s:C_MenuHeader == "yes"
		exe "amenu  ".s:C_Root.'C&++.C\+\+<Tab>C\/C\+\+          <Esc>'
		exe "amenu  ".s:C_Root.'C&++.-Sep00-                     :'
	endif
	exe " menu ".s:C_Root.'C&++.c&in                 <Esc><Esc>ocin<Tab>>> ;<Esc>i'
	exe " menu ".s:C_Root.'C&++.cout\ &variable      <Esc><Esc>ocout<Tab><<  << endl;<Esc>2F<hi'
	exe " menu ".s:C_Root.'C&++.cout\ &string        <Esc><Esc>ocout<Tab><< "\n";<Esc>F\i'
	exe " menu ".s:C_Root.'C&++.c&err\ string        <Esc><Esc>ocerr<Tab><< "\n";<Esc>F\i'
	"
	exe "imenu ".s:C_Root.'C&++.c&in                 cin<Tab>>> ;<Esc>i'
	exe "imenu ".s:C_Root.'C&++.cout\ &variable      cout<Tab><<  << endl;<Esc>2F<hi'
	exe "imenu ".s:C_Root.'C&++.cout\ &string        cout<Tab><< "\n";<Esc>F\i'
	exe "imenu ".s:C_Root.'C&++.c&err\ string        cerr<Tab><< "\n";<Esc>F\i'
	"
	"----- Submenu : C++   library  -------------------------------------------------------------------
	"
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.<Tab>C\/C\+\+   <Esc>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.-Sep0-          :'
	"
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.&algorithm      <Esc><Esc>o#include<Tab><algorithm>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.&bitset         <Esc><Esc>o#include<Tab><bitset>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.&complex        <Esc><Esc>o#include<Tab><complex>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.&deque          <Esc><Esc>o#include<Tab><deque>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.&exception      <Esc><Esc>o#include<Tab><exception>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.&fstream        <Esc><Esc>o#include<Tab><fstream>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.f&unctional     <Esc><Esc>o#include<Tab><functional>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.iomani&p        <Esc><Esc>o#include<Tab><iomanip>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.&ios            <Esc><Esc>o#include<Tab><ios>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.iosf&wd         <Esc><Esc>o#include<Tab><iosfwd>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.io&stream       <Esc><Esc>o#include<Tab><iostream>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.istrea&m        <Esc><Esc>o#include<Tab><istream>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.iterato&r       <Esc><Esc>o#include<Tab><iterator>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.&limits         <Esc><Esc>o#include<Tab><limits>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.lis&t           <Esc><Esc>o#include<Tab><list>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&alg\.\.loc>.l&ocale         <Esc><Esc>o#include<Tab><locale>'
	"
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.<Tab>C\/C\+\+   <Esc>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.-Sep0-          :'

	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.&map            <Esc><Esc>o#include<Tab><map>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.memor&y         <Esc><Esc>o#include<Tab><memory>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.&new            <Esc><Esc>o#include<Tab><new>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.numeri&c        <Esc><Esc>o#include<Tab><numeric>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.&ostream        <Esc><Esc>o#include<Tab><ostream>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.&queue          <Esc><Esc>o#include<Tab><queue>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.&set            <Esc><Esc>o#include<Tab><set>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.sst&ream        <Esc><Esc>o#include<Tab><sstream>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.st&ack          <Esc><Esc>o#include<Tab><stack>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.stde&xcept      <Esc><Esc>o#include<Tab><stdexcept>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.stream&buf      <Esc><Esc>o#include<Tab><streambuf>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.str&ing         <Esc><Esc>o#include<Tab><string>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.&typeinfo       <Esc><Esc>o#include<Tab><typeinfo>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.&utility        <Esc><Esc>o#include<Tab><utility>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.&valarray       <Esc><Esc>o#include<Tab><valarray>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&map\.\.vec>.v&ector         <Esc><Esc>o#include<Tab><vector>'
	"
	"----- Submenu : C     library  -------------------------------------------------------------------
	"
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.<Tab>C\/C\+\+ <Esc>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.-Sep0-        :'
	"
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.c&assert      <Esc><Esc>o#include<Tab><cassert>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.c&ctype       <Esc><Esc>o#include<Tab><cctype>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.c&errno       <Esc><Esc>o#include<Tab><cerrno>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.c&float       <Esc><Esc>o#include<Tab><cfloat>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.c&limits      <Esc><Esc>o#include<Tab><climits>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.cl&ocale      <Esc><Esc>o#include<Tab><clocale>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.c&math        <Esc><Esc>o#include<Tab><cmath>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.cset&jmp      <Esc><Esc>o#include<Tab><csetjmp>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.cs&ignal      <Esc><Esc>o#include<Tab><csignal>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.cstdar&g      <Esc><Esc>o#include<Tab><cstdarg>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.cst&ddef      <Esc><Esc>o#include<Tab><cstddef>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.c&stdio       <Esc><Esc>o#include<Tab><cstdio>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.cstdli&b      <Esc><Esc>o#include<Tab><cstdlib>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.cst&ring      <Esc><Esc>o#include<Tab><cstring>'
	exe "amenu ".s:C_Root.'C&++.#include\ <&cX>.c&time        <Esc><Esc>o#include<Tab><ctime>'

	"
	"----- Submenu : C++ : output manipulators  -------------------------------------------------------
	"
	exe "amenu ".s:C_Root.'C&++.output\ mani&pulators.<Tab>C\/C\+\+              <Esc>'
	exe "amenu ".s:C_Root.'C&++.output\ mani&pulators.-Sep0-                     :'
	"
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &boolalpha           i<< boolalpha<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &dec                 i<< dec<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &endl                i<< endl<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &fixed               i<< fixed<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ fl&ush               i<< flush<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &hex                 i<< hex<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &internal            i<< internal<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &left                i<< left<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &oct                 i<< oct<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &right               i<< right<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ s&cientific          i<< scientific<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &setbase\(\ \)       i<< setbase(10) <ESC>F)i'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ se&tfill\(\ \)       i<< setfill() <ESC>hi'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ setiosfla&g\(\ \)    i<< setiosflags() <ESC>F)i'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ set&precision\(\ \)  i<< setprecision(6) <ESC>F)i'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ set&w\(\ \)          i<< setw(0) <ESC>F)i'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ showb&ase            i<< showbase<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ showpoi&nt           i<< showpoint<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ showpos\ \(&1\)      i<< showpos<Space>'
	exe " menu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ uppercase\ \(&2\)    i<< uppercase<Space>'
	"
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &boolalpha           << boolalpha<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &dec                 << dec<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &endl                << endl<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &fixed               << fixed<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ fl&ush               << flush<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &hex                 << hex<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &internal            << internal<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &left                << left<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ o&ct                 << oct<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &right               << right<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ s&cientific          << scientific<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ &setbase\(\ \)       << setbase(10) <ESC>F)i'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ se&tfill\(\ \)       << setfill() <ESC>hi'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ setiosfla&g\(\ \)    << setiosflags() <ESC>F)i'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ set&precision\(\ \)  << setprecision(6) <ESC>F)i'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ set&w\(\ \)          << setw(0) <ESC>F)i'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ showb&ase            << showbase<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ showpoi&nt           << showpoint<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ showpos\ \(&1\)      << showpos<Space>'
	exe "imenu ".s:C_Root.'C&++.output\ mani&pulators.\<\<\ uppercase\ \(&2\)    << uppercase<Space>'
	"
	"----- Submenu : C++ : ios flag bits  -------------------------------------------------------------
	"
	exe "amenu ".s:C_Root.'C&++.ios\ flag&bits.<Tab>C\/C\+\+        <Esc>'
	exe "amenu ".s:C_Root.'C&++.ios\ flag&bits.-Sep0-               :'
	"
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::&skipws         iios::skipws'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::&left           iios::left'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::&right          iios::right'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::&internal       iios::internal'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::&boolalpha      iios::boolalpha'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::&dec            iios::dec'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::&hex            iios::hex'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::&oct            iios::oct'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::s&cientific     iios::scientific'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::&fixed          iios::fixed'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::sho&wbase       iios::showbase'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::show&pos        iios::showpos'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::&uppercase      iios::uppercase'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::&adjustfield    iios::adjustfield'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::bas&efield      iios::basefield'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::floa&tfield     iios::floatfield'
	exe " menu ".s:C_Root.'C&++.ios\ flag&bits.ios::u&nitbuf        iios::unitbuf'
	"
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::&skipws         ios::skipws'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::&left           ios::left'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::&right          ios::right'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::&internal       ios::internal'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::&boolalpha      ios::boolalpha'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::&dec            ios::dec'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::&hex            ios::hex'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::&oct            ios::oct'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::s&cientific     ios::scientific'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::&fixed          ios::fixed'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::sho&wbase       ios::showbase'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::show&pos        ios::showpos'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::&uppercase      ios::uppercase'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::&adjustfield    ios::adjustfield'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::bas&efield      ios::basefield'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::floa&tfield     ios::floatfield'
	exe "imenu ".s:C_Root.'C&++.ios\ flag&bits.ios::u&nitbuf        ios::unitbuf'
	"
	exe "amenu <silent> ".s:C_Root.'C&++.-SEP2-                        :'
	exe "amenu <silent> ".s:C_Root.'C&++.metho&d\ implement\.          <Esc><Esc>:call C_CodeMethod()<CR>'

	exe "amenu <silent> ".s:C_Root.'C&++.c&lass                        <Esc><Esc>:call C_CommentTemplates("CppClass")<CR>'
	exe "amenu <silent> ".s:C_Root.'C&++.class\ (w\.\ &new)            <Esc><Esc>:call C_CommentTemplates("CppClassUsingNew")<CR>'
	exe "amenu <silent> ".s:C_Root.'C&++.err&or\ class                 <Esc><Esc>:call C_CommentTemplates("CppErrorClass")<CR>'
	exe "amenu <silent> ".s:C_Root.'C&++.-SEP3-                        :'
	exe "amenu <silent> ".s:C_Root.'C&++.&templ\.\ class              <Esc><Esc>:call C_CommentTemplates("CppTemplateClass")<CR>'
	exe "amenu <silent> ".s:C_Root.'C&++.templ\.\ class\ (w\.\ ne&w)  <Esc><Esc>:call C_CommentTemplates("CppTemplateClassUsingNew")<CR>'

	exe "amenu <silent> ".s:C_Root.'C&++.templ\.\ &function           <Esc><Esc>:call C_CodeTemplateFunct()<CR>'
	exe "amenu <silent> ".s:C_Root.'C&++.-SEP4-                        :'
	exe "amenu <silent> ".s:C_Root.'C&++.operator\ &<<                <Esc><Esc>:call C_CodeOutputOperator()<CR>3jf.a'
	exe "amenu <silent> ".s:C_Root.'C&++.operator\ &>>                <Esc><Esc>:call C_CodeInputOperator()<CR>3jf.a'
	exe "amenu <silent> ".s:C_Root.'C&++.-SEP5-                        :'
	exe "amenu <silent> ".s:C_Root.'C&++.tr&y\ \.\.\ catch             <Esc><Esc>:call C_CodeTryCatch()<CR>4j2f a'
	exe "amenu <silent> ".s:C_Root.'C&++.catc&h                        <Esc><Esc>:call C_CodeCatch()<CR>2f a'

	exe " menu <silent> ".s:C_Root.'C&++.catch\(&\.\.\.\)              <Esc><Esc>ocatch (...)<CR>{<CR>}<Esc>O'
	exe "imenu <silent> ".s:C_Root.'C&++.catch\(&\.\.\.\)              catch (...)<CR>{<CR>}<Esc>O'

	exe "amenu <silent> ".s:C_Root.'C&++.-SEP6-                        :'
	exe "amenu <silent> ".s:C_Root.'C&++.open\ input\ file\ \(&1\)     <Esc><Esc>:call C_CodeIfstream()<CR>f"a'
	exe "amenu <silent> ".s:C_Root.'C&++.open\ output\ file\ \(&2\)    <Esc><Esc>:call C_CodeOfstream()<CR>f"a'
	exe "amenu <silent> ".s:C_Root.'C&++.-SEP7-                        :'

	exe " menu <silent> ".s:C_Root.'C&++.&using\ namespace\ std;       <Esc><Esc>ousing namespace std;<CR>'
	exe " menu <silent> ".s:C_Root.'C&++.usin&g\ namespace\ ;          <Esc><Esc>ousing namespace ;<Esc>$i'
	exe "amenu <silent> ".s:C_Root.'C&++.namespace\ &\{\ \}            <Esc><Esc>:call C_Namespace("a")<CR>jo'

	exe "imenu <silent> ".s:C_Root.'C&++.&using\ namespace\ std;       using namespace std;<CR>'
	exe "imenu <silent> ".s:C_Root.'C&++.usin&g\ namespace\ ;          using namespace ;<Esc>$i'
	exe "vmenu <silent> ".s:C_Root.'C&++.namespace\ &\{\ \}            <Esc><Esc>:call C_Namespace("v")<CR>'

	exe "amenu <silent> ".s:C_Root.'C&++.-SEP8-              :'
	"
	"----- Submenu : RTTI  ----------------------------------------------------------------------------
	"
	exe "amenu ".s:C_Root.'C&++.&RTTI.<Tab>C\/C\+\+          <Esc>'
	exe "amenu ".s:C_Root.'C&++.&RTTI.-Sep0-                 :'
	"
	exe " menu ".s:C_Root.'C&++.&RTTI.&typeid                atypeid()<Esc>F(a'
	exe " menu ".s:C_Root.'C&++.&RTTI.&static_cast           astatic_cast<>()<Esc>F<a'
	exe " menu ".s:C_Root.'C&++.&RTTI.&const_cast            aconst_cast<>()<Esc>F<a'
	exe " menu ".s:C_Root.'C&++.&RTTI.&reinterpret_cast      areinterpret_cast<>()<Esc>F<a'
	exe " menu ".s:C_Root.'C&++.&RTTI.&dynamic_cast          adynamic_cast<>()<Esc>F<a'
	"
	exe "imenu ".s:C_Root.'C&++.&RTTI.&typeid                typeid()<Esc>F(a'
	exe "imenu ".s:C_Root.'C&++.&RTTI.&static_cast           static_cast<>()<Esc>F<a'
	exe "imenu ".s:C_Root.'C&++.&RTTI.&const_cast            const_cast<>()<Esc>F<a'
	exe "imenu ".s:C_Root.'C&++.&RTTI.&reinterpret_cast      reinterpret_cast<>()<Esc>F<a'
	exe "imenu ".s:C_Root.'C&++.&RTTI.&dynamic_cast          dynamic_cast<>()<Esc>F<a'
	exe "amenu ".s:C_Root.'C&++.e&xtern\ \"C\"\ \{\ \}       <Esc><Esc>oextern "C"<CR>{<CR>#include<Tab><CR>}<Esc>kA'
	exe "vmenu ".s:C_Root.'C&++.e&xtern\ \"C\"\ \{\ \}       DOextern "C"<CR>{<CR>}<Esc>P'
	"
	"===============================================================================================
	"----- Menu : run  -----------------------------------------------------------------------------
	"===============================================================================================
	"
	if s:C_MenuHeader == "yes"
		exe "amenu  ".s:C_Root.'&Run.Run<Tab>C\/C\+\+       <Esc>'
		exe "amenu  ".s:C_Root.'&Run.-Sep00-                 :'
	endif
	"
	exe "amenu  <silent>  ".s:C_Root.'&Run.save\ and\ &compile<Tab>\<A-F9\>    <C-C>:call C_Compile()<CR><CR>'
	exe "amenu  <silent>  ".s:C_Root.'&Run.&link<Tab>\<F9\>                    <C-C>:call C_Link()<CR>'
	exe "amenu  <silent>  ".s:C_Root.'&Run.&run<Tab>\<C-F9\>                   <C-C>:call C_Run()<CR>'
	exe "amenu  <silent>  ".s:C_Root.'&Run.cmd\.\ line\ &arg\.<Tab>\<S-F9\>    <C-C>:call C_Arguments()<CR>'
	exe "amenu  <silent>  ".s:C_Root.'&Run.-SEP0-                              :'
	exe "amenu  <silent>  ".s:C_Root.'&Run.&make                               <C-C>:call C_Make()<CR>'
	exe "amenu  <silent>  ".s:C_Root.'&Run.cmd\.\ line\ ar&g\.\ for\ make      <C-C>:call C_MakeArguments()<CR>'
	exe "amenu  <silent>  ".s:C_Root.'&Run.s&plint                             <C-C>:call C_SplintCheck()<CR>:redraw<CR>:call C_SplintCheckMsg()<CR>'
	exe "amenu  <silent>  ".s:C_Root.'&Run.cmd\.\ line\ arg\.\ for\ spl&int    <C-C>:call C_SplintArguments()<CR>'
	exe "amenu  <silent>  ".s:C_Root.'&Run.-SEP2-                              :'
	exe "amenu  <silent>  ".s:C_Root.'&Run.&hardcopy\ to\ FILENAME\.ps         <C-C>:call C_Hardcopy("n")<CR>'
	exe "vmenu  <silent>  ".s:C_Root.'&Run.&hardcopy\ to\ FILENAME\.ps         <C-C>:call C_Hardcopy("v")<CR>'
	exe "imenu  <silent>  ".s:C_Root.'&Run.-SEP3-                              :'

	exe "amenu  <silent>  ".s:C_Root.'&Run.&settings                             <C-C>:call C_Settings()<CR>'
	exe "imenu  <silent>  ".s:C_Root.'&Run.-SEP4-                                :'

	if	!s:MSWIN
		exe "amenu  <silent>  ".s:C_Root.'&Run.x&term\ size                             <C-C>:call C_XtermSize()<CR>'
	endif
	if s:C_OutputGvim == "vim" 
		exe "amenu  <silent>  ".s:C_Root.'&Run.output:\ VIM->&buffer->xterm            <C-C>:call C_Toggle_Gvim_Xterm()<CR><CR>'
	else
		if s:C_OutputGvim == "buffer" 
			exe "amenu  <silent>  ".s:C_Root.'&Run.output:\ BUFFER->&xterm->vim        <C-C>:call C_Toggle_Gvim_Xterm()<CR><CR>'
		else
			exe "amenu  <silent>  ".s:C_Root.'&Run.output:\ XTERM->&vim->buffer          <C-C>:call C_Toggle_Gvim_Xterm()<CR><CR>'
		endif
	endif

endfunction    " ----------  end of function  C_InitC  ----------
"
"===============================================================================================
"----- Menu Functions --------------------------------------------------------------------------
"===============================================================================================
"
"------------------------------------------------------------------------------
"  Input after a highlighted prompt
"------------------------------------------------------------------------------
function! C_Input ( promp, text )
	echohl Search												" highlight prompt
	call inputsave()										" preserve typeahead
	let	retval=input( a:promp, a:text )	" read input
	call inputrestore()									" restore typeahead
	echohl None													" reset highlighting
	return retval
endfunction    " ----------  end of function C_Input ----------
"
"------------------------------------------------------------------------------
"  Comments : get line-end comment position
"------------------------------------------------------------------------------
function! C_GetLineEndCommCol ()
  let	b:C_LineEndCommentColumn	= virtcol(".") 
  echomsg "line end comments will start at column  ".b:C_LineEndCommentColumn
endfunction		" ---------- end of function  C_GetLineEndCommCol  ----------
"
"------------------------------------------------------------------------------
"  Comments : single line-end comment
"------------------------------------------------------------------------------
function! C_LineEndComment ( arg1 )
	if !exists("b:C_LineEndCommentColumn")
		let	b:C_LineEndCommentColumn	= s:C_LineEndCommColDefault
	endif
	" ----- trim whitespaces -----
	exe "s/\s\*$//"
	let linelength= virtcol("$") - 1
	if linelength < b:C_LineEndCommentColumn
		let diff	= b:C_LineEndCommentColumn -1 -linelength
		exe "normal	".diff."A "
	endif
	" append at least one blank
	if linelength >= b:C_LineEndCommentColumn
		exe "normal A "
	endif
	exe "normal	$A".a:arg1
endfunction		" ---------- end of function  C_LineEndComment  ----------
"
"------------------------------------------------------------------------------
"  Comments : multi line-end comments
"------------------------------------------------------------------------------
function! C_MultiLineEndComments ( arg1 )
	"
  if !exists("b:C_LineEndCommentColumn")
		let	b:C_LineEndCommentColumn	= s:C_LineEndCommColDefault
  endif
	"
	let pos0	= line("'<")
	let pos1	= line("'>")
	"
	" ----- trim whitespaces -----
	exe "'<,'>s/\s\*$//"
	" 
	" ----- find the longest line -----
	let	maxlength		= 0
	let	linenumber	= pos0
	normal '<
	while linenumber <= pos1
		if  getline(".") !~ "^\\s*$"  && maxlength<virtcol("$")
			let maxlength= virtcol("$")
		endif
		let linenumber=linenumber+1
		normal j
	endwhile
	"
	if maxlength < b:C_LineEndCommentColumn
	  let maxlength = b:C_LineEndCommentColumn
	else
	  let maxlength = maxlength+1		" at least 1 blank
	endif
	"
	" ----- fill lines with blanks -----
	let	linenumber	= pos0
	while linenumber <= pos1
		exe ":".linenumber
		if getline(".") !~ "^\\s*$"
			let diff	= maxlength - virtcol("$")
			exe "normal	".diff."A "
			exe "normal	$A".a:arg1
		endif
		let linenumber=linenumber+1
	endwhile
	" ----- back to the begin of the marked block -----
	exe ":".pos0
endfunction		" ---------- end of function  C_MultiLineEndComments  ----------
"
"------------------------------------------------------------------------------
"  C-Comments : classified comments
"------------------------------------------------------------------------------
function! C_CommentClassified (class)
  	put = '	'.s:C_Com1.' :'.a:class.':'.strftime(\"%x %X\").':'.s:C_AuthorRef.':  '.s:C_Com2
endfunction    " ----------  end of function C_CommentClassified ----------
"
"------------------------------------------------------------------------------
"  C-Comments : special comments
"------------------------------------------------------------------------------
function! C_CommentSpecial (special)
  	put = '	'.s:C_Com1.' '.a:special.' '.s:C_Com2
endfunction    " ----------  end of function C_CommentSpecial ----------
"
"------------------------------------------------------------------------------
"  C-Comments : Section Comments
"------------------------------------------------------------------------------
"
function! C_CommentSection (keyword)
	let zz=   s:C_Com1." #####   ".a:keyword."   "
	if s:C_Comments == 'yes' 
		let	n = 71-strlen(a:keyword)
	else
		let	n = 74-strlen(a:keyword)
	endif	
	while n>0
		let zz = zz."#"
		let	n  = n-1
	endwhile
	let zz= zz." ".s:C_Com2
	let zz= zz."\n\n"
	put =zz | +1
endfunction    " ----------  end of function C_CommentSection ----------
"
"------------------------------------------------------------------------------
"  C-Comments : Section Comments
"------------------------------------------------------------------------------
"
function! C_Comment_C_SectionAll1 ()
	call C_CommentSection("HEADER FILE INCLUDES")
  call C_CommentSection("MACROS  -  LOCAL TO THIS SOURCE FILE")
  call C_CommentSection("TYPE DEFINITIONS  -  LOCAL TO THIS SOURCE FILE")
  call C_CommentSection("DATA TYPES  -  LOCAL TO THIS SOURCE FILE")
  call C_CommentSection("VARIABLES  -  LOCAL TO THIS SOURCE FILE")
  call C_CommentSection("PROTOTYPES  -  LOCAL TO THIS SOURCE FILE")
	call C_CommentSection("FUNCTION DEFINITIONS  -  EXPORTED FUNCTIONS")
	call C_CommentSection("FUNCTION DEFINITIONS  -  LOCAL TO THIS SOURCE FILE")
endfunction    " ----------  end of function C_Comment_C_SectionAll1 ----------
"
function! C_Comment_C_SectionAll2 ()
	call C_Comment_C_SectionAll1()
	call C_CommentSection("CLASS DEFINITIONS  -  LOCAL TO THIS SOURCE FILE")
	call C_CommentSection("CLASS IMPLEMENTATIONS  -  EXPORTED CLASSES")
	call C_CommentSection("CLASS IMPLEMENTATIONS  -  LOCAL CLASSES")
endfunction    " ----------  end of function C_Comment_C_SectionAll2 ----------
"
function! C_Comment_H_SectionAll1 ()
	call C_CommentSection("HEADER FILE INCLUDES")
  call C_CommentSection("EXPORTED MACROS")
  call C_CommentSection("EXPORTED TYPE DEFINITIONS")
  call C_CommentSection("EXPORTED VARIABLES") 
  call C_CommentSection("EXPORTED FUNCTION DECLARATIONS")
endfunction    " ----------  end of function C_Comment_H_SectionAll1 ----------
"
function! C_Comment_H_SectionAll2 ()
	call C_Comment_H_SectionAll1()
	call C_CommentSection("EXPORTED CLASS DEFINITIONS")
endfunction    " ----------  end of function  C_Comment_H_SectionAll2----------
"
"------------------------------------------------------------------------------
"  Substitute tags
"------------------------------------------------------------------------------
function! C_SubstituteTag( pos1, pos2, tag, replacement )
	" 
	" loop over marked block
	" 
	let	linenumber=a:pos1
	while linenumber <= a:pos2
		let line	= getline(linenumber)
		" 
		" loop for multiple tags in one line
		" 
		let	start=0
		while match(line,a:tag,start)>=0				" do we have a tag ?
			let frst = match(line,a:tag,start)
			let last = matchend(line,a:tag,start)
			if frst!=-1
				let part1 = strpart(line,0,frst)
				let part2 = strpart(line,last)
				let line  = part1.a:replacement.part2
				"
				" next search starts after the replacement to suppress recursion
				" 
				let start=strlen(part1)+strlen(a:replacement)
			endif
		endwhile
		call setline( linenumber, line )
		let	linenumber=linenumber+1
	endwhile

endfunction    " ----------  end of function  C_SubstituteTag  ----------
"
"------------------------------------------------------------------------------
"  C-Comments : Insert a template files
"------------------------------------------------------------------------------
function! C_CommentTemplates (arg)

	if s:C_Comments == 'yes' 
		let prefix="C"
	else
		let prefix="Cpp"
	endif
	"----------------------------------------------------------------------
	"  templates
	"----------------------------------------------------------------------
	if a:arg=='frame'
		let templatefile=s:C_Template_Directory.s:{prefix}_Template_Frame
	endif
	if a:arg=='function'
		let templatefile=s:C_Template_Directory.s:{prefix}_Template_Function
	endif
	if a:arg=='class'
		let templatefile=s:C_Template_Directory.s:{prefix}_Template_Class
	endif
	if a:arg=='method'
		let templatefile=s:C_Template_Directory.s:{prefix}_Template_Method
	endif
	if a:arg=='cheader'
		let templatefile=s:C_Template_Directory.s:{prefix}_Template_C_File
	endif
	if a:arg=='hheader'
		let templatefile=s:C_Template_Directory.s:{prefix}_Template_H_File
	endif
	if a:arg=='CppClass'
		let templatefile=s:C_Template_Directory.s:{prefix}_Class
	endif
	if a:arg=='CppClassUsingNew'
		let templatefile=s:C_Template_Directory.s:{prefix}_ClassUsingNew
	endif
	if a:arg=='CppTemplateClass'
		let templatefile=s:C_Template_Directory.s:{prefix}_TemplateClass
	endif
	if a:arg=='CppTemplateClassUsingNew'
		let templatefile=s:C_Template_Directory.s:{prefix}_TemplateClassUsingNew
	endif
	if a:arg=='CppErrorClass'
		let templatefile=s:C_Template_Directory.s:{prefix}_ErrorClass
	endif

	if	a:arg=='CppClass'                 ||
		\	a:arg=='CppClassUsingNew'         ||
		\	a:arg=='CppTemplateClass'         ||
		\	a:arg=='CppTemplateClassUsingNew' ||
		\	a:arg=='CppErrorClass' 

		let	name	= C_Input("class name : ", "" )
		if name == ""
			return
		endif
		let s:C_ClassName	= name
	endif

	if filereadable(templatefile)
		let	length= line("$")
		let	pos1  = line(".")+1
		"
		let l:old_cpoptions	= &cpoptions " Prevent the alternate buffer from being set to this files
		setlocal cpoptions-=a
		if  a:arg=='cheader' || a:arg=='hheader'
			:goto 1
			let	pos1  = 1
			silent exe '0read '.templatefile
		else
			silent exe 'read '.templatefile
		endif
		let &cpoptions	= l:old_cpoptions		" restore previous options
		let	length= line("$")-length
		let	pos2  = pos1+length-1
		"----------------------------------------------------------------------
		"  frame comment will be indented
		"----------------------------------------------------------------------
		if a:arg=='frame'
			let	length	= length-1
			silent exe "normal =".length."+"
			let	length	= length+1
		endif
		"----------------------------------------------------------------------
		"  substitute keywords
		"----------------------------------------------------------------------

		call  C_SubstituteTag( pos1, pos2, '|FILENAME|',        expand("%:t")        )
		call  C_SubstituteTag( pos1, pos2, '|DATE|',            strftime("%x %X %Z") )
		call  C_SubstituteTag( pos1, pos2, '|TIME|',            strftime("%X")       )
		call  C_SubstituteTag( pos1, pos2, '|YEAR|',            strftime("%Y")       )
		call  C_SubstituteTag( pos1, pos2, '|AUTHOR|',          s:C_AuthorName       )
		call  C_SubstituteTag( pos1, pos2, '|EMAIL|',           s:C_Email            )
		call  C_SubstituteTag( pos1, pos2, '|AUTHORREF|',       s:C_AuthorRef        )
		call  C_SubstituteTag( pos1, pos2, '|PROJECT|',         s:C_Project          )
		call  C_SubstituteTag( pos1, pos2, '|COMPANY|',         s:C_Company          )
		call  C_SubstituteTag( pos1, pos2, '|COPYRIGHTHOLDER|', s:C_CopyrightHolder  )
		call  C_SubstituteTag( pos1, pos2, '|CLASSNAME|',       s:C_ClassName        )

		"----------------------------------------------------------------------
		"  Position the cursor
		"----------------------------------------------------------------------
		exe ':'.pos1
		normal 0
		let linenumber=search('|CURSOR|')
		if linenumber >=pos1 && linenumber<=pos2
			let pos1=match( getline(linenumber) ,"|CURSOR|")
			if  matchend( getline(linenumber) ,"|CURSOR|") == match( getline(linenumber) ,"$" )
				silent! s/|CURSOR|//
				" this is an append like A
				:startinsert!
			else
				silent  s/|CURSOR|//
				call cursor(linenumber,pos1+1)
				" this is an insert like i
				:startinsert
			endif
		endif

	else
		echohl WarningMsg | echo 'template file '.templatefile.' does not exist or is not readable'| echohl None
	endif
	
endfunction    " ----------  end of function  C_CommentTemplates  ----------
"
"----------------------------------------------------------------------
"  Code -> Comment
"----------------------------------------------------------------------
function! C_CodeComment( mode, style )
	if a:style==""
		let style=s:C_Comments
	else
		let style=a:style
	endif
	if a:mode=="a"
		if style == 'yes' 
			silent exe ":s#^#/\* #"
			silent put = ' */'
		else
			silent exe ":s#^#//#"
		endif
	endif
	
	if a:mode=="v"
		if style == 'yes' 
			silent exe ":'<,'>s/^/ \* /"
			silent exe ":'< s'^ '\/'"
			silent exe ":'>"
			silent put = ' */'
		else
			silent exe ":'<,'>s#^#//#"
		endif
	endif
endfunction    " ----------  end of function  C_CodeComment  ----------
"
"----------------------------------------------------------------------
"  Comment -> Code
"----------------------------------------------------------------------
let s:C_StartMultilineComment	= '^\s*\/\*[\*! ]\='

function! C_RemoveCComment( start, end )

	if a:end-a:start<1
		return 0										" lines removed
	endif
	" 
	" Is the C-comment complete ? Get length.
	" 
	let check				= getline(	a:start ) =~ s:C_StartMultilineComment
	let	linenumber	= a:start+1
	while linenumber < a:end && getline(	linenumber ) !~ '^\s*\*\/'
		let check				= check && getline(	linenumber ) =~ '^\s*\*[ ]\='
		let linenumber	= linenumber+1
	endwhile
	let check = check && getline(	linenumber ) =~ '^\s*\*\/'
	"
	" remove a complete comment
	" 
	if check
		exe "silent :".a:start.'   s/'.s:C_StartMultilineComment.'//'
		let	linenumber1	= a:start+1
		while linenumber1 < linenumber
			exe "silent :".linenumber1.' s/^\s*\*[ ]\=//'
			let linenumber1	= linenumber1+1
		endwhile
		exe "silent :".linenumber1.'   s/^\s*\*\///'
	endif

	return linenumber-a:start+1			" lines removed
endfunction    " ----------  end of function  C_RemoveCComment  ----------

function! C_CommentCode(mode)
	if a:mode=="a"
		let	pos1		= line(".")
		let	pos2		= pos1
	endif
	if a:mode=="v"
		let	pos1		= line("'<")
		let	pos2		= line("'>")
	endif

	let	removed	= 0
	" 
	let	linenumber=pos1
	while linenumber <= pos2
		" Do we have a C++ comment ?
		if getline(	linenumber ) =~ '^\s*//'
			exe "silent :".linenumber.' s#^\s*//##'
		endif
		" Do we have a C   comment ?
		if getline(	linenumber ) =~ s:C_StartMultilineComment
			let removed = C_RemoveCComment(linenumber,pos2)
		endif

		if removed!=0
			let linenumber = linenumber+removed
			let	removed    = 0
		else
			let linenumber = linenumber+1
		endif
	endwhile
endfunction    " ----------  end of function  C_CommentCode  ----------
"
"----------------------------------------------------------------------
"  Toggle comment style
"----------------------------------------------------------------------
function! C_Toggle_C_Cpp ()
	if s:C_Comments == 'yes'
		exe "aunmenu <silent> ".s:C_Root.'&Comments.st&yle\ C\ ->\ C\+\+'
		exe "amenu   <silent> ".s:C_Root.'&Comments.st&yle\ C\+\+\ ->\ C       <Esc><Esc>:call C_Toggle_C_Cpp()<CR>'
		let	s:C_Comments	= 'no'
		let s:C_Com1      = '//'     " C++style : comment start 
		let s:C_Com2      = ''       " C++style : comment end
	else
		exe "aunmenu <silent> ".s:C_Root.'&Comments.st&yle\ C\+\+\ ->\ C'
		exe "amenu   <silent> ".s:C_Root.'&Comments.st&yle\ C\ ->\ C\+\+    		<Esc><Esc>:call C_Toggle_C_Cpp()<CR>'
		let	s:C_Comments	= 'yes'
		let s:C_Com1      = '/*'     " C-style : comment start 
		let s:C_Com2      = '*/'     " C-style : comment end
	endif
endfunction    " ----------  end of function C_Toggle_C_Cpp  ----------
"
"------------------------------------------------------------------------------
"  C-Comments : vim modeline
"------------------------------------------------------------------------------
function! C_CommentVimModeline ()
  	put = '/* vim: set tabstop='.&tabstop.' shiftwidth='.&shiftwidth.': */'
endfunction    " ----------  end of function C_CommentVimModeline  ----------
"
"=====================================================================================
"----- Menu : Statements -----------------------------------------------------------
"=====================================================================================
"
"------------------------------------------------------------------------------
"  Statements : do-while
"------------------------------------------------------------------------------
function! C_DoWhile (arg)

	if a:arg=='a'
		let zz=    "do\n{\n}\nwhile (  );"
		let zz= zz."\t\t\t\t".s:C_Com1." -----  end do-while  ----- ".s:C_Com2."\n"
		put =zz
		normal  =3+
	endif
	
	if a:arg=='v'
		let zz=    "do\n{"
		:'<put! =zz
		let zz=    "}\nwhile (  );\t\t\t\t".s:C_Com1." -----  end do-while  ----- ".s:C_Com2."\n"
		:'>put =zz
		:'<-2
		:exe "normal =".(line("'>")-line(".")+3)."+"
		:'>+2
	endif
	
endfunction    " ----------  end of function C_DoWhile  ----------
"
"------------------------------------------------------------------------------
"  Statements : switch
"------------------------------------------------------------------------------
"
function! C_CodeSwitch ()
  let zz= "switch (  )\n{\n"
	let zz= zz."case 0:\t\n\t\tbreak;\n\n"
	let zz= zz."case 0:\t\n\t\tbreak;\n\n"
	let zz= zz."case 0:\t\n\t\tbreak;\n\n"
	let zz= zz."case 0:\t\n\t\tbreak;\n\n"
	let zz= zz."default:\t\n\t\tbreak;\n}"
  let zz= zz."\t\t\t\t".s:C_Com1." -----  end switch  ----- ".s:C_Com2."\n"
	put =zz	
	" indent 
	normal  =16+
	" delete case labels
	exe ":.,+12s/0//"
	-11
endfunction    " ----------  end of function C_CodeSwitch  ----------
"
"----------------------------------------------------------------------
"  Statements : #define
"----------------------------------------------------------------------
function! C_PPDefine ()
	if s:C_Comments == 'yes' 
		put = \"#define\t\t\t\t\".s:C_Com1.\"  \".s:C_Com2
	else
		put = \"#define\t\t\t\t\".s:C_Com1.\" \"
	endif
endfunction    " ----------  end of function C_PPDefine  ----------
"
"----------------------------------------------------------------------
"  Statements : #undef
"----------------------------------------------------------------------
function! C_PPUndef ()
	if s:C_Comments == 'yes' 
		put = \"#undef\t\t\t\t\".s:C_Com1.\"  \".s:C_Com2
	else
		put = \"#undef\t\t\t\t\".s:C_Com1.\" \"
	endif
endfunction    " ----------  end of function C_PPDefine  ----------
"
"------------------------------------------------------------------------------
"  Statements : #if .. #else .. #endif 
"  Statements : #ifdef .. #else .. #endif 
"  Statements : #ifndef .. #else .. #endif 
"------------------------------------------------------------------------------
function! C_PPIfElse (keyword,mode)
	let identifier = "CONDITION"
	let	identifier = C_Input("(uppercase) condition for #".a:keyword." : ", identifier )
	if identifier != ""
		
		if a:mode=='a'
			let zz=    "#".a:keyword."  ".identifier."\n\n"
			let zz= zz."#else      ".s:C_Com1." ----- #".a:keyword." ".identifier."  ----- ".s:C_Com2."\n\n"
			let zz= zz."#endif     ".s:C_Com1." ----- #".a:keyword." ".identifier."  ----- ".s:C_Com2."\n"
			put =zz
		endif
		
		if a:mode=='v'
			let zz=    "#".a:keyword."  ".identifier."\n"
			:'<put! =zz
			let zz=    "#else      ".s:C_Com1." ----- #".a:keyword." ".identifier."  ----- ".s:C_Com2."\n\n"
			let zz= zz."#endif     ".s:C_Com1." ----- #".a:keyword." ".identifier."  ----- ".s:C_Com2."\n"
			:'>put  =zz
			:normal '<
		endif

	endif
endfunction    " ----------  end of function C_PPIfElse ----------
"
"------------------------------------------------------------------------------
"  Statements : #ifndef .. #define .. #endif 
"------------------------------------------------------------------------------
function! C_PPIfDef (arg)
	" use filename without path (:t) and extension (:r) :
	let identifier = toupper(expand("%:t:r"))."_INC"
	let	identifier = C_Input("(uppercase) condition for #ifndef : ", identifier )
	if identifier != ""
		
		if a:arg=='a'
			let zz=    "#ifndef  ".identifier."\n"
			let zz= zz."#define  ".identifier."\n\n"
			let zz= zz."#endif   ".s:C_Com1." ----- #ifndef ".identifier."  ----- ".s:C_Com2."\n"
			put =zz
		endif

		if a:arg=='v'
			let zz=    "#ifndef  ".identifier."\n"
			let zz= zz."#define  ".identifier."\n"
			:'<put! =zz
			let zz=    "#endif   ".s:C_Com1." ----- #ifndef ".identifier."  ----- ".s:C_Com2."\n"
			:'>put  =zz
			:normal '<
		endif

	endif
endfunction    " ----------  end of function C_PPIfDef ----------
"
"------------------------------------------------------------------------------
"  C-Idioms : function
"------------------------------------------------------------------------------
function! C_CodeFunction (arg1)

	let	identifier=C_Input("function name : ", "" )

	if identifier != ""
		if a:arg1=="sa" || a:arg1=="sv"
			let prfx	= "static "
		else
			let prfx	= ""
		endif
		" ----- normal mode ----------------
		if a:arg1=="a" || a:arg1=="sa"
			let zz=    prfx."void\n".identifier." (  )\n{\n\treturn ;\n}"
			let zz= zz."\t\t".s:C_Com1." -----  end of ".prfx."function ".identifier."  ----- ".s:C_Com2
			put =zz
		endif
		" ----- visual mode ----------------
		if a:arg1=="v" || a:arg1=="sv"
			let zz=    prfx."void\n".identifier." (  )\n{"
			:'<put! =zz
			let zz=    "return ;\n}"
			let zz= zz."\t\t".s:C_Com1." -----  end of ".prfx."function ".identifier."  ----- ".s:C_Com2
			:'>put =zz
			:'<-3
			:exe "normal =".(line("'>")-line(".")+2)."+"
		endif
	endif
endfunction    " ----------  end of function C_CodeFunction ----------
"
"------------------------------------------------------------------------------
"  C-Idioms : main
"------------------------------------------------------------------------------
function! C_CodeMain ()
	let zz=    "int\nmain ( int argc, char *argv[] )\n{\n\t\n"
	let zz= zz."\treturn EXIT_SUCCESS;\n}"
	let zz= zz."\t\t\t\t".s:C_Com1." ----------  end of function main  ---------- ".s:C_Com2
	put =zz
endfunction    " ----------  end of function C_CodeMain ----------

"------------------------------------------------------------------------------
"  C-Idioms : read / edit code snippet
"------------------------------------------------------------------------------
function! C_CodeSnippet(arg1)
	if isdirectory(s:C_CodeSnippets)
		"
		" read snippet file, put content below current line and indent
		" 
		if a:arg1 == "r"
			let	l:snippetfile=browse(0,"read a code snippet",s:C_CodeSnippets,"")
			if filereadable(l:snippetfile)
				let	linesread= line("$")
				let l:old_cpoptions	= &cpoptions " Prevent the alternate buffer from being set to this files
				setlocal cpoptions-=a
				:execute "read ".l:snippetfile
				let &cpoptions	= l:old_cpoptions		" restore previous options
				let	linesread= line("$")-linesread-1
				if linesread>=0 && match( l:snippetfile, '\.\(ni\|noindent\)$' ) < 0 
				endif
			endif
			if line(".")==2 && getline(1)=~"^$"
				silent exe ":1,1d"
			endif
		endif
		"
		" update current buffer / split window / edit snippet file
		" 
		if a:arg1 == "e"
			let	l:snippetfile	= browse(0,"edit a code snippet",s:C_CodeSnippets,"")
			if l:snippetfile != ""
				:execute "update! | split | edit ".l:snippetfile
			endif
		endif
		"
		" write whole buffer into snippet file 
		" 
		if a:arg1 == "w"
			let	l:snippetfile=browse(0,"write a code snippet",s:C_CodeSnippets,"")
			if l:snippetfile != ""
				if filereadable(l:snippetfile)
					if confirm("File ".l:snippetfile." exists ! Overwrite ? ", "&Cancel\n&No\n&Yes") != 3
						return
					endif
				endif
				:execute ":write! ".l:snippetfile
			endif
		endif
		"
		" write marked area into snippet file 
		" 
		if a:arg1 == "wv"
			let	l:snippetfile=browse(0,"write a code snippet",s:C_CodeSnippets,"")
			if l:snippetfile != ""
				if filereadable(l:snippetfile)
					if confirm("File ".l:snippetfile." exists ! Overwrite ? ", "&Cancel\n&No\n&Yes") != 3
						return
					endif
				endif
				:execute ":*write! ".l:snippetfile
			endif
		endif

	else
		echo "code snippet directory ".s:C_CodeSnippets." does not exist (please create it)"
	endif
endfunction    " ----------  end of function C_CodeSnippets  ----------
"
"------------------------------------------------------------------------------
"  C : for (idiom)
"------------------------------------------------------------------------------
function! C_CodeFor( direction )
	if a:direction=="up"
		let	string	= C_Input( " loop var. [ start [ end [ incr. ]]] : ", "" )
	else
		let	string	= C_Input( " loop var. [ start [ end [ decr. ]]] : ", "" )
	endif
	let	pos		= 0
	let	jmp		= 0
	if string != ""
		" loop variable
		let loopvar		= matchstr( string, '\S\+\s*', pos )
		let pos				= pos + strlen(loopvar)
		let loopvar		= substitute( loopvar, '\s*$', "", "" )
		" 
		" start value
		let startval	= matchstr( string, '\S\+\s*', pos )
		let pos				= pos + strlen(startval)
		let startval	= substitute( startval, '\s*$', "", "" )

		" end value
		let endval	= matchstr( string, '\S\+\s*', pos )
		let pos				= pos + strlen(endval)
		let endval	= substitute( endval, '\s*$', "", "" )

		" increment
		let incval	= matchstr( string, '\S\+\s*', pos )
		let pos			= pos + strlen(incval)
		let incval	= substitute( incval, '\s*$', "", "" )

		if incval==""
			let incval	= '1'
			let	jmp		= 10
		endif

		if a:direction=="up"
			if endval==""
				let endval	= 'n'
				let	jmp		= 7
			endif
			if startval==""
				let startval	= '0'
				let	jmp		= 4
			endif
			let zz= "for ( ".loopvar." = ".startval."; ".loopvar." < ".endval."; ".loopvar." += ".incval." )" 
		else
			if endval==""
				let endval	= '0'
				let	jmp		= 7
			endif
			if startval==""
				let startval	= 'n-1'
				let	jmp		= 4
			endif
			let zz= "for ( ".loopvar." = ".startval."; ".loopvar." >= ".endval."; ".loopvar." -= ".incval." )" 
		endif

		put =zz
		normal ==
		if jmp!=0
			exe "normal ".jmp."Wh"
		else
			exe 'normal $'
		endif
	endif

endfunction    " ----------  end of function C_CodeFor ----------
"
"------------------------------------------------------------------------------
"  C++ : method
"------------------------------------------------------------------------------
function! C_CodeMethod()
	let	identifier=C_Input("method name : ", s:C_ClassName."::" )
	if identifier != ""
		let zz= "
		\void\n".identifier."\t(  )\n{\n\treturn ;\n}
		\\t\t".s:C_Com1." -----  end of method ".identifier."  ----- ".s:C_Com2
		put =zz
	endif
endfunction    " ----------  end of function C_CodeMethod ----------
"
"
"------------------------------------------------------------------------------
"  C++ : template function
"------------------------------------------------------------------------------
function! C_CodeTemplateFunct ()
	let	identifier=C_Input("template function name : ", "" )
	if identifier != ""
		let zz=    "template <class T> void\n".identifier."\t( T param )\n{\n\n\n\treturn ;\n}"
		let zz= zz."\t\t".s:C_Com1." -----  end of template function ".identifier."  ----- ".s:C_Com2
		put =zz
	endif
endfunction    " ----------  end of function C_CodeTemplateFunct ----------
"
"------------------------------------------------------------------------------
"  C-Idioms : enum struct union
"------------------------------------------------------------------------------
function! C_EST (su)
	let name= strpart( a:su, 0, 1 )												" first character of argument
	let	name= C_Input("(lowercase) ".a:su." name : ", name )
	if name != ""
		let	typename	= name
		let zz=    a:su." ".name."\n{\n};"
		let zz= zz."\t\t\t\t".s:C_Com1." ----------  end of ".a:su." ".name."  ---------- ".s:C_Com2."\n\n"
		let zz= zz."typedef ".a:su." ".name." ".typename.";\n"
		put =zz
	endif
	normal  =4+
endfunction    " ----------  end of function C_EST ----------
"
"------------------------------------------------------------------------------
"  C-Idioms : malloc
"------------------------------------------------------------------------------
function! C_CodeMalloc (type)
	let	pos		= 0
	let	jmp		= 0
	if a:type == "c"
		let	string	= C_Input("pointer name { count [ type ]] : ", "")
	else
		let	string	= C_Input("pointer name [ type ] : ", "")
	endif

	if string != ""
		" loop variable
		let pointername		= matchstr( string, '\S\+\s*', pos )
		let pos						= pos + strlen(pointername)
		let pointername		= substitute( pointername, '\s*$', "", "" )
		" 
		" calloc
		"
		if a:type == "c"
			" count 
			let cnt	= matchstr( string, '\S\+\s*', pos )
			let pos		= pos + strlen(cnt)
			let cnt	= substitute( cnt, '\s*$', "", "" )
			" size 
			let size	= matchstr( string, '\S\+\s*', pos )
			let pos		= pos + strlen(size)
			let size	= substitute( size, '\s*$', "", "" )
			if size=="" || cnt ==""
				let jmp	= 1
			endif
			let zz=    pointername."\t= (".size."*)calloc ( ".cnt.", sizeof(".size.") );"
		" 
		" malloc
		"
		else
			let size	= matchstr( string, '\S\+\s*', pos )
			let pos		= pos + strlen(size)
			let size	= substitute( size, '\s*$', "", "" )
			if size==""
				let jmp	= 1
			endif

			let zz=    pointername."\t= (".size."*)malloc ( sizeof(".size.") );"
		endif
		let zz= zz."\nif ( ".pointername."==NULL )\n{"
		let zz= zz."\n\tfprintf (stderr, \"\\ndynamic memory allocation failed\\n\" );"
		let zz= zz."\n\texit (EXIT_FAILURE);\n}"
		let zz= zz."\n\nfree (".pointername.");\n\n"
		put =zz
		normal  =7+
		if jmp!=0
			exe "normal f*"
		else
			exe "normal 6j"
		endif
	endif
endfunction    " ----------  end of function C_CodeMalloc ----------
"
"------------------------------------------------------------------------------
"  C-Idioms : open file for reading
"------------------------------------------------------------------------------
function! C_CodeFopenRead ()
	let	filepointer=C_Input("input-file pointer : ", "infile")
	if filepointer != ""
		let filename=filepointer."_file_name"
		let zz=    "FILE\t*".filepointer.";\t\t\t\t\t\t\t\t\t".s:C_Com1." input-file pointer ".s:C_Com2."\n"
		let zz= zz."char\t*".filename." = \"\";\t\t".s:C_Com1." input-file name    ".s:C_Com2."\n\n"
		let zz= zz.filepointer."\t= fopen( ".filename.", \"r\" );\n"
		let zz= zz."if ( ".filepointer." == NULL )\n{\n"
		let zz= zz."\tfprintf (stderr, \"couldn't open file '%s'; %s\\n\", ".filename.", strerror(errno) );\n"
		let zz= zz."\texit (EXIT_FAILURE);\n}\n\n\n"
		let zz= zz."if( fclose(".filepointer.") == EOF )\t\t\t".s:C_Com1." close input file ".s:C_Com2."\n"
		let zz= zz."{\n\tfprintf (stderr, \"couldn't close file '%s'; %s\\n\", ".filename.", strerror(errno) );\n"
		let zz= zz."\texit (EXIT_FAILURE);\n}\n\n\n"
		put =zz
		normal =15+
		"
		exe ": menu ".s:C_Root.'&Idioms.fscanf('.filepointer.',\ "",\ );    <Esc><Esc>ofscanf ( '.filepointer.', "", & );<ESC>F"i'
		exe ":imenu ".s:C_Root.'&Idioms.fscanf('.filepointer.',\ "",\ );               fscanf ( '.filepointer.', "", & );<ESC>F"i'
	endif
endfunction    " ----------  end of function C_CodeFopenRead ----------
"
"------------------------------------------------------------------------------
"  C-Idioms : open file for writing
"------------------------------------------------------------------------------
function! C_CodeFopenWrite ()
	let	filepointer=C_Input("output-file pointer : ", "outfile")
	if filepointer != ""
		let filename=filepointer."_file_name"
		let zz=    "FILE\t*".filepointer.";\t\t\t\t\t\t\t\t\t".s:C_Com1." output-file pointer ".s:C_Com2."\n"
		let zz= zz."char\t*".filename." = \"\";\t".s:C_Com1." output-file name    ".s:C_Com2."\n\n"
		let zz= zz.filepointer."\t= fopen( ".filename.", \"w\" );\n"
		let zz= zz."if ( ".filepointer." == NULL )\n{\n"
		let zz= zz."\tfprintf (stderr, \"couldn't open file '%s'; %s\\n\", ".filename.", strerror(errno) );\n"
		let zz= zz."\texit (EXIT_FAILURE);\n}\n\n\n"
		let zz= zz."if( fclose(".filepointer.") == EOF )\t\t".s:C_Com1." close output file ".s:C_Com2."\n"
		let zz= zz."{\n\tfprintf (stderr, \"couldn't close file '%s'; %s\\n\", ".filename.", strerror(errno) );\n"
		let zz= zz."\texit (EXIT_FAILURE);\n}\n\n\n"
		put =zz
		normal =15+
		exe ": menu ".s:C_Root.'&Idioms.fprintf('.filepointer.',\ "\\n",\ );     <Esc><Esc>ofprintf ( '.filepointer.', "\n",  );<ESC>F\i'
		exe ":imenu ".s:C_Root.'&Idioms.fprintf('.filepointer.',\ "\\n",\ );                fprintf ( '.filepointer.', "\n",  );<ESC>F\i'
	endif
endfunction    " ----------  end of function C_CodeFopenWrite ----------
"
"------------------------------------------------------------------------------
"  C++ : open file for reading
"------------------------------------------------------------------------------
function! C_CodeIfstream ()
	let	comment1	= " input file name        "
	let	comment2	= " create ifstream object "
	let	comment3	= " open ifstream          "
	let	ifstreamobject=C_Input("ifstream object : ", "ifs" )
	if ifstreamobject != ""
		let filename=ifstreamobject."_file_name"
		let zz=    "char *".filename." = \"\";\t\t".s:C_Com1.comment1.s:C_Com2."\n"
		let zz= zz."ifstream\t".ifstreamobject.";\t\t\t\t\t\t\t".s:C_Com1.comment2.s:C_Com2."\n\n"
		let zz= zz.ifstreamobject.".open (".filename.");\t\t".s:C_Com1.comment3.s:C_Com2."\n"
		let zz= zz."if (!".ifstreamobject.")\n{\n"
		let zz= zz."\tcerr << \"\\nERROR : failed to open input file \" << ".filename." << endl;\n"
		let zz= zz."\texit (EXIT_FAILURE);\n}\n\n\n"
		let zz= zz.ifstreamobject.".close ();\t\t".s:C_Com1." close ifstream ".s:C_Com2."\n"
		put =zz
		normal =11+
	endif
endfunction    " ----------  end of function C_CodeIfstream ----------
"
"------------------------------------------------------------------------------
"  C++ : open file for writing
"------------------------------------------------------------------------------
function! C_CodeOfstream ()
	let	comment1	= " output file name       "
	let	comment2	= " create ofstream object "
	let	comment3	= " open ofstream          "
	let	ofstreamobject=C_Input("ofstream object : ", "ofs" )
	if ofstreamobject != ""
		let filename=ofstreamobject."_file_name"
		let zz=    "char *".filename." = \"\";\t\t".s:C_Com1.comment1.s:C_Com2."\n"
		let zz= zz."ofstream\t".ofstreamobject.";\t\t\t\t\t\t\t".s:C_Com1.comment2.s:C_Com2."\n\n"
		let zz= zz.ofstreamobject.".open (".filename.");\t\t".s:C_Com1.comment3.s:C_Com2."\n"
		let zz= zz."if (!".ofstreamobject.")\n{\n"
		let zz= zz."\tcerr << \"\\nERROR : failed to open output file \" << ".filename." << endl;\n"
		let zz= zz."\texit (EXIT_FAILURE);\n}\n\n\n"
		let zz= zz.ofstreamobject.".close ();\t\t".s:C_Com1." close ofstream ".s:C_Com2."\n"
		put =zz
		normal =11+
	endif
endfunction    " ----------  end of function C_CodeOfstream ----------
"
"------------------------------------------------------------------------------
"  C-Idioms : namespace
"------------------------------------------------------------------------------
function! C_Namespace (arg1)

	let	identifier=C_Input("namespace name : ", "" )

	if identifier != ""
		" ----- normal mode ----------------
		if a:arg1=="a"
			let zz=    "namespace ".identifier."\n{\n}"
			let zz= zz."\t\t".s:C_Com1." -----  end of namespace  ".identifier."  ----- ".s:C_Com2
			put =zz
		endif
		" ----- visual mode ----------------
		if a:arg1=="v"
			let zz=    "namespace ".identifier."\n{\n\n"
			:'<put! =zz
			let zz=    "\n}\t\t".s:C_Com1." -----  end of namespace  ".identifier."  ----- ".s:C_Com2
			:'>put  =zz
			:'<,'>>
		endif
	endif
endfunction    " ----------  end of function C_Namespace ----------
"
"------------------------------------------------------------------------------
"  C++ : output operator
"------------------------------------------------------------------------------
function! C_CodeOutputOperator ()
	let	identifier=C_Input("class name : ", s:C_ClassName )
	if identifier != ""
		let zz=    "ostream &\noperator << (ostream & os, const ".identifier." & obj )\n"
		let zz= zz."{\n\tos << obj. ;\n\treturn os;\n}"
		let zz= zz."\t\t".s:C_Com1." -----  class ".identifier." : end of friend function operator <<  ----- ".s:C_Com2
		put =zz
	endif
endfunction    " ----------  end of function C_CodeOutputOperator ----------
"
"------------------------------------------------------------------------------
"  C++ : input operator
"------------------------------------------------------------------------------
function! C_CodeInputOperator ()
	let	identifier=C_Input("class name : ", s:C_ClassName )
	if identifier != ""
		let zz=    "istream &\noperator >> (istream & is, ".identifier." & obj )"
		let zz= zz."\n{\n\tis >> obj. ;\n\treturn is;\n}"
		let zz= zz."\t\t".s:C_Com1." -----  class ".identifier." : end of friend function operator >>  ----- ".s:C_Com2
		put =zz
	endif
endfunction    " ----------  end of function C_CodeInputOperator ----------
"
"------------------------------------------------------------------------------
"  C++ : try catch
"------------------------------------------------------------------------------
function! C_CodeTryCatch ()
  let zz=    "try\n{\n\t\n}\n"
  let zz= zz."catch (const  &ExceptObj)\t\t".s:C_Com1." handle exception: ".s:C_Com2."\n{\n\t\n}\n"
  let zz= zz."catch (...)\t\t\t".s:C_Com1." handle exception: unspezified ".s:C_Com2."\n{\n\t\n}"
	put =zz		
	normal  =11+
endfunction    " ----------  end of function C_CodeTryCatch ----------
"
"------------------------------------------------------------------------------
"  C++ : catch
"------------------------------------------------------------------------------
function! C_CodeCatch ()
  put =\"catch (const  &ExceptObj)\t\t\".s:C_Com1.\" handle exception: \".s:C_Com2.\"\n{\n\t\n}\n\"
	normal  =3+
endfunction    " ----------  end of function C_CodeCatch ----------
"
"------------------------------------------------------------------------------
"  Handle prototypes
"------------------------------------------------------------------------------
"
let s:C_Prototype        = ''
let s:C_PrototypeShow    = ''
let s:C_PrototypeCounter = 0
let s:C_CComment         = '\/\*.\{-}\*\/\s*'		" C comment with trailing whitespaces
																								"  '.\{-}'  any character, non-greedy
let s:C_CppComment       = '\/\/.*$'						" C++ comment
"
"------------------------------------------------------------------------------
"  Prototypes : pick up (normal/visual)
"------------------------------------------------------------------------------
function! C_ProtoPick (mode)
	if a:mode=="n"
		" --- normal mode -------------------
		let	pos1	= line(".")
		let	pos2	= line(".")
	else
		" --- visual mode -------------------
		let	pos1	= line("'<")
		let	pos2	= line("'>")
	endif
	let	linenumber = pos1
	let prototyp   = getline(linenumber)
	let prototyp   = substitute( prototyp, s:C_CppComment, "", "" ) " remove C++ comment
	let linenumber = linenumber+1
	while linenumber <= pos2
		let newline			= getline(linenumber)
		let newline 	  = substitute( newline, s:C_CppComment, "", "" ) " remove C++ comment
		let prototyp		= prototyp." ".newline
		let linenumber	= linenumber+1
	endwhile
	let prototyp  = substitute( prototyp, '^\s\+', "", "" )					" remove leading whitespaces
	let prototyp  = substitute( prototyp, s:C_CComment, "", "g" )		" remove (multiline) C comments 
	let prototyp  = substitute( prototyp, '\s\+', " ", "g" )				" squeeze whitespaces
	let prototyp  = substitute( prototyp, '\s\+$', "", "" )					" remove trailing whitespaces
	let prototyp	= substitute( prototyp, '\<\h\w*\s*::', "", "" )	" remove the scope res. operator
	let prototyp	= substitute( prototyp, '\s*{.*$', "", "" )     	" remove trailing parts of the function body
	let prototyp	= prototyp.";\n"
	let s:C_PrototypeCounter = s:C_PrototypeCounter+1
	let s:C_Prototype        = s:C_Prototype.prototyp
	let identstring          = s:C_PrototypeShow."(".s:C_PrototypeCounter.") ".bufname("%")." #  "
	let s:C_PrototypeShow    = identstring.prototyp
	"
	echo	s:C_PrototypeCounter.' prototype(s)'
	"
endfunction    " ---------  end of function C_ProtoPick  ----------
"
"------------------------------------------------------------------------------
"  Prototypes : insert
"------------------------------------------------------------------------------
function! C_ProtoInsert ()
	if s:C_PrototypeCounter==0
		echo "currently no prototypes available"
	else
		let	output	= s:C_Prototype
		put =output
		silent exe "normal =".s:C_PrototypeCounter."+"
		call C_ProtoClear()
	endif
endfunction    " ---------  end of function C_ProtoInsert  ----------
"
"------------------------------------------------------------------------------
"  Prototypes : clear
"------------------------------------------------------------------------------
function! C_ProtoClear ()
	if s:C_PrototypeCounter==0
		echo "currently no prototypes available"
	else
		let s:C_Prototype        = ""
		let s:C_PrototypeShow    = ""
		let s:C_PrototypeCounter = 0
		echo 'prototypes deleted'
	endif
endfunction    " ---------  end of function C_ProtoClear  ----------
"
"------------------------------------------------------------------------------
"  Prototypes : show
"------------------------------------------------------------------------------
function! C_ProtoShow ()
	if s:C_PrototypeCounter==0
		echo "currently no prototypes available"
	else
		echo s:C_PrototypeShow
	endif
endfunction    " ---------  end of function C_ProtoShow  ----------
"
"------------------------------------------------------------------------------
"  run : C_EscapeBlanks
"------------------------------------------------------------------------------
function! C_EscapeBlanks (arg)
	return  substitute( a:arg, " ", "\\ ", "g" )
endfunction    " ---------  end of function C_EscapeBlanks  ----------
"
"------------------------------------------------------------------------------
"  run : C_Compile
"------------------------------------------------------------------------------
"  The standard make program 'make' called by vim is set to the C or C++ compiler
"  and reset after the compilation  (set makeprg=... ).
"  The errorfile created by the compiler will now be read by gvim and
"  the commands cl, cp, cn, ... can be used.
"
"
"------------------------------------------------------------------------------
function! C_Compile ()

	exe	":cclose"
	let	Sou		= expand("%")											" name of the file in the current buffer
	let	Obj		= expand("%:r").s:C_ObjExtension	" name of the object
	let SouEsc= escape( Sou, s:escfilename )
	let ObjEsc= escape( Obj, s:escfilename )

	" update : write source file if necessary
	exe	":update"
	
	" compilation if object does not exist or object exists and is older then the source	
	if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
		
		if expand("%:e") == s:C_CExtension
			exe		"set makeprg=".s:C_CCompiler
		else
			exe		"set makeprg=".s:C_CplusCompiler
		endif
		" 
		" COMPILATION
		"
		if s:MSWIN
			exe		"make ".s:C_CFlags." \"".SouEsc."\" -o \"".ObjEsc."\""
		else
			exe		"make ".s:C_CFlags." ".SouEsc." -o ".ObjEsc
		endif
		exe		"set makeprg=make"
		" 
		" open error window if necessary 
		exe	":botright cwindow"
	else
		echo "'".Obj."' is up to date"
	endif
	
endfunction    " ----------  end of function C_Compile ----------
"
"------------------------------------------------------------------------------
"  run : C_Link
"------------------------------------------------------------------------------
"  The standard make program which is used by gvim is set to the compiler
"  (for linking) and reset after linking.
"
"  calls: C_Compile
"------------------------------------------------------------------------------
function! C_Link ()

	call	C_Compile()

	let	Sou		= expand("%")						       		" name of the file in the current buffer
	let	Obj		= expand("%:r").s:C_ObjExtension	" name of the object file
	let	Exe		= expand("%:r").s:C_ExeExtension	" name of the executable
	let ObjEsc= escape( Obj, s:escfilename )
	let ExeEsc= escape( Exe, s:escfilename )
	
	" no linkage if:
	"   executable exists
	"   object exists
	"   source exists
	"   executable newer then object
	"   object newer then source

	if    filereadable(Exe)                &&
      \ filereadable(Obj)                &&
      \ filereadable(Sou)                &&
      \ (getftime(Exe) >= getftime(Obj)) &&
      \ (getftime(Obj) >= getftime(Sou))
		echo "'".Exe."' is up to date"
		return
	endif
	
	" linkage if:
	"   object exists
	"   source exists
	"   object newer then source

	if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
		if expand("%:e") == s:C_CExtension
			exe		"set makeprg=".s:C_CCompiler
		else
			exe		"set makeprg=".s:C_CplusCompiler
		endif
		let v:statusmsg="" 
		if s:MSWIN
			silent exe "make ".s:C_LFlags." ".s:C_Libs." -o \"".ExeEsc."\" \"".ObjEsc."\""
		else
			silent exe "make ".s:C_LFlags." ".s:C_Libs." -o ".ExeEsc." ".ObjEsc
		endif
		if v:statusmsg != ""
			echoerr v:statusmsg 
		endif
		exe		"set makeprg=make"
	endif
endfunction    " ----------  end of function C_Link ----------
"
"------------------------------------------------------------------------------
"  run : 	C_Run
"  calls: C_Link
"------------------------------------------------------------------------------
"
let s:C_OutputBufferName   = "C-Output"
let s:C_OutputBufferNumber = -1
"
function! C_Run ()
"
	let Cwd	 		= getcwd()
	let Sou  		= expand("%")															" name of the source file
	let Obj  		= expand("%:r").s:C_ObjExtension					" name of the object file
	let Exe  		= Cwd."/".expand("%:r").s:C_ExeExtension	" name of the executable
	let ExeEsc  = escape( Exe, s:escfilename )						" name of the executable, escaped
	"
	let l:arguments     = exists("b:C_CmdLineArgs") ? b:C_CmdLineArgs : ''
	"
	let	l:currentbuffer	= bufname("%")
	"
	"==============================================================================
	"  run : run from the vim command line
	"==============================================================================
	if s:C_OutputGvim == "vim"
		"
		silent call C_Link()
		"
		if	executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
			if s:MSWIN
				exe		"!\"".ExeEsc."\" ".l:arguments
			else
				exe		"!".ExeEsc." ".l:arguments
			endif
		else
			echomsg "file ".Exe." does not exist / is not executable"
		endif
	endif
	"
	"==============================================================================
	"  run : redirect output to an output buffer
	"==============================================================================
	if s:C_OutputGvim == "buffer"
		let	l:currentbuffernr	= bufnr("%")
		let l:currentdir			= getcwd()
		"
		silent call C_Link()
		"
		if l:currentbuffer ==  bufname("%")
			"
			"
			if bufloaded(s:C_OutputBufferName) != 0 && bufwinnr(s:C_OutputBufferNumber)!=-1 
				exe bufwinnr(s:C_OutputBufferNumber) . "wincmd w"
				" buffer number may have changed, e.g. after a 'save as' 
				if bufnr("%") != s:C_OutputBufferNumber
					let s:C_OutputBufferNumber	= bufnr(s:C_OutputBufferName)
					exe ":bn ".s:C_OutputBufferNumber
				endif
			else
				silent exe ":new ".s:C_OutputBufferName
				let s:C_OutputBufferNumber=bufnr("%")
				setlocal buftype=nofile
				setlocal noswapfile
				setlocal syntax=none
				setlocal bufhidden=delete
			endif
			"
			" run programm 
			"
			setlocal	modifiable
			if	executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
				if s:MSWIN
					exe		"%!\"".ExeEsc."\" ".l:arguments
				else
					exe		"%!".ExeEsc." ".l:arguments
				endif
			endif
			setlocal	nomodifiable
			"
			" stdout is empty / not empty
			"
			if line("$")==1 && col("$")==1
				silent	exe ":bdelete"
			else
				if winheight(winnr()) >= line("$")
					exe bufwinnr(l:currentbuffernr) . "wincmd w" 
				endif
			endif
			"
		endif
	endif
	"
	"==============================================================================
	"  run : run in a detached xterm  (not available for MS Windows)
	"==============================================================================
	if s:C_OutputGvim == "xterm"
		"
		silent call C_Link()
		"
		if	executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
			if s:MSWIN
				exe		"!\"".ExeEsc."\" ".l:arguments
			else
				silent exe '!xterm -title '.ExeEsc.' '.s:C_XtermDefaults." -e $HOME/.vim/plugin/wrapper.sh ".ExeEsc.' '.l:arguments.' &'
			endif
		endif
	endif

	silent exe ":highlight clear"
endfunction    " ----------  end of function C_Run ----------
"
"------------------------------------------------------------------------------
"  run : Arguments for the executable
"------------------------------------------------------------------------------
function! C_Arguments ()
	let	Exe		  = expand("%:r").s:C_ExeExtension
  if Exe == ""
		redraw
		echohl WarningMsg | echo " no file name " | echohl None
		return
  endif
	let	prompt	= 'command line arguments for "'.Exe.'" : '
	if exists("b:C_CmdLineArgs")
		let	b:C_CmdLineArgs= C_Input( prompt, b:C_CmdLineArgs )
	else
		let	b:C_CmdLineArgs= C_Input( prompt , "" )
	endif
endfunction    " ----------  end of function C_Arguments ----------
"
"----------------------------------------------------------------------
"  Toggle comment style
"----------------------------------------------------------------------
function! C_Toggle_Gvim_Xterm ()
	
	if s:C_OutputGvim == "vim"
		exe "aunmenu  <silent>  ".s:C_Root.'&Run.output:\ VIM->&buffer->xterm'
		exe "amenu    <silent>  ".s:C_Root.'&Run.output:\ BUFFER->&xterm->vim              <C-C>:call C_Toggle_Gvim_Xterm()<CR><CR>'
		let	s:C_OutputGvim	= "buffer"
	else
		if s:C_OutputGvim == "buffer"
			exe "aunmenu  <silent>  ".s:C_Root.'&Run.output:\ BUFFER->&xterm->vim'
			exe "amenu    <silent>  ".s:C_Root.'&Run.output:\ XTERM->&vim->buffer             <C-C>:call C_Toggle_Gvim_Xterm()<CR><CR>'
			let	s:C_OutputGvim	= "xterm"
		else
			" ---------- output : xterm -> gvim
			exe "aunmenu  <silent>  ".s:C_Root.'&Run.output:\ XTERM->&vim->buffer'
			exe "amenu    <silent>  ".s:C_Root.'&Run.output:\ VIM->&buffer->xterm            <C-C>:call C_Toggle_Gvim_Xterm()<CR><CR>'
			let	s:C_OutputGvim	= "vim"
		endif
	endif

endfunction    " ----------  end of function C_Toggle_Gvim_Xterm ----------
"
"------------------------------------------------------------------------------
"  run : xterm geometry
"------------------------------------------------------------------------------
function! C_XtermSize ()
	let regex	= '-geometry\s\+\d\+x\d\+'
	let geom	= matchstr( s:C_XtermDefaults, regex )
	let geom	= matchstr( geom, '\d\+x\d\+' )
	let geom	= substitute( geom, 'x', ' ', "" )
	let	answer= C_Input("   xterm size (COLUMNS LINES) : ", geom )
	while match(answer, '^\s*\d\+\s\+\d\+\s*$' ) < 0
		let	answer= C_Input(" + xterm size (COLUMNS LINES) : ", geom )
	endwhile
	let answer  = substitute( answer, '^\s\+', "", "" )		 				" remove leading whitespaces
	let answer  = substitute( answer, '\s\+$', "", "" )						" remove trailing whitespaces
	let answer  = substitute( answer, '\s\+', "x", "" )						" replace inner whitespaces
	let s:C_XtermDefaults	= substitute( s:C_XtermDefaults, regex, "-geometry ".answer , "" )
endfunction    " ----------  end of function C_XtermSize ----------
"
"------------------------------------------------------------------------------
"  run : run make
"------------------------------------------------------------------------------

let s:C_MakeCmdLineArgs   = ""     " command line arguments for Run-make; initially empty

function! C_MakeArguments ()
	let	s:C_MakeCmdLineArgs= C_Input("make command line arguments : ",s:C_MakeCmdLineArgs)
endfunction    " ----------  end of function C_MakeArguments ----------
"
function! C_Make()
	" update : write source file if necessary
	exe	":update"
	" run make
	exe		":make ".s:C_MakeCmdLineArgs
endfunction    " ----------  end of function C_Make ----------
"
"------------------------------------------------------------------------------
"  run : splint command line arguments
"------------------------------------------------------------------------------
let s:C_SplintCheckMsg    = ""
"
function! C_SplintArguments ()
	if !executable("splint") 
		let s:C_SplintCheckMsg = 'Splint is not executable or not installed!'
	else
		let	prompt	= 'Splint command line arguments for "'.expand("%").'" : '
		if exists("b:C_SplintCmdLineArgs")
			let	b:C_SplintCmdLineArgs= C_Input( prompt, b:C_SplintCmdLineArgs )
		else
			let	b:C_SplintCmdLineArgs= C_Input( prompt , "" )
		endif
	endif
endfunction    " ----------  end of function C_SplintArguments ----------
"
"------------------------------------------------------------------------------
"  run : splint check
"------------------------------------------------------------------------------
function! C_SplintCheck ()
	if !executable("splint") 
		let s:C_SplintCheckMsg = 'Splint is not executable or not installed!'
		return
	endif
	let	l:currentbuffer=bufname("%")
	if &filetype != "c" && &filetype != "cpp"
		let s:C_SplintCheckMsg = l:currentbuffer.' seems not to be a C/C++ file'
		return
	endif
	let s:C_SplintCheckMsg = ""
	exe	":cclose"	
	silent exe	":update"
	exe	"set makeprg=splint"
	" 
	" match the splint error messages (quickfix commands)
	" ignore any lines that didn't match one of the patterns
	"
	:setlocal errorformat=%OLCLint*m,
        \%OSplint*m,
        \%*[\ ]%f:%l:%c:\ %m,
        \%*[\ ]%f:%l:\ %m,
        \%*[^\"]\"%f\"%*\\D%l:\ %m,
        \\"%f\"%*\\D%l:\ %m,
        \%A%f:%l:%c:\ %m,
        \%A%f:%l:%m,
        \\"%f\"\\,
        \\ line\ %l%*\\D%c%*[^\ ]\ %m,
        \%D%*\\a[%*\\d]:\ Entering\ directory\ `%f',
        \%X%*\\a[%*\\d]:\ Leaving\ directory\ `%f',
        \%DMaking\ %*\\a\ in\ %f,
        \%C\ \ %m
	"	
	let l:arguments  = exists("b:C_SplintCmdLineArgs") ? " ".b:C_SplintCmdLineArgs : ""
	exe	":make ".l:arguments." ".escape( l:currentbuffer, s:escfilename )
	exe	":botright cwindow"
	exe	':setlocal errorformat='
	exe	"set makeprg=make"
	"
	" message in case of success
	"
	if l:currentbuffer == bufname("%")
		let s:C_SplintCheckMsg = " Splint --- no warnings for : ".l:currentbuffer
	else
		setlocal wrap
		setlocal linebreak
	endif
endfunction    " ----------  end of function C_SplintCheck ----------
"
"------------------------------------------------------------------------------
"  run : splint check message
"------------------------------------------------------------------------------
function! C_SplintCheckMsg ()
		echohl Search 
		echo s:C_SplintCheckMsg
		echohl None
endfunction    " ----------  end of function C_SplintCheckMsg ----------
"
"------------------------------------------------------------------------------
"  run : settings
"------------------------------------------------------------------------------
function! C_Settings ()
	let	txt =     " C/C++-Support settings\n\n"
	let txt = txt.'                   author :  "'.s:C_AuthorName."\"\n"
	let txt = txt.'                 initials :  "'.s:C_AuthorRef."\"\n"
	let txt = txt.'                    email :  "'.s:C_Email."\"\n"
	let txt = txt.'                  company :  "'.s:C_Company."\"\n"
	let txt = txt.'                  project :  "'.s:C_Project."\"\n"
	let txt = txt.'         copyright holder :  "'.s:C_CopyrightHolder."\"\n"
	let txt = txt.'         C / C++ compiler :  '.s:C_CCompiler.' / '.s:C_CplusCompiler."\n"
	let txt = txt.'         C file extension :  '.s:C_CExtension.'  (everything else is C++)'."\n"
	let txt = txt.'    extension for objects :  "'.s:C_ObjExtension."\"\n"
	let txt = txt.'extension for executables :  "'.s:C_ExeExtension."\"\n"
	let txt = txt.'           compiler flags :  "'.s:C_CFlags."\"\n"
	let txt = txt.'             linker flags :  "'.s:C_LFlags."\"\n"
	let txt = txt.'                libraries :  "'.s:C_Libs."\"\n"
	let txt = txt.'   code snippet directory :  '.s:C_CodeSnippets."\n"
	let txt = txt.'       template directory :  '.s:C_Template_Directory."\n"
	let txt = txt.'           xterm defaults :  '.s:C_XtermDefaults."\n"
	if g:C_Dictionary_File != ""
		let ausgabe= substitute( g:C_Dictionary_File, ",", ",\n                           + ", "g" )
		let txt = txt."       dictionary file(s) :  ".ausgabe."\n"
	endif
	let txt = txt."\n"
	let	txt = txt."__________________________________________________________________________\n"
	let	txt = txt." C/C++-Support, Version ".g:C_Version." / Dr.-Ing. Fritz Mehner / mehner@fh-swf.de\n\n"
	echo txt
endfunction    " ----------  end of function C_Settings ----------
"
"------------------------------------------------------------------------------
"  run : hardcopy
"------------------------------------------------------------------------------
function! C_Hardcopy (arg1)
	let Sou	= expand("%")	
  if Sou == ""
		redraw
		echohl WarningMsg | echo " no file name " | echohl None
		return
  endif
	let	Sou		= escape(Sou,s:escfilename)		" name of the file in the current buffer
	" ----- normal mode ----------------
	if a:arg1=="n"
		silent exe	"hardcopy > ".Sou.".ps"		
		echo "file \"".Sou."\" printed to \"".Sou.".ps\""
	endif
	" ----- visual mode ----------------
	if a:arg1=="v"
		silent exe	"*hardcopy > ".Sou.".ps"		
		echo "file \"".Sou."\" (lines ".line("'<")."-".line("'>").") printed to \"".Sou.".ps\""
	endif
endfunction    " ----------  end of function C_Hardcopy ----------
"
"------------------------------------------------------------------------------
"  c : C_CreateUnLoadMenuEntries
"	 Create the load/unload entry in the GVIM tool menu, depending on 
"	 which script is already loaded.
"  Author: M.Faulstich
"------------------------------------------------------------------------------
"
let s:C_Active = -1									" state variable controlling the C-menus
"
function! C_CreateUnLoadMenuEntries ()
	"
	" C is now active and was former inactive -> 
	" Insert Tools.Unload and remove Tools.Load Menu
	" protect the following submenu names against interpolation by using single qoutes (Mn)
	"
	if  s:C_Active == 1
		:aunmenu &Tools.Load\ C\ Support
		exe 'amenu <silent> 40.1030 &Tools.Unload\ C\ Support  	<C-C>:call C_Handle()<CR>'
	else
		" C is now inactive and was former active or in initial state -1 
		if s:C_Active == 0
			" Remove Tools.Unload if C was former inactive
			:aunmenu &Tools.Unload\ C\ Support
		else
			" Set initial state C_Active=-1 to inactive state C_Active=0
			" This protects from removing Tools.Unload during initialization after
			" loading this script
			let s:C_Active = 0
			" Insert Tools.Load
		endif
		exe 'amenu <silent> 40.1000 &Tools.-SEP100- : '
		exe 'amenu <silent> 40.1030 &Tools.Load\ C\ Support <C-C>:call C_Handle()<CR>'
	endif
	"
endfunction    " ----------  end of function C_CreateUnLoadMenuEntries ----------
"
"------------------------------------------------------------------------------
"  C : C_Handle
"  Loads or unloads C support menus.
"  Author: M.Faulstich
"------------------------------------------------------------------------------
function! C_Handle ()
	if s:C_Active == 0
		:call C_InitC()
		let s:C_Active = 1
	else
		if s:C_Root == ""
			aunmenu Comments
			aunmenu Statements
			aunmenu Idioms
			aunmenu Snippets
			aunmenu C++
			aunmenu Run
		else
			exe "aunmenu ".s:C_Root
		endif
		let s:C_Active = 0
	endif

	call C_CreateUnLoadMenuEntries ()
endfunction    " ----------  end of function C_Handle ----------
"
"------------------------------------------------------------------------------
" 
call C_CreateUnLoadMenuEntries()			" create the menu entry in the GVIM tool menu
if s:C_LoadMenus == "yes"
	call C_Handle()											" load the menus
endif
"
"------------------------------------------------------------------------------
"  Automated header insertion
"------------------------------------------------------------------------------
"
if has("autocmd")
	autocmd BufNewFile  *.\(c\|cc\|cpp\|C\)  call C_CommentTemplates('cheader')
	autocmd BufNewFile  *.\(h\|hpp\)         call C_CommentTemplates('hheader')
endif " has("autocmd")
"
"=====================================================================================
" vim: set tabstop=2 shiftwidth=2: 
