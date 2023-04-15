
a = readfile('kxguilib/as.lua')
local Library = loadstring(a)()

local Window = Library:CreateWindow("Main")

local safe = Window:AddFolder"Safe"
local plys = Window:AddFolder"Players"
local liv = Window:AddFolder"Living"

local rof = Window:AddFolder"Rofls"
local rems =Window:AddFolder"Remotes"
local dan = Window:AddFolder"Danger"
local serv = Window:AddFolder"Server"
local skillrofls = Window:AddFolder"Skill rofls"
local potrofls = Window:AddFolder"Potion things (only with 0)"

local tweenservice = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local plrs = game.Players
local lp = plrs.LocalPlayer
local twtp = false
local ptarget = lp
local ltarget
local slot = "Slot_1"
local heart = {}
local srs = {}
local selskill

local candyspam = false
local Dashspam = false
local Attackspam = false
local Attackspamid = 1
local Dropsteal = false
local AutoMed = false

local AbilityRoflsBase = require(game:GetService("ReplicatedStorage").Modules["Database_Modules"]["Skill_Data"])

function tpt(targ)
	if twtp == false then
		lp.Character.HumanoidRootPart.CFrame = targ.CFrame
	else
		a = tweenservice:Create(lp.Character.HumanoidRootPart, TweenInfo.new(0.5 +(lp.Character.HumanoidRootPart.CFrame.Position - targ.CFrame.Position).Magnitude / 1000) , { CFrame = targ.CFrame + Vector3.new(0,5,0) })
		a:Play()
		return a
	end
end

-- function livlistupd()
-- 	livlist:Clear()
-- 	for i,v in pairs(game.Workspace.NPCs.Alive:GetChildren()) do
-- 		livlist:AddValue(v)
-- 	end
-- end
function serversupd()
	servers:Clear()
	for i,v in pairs(game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data) do
		if v.playing and v.maxPlayers and v.ping and v.id then
		    servers:AddValue(v.id,v.playing .. "/".. v.maxPlayers .. " " .. v.ping)-- .." ".. v.id)
	    end
	end
end
function pllistupd()
	pllist:Clear()
	for i,v in pairs(game.Players:GetPlayers()) do
		pllist:AddValue(v)
	end
end
function vallistupd(ply)
    if vallist then
    	vallist:Clear()
    	for i,v in pairs(game:GetService("ReplicatedStorage")["Player_Datas"][ply.Name][slot]:GetChildren()) do
    		vallist:AddValue(v)
    	end
    end
end
function abilmainlistupd()
    if abilmain then
    	abilmain:Clear()
    	for i,v in pairs(AbilityRoflsBase.Skills) do
    		abilmain:AddValue(v, i)
    	end
    end
end
function abillistupd(cat)
    if abillist then
    	abillist:Clear()
    	for i,v in pairs(cat) do
    		abillist:AddValue(i)
    	end
    end
end
function prvorf(ply, val)
    if tostring(type(val)) ~= 'string' and val.GetChildren then
        local gcp = val:GetChildren()
        if gcp ~= nil and #gcp > 0 then
            print(val.Name)
            for i,v in pairs(gcp) do
                prvorf(ply, v)
            end
            return
        end
    end
    print(val.Name, val.Value)
end



--idk 
local function medone()
    game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer("Meditating", true)
    task.wait(0.5)
    for i=1,25 do
        game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer("Apply_Meditation", 1, true)
        task.wait(0.1)
    end
end

-- WHILE FOLDER
local function candyspamfunc()
    while candyspam == true do
        game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer("Soul_Candy",nil,true)
        task.wait(0.1)
    end
end

local function Dashspamfunc()
    while Dashspam == true do
        game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer("Dash")
        task.wait(0.2)
    end
end

local function Attackspamfunc()
    while Attackspam == true do
        game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer("Swing", Attackspamid, "Sword")
        Attackspamid = Attackspamid + 1
        if Attackspamid > 4 then
            Attackspamid = 1
        end
        task.wait(0.1)
    end
end
local function Dropstealfunc()
    while Dropsteal == true do
        for i,v in pairs(workspace.World.Drops:GetChildren()) do
            game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer("Pickup_Item", v)
            task.wait(0.1)
        end
        task.wait(0.1)
    end 
end
local function AutoMeditate()
    while AutoMed== true do
        medone()
        task.wait(1)
    end 
end













--

-- function toglanti(a)
-- 	game:GetService("Players").LocalPlayer.PlayerScripts.Effects.Disabled = a
-- 	game:GetService("Players").LocalPlayer.PlayerScripts["Anti Exploit"].Disabled = a
-- end
safe:AddToggle({text = "Safe tp", flag = "toggle", state = false, callback = function(a) twtp = a end})
-- safe:AddToggle({text = "Disable AntiCheat", flag = "toggle", state = false, callback = function(a) toglanti( a) end})

--

pllist = plys:AddList({text = "Player", flag = "list", value = ptarget ,values = '', callback = function(a) 
	ptarget = a 
	pllistupd() 
end})

slotlist = plys:AddList({text = "Slot", flag = "list", value = slot,values = {"Slot_1","Slot_2","Slot_3"}, callback = function(a) 
	slot = a
end})
vallist = plys:AddList({text = "Stat", flag = "list", value = '',values = '', callback = function(a) 
	prvorf(ptarget, a)
	vallistupd(ptarget)
end})
plys:AddButton({text = "TP to target", flag = "button", callback = function() tpt(ptarget.Character.HumanoidRootPart) end})
--plys:AddButton({text = "Get selected stat", flag = "button", callback = function() prvorf(ptarget, sval) end})

