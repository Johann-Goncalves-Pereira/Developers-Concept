module Pages.Home_ exposing (Model, Msg, page)

import Components.Layout exposing (initLayout)
import Components.Svg as SVG
import Gen.Params.Home_ exposing (Params)
import Gen.Route as Route
import Html exposing (Html, a, button, div, h2, h3, p, span, text)
import Html.Attributes exposing (class, href, target)
import Page
import Request
import Shared
import SyntaxHighlight exposing (elm)
import Utils.Highlight exposing (codeFormatter, codeHighlight)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ _ =
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
    { title = "_hello"
    , body =
        Components.Layout.viewLayout
            { initLayout
                | route = Route.Home_
                , mainAttrs = [ class "scroll-custom" ]
                , mainContent = viewPage model
            }
    }


viewPage : Model -> List (Html Msg)
viewPage model =
    [ viewPresentation model, viewGame model ]


viewPresentation : Model -> Html Msg
viewPresentation model =
    div [ class "grid gap-16 m-auto lg:mr-0 z-10" ]
        [ div [ class "pointer-events-none" ]
            [ p [ class "font-450 select-none" ] [ text "Hi all. I am" ]
            , h2 [ class "text-6xl font-400 select-none" ]
                [ text "Johann Gonçalves", span [ class "hidden 2xl:block" ] [ text "Pereira" ] ]
            , h3 [ class "text-4xl leading-snug  text-secondary-2 font-450 select-none" ]
                [ text "|> Front-end developer" ]
            ]
        , a
            [ class "no-underline select-none cursor-pointer"
            , href "https://github.com/Johann-Goncalves-Pereira/Developers-Concept"
            , target "_blank"
            ]
            [ codeFormatter viewCode
                |> codeHighlight elm
            ]
        ]


viewCode : List String
viewCode =
    [ "-- complete the game to continue"
    , "-- you can also see it on my Github page"
    , "repository : Attribute msg"
    , "repository = "
    , "   a [ href \"https://github.com/example/url\" ]"
    , "     [ text \"Game\" ]  "
    ]


viewGame : Model -> Html Msg
viewGame model =
    div [ class "game-container" ]
        [ -- Screws
          div [ class "game-container__screw" ] [ SVG.x ]
        , div [ class "game-container__screw" ] [ SVG.x ]
        , div [ class "game-container__screw" ] [ SVG.x ]
        , div [ class "game-container__screw" ] [ SVG.x ]

        -- Content
        , div [ class "board" ] []
        , div [ class "info" ]
            [ div [ class "info__keyboard" ]
                [ p [ class "text-sm pointer-events-none select-none" ]
                    [ text "// use keyboard" ]
                , p [ class "text-sm pointer-events-none select-none" ]
                    [ text "// arrows to play" ]
                , button [ class "arrows__key" ] [ SVG.arrow ]
                    |> List.repeat 4
                    |> div [ class "arrows" ]
                ]
            , div [ class "score" ]
                [ p [ class "text-sm pointer-events-none select-none font-500" ]
                    [ text "// food left" ]
                , div [ class "pulse" ] []
                    |> List.repeat (5 * 2)
                    |> div [ class "score__grid" ]
                ]
            , div [ class "btn--ghost w-fit px-3 py-1 row-end-last ml-auto font-500" ]
                [ text "skip" ]
            ]
        ]
