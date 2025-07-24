MODULE lachesis;
(* parser *)

IMPORT 
    Files,
    errors, format,
    atropos, clotho;

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
        format.AppendStr(errorMessage, "token expected ");
        format.AppendChr(errorMessage, CHR(34));
        format.AppendChr(errorMessage, CHR(48 + expected));
        format.AppendChr(errorMessage, CHR(34));
        format.AppendStr(errorMessage, ", received ");
        format.AppendChr(errorMessage, CHR(34));
        format.AppendChr(errorMessage, CHR(48 + context.symbol));
        format.AppendChr(errorMessage, CHR(34));
        RETURN errors.Pipe(NIL, "syntax", errorMessage);
    END;

    atropos.Scan(context.symbol, context.source);
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
        IF context.symbol = atropos.increase
        THEN
            error := Accept(atropos.increase, context);
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

    clotho.WriteIncrease(context.target, counter, context.indent);

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
        IF context.symbol = atropos.decrease
        THEN
            error := Accept(atropos.decrease, context);
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

    clotho.WriteDecrease(context.target, counter, context.indent);

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
        IF context.symbol = atropos.right
        THEN
            error := Accept(atropos.right, context);
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

    clotho.WriteMoveRight(context.target, counter, context.indent);

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
        IF context.symbol = atropos.left
        THEN
            error := Accept(atropos.left, context);
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

    clotho.WriteMoveLeft(context.target, counter, context.indent);

    RETURN NIL;
END RuleMoveLeft;

PROCEDURE RuleLoop*(VAR context : ContextData) : errors.Error;
VAR
    error           : errors.Error;
    errorMessage    : ARRAY 128 OF CHAR;
BEGIN

    error := Accept(atropos.fjump, context);
    IF error # NIL
    THEN
        format.Clear(errorMessage);
        format.AppendStr(errorMessage, "error in entering loop");
        RETURN errors.Pipe(error, "syntax", errorMessage);
    END;

    clotho.WriteJumpForward(context.target, context.indent);

    context.indent := context.indent + 1;

    error := RuleContent(context);
    IF error # NIL
    THEN
        (* direct piping *)
        RETURN error;
    END;

    context.indent := context.indent - 1;

    error := Accept(atropos.bjump, context);
    IF error # NIL
    THEN
        format.Clear(errorMessage);
        format.AppendStr(errorMessage, "error in exiting loop");
        RETURN errors.Pipe(error, "syntax", errorMessage);
    END;

    clotho.WriteJumpBackward(context.target, context.indent);

    RETURN NIL;
END RuleLoop;

PROCEDURE RuleContent*(VAR context : ContextData) : errors.Error;
VAR
    error : errors.Error;
BEGIN
    REPEAT
        IF context.symbol = atropos.right
        THEN
            error := RuleMoveRight(context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
        ELSIF context.symbol = atropos.left
        THEN
            error := RuleMoveLeft(context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
        ELSIF context.symbol = atropos.increase
        THEN
            error := RuleIncrease(context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
        ELSIF context.symbol = atropos.decrease
        THEN
            error := RuleDecrease(context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
        ELSIF context.symbol = atropos.input
        THEN
            error := Accept(atropos.input, context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
            clotho.WriteInput(context.target, context.indent);
        ELSIF context.symbol = atropos.output
        THEN
            error := Accept(atropos.output, context);
            IF error # NIL
            THEN
                (* direct piping *)
                RETURN error;
            END;
            clotho.WriteOutput(context.target, context.indent);
        ELSIF context.symbol = atropos.fjump
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
    clotho.WriteMainStart(context.target);

    error := RuleContent(context);
    IF error # NIL
    THEN
        (* direct piping *)
        RETURN error;
    END;

    error := Accept(atropos.eof, context);
    IF error # NIL
    THEN
        format.Clear(errorMessage);
        format.AppendStr(errorMessage, "error in parsing eof");
        RETURN errors.Pipe(error, "syntax", errorMessage);
    END;

    clotho.WriteMainEnd(context.target);

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
    atropos.Scan(context.symbol, context.source);

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

END lachesis.