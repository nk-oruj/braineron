MODULE generator;
(* clotho *)

IMPORT
    Files,
    format;

(*  *)

PROCEDURE WriteMainStart*(VAR rider : Files.Rider);
VAR
    instruct : ARRAY 128 OF CHAR;
BEGIN
    format.Clear(instruct);
    format.AppendStr(instruct, "MODULE main;");
    format.AppendChr(instruct, CHR(10));
    format.AppendStr(instruct, "IMPORT In, Out;");
    format.AppendChr(instruct, CHR(10));
    format.AppendStr(instruct, "VAR");
    format.AppendChr(instruct, CHR(10));
    format.AppendStr(instruct, "    arr : ARRAY 1024 OF CHAR;");
    format.AppendChr(instruct, CHR(10));
    format.AppendStr(instruct, "    ind : INTEGER;");
    format.AppendChr(instruct, CHR(10));
    format.AppendStr(instruct, "BEGIN");
    format.AppendChr(instruct, CHR(10));
    Files.WriteBytes(rider, instruct, format.Length(instruct));
END WriteMainStart;

PROCEDURE WriteMainEnd*(VAR rider : Files.Rider);
VAR
    instruct : ARRAY 128 OF CHAR;
BEGIN
    format.Clear(instruct);
    format.AppendStr(instruct, "    Out.Ln;");
    format.AppendChr(instruct, CHR(10));
    format.AppendStr(instruct, "END main.");
    format.AppendChr(instruct, CHR(10));
    Files.WriteBytes(rider, instruct, format.Length(instruct));
    Files.Write(rider, CHR(10));
END WriteMainEnd;

PROCEDURE WriteIncrease*(VAR rider : Files.Rider; value, indent : INTEGER);
VAR
    instruct : ARRAY 128 OF CHAR;
BEGIN
    format.Clear(instruct);

    WHILE indent > 0
    DO
        format.AppendStr(instruct, "    ");
        indent := indent - 1;
    END;

    format.AppendStr(instruct, "    arr[ind MOD 1024] := CHR(ORD(arr[ind MOD 1024]) + ");
    format.AppendInt(instruct, value);
    format.AppendStr(instruct, ");");
    format.AppendChr(instruct, CHR(10));
    Files.WriteBytes(rider, instruct, format.Length(instruct));
END WriteIncrease;

PROCEDURE WriteDecrease*(VAR rider : Files.Rider; value, indent : INTEGER);
VAR
    instruct : ARRAY 128 OF CHAR;
BEGIN
    format.Clear(instruct);

    WHILE indent > 0
    DO
        format.AppendStr(instruct, "    ");
        indent := indent - 1;
    END;

    format.AppendStr(instruct, "    arr[ind MOD 1024] := CHR(ORD(arr[ind MOD 1024]) - ");
    format.AppendInt(instruct, value);
    format.AppendStr(instruct, ");");
    format.AppendChr(instruct, CHR(10));
    Files.WriteBytes(rider, instruct, format.Length(instruct));
END WriteDecrease;

PROCEDURE WriteMoveRight*(VAR rider : Files.Rider; value, indent : INTEGER);
VAR
    instruct : ARRAY 128 OF CHAR;
BEGIN
    format.Clear(instruct);

    WHILE indent > 0
    DO
        format.AppendStr(instruct, "    ");
        indent := indent - 1;
    END;
    
    format.AppendStr(instruct, "    ind := ind + ");
    format.AppendInt(instruct, value);
    format.AppendStr(instruct, ";");
    format.AppendChr(instruct, CHR(10));
    Files.WriteBytes(rider, instruct, format.Length(instruct));
END WriteMoveRight;

PROCEDURE WriteMoveLeft*(VAR rider : Files.Rider; value, indent : INTEGER);
VAR
    instruct : ARRAY 128 OF CHAR;
BEGIN
    format.Clear(instruct);

    WHILE indent > 0
    DO
        format.AppendStr(instruct, "    ");
        indent := indent - 1;
    END;
    
    format.AppendStr(instruct, "    ind := ind - ");
    format.AppendInt(instruct, value);
    format.AppendStr(instruct, ";");
    format.AppendChr(instruct, CHR(10));
    Files.WriteBytes(rider, instruct, format.Length(instruct));
END WriteMoveLeft;

PROCEDURE WriteJumpForward*(VAR rider : Files.Rider; indent : INTEGER);
VAR
    instruct : ARRAY 128 OF CHAR;
BEGIN
    format.Clear(instruct);

    WHILE indent > 0
    DO
        format.AppendStr(instruct, "    ");
        indent := indent - 1;
    END;
    
    format.AppendStr(instruct, "    WHILE arr[ind MOD 1024] # 0X DO");
    format.AppendChr(instruct, CHR(10));
    Files.WriteBytes(rider, instruct, format.Length(instruct));
END WriteJumpForward;

PROCEDURE WriteJumpBackward*(VAR rider : Files.Rider; indent : INTEGER);
VAR
    instruct : ARRAY 128 OF CHAR;
BEGIN
    format.Clear(instruct);

    WHILE indent > 0
    DO
        format.AppendStr(instruct, "    ");
        indent := indent - 1;
    END;
    
    format.AppendStr(instruct, "    END;");
    format.AppendChr(instruct, CHR(10));
    Files.WriteBytes(rider, instruct, format.Length(instruct));
END WriteJumpBackward;

PROCEDURE WriteInput*(VAR rider : Files.Rider; indent : INTEGER);
VAR
    instruct : ARRAY 128 OF CHAR;
BEGIN
    format.Clear(instruct);

    WHILE indent > 0
    DO
        format.AppendStr(instruct, "    ");
        indent := indent - 1;
    END;
    
    format.AppendStr(instruct, "    In.Char(arr[ind MOD 1024]);");
    format.AppendChr(instruct, CHR(10));
    Files.WriteBytes(rider, instruct, format.Length(instruct));
END WriteInput;

PROCEDURE WriteOutput*(VAR rider : Files.Rider; indent : INTEGER);
VAR
    instruct : ARRAY 128 OF CHAR;
BEGIN
    format.Clear(instruct);

    WHILE indent > 0
    DO
        format.AppendStr(instruct, "    ");
        indent := indent - 1;
    END;
    
    format.AppendStr(instruct, "    Out.Char(arr[ind MOD 1024]);");
    format.AppendChr(instruct, CHR(10));
    Files.WriteBytes(rider, instruct, format.Length(instruct));
END WriteOutput;


END generator.