MODULE braineron;

IMPORT
    Files,
    errors, options,
    lachesis;

VAR
    error : errors.Error;
    setup : options.SetupData;
BEGIN
    (* parse compiler options *)
    error := options.Setup(setup);
    IF error # NIL
    THEN
        errors.Raise(error, "meta");
        RETURN;
    END;

    (* parse given source to target *)
    error := lachesis.Parse(setup.sourceRider, setup.targetRider);
    IF error # NIL
    THEN
        errors.Raise(error, "error");
        RETURN;
    END;

    (* process setup afterwards *)
    options.CloseSetup(setup);
END braineron.