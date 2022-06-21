script_name('Imgui asv') -- название скрипта
script_author('bars') -- автор скрипта
script_description('Imgui') -- описание скрипта


require "lib.moonloader" -- подключение библиотеки
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local directIni = "moonloader\\config\\CRIP.ini"
--local mainIni = inicfg.load(nil, directIni)
--local mainIni = inicfg.save(mainIni, directIni)
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 1
local script_vers_text = "1.00"

local update_url = "https://raw.githubusercontent.com/Barsomet/CRIP/main/update.ini" -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. "/update.ini" -- и тут свою ссылку

local script_url = "" -- тут свою ссылку
local script_path = thisScript().path


local pInfo = {
  Tag ="[Стажер ВСБ]:",
  BOACList = "15",
  AutoClist 		= true,
  AutoColor 		= true,
  Questions = {},
  Lecture = {},
  Dates = {}
}

local rkeys = require 'rkeys'
imgui.ToggleButton = require('imgui_addons').ToggleButton
imgui.HotKey = require('imgui_addons').HotKey
imgui.Spinner = require('imgui_addons').Spinner
imgui.BufferingBar = require('imgui_addons').BufferingBar

menu = imgui.ImBool(false)
window = imgui.ImBool(false)
okno = imgui.ImBool(false)
main_window_state = imgui.ImBool(false)
arrSelectable = {false, false}

local x, y, z = 0, 0, 0

function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    style.WindowPadding = imgui.ImVec2(9, 5)
    style.WindowRounding = 10
    style.ChildWindowRounding = 10
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 6.0
    style.ItemSpacing = imgui.ImVec2(9.0, 3.0)
    style.ItemInnerSpacing = imgui.ImVec2(9.0, 3.0)
    style.IndentSpacing = 21
    style.ScrollbarSize = 6.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 17.0
    style.GrabRounding = 16.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)


    colors[clr.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
    colors[clr.TextDisabled]           = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.ChildWindowBg]          = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.PopupBg]                = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.Border]                 = ImVec4(0.82, 0.77, 0.78, 1.00)
    colors[clr.BorderShadow]           = ImVec4(0.35, 0.35, 0.35, 0.66)
    colors[clr.FrameBg]                = ImVec4(40.00, 1.00, 1.00, 0.28)
    colors[clr.FrameBgHovered]         = ImVec4(0.68, 0.68, 0.68, 0.67)
    colors[clr.FrameBgActive]          = ImVec4(0.79, 0.73, 0.73, 0.62)
    colors[clr.TitleBg]                = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.46, 0.46, 0.46, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.MenuBarBg]              = ImVec4(0.00, 0.00, 0.00, 0.80)
    colors[clr.ScrollbarBg]            = ImVec4(0.00, 0.00, 0.00, 0.60)
    colors[clr.ScrollbarGrab]          = ImVec4(1.00, 1.00, 1.00, 0.87)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(1.00, 1.00, 1.00, 0.79)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.80, 0.50, 0.50, 0.40)
    colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 0.99)
    colors[clr.CheckMark]              = ImVec4(0.99, 0.99, 0.99, 0.52)
    colors[clr.SliderGrab]             = ImVec4(1.00, 1.00, 1.00, 0.42)
    colors[clr.SliderGrabActive]       = ImVec4(0.76, 0.76, 0.76, 1.00)
    colors[clr.Button]                 = ImVec4(0.51, 0.51, 0.51, 0.60)
    colors[clr.ButtonHovered]          = ImVec4(0.68, 0.68, 0.68, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.67, 0.67, 0.67, 1.00)
    colors[clr.Header]                 = ImVec4(0.72, 0.72, 0.72, 0.54)
    colors[clr.HeaderHovered]          = ImVec4(0.92, 0.92, 0.95, 0.77)
    colors[clr.HeaderActive]           = ImVec4(0.82, 0.82, 0.82, 0.80)
    colors[clr.Separator]              = ImVec4(0.73, 0.73, 0.73, 1.00)
    colors[clr.SeparatorHovered]       = ImVec4(0.81, 0.81, 0.81, 1.00)
    colors[clr.SeparatorActive]        = ImVec4(0.74, 0.74, 0.74, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.80, 0.80, 0.80, 0.30)
    colors[clr.ResizeGripHovered]      = ImVec4(0.95, 0.95, 0.95, 0.60)
    colors[clr.ResizeGripActive]       = ImVec4(1.00, 1.00, 1.00, 0.90)
    colors[clr.CloseButton]            = ImVec4(0.45, 0.45, 0.45, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.70, 0.70, 0.90, 0.60)
    colors[clr.CloseButtonActive]      = ImVec4(0.70, 0.70, 0.70, 1.00)
    colors[clr.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(1.00, 1.00, 1.00, 0.35)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.88, 0.88, 0.88, 0.35)
