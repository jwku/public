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





-------------------------------------------------
______________________________________________________________________

Model: Web Browsing

User
Im advanced with Excel, 0 vba knowledge. I'm struggling with this VBA, help me understand the first lil bit of this, don't worry about the rest yet: Option Explicit

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
ChatGPT
This script is designed to analyze the frequency of words and phrases in a column of text data in Excel. Here's a breakdown of the code:

Option Explicit: This forces you to declare all your variables before you use them. This can help avoid simple typos.

Sub Word_Phrase_Frequency_v1(): This starts a new subroutine, which is essentially a block of code that performs a specific task. In this case, the task is to analyze the frequency of words and phrases in a column of data.

Const sNumber As String = "1,2,3": This is a constant value that's being set. The string "1,2,3" refers to the phrase lengths that the script will analyze: 1-word, 2-word, and 3-word phrases.

Const xPattern As String = "A-Z0-9_'": This is another constant value that's being set. This string specifies what characters the script will consider as part of a word. In this case, it includes uppercase and lowercase letters (A-Z, a-z), numbers (0-9), underscores (_), and apostrophes (').

Const xCol As String = "C:ZZ": This is a constant that specifies the range of columns to clear before starting the analysis.

Dim i As Long, j As Long: These are variable declarations. i and j are both being declared as variables that can hold long integer values.

Application.ScreenUpdating = False: This line turns off screen updating, which can help the script run faster because Excel doesn't have to redraw the screen every time something changes.

Range(xCol).Clear: This line clears the contents of the range specified by xCol, which was set earlier as "C:ZZ".

On Error Resume Next: This line tells the script to continue running even if it encounters an error. It's usually used when you expect that there might be errors that you want to ignore.

Range("A:A").SpecialCells(xlCellTypeFormulas, xlErrors).ClearContents: This line clears any cells in column A that contain errors. The SpecialCells function is used to select cells that meet certain criteria - in this case, cells that contain errors.

On Error GoTo 0: This line turns off the error handling that was turned on by On Error Resume Next. This means that any errors encountered after this line will stop the script from running.

j = Range("A" & Rows.Count).End(xlUp).Row: This line is finding the last used row in column A. It does this by starting at the bottom of the spreadsheet (Rows.Count) and going up (End(xlUp)) until it finds a cell that's being used. The row number of that cell is then stored in the variable j.

The If j < 65000 Then block: This part of the script is reading in the data from column A. It does this differently depending on how many rows of data there are. If there are fewer than 65,000 rows, it reads in all the data at once. If there are more than 65,000 rows, it reads in the data in chunks of 65,000 rows at a time.

z = Split(sNumber, ","): This line splits the sNumber string into an array, using the comma as the delimiter.

For i = LBound(z) To UBound(z): This is the start of a loop that will run once for each item in thez array. LBound(z) gives the lower bound of the array (in this case, 0) and UBound(z) gives the upper bound (in this case, the number of elements in the array - 1).

Call toProcessY(CLng(z(i)), txa, xPattern): This line calls the toProcessY subroutine, which is defined later in the script. CLng(z(i)) converts the ith element of z to a Long data type, txa is the data from column A, and xPattern is the set of characters that make up words.

Range(xCol).Columns.AutoFit: This line automatically adjusts the width of the columns in the range xCol to fit the contents.

Debug.Print "It's done in: " & Timer - t & " seconds": This line prints out the time it took for the script to run to the Immediate window in the Visual Basic Editor.

End Sub: This marks the end of the Word_Phrase_Frequency_v1 subroutine.

Sub toProcessY(n As Long, ByVal tx As String, xP As String): This starts the toProcessY subroutine. It takes three arguments: n (the number of words in a phrase to analyze), tx (the text data), and xP (the set of characters that make up words).

The rest of the script is the toProcessY subroutine, which analyzes the frequency of n-word phrases in tx. It uses regular expressions (via the VBScript.RegExp object) to identify words and phrases, and a dictionary (via the Scripting.Dictionary object) to keep track of how often each phrase appears. Finally, it outputs the results to the next available column in the spreadsheet.





User
I do know js quite well, can you compare things above to what would be similar js code?
ChatGPT
Sure, I can show you a high-level equivalent of what the VBA script does, but it's important to note that JavaScript does not have the same built-in capabilities for manipulating Excel sheets. JavaScript is a general-purpose programming language that can be run in many different environments, whereas VBA is specifically designed to automate tasks in Microsoft Office applications.

Here's a simplified example of how some of the concepts might translate to JavaScript:

javascript
Copy code
function wordPhraseFrequency() {
  const sNumber = "1,2,3";
  const xPattern = "A-Z0-9_'";
  let txa = getTextData(); // this function would need to get the text data from somewhere

  const z = sNumber.split(",");
  
  for (let i = 0; i < z.length; i++) {
    toProcessY(parseInt(z[i]), txa, xPattern);
  }
}

