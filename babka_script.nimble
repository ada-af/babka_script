# Package

version       = "0.1.0"
author        = "mcilya"
description   = "Package to ping bunch of network resources and say if internet is working"
license       = "WTFPL"
srcDir        = "src"
bin           = @["babka_script"]


# Dependencies

requires "nim >= 1.6.6"

before build:
    switch("d", "release")
    switch("opt", "size")