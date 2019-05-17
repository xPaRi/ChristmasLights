-- Obecne menu pro pouziti s OLED displejem
--
-- Struktura menu se definuje jako pole
-- -----------------------------------------

-- Inicializace displeje
function InitDisplay()
    gdisplay.attach(gdisplay.SSD1306_128_64, gdisplay.LANDSCAPE_FLIP, true, 0x3C)
    gdisplay.on()
    gdisplay.clear()
    gdisplay.settransp(false) -- co je za textem bude prepsano

    gdisplay.setfont(gdisplay.FONT_DEFAULT)    
end

-- Obsluha presunuti na vybranou pozici
-- Manipuluje se zde s pozici stranky menu atd...
-- <pos> - pozice aktualne vybraneho radku
function Move(pos)
    -- Aby pos nevypadl z rámce
    if (pos < 1) then
        pos = 1;
    elseif (pos > MenuLength) then
        pos = MenuLength;
    end
    --

    -- Optimalizace, aby to na prvni a posledni polozce neblikalo
    if pos == LastPos then
        return
    end
    --

    if (pos < PageTop) then
        PageTop = pos;
        PageEnd = PageTop + PageHeight - 1;
        PrintMenu(false, pos);
    elseif (pos > PageEnd) then
        PageTop = pos - PageHeight + 1;
        PageEnd = PageTop + PageHeight - 1;
        PrintMenu(true, pos);
    else
        PrintRow(CursorPos, false);
        PrintRow(pos, true);
    end

    CursorPos = pos;
    LastPos = pos;
end

-- Zobrazi jeden radek menu
-- <row>        - index zobrazovaneho radku
-- <isSelected> - indikuje zvyraznene zobrazeni (vybrana polozka menu)
function PrintRow(row, isSelected)
    -- Barvy podle 'isEmpty'
    local colorText, colorBack = gdisplay.WHITE, gdisplay.BLACK

    if (isSelected) then
        colorText, colorBack = gdisplay.BLACK, gdisplay.WHITE
    end
    --

    local absY = POS_Y + ROW_HEIGHT * (row - PageTop)

    -- Ramecek kolem textu a text
    gdisplay.rect( {TEXT_X, absY-1}, TEXT_WIDTH, BORDER_HEIGHT, colorBack, colorBack)    
    gdisplay.write({TEXT_X, absY  }, MenuList[row].Text, colorText, colorBack)
    
    -- Ramecek kolem hodnoty a hodnota
    gdisplay.rect({VALUE_X,  absY-1}, VALUE_WIDTH, BORDER_HEIGHT, gdisplay.BLACK, gdisplay.BLACK)    
    gdisplay.write({VALUE_X, absY  }, MenuList[row].Value)
end

-- Zobrazi menu
-- <reverse> - zacne zobrazovani odspodu
-- <pos>     - na teto pozicci bude zobrazen ukazatel (vybrana polozka menu)
function PrintMenu(reverse, pos)
    local from, to, step = PageTop, PageEnd, 1

    if reverse then
        from, to, step = PageEnd, PageTop, -1
    end

    for row = from, to, step do
        PrintRow(row, row==pos);
    end
end

-- Vraci delku pole
-- <array>  - zkoumane pole
function ArrayLength(array)
    local result = 0

    for k in pairs(array) do 
        result = result + 1 
    end

    return result
end

-- Vraci index hodnoty v poli nebo nil
-- <array> - zkoumane pole
-- <value> - hledana hodnota
function GetIndexOfValue(array, value)
    for k, item in ipairs(array) do 
        if (item==value) then
            return k
        end
    end

    return nil
end

function GetPrevValue(array, value)
    local i = GetIndexOfValue(array, value)

    if (i == nil or i <= 1) then
        return array[1]
    else
        return array[i-1]
    end
end

function GetNextValue(array, value)
    local i = GetIndexOfValue(array, value)
    local aLength = ArrayLength(array)

    if (i == nil or i >= aLength) then
        return array[aLength]
    else
        return array[i+1]
    end
end

function SetValue(menuItem, dir)
    if (dir < 0) then 
        menuItem.Value = GetPrevValue(menuItem.Values, menuItem.Value)
    elseif (dir > 0) then
        menuItem.Value = GetNextValue(menuItem.Values, menuItem.Value)
    end

    PrintRow(CursorPos, true)
end

-- Obsluha rotacniho enkoderu s vazbou na menu
-- <dir>        - smer otaceni
-- <counter>    - pozice ankoderu
-- <button>     - stisk tlacitka
function callback(dir, counter, button)
    if button==1 then
        IsSetValue = not IsSetValue 
    end

    if IsSetValue then
        SetValue(MenuList[CursorPos], dir)
    else
        Move(CursorPos + dir);
    end
end


MenuList = 
{ 
    { Text="1.Modul",  Value="A1",         Type=1, Values={"--", "A1", "B1", "C1", "D1", "E1", "F1"}},
    { Text="2.Speed",  Value= 60,          Type=1, Values={10,20,30,40,50,60,70,80,90,100}},
    { Text="3.Random", Value= 10,          Type=1, Values={1,2,3,4,5,6}},
    { Text="4.Red",    Value=100,          Type=1, Values={1,2,3,4,5,6}},
    { Text="5.Green",  Value=  2,          Type=1, Values={1,2,3,4,5,6}},
    { Text="6.Black",  Value= 20,          Type=1, Values={1,2,3,4,5,6}},
    { Text="7.White",  Value=200,          Type=1, Values={1,2,3,4,5,6}},
    { Text="8.Yellow", Value=  3,          Type=1, Values={1,2,3,4,5,6}},
    { Text="9.Santin", Value= 30,          Type=1, Values={1,2,3,4,5,6}}
}

POS_Y = 0;

TEXT_X = 1;
TEXT_WIDTH = 71

VALUE_X = 75
VALUE_WIDTH = 50

ROW_HEIGHT = 12;
BORDER_HEIGHT = 13

CursorPos = 1
LastPos = nil
MenuLength = ArrayLength(MenuList);
PageTop = 1;
PageHeight = 4;
PageEnd = PageTop + PageHeight - 1;

IsSetValue = false

-- Zahajujeme
InitDisplay()
PrintMenu();
PrintRow(CursorPos, true);

enc = encoder.attach(pio.GPIO34, pio.GPIO35, pio.GPIO32, callback)
--

