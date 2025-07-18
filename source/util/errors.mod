MODULE errors;

IMPORT
    Strings, Out, VT100;

TYPE
    ErrorDesc = RECORD
        raise : ARRAY 1024 OF CHAR;
    END;
    Error* = POINTER TO ErrorDesc;

PROCEDURE Pipe*(error : Error; label, description : ARRAY OF CHAR) : Error;
VAR
    newError    : Error;
    newLength   : INTEGER;
    escape      : ARRAY 9 OF CHAR;
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

    (* append error description *)
    Strings.Append(description, newError.raise);
    
    (* append line feed (handle platforms?) *)
    newLength := Strings.Length(newError.raise);
    newError.raise[newLength] := CHR(10);
    newError.raise[newLength + 1] := 0X;

    (* if piping up a specified error *)
    IF error # NIL
    THEN
        (* append previous error descriptions afterwards (desc ord) *)
        Strings.Append(error.raise, newError.raise);
    END;

    (* return new error *)
    RETURN newError;

END Pipe;

PROCEDURE Raise*(error : Error; label : ARRAY OF CHAR);
VAR
    escape : ARRAY 9 OF CHAR;
BEGIN

    (* if raise is called without any error *)
    IF error = NIL
    THEN
        (* print raise misuse *)
        Out.String(label);
        Out.String(": invalid raising");
        Out.Ln;

        RETURN;
    END;
     
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
    
    (* print the piped descriptions *)
    Out.String(error.raise);

    (* print a padding line feed *)
    Out.Ln;

END Raise;

END errors.