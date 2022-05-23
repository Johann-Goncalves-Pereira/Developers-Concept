module Components.Layout exposing
    ( Model
    , footerId
    , headerId
    , headerUsernameId
    , initLayout
    , rootId
    , viewLayout
    )

import Components.Svg as SVG
import Gen.Route as Route exposing (Route)
import Html exposing (Attribute, Html, a, div, h1, header, input, li, main_, nav, small, span, text, ul)
import Html.Attributes exposing (class, classList, href, id, tabindex, type_)
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

        ( Route.AboutMe, Route.AboutMe__Kelpie ) ->
            True

        ( Route.Projects, Route.Projects ) ->
            True

        ( Route.ContactMe, Route.ContactMe ) ->
            True

        _ ->
            False


caseNamePage : Route -> String
caseNamePage route =
    if route == Route.Home_ then
        "_hello"

    else
        "_" ++ String.replace "/" " - " (String.dropLeft 1 <| Route.toHref route)


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


rootId : String
rootId =
    "root"


viewLayout : Model msg -> List (Html msg)
viewLayout model =
    let
        mainClass : Attribute msg
        mainClass =
            class <| "root__main main--" ++ classBuilder (caseNamePage model.route)
    in
    [ div
        [ id rootId
        , classList
            [ ( "root", True )
            , ( "root--" ++ classBuilder (caseNamePage model.route), True )
            ]
        ]
        [ viewHeader model
        , main_ (mainClass :: model.mainAttrs) model.mainContent
        , viewFooter
        ]
    ]


classTail : List String -> Attribute msg
classTail list =
    class <| String.join " " list


headerId : String
headerId =
    "root__header"


headerUsernameId : String
headerUsernameId =
    "header-username"


viewHeader : Model msg -> Html msg
viewHeader model =
    header [ class "root__header", id headerId ]
        [ h1
            [ classTail
                [ "py-4"
                , "px-[calc(1rem+1ch)]"
                , "text-secondary-0"
                , "cursor-default"
                , "select-none"
                , "pointer-events-none"
                ]
            , id headerUsernameId
            ]
            [ text "johann-gonçalves", span [ class "hidden md:inline-block" ] [ text "-pereira" ] ]
        , input [ class "lines__input block md:hidden", type_ "checkbox" ] []
        , div [ class "lines" ] [ SVG.threeLines, SVG.x ]
        , nav [ class "list-nav col-span-2  md:col-span-1" ]
            [ viewHeaderLinks model [ Route.Home_, Route.AboutMe, Route.Projects, Route.ContactMe ]
                |> ul [ class "list" ]
            ]
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
    li [ class "list__item" ]
        [ a
            [ class "list__links "
            , classList
                [ ( "list__links--current-page"
                  , isRoute model.routeReceived model.routeStatic
                  )
                ]
            , href <| Route.toHref model.routeStatic
            , tabindex 1
            ]
            [ text model.routeName ]
        ]


footerId : String
footerId =
    "root__footer"


viewFooter : Html msg
viewFooter =
    div [ class "root__footer", id footerId ]
        [ small
            [ classTail
                [ "py-4"
                , "px-[calc(1rem+1ch)]"
                , "text-secondary-0"
                , "cursor-default"
                , "select-none"
                , "pointer-events-none"
                ]
            ]
            [ text "find me in:" ]
        , nav [ class "nav" ]
            [ a [ class "nav__link p-4", href "#" ] [ SVG.twitter ]
            , a [ class "nav__link p-4", href "#" ] [ SVG.discord ]
            , a [ class "nav__link px-[calc(1rem+1ch)] py-4", href "#" ]
                [ span [ class "select-none hidden md:block" ] [ text "@Johann-Goncalves-Pereira" ], SVG.github ]
            ]
        ]
