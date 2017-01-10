-- Tractor mod

--[[
Copyright (C) 2017 Joseph 'Tucker' Bamberg AKA mootpoint
leave room for Foz to copyright if he wants
This file is part of tractor.
tractor is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
tractor is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with tractor.  If not, see <http://www.gnu.org/licenses/>.
]]
tractor = {}
-- some code borrowed from default farming 
local function tick(pos)

	minetest.get_node_timer(pos):start(math.random(166, 286))

end
-- far from a complete mod use at your own risk
-- Farming drop rates From the default farming mod
tractor.can_dig = function(pos, dignode, puncher)
	local diglist = {
		'farming:wheat_8',
		'farming:cotton_8',
		'farming_plus:carrot',
		'farming_plus:corn',
		'farming_plus:cotton',
		'farming_plus:cucumber',
		'farming_plus:potato',
		'farming_plus:pumkin',
		'farming_plus:rhubarb',
		'farming_plus:strawberry',
		'farming_plus:tomato',
		'farming_plus:weed',
		'farming_plus:wheat',
		
	}
	local name = puncher:get_player_name()
	if not minetest.is_protected(pos, name) then
		for _,v in pairs(diglist) do
			if v == dignode then
				return true
			end
		end
	end
end

tractor.check_pos = function(pos, facing, puncher)
	local newposnz = {}
	local newpospz = {}
	local newposnx = {}
	local newpospx = {}
	newposnz = {x = pos.x, y = pos.y, z = pos.z - 1} -- -z
	newpospz = {x = pos.x, y = pos.y, z = pos.z + 1} -- +z
	newposnx = {x = pos.x-1, y = pos.y, z = pos.z} -- -x
	newpospx = {x = pos.x+1, y = pos.y, z = pos.z} -- +x
	local nodenz = minetest.get_node(newposnz)
	local nodepz = minetest.get_node(newpospz)
	local nodenx = minetest.get_node(newposnx)
	local nodepx = minetest.get_node(newpospx)
	-- todo need to check the rarity for all the seeds listed below and make them match their original mod
	if tonumber(facing) == 1 then 
		local x = 1
		-- check forward left then right otherwise return nil
		if (nodenz.name ~= 'air' or nodenz.name ~= 'ignore') and tractor.can_dig(newposnz, nodenz.name, puncher) then
			minetest.log('Can go straight facing -z')
			return x
		elseif (nodepx.name ~= 'air' or nodepx.name ~= 'ignore') and tractor.can_dig(newpospx, nodepx.name, puncher) then
			minetest.log('Can left facing -z')
			x = 0
			return x
			
		elseif (nodenx.name ~= 'air' or nodenx.name ~= 'ignore') and tractor.can_dig(newposnx, nodenx.name, puncher) then
			minetest.log('Cango right Facing -z')
			x = 2
			return x
		elseif (nodepz.name ~= 'air' or nodepz.name ~= 'ignore') and tractor.can_dig(newpospz, nodepz.name, puncher) then
			x = 3
			return x
		else
			return nil
		end
	elseif tonumber(facing) == 2 then
		-- check forward left then right otherwise return nil
		local x = 2
		if (nodenx.name ~= 'air' or nodenx.name ~= 'ignore') and tractor.can_dig(newposnx, nodenx.name, puncher) then
			return x
		elseif (nodenz.name ~= 'air' or nodenz.name ~= 'ignore') and tractor.can_dig(newposnz, nodenz.name, puncher) then
			x = 1
			return x
		elseif (nodepz.name ~= 'air' or nodepz.name ~= 'ignore') and tractor.can_dig(newpospz, nodepz.name, puncher) then
			x = 3
			return x
		elseif (nodepx.name ~= 'air' or nodepx.name ~= 'ignore') and tractor.can_dig(newpospx, nodepx.name, puncher) then
			minetest.log('Can left facing -z')
			x = 0
			return x
		else
			return nil
		end
	elseif tonumber(facing) == 3 then
			-- check forward left then right otherwise return nil
		local x = 3
		if (nodepz.name ~= 'air' or nodepz.name ~= 'ignore') and tractor.can_dig(newpospz, nodepz.name, puncher) then
			return x
		elseif (nodenx.name ~= 'air' or nodenx.name ~= 'ignore') and tractor.can_dig(newposnx, nodenx.name, puncher) then
			x = 2
			return x
		elseif (nodepx.name ~= 'air' or nodepx.name ~= 'ignore') and tractor.can_dig(newpospx, nodepx.name, puncher) then
			x = 0
			return x
		elseif (nodenz.name ~= 'air' or nodenz.name ~= 'ignore') and tractor.can_dig(newposnz, nodenz.name, puncher) then
			x = 1
			return x
		else
			return nil
		end
	else  --facing is probably 0, if not it probably should be anyway
			-- check forward left then right otherwise return nil
		local x = 0
		if (nodepx.name ~= 'air' or nodepx.name ~= 'ignore') and tractor.can_dig(newpospx, nodepx.name, puncher) then
			return x
		elseif (nodepz.name ~= 'air' or nodepz.name ~= 'ignore') and tractor.can_dig(newpospz, nodepz.name, puncher) then
			x = 3
			return x
		elseif (nodenz.name ~= 'air' or nodenz.name ~= 'ignore') and tractor.can_dig(newposnz, nodenz.name, puncher) then
			x = 1
			return x
		elseif (nodenx.name ~= 'air' or nodenx.name ~= 'ignore') and tractor.can_dig(newposnx, nodenx.name, puncher) then
			x = 2
			return x
		else
			return nil
		end
	end
