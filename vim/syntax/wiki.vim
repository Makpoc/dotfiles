" Vim syntax file

if exists("b:current_syntax")
  finish
endif

syn match myBrackets '\[\|\]\|(\|)\|{\|}\|"\|\'' skipwhite
syn match myWikiStruct display '^{.*}$'
syn match myPriority display '^Priority:\s\*.*$' nextgroup=myPriorityValue skipwhite
syn match headerSymbol  display '^h\d\.' nextgroup=headers skipwhite
syn match headers contained display '.*' skipwhite
syn match myTable '|'
syn match bullet '^\s*\*\{1,}'
syn match olist '^\s*\#\{1,}'

hi def link myBrackets Character
hi def link myWikiStruct NonText
hi def link myPriority ModeMsg
hi def link headerSymbol LineNr
hi def link headers SpecialKey
hi def link myTable Character 
hi def link bullet LineNr
hi def link olist LineNr

let b:current_syntax = "wiki"
