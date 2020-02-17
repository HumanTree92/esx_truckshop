ESX = nil
local categories, vehicles = {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('[esx_truckshop] [^3WARNING^7] Plate character count reached, %s/8 characters!'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM truck_categories', {}, function(_categories)
		categories = _categories

		MySQL.Async.fetchAll('SELECT * FROM trucks', {}, function(_vehicles)
			vehicles = _vehicles

			for k,v in ipairs(vehicles) do
				for k2,v2 in ipairs(categories) do
					if v2.name == v.category then
						vehicles[k].categoryLabel = v2.label
						break
					end
				end
			end

			-- send information after db has loaded, making sure everyone gets vehicle information
			TriggerClientEvent('esx_truckshop:sendCategories', -1, categories)
			TriggerClientEvent('esx_truckshop:sendVehicles', -1, vehicles)
		end)
	end)
end)

function getVehicleLabelFromModel(model)
	for k,v in ipairs(vehicles) do
		if v.model == model then
			return v.name
		end
	end

	return
end

ESX.RegisterServerCallback('esx_truckshop:getCategories', function(source, cb)
	cb(categories)
end)

ESX.RegisterServerCallback('esx_truckshop:getVehicles', function(source, cb)
	cb(vehicles)
end)

ESX.RegisterServerCallback('esx_truckshop:buyVehicle', function(source, cb, model, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local modelPrice

	for k,v in ipairs(vehicles) do
		if model == v.model then
			modelPrice = v.price
			break
		end
	end

	if modelPrice and xPlayer.getMoney() >= modelPrice then
		xPlayer.removeMoney(modelPrice)

		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)', {
			['@owner']   = xPlayer.identifier,
			['@plate']   = plate,
			['@vehicle'] = json.encode({model = GetHashKey(model), plate = plate}),
			['@type']    = 'car'
		}, function(rowsChanged)
			xPlayer.showNotification(_U('truck_belongs', plate))
			cb(true)
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_truckshop:resellVehicle', function(source, cb, plate, model)
	local resellPrice

	-- calculate the resell price
	for i=1, #vehicles, 1 do
		if GetHashKey(vehicles[i].model) == model then
			resellPrice = ESX.Math.Round(vehicles[i].price / 100 * Config.ResellPercentage)
			break
		end
	end

	if not resellPrice then
		print(('[esx_truckshop] [^3WARNING^7] %s attempted to sell an unknown vehicle!'):format(GetPlayerIdentifiers(source)[1]))
		cb(false)
	else
		local xPlayer = ESX.GetPlayerFromId(source)

		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = plate
		}, function(result)
			if result[1] then -- does the owner match?
				local vehicle = json.decode(result[1].vehicle)

				if vehicle.model == model then
					if vehicle.plate == plate then
						xPlayer.addMoney(resellPrice)
						RemoveOwnedVehicle(plate)
						cb(true)
					else
						print(('[esx_truckshop] [^3WARNING^7] %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
						cb(false)
					end
				else
					print(('[esx_truckshop] [^3WARNING^7] %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
					cb(false)
				end
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_truckshop:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('esx_truckshop:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.identifier,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)

RegisterNetEvent('esx_truckshop:setJobVehicleState')
AddEventHandler('esx_truckshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('[esx_truckshop] [^3WARNING^7] %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)
