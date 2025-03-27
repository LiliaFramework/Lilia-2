## Syntax
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

## TODO
- Character System ( Creating, Loading, Deleting )
- Inventory System ( Weight Based )
- User Interface ( Some sunny day )
- Core Functions ( File Including, Modules System )