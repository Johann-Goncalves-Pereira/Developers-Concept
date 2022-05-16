module Layout exposing (Model, initLayout, viewLayout)

import Gen.Route as Route exposing (Route)
import Html exposing (Attribute, Html, a, div, h1, header, main_, nav, small, text)
import Html.Attributes exposing (class, classList, href, id, tabindex)
import Regex



-- Model


type alias Model msg =
    { route : Route
    , link : Link
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
    , link = initLink
    , mainContent = []
    , mainAttrs = []
    }


initLink : Link
initLink =
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

        ( Route.AboutMe, Route.AboutMe ) ->
            True

        ( Route.Projects, Route.Projects ) ->
            True

        ( Route.ContactMe, Route.ContactMe ) ->
            True

        _ ->
            False


caseNamePage : Route -> String
caseNamePage route =
    case route of
        Route.Home_ ->
            "_home"

        Route.AboutMe ->
            "_about-me"

        Route.Projects ->
            "_projects"

        Route.ContactMe ->
            "_contact-me"

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
    userReplace "[_]" (\_ -> "") string
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
        , viewFooter
        ]
    ]


viewHeader : Model msg -> Html msg
viewHeader model =
    header [ class "root__header" ]
        [ h1 [ class "root__header__title" ] [ text "johann-gonçalves-pereira" ]
        , viewHeaderLinks model [ Route.Home_, Route.AboutMe, Route.Projects, Route.ContactMe ]
            |> nav [ class "root__header__nav" ]
        ]


viewHeaderLinks : Model msg -> List Route -> List (Html msg)
viewHeaderLinks model routes =
    List.map
        (\staticRoute ->
            viewLink
                { initLink
                    | routeName = caseNamePage staticRoute
                    , routeStatic = staticRoute
                    , routeReceived = model.route
                }
        )
        routes


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


viewFooter : Html msg
viewFooter =
    div [ class "root__footer" ]
        [ small [ class "root__footer__text" ] [ text "find me in:" ] ]
