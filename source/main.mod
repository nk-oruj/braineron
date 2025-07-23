MODULE braineron;

IMPORT
    Files,
    errors, options,
    lachesis;

VAR
    error : errors.Error;
    setup : options.SetupData;
BEGIN
    error := options.Setup(setup);
    IF error # NIL
    THEN
        errors.Raise(error, "meta");
        RETURN;
    END;

    error := lachesis.Parse(setup.sourceRider, setup.targetRider);
    IF error # NIL
    THEN
        errors.Raise(error, "error");
        RETURN;
    END;

    options.CloseSetup(setup);
END braineron.