end
			
			
tractor.drop = function(pos, item, puncher)
	local rarity = math.random(1, 18)
	local seed = {}
	if item == 'farming:wheat_8' then
		minetest.add_item(pos, {name = 'farming:wheat'})
		if rarity == 1 then
			minetest.add_item(pos, {name = 'farming:wheat'})
			minetest.add_item(pos, {name = 'farming:seed_wheat'})
		end
		
		seed = {name = 'farming:seed_wheat', param1=0, param2=1}
		
	elseif item == 'farming:cotton_8' then
		minetest.add_item(pos, {name = 'farming:cotton'})
		if rarity == 1 then 
			minetest.add_item(pos, {name = 'farming:cotton'})
			minetest.add_item(pos, {name = 'farming:seed_cotton'})
		end
		seed = {name = 'farming:seed_cotton', param1=0, param2=1}
	elseif item == 'farming_plus:carrot' then
		minetest.add_item(pos, {name = 'farming_plus:carrot_item'})
		if rarity == 1 then 
			minetest.add_item(pos, {name = 'farming_plus:carrot_item'})
			minetest.add_item(pos, {name = 'farming_plus:carrot_seed'})
		end
		seed = {name = 'farming_plus:carrot_seed', param1=0, param2=1}
	elseif item == 'farming_plus:corn' then
		minetest.add_item(pos, {name = 'farming_plus:corn_item'})
		if rarity == 1 then 
			minetest.add_item(pos, {name = 'farming_plus:corn_item'})
			minetest.add_item(pos, {name = 'farming_plus:corn_seed'})
		end
		seed = {name = 'farming_plus:corn_seed'}
	elseif item == 'farming_plus:cotton' then
		minetest.add_item(pos, {name = 'farming:cotton'})
		if rarity == 1 then 
			minetest.add_item(pos, {name = 'farming:cotton'})
			minetest.add_item(pos, {name = 'farming:seed_cotton'})
		end
		seed = {name = 'farming:seed_cotton', param1=0, param2=1}
	elseif item == 'farming_plus:cucumber' then
		minetest.add_item(pos, {name = 'farming_plus:cucumber'})
		if rarity == 1 then 
			minetest.add_item(pos, {name = 'farming_plus:cucumber_item'})
			minetest.add_item(pos, {name = 'farming_plus:cucumber_seed'})
		end
		seed = {name = 'farming_plus:cucumber_seed', param1=0, param2=1}
	elseif item == 'farming_plus:potato' then
		minetest.add_item(pos, {name = 'farming_plus:potato_item'})
		if rarity == 1 then 
			minetest.add_item(pos, {name = 'farming_plus:potato_item'})
			minetest.add_item(pos, {name = 'farming_plus:potato_seed'})
		end
		seed = {name = 'farming_plus:potato_seed', param1=0, param2=1}
	elseif item == 'farming_plus:pumkin' then
		minetest.add_item(pos, {name = 'farming_plus:pumpkin'})
		seed = {name = 'farming_plus:pumpkin_seed', param1=0, param2=1}
	elseif item == 'farming_plus:rhubarb' then
		minetest.add_item(pos, {name = 'farming_plus:rhubarb_item'})
		if rarity == 1 then 
			minetest.add_item(pos, {name = 'farming:rhubarb_item'})
			minetest.add_item(pos, {name = 'farming:rhubarb_seed'})
		end
		seed = {name = 'farming_plus:rhubarb_seed', param1=0, param2=1}
	elseif item == 'farming_plus:strawberry' then
		minetest.add_item(pos, {name = 'farming_plus:strawberry_item'})
		if rarity == 1 then 
			minetest.add_item(pos, {name = 'farming_plus:strawberry_item'})
			minetest.add_item(pos, {name = 'farming_plus:strawberry_seed'})
		end
		seed = {name = 'farming_plus:strawberry_seed', param1=0, param2=1}
	elseif item == 'farming_plus:tomato' then
		minetest.add_item(pos, {name = 'farming_plus:tomato_item'})
		if rarity == 1 then 
			minetest.add_item(pos, {name = 'farming_plus:tomato_item'})
			minetest.add_item(pos, {name = 'farming_plus:tomato_seed'})
		end
		seed = {name = 'farming_plus:tomato_seed', param1=0, param2=1}
	elseif item == 'farming_plus:weed' then
		minetest.add_item(pos, {name = 'farming_plus:weed'})
		seed = 'air'
	elseif item == 'farming_plus:wheat' then
		minetest.add_item(pos, {name = 'farming:wheat'})
		if rarity == 1 then 
			minetest.add_item(pos, {name = 'farming:wheat'})
			minetest.add_item(pos, {name = 'farming:seed_wheat'})
		end
		seed = {name = 'farming:seed_wheat', param1=0, param2=1}
	else
		return 
	end
	return seed
