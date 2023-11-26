local OrionLib = loadstring(game:HttpGet(('https://github.com/cszndex/Utilities/raw/main/Prism/OrionLibrary.prism')))()
local Window = OrionLib:MakeWindow({
  Name = "Hikari [BSS]",
  HidePremium = true,
  IntroEnabled = false,
  SaveConfig = true,
  ConfigFolder = "Hikari"..tostring(game.PlaceId)
})
local Main = Window:MakeTab({
  Name = "Main",
  Icon = "",
  PremiumOnly = false,
})
local FarmSection = Main:AddSection({
  Name = "Farming"
})

local Player = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Connections = {
  connections = {}
}
function Connections:BindConnection(name,connect)
    if not Connections.connections[name] then
		Connections.connections[name] = connect
	else
		Connections.connections[name]:Disconnect()
		Connections.connections[name] = connect
	end
end
function Connections:BindToRenderStep(name,func)
	local connect = game:GetService("RunService").RenderStepped:Connect(func)
	if not Connections.connections[name] then
		Connections.connections[name] = connect
	else
		Connections.connections[name]:Disconnect()
		Connections.connections[name] = connect
	end
end
function Connections:BindToHeartbeat(name,func)
	local connect = game:GetService("RunService").Heartbeat:Connect(func)
	if not Connections.connections[name] then
		Connections.connections[name] = connect
	else
		Connections.connections[name]:Disconnect()
		Connections.connections[name] = connect
	end
end
function Connections:BindToStep(name,func)
	local connect = game:GetService("RunService").Stepped:Connect(func)
	if not Connections.connections[name] then
		Connections.connections[name] = connect
	else
		Connections.connections[name]:Disconnect()
		Connections.connections[name] = connect
	end
end
function Connections:UnbindConnection(name)
	if Connections.connections[name] then
		Connections.connections[name]:Disconnect()
	end
end

local HasFired = false
local tweenFarm = nil
local tweenInstance = nil

local Zones = {
  Table = {},
  Names = {}
}
for _, zone in next, workspace.FlowerZones:GetChildren() do
  table.insert(Zones.Names, zone.Name)
  table.insert(Zones.Table, zone)
end

getgenv().AutoFarm = false
getgenv().IgnoreHoney = false
getgenv().FarmZone = nil

RunService.PostSimulation:Connect(function(delta)
  task.spawn(function()
    local Capacity = Player.LocalPlayer.CoreStats:FindFirstChild("Capacity").Value
    local Pollen = Player.LocalPlayer.CoreStats:FindFirstChild("Pollen").Value
    local Collectibles = workspace:FindFirstChild("Collectibles")
    
    if getgenv().AutoFarm and getgenv().FarmZone then
      if Pollen <= 0 then
        Connections:BindToHeartbeat("AutoFarm", function()
          tweenFarm = TweenService:Create(Player.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(2), {CFrame = workspace.FlowerZones:FindFirstChild(getgenv().FarmZone).CFrame * CFrame.new(0, 5, 0)})
          tweenFarm:Play()
          tweenFarm.Completed:Connect(function()
            tweenFarm:Cancel()
          end)
          spawn(function()
            for _, item in next, Player.LocalPlayer.Character:GetChildren() do
              if item:IsA("Tool") then
                local itemName = item.Name
                Player.LocalPlayer.Character:FindFirstChild(itemName).ClickEvent:FireServer()
              end
            end
          end)
        end)
      end
      
      if Pollen >= Capacity then
        Connections:UnbindConnection("AutoFarm")
        
        for i, Platforms in next, workspace.HivePlatforms:GetChildren() do
          if Platforms:FindFirstChild("Circle").SurfaceGui.TextLabel.Text == Player.LocalPlayer.Name then
            local PlayerPos = Player.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
            local CirclePos = Platforms:FindFirstChild("Circle").Position
            
            local Distance = (PlayerPos - CirclePos).Magnitude
            
            tweenInstance = TweenService:Create(Player.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(5), {CFrame = Platforms:FindFirstChild("Circle").CFrame * CFrame.new(0, 5.184680700302, 0)})
            tweenInstance:Play()
            
            if Distance <= 7 and not HasFired then
              tweenInstance:Cancel()
              local args = {
                [1] = "ToggleHoneyMaking"
              }
              game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer(unpack(args))
              HasFired = true
            elseif Distance >= 7 then
              HasFired = false
            end
          end
        end
      end
    else
      Connections:UnbindConnection("AutoFarm")
    end
  end)
end)

FarmSection:AddToggle({
  Name = "Auto Farm",
  Default = false,
  Callback = function(bool)
    getgenv().AutoFarm = bool
  end
})
FarmSection:AddToggle({
  Name = "Ignore Honey",
  Default = false,
  Callback = function(bool)
    getgenv().IgnoreHoney = bool
  end
})
FarmSection:AddDropdown({
  Name = "Zone Dropdown",
  Default = "",
  Options = Zones.Names,
  Callback = function(value)
    getgenv().FarmZone = value
  end
})