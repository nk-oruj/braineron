MODULE atropos;
(* scanner *)

IMPORT
    Files;
    
(*  *)

CONST
    eof*        = 0;
    invalid*    = 1;
    right*      = 2;
    left*       = 3;
    increase*   = 4;
    decrease*   = 5;
    input*      = 6;
    output*     = 7;
    fjump*      = 8;
    bjump*      = 9;

(*  *)

PROCEDURE Scan*(VAR symbol : INTEGER; VAR rider : Files.Rider);
VAR
    chr : CHAR;
BEGIN

    (* if control characters, skip through *)
    chr := 0X; WHILE (~rider.eof) & (chr <= " ")
    DO
        Files.Read(rider, chr);
    END;

    (* if end of file, return end of file symbol *)
    IF rider.eof
    THEN
        symbol := eof;
        RETURN;
    END;

    (* if potential comment, process through *)
    IF chr = "#"
    THEN
        WHILE (~rider.eof) & (chr # CHR(10))
        DO
            Files.Read(rider, chr);
        END;

        Scan(symbol, rider);
        RETURN;
    END;

    (* match through these characters *)
    IF chr = CHR(62)
    THEN
        symbol := right;
        RETURN;
    END;

    IF chr = CHR(60)
    THEN
        symbol := left;
        RETURN;
    END;

    IF chr = CHR(43)
    THEN
        symbol := increase;
        RETURN;
    END;

    IF chr = CHR(45)
    THEN
        symbol := decrease;
        RETURN;
    END;

    IF chr = CHR(44)
    THEN
        symbol := input;
        RETURN;
    END;

    IF chr = CHR(46)
    THEN
        symbol := output;
        RETURN;
    END;

    IF chr = CHR(91)
    THEN
        symbol := fjump;
        RETURN;
    END;

    IF chr = CHR(93)
    THEN
        symbol := bjump;
        RETURN;
    END;

    (* if nothing matches, then it's invalid character *)
    symbol := invalid;
    RETURN;

END Scan;

END atropos.