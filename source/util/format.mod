MODULE format;

(*  *)

PROCEDURE Clear*(VAR destination : ARRAY OF CHAR);
BEGIN
    IF LEN(destination) > 0
    THEN
        destination[0] := 0X;
    END;
END Clear;

PROCEDURE Length*(VAR destination : ARRAY OF CHAR) : INTEGER;
VAR
    capacity    : LONGINT;
    max         : INTEGER;
    index       : INTEGER;
BEGIN
    capacity    := LEN(destination);
    max         := MAX(INTEGER);

    index := 0; WHILE (index < capacity) & (destination[index] # 0X) & (index < max)
    DO
        index := index + 1;
    END;

    RETURN index;
END Length;

(*  *)

PROCEDURE AppendStr*(VAR destination : ARRAY OF CHAR; str : ARRAY OF CHAR);
VAR
    capacity    : LONGINT;
    lengthA     : INTEGER;
    lengthB     : INTEGER;
    index       : INTEGER;
BEGIN
    capacity    := LEN(destination);
    lengthA     := Length(destination);
    lengthB     := Length(str);
    
    index := 0; WHILE (index < lengthB) & (index + lengthA < capacity)
    DO
        destination[index + lengthA] := str[index];
        index := index + 1;
    END;

    IF (index + lengthA < capacity)
    THEN
        destination[index + lengthA] := 0X;
    ELSE
        destination[capacity - 1] := 0X;
    END;
END AppendStr;

PROCEDURE AppendChr*(VAR destination : ARRAY OF CHAR; chr : CHAR);
VAR
    length: INTEGER;
BEGIN
    length := Length(destination);

    IF length + 1 < LEN(destination)
    THEN
        destination[length] := chr;
        destination[length + 1] := 0X;
    END;
END AppendChr;

PROCEDURE AppendInt*(VAR destination : ARRAY OF CHAR; int : INTEGER);
BEGIN
END AppendInt;

PROCEDURE AppendFlt*(VAR destination : ARRAY OF CHAR; flt : REAL);
BEGIN
END AppendFlt;

(*  *)

END format.