--


--

function fly()
	local MOUSE = lp:GetMouse()
	local CONTROL = {F = 0,B = 0,L = 0,R = 0}
	local speed = 100
	local BV = nil
	local function flystart()
		spawn(function ()
			while wait() do
				local crb = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * speed
				if BV ~= nil then
					BV.velocity = crb
				else
					break
				end
			end
		end)
	end

	MOUSE.KeyDown:connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 1
		elseif KEY:lower() == 's' then
			CONTROL.B = -1
		elseif KEY:lower() == 'a' then
			CONTROL.L = -1 
		elseif KEY:lower() == 'd' then 
			CONTROL.R = 1
		elseif KEY:lower() == 'e' then 
			speed = speed * 3
		elseif KEY:lower() == 'p' then 
			if BV ~= nil then
				BV:Destroy()
				BV = nil
				print('destr')
			else
				BV = Instance.new("BodyVelocity", lp.Character.Torso)
				flystart()
				print('start')
			end
		end
	end)
	 
	MOUSE.KeyUp:connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then 
			speed = speed / 3
		end
	end)
end

dan:AddButton({text = "FLY P", flag = "button", callback = function() fly() end})

local function webImport(file)
    return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/%s.lua"):format(file)), file .. '.lua')()
end
dan:AddButton({text = "Hydroxide", flag = "button", callback = function() 

    webImport("init")
    webImport("ui/main")
end})
dan:AddToggle({text = "Noclip", flag = "toggle", state = false, callback = function(a)
	b = not a
	for i,v in pairs(lp.Character:GetDescendants()) do
	    if v:IsA('Part') then
	        v.CanCollide = b
	    end
	end
-- 	lp.Character.Head.CanCollide = b
-- 	lp.Character.Torso.CanCollide = b
-- 	for i,v in pairs(lp.Character.RDCs:GetChildren()) do
-- 		v.CanCollide = b
-- 	end
end})

--

rems:AddButton({text = "Senkaimon", flag = "button", callback = function() 
    game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer("Senkaimon")
end})


rems:AddToggle({text = "Candy spam", flag = "toggle", state = false, callback = function(a) 
    candyspam = a
    candyspamfunc()
end})

rems:AddToggle({text = "Dash spam", flag = "toggle", state = false, callback = function(a) 
    Dashspam = a
    Dashspamfunc()
end})

rems:AddToggle({text = "Attack spam", flag = "toggle", state = false, callback = function(a) 
    Attackspam = a
    Attackspamfunc()
end})

rems:AddToggle({text = "Steal drop from map", flag = "toggle", state = false, callback = function(a) 
    Dropsteal = a
    Dropstealfunc()
end})
rems:AddToggle({text = "Automeditate", flag = "toggle", state = false, callback = function(a) 
    AutoMed = a
    AutoMeditate()
end})

rems:AddBox({text = "Take quest (name of npc) ", flag = "button", value = selserv, callback = function(a)
    game:GetService("ReplicatedStorage").Remotes.Quest_Remote:FireServer(a, "Add")
end})

-- 

potrofls:AddButton({text = "Health Potion", flag = "button", callback = function() 
    game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer("Health_Potion", nil, "Drink")
end})
potrofls:AddButton({text = "Ignition Potion", flag = "button", callback = function() 
    game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer("Ignition_Potion", nil, "Drink")
end})
potrofls:AddButton({text = "Reiatsu Potion", flag = "button", callback = function() 
    game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer("Reiatsu_Potion", nil, "Drink")
end})


--


abilmain = skillrofls:AddList({text = "Category", flag = "list", value = '' ,values = '', callback = function(a) 
	abillistupd(a)
end})


abillist = skillrofls:AddList({text = "Skills", flag = "list", value = '' ,values = '', callback = function(a) 
	selskill = a
end})

skillrofls:AddButton({text = "Give selected skill", flag = "button", callback = function() 
    game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer("EquipSkill", "Soul Reaper", selskill)
end})


--
rof:AddButton({text = "Destroy", flag = "button", callback = function() Library:Destr() end})
rof:AddButton({text = "New window", flag = "button", callback = 
function() 
	Library:CreateWindow("yay")
	Library:Init()
end})
--
local selserv = game.JobId
serv:AddButton({text = "Join to server (Server id box)", flag = "button", callback = function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, selserv, lp)
end})
-- serv:AddButton({text = "Change Server", flag = "button", callback = function()
-- 	TeleportService:Teleport(game.PlaceId, lp)
-- end})
servers = serv:AddList({text = "Servers", flag = "list", value = '',values = '', callback = function(a) 
	setclipboard(a)
	serversupd()
end})
sidcheck  = serv:AddButton({text = "Get Current Server id", flag = "button", callback = function()
	sid:SetValue(game.JobId)
	selserv = game.JobId
end})
sid = serv:AddBox({text = "Server id ", flag = "button", value = selserv, callback = function(a)
	selserv = a
end})




--

Library:Init()

pllistupd()
-- livlistupd()
serversupd()
vallistupd(ptarget)
abilmainlistupd()
-- print("Toggle is currently:", Library.flags["toggle"])

