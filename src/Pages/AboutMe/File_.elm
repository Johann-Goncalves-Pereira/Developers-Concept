module Pages.AboutMe.File_ exposing (Model, Msg, page)

import Components.Layout as Layout exposing (footerId, headerId, initLayout)
import Components.Svg exposing (github)
import Gen.Params.AboutMe.File_ exposing (Params)
import Gen.Route as Route exposing (Route)
import Html exposing (Attribute, Html, div, p, text)
import Html.Attributes as Attributes exposing (class)
import Page
import Pages.AboutMe as AboutMe
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ req =
    Page.element
        { init = init req.params
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { params : Params
    , aboutMeModel : AboutMe.Model
    }


init : Params -> ( Model, Cmd Msg )
init params =
    let
        ( aboutMeModel_, aboutMeCmd_ ) =
            AboutMe.init
    in
    ( { params = params
      , aboutMeModel = aboutMeModel_
      }
    , Cmd.map AboutMeMsg aboutMeCmd_
    )



-- UPDATE


type Msg
    = AboutMeMsg AboutMe.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AboutMeMsg aboutMeMsg_ ->
            let
                ( aboutMeModel_, aboutMeCmd_ ) =
                    AboutMe.update aboutMeMsg_ model.aboutMeModel
            in
            ( { model | aboutMeModel = aboutMeModel_ }, Cmd.map AboutMeMsg aboutMeCmd_ )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



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

        aboutMeContent =
            AboutMe.viewSidebar model.aboutMeModel
                |> Html.map AboutMeMsg
    in
    { title =
        viewTitle
            ( aboutMeView.title, model.params.file )
    , body =
        Layout.viewLayout
            { initLayout
                | route = Route.AboutMe
                , mainAttrs = aboutMeAttrs
                , mainContent = aboutMeContent :: viewPage model
            }
    }


viewTitle : ( String, String ) -> String
viewTitle ( base, file ) =
    String.join " - " [ base, file ]


viewPage : Model -> List (Html Msg)
viewPage model =
    case model.params.file of
        "README.md" ->
            [ placeholderOne
            , div [ class "bg-secondary-2 p-5 " ] []
            ]

        "university" ->
            [ placeholderOne
            , div [ class "bg-secondary-1 p-5 " ] []
            ]

        "github" ->
            [ placeholderOne
            , div [ class "bg-accent-1 p-5 " ] []
            ]

        "gitlab" ->
            [ placeholderOne
            , div [ class "bg-accent-3 p-5 " ] []
            ]

        "kelpie" ->
            [ placeholderOne
            , div [] []
            ]

        "materialize" ->
            [ placeholderOne
            , div [] []
            ]

        _ ->
            []


placeholderOne : Html Msg
placeholderOne =
    div [ class "file--description scroll-custom" ]
        [ p [] [ text strss ] ]


strss : String
strss =
    String.repeat 10 """
        This tutorial shows you how to add space in HTML.
        Any blank spaces you type in HTML text to show in a browser, 
        beyond a single space between words, are ignored.
        Therefore, you must code your desired blank spaces into your document.
        You can add space in HTML to any lines of text. You can use the &nbsp; 
        HTML entity to create blank spaces in both paragraph text 
        and text in tables, for example.
        Since there is no blank space keyboard character in HTML, 
        you must type the entity &nbsp; for each space to add."""