end

tractor.setseed = function(pos, seed)
	
	local pt = {
		type = 'node',
		above = pos,
		under = {x = pos.x, y = pos.y-1, z = pos.z},
	}
	--minetest.add_node(pt.above, {name = seed, param2 = 1})

	return --tick(pt.above)
end

tractor.move = function(pos, puncher)
	local newpos = {}
	local tractornode = minetest.get_node(pos)
	local facing = tractornode.param2
	local plantseed = {}
	if tonumber(facing) == 1 then
		newpos = {x = pos.x, y = pos.y, z = pos.z - 1} -- -z
		local onode = minetest.get_node(newpos)
		if onode.name ~= 'air' and onode.name ~= 'ignore' and tractor.can_dig(newpos, onode.name, puncher) then			
			plantseed = tractor.drop(newpos, onode.name, puncher)
			minetest.dig_node(newpos)
			local nnode = {name='tractor:tractor', param1=0, param2=0}
			minetest.add_node(newpos, nnode)
			minetest.remove_node(pos)
			--tractor.setseed(pos, puncher, plantseed)
			return tractor.move(newpos, puncher)
		else
			local x = tractor.check_pos(pos, facing, puncher)
			if x == nil then
				return minetest.chat_send_all('Tractor Done')
			else
				minetest.remove_node(pos)
				local nnode = {name = 'tractor:tractor', param1=0, param2 = tonumber(x)}
				minetest.add_node(pos, nnode)
				return tractor.move(pos, puncher)
			end
		end
	elseif tonumber(facing) == 2 then
		newpos = {x = pos.x-1, y = pos.y, z = pos.z} -- -x
		local onode = minetest.get_node(newpos)
		if (onode.name ~= 'air' or onode.name ~= 'ignore') and tractor.can_dig(newpos, onode.name, puncher) then			
			plantseed = tractor.drop(newpos, onode.name, puncher)
			minetest.dig_node(newpos)
			local nnode = {name='tractor:tractor', param1=0, param2=0}
			minetest.add_node(newpos, nnode)
			minetest.remove_node(pos)
			--tractor.setseed(pos, puncher, plantseed)
			return tractor.move(newpos, puncher)
		else
			local x = tractor.check_pos(pos, facing, puncher)
			if x == nil then
				return minetest.chat_send_all('Tractor Done')
			else
				minetest.remove_node(pos)
				local nnode = {name = 'tractor:tractor', param1=0, param2 = tonumber(x)}
				minetest.add_node(pos, nnode)
				return tractor.move(pos, puncher)
			end
		end
	elseif tonumber(facing) == 3 then
		newpos = {x = pos.x, y = pos.y, z = pos.z+1} --+z
		local onode = minetest.get_node(newpos)
		if (onode.name ~= 'air' or onode.name ~= 'ignore') and tractor.can_dig(newpos, onode.name, puncher) then			
			plantseed = tractor.drop(newpos, onode.name, puncher)
			minetest.dig_node(newpos)
			local nnode = {name='tractor:tractor', param1=0, param2=0}
			minetest.add_node(newpos, nnode)
			minetest.remove_node(pos)
			--tractor.setseed(pos, puncher, plantseed)
			return tractor.move(newpos, puncher)
		else
			local x = tractor.check_pos(pos, facing, puncher)
			if x == nil then
				return minetest.chat_send_all('Tractor Done')
			else
				minetest.remove_node(pos)
				local nnode = {name = 'tractor:tractor', param1=0, param2 = tonumber(x)}
				minetest.add_node(pos, nnode)
				return tractor.move(pos, puncher)
			end
		end
				
	else
		newpos = {x = pos.x + 1, y = pos.y, z = pos.z} -- +x
		local onode = minetest.get_node(newpos)
		if (onode.name ~= 'air' or onode.name ~= 'ignore') and tractor.can_dig(newpos, onode.name, puncher) then			
			plantseed = tractor.drop(newpos, onode.name, puncher)
			minetest.dig_node(newpos)
			local nnode = {name='tractor:tractor', param1=0, param2=0}
			minetest.add_node(newpos, nnode)
			minetest.remove_node(pos)
		--	tractor.setseed(pos, puncher, plantseed)
			return tractor.move(newpos, puncher)
		else
			local x = tractor.check_pos(pos, facing, puncher)
			if x == nil then
				return minetest.chat_send_all('Tractor Done')
			else
				minetest.remove_node(pos)
				local nnode = {name = 'tractor:tractor', param1=0, param2 = tonumber(x)}
				minetest.add_node(pos, nnode)
				return tractor.move(pos, puncher)
			end
		end
	end
	
