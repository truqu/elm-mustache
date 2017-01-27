module Tests exposing (..)

import Expect
import Fuzz exposing (list, int, tuple, string)
import Mustache
import String
import Test exposing (..)


all : Test
all =
    describe "Mustache test suite"
        [ render ]


render : Test
render =
    describe "Rendering"
        [ test
            "Variable"
          <|
            \_ ->
                Expect.equal
                    (Mustache.render [ Mustache.Variable "name" "John" ] "My name is {{ name }}.")
                    "My name is John."
        , test
            "Variable without spaces"
          <|
            \_ ->
                Expect.equal
                    (Mustache.render [ Mustache.Variable "name" "John" ] "My name is {{name}}.")
                    "My name is John."
        , test
            "Section"
          <|
            \_ ->
                Expect.equal
                    (Mustache.render [ Mustache.Section "show" True ] "Hello{{# show }}, world.{{/ show }}")
                    "Hello, world."
        , test
            "Section without spaces"
          <|
            \_ ->
                Expect.equal
                    (Mustache.render [ Mustache.Section "show" True ] "Hello{{#show}}, world.{{/show}}")
                    "Hello, world."
        , test
            "Hide section"
          <|
            \_ ->
                Expect.equal
                    (Mustache.render [ Mustache.Section "show" False ] "Hello{{# show }}, world.{{/ show }}")
                    "Hello"
        ]
