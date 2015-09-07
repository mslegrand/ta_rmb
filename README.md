# ta_rmb
textadept module for RMarkdown

This provides a simple alternative to the RStudio IDE
Advantages:

-  Extremely Customizable 
-  Can view multiple files (in seperate windows) concurrently
-  Can view the same file (in multiple locations)
-  Supports Bookmarks
 
Disadvantages:

-  In the infancy stage:
  +  Still need to add the knitter commands
  +  Still need to add debugger capabilities
  

The rmd lexer recognizes markdown with embedded r code blocks
The rstat lexer is an enhancement of the rstat lexer included in textadept
a lexer for the r programming language, 
This version has been enhance to include a few additional functions

To use:

0. install textadept: http://foicica.com/textadept/download
1. clone https://github.com/mslegrand/ta_rmb 
2. place both lexers and the module containedunder USER_HOME/.textadept /lexers and USERHOME/.textadept/modules
3. place the following 4 lines inside your USER_HOME/.textadept/init.lua file :

```
textadept.file_types.extensions.rmd='rmd'
textadept.file_types.patterns['^---'] = 'rmd'
markdown = require('markdown')
rmd=require('rmd')
```

Your final director structure should contain:
- USERHOME/.textadept/
- USERHOME/.textadept/lexers/rstats.lua
- USERHOME/.textadept/lexers/rmd.lua
- USERHOME/.textadept/modules/rmd/init.lua
