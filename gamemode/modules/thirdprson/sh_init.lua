local MODULE = MODULE

MODULE.name = "Third Person"
MODULE.author = "bloodycop"
MODULE.description = "Allows you to play in third person."

lia.language.Add("eng", {
    ["thirdperson"] = "Third Person",
    ["thirdperson_toggle"] = "Toggle Third Person",

    ["thirdperson_offset_x"] = "Third Person X Offset",
    ["thirdperson_offset_y"] = "Third Person Y Offset",
    ["thirdperson_offset_z"] = "Third Person Z Offset",
})

lia.option.Register("thirdperson", {
    name = "Third Person",
    type = lia.type.bool,
    default = false,
    category = MODULE.name,
    description = "Enable third person view.",
})

lia.option.Register("thirdperson_offset_x", {
    name = "Third Person",
    type = lia.type.number,
    default = 5,
    category = MODULE.name,
    description = "Enable third person view.",
})

lia.option.Register("thirdperson_offset_y", {
    name = "Third Person",
    type = lia.type.number,
    default = 5,
    category = MODULE.name,
    description = "Enable third person view.",
})

lia.option.Register("thirdperson_offset_z", {
    name = "Third Person",
    type = lia.type.number,
    default = 5,
    category = MODULE.name,
    description = "Enable third person view.",
})

lia.Include("cl_init.lua")