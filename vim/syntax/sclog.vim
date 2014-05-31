if exists("b:current_syntax")
	finish
endif

syn keyword logError ERROR Error error
syn match errorPatterns display '[a-zA-Z.]*Exception' skipwhite
syn match date display '^\d\{4} \d\{2} \d\{2}' nextgroup=time skipwhite
syn match time contained display '\d\{2}:\d\{2}:\d\{2}\s[PA]M' nextgroup=logLevel skipwhite
syn match logLevel contained 'INFO\|DEBUG\|WARN' nextgroup=origin skipwhite
syn match origin contained display '\w\+' skipwhite

hi def link date LineNr
hi def link time LineNr
hi def link logLevel Identifier
hi def link origin ModeMsg
hi def link logError Error
hi def link errorPatterns Error
