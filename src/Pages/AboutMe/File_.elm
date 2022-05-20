module Pages.AboutMe.File_ exposing (Model, Msg, page)

import Components.Layout as Layout exposing (initLayout)
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
            [ p [] [ text "README.md" ]
            , div [ class "bg-secondary-2 p-5 " ] []
            ]

        "university" ->
            [ p [] [ text "university" ]
            , div [ class "bg-secondary-1 p-5 " ] []
            ]

        "github" ->
            [ p [] [ text "github" ]
            , div [ class "bg-accent-1 p-5 " ] []
            ]

        "gitlab" ->
            [ p [] [ text "gitlab" ]
            , div [ class "bg-accent-3 p-5 " ] []
            ]

        _ ->
            []
