local selection = game:GetService("Selection");

local CS = game:GetService("CollectionService");

local CSS = game:GetService("ChangeHistoryService");

local bar = plugin:CreateToolbar("Mass Apply textures.");

local button = bar:CreateButton("Open","Open","");

local Maid = require(script.Maid);

local maid = Maid.new();

local buttonMaid = Maid.new();

local faces = {};

local texture = nil;

local WI = DockWidgetPluginGuiInfo.new(

	Enum.InitialDockState.Float,

	true,

	true, 

	100,

	150

);

local w = plugin:CreateDockWidgetPluginGui("MassApply", WI);

w.Name = "MassApply";

w.Title = "Mass Apply__Test";

w.Enabled = false;

if not w:FindFirstChild("MainFrame") then

	script.MainFrame.Parent = w;

end;

local function id_name(name)

	local words = name:split(".");

	return words[3];

end;

local function generate_all_sides(text)

	if texture == nil then

		return false;

	end;



	local faceT = Enum.NormalId:GetEnumItems();

	local faces = {};

	for i,enum in pairs(faceT) do

		local clone = text:Clone();

		clone.Face = enum;

		clone.Name = id_name(tostring(enum));

		faces[i] = clone;

	end;

	if #faces > 0 then

		return faces;

	else

		return false;

	end;

end;

local GUI = {};

function GUI.__new(text,obj)

	local gui = script.ChoiceGui:Clone();

	gui.OBJ.Value = obj;

	gui.name.Text = text;

	gui.Parent = w.MainFrame.B.Labels;

	return gui.E.MouseButton1Click, gui;

end;

function GUI.__onClicked(obj)

	if obj == nil then

		return;

	end;

	if not obj:FindFirstChild("Enabled") then

		return;

	end;

	local bool = obj:FindFirstChild("Enabled")

	bool.Value = not bool.Value;

	if bool.Value then

		obj.E.BackgroundColor3 = Color3.fromRGB(0,255,0);

	else

		obj.E.BackgroundColor3 = Color3.fromRGB(255, 0, 0);

	end;

end;

