module Pages.Home_ exposing (Model, Msg, page)

import Components.Layout exposing (initLayout)
import Components.Svg as SVG
import Gen.Params.Home_ exposing (Params)
import Gen.Route as Route
import Html exposing (Html, a, button, div, h1, h2, h3, h5, p, section, text)
import Html.Attributes exposing (class, href, id, rel, tabindex, target)
import Html.Attributes.Aria exposing (ariaLabel, ariaLabelledby)
import Page
import Request
import Shared
import Svg exposing (desc)
import SyntaxHighlight exposing (elm, javascript)
import Utils.Highlight exposing (codeHighlight)
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
    { title = "_hello"
    , body =
        Components.Layout.viewLayout
            { initLayout
                | route = Route.Home_
                , mainContent = viewPage model
            }
    }


viewPage : Model -> List (Html Msg)
viewPage model =
    [ viewPresentation model, viewGame model ]


viewPresentation : Model -> Html Msg
viewPresentation model =
    div [ class "grid gap-16 m-auto lg:mr-0 z-10" ]
        [ div []
            [ p [ class "font-medium-less" ] [ text "Hi all. I am" ]
            , h2 [ class "text-6xl font-normal" ] [ text "Johann Gonçalves" ]
            , h3 [ class "text-4xl leading-snug  text-secondary-2 font-medium-less" ]
                [ text "|> Front-end developer" ]
            ]
        , codeHighlight elm viewCode
        ]


viewCode : String
viewCode =
    String.join "\n"
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
                [ p [ class "text-sm pointer-events-none select-none font-normal" ]
                    [ text "// food left" ]
                , div [ class "pulse" ] []
                    |> List.repeat (5 * 2)
                    |> div [ class "score__grid" ]
                ]
            , div [ class "btn--ghost w-fit px-3 py-1 row-start-[-1] ml-auto font" ]
                [ text "skip" ]
            ]
        ]
