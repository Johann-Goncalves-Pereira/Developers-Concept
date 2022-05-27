module Pages.AboutMe.ReadMe exposing (Model, Msg, page)

import Browser.Dom as BrowserDom exposing (Element, Error, Viewport, getViewport)
import Browser.Events as BrowserEvents
import Components.Layout as Layout exposing (footerId, headerId, headerUsernameId, initLayout, rootId)
import Gen.Params.AboutMe.ReadMe exposing (Params)
import Gen.Route as Route exposing (Route)
import Html exposing (Html, div, p, span, text)
import Html.Attributes as Attributes exposing (class, id)
import List exposing (singleton)
import Page
import Pages.AboutMe as AboutMe
import Request
import Shared
import Task
import Utils.Task exposing (run)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ req =
    Page.element
        { init = init req.route
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { -- Models
      aboutMeModel : AboutMe.Model

    -- Size
    , description : Float
    }


init : Route -> ( Model, Cmd Msg )
init route =
    let
        ( aboutMeModel_, aboutMeCmd_ ) =
            AboutMe.init route
    in
    ( { -- Models
        aboutMeModel = aboutMeModel_

      -- Size
      , description = 0
      }
    , Cmd.batch
        [ Cmd.map AboutMeMsg aboutMeCmd_
        , BrowserDom.getElement descriptionId
            |> Task.attempt GetDescription
        ]
    )



-- UPDATE


type Msg
    = -- Other Msg
      AboutMeMsg AboutMe.Msg
      -- Elements
    | GetDescription (Result Error Element)
    | UpdateValuesOnResize


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AboutMeMsg msg_ ->
            let
                ( aboutMeModel_, aboutMeCmd_ ) =
                    AboutMe.update msg_ model.aboutMeModel
            in
            ( { model | aboutMeModel = aboutMeModel_ }
            , Cmd.map AboutMeMsg aboutMeCmd_
            )

        GetDescription callback ->
            case callback of
                Err _ ->
                    ( model, Cmd.none )

                Ok side_ ->
                    ( { model
                        | description = side_.element.height
                      }
                    , Cmd.none
                    )

        UpdateValuesOnResize ->
            ( model
            , List.map (Cmd.map AboutMeMsg)
                [ AboutMe.getElements AboutMe.Root rootId
                , AboutMe.getElements AboutMe.RootHeader headerId
                , AboutMe.getElements AboutMe.RootFooter footerId
                , AboutMe.getElements AboutMe.RootHeaderUsername headerUsernameId
                ]
                ++ [ BrowserDom.getElement descriptionId
                        |> Task.attempt GetDescription
                   ]
                |> Cmd.batch
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    BrowserEvents.onResize <|
        \_ _ -> UpdateValuesOnResize



-- Sub.none
-- VIEW


view : Model -> View Msg
view model =
    let
        aboutMeView =
            AboutMe.view model.aboutMeModel
                |> View.map AboutMeMsg

        aboutMeAttrs =
            AboutMe.viewAttrs model.aboutMeModel
                |> List.map (Attributes.map AboutMeMsg)

        aboutMeSideBar =
            AboutMe.viewPageContent model.aboutMeModel
                |> List.map (Html.map AboutMeMsg)
    in
    { title = aboutMeView.title ++ " - Kelpie"
    , body =
        Layout.viewLayout
            { initLayout
                | route = Route.AboutMe__Kelpie
                , mainAttrs = aboutMeAttrs
                , mainContent =
                    aboutMeSideBar
                        ++ viewPage model
            }
    }


descriptionId : String
descriptionId =
    "description-id"


viewPage : Model -> List (Html Msg)
viewPage model =
    let
        numberOfLines =
            model.description / 20 - 1 |> round
    in
    [ div [ class "description scroll-custom" ]
        [ div [ class "code-count-lines" ] <| linesNumber numberOfLines
        , p [ class "description__text", id descriptionId ] [ text strss ]
        ]
    ]


strss : String
strss =
    String.repeat 15 """
        This tutorial shows you how to add space in HTML.
        Any blank spaces you type in HTML text to show in a browser, 
        beyond a single space between words, are ignored.
        Therefore, you must code your desired blank spaces into your document.
        you must type the entity &nbsp; for each space to add."""


linesNumber : Int -> List (Html Msg)
linesNumber n =
    List.range 0 n
        |> List.map
            (\x ->
                span []
                    [ text <| String.fromInt x ]
            )
