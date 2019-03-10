# .inputrc file

## Ignore case with tab completing \
`set completion-ignore-case on`

## If it matches more than one, show them
`set show-all-if-ambiguous on`

## Turn off the annoying bell
`set bell-style visible` \

## Hoping Apple with use BASH 4 one day
`set skip-completed-text on` \
`set colored-stats on` \
`set colored-completion-prefix on` \

## Magic space
Turn history references into text after spacing after\
*Prevents you from running unaticipated cammands when accessing older history* \
`!!` Will become the last line \
`!$` Will become the last parameter \
`!-3` Will become the 3rd last line \
`!-5:0` Will before the command you ran 5 lines ago \
`!-4:$` Will become the last parameter from 4 lines ago \
`Space: magic-space`

## Completes word and not part of
`TAB: menu-complete`

## Search history by start of line
`"\e[A": history-search-backward`
`"\e[B": history-search-forward`


