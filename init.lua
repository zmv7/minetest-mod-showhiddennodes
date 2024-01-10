local enabled = {}

local function shn(name,radius)
	if enabled[name] then
		local player = minetest.get_player_by_name(name)
		local ppos = player and vector.round(player:get_pos())
		if not ppos then return end
		for x = ppos.x-radius, ppos.x+radius do
			for y = ppos.y-radius, ppos.y+radius do
				for z = ppos.z-radius, ppos.z+radius do
					local pos = {x=x,y=y,z=z}
					local dist = vector.distance(ppos,pos)
					if dist <= radius then
						local node = minetest.get_node_or_nil(pos)
						local ndef = node and minetest.registered_nodes[node.name]
						if ndef and node.name ~= "air" and ndef.drawtype == "airlike" then
							minetest.add_particle({
								playername = name,
								pos = pos,
								velocity = {x=0, y=0, z=0},
								acceleration = {x=0, y=0, z=0},
								expirationtime = 2,
								size = 10,
								collisiondetection = false,
								collision_removal = false,
								vertical = false,
								texture = "camera_btn.png^[colorize:#ff0:255",
								glow = 14
							})
						end
					end
				end
			end
		end
		minetest.after(1,shn,name,radius)
	end
end

minetest.register_privilege("showhiddennodes",{
	description = "Allows using /shn",
	give_to_singleplayer = false,
})

minetest.register_chatcommand("shn",{
  description = "Toggle showing hidden nodes",
  privs = {showhiddennodes=true},
  func = function(name,param)
	local player = minetest.get_player_by_name(name)
	if not name then
		return false, "This command can be used in-game only!"
	end
	enabled[name] = not enabled[name]
	shn(name,10)
	return true, "Hidden nodes showing is now "..(enabled[name] and "enabled" or "disabled")
end})
