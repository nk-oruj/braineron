# braineron
brainfuck compiler written on oberon compiling oberon

## deps
voc - https://github.com/vishapoberon/compiler

## usage

#### compile braineron
```
make build
make delete
```

#### execute braineron
```
./braineron <source> <target>
voc <target> -m
```

#### execute the program
```
./main
```

## syntax

|token|purpose|
|---|---|
|`+`|increase pointed data|
|`-`|decrease pointed data|
|`>`|move data pointer right|
|`<`|move data pointer left|
|`.`|output from pointed data cell|
|`,`|input to pointed data cell|
|`[`|jump forward to `]` if pointed data is zero|
|`]`|jump backward to `[` if pointed data is non-zero|
|`#`|compiler-specific inline comment prefix|