end

apply_custom_style()

function main()
	repeat wait(0) until isSampAvailable()
    while not isSampLoaded() or not isSampfuncsLoaded() do wait(80) end
    sampRegisterChatCommand('sp', search)
    sampRegisterChatCommand('help', cmd_update)
    sampRegisterChatCommand('cl', clist)
	sampRegisterChatCommand('sos', sos)
	sampRegisterChatCommand('helpos', helpos)
	sampRegisterChatCommand('getinfo', cfg)
    sampRegisterChatCommand('setinfo', cf)
	sampRegisterChatCommand('tag', tag)
	sampRegisterChatCommand('ps', ps)
    sampRegisterChatCommand('pf', pf)	
	sampRegisterChatCommand('kmb', cmd_kmb)
	sampRegisterChatCommand('l', cmd_undate)
	sampRegisterChatCommand('infa', infa)
	sampRegisterChatCommand('meny', meny)
	sampRegisterChatCommand('car', car)
	sampRegisterChatCommand("update", cmd_update)
	imgui.SwitchContext()
	
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("Есть обновление! Версия: " .. updateIni.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end
    end)	
	
	while true do
        wait(0)
                     
        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            break
        end            
			
			
			
			if isCharInAnyCar(PLAYER_PED) then
                local carhandle = storeCarCharIsInNoSave(PLAYER_PED)
                carId = getCarModel(carhandle)
                local Driver = getDriverOfCar(carhandle)
                if Driver==PLAYER_PED and carId==433 then
                    siren = isCarSirenOn(carhandle)
                    inTruck = true
                else
                    inTruck = false
                end
            else
                carId = 0 inTruck = false
            end
            if inTruck then
                okno.v = true
            else
                okno.v = false
            end             
            if inTruck then
                window.v = true
            else
                window.v = false
            end 	  
	   
	   
	    if text == " Рабочий день начат" and color == 1790050303 then
        lua_thread.create(function()
            wait(200)
            sampSendChat("/b Кхм..")
        end)
    end
	   if isKeyJustPressed(VK_SPACE) and sampIsChatInputActive() and sampGetChatInputText() =="/mem " then sampSetChatInputText("/members ") end
	   if isKeyJustPressed(VK_SPACE) and sampIsChatInputActive() and sampGetChatInputText() =="/r " then sampSetChatInputText("/r "..mainIni.config.tag.." ") end             
	   if on then

			if carId == 433 then sampSendChat('Еуу') end
			
			if draw_suka then
                --setMarker(1, x, y, z-2, 1, 0xFFFFFFFF)
                removeUser3dMarker(mark)
                mark = createUser3dMarker(x,y,z+2,0xFFD00000)
            else
                removeUser3dMarker(mark)
                --deleteCheckpoint(marker)
                --removeBlip(checkpoint)
            end
        end
    end
end

lua_thread.create(function()
    while true do
        wait(0)
            if isCharDead(PLAYER_PED) then
                wait(5000)
                sampAddChatMessage("clist "..mainIni.config.clist.."", -1)
            end
       
    end
end)

function cfg (arg)
  mainIni = inicfg.load(nil, directIni) 
     sampSendChat(mainIni.config.name, -1)
end

function tag(arg)
	mainIni.config.tag = arg
    if inicfg.save(mainIni, directIni) then
       sampAddChatMessage("{8B0000}[CarCheck]: {FFFFFF}Вы сменили тег на - {CD853F}"..mainIni.config.tag.."", -1)
    end
end

function cf(arg)
	mainIni.config.clist = arg
    if inicfg.save(mainIni, directIni) then
       sampAddChatMessage("{8B0000}[CarCheck]: {FFFFFF}Вы сменили клист на {CD853F}["..mainIni.config.clist.."]", -1)
    end
end

toggle_status = imgui.ImBool(false)
toggle_status_2 = imgui.ImBool(false)
toggle_status_3 = imgui.ImBool(false)
toggle_status_4 = imgui.ImBool(false)
toggle_status_5  = imgui.ImBool(false)
toggle_status_6 = imgui.ImBool(false)

function infa(arg)
	main_window_state.v = not main_window_state.v
    imgui.Process = main_window_state.v
