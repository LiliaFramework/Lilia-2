# This is the Official Repository for Lilia 2.0

This is heavily WIP. Do not try to use.

# Code Syntax

You **can** put spaces between brackets, **if you'd like to** (both are fine)
```lua
lia.exampleFunction.Test( "test" )
lia.exampleFunction.Test("test")
```

**Do not** use brackets for if statements. ( Except when you need them, I can't explain it )
```lua
local test = 2
if test == 2 then
    -- code
end
```

Please put spacing between operators
```lua
local str1 = "Hello "
local str2 = "World"

print(str1 .. str2)
```

### For functions
```lua
Player:IsClass()
NOT
Player:isClass()
```

### For variables
```lua
local isDead = false
NOT
local IsDead = false
```

### For operators
use `not, != (not equal to), and, or`

```lua
if not client:IsAlive() then

end
```
```lua
if ( client:Health() < 50 and client:Health() > 45 and client:Health() != 49 ) or not client:Alive() then

end
```

### Spacing
Space out when you start to use different variables or smth, idk how to explain it, just make it pretty and readable

```lua
local test = 2 + 2
print(test)
```
```lua
local deathScreen = vgui.Create("liaDeathScreen")
deathScreen:SetDuration(5)

client:Notify("You have died, lol")
```

### Networking
**Use the bloody `net.` library**
```lua
lia.character.Create
```

### Optimization
Try to optimize where you can.

Some global variables:
```lua
color_white =       Color( 255, 255, 255, 255 )
color_black =       Color( 0, 0, 0, 255 )
color_transparent = Color( 255, 255, 255, 0 )

vector_origin =     Vector( 0, 0, 0 )
vector_up =         Vector( 0, 0, 1 )
angle_zero =        Angle( 0, 0, 0 )
```

* Creating a [Color](https://wiki.facepunch.com/gmod/Global.Color) is expensive in rendering hooks or frequent operations. It is better to store the color in a variable.
* Creating a [Vector](https://wiki.facepunch.com/gmod/Global.Vector) is expensive in rendering hooks or frequent operations. It is better to store the color in a variable.
* Creating an [Angle](https://wiki.facepunch.com/gmod/Global.Angle) is expensive in rendering hooks or frequent operations. It is better to store the color in a variable.


[A few others](https://wiki.facepunch.com/gmod/Global_Variables)

## TODO
- Character System ( Creating, Loading, Deleting )
- Inventory System ( Weight Based )
- User Interface ( Some sunny day )
- Core Functions ( File Including, Modules System )
