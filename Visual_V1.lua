local PlaceId = game.PlaceId
local GameName = game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name


if GameName then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Visual V1",
        Text = "SCRIPT EJECUTADO, DISFRUTALO",
        Duration = 5
    })
end
