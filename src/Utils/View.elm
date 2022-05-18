module Utils.View exposing (customProp, customProps)

import Html exposing (Attribute)
import Html.Attributes exposing (attribute)


customProps : List { prop : String, value : String } -> Attribute msg
customProps listProps =
    List.foldl
        (\{ prop, value } result ->
            String.concat [ result, "--", prop, ":", value, ";" ]
        )
        ""
        listProps
        |> attribute "style"


customProp : ( String, String ) -> Attribute msg
customProp ( p, v ) =
    String.concat [ "--", p, ":", v, ";" ]
        |> attribute "style"
