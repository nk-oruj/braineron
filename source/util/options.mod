MODULE options;

IMPORT
    Args, Files,
    errors, format;

(*  *)

TYPE
    SetupDataDesc = RECORD
        sourceFile, targetFile      : Files.File;
        sourceRider*, targetRider*  : Files.Rider;
    END;
    SetupData* = POINTER TO SetupDataDesc;

(*  *)

PROCEDURE Setup*(VAR setup : SetupData) : errors.Error;
VAR
    errorMessage            : ARRAY 256 OF CHAR;
    sourcePath, targetPath  : ARRAY 128 OF CHAR;
BEGIN
    NEW(setup);

    IF Args.argc # 3
    THEN
        RETURN errors.Pipe(NIL, "options", "error in usage: braineron <source> <target>");
    END;

    Args.Get(1, sourcePath);
    Args.Get(2, targetPath);
    
    setup.sourceFile := Files.Old(sourcePath);
    IF setup.sourceFile = NIL
    THEN
        format.Clear(errorMessage);
        format.AppendStr(errorMessage, "source not found at ");
        format.AppendChr(errorMessage, CHR(34));
        format.AppendStr(errorMessage, sourcePath);
        format.AppendChr(errorMessage, CHR(34));
        RETURN errors.Pipe(NIL, "options", errorMessage);
    END;
    Files.Set(setup.sourceRider, setup.sourceFile, 0);

    setup.targetFile := Files.New(targetPath);
    IF setup.sourceFile = NIL
    THEN
        format.Clear(errorMessage);
        format.AppendStr(errorMessage, "target not found at ");
        format.AppendChr(errorMessage, CHR(34));
        format.AppendStr(errorMessage, sourcePath);
        format.AppendChr(errorMessage, CHR(34));
        RETURN errors.Pipe(NIL, "options", errorMessage);
    END;
    Files.Set(setup.targetRider, setup.targetFile, 0);

    RETURN NIL;
END Setup;

PROCEDURE CloseSetup*(VAR setup : SetupData);
BEGIN
    Files.Close(setup.sourceFile);
    Files.Register(setup.targetFile);
END CloseSetup;

END options.