module Utils.Task exposing (..)

import Task exposing (perform, succeed)


run : msg -> Cmd msg
run message =
    perform (always message) (succeed ())
