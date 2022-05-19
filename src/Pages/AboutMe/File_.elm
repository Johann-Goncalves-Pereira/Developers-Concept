module Pages.AboutMe.File_ exposing (page)

import Gen.Params.AboutMe.File_ exposing (Params)
import Page exposing (Page)
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page
page shared req =
    Page.static
        { view = view
        }


view : View msg
view =
    View.placeholder "AboutMe.File_"