function __clicked()

	w.Enabled = not w.Enabled;

	selection:Remove(selection:Get());

	buttonMaid:GiveTask(w.MainFrame.A.Select.MouseButton1Click:Connect(function()

		local items = selection:Get();

		local textures = {};

		for i,v in pairs(items) do

			if v:IsA("Texture") then

				table.insert(textures,v);

			end;

		end;

		local texturea = textures[1];

		texture = texturea;

		if texturea ~= nil then

			w.MainFrame.A.Label.Text = texturea.Name;

		end;

		w.MainFrame.A.Continue.Visible = true;

		buttonMaid:GiveTask(w.MainFrame.A.Continue.MouseButton1Click:Connect(function()

			if #items == 0 and w.MainFrame.A.Label.Text == "" then

				w.MainFrame.A.Label.Text = "No texture selected!"

			elseif #items ~= 0 then

				w.MainFrame.B.Visible = true;

				w.MainFrame.A.Visible = false;

				w.MainFrame.A.Continue.Visible = false;

				w.MainFrame.A.Label.Text = "";



				for i,v in pairs(w.MainFrame.B.Faces:GetChildren()) do

					maid:GiveTask(v.MouseButton1Click:Connect(function()

						local g_enabled = not v:GetAttribute("Enabled")

						v:SetAttribute("Enabled",g_enabled);

						faces[v.Name] = g_enabled;

						if g_enabled then

							v.BackgroundColor3 = Color3.fromRGB(195,55,55);

						else

							v.BackgroundColor3 = Color3.fromRGB(255,255,255);

						end;

					end));

				end;



			elseif w.MainFrame.A.Label.Text ~= "" and #items == 0 and tonumber(w.MainFrame.A.Label.Text:split(" ")[#w.MainFrame.A.Label.Text:split(" ")]) ~= nil and not w.MainFrame.A.Label.Text:find(" ") then

				texture = Instance.new("Texture");

				texture.Texture = "rbxassetid://"..w.MainFrame.A.Label.Text:split(" ")[#w.MainFrame.A.Label.Text:split(" ")];

				w.MainFrame.B.Visible = true;

				w.MainFrame.A.Visible = false;

				w.MainFrame.A.Continue.Visible = false;

				w.MainFrame.A.Label.Text = "";



				for i,v in pairs(w.MainFrame.B.Faces:GetChildren()) do

					maid:GiveTask(v.MouseButton1Click:Connect(function()

						local g_enabled = not v:GetAttribute("Enabled")

						v:SetAttribute("Enabled",g_enabled);

						faces[v.Name] = g_enabled;

						if g_enabled then

							v.BackgroundColor3 = Color3.fromRGB(195,55,55);

						else

							v.BackgroundColor3 = Color3.fromRGB(255,255,255);

						end;

					end));

				end;



			else

				w.MainFrame.A.Label.Text = "Failed."

			end;

		end));

	end));











	buttonMaid:GiveTask(w.MainFrame.B.Select.MouseButton1Click:Connect(function()

		--beginning of select

		local items = selection:Get();

		local objs = {};

		local doneOBJs = CS:GetTagged("Applied_to");



		for i,v in pairs(w.MainFrame.B.Faces:GetChildren()) do

			v.Visible = true;

		end;

		for i,v in pairs(items) do

			if v:IsA("BasePart") then

				table.insert(objs,v);				

			elseif v:IsA("Model") or v:IsA("Folder") then

				for _,p in pairs(v:GetDescendants()) do

					if p:IsA("BasePart") then

						table.insert(objs,p);

					end;

				end;

			end;

		end;

		if #objs ~= 0 then

			for i = #objs,1,-1 do

				local v = objs[i];

				print(v);

				print(i);

				print(objs);

				if #doneOBJs > 0 and v ~= nil then	

					if not CS:HasTag(v,"Applied_to") then			

						CS:AddTag(v,"Applied_to");

						local enabled,obj = GUI.__new(v.Name,v);

						maid:GiveTask(enabled:Connect(function()

							GUI.__onClicked(obj);

						end));

						maid:GiveTask(obj.MouseEnter:Connect(function()

							selection:Set({obj.OBJ.Value});

						end));

						table.remove(objs,i);

					end;

				elseif v ~= nil then

					if not CS:HasTag(v,"Applied_to") then

						CS:AddTag(v,"Applied_to");

						local enabled,obj = GUI.__new(v.Name,v);

						maid:GiveTask(enabled:Connect(function()

							GUI.__onClicked(obj);

						end));

						maid:GiveTask(obj.MouseEnter:Connect(function()

							selection:Set({obj.OBJ.Value});

						end));

						table.remove(objs,i);

						table.insert(doneOBJs,v);

					end;

				else

					warn("PART IS NIL");

					continue;

				end;

			end;

		end;



		table.clear(objs);

		table.clear(doneOBJs);

		--end of select





		w.MainFrame.B.Continue.Visible = true;

		buttonMaid:GiveTask(w.MainFrame.B.Continue.MouseButton1Click:Connect(function()

			CSS:SetWaypoint("beforeApply")

			if texture ~= nil and texture ~= "" then

				local facet = generate_all_sides(texture);

				for i,v in pairs(w.MainFrame.B.Labels:GetChildren()) do

					if v:IsA("Frame") then

						if v:FindFirstChild("Enabled").Value then

							local OBJ = v.OBJ.Value;

							for l,face in pairs(facet) do

								if faces[face.Name] == true then

									local newface = face:Clone();

									newface.Parent = OBJ;

								end;

							end;

						end;

					end;

				end;

			end;

			CSS:SetWaypoint("afterApply");

			texture = nil;

			w.MainFrame.B.Visible = false;

			w.MainFrame.A.Visible = true;

			w.MainFrame.B.Continue.Visible = false;

            w.MainFrame.A.Label.Text = "";

			maid:DoCleaning();

			for i,v in pairs(CS:GetTagged("Applied_to")) do

				CS:RemoveTag(v,"Applied_to");

			end;

			for i,v in pairs(w.MainFrame.B.Faces:GetChildren()) do

				v.Visible = false;

				v.BackgroundColor3 = Color3.fromRGB(255,255,255);

			end;

			for i,v in pairs(w.MainFrame.B.Labels:GetChildren()) do

				if not v:IsA("UIListLayout") then

					v:Destroy();

				end;

			end;

			for i,v in pairs(w.MainFrame.B.Faces:GetChildren()) do

				v:SetAttribute("Enabled",false);

			end;

            selection:Set({});

		end));

	end));

end;

w:BindToClose(function()

	w.Enabled = false;

	for i,v in pairs(CS:GetTagged("Applied_to")) do

		CS:RemoveTag(v,"Applied_to");

	end;

	texture = nil;

	w.MainFrame.A.Label.Text = "";

	w.MainFrame.B.Visible = false;

	w.MainFrame.A.Visible = true;

	w.MainFrame.B.Continue.Visible = false;

	maid:DoCleaning();

	buttonMaid:DoCleaning();

	for i,v in pairs(w.MainFrame.B.Faces:GetChildren()) do

		v.Visible = false;

		v.BackgroundColor3 = Color3.fromRGB(255,255,255);

	end;

	for i,v in pairs(w.MainFrame.B.Labels:GetChildren()) do

		if not v:IsA("UIListLayout") then

			v:Destroy();

		end;

	end;

	for i,v in pairs(w.MainFrame.B.Faces:GetChildren()) do

		v:SetAttribute("Enabled",false);

	end;	

end);



button.Click:Connect(__clicked);

