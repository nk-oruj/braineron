MODULE errors;
IMPORT Strings, Out, VT100;

TYPE
    ErrorDesc = RECORD
        raise : ARRAY 1024 OF CHAR;
    END;

    Error* = POINTER TO ErrorDesc;


PROCEDURE Pipe*(error : Error; label, message : ARRAY OF CHAR) : Error;
VAR
    newError    : Error;
    length      : INTEGER;
    escape      : ARRAY 9 OF CHAR;
BEGIN
    NEW(newError);
    newError.raise[0] := 0X;

    COPY(VT100.CSI, escape);
    Strings.Append(VT100.DarkGray, escape);
    Strings.Append(escape, newError.raise);


    Strings.Append("> ", newError.raise);
    Strings.Append(label, newError.raise);
    Strings.Append(": ", newError.raise);

    COPY(VT100.CSI, escape);
    Strings.Append(VT100.ResetAll, escape);
    Strings.Append(escape, newError.raise);

    Strings.Append(message, newError.raise);
    
    length := Strings.Length(newError.raise);

    newError.raise[length] := CHR(10);
    newError.raise[length + 1] := 0X;

    IF error # NIL
    THEN
        Strings.Append(error.raise, newError.raise);
    END;

    RETURN newError;
END Pipe;

PROCEDURE Raise*(error : Error; label : ARRAY OF CHAR);
VAR
    buffer : ARRAY 1024 OF CHAR;
    escape : ARRAY 9 OF CHAR;
BEGIN
    IF error = NIL
    THEN
        Out.String(label);
        Out.String(": invalid raising");
        Out.Ln;
    ELSE
        Out.Ln;
        
        COPY(VT100.CSI, escape);
        Strings.Append(VT100.Red, escape);
        Out.String(escape);

        COPY(VT100.CSI, escape);
        Strings.Append(VT100.Underlined, escape);
        Out.String(escape);

        Out.String(label);    

        COPY(VT100.CSI, escape);
        Strings.Append(VT100.ResetAll, escape);
        Out.String(escape);
        
        Out.Ln;
        Out.String(error.raise);
        Out.Ln;
    END;
END Raise;

END errors.