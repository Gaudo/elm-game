module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (..)


type alias Model =
    Int


init : () -> ( Model, Cmd msg )
init _ =
    ( 3, Cmd.none )


update : any -> Model -> ( Model, Cmd any )
update _ _ =
    ( 6, Cmd.none )


view : Model -> Html msg
view _ =
    div [] [ text "Hello World" ]


subscriptions : Model -> Sub any
subscriptions _ =
    Sub.none


main : Program () Model any
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
