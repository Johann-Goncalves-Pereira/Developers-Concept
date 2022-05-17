module Pages.Projects exposing (Model, Msg, page)

import Gen.Params.Projects exposing (Params)
import Page
import Request
import Shared
import View exposing (View)


import Gen.Route as Route
import Layout exposing (initLayout)
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
   { title = "_projects"
    , body =
        Layout.viewLayout
            { initLayout
                | route = Route.Projects
                , mainAttrs = []
                , mainContent = []
            }
    }