end



function imgui.CenterText(text)
local width = imgui.GetWindowWidth()
local calc = imgui.CalcTextSize(text)
imgui.SetCursorPosX( width / 2 - calc.x / 2 )
imgui.Text(text)
end

function imgui.OnDrawFrame()

           if main_window_state.v and not menu.v then 
		     imgui.Process = false
		   end
        imgui.Process = main_window_state.v or menu.v
        if main_window_state.v then
        imgui.ShowCursor = false

		
		local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 1.1, sh / 1.1), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(263, 110), imgui.Cond.FirstUseEver)

        imgui.Begin('Speck ', main_window_state, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize )
			
		   				        		
		
            _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
            local myname = sampGetPlayerNickname(myid)
            local myping = sampGetPlayerPing(myid)
            local myweapon = getCurrentCharWeapon(PLAYER_PED)
            local myweaponammo = getAmmoInCharWeapon(PLAYER_PED, myweapon)
            local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)

                if isCharInAnyCar(PLAYER_PED) then
                local carhandle = storeCarCharIsInNoSave(PLAYER_PED)
                carId = getCarModel(carhandle)
                local Driver = getDriverOfCar(carhandle)
                if Driver==PLAYER_PED and carId==433 then
                    siren = isCarSirenOn(carhandle)
                    inTruck = true
                else
                    inTruck = false
                end
            else
                carId = 0 inTruck = false
            end
			
			imgui.Text((u8"Nick:"):format(myname, myid, myping))
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(getColor(myid)), u8('%s [%s] | Ping: [%s] '):format(myname, myid, myping))	
		    imgui.Text((u8'Квадрат: %s'):format(u8(kvadrat())))  
			imgui.SameLine()
			imgui.Text((u8 '|  Время: %s'):format(os.date('%H:%M:%S'))) 
			if isCharInAnyCar(playerPed) then
            local vHandle = storeCarCharIsInNoSave(playerPed)
            local result, vID = sampGetVehicleIdByCarHandle(vHandle)
            local vHP = getCarHealth(vHandle)
            local carspeed = getCarSpeed(vHandle)
            local speed = math.floor(carspeed)
            local ncspeed = math.floor(carspeed*2)
			 imgui.Text((u8'Check:| HP: %s | Скорость: %s'):format(vHP, ncspeed))
			 imgui.Text(u8'CarCheck:')
             imgui.TextColored(imgui.ImVec4(0.0, 0.255, 0.0, 1.0 ), u8'Вы в машине', imgui.SameLine())
			if imgui.Button(u8"Меню Хэлпера", imgui.ImVec2(240, 23)) then
                   menu.v = not menu.v 
			    imgui.Process = main_window_state.v
             end			
		
		else
		    imgui.Text(u8'CarCheck:')
            imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Вы не в машине', imgui.SameLine())
               

			   
				if valid and doesCharExist(ped) then 
                local result, id = sampGetPlayerIdByCharHandle(ped)
                if result then
                    local targetname = sampGetPlayerNickname(id)
                    local targetscore = sampGetPlayerScore(id)
                    imgui.Text((u8 '%s [%s] | Уровень: %s'):format(targetname, id, targetscore))                
				else
		   imgui.Text(u8'ManСheck:')
            imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Человека нету', imgui.SameLine())
                end
            else
		   imgui.Text(u8'ManСheck:')
            imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Человека нету', imgui.SameLine())
            end       
			if imgui.Button(u8"Меню Хэлпера", imgui.ImVec2(240, 23)) then
                   menu.v = not menu.v 
			    imgui.Process = main_window_state.v
        end	
	  end   	
		
		if menu.v then 
		imgui.ShowCursor = false
		local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 1.1), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600, 40), imgui.Cond.FirstUseEver)

        imgui.Begin('BARS HELPER ', menu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar )		   
		if imgui.Button(u8"Пустышка", imgui.ImVec2(130, 26)) then
           --code
        end	            
		imgui.SameLine()
		if imgui.Button(u8"Пустышка", imgui.ImVec2(160, 26))  then
           --code
		end 
		imgui.SameLine()
		if imgui.Button(u8"Пустышка", imgui.ImVec2(130, 26)) then
           --code
        end	   
		imgui.SameLine()
		if imgui.Button(u8"Пустышка", imgui.ImVec2(130, 26)) then
	       --code
        end			  
		  
		  imgui.End()		   
	    end 
		
		if okno.v then 
		imgui.ShowCursor = false
		local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 1.4, sh / 1.1), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 110), imgui.Cond.FirstUseEver)

        imgui.Begin('BARS e ', okno, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar )		   
            imgui.SetCursorPos(imgui.ImVec2(45, 5))
			imgui.Text('CarCheck | Ten-Code')
			imgui.Separator()
			imgui.Text(u8'500-1 - выехал из части в LSPD')
	        imgui.Text(u8'500-2 - выехал из части в SFPD')
			imgui.Text(u8'500-3 - выехал из части в LVPD')
			imgui.Text(u8'500-4 - выехал из части в FBI')
			imgui.Text(u8'500-5 - выехал из части в SFa')			
            		  
		  imgui.End()		   
	    end 
		
		if window.v then 
		imgui.ShowCursor = false
		local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 1.1, sh / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(145, 200), imgui.Cond.FirstUseEver)

        imgui.Begin('BAR ', window.v, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar )		   
            imgui.SetCursorPos(imgui.ImVec2(15, 5))
			imgui.Text('CarCheck | InTruck')
     imgui.BeginChild("BARWin", imgui.ImVec2(125, 165), true)
		
		if imgui.Button(u8"Взять фуру", imgui.ImVec2(110, 25)) then
           sampSendChat("/r "..pInfo.Tag.." взял грузовик снабжения!")
		   sampSendChat('/carm')
		end            
		if imgui.Button(u8"Поставить фуру", imgui.ImVec2(110, 25)) then
           sampSendChat("/r "..pInfo.Tag.." Закончил поставки, поставил грузовик на место!")
        end		
		if imgui.Button(u8"SOS", imgui.ImVec2(110, 25)) then
           sampSendChat(string.format('/r %s: Запрашиваю SOS в сектор - [%s], нападение на конвой! ',pInfo.Tag, kvadrat()))
        end	 
		if imgui.Button(u8"Мониторинг", imgui.ImVec2(110, 25)) then
           sampSendChat("/r "..pInfo.Tag.." Запрашиваю мониторинг!")
		end	
		if imgui.Button(u8"Подъезд к части", imgui.ImVec2(110, 26)) then
           sampSendChat(string.format('/r %s: Колонна подъезжает к СКПП! - Открывайте. ',pInfo.Tag))
        end	            		  
     
	 imgui.EndChild()  
		  
       imgui.End()		   
	    
		
		
		
		end 		
		
		imgui.End()
    end
