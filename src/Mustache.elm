module Mustache exposing (Node(..), render)

{-| Rendering mustache templates

@docs Node, render

-}

import Regex exposing (..)


{-| Represent mustache variables
-}
type Node
    = Variable String String
    | Section String Bool


type Hole
    = Variable_ String
    | Section_ String String


{-| Collapse all whitespace like in HTML rendering
-}
collapseWhitespace : String -> String
collapseWhitespace =
    replace All (regex "\\s+") (\{ match } -> " ")


{-| Render a template using a list of variables
-}
render : List Node -> String -> String
render nodes template =
    renderSections nodes (collapseWhitespace template)
        |> renderVariables nodes
        >> String.trim


renderSections : List Node -> String -> String
renderSections nodes template =
    let
        r =
            regex "{{#\\s?(.+?)\\s?}}(.+?){{/\\s?\\1\\s?}}"
    in
        replace All r (getSection nodes) template


renderVariables : List Node -> String -> String
renderVariables nodes template =
    let
        r =
            regex "{{\\s?(.+?)\\s?}}"
    in
        replace All r (getVariable nodes) template


getVariable : List Node -> Match -> String
getVariable nodes match =
    let
        key =
            head_ match.submatches

        getContent node =
            case node of
                Variable key_ val ->
                    if key == key_ then
                        Just val
                    else
                        Nothing

                _ ->
                    Nothing
    in
        List.map getContent nodes
            |> oneOf
            |> Maybe.withDefault ""


getSection : List Node -> Match -> String
getSection nodes match =
    let
        key =
            head_ match.submatches

        val =
            List.tail match.submatches
                |> Maybe.withDefault []
                |> head_

        expand node =
            case node of
                Section key_ bool ->
                    if key_ == key then
                        bool
                    else
                        False

                _ ->
                    False
    in
        if List.any expand nodes then
            val
        else
            ""


head_ : List (Maybe String) -> String
head_ xs =
    List.head xs
        |> Maybe.withDefault Nothing
        |> Maybe.withDefault ""


oneOf : List (Maybe a) -> Maybe a
oneOf maybes =
    case maybes of
        [] ->
            Nothing

        maybe :: rest ->
            case maybe of
                Nothing ->
                    oneOf rest

                Just _ ->
                    maybe
