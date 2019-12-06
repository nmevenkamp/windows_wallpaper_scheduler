Set objShell = CreateObject("Wscript.Shell")
Set args = Wscript.Arguments
For Each arg In args
	objShell.Run("powershell -windowstyle hidden -executionpolicy bypass -noninteractive ""&"" ""'" & arg & "'"""),0
Next