Config = {}
Config.Locale = 'en'

Config.DrawDistance = 100
Config.MarkerColor  = {r = 120, g = 120, b = 240}

Config.ResellPercentage = 50
Config.LicenseEnable    = true

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Zones = {
	ShopEntering = { -- Marker for Accessing Shop
		Pos   = vector3(900.4, -1155.0, 24.1),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 1
	},
	ShopInside = { -- Marker for Viewing Vehicles
		Pos     = vector3(927.5, -1226.8, 24.6),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 102.93,
		Type    = -1
	},
	ShopOutside = { -- Marker for Purchasing Vehicles
		Pos     = vector3(994.7, -1186.4, 24.5),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 93.19,
		Type    = -1
	},
	ResellVehicle = { -- Marker for Selling Vehicles
		Pos   = vector3(879.2, -1168.5, 24.0),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = 1
	}
}
