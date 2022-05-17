module Pages.AboutMe exposing (Model, Msg, page)

import Components.Layout exposing (initLayout)
import Gen.Params.AboutMe exposing (Params)
import Gen.Route as Route
import Page
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }



-- INIT


type alias Model =
    {}


init : Model
init =
    {}



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> Model
update msg model =
    case msg of
        ReplaceMe ->
            model



-- VIEW


view : Model -> View Msg
view model =
    { title = "_about-me"
    , body =
        Components.Layout.viewLayout
            { initLayout
                | route = Route.AboutMe
                , mainAttrs = []
                , mainContent = []
            }
    }
