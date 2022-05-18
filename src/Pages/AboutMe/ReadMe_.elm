module Pages.AboutMe.ReadMe_ exposing (page)

import Components.Layout as Layout exposing (initLayout)
import Gen.Params.AboutMe.ReadMe_ exposing (Params)
import Gen.Route as Route
import Page exposing (Page)
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page
page _ req =
    Page.static
        { view = view req.params
        }


view : Params -> View msg
view params =
    { title = "Dynamic: " ++ params.readMe
    , body =
        Layout.viewLayout
            { initLayout
                | route = Route.AboutMe
                , mainContent = []
            }
    }
