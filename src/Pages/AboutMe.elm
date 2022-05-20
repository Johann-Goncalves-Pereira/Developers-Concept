module Pages.AboutMe exposing (Model, Msg, init, page, update, view, viewAttrs, viewSidebar)

import Browser.Dom as BrowserDom exposing (Element, Error)
import Components.Layout as Layout exposing (headerUsernameId, initLayout)
import Components.Svg as SVG
import Gen.Params.AboutMe exposing (Params)
import Gen.Route as Route exposing (Route)
import Html exposing (Attribute, Html, a, button, div, h4, header, li, section, text, ul)
import Html.Attributes exposing (class, classList, href, id)
import Html.Attributes.Aria exposing (ariaLabelledby)
import Html.Events exposing (onClick)
import Page
import Platform exposing (Task)
import Process
import Request
import Round
import Shared
import Task
import Time
import Utils.Task exposing (run)
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
    , currentFile : String
    , showExplorer : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { headerUsernameWidth = 304
      , currentFile = ""
      , showExplorer = True
      }
    , Cmd.batch
        [ BrowserDom.getElement headerUsernameId
            |> Task.attempt GetHeaderUsernameWidth
        ]
    )



-- UPDATE


type Msg
    = GetHeaderUsernameWidth (Result Error Element)
    | TryGetHeaderAgain
    | ChangeCurrentFile String
    | ToggleExplorer Bool


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

        ChangeCurrentFile file_ ->
            ( { model | currentFile = file_ }, Cmd.none )

        ToggleExplorer showExplorer_ ->
            ( { model | showExplorer = not showExplorer_ }, Cmd.none )



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
    , body = viewPage model
    }


viewPage : Model -> List (Html Msg)
viewPage model =
    Layout.viewLayout
        { initLayout
            | route = Route.AboutMe
            , mainAttrs = viewAttrs model
            , mainContent = [ viewSidebar model ]
        }


viewAttrs : Model -> List (Attribute Msg)
viewAttrs model =
    [ customProp
        ( "header-username"
        , String.fromFloat
            (model.headerUsernameWidth + 1)
            ++ "px"
        )
    ]


viewSidebar : Model -> Html Msg
viewSidebar model =
    div [ class "sidebar" ]
        [ viewSidebarButtons
        , viewSidebarExplorer model
        ]


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


viewSidebarExplorer : Model -> Html Msg
viewSidebarExplorer model =
    section [ class "sidebar__explorer", ariaLabelledby "header-explorer" ]
        [ header [ class "header" ]
            [ button
                [ classList
                    [ ( "header__button", True )
                    , ( "header__button--active", not model.showExplorer )
                    ]
                , ToggleExplorer model.showExplorer
                    |> onClick
                ]
                [ SVG.arrow
                , h4 [ id "header-explorer" ] [ text "personal-info" ]
                ]
            ]
        , if model.showExplorer then
            ul [ class "explorer" ] <|
                List.map
                    (\{ folder, files } ->
                        viewDirectory folder <|
                            List.map
                                (\name ->
                                    viewListFiles model name
                                )
                                files
                    )
                    [ { folder = "bio"
                      , files = [ "university", "github", "gitlab" ]
                      }
                    , { folder = "projects"
                      , files = [ "kelpie", "materialize" ]
                      }
                    ]
                    ++ [ viewListFiles model "README.md"
                       ]

          else
            text ""
        ]


viewDirectory : String -> List (Html Msg) -> Html Msg
viewDirectory folderName files =
    li [ class "explorer__directory" ]
        [ SVG.lineArrow
        , SVG.directory
        , text folderName
        , ul [ class "explorer__nested" ] files
        ]


viewListFiles : Model -> String -> Html Msg
viewListFiles model filename =
    li [ class "file" ]
        [ a
            [ classList
                [ ( "file__link", True )
                , ( "file__link--active"
                  , filename == model.currentFile
                  )
                ]
            , Route.AboutMe__File_ { file = filename }
                |> Route.toHref
                |> href
            , ChangeCurrentFile filename
                |> onClick
            ]
            [ SVG.markdown, text filename ]
        ]
