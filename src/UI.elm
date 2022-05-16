module UI exposing (Model, initLayout, viewLayout)

import Gen.Route as Route exposing (Route)
import Html exposing (Attribute, Html, a, div, header, main_, nav, text)
import Html.Attributes exposing (class, classList, href, id, tabindex)
import Regex



-- Model


type alias Model msg =
    { route : Route
    , mainContent : List (Html msg)
    , mainAttrs : List (Attribute msg)
    }


type alias Link =
    { routeStatic : Route
    , routeReceived : Route
    , routeName : String
    }


initLayout : Model msg
initLayout =
    { route = Route.Home_
    , mainContent = []
    , mainAttrs = []
    }


defaultLink : Link
defaultLink =
    { routeStatic = Route.Home_
    , routeReceived = Route.Home_
    , routeName = ""
    }



-- Structure


isRoute : Route -> Route -> Bool
isRoute route compare =
    case ( route, compare ) of
        ( Route.Home_, Route.Home_ ) ->
            True

        _ ->
            False


caseNamePage : Route -> String
caseNamePage route =
    case route of
        Route.Home_ ->
            "Home"

        Route.About ->
            "About"

        Route.NotFound ->
            "Not Found"


userReplace : String -> (Regex.Match -> String) -> String -> String
userReplace userRegex replacer string =
    case Regex.fromString userRegex of
        Nothing ->
            string

        Just regex ->
            Regex.replace regex replacer string


classBuilder : String -> String
classBuilder string =
    userReplace "[ ]" (\_ -> "-") string
        |> String.toLower



-- View


viewLayout : Model msg -> List (Html msg)
viewLayout model =
    let
        mainClass : Attribute msg
        mainClass =
            class <| "root__main main--" ++ classBuilder (caseNamePage model.route)
    in
    [ div
        [ id "root"
        , classList
            [ ( "scroll", True )
            , ( "root", True )
            , ( "root--" ++ classBuilder (caseNamePage model.route), True )
            ]
        ]
        [ viewHeader model
        , main_ (mainClass :: model.mainAttrs) model.mainContent
        ]
    ]


viewHeader : Model msg -> Html msg
viewHeader model =
    header [ class "root__header" ]
        [ viewHeaderLinks model [ Route.Home_, Route.About ]
            |> nav
                [ class "root__header__nav"
                ]
        ]


viewHeaderLinks : Model msg -> List Route -> List (Html msg)
viewHeaderLinks model links =
    List.map
        (\staticRoute ->
            viewLink
                { defaultLink
                    | routeName = caseNamePage staticRoute
                    , routeStatic = staticRoute
                    , routeReceived = model.route
                }
        )
        links


viewLink : Link -> Html msg
viewLink model =
    a
        [ class "root__header__links"
        , classList
            [ ( "root__header__links--current-page"
              , isRoute model.routeReceived model.routeStatic
              )
            ]
        , href <| Route.toHref model.routeStatic
        , tabindex 1
        ]
        [ text model.routeName ]
