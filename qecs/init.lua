local PATH = (...):gsub('%.init$', '')

local Qecs = {}

Qecs.entity       = require(PATH..".entity")
Qecs.component    = require(PATH..".component")
Qecs.system       = require(PATH..".system")
Qecs.instance     = require(PATH..".instance")
Qecs.assemblage   = require(PATH..".assemblage")
Qecs.event        = require(PATH..".event")
Qecs.eventManager = require(PATH..".eventManager")

return Qecs
