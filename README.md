# Blop-Gui
The blop Gui is a Gui that is Short compact and easy to use. It is not the most popular but it is small tho so stick em up


## Usage script

```lua

-- Load the BlopGui library
local BlopGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/AzxerMan000/Blop-Gui/main/Source.lua"))() 

-- Create the GUI window
local gui = BlopGui.CreateLib("Blop UI Example")

-- Create a new tab
local mainTab = gui:NewTab("Main")

-- Add a button to the tab
mainTab:NewButton("Click Me", "This button does something", function()
    print("Button was clicked!")
end)

-- Add a toggle to the tab
mainTab:NewToggle("Toggle Feature", "Turns something on/off", function(state)
    print("Toggle is now", state and "ON" or "OFF")
end)

```
