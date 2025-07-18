MODULE format;

PROCEDURE Clear*(VAR destination : ARRAY OF CHAR);
BEGIN
    (* if destination has capacity, then set first char null *)
    IF LEN(destination) > 0 THEN destination[0] := 0X; END;
END Clear;

PROCEDURE Length*(VAR destination : ARRAY OF CHAR) : INTEGER;
VAR
    capacity    : LONGINT;
    max         : INTEGER;
    index       : INTEGER;
BEGIN
    capacity    := LEN(destination);
    max         := MAX(INTEGER);

    (* while index is within capacity, index char is not null, and index isn't overflowing *)
    index := 0; WHILE (index < capacity) & (destination[index] # 0X) & (index < max)
    DO
        (* increase index *)
        index := index + 1;
    END;

    (* return iterated index as length *)
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
    
    (* while index is within str length and doesn't enlarge destination past its capacity *)
    index := 0; WHILE (index < lengthB) & (index + lengthA < capacity)
    DO
        (* append destination with str index char *)
        destination[index + lengthA] := str[index];
        (* increase index *)
        index := index + 1;
    END;

    IF (index + lengthA < capacity)
    THEN
        (* if appending index within destination capacity, set length-end char null *)
        destination[index + lengthA] := 0X;
    ELSE
        (* if appending index past destination capacity, set capacity-end char null *)
        destination[capacity - 1] := 0X;
    END;
END AppendStr;

PROCEDURE AppendChr*(VAR destination : ARRAY OF CHAR; chr : CHAR);
VAR
    lengthA : INTEGER;
BEGIN
    lengthA := Length(destination);

    (* if destination length is not filling whole destination capacity *)
    IF lengthA + 1 < LEN(destination)
    THEN
        (* append the given char *)
        destination[lengthA] := chr;
        (* append null char *)
        destination[lengthA + 1] := 0X;
    END;
END AppendChr;

PROCEDURE AppendInt*(VAR destination : ARRAY OF CHAR; int : INTEGER);
BEGIN
END AppendInt;

PROCEDURE AppendFlt*(VAR destination : ARRAY OF CHAR; flt : REAL);
BEGIN
END AppendFlt;

END format.