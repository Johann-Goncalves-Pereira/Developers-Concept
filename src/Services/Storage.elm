port module Services.Storage exposing (..)

import Json.Decode as Json
import Json.Encode as Encode


port save : Json.Value -> Cmd msg


port load : (Json.Value -> msg) -> Sub msg


type alias Storage =
    { counter : Int
    }



-- Converting to JSON


toJson : Storage -> Json.Value
toJson storage =
    Encode.object
        [ ( "counter", Encode.int storage.counter )
        ]



-- Converting from JSON


fromJson : Json.Value -> Storage
fromJson value =
    value
        |> Json.decodeValue decoder
        |> Result.withDefault initial


decoder : Json.Decoder Storage
decoder =
    Json.map Storage
        (Json.field "counter" Json.int)


initial : Storage
initial =
    { counter = 0
    }
