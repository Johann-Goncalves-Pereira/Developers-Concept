module Utils.Highlight exposing (..)

import Html exposing (Html, code, div, p, text)
import Parser exposing (DeadEnd)
import SyntaxHighlight exposing (HCode, elm, monokai, oneDark, toBlockHtml, toInlineHtml, useTheme)


codeHighlight : (String -> Result (List DeadEnd) HCode) -> String -> Html msg
codeHighlight lang str =
    lang
        str
        |> Result.map toInlineHtml
        |> Result.withDefault
            (code [] [ text "isEmpty : String -> Bool" ])