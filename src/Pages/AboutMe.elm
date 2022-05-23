module Pages.AboutMe exposing (Model, Msg, init, page, update, view, viewAttrs, viewSidebar)

import Browser.Dom as BrowserDom exposing (Element, Error)
import Components.Layout as Layout exposing (footerId, headerId, headerUsernameId, initLayout, rootId)
import Components.Svg as SVG
import Gen.Params.AboutMe exposing (Params)
import Gen.Route as Route exposing (Route)
import Html exposing (Attribute, Html, a, button, div, h4, header, li, p, section, span, text, ul)
import Html.Attributes exposing (attribute, class, classList, href, id)
import Html.Attributes.Aria exposing (ariaLabelledby)
import Html.Events exposing (onClick)
import List exposing (singleton)
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
        { init = init req.route
        , update = update
        , view = view
        , subscriptions = subs
        }



-- MODEL


type alias Model =
    { -- Elements Size
      rootElements : RootElements

    -- Explorer toggles
    , showExplorer : Bool
    , showFolder : Folders

    -- Other Pages
    , route : Route
    }


type alias Folders =
    { bio : Bool
    , project : Bool
    }


type alias RootElements =
    { root : Float
    , rootHeader : Float
    , rootFooter : Float
    , headerUsername : Float
    , fallBackError : Error
    }


init : Route -> ( Model, Cmd Msg )
init route_ =
    ( { showExplorer = True
      , showFolder = initFolders
      , rootElements = initElements
      , route = route_
      }
    , Cmd.batch
        [ getElements Root rootId
        , getElements RootHeader headerId
        , getElements RootFooter footerId
        , getElements RootHeaderUsername headerUsernameId
        ]
    )


initFolders : Folders
initFolders =
    { bio = True, project = True }


initElements : RootElements
initElements =
    { root = 0
    , rootHeader = 0
    , rootFooter = 0
    , headerUsername = 0
    , fallBackError = BrowserDom.NotFound "Error"
    }


getElements : RootPart -> String -> Cmd Msg
getElements rootParts elementId =
    BrowserDom.getElement elementId
        |> Task.attempt (GotBaseElementsSize rootParts)



-- TYPES


type RootPart
    = Root
    | RootFooter
    | RootHeader
    | RootHeaderUsername



-- UPDATE


type Msg
    = -- Get Elements Size
      GotBaseElementsSize RootPart (Result Error Element)
    | TryGetElementsAgain
      -- Toggle Explorer
    | ToggleExplorer Bool
    | ToggleBio Bool
    | ToggleProject Bool
      -- Other Pages
    | ChangeUrl Route


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        showFolder_ =
            model.showFolder
    in
    case msg of
        GotBaseElementsSize part result ->
            let
                rootElements_ =
                    model.rootElements
            in
            case ( part, result ) of
                ( _, Err error ) ->
                    ( { model
                        | rootElements =
                            { rootElements_
                                | fallBackError = error
                            }
                      }
                    , Cmd.none
                    )

                ( Root, Ok size_ ) ->
                    ( { model
                        | rootElements =
                            { rootElements_
                                | root =
                                    size_.element.height
                                , fallBackError =
                                    BrowserDom.NotFound "Ok"
                            }
                      }
                    , Cmd.none
                    )

                ( RootHeader, Ok size_ ) ->
                    ( { model
                        | rootElements =
                            { rootElements_
                                | rootHeader =
                                    size_.element.height
                                , fallBackError =
                                    BrowserDom.NotFound "Ok"
                            }
                      }
                    , Cmd.none
                    )

                ( RootFooter, Ok size_ ) ->
                    ( { model
                        | rootElements =
                            { rootElements_
                                | rootFooter =
                                    size_.element.height
                                , fallBackError =
                                    BrowserDom.NotFound "Ok"
                            }
                      }
                    , Cmd.none
                    )

                ( RootHeaderUsername, Ok size_ ) ->
                    ( { model
                        | rootElements =
                            { rootElements_
                                | headerUsername =
                                    size_.element.height
                                , fallBackError =
                                    BrowserDom.NotFound "Ok"
                            }
                      }
                    , Cmd.none
                    )

        TryGetElementsAgain ->
            ( model
            , Cmd.batch
                [ getElements Root rootId
                , getElements RootHeader headerId
                , getElements RootFooter footerId
                , getElements RootHeaderUsername headerUsernameId
                ]
            )

        ToggleExplorer toggler_ ->
            ( { model | showExplorer = not toggler_ }, Cmd.none )

        ToggleBio toggler_ ->
            ( { model | showFolder = { showFolder_ | bio = not toggler_ } }
            , Cmd.none
            )

        ToggleProject toggler_ ->
            ( { model | showFolder = { showFolder_ | project = not toggler_ } }
            , Cmd.none
            )

        ChangeUrl route_ ->
            ( { model | route = route_ }, Cmd.none )



-- SUBSCRIPTIONS


subs : Model -> Sub Msg
subs model =
    if
        model.rootElements.fallBackError
            == BrowserDom.NotFound "Error"
    then
        Time.every (60 * 10) (\_ -> TryGetElementsAgain)

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
            , mainContent =
                singleton <| viewSidebar model
        }


viewAttrs : Model -> List (Attribute Msg)
viewAttrs model =
    let
        elements =
            model.rootElements

        calcMaxHeight =
            elements.root
                - elements.rootHeader
                - elements.rootFooter
    in
    [ customProp
        ( "header-username"
        , String.fromFloat
            (elements.headerUsername + 1)
            ++ "px"
        )
    , attribute "style" <|
        String.concat
            [ "max-height:"
            , String.fromFloat calcMaxHeight
            , "px;"
            ]
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
                    , ( "header__button--active"
                      , not model.showExplorer
                      )
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
                    (\{ folder, msg, showFile, files } ->
                        viewDirectory folder msg showFile <|
                            List.map
                                (\name ->
                                    viewListFiles model name
                                )
                                files
                    )
                    [ {- { folder = "bio"
                           , msg = ToggleBio model.showFolder.bio
                           , showFile = model.showFolder.bio
                           , files = [ "university", "github", "gitlab" ]
                           }
                         ,
                      -}
                      { folder = "projects"
                      , msg = ToggleProject model.showFolder.project
                      , showFile = model.showFolder.project
                      , files = [ Route.AboutMe__Kelpie ]
                      }
                    ]
                    ++ [ viewListFiles model Route.AboutMe__ReadMe ]

          else
            text ""
        ]


viewDirectory : String -> Msg -> Bool -> List (Html Msg) -> Html Msg
viewDirectory folderName msg showFiles files =
    li [ class "explorer__directory" ]
        [ button
            [ classList
                [ ( "explorer__folders", True )
                , ( "explorer__folders--active", not showFiles )
                ]
            , onClick msg
            ]
            [ SVG.lineArrow
            , SVG.directory
            , span [ class "mr-auto" ] [ text folderName ]
            ]
        , if showFiles then
            ul [ class "explorer__nested" ] files

          else
            text ""
        ]


viewListFiles : Model -> Route -> Html Msg
viewListFiles model filename =
    let
        aboutSize =
            String.length (Route.toHref Route.AboutMe) + 1
    in
    li [ class "file" ]
        [ a
            [ classList
                [ ( "file__link", True )
                , ( "file__link--active"
                  , filename == model.route
                  )
                ]
            , href <| Route.toHref filename
            , onClick <| ChangeUrl filename
            ]
            [ SVG.markdown
            , -- |>
              Route.toHref filename
                |> String.dropLeft aboutSize
                |> text
            ]
        ]
