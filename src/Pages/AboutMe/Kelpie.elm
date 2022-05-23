module Pages.AboutMe.Kelpie exposing (page, view)

import Gen.Params.AboutMe.Kelpie exposing (Params)
import Html exposing (div, p, text)
import Html.Attributes exposing (class)
import Page exposing (Page)
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page
page shared req =
    Page.static
        { view = view
        }


view : View msg
view =
    { title = ""
    , body =
        [ div [ class "grid place-content-center" ] [ p [] [ text " kelpie" ] ]
        , div [ class "bg-secondary-3 opacity-50" ] []
        ]
    }
