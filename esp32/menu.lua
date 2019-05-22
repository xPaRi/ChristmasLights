-- Obecne menu pro pouziti s OLED displejem
--
-- Struktura menu se definuje jako pole
-- -----------------------------------------

m = 
{
    -- Mody zobrazeni menu a hodnoty
    ITEM_MODE_PRINTED = 1,
    ITEM_MODE_SELECTED = 2,
    ITEM_MODE_EDITED = 3,
    --

    -- Barvy pro zobrazeni menu
    TEXT_SET = 
    {
        [1] =  {fg=gdisplay.WHITE, bg=gdisplay.BLACK, box=gdisplay.BLACK, fill=gdisplay.BLACK}, --ITEM_MODE_PRINTED
        [2] = {fg=gdisplay.BLACK, bg=gdisplay.WHITE, box=gdisplay.WHITE, fill=gdisplay.WHITE},  --ITEM_MODE_SELECTED
        [3] =   {fg=gdisplay.BLACK, bg=gdisplay.WHITE, box=gdisplay.WHITE, fill=gdisplay.WHITE} --ITEM_MODE_EDITED
    },

    VALUE_SET =
    {
        [1] =  {fg=gdisplay.WHITE, bg=gdisplay.BLACK, box=gdisplay.BLACK, fill=gdisplay.BLACK}, --ITEM_MODE_PRINTED
        [2] = {fg=gdisplay.BLACK, bg=gdisplay.WHITE, box=gdisplay.WHITE, fill=gdisplay.WHITE},  --ITEM_MODE_SELECTED
        [3] =   {fg=gdisplay.WHITE, bg=gdisplay.BLACK, box=gdisplay.WHITE, fill=gdisplay.BLACK} --ITEM_MODE_EDITED
    },
    --

    -- Pozice a rozmery menu
    POS_Y = 0,

    TEXT_X = 1,
    TEXT_WIDTH = 72,
    
    VALUE_X = 75,
    VALUE_WIDTH = 50,
    
    ROW_HEIGHT = 12,
    BORDER_HEIGHT = 13,

    PAGE_HEIGHT = 4,
    --

    -- Stavove promenne
    MenuList = {},
    CursorPos = 1,
    LastPos = CursorPos,
    MenuLength = 0,
    PageTop = 1,
    
    PageEnd = function() return m.PageTop + m.PAGE_HEIGHT - 1 end,
    
    IsSetValue = false, -- indikuje mod nastavovani hodnoty
    --

    -- Inicializace displeje
    InitDisplay = function ()
        gdisplay.attach(gdisplay.SSD1306_128_64, gdisplay.LANDSCAPE_FLIP, true, 0x3C)
        gdisplay.on()
        gdisplay.clear()
        gdisplay.settransp(false) -- co je za textem bude prepsano

        gdisplay.setfont(gdisplay.FONT_DEFAULT)    
    end
   
}

-- Obsluha presunuti na vybranou pozici
-- Manipuluje se zde s pozici stranky menu atd...
-- <pos> - pozice aktualne vybraneho radku
m.Move = function (pos)
    -- Aby pos nevypadl z rámce
    if (pos < 1) then
        pos = 1;
    elseif (pos > m.MenuLength) then
        pos = m.MenuLength;
    end
    --

    -- Optimalizace, aby to na prvni a posledni polozce neblikalo
    if pos == m.LastPos then
        return
    end
    --

    if (pos < m.PageTop) then
        m.PageTop = pos;
        m.PrintMenu(false, pos);
    elseif (pos > m.PageEnd()) then
        m.PageTop = pos - m.PAGE_HEIGHT + 1;
        m.PrintMenu(true, pos);
    else
        m.PrintRow(m.CursorPos, m.ITEM_MODE_PRINTED);
        m.PrintRow(pos, m.ITEM_MODE_SELECTED);
    end

    m.CursorPos = pos;
    m.LastPos = pos;
end

-- Zobrazí hodnotu na uvedeny radek
m.PrintValue = function (row, itemMode)
    local modeSet = m.VALUE_SET[itemMode]
    local absY = m.POS_Y + m.ROW_HEIGHT * (row - m.PageTop)

    -- Ramecek kolem hodnoty a hodnota
    gdisplay.rect({m.VALUE_X, absY-1}, m.VALUE_WIDTH, m.BORDER_HEIGHT, modeSet.box, modeSet.fill)
    gdisplay.write({m.VALUE_X + 1, absY}, m.MenuList[row].Values[m.MenuList[row].SelIndex], modeSet.fg, modeSet.bg)
    --
end

