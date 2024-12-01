local namecall
local RunService = game:GetService("RunService")
local ClosestPlayer = nil
local ShootStart
--60/70 ping = 0.04
--130/140 ping = 0.09
-- wide ping ranges and they arent great, i didnt have time for more
local function getClosestPlayer()
    local closest
    local cMag = math.huge
    for i, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Character and v.Character.HumanoidRootPart and v ~= game:GetService("Players").LocalPlayer then
            local mag = (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
            if mag < cMag then
                cMag = mag
                closest = v
            end
        end
    end
    return closest
end



RunService.Heartbeat:Connect(function()
    ClosestPlayer = getClosestPlayer() 
    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Gun") then 
        ShootStart = game:GetService("Players").LocalPlayer.Character.Gun.GunServer.ShootStart
    else 
        ShootStart = nil 
    end
end)

namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod():lower()

    if not checkcaller() and self == ShootStart and method == "fireserver" and ShootStart then
        if ClosestPlayer and ClosestPlayer.Character and ClosestPlayer.Character.HumanoidRootPart then
            args[2] = ClosestPlayer.Character.HumanoidRootPart.Position + (ClosestPlayer.Character.HumanoidRootPart.Velocity * getgenv().prediction)
        end

        return namecall(self, unpack(args))
    end
    return namecall(self, ...)
end)
