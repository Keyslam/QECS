local PATH = (...):gsub('%.init$', '')

local Qecs = {}

Qecs.entity    = require(PATH..".entity")
Qecs.component = require(PATH..".component")
Qecs.system    = require(PATH..".system")
Qecs.instance  = require(PATH..".instance")

return Qecs
