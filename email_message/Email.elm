module Email exposing (Address, validateAddress, toString)


type Address
    = Address String


validateAddress : String -> Result String Address
validateAddress s =
    if String.contains "@" s then
        Result.Ok (Address s)
    else
        Result.Err "invalid email"


toString : Address -> String
toString (Address s) =
    s
