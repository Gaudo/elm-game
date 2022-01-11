module Main exposing (main)

import Array exposing (Array, fromList, toList)
import Browser
import Html exposing (..)
import Html.Events exposing (..)
import List.Extra
import Random


type alias Card =
    ( Value, Suit )


type Suit
    = Hearts
    | Diamonds
    | Clubs
    | Spades


type Value
    = Ace
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight
    | Nine
    | Ten
    | Jack
    | Queen
    | King


cardsSet : Array Card
cardsSet =
    fromList
        [ ( Ace, Hearts )
        , ( Two, Hearts )
        , ( Three, Hearts )
        , ( Four, Hearts )
        , ( Five, Hearts )
        , ( Six, Hearts )
        , ( Seven, Hearts )
        , ( Eight, Hearts )
        , ( Nine, Hearts )
        , ( Ten, Hearts )
        , ( Jack, Hearts )
        , ( Queen, Hearts )
        , ( King, Hearts )
        , ( Ace, Diamonds )
        , ( Two, Diamonds )
        , ( Three, Diamonds )
        , ( Four, Diamonds )
        , ( Five, Diamonds )
        , ( Six, Diamonds )
        , ( Seven, Diamonds )
        , ( Eight, Diamonds )
        , ( Nine, Diamonds )
        , ( Ten, Diamonds )
        , ( Jack, Diamonds )
        , ( Queen, Diamonds )
        , ( King, Diamonds )
        , ( Ace, Clubs )
        , ( Two, Clubs )
        , ( Three, Clubs )
        , ( Four, Clubs )
        , ( Five, Clubs )
        , ( Six, Clubs )
        , ( Seven, Clubs )
        , ( Eight, Clubs )
        , ( Nine, Clubs )
        , ( Ten, Clubs )
        , ( Jack, Clubs )
        , ( Queen, Clubs )
        , ( King, Clubs )
        , ( Ace, Spades )
        , ( Two, Spades )
        , ( Three, Spades )
        , ( Four, Spades )
        , ( Five, Spades )
        , ( Six, Spades )
        , ( Seven, Spades )
        , ( Eight, Spades )
        , ( Nine, Spades )
        , ( Ten, Spades )
        , ( Jack, Spades )
        , ( Queen, Spades )
        , ( King, Spades )
        ]


type alias Model =
    { choosenCards : List Card
    , availableCards : List Card
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { choosenCards = []
      , availableCards = toList cardsSet
      }
    , Cmd.none
    )


type Msg
    = ChangeAllMagically
    | Restart
    | Pick Int


magicChange : Card -> Card
magicChange ( value, suit ) =
    ( value
    , if suit == Hearts then
        Diamonds

      else if suit == Diamonds then
        Hearts

      else if suit == Clubs then
        Spades

      else
        Clubs
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeAllMagically ->
            ( { model
                | choosenCards = List.map magicChange model.choosenCards
              }
            , Cmd.none
            )

        Restart ->
            ( { availableCards = toList cardsSet
              , choosenCards = []
              }
            , Random.generate Pick (Random.int 0 (List.length model.availableCards - 1))
            )

        Pick index ->
            ( { availableCards = List.Extra.removeAt index model.availableCards
              , choosenCards =
                    case List.Extra.getAt index model.availableCards of
                        Maybe.Nothing ->
                            model.choosenCards

                        Just card ->
                            card :: model.choosenCards
              }
            , let
                choosenCardsLength =
                    List.length model.choosenCards
              in
              if choosenCardsLength == 6 then
                Cmd.none

              else
                Random.generate Pick (Random.int 0 (List.length model.availableCards - 1))
            )


cardToView : Card -> String
cardToView ( value, suit ) =
    String.concat
        [ if suit == Hearts then
            "♥"

          else if suit == Diamonds then
            "♦"

          else if suit == Clubs then
            "♣"

          else
            "♠"
        , " "
        , if value == Ace then
            "Ace"

          else if value == Two then
            "2"

          else if value == Three then
            "3"

          else if value == Four then
            "4"

          else if value == Five then
            "5"

          else if value == Six then
            "6"

          else if value == Seven then
            "7"

          else if value == Eight then
            "8"

          else if value == Nine then
            "9"

          else if value == Ten then
            "10"

          else if value == Jack then
            "Jack"

          else if value == Queen then
            "Queen"

          else
            "King"
        ]


view : Model -> Html Msg
view model =
    div []
        (List.concat
            [ List.map (cardToView >> text >> (\a -> li [] [ a ])) model.choosenCards
            , [ button [ onClick Restart ] [ text "Restart" ] ]
            , if List.length model.choosenCards > 0 then
                [ button [ onClick ChangeAllMagically ] [ text "Change" ] ]

              else
                []
            ]
        )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
