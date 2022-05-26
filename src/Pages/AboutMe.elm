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
import Utils.View exposing (customProp, customProps)
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
    { root = -1
    , rootHeader = -1
    , rootFooter = -1
    , headerUsername = -1
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
    | TryGetElementsAgain RootPart
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

                bnf =
                    BrowserDom.NotFound
            in
            case ( part, result ) of
                ( Root, Err _ ) ->
                    ( { model
                        | rootElements =
                            { rootElements_
                                | fallBackError = bnf "Error Root"
                            }
                      }
                    , Cmd.none
                    )

                ( RootHeader, Err _ ) ->
                    ( { model
                        | rootElements =
                            { rootElements_
                                | fallBackError = bnf "Error RootHeader"
                            }
                      }
                    , Cmd.none
                    )

                ( RootFooter, Err _ ) ->
                    ( { model
                        | rootElements =
                            { rootElements_
                                | fallBackError = bnf "Error RootFooter"
                            }
                      }
                    , Cmd.none
                    )

                ( RootHeaderUsername, Err _ ) ->
                    ( { model
                        | rootElements =
                            { rootElements_
                                | fallBackError = bnf "Error RootHeaderUsername"
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
                                    bnf "Ok"
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
                                    bnf "Ok"
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
                                    bnf "Ok"
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
                                    bnf "Ok"
                            }
                      }
                    , Cmd.none
                    )

        TryGetElementsAgain element_ ->
            let
                command e_ id_ =
                    ( model, getElements e_ id_ )
            in
            case element_ of
                Root ->
                    command Root rootId

                RootHeader ->
                    command RootHeader headerId

                RootFooter ->
                    command RootFooter footerId

                RootHeaderUsername ->
                    command RootHeaderUsername headerUsernameId

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
    let
        validateElement : String -> Bool
        validateElement name =
            model.rootElements.fallBackError
                == BrowserDom.NotFound ("Error " ++ name)

        tryGetElementAgain e =
            Time.every (6 * 10 ^ 2) (\_ -> TryGetElementsAgain e)
    in
    if validateElement "Root" then
        tryGetElementAgain Root

    else if validateElement "RootHeader" then
        tryGetElementAgain RootHeader

    else if validateElement "RootFooter" then
        tryGetElementAgain RootFooter

    else if validateElement "RootHeaderUsername" then
        tryGetElementAgain RootHeaderUsername

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
            if
                elements.root
                    <= 0
                    && elements.rootHeader
                    <= 0
                    && elements.rootFooter
                    <= 0
                    && elements.headerUsername
                    <= 0
            then
                -1

            else
                elements.root
                    - elements.rootHeader
                    - elements.rootFooter
                    - 1

        getPx v =
            String.fromFloat v ++ "px"

        checkCustomProp name value =
            if value <= 0 then
                class ""

            else
                customProp ( name, getPx value )
    in
    [ checkCustomProp "header-username" <| elements.headerUsername + 1
    , checkCustomProp "main-height" calcMaxHeight
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
