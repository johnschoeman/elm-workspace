module Main exposing (..)

import Html exposing (h1, text, Html)
import Email


type alias Message =
    { recipient : Email.Address
    , body : String
    }


data : String
data =
    "hello@test.com"


main : Html msg
main =
    let
        content =
            data
                |> Email.validateAddress
                |> Result.map Email.toString
                |> Result.withDefault "invalid"
    in
        h1 [] [ text content ]
