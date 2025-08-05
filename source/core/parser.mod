MODULE parser;
(* lachesis *)

IMPORT
    SYSTEM,
    Files,
    errors, format,
    scanner, generator;

(*  *)

TYPE
    ContextDataDesc = RECORD
        source, target  : Files.Rider;
        symbol, indent  : INTEGER;
    END;
    ContextData = POINTER TO ContextDataDesc;

(*  *)

PROCEDURE Accept(expected : INTEGER; VAR context : ContextData) : errors.Error;
VAR
    error : errors.Error;
    errorMessage : ARRAY 128 OF CHAR;
BEGIN
    IF context.symbol # expected
    THEN
        format.Clear(errorMessage);
        format.AppendStr(errorMessage, "token expected id ");
        format.AppendChr(errorMessage, CHR(48 + expected));
        format.AppendStr(errorMessage, ", received id ");
        format.AppendChr(errorMessage, CHR(48 + context.symbol));
        RETURN errors.Pipe(NIL, "syntax", errorMessage);
    END;

    scanner.Scan(context.symbol, context.source);
    RETURN NIL;
END Accept;

(*  *)

PROCEDURE^ RuleProgram*(VAR context : ContextData) : errors.Error;
PROCEDURE^ RuleContent*(VAR context : ContextData) : errors.Error;
PROCEDURE^ RuleLoop*(VAR context : ContextData) : errors.Error;
PROCEDURE^ RuleIncrease*(VAR context : ContextData) : errors.Error;
PROCEDURE^ RuleDecrease*(VAR context : ContextData) : errors.Error;
PROCEDURE^ RuleMoveRight*(VAR context : ContextData) : errors.Error;
PROCEDURE^ RuleMoveLeft*(VAR context : ContextData) : errors.Error;

(*  *)

PROCEDURE RuleIncrease*(VAR context : ContextData) : errors.Error;
VAR
    error   : errors.Error;
    counter : INTEGER;
    break   : BOOLEAN;
