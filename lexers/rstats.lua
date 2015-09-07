-- Copyright 2006-2015 Mitchell mitchell.att.foicica.com. See LICENSE.
-- R LPeg lexer.

local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'rstats'}

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Comments.
local comment = token(l.COMMENT, '#' * l.nonnewline^0)

-- Strings.
local sq_str = l.delimited_range("'", true)
local dq_str = l.delimited_range('"', true)
local string = token(l.STRING, sq_str + dq_str)

-- Numbers.
local number = token(l.NUMBER, (l.float + l.integer) * P('i')^-1)

-- Keywords.
local keyword = token(l.KEYWORD, word_match{
  'break', 'else', 'for', 'if', 'in', 'next', 'repeat', 'return', 'switch',
  'try', 'while', 'Inf', 'NA', 'NaN', 'NULL', 'FALSE', 'TRUE'
})

-- Types.
local type = token(l.TYPE, word_match{
  'array', 'character', 'complex', 'data.frame', 'double', 'factor', 'function',
  'integer', 'list', 'logical', 'matrix', 'numeric', 'vector'
})

-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)

-- Operators.
local operator = token(l.OPERATOR, S('<->+*/^=.,:;|$()[]{}'))


-- Functions
local funcs= token( l.FUNCTION, word_match{
'NCOL', 'NROW', 'UseMethod', 'abline', 'abs', 'all', 'any', 'apply', 'array', 'as', 'as.character', 'as.data.frame', 'as.double', 'as.factor', 'as.formula', 'as.integer', 'as.list', 'as.logical', 'as.matrix', 'as.name', 'as.numeric', 'as.vector', 'assign', 'attr', 'attributes', 'axis', 'c', 'cat', 'cbind', 'ceiling', 'character', 'checkPtrType', 'class', 'coef', 'colSums', 'colnames', 'cos', 'crossprod', 'cumsum', 'data.frame', 'deparse', 'diag', 'diff', 'dim', 'dimnames', 'dnorm', 'do.call', 'double', 'drop', 'eigen', 'enter', 'environment', 'errorCondition', 'eval', 'exists', 'exit', 'exp', 'expression', 'factor', 'file.path', 'floor', 'for', 'format', 'formatC', 'function', 'get', 'getOption', 'gettextRcmdr', 'grep', 'gsub', 'identical', 'if', 'ifelse', 'in', 'inherits', 'integer', 'invisible', 'is', 'is.character', 'is.data.frame', 'is.element', 'is.factor', 'is.finite', 'is.function', 'is.list', 'is.logical', 'is.matrix', 'is.na', 'is.null', 'is.numeric', 'is.vector', 'isGeneric', 'justDoIt', 'lapply', 'legend', 'length', 'levels', 'library', 'lines', 'list', 'lm', 'log', 'logger', 'match', 'match.arg', 'match.call', 'matrix', 'max', 'mean', 'median', 'message', 'min', 'missing', 'mode', 'model.frame', 'model.matrix', 'mtext', 'na.omit', 'names', 'nchar', 'ncol', 'new', 'nrow', 'numeric', 'on.exit', 'optim', 'options', 'order', 'outer', 'par', 'parent.frame', 'parse', 'paste', 'pchisq', 'plot', 'pmax', 'pnorm', 'points', 'predict', 'print', 'prod', 'qnorm', 'quantile', 'range', 'rbind', 'rep', 'rep.int', 'representation', 'require', 'return', 'rev', 'rm', 'rnorm', 'round', 'row.names', 'rowSums', 'rownames', 'runif', 'sQuote', 'sample', 'sapply', 'sd', 'segments', 'seq', 'seq_len', 'setClass', 'setGeneric', 'setMethod', 'setMethodS3', 'setdiff', 'sign', 'signature', 'signif', 'sin', 'slot', 'solve', 'sort', 'sprintf', 'sqrt', 'standardGeneric', 'stop', 'stopifnot', 'storage.mode', 'str', 'strsplit', 'structure', 'sub', 'substitute', 'substr', 'substring', 'sum', 'summary', 'svalue', 'sweep', 'switch', 't', 'table', 'tapply', 'tclVar', 'tclvalue', 'terms', 'text', 'theWidget', 'throw', 'title', 'tkadd', 'tkbind', 'tkbutton', 'tkconfigure', 'tkdestroy', 'tkentry', 'tkfocus', 'tkframe', 'tkgrid', 'tkgrid.configure', 'tkinsert', 'tklabel', 'tkpack', 'try', 'unclass', 'unique', 'unit', 'unlist', 'var', 'vector', 'warning', 'which', 'while', 'write'
})

M._rules = {
  {'whitespace', ws},
  {'keyword', keyword},
  {'type', type},
  {'function', funcs},
  {'identifier', identifier},
  {'string', string},
  {'comment', comment},
  {'number', number},
  {'operator', operator},
}

M._foldsymbols = {
  [l.OPERATOR] = {['{'] = 1, ['}'] = -1},
  _patterns = {'[{}]'}
}

return M
