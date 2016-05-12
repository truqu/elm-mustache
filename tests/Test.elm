module Main (..) where

import Console exposing (IO)
import ElmTest exposing (..)
import Mustache
import Signal exposing (Signal)
import Task


console : IO ()
console =
  consoleRunner render


port runner : Signal (Task.Task x ())
port runner =
  Console.run console


render : Test
render =
  suite
    "Render"
    [ test
        "Variable"
        <| assertEqual
            (Mustache.render [ Mustache.Variable "name" "John" ] "My name is {{ name }}.")
            "My name is John."
    , test
        "Variable without spaces"
        <| assertEqual
            (Mustache.render [ Mustache.Variable "name" "John" ] "My name is {{name}}.")
            "My name is John."
    , test
        "Section"
        <| assertEqual
            (Mustache.render [ Mustache.Section "show" True ] "Hello{{# show }}, world.{{/ show }}")
            "Hello, world."
    , test
        "Section without spaces"
        <| assertEqual
            (Mustache.render [ Mustache.Section "show" True ] "Hello{{#show}}, world.{{/show}}")
            "Hello, world."
    , test
        "Hide section"
        <| assertEqual
            (Mustache.render [ Mustache.Section "show" False ] "Hello{{# show }}, world.{{/ show }}")
            "Hello"
    ]