BEGIN
    counter := 0;
    break := FALSE;

    REPEAT
        IF context.symbol = scanner.increase
        THEN
            error := Accept(scanner.increase, context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
            counter := counter + 1;
        ELSE
            break := TRUE;
        END;
    UNTIL break;

    generator.WriteIncrease(context.target, counter, context.indent);

    RETURN NIL;
END RuleIncrease;

PROCEDURE RuleDecrease*(VAR context : ContextData) : errors.Error;
VAR
    error   : errors.Error;
    counter : INTEGER;
    break   : BOOLEAN;
BEGIN
    counter := 0;
    break := FALSE;

    REPEAT
        IF context.symbol = scanner.decrease
        THEN
            error := Accept(scanner.decrease, context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
            counter := counter + 1;
        ELSE
            break := TRUE;
        END;
    UNTIL break;

    generator.WriteDecrease(context.target, counter, context.indent);

    RETURN NIL;
END RuleDecrease;

PROCEDURE RuleMoveRight*(VAR context : ContextData) : errors.Error;
VAR
    error   : errors.Error;
    counter : INTEGER;
    break   : BOOLEAN;
BEGIN
    counter := 0;
    break := FALSE;

    REPEAT
        IF context.symbol = scanner.right
        THEN
            error := Accept(scanner.right, context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
            counter := counter + 1;
        ELSE
            break := TRUE;
        END;
    UNTIL break;

    generator.WriteMoveRight(context.target, counter, context.indent);

    RETURN NIL;
END RuleMoveRight;

PROCEDURE RuleMoveLeft*(VAR context : ContextData) : errors.Error;
VAR
    error   : errors.Error;
    counter : INTEGER;
    break   : BOOLEAN;
BEGIN
    counter := 0;
    break := FALSE;

    REPEAT
        IF context.symbol = scanner.left
        THEN
            error := Accept(scanner.left, context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
            counter := counter + 1;
        ELSE
            break := TRUE;
        END;
    UNTIL break;

    generator.WriteMoveLeft(context.target, counter, context.indent);

    RETURN NIL;
END RuleMoveLeft;

PROCEDURE RuleLoop*(VAR context : ContextData) : errors.Error;
VAR
    error           : errors.Error;
    errorMessage    : ARRAY 128 OF CHAR;
BEGIN

    error := Accept(scanner.fjump, context);
    IF error # NIL
    THEN
        format.Clear(errorMessage);
        format.AppendStr(errorMessage, "error in entering loop");
        RETURN errors.Pipe(error, "syntax", errorMessage);
    END;

    generator.WriteJumpForward(context.target, context.indent);

    context.indent := context.indent + 1;

    error := RuleContent(context);
    IF error # NIL
    THEN
        (* direct piping *)
        RETURN error;
    END;

    context.indent := context.indent - 1;

    error := Accept(scanner.bjump, context);
    IF error # NIL
    THEN
        format.Clear(errorMessage);
        format.AppendStr(errorMessage, "error in exiting loop");
        RETURN errors.Pipe(error, "syntax", errorMessage);
    END;

    generator.WriteJumpBackward(context.target, context.indent);

    RETURN NIL;
END RuleLoop;

PROCEDURE RuleContent*(VAR context : ContextData) : errors.Error;
VAR
    error : errors.Error;
BEGIN
    REPEAT
        IF context.symbol = scanner.right
        THEN
            error := RuleMoveRight(context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
        ELSIF context.symbol = scanner.left
        THEN
            error := RuleMoveLeft(context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
        ELSIF context.symbol = scanner.increase
        THEN
            error := RuleIncrease(context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
        ELSIF context.symbol = scanner.decrease
        THEN
            error := RuleDecrease(context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
        ELSIF context.symbol = scanner.input
        THEN
            error := Accept(scanner.input, context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
            generator.WriteInput(context.target, context.indent);
        ELSIF context.symbol = scanner.output
        THEN
            error := Accept(scanner.output, context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
            generator.WriteOutput(context.target, context.indent);
        ELSIF context.symbol = scanner.fjump
        THEN
            error := RuleLoop(context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
        ELSE
            RETURN NIL;
        END;
    UNTIL FALSE;

    RETURN NIL;
END RuleContent;

PROCEDURE RuleProgram*(VAR context : ContextData) : errors.Error;
VAR
    error           : errors.Error;
    errorMessage    : ARRAY 128 OF CHAR;
BEGIN
    generator.WriteMainStart(context.target);

    error := RuleContent(context);
    IF error # NIL
    THEN
        format.Clear(errorMessage);
        format.AppendStr(errorMessage, "error in parsing token at position ");
        format.AppendInt(errorMessage, SYSTEM.VAL(INTEGER, Files.Pos(context.source)));
        RETURN errors.Pipe(error, "syntax", errorMessage);
    END;

    error := Accept(scanner.eof, context);
    IF error # NIL
    THEN
        format.Clear(errorMessage);
        format.AppendStr(errorMessage, "error in parsing token at position ");
        format.AppendInt(errorMessage, SYSTEM.VAL(INTEGER, Files.Pos(context.source)));
        RETURN errors.Pipe(error, "syntax", errorMessage);
    END;

    generator.WriteMainEnd(context.target);

    RETURN NIL;
END RuleProgram;

(*  *)

PROCEDURE Parse*(VAR source, target : Files.Rider) : errors.Error;
VAR
    error           : errors.Error;
    errorMessage    : ARRAY 128 OF CHAR;
    context         : ContextData;
BEGIN
    (* initialize context datas *)
    NEW(context);
    context.source := source;
    context.target := target;
    context.indent := 0;
    scanner.Scan(context.symbol, context.source);

    (* run parsing rules *)
    error := RuleProgram(context);
    IF error # NIL
    THEN
        format.Clear(errorMessage);
        format.AppendStr(errorMessage, "error in parsing the source");
        RETURN errors.Pipe(error, "syntax", errorMessage);
    END;

    RETURN NIL;
END Parse;

END parser.