# Elm-Mustache

An Elm library for mustache templates


## Usage

```elm
import Mustache


template : String
template =
  "Hi, my name is {{ name }}.{{# show }} Show me!{{/ show }}"

evaluatedTemplate : String
evaluatedTemplate =
  Mustache.render
    [ Mustache.Variable "name" "John"
    , Mustache.Section "show" True
    ]
    template

-- evaluatedTemplate == "Hi, my name is John. Show me!"
```