-- Zobrazi jeden radek menu
-- <row>        - index zobrazovaneho radku
-- <itemMode>   - indikuje zpusob zobrazeni (ITEM_MODE_*)
m.PrintRow = function (row, itemMode)
    local modeSet = m.TEXT_SET[itemMode]
    local absY = m.POS_Y + m.ROW_HEIGHT * (row - m.PageTop)

    -- Ramecek kolem textu a text
    gdisplay.rect( {m.TEXT_X, absY-1}, m.TEXT_WIDTH, m.BORDER_HEIGHT, modeSet.box, modeSet.fill)    
    gdisplay.write({m.TEXT_X + 1, absY}, m.MenuList[row].Text, modeSet.fg, modeSet.bg)
    --

    m.PrintValue(row, itemMode)
end

-- Zobrazi menu
-- <reverse> - zacne zobrazovani odspodu
-- <pos>     - na teto pozicci bude zobrazen ukazatel (vybrana polozka menu)
m.PrintMenu = function (reverse, pos)
    local from, to, step = m.PageTop, m.PageEnd(), 1

    if reverse then
        from, to, step = m.PageEnd(), m.PageTop, -1
    end

    for row = from, to, step do
        if (row==pos) then
            m.PrintRow(row, m.ITEM_MODE_SELECTED);
        else
            m.PrintRow(row, m.ITEM_MODE_PRINTED);
        end
    end
end

-- Vraci delku pole
-- <array>      - zkoumane pole
m.ArrayLength = function (array)
    local result = 0

    for i in pairs(array) do 
        result = i
    end

    return result
end

-- Vraci aktualne vybranou hodnotu
m.GetCurrentValue = function()
    return m.MenuList[m.CursorPos].Values[m.MenuList[m.CursorPos].SelIndex]
end

-- Nastavi hodnotu
-- <menuItem>   - menu, ktere nastavujeme
-- <dir>        - smer otaceni encoderu (-1;1)
m.SetValue = function (menuItem, dir)
    local index = menuItem.SelIndex + dir

    if (index < 1) then 
        index = 1
    elseif (index > menuItem.ValuesCount) then 
        index = menuItem.ValuesCount; 
    end

    if (menuItem.SelIndex == index) then
        return
    end

    menuItem.SelIndex = index

    -- ValueChange (pokud menu obsahuje ValueChange, spustime jej pri kazde zmene hodnoty)
    if menuItem.ValueChange ~= nil then
        menuItem.ValueChange(menuItem.SelIndex, m.GetCurrentValue())
    end
    --

    m.PrintValue(m.CursorPos, m.ITEM_MODE_EDITED)
end

-- Obsluha rotacniho enkoderu s vazbou na menu
-- <dir>        - smer otaceni
-- <counter>    - pozice ankoderu
-- <button>     - stisk tlacitka
m.EncoderCallback = function (dir, counter, button)  
    if (button==1 and m.IsSetValue==true) then
        m.IsSetValue = false
        m.PrintValue(m.CursorPos, m.ITEM_MODE_SELECTED)
        -- ValueChanged (pokud menu obsahuje ValueChange, spustime jej pri kazde zmene hodnoty)
        menuItem = m.MenuList[m.CursorPos]

        if menuItem.ValueChanged ~= nil then
            menuItem.ValueChanged(menuItem.SelIndex, m.GetCurrentValue())
        end
        --
    elseif (button==1 and m.IsSetValue==false) then
        m.IsSetValue = true 
        m.PrintValue(m.CursorPos, m.ITEM_MODE_EDITED)
    elseif (m.IsSetValue) then
        m.SetValue(m.MenuList[m.CursorPos], dir)
    elseif (not m.IsSetValue and dir ~=0) then
        m.Move(m.CursorPos + dir);
    end
end

-- Nastavi atribut ValuesCount
-- <menuList> - zkoumane pole
m.SetValuesCount = function (menuList)
    for k, item in ipairs(menuList) do 
        if (item.Text ~= nil) then
            for i in pairs(item.Values) do 
                item.ValuesCount = i
            end
        end
    end
end

-- 
m.Refresh()
end

-- Inicializace celeho menu
-- <gpioA>      - A vyvod enkoderu
-- <gpioB>      - B vyvod enkoderu
-- <gpioSW>     - vyvod tlacitka enkoderu
-- <menuList>   - definice celého menu
m.Init = function(gpioA, gpioB, gpioSW, menuList)
    m.MenuList = menuList
    m.SetValuesCount(m.MenuList)
    m.MenuLength = m.ArrayLength(m.MenuList)
    
    -- Zahajujeme
    m.InitDisplay()
    m.PrintMenu();
    m.PrintRow(m.CursorPos, m.ITEM_MODE_SELECTED);
    
    enc = encoder.attach(gpioA, gpioB, gpioSW, m.EncoderCallback)
end

return m