function toProcessY(n, tx, xP) {
  const regEx = new RegExp(`[${xP}]+`, "g");

  let matches = tx.match(regEx);
  
  let frequency = {};
  for (let i = 0; i < matches.length; i++) {
    if (frequency[matches[i]]) {
      frequency[matches[i]]++;
    } else {
      frequency[matches[i]] = 1;
    }
  }

  // output the frequency dictionary somehow
}
In this code, the wordPhraseFrequency function is equivalent to the Word_Phrase_Frequency_v1 subroutine in VBA, and the toProcessY function is equivalent to the toProcessY subroutine.

Like the VBA script, the JavaScript code splits the sNumber string into an array and calls the toProcessY function for each item in the array. The toProcessY function then uses a regular expression to match words in the text data and builds up a frequency dictionary, which is similar to how the Scripting.Dictionary object is used in VBA.

Again, this is a very high-level and simplified comparison. The actual implementation would likely be much more complex in JavaScript, especially if you wanted to interact with Excel or some other spreadsheet software.





User
change this   // output the frequency dictionary somehow
 to some console.log()
ChatGPT
Sure, you can use console.log() to print out the contents of the frequency dictionary. Here's how you might do that:

javascript
Copy code
function toProcessY(n, tx, xP) {
  const regEx = new RegExp(`[${xP}]+`, "g");

  let matches = tx.match(regEx);
  
  let frequency = {};
  for (let i = 0; i < matches.length; i++) {
    if (frequency[matches[i]]) {
      frequency[matches[i]]++;
    } else {
      frequency[matches[i]] = 1;
    }
  }

  // output the frequency dictionary
  console.log(frequency);
}
With this modification, toProcessY will print out the frequency dictionary to the console every time it's called. Each key in the dictionary will be a word from the text data, and the value associated with each key will be the number of times that word appeared in the data.





User
bug: function wordPhraseFrequency() {
  const sNumber = "1,2,3";
  const xPattern = "A-Z0-9_'";
  let txa = getTextData(); // this function would need to get the text data from somewhere

  const z = sNumber.split(",");
  
  for (let i = 0; i < z.length; i++) {
    toProcessY(parseInt(z[i]), txa, xPattern);
  }
}

function toProcessY(n, tx, xP) {
  const regEx = new RegExp(`[${xP}]+`, "g");

  let matches = tx.match(regEx);
  
  let frequency = {};
  for (let i = 0; i < matches.length; i++) {
    if (frequency[matches[i]]) {
      frequency[matches[i]]++;
    } else {
      frequency[matches[i]] = 1;
    }
  }

  // output the frequency dictionary
  console.log(frequency);
}


00:54:25.029 undefined
ChatGPT
This error message indicates that getTextData() is undefined. This is because the getTextData function has not been declared in the provided code.

Here is a simple implementation of the getTextData function which retrieves a hardcoded string. You can replace this function with any way you want to retrieve your data:

javascript
Copy code
function getTextData() {
  return "This is some text data for testing purposes.";
}
After adding this function to your code, getTextData() will no longer be undefined, and the wordPhraseFrequency function should work as expected.

Here is your script with getTextData function added:

javascript
Copy code
function getTextData() {
  return "This is some text data for testing purposes.";
}

function wordPhraseFrequency() {
  const sNumber = "1,2,3";
  const xPattern = "A-Z0-9_'";
  let txa = getTextData(); 

  const z = sNumber.split(",");
  
  for (let i = 0; i < z.length; i++) {
    toProcessY(parseInt(z[i]), txa, xPattern);
  }
}

function toProcessY(n, tx, xP) {
  const regEx = new RegExp(`[${xP}]+`, "g");

  let matches = tx.match(regEx);
  
  let frequency = {};
  for (let i = 0; i < matches.length; i++) {
    if (frequency[matches[i]]) {
      frequency[matches[i]]++;
    } else {
      frequency[matches[i]] = 1;
    }
  }

  // output the frequency dictionary
  console.log(frequency);
}

wordPhraseFrequency();
This script should now print out the frequency of each character in the string returned by getTextData. If you want to process words instead of characters, you may need to adjust the regular expression and the way the text is processed.





User
function getTextData() {
  return "This is some text data for testing purposes.";
}

function wordPhraseFrequency() {
  const sNumber = "1,2,3";
  const xPattern = "A-Z0-9_'";
  let txa = getTextData(); 

  const z = sNumber.split(",");
  
  for (let i = 0; i < z.length; i++) {
    toProcessY(parseInt(z[i]), txa, xPattern);
  }
}

function toProcessY(n, tx, xP) {
  const regEx = new RegExp(`[${xP}]+`, "g");

  let matches = tx.match(regEx);
  
  let frequency = {};
  for (let i = 0; i < matches.length; i++) {
    if (frequency[matches[i]]) {
      frequency[matches[i]]++;
    } else {
      frequency[matches[i]] = 1;
    }
  }

  // output the frequency dictionary
  console.log(frequency);
}

wordPhraseFrequency();

