-- A rmd module for the
-- [Textadept](http://foicica.com/textadept/) editor with some short cuts and
-- snippets for writing
-- [rmd](http://rmarkdown.rstudio.com/).<br>
--
-- Installation:<br>
-- Download an
-- [archived](https://github.com/mslegrand/ta_rmb)
-- version or clone the git repository into your `.textadept` directory:
--
--     cd ~/.textadept/modules
--     git clone https://github.com/mslegrand/ta_rmb.git \
--         rmd
--
-- The [source](https://github.com/mslegrand/ta_rmb) is on GitHub,
-- released under the
-- [MIT license](http://www.opensource.org/licenses/mit-license.php).
-- This is an adaptation of [annotated source](http://rgieseke.github.com/ta-markdown/).



local M = {}


-- ## Settings

-- Local variables.
local editing, run = textadept.editing
-- Blockquotes.
editing.comment_string.rmd = '> '
-- Auto-matching chars.<br>
-- Match `<` for embedded HTML, don't match `'`.
editing.char_matches.rmd = {
  [40] = ')', [91] = ']', [123] = '}', [34] = '"', [60] = '>'
}

-- Sets default buffer properties for rmd files.
events.connect(events.LEXER_LOADED, function(lang)
  if lang == 'rmd' then
    buffer.tab_width = 2
  end
end)

-- Todo fix commands so that we have 3 menu commands (correctly labeled)
-- ## Desired Commands 
-- 1. knit:  'Rscript -e "require(knitr); knit(\'%e.Rmd\', \'%e.md\');"'
-- 2. markdown2html: 'Rscript -e "require(markdown); markdownToHTML(\'%e.md\', \'%e.html\', options=c(\'use_xhtml\', \'base64_images\'));"'
-- 3. browse: 'Rscript -e "browseURL(paste(\'file://\', file.path(getwd(),\'%e.html\'), sep=\'\'))"'

-- local rmd_commands
-- make table of rmd_cmds
-- 
--~ textadept.menu.context_menu[#textadept.menu.context_menu+1]={
--~ title='rmd',
--~ {'knit', M.knit}
--~ }

-- textadept.run.compile_commands.rmd = 'Rscript -e "require(knitr); knit(\'%e.Rmd\', \'%e.md\');"'
-- textadept.run.build_commands.rmd = 'Rscript -e "require(markdown); markdownToHTML(\'%e.md\', \'%e.html\', options=c(\'use_xhtml\', \'base64_images\'));"'

-- This is a kludge to run browse under the command name of run
textadept.run.run_commands.rmd = 'Rscript -e "browseURL(paste(\'file://\', file.path(getwd(),\'%e.html\'), sep=\'\'))"'

textadept.run.compile_commands.rmd = 'Rscript -e "library(rmarkdown); render(\'%e.md\');"'

-- This is a kludge to run knit and markdown2html as a single command under the name of compile
-- textadept.run.compile_commands.rmd = 'Rscript -e "require(knitr); knit(\'%e.Rmd\', \'%e.md\');require(markdown); markdownToHTML(\'%e.md\', \'%e.html\', options=c(\'use_xhtml\', \'base64_images\'));"'

-- textadept.run.run_commands.rmd = 'Rscript -e "require(markdown); markdownToHTML(\'%e.md\', \'%e.html\', options=c(\'use_xhtml\', \'base64_images\'));"'
-- textadept.run.run_commands.rmd = 'Rscript -e "browseURL(paste(\'file://\', file.path(getwd(),\'%e.html\'), sep=\'\'))"'

-- Underlines the current line.<br>
-- Parameter:<br>
-- _char_: "=" or "-".
function M.underline(char)
  local b = buffer
  b:begin_undo_action()
  b:line_end()
  caret = b.current_pos
  b:home()
  start = b.current_pos
  b:line_end()
  b:new_line()
  b:add_text(string.rep(char, caret - start))
  b:new_line()
  b:end_undo_action()
end

-- Sets the current line's header level.<br>
-- Parameter:<br>
-- _level_: 1 - 6
function M.header(level)
  local b = buffer
  local pos = b.current_pos
  b:begin_undo_action()
  editing.select_line()
  sel = b:get_sel_text()
  sel, count = sel:gsub('#+', string.rep('#', level))
  if count == 0 then
    b:home()
    b:add_text(string.rep('#', level)..' ')
    b:line_end()
  else
    b:replace_sel(sel)
    b:line_end()
  end
  b:end_undo_action()
end

-- Remove header symbols.
function M.remove_header()
  local b = buffer
  local pos = b.current_pos
  b:begin_undo_action()
  editing.select_line()
  sel = b:get_sel_text()
  sel = sel:gsub('#+ ', '')
  b:replace_sel(sel)
  b:line_end()
  b:end_undo_action()
end

-- Display word and char count in status bar.
function word_count()
  local buffer = buffer
  local text, length = buffer:get_text(buffer.get_length)
  if #text > 0 then text = text.." " end
  text = string.gsub(text, "^%s+", "")
  seps = string.gmatch(text, "%s+")
  local count = 0
  for i in seps do
    count = count + 1
  end
  status = 'Words: %d - Chars: %d'
  ui.statusbar_text = status:format(count, buffer.length)
end


-- ## Key Commands

-- rmd-specific key commands.
keys.rmd = {
  [not OSX and not CURSES and 'cl' or 'ml'] = {
    -- Open this module for editing: `Alt/⌘-L` `M`
    m = { io.open_file,
        (_USERHOME..'/modules/rmd/init.lua') },
    --  Show char and word count: `Alt/⌘-L` `I`
    i = { word_count },
  },
  -- Underline current line: `Alt/⌘ ='
  [OSX and 'm=' or 'a='] = { M.underline, '=' },
  -- Underline current line: `Alt/⌘ -`
  [OSX and 'm-' or 'a-'] = { M.underline, '-' },
  -- Change header level: `Alt/⌘-0 … 6`
  [OSX and 'm0' or 'a0'] = { M.remove_header },
  [OSX and 'm1' or 'a1'] = { M.header, 1 },
  [OSX and 'm2' or 'a2'] = { M.header, 2 },
  [OSX and 'm3' or 'a3'] = { M.header, 3 },
  [OSX and 'm4' or 'a4'] = { M.header, 4 },
  [OSX and 'm5' or 'a5'] = { M.header, 5 },
  [OSX and 'm6' or 'a6'] = { M.header, 6 },
  -- Enclose selected text or previous word:<br>
  -- `Alt/⌘ *`, `Alt/⌘ _`, ``Ctrl Alt/⌘ ` ``
  [OSX and 'm*' or 'a*'] = { editing.enclose, "*", "*" },
  [OSX and 'm_' or 'a_'] = { editing.enclose, '_', '_' },
  [OSX and 'cm`' or 'ca`'] = { editing.enclose, '`', '`' },
}



-- ## Snippets.

-- rmd-specific snippets.
snippets.rmd = {
  -- Headers.
  ['1'] = '# ',
  ['2'] = '## ',
  ['3'] = '### ',
  ['4'] = '#### ',
  ['5'] = '##### ',
  ['6'] = '###### ',
  -- Link.
  l = '[%1(Link)](%2(http://example.net/))',
  -- Clickable link.
  cl = '<%1(http://example.com/)>',
  --  Reference-style link.
  rl = '[%1(example)][%2(ref)]',
  id = '[%1(ref)]: %2(http://example.com/)',
  -- Code.
  c = '`%0`',
  -- Image.
  i = '![%1(Alt text)](%2(/path/to/img.jpg "Optional title"))',
}

-- Todo snippets:
-- block insertion
-- 

return M