end
	
	
-- support for default farming and farming_plus
-- more supports to be added upon request
-- all functionality besides default should be optional



--Register Tractor

minetest.register_node('tractor:tractor', {
	description = 'Tractor for harvesting crops',
	tiles = {
		'tractor_top.png',
		'tractor_bottom.png',
		'tractor_front.png',
		'tractor_back.png',
		'tractor_left.png',
		'tractor_right.png',
	},
	drawtype = 'nodebox',
	paramtype = 'light',
	paramtype2 = 'facedir',
	node_box = {
		type = 'fixed',
		fixed = {
			{-0.4375, 0.3125, -0.25, 0.0625, 0.375, 0.25}, -- NodeBox1
			{-0.375, -0.5, -0.25, -0.1875, 0.3125, 0.25}, -- NodeBox2
			{-0.1875, -0.4375, -0.25, -0.125, 0.3125, 0.25}, -- NodeBox3
			{-0.125, -0.375, -0.25, -0.0625, 0.3125, 0.25}, -- NodeBox4
			{-0.0625, -0.3125, -0.25, 0.0625, 0.3125, 0.25}, -- NodeBox5
			{0.0625, -0.3125, -0.25, 0.125, 0.1875, 0.25}, -- NodeBox6
			{0.125, -0.3125, -0.25, 0.5, 0, 0.25}, -- NodeBox7
			{0.4375, -0.3125, -0.0625, 0.5, 0.125, 0.0625}, -- NodeBox8
			{0.25, -0.3125, -0.1875, 0.3125, 0.25, -0.125}, -- NodeBox10
			{0.1875, -0.4375, -0.25, 0.4375, -0.3125, 0.25}, -- NodeBox11
			{0.25, -0.5, -0.25, 0.375, -0.4375, 0.25}, -- NodeBox12
			{-0.4375, -0.4375, -0.25, -0.375, 0, 0.25}, -- NodeBox13
			{-0.5, -0.375, -0.25, -0.4375, -0.125, 0.25}, -- NodeBox14
			{-0.5, -0.0625, -0.25, -0.4375, 0, 0.25}, -- NodeBox15
		}
	},
	groups = {oddly_breakable_by_hand = 3},
	on_punch = function(pos, node, puncher, pointed_thing)
		tractor.move(pos, puncher)
	end
})
		