end

lua_thread.create(function()
    while true do
        wait(0)
            if (skinId==191 or skinId==287) then
			if isCharDead(PLAYER_PED) then
                wait(5000)
                sampSendChat("LELELE ")
            end
        end
	end
end)

--            imgui.TextQuestion(u8" Press me ", "/meny -- table settings")
function imgui.TextQuestion(label, description)
    imgui.TextDisabled(label)

    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
            imgui.PushTextWrapPos(600)
                imgui.TextUnformatted(description)
            imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function imgui.Hint(text, delay, action)
    if imgui.IsItemHovered() then
        if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
        local alpha = (os.clock() - go_hint) * 5
        if os.clock() >= go_hint then
            imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
            imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
                imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(0.11, 0.11, 0.11, 1.00))
                    imgui.BeginTooltip()
                    imgui.PushTextWrapPos(450)
                    imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ButtonHovered], u8' Подсказка:')
                    imgui.TextUnformatted(text)
                    if action ~= nil then
                        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.TextDisabled], '\n '..action)
                    end
                    if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
                    imgui.PopTextWrapPos()
                    imgui.EndTooltip()
                imgui.PopStyleColor()
            imgui.PopStyleVar(2)
        end
    end
end

function search(arg)
    if not on and (not arg or not arg:find('^.+$')) then sampShowDialog(1000, "{9370DB}Слежка - [Ошибка]{9370DB}", " \n ID жертвы забыл)", "{9370DB}Close", "", 0)  return end
    if arg:find('^%d$') or arg:find('%d+') then
        if sampIsPlayerConnected(arg) then
            arg = sampGetPlayerNickname(arg)
        else
            sampShowDialog(1000, "{9370DB}Слежка - [Ошибка]{9370DB}", " \n Такого игрока нету на сервере ", "{9370DB}Печально", "", 0) 
            return
        end
    end

    on = not on
    if on then
		sampAddChatMessage('{9370DB}Слежка - [ ;) ]{FFFFFF}: Имя человека:{9370DB}'..arg..'{FFFFFF}, установил метку. Следуй по ней.', -1)
		lua_thread.create(function()

            while on do
                wait(0)
                local id = sampGetPlayerIdByNickname(arg)
                if id ~= nil and id ~= -1 and id ~= false then
                    local res, handle = sampGetCharHandleBySampPlayerId(id)
                    if res then

                        

                        local screen_text = 'Metka'
                        x, y, z = getCharCoordinates(handle)
                        local mX, mY, mZ = getCharCoordinates(playerPed)
                        local x1, y1 = convert3DCoordsToScreen(x,y,z)
                        local x2, y2 = convert3DCoordsToScreen(mX, mY, mZ)
                        --sampDestroy3dText(dtext)
                        if not dtext then
                            dtext = sampCreate3dText('Цель',0xFFD00000,0,0,0.4,9999,true,id,-1)
                        end
                        if isPointOnScreen(x,y,z,0) then
                            renderDrawLine(x2, y2, x1, y1, 2.0, 0xFFD00000)
                            renderDrawBox(x1-2, y1-2, 8, 8, 0xAA00CC00)
                        else
                            screen_text = 'Ne tuda '
                        end
                        printStringNow(conv(screen_text),1)
                        draw_suka = true
                    else
                        if marker or checkpoint then
                            deleteCheckpoint(marker)
                            removeBlip(checkpoint)
                        end
                        sampDestroy3dText(dtext)
                        dtext = nil
                        draw_suka = false
                    end
                end
            end
    
        end)
    else
        lua_thread.create(function()
            draw_suka = false
            wait(10)
            removeUser3dMarker(mark)
            sampDestroy3dText(dtext)
            dtext = nil
            --deleteCheckpoint(marker)
            --removeBlip(checkpoint)
            sampAddChatMessage('{9370DB}Слежка - [ ;) ]{FFFFFF}: нужна будет помощь, обращайся!', -1)            
		end)
    end
