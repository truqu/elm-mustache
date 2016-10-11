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
  = Variable' String
  | Section' String String


{-| Render a template using a list of variables
-}
render : List Node -> String -> String
render nodes template =
  renderSections nodes template
    |> renderVariables nodes


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
      head' match.submatches

    getContent node =
      case node of
        Variable key' val ->
          if key == key' then
            Just val
          else
            Nothing

        _ ->
          Nothing
  in
    List.map getContent nodes
      |> Maybe.oneOf
      |> Maybe.withDefault ""


getSection : List Node -> Match -> String
getSection nodes match =
  let
    key =
      head' match.submatches

    val =
      List.tail match.submatches
        |> Maybe.withDefault []
        |> head'

    expand node =
      case node of
        Section key' bool ->
          if key' == key then
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


head' : List (Maybe String) -> String
head' xs =
  List.head xs
    |> Maybe.withDefault Nothing
    |> Maybe.withDefault ""
