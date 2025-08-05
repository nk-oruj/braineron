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
VAR
  index, digit, length  : INTEGER;
  isNegative            : BOOLEAN;
  temp                  : ARRAY 16 OF CHAR;
BEGIN
    (* check zero value *)
    IF int = 0 THEN
        destination[0] := "0";
        destination[1] := 0X;
        RETURN;
    END;

    (* check negative value *)
    isNegative := FALSE;
    IF int < 0 THEN
        isNegative := TRUE;
        int := -int;
    END;

    (* stack the digits *)
    index := 0; WHILE int # 0
    DO
        digit := int MOD 10;
        temp[index] := CHR(48 + digit);
        index := index + 1;
        int := int DIV 10;
    END;

    (* append minus if needed *)
    IF isNegative
    THEN
        AppendChr(destination, "-");
    END;

    (* append stacked digits *)
    WHILE index > 0
    DO
        index := index - 1;
        AppendChr(destination, temp[index]);
    END;
END AppendInt;

PROCEDURE AppendFlt*(VAR destination : ARRAY OF CHAR; flt : REAL);
BEGIN
END AppendFlt;

(*  *)

END format.