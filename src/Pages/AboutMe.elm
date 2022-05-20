module Pages.AboutMe exposing (Model, Msg, init, mainAttrs, page, update, viewPage)

import Browser.Dom as BrowserDom exposing (Element, Error)
import Components.Layout as Layout exposing (headerUsernameId, initLayout)
import Components.Svg as SVG
import Gen.Params.AboutMe exposing (Params)
import Gen.Route as Route exposing (Route)
import Html exposing (Attribute, Html, a, button, div, h4, header, li, section, text, ul)
import Html.Attributes exposing (class, href, id)
import Html.Attributes.Aria exposing (ariaLabelledby)
import Page
import Platform exposing (Task)
import Process
import Request
import Round
import Shared
import Task
import Time
import Utils.View exposing (customProp)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ req =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subs
        }



-- INIT


type alias Model =
    { headerUsernameWidth : Float
    }


init : ( Model, Cmd Msg )
init =
    ( { headerUsernameWidth = 304
      }
    , BrowserDom.getElement headerUsernameId
        |> Task.attempt GetHeaderUsernameWidth
    )



-- UPDATE


type Msg
    = GetHeaderUsernameWidth (Result Error Element)
    | TryGetHeaderAgain


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetHeaderUsernameWidth result ->
            case result of
                Err _ ->
                    ( model, Cmd.none )

                Ok size ->
                    ( { model | headerUsernameWidth = size.element.width }, Cmd.none )

        TryGetHeaderAgain ->
            ( model
            , BrowserDom.getElement headerUsernameId
                |> Task.attempt GetHeaderUsernameWidth
            )



-- SUBSCRIPTIONS


subs : Model -> Sub Msg
subs model =
    if model.headerUsernameWidth < 200 then
        Time.every (60 + 10) (\_ -> TryGetHeaderAgain)

    else
        Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "_about-me"
    , body =
        Layout.viewLayout
            { initLayout
                | route = Route.AboutMe
                , mainAttrs =
                    [ customProp
                        ( "header-username"
                        , String.fromFloat
                            (model.headerUsernameWidth + 1)
                            ++ "px"
                        )
                    ]
                , mainContent = viewPage model
            }
    }


viewPage : Model -> List (Html Msg)
viewPage model =
    [ viewSidebar ]


viewSidebar : Html Msg
viewSidebar =
    div [ class "sidebar" ]
        [ viewSidebarButtons, viewSidebarExplorer ]


viewSidebarButtons : Html Msg
viewSidebarButtons =
    ul [ class "sidebar__buttons" ]
        [ li []
            [ button [ class "grid place-items-center p-4" ]
                [ SVG.bash ]
            ]
        , li []
            [ button [ class "grid place-items-center p-4" ]
                [ SVG.strangeBall ]
            ]
        , li []
            [ button [ class "grid place-items-center p-4" ]
                [ SVG.gameBoy ]
            ]
        ]


viewSidebarExplorer : Html Msg
viewSidebarExplorer =
    section [ class "sidebar__explorer", ariaLabelledby "header-explorer" ]
        [ header [ class "header" ]
            [ button [ class "header__button" ]
                [ SVG.arrow
                , h4 [ id "header-explorer" ] [ text "personal-info" ]
                ]
            ]
        , ul [ class "explorer" ]
            [ viewDirectory <| [ viewListFiles "university" ]
            , viewListFiles "README.md"
            ]
        ]


viewDirectory : List (Html Msg) -> Html Msg
viewDirectory files =
    li [ class "explorer__directory" ]
        [ SVG.lineArrow
        , SVG.directory
        , text "bio"
        , ul [ class "explorer__nested" ] files
        ]


viewListFiles : String -> Html Msg
viewListFiles filename =
    li [ class "file" ]
        [ a
            [ class "file__link"
            , Route.AboutMe__File_ { file = filename }
                |> Route.toHref
                |> href
            ]
            [ SVG.markdown, text filename ]
        ]


mainAttrs : Model -> List (Attribute Msg)
mainAttrs model =
    [ customProp
        ( "header-username"
        , String.fromFloat
            (model.headerUsernameWidth + 1)
            ++ "px"
        )
    ]
