MODULE format;

PROCEDURE Clear*(VAR destination : ARRAY OF CHAR);
BEGIN
    IF LEN(destination) > 0
    THEN
        destination[0] := 0X;
    END;
END Clear;

PROCEDURE Length*(VAR destination : ARRAY OF CHAR) : INTEGER;
VAR
    destinationCapacity : LONGINT;
    integerMax, index : INTEGER;
BEGIN
    destinationCapacity := LEN(destination);
    integerMax := MAX(INTEGER);
    index := 0;

    WHILE (index < destinationCapacity) & (destination[index] # 0X) & (index < integerMax)
    DO
        index := index + 1;
    END;

    RETURN index;
END Length;

PROCEDURE AppendStr*(VAR destination : ARRAY OF CHAR; str : ARRAY OF CHAR);
VAR
    destinationCapacity : LONGINT;
    destinationLength, strLength, index : INTEGER;
BEGIN
    destinationCapacity := LEN(destination);
    destinationLength := Length(destination);
    strLength := Length(str);
    index := 0;

    WHILE (index < strLength) & (index + destinationLength < destinationCapacity)
    DO
        destination[index + destinationLength] := str[index];
        index := index + 1;
    END;

    IF (index + destinationLength < destinationCapacity)
    THEN
        destination[index + destinationLength] := 0X;
    ELSE
        destination[destinationCapacity - 1] := 0X;
    END;

END AppendStr;

PROCEDURE AppendChr*(VAR destination : ARRAY OF CHAR; chr : CHAR);
VAR
    destinationLength : INTEGER;
BEGIN
    destinationLength := Length(destination);

    IF destinationLength + 1 < LEN(destination)
    THEN
        destination[destinationLength] := chr;
        destination[destinationLength + 1] := 0X;
    END;
END AppendChr;

PROCEDURE AppendInt*(VAR destination : ARRAY OF CHAR; int : INTEGER);
BEGIN
END AppendInt;

PROCEDURE AppendFlt*(VAR destination : ARRAY OF CHAR; flt : REAL);
BEGIN
END AppendFlt;

END format.