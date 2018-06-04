module Exercise10 exposing (Person, PersonDetails, Role(..), decoder)

import Json.Decode exposing (Decoder, fail)


{- Let's try and do a complicated decoder, this time. No worries, nothing new
   here: applying the techniques you've used in the previous decoders should
   help you through this one.

   A couple of pointers:
    - try working "inside out". Write decoders for the details and role first
    - combine those decoders + the username and map them into the Person constructor
    - finally, wrap it all together to build it into a list of people


   Example input:

        [ { "username": "Phoebe"
          , "role": "regular"
          , "details":
            { "registered": "yesterday"
            , "aliases": [ "Phoebs" ]
            }
          }
        ]
-}


type alias Person =
    { username : String
    , role : Role
    , details : PersonDetails
    }


type alias PersonDetails =
    { registered : String
    , aliases : List String
    }


type Role
    = Newbie
    | Regular
    | OldFart


decoder : Decoder (List Person)
decoder =
    let
        usernameEntryDecoder : Decoder String
        usernameDecoder =
            Json.Decode.field "username" Json.Decode.string

        roleEntryDecoder : Decoder Role
        roleEntryDecoder =
            Json.Decode.field "role" roleDecoder

        detailsEntryDecoder : Decoder PersonDetails
        detailsEntryDecoder =
            Json.Decode.field "details" personDetailsDecoder

        personDecoder : Decoder Person
        personDecoder =
            Json.Decode.map3 Person
                usernameDecoder
                roleEntryDecoder
                detailsEntryDecoder
    in
    Json.Decode.list personDecoder


personDetailsDecoder : Decoder PersonDetails
personDetailsDecoder =
    let
        registeredDecoder : Decoder String
        registeredDecoder =
            Json.Decode.field "registered" Json.Decode.string

        aliasListDecoder : Decoder (List String)
        aliasListDecoder =
            Json.Decode.list Json.Decode.string

        aliasesDecoder : Decoder (List String)
        aliasesDecoder =
            Json.Decode.field "aliases" aliasListDecoder
    in
    Json.Decode.map2 PersonDetails registeredDecoder aliasesDecoder


roleDecoder : Decoder Role
roleDecoder =
    Json.Decode.string |> Json.Decode.andThen roleFromString


roleFromString : String -> Decoder Role
roleFromString roleAsString =
    case roleAsString of
        "newbie" ->
            Json.Decode.succeed Newbie

        "regular" ->
            Json.Decode.succeed Regular

        "oldfart" ->
            Json.Decode.succeed OldFart

        _ ->
            fail ("unknown role: " ++ roleAsString)



{- Once you think you're done, run the tests for this exercise from the root of
   the project:

   - If you have installed `elm-test` globally:
        `elm test tests/Exercise10`

   - If you have installed locally using `npm`:
        `npm run elm-test tests/Exercise10`

   - If you have installed locally using `yarn`:
        `yarn elm-test tests/Exercise10`
-}
