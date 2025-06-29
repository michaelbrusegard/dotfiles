Import-Module pure-pwsh
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -AddToHistoryHandler { param($line) -return $line -notmatch '^\s' }
Set-PSReadLineOption -MaximumHistoryCount 10000
Set-PSReadLineOption -ViModeIndicator Cursor
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineKeyHandler -Key "Ctrl+p" -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key "Ctrl+n" -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key "Ctrl+y" -Function AcceptSuggestion
