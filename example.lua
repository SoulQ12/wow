-- Welcome to the Tinkr scripting system! We provide many utilties to help
-- you along the way, below you can find a few examples.
-- The Tinkr object is passed to all scripts and can be accessed via the
-- global vararg as shown below.  You don't need to understand this, just
-- know that this is how you get your local copy of the Tinkr library.
local Tinkr = ...

-- A simple script to draw lines and the names of all objects around you.
local Draw = Tinkr.Util.Draw:New()
local Common = Tinkr.Common
local ObjectManager = Tinkr.Util.ObjectManager

Draw:Sync(function(draw)
	local px, py, pz = ObjectPosition("player")

	-- draw the cursor position in world
	local mx, my, mz = Common.ScreenToWorld(GetCursorPosition())
	draw:SetColor(draw.colors.white)
	draw:Circle(mx, my, mz, 0.5)

	local playerHeight = ObjectHeight("player")
	local playerRadius = ObjectBoundingRadius("player")
	local combatReach = ObjectCombatReach("player")

	draw:SetColor(draw.colors.white)
	draw:Circle(px, py, pz, playerRadius)
	draw:Circle(px, py, pz, combatReach)

	local rotation = ObjectRotation("player")
	local rx, ry, rz = RotateVector(px, py, pz, rotation, playerRadius)
	draw:Line(px, py, pz, rx, ry, rz)

	for object in ObjectManager:Objects() do
		local name = ObjectType(object) == 7 and GetSpellInfo(ObjectId(object)) or ObjectName(object)
		-- local name = ObjectAddress(object)
		-- local name = ObjectID(object)
		-- local name = ObjectType(object)
		-- local name = ObjectSkinnable(object) and "skin me" or "Nope"
		local height = ObjectHeight(object) or 1
		local x, y, z = ObjectPosition(object)
		if x and y and z then
			local distance = Common.Distance(px, py, pz, x, y, z)
			if distance < 100 then
				draw:SetColorFromObject(object)
				local hx, hy, hz = TraceLine(px, py, pz + playerHeight, x, y, z + height, Common.HitFlags.All)
				if hx ~= 0 or hy ~= 0 or hz ~= 0 then
					draw:SetAlpha(48)
				else
					draw:SetAlpha(196)
				end

				local angleBetween = Common.GetAnglesBetweenPositions(px, py, pz, x, y, z)
				local sx, sy, sz = Common.GetPositionFromPosition(px, py, pz, playerRadius, angleBetween, 0)
				draw:Line(sx, sy, sz, x, y, z)
				draw:Text(
					(name or "Obj") .. " (" .. Common.Round(distance, 1) .. ")",
					"SourceCodePro",
					x,
					y,
					z + height
				)
			end
		end
	end

	for m in ObjectManager:Missiles() do
		-- inital -> hit
		-- draw:SetColor(255, 255, 255, 128)
		draw:Line(m.ix, m.iy, m.iz, m.hx, m.hy, m.hz)

		-- current -> hit
		-- draw:SetColor(3, 252, 11, 256)
		draw:Line(m.cx, m.cy, m.cz, m.hx, m.hy, m.hz)

		-- model -> hit
		if m.mx and m.my and m.mz then
			-- draw:SetColor(3, 252, 252, 256)
			draw:Line(m.mx, m.my, m.mz, m.hx, m.hy, m.hz)
		end

		-- draw:SetColor(255, 255, 255, 255)
		local cdt = Common.Distance(m.cx, m.cy, m.cz, m.hx, m.hy, m.hz)
		local spell = GetSpellInfo(m.spellId)
		draw:Text((spell or m.spellId), "NumberFont_Small", m.cx, m.cy, m.cz + 1.35)
	end
end)

Draw:Enable()
