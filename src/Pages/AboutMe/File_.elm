module Pages.AboutMe.File_ exposing (Model, Msg, page)

import Components.Layout as Layout exposing (initLayout)
import Gen.Params.AboutMe.File_ exposing (Params)
import Gen.Route as Route exposing (Route)
import Html exposing (Attribute, Html, div, p, text)
import Html.Attributes as Attributes
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
    { title = "_about-me - " ++ model.params.file
    , body =
        Layout.viewLayout
            { initLayout
                | route = Route.AboutMe__File_ { file = model.params.file }
                , mainAttrs =
                    AboutMe.mainAttrs model.aboutMeModel
                        |> List.map (Attributes.map AboutMeMsg)
                , mainContent =
                    viewAboutMePage model
                        ++ viewPage model
            }
    }


viewAboutMePage : Model -> List (Html Msg)
viewAboutMePage model =
    AboutMe.viewPage model.aboutMeModel
        |> List.map (Html.map AboutMeMsg)


viewPage : Model -> List (Html Msg)
viewPage model =
    [ case model.params.file of
        "README.md" ->
            p [] [ text "README.md" ]

        "university" ->
            p [] [ text "university" ]

        _ ->
            text ""
    ]