00:55:57.772 VM260:32 {T: 1}
00:55:57.772 VM260:32 {T: 1}
00:55:57.772 VM260:32 {T: 1}
00:55:57.801 undefined
ChatGPT
The provided code only counts the frequency of each character, not words. It's because of the regular expression used, which matches each character individually.

If you want to count the frequency of each word, you need to adjust the regular expression to match whole words instead of individual characters.

Here's an updated version of your code:

javascript
Copy code
function getTextData() {
  return "This is some text data for testing purposes.";
}

function wordPhraseFrequency() {
  const sNumber = "1,2,3";
  let txa = getTextData(); 

  const z = sNumber.split(",");
  
  for (let i = 0; i < z.length; i++) {
    toProcessY(parseInt(z[i]), txa);
  }
}

function toProcessY(n, tx) {
  // Matches groups of 1 or more word characters (letters, numbers, or underscores)
  const regEx = /\b\w+\b/g;

  let matches = tx.match(regEx);
  
  let frequency = {};
  for (let i = 0; i < matches.length; i++) {
    if (frequency[matches[i]]) {
      frequency[matches[i]]++;
    } else {
      frequency[matches[i]] = 1;
    }
  }

  // output the frequency dictionary
  console.log(frequency);
}

wordPhraseFrequency();
In this updated version, the xPattern variable has been removed and replaced with a regular expression that matches whole words (\b\w+\b). This will count the frequency of each word in the text data, rather than each character.

Please note that this still does not handle the "n-gram" functionality of the original VBA script, which counts the frequency of phrases of n words. Implementing this in JavaScript would require more complex code to handle splitting the text into n-word phrases.





User
change it so that it is detecting frequency of 2-word and 3-word combinations
ChatGPT
To detect the frequency of 2-word and 3-word combinations (or n-word combinations in general), you can create a function that generates these combinations, and then use that function in your frequency count.

Here is your adjusted code:

javascript
Copy code
function getTextData() {
  return "This is some text data for testing purposes.";
}

function wordPhraseFrequency() {
  const sNumber = "1,2,3";
  let txa = getTextData(); 

  const z = sNumber.split(",");
  
  for (let i = 0; i < z.length; i++) {
    toProcessY(parseInt(z[i]), txa);
  }
}

function toProcessY(n, tx) {
  // Split the text into an array of words
  const words = tx.split(/\s+/);

  let frequency = {};
  for (let i = 0; i <= words.length - n; i++) {
    // Join together the next n words to form the phrase
    const phrase = words.slice(i, i + n).join(' ');

    if (frequency[phrase]) {
      frequency[phrase]++;
    } else {
      frequency[phrase] = 1;
    }
  }

  // output the frequency dictionary
  console.log(frequency);
}

wordPhraseFrequency();
In this adjusted version, the text is first split into an array of words. Then, for each word, it creates a phrase of n words by joining together the current word and the next n - 1 words. The frequency of each phrase is then counted in the same way as before.

Please note that this code assumes that tx contains the text data as a single string, with words separated by spaces. If your data is formatted differently, you may need to adjust the code accordingly.





User
The first action needs to remove all non-alphanumeric characters before other functions start
ChatGPT
If you need to remove all non-alphanumeric characters from the text before processing it, you can do so by adding an additional step at the beginning of the toProcessY function.

You can use the replace function with a regular expression to replace all non-alphanumeric characters with a space. The regular expression /[^a-z0-9_' ]+/gi matches all characters that are not alphanumeric (letters a-z and digits 0-9), underscores, apostrophes, or spaces. The i flag makes the match case-insensitive, and the g flag makes it global (match all occurrences, not just the first one).

Here's the updated code:

javascript
Copy code
function getTextData() {
  return "purposes This is some text data for testing purposes purposes. purposes This is some text data for testing purposes purposes. purposes This is some text data for testing purposes purposes testing purposes.";
}

function wordPhraseFrequency() {
  const sNumber = "1,2,3";
  let txa = getTextData(); 

  const z = sNumber.split(",");
  
  for (let i = 0; i < z.length; i++) {
    toProcessY(parseInt(z[i]), txa);
  }
}

function toProcessY(n, tx) {
  // Remove all non-alphanumeric characters
  tx = tx.replace(/[^a-z0-9_' ]+/gi, ' ');

  // Split the text into an array of words
  const words = tx.split(/\s+/);

  let frequency = {};
  for (let i = 0; i <= words.length - n; i++) {
    // Join together the next n words to form the phrase
    const phrase = words.slice(i, i + n).join(' ');

    if (frequency[phrase]) {
      frequency[phrase]++;
    } else {
      frequency[phrase] = 1;
    }
  }

  // output the frequency dictionary
  console.log(frequency);
}

wordPhraseFrequency();
Please note that this will replace all non-alphanumeric characters with a space, potentially creating additional word boundaries. If you want to remove these characters without creating additional word boundaries (for example, to treat "word1-word2" as a single word), you could replace non-alphanumeric characters with nothing ('') instead of a space (' ').
