module Pages.AboutMe.Kelpie exposing (Model, Msg, page)

import Components.Layout as Layout exposing (initLayout)
import Gen.Params.AboutMe.Kelpie exposing (Params)
import Gen.Route as Route exposing (Route)
import Html exposing (Html)
import Html.Attributes as Attributes
import List exposing (singleton)
import Page
import Pages.AboutMe as AboutMe
import Request
import Shared
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
    }


init : Route -> ( Model, Cmd Msg )
init route =
    let
        ( aboutMeModel_, aboutMeCmd_ ) =
            AboutMe.init route
    in
    ( { -- Init
        aboutMeModel = aboutMeModel_
      }
    , Cmd.map AboutMeMsg aboutMeCmd_
    )



-- UPDATE


type Msg
    = AboutMeMsg AboutMe.Msg


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

        aboutMeSideBar =
            AboutMe.viewSidebar model.aboutMeModel
                |> Html.map AboutMeMsg
    in
    { title = aboutMeView.title ++ " - Kelpie"
    , body =
        Layout.viewLayout
            { initLayout
                | route = Route.AboutMe__Kelpie
                , mainAttrs = aboutMeAttrs
                , mainContent = singleton aboutMeSideBar
            }
    }
