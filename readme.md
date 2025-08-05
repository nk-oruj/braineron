# braineron
brainfuck compiler - written in oberon and writing out oberon

## deps
voc - https://github.com/vishapoberon/compiler

## usage

#### compile braineron
```
make build && make delete
```

#### execute braineron
```
./braineron <source> <target>
```

#### compile the program
```
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

## refs
https://esolangs.org/wiki/Brainfuck
