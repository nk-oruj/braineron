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
    escape      : ARRAY 9 OF CHAR;
    length      : INTEGER;
BEGIN
    (* allocate new error *)
    NEW(newError);
    newError.raise[0] := 0X;

    (* append escape seq for dark gray *)
    COPY(VT100.CSI, escape);
    Strings.Append(VT100.DarkGray, escape);
    Strings.Append(escape, newError.raise);

    (* append prefix of error label *)
    Strings.Append("> ", newError.raise);
    Strings.Append(label, newError.raise);
    Strings.Append(": ", newError.raise);

    (* append escape seq for reset *)
    COPY(VT100.CSI, escape);
    Strings.Append(VT100.ResetAll, escape);
    Strings.Append(escape, newError.raise);

    (* append error message *)
    Strings.Append(message, newError.raise);
    
    (* apeend line feed (handle platforms?) *)
    length := Strings.Length(newError.raise);
    newError.raise[length] := CHR(10);
    newError.raise[length + 1] := 0X;

    (* if piping up a specified error *)
    (* append previous error messages after *)
    (* to list messages in descending order *)
    IF error # NIL
    THEN
        Strings.Append(error.raise, newError.raise);
    END;

    (* return new error *)
    RETURN newError;
END Pipe;

PROCEDURE Raise*(error : Error; label : ARRAY OF CHAR);
VAR
    escape : ARRAY 9 OF CHAR;
BEGIN
    IF error = NIL
    THEN
        (* if raise is called without any error, then it's raise misuse *)
        Out.String(label);
        Out.String(": invalid raising");
        Out.Ln;
    ELSE
        (* if raise is called for a valid error *)

        (* print a padding line feed *)
        Out.Ln;
        
        (* print escape seq for red *)
        COPY(VT100.CSI, escape);
        Strings.Append(VT100.Red, escape);
        Out.String(escape);

        (* print escape seq for underline *)
        COPY(VT100.CSI, escape);
        Strings.Append(VT100.Underlined, escape);
        Out.String(escape);

        (* print label of raise *)
        Out.String(label);
        Out.Ln;  

        (* print escape seq for reset *)
        COPY(VT100.CSI, escape);
        Strings.Append(VT100.ResetAll, escape);
        Out.String(escape);
        
        (* print the piped messages *)
        Out.String(error.raise);

        (* print a padding line feed *)
        Out.Ln;
    END;
END Raise;

END errors.