end

function cmd_update(arg)
    sampShowDialog(1000, "{9370DB}[sPecLuA]{9370DB}", " \n {9370DB}/help{FFFFFF} - вызов меню помощи. \n {9370DB} /sp{FFFFFF} - слежка за игроком. \n {9370DB} /cl{FFFFFF} - ввод команды /clist 7. \n {9370DB} /kbm{FFFFFF} - созвать рядовых на КМБ. \n {9370DB} /kmbh{FFFFFF} - вопросы для КМБ \n {9370DB} /l{FFFFFF} - ввод команды /lock \n {9370DB} /ps{FFFFFF} - доклад о разгрузке с поставок | Фракция | Тонаж |, /ps SFa 199 \n автотег еще не сделан. Он есть. Но его нету. Кароче пока в процессе тег в рациюю IF", "{9370DB}Close", "", 0)
end

function cmd_undate(arg)
sampSendChat("/lock")
end

function cmd_kmb(arg)
sampSendChat("/r  Внимание! Рядовые отслужившие 2 дня в части, прошу подойти к ГС для сдачи КМБ!")
end	

function clist(arg)
sampSendChat('/clist 7')
end

function sos(arg)
sampSendChat("/r "..pInfo.Tag.." На колонну напали, требуется поддержка в сектор" ..kvadrat())
end

function pf(arg)
sampSendChat(" "..pInfo.Tag.." взял грузовик снабжения!")
end

function ps(arg)
    var1, var2 = string.match(arg, "(.+) (.+)")
    if var1 == nil or var1 == "" then    
		sampAddChatMessage("{FFFFFF} Ты ввел не все аргументы.")
    else
        sampSendChat("/r "..pInfo.Tag.." Доставил боеприпасы на склад - "..var1.." состояние склада: "..var2.."т. Едем в часть. ")
    end 
end

-- КВАДРАТЫ 

