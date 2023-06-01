Option Explicit

Sub Word_Phrase_Frequency_v1()

' Keyboard Shortcut: Ctrl+q

'The code will generate word/phrase frequency
'How to use:
'1. Add reference to "Microsoft VBScript Regular Expressions 5.5" (you need to do it once only):
'   In Visual Basic Editor menu, select Tools –> References, then select Microsoft VBScript Regular Expressions 5.5, then click OK.
'2. Data must be in column A, start at A1
'3. Run Word_Phrase_Frequency_v1


'--- CHANGE sNumber & xPattern VALUE TO SUIT -----------------------------------

Const sNumber As String = "1,2,3"  '"1,2,3"
'sNumber = "1"  will generate 1 word frequency list
'sNumber = "1,2,3"  will generate 1 word, 2 word & 3 word frequency list

Const xPattern As String = "A-Z0-9_'"
'define the word characters, the above pattern will include letter, number, underscore & apostrophe as word character
'word with apostrophe such as "you're" counts as one word.
'word with underscore such as "aa_bb" counts as one word.


Const xCol As String = "C:ZZ" 'columns to clear
Dim i As Long, j As Long
Dim txa As String
Dim z, t

t = Timer
Application.ScreenUpdating = False
Range(xCol).Clear

'if there are errors, remove them
On Error Resume Next
Range("A:A").SpecialCells(xlCellTypeFormulas, xlErrors).ClearContents
Range("A:A").SpecialCells(xlConstants, xlErrors).ClearContents
On Error GoTo 0

j = Range("A" & Rows.Count).End(xlUp).Row

If j < 65000 Then
    txa = Join(Application.Transpose(Range("A1", Cells(Rows.Count, "A").End(xlUp))), " ")
Else
    For i = 1 To j Step 65000
    txa = txa & Join(Application.Transpose(Range("A" & i).Resize(65000)), " ") & " "
    Next
End If


z = Split(sNumber, ",")
    
    'TO PROCESS
    For i = LBound(z) To UBound(z)
        Call toProcessY(CLng(z(i)), txa, xPattern)
    Next

Range(xCol).Columns.AutoFit
Application.ScreenUpdating = True

Debug.Print "It's done in:  " & Timer - t & " seconds"

End Sub

Sub toProcessY(n As Long, ByVal tx As String, xP As String)
'phrase frequency

Dim regEx As Object, matches As Object, x As Object, d As Object
Dim i As Long, rc As Long
Dim va, q

        Set regEx = CreateObject("VBScript.RegExp")
        With regEx
            .Global = True
            .MultiLine = True
            .ignorecase = True
        End With

If n > 1 Then

        regEx.Pattern = "( ){2,}"

        If regEx.Test(tx) Then
           tx = regEx.Replace(tx, " ") 'remove excessive space
        End If
        
        tx = Trim(tx)
               
'        regEx.Pattern = "[^A-Z0-9_' ]+"
        regEx.Pattern = "[^" & xP & " ]+" 'exclude xp and space
        If regEx.Test(tx) Then
           tx = regEx.Replace(tx, vbLf) 'replace non words character (excluding space) with new line char (vbLf)
        End If
        
        tx = Replace(tx, vbLf & " ", vbLf & "") 'remove space in the beginning of every line

End If

    Set d = CreateObject("scripting.dictionary")
    d.CompareMode = vbTextCompare

'    regEx.Pattern = Trim(WorksheetFunction.Rept("[A-Z0-9_']+ ", n)) 'match n words (the phrase) separated by a space
    regEx.Pattern = Trim(WorksheetFunction.Rept("[" & xP & "]+ ", n)) 'match n words (the phrase) separated by a space
            Set matches = regEx.Execute(tx)
            
            For Each x In matches
                d(CStr(x)) = d(CStr(x)) + 1 'get phrase frequency
            Next
 
For i = 1 To n - 1
        
        regEx.Pattern = "^[" & xP & "]+ "
        If regEx.Test(tx) Then
           tx = regEx.Replace(tx, "")   'remove first word in each line to get different combination of n words (phrase)

'            regEx.Pattern = Trim(WorksheetFunction.Rept("[A-Z0-9_']+ ", n))
            regEx.Pattern = Trim(WorksheetFunction.Rept("[" & xP & "]+ ", n))
            
            Set matches = regEx.Execute(tx)
            
            For Each x In matches
                d(CStr(x)) = d(CStr(x)) + 1     'get phrase frequency
            Next

        End If
Next

If d.Count = 0 Then MsgBox "Nothing with " & n & " word phrase found": Exit Sub

rc = Cells(1, Columns.Count).End(xlToLeft).Column
'put the result

With Cells(2, rc + 2).Resize(d.Count, 2)
    
    Select Case d.Count
    Case Is < 65536 'Transpose function has a limit of 65536 item to process
        
        .Value = Application.Transpose(Array(d.Keys, d.Items))
        
    Case Is <= 1048500
        
        ReDim va(1 To d.Count, 1 To 2)
        i = 0
            For Each q In d.Keys
                i = i + 1
                va(i, 1) = q: va(i, 2) = d(q)
            Next
        .Value = va
    
    Case Else
        
        MsgBox "Process is canceled, the result is more than 1048500 rows"
    
    End Select
    
    .Sort Key1:=.Cells(1, 2), Order1:=xlDescending, Key2:=.Cells(1, 1), Order2:=xlAscending, Header:=xlNo
    
End With


Cells(1, rc + 2) = n & " WORD"
Cells(1, rc + 3) = "COUNT"

End Sub
