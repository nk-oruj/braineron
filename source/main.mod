MODULE braineron;

IMPORT
    Files,
    errors, options,
    parser;

VAR
    error : errors.Error;
    setup : options.SetupData;
BEGIN
    (* options parsing *)
    error := options.Setup(setup);
    IF error # NIL
    THEN
        errors.Raise(error, "meta");
        RETURN;
    END;

    (* program parsing *)
    error := parser.Parse(setup.sourceRider, setup.targetRider);
    IF error # NIL
    THEN
        errors.Raise(error, "error");
        RETURN;
    END;

    (* closing options setup *)
    options.CloseSetup(setup);
END braineron.