function kvadrat()
    local KV = {
        [1] = "А",
        [2] = "Б",
        [3] = "В",
        [4] = "Г",
        [5] = "Д",
        [6] = "Ж",
        [7] = "З",
        [8] = "И",
        [9] = "К",
        [10] = "Л",
        [11] = "М",
        [12] = "Н",
        [13] = "О",
        [14] = "П",
        [15] = "Р",
        [16] = "С",
        [17] = "Т",
        [18] = "У",
        [19] = "Ф",
        [20] = "Х",
        [21] = "Ц",
        [22] = "Ч",
        [23] = "Ш",
        [24] = "Я",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
    local KVX = (Y.."-"..X)
    return KVX
end

function getColorForSeconds(sec)
	if sec > 0 and sec <= 50 then
		return imgui.ImVec4(1, 1, 0, 1)
	elseif sec > 50 and sec <= 100 then
		return imgui.ImVec4(1, 159/255, 32/255, 1)
	elseif sec > 100 and sec <= 200 then
		return imgui.ImVec4(1, 93/255, 24/255, 1)
	elseif sec > 200 and sec <= 300 then
		return imgui.ImVec4(1, 43/255, 43/255, 1)
	elseif sec > 300 then
		return imgui.ImVec4(1, 0, 0, 1)
	end
end

function imgui.TextColoredRGB(text, render_text)
    local max_float = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end

            local length = imgui.CalcTextSize(w)
            if render_text == 2 then
                imgui.NewLine()
                imgui.SameLine(max_float / 2 - ( length.x / 2 ))
            elseif render_text == 3 then
                imgui.NewLine()
                imgui.SameLine(max_float - length.x - 5 )
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], text[i])
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(w) end


        end
    end

    render_text(text)
end

function getColor(ID)
	PlayerColor = sampGetPlayerColor(ID)
	a, r, g, b = explode_argb(PlayerColor)
	return r/255, g/255, b/255, 1
end
function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end

function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
end


function setMarker(type, x, y, z, radius, color)
    deleteCheckpoint(marker)
    removeBlip(checkpoint)
    checkpoint = addBlipForCoord(x, y, z)
    marker = createCheckpoint(type, x, y, z, 1, 1, 1, radius)
    changeBlipColour(checkpoint, color)
--[[    lua_thread.create(function()
    repeat
        wait(0)
        local x1, y1, z1 = getCharCoordinates(PLAYER_PED)
        until getDistanceBetweenCoords3d(x, y, z, x1, y1, z1) < radius or not doesBlipExist(checkpoint)
        deleteCheckpoint(marker)
        removeBlip(checkpoint)
        addOneOffSound(0, 0, 0, 1149)
    end)]]
end

function onScriptTerminate(s, quit)
    if s == thisScript() then
        if marker or checkpoint or mark or dtext then
            removeUser3dMarker(mark)
            deleteCheckpoint(marker)
            removeBlip(checkpoint)
            sampDestroy3dText(dtext)
        end
    end
end

function conv(text)
    local convtbl = {[230]=155,[231]=159,[247]=164,[234]=107,[250]=144,[251]=168,[254]=171,[253]=170,[255]=172,[224]=97,[240]=112,[241]=99,[226]=162,[228]=154,[225]=151,[227]=153,[248]=165,[243]=121,[184]=101,[235]=158,[238]=111,[245]=120,[233]=157,[242]=166,[239]=163,[244]=63,[237]=174,[229]=101,[246]=36,[236]=175,[232]=156,[249]=161,[252]=169,[215]=141,[202]=75,[204]=77,[220]=146,[221]=147,[222]=148,[192]=65,[193]=128,[209]=67,[194]=139,[195]=130,[197]=69,[206]=79,[213]=88,[168]=69,[223]=149,[207]=140,[203]=135,[201]=133,[199]=136,[196]=131,[208]=80,[200]=133,[198]=132,[210]=143,[211]=89,[216]=142,[212]=129,[214]=137,[205]=72,[217]=138,[218]=167,[219]=145}
    local result = {}
    for i = 1, #text do
        local c = text:byte(i)
        result[i] = string.char(convtbl[c] or c)
    end
    return table.concat(result)
end

local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}

-- imgui.WindowFlags.NoResize -- убрать ресайз полоску 
-- imgui.WindowFlags.NoCollapse -- не разрешать сворачивать окно
-- imgui.WindowFlags.NoMove -- нельзя двигать имгуи окно
-- imgui.WindowFlags.NoScrollbar -- убирает скролл
-- imgui.WindowFlags.NoTitleBar -- убирает тайтл у окон

-- imgui.SelectableFlags.AllowDoubleClick -- разрешение дабл клика на пункт

-- несколько флагов прописываются через "+"

--        imgui.SetCursorPos(imgui.ImVec2(40, 50)) полезная фича чтобы перемещать любое что находится в имгуи окне

--[[function cf(arg) НУЖНАЯ ФИЧА ЭТО ИНИ КФГ ФАЙЛЫ НА КОТОРОМ ДЕРЖИТСЯ АВТОКЛИСТ
	mainIni.healt = {} 
	mainIni.healt.body = arg
	
    if inicfg.save(mainIni, directIni) then
       sampAddChatMessage("Успешно", -1)
    end
end ]]