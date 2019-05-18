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

-- Mody zobrazeni menu a hodnoty
ITEM_MODE_PRINTED = 1
ITEM_MODE_SELECTED = 2
ITEM_MODE_EDITED = 3
--

-- Barvy pro zobrazeni menu
TEXT_SET = 
{
    [ITEM_MODE_PRINTED] =  {fg=gdisplay.WHITE, bg=gdisplay.BLACK, box=gdisplay.BLACK, fill=gdisplay.BLACK},
    [ITEM_MODE_SELECTED] = {fg=gdisplay.BLACK, bg=gdisplay.WHITE, box=gdisplay.WHITE, fill=gdisplay.WHITE},
    [ITEM_MODE_EDITED] =   {fg=gdisplay.BLACK, bg=gdisplay.WHITE, box=gdisplay.WHITE, fill=gdisplay.WHITE}
}

VALUE_SET =
{
    [ITEM_MODE_PRINTED] =  {fg=gdisplay.WHITE, bg=gdisplay.BLACK, box=gdisplay.BLACK, fill=gdisplay.BLACK},
    [ITEM_MODE_SELECTED] = {fg=gdisplay.BLACK, bg=gdisplay.WHITE, box=gdisplay.WHITE, fill=gdisplay.WHITE},
    [ITEM_MODE_EDITED] =   {fg=gdisplay.WHITE, bg=gdisplay.BLACK, box=gdisplay.WHITE, fill=gdisplay.BLACK}
}
--

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
        PrintRow(CursorPos, ITEM_MODE_PRINTED);
        PrintRow(pos, ITEM_MODE_SELECTED);
    end

    CursorPos = pos;
    LastPos = pos;
end

function PrintValue(row, itemMode)
    local modeSet = VALUE_SET[itemMode]
    local absY = POS_Y + ROW_HEIGHT * (row - PageTop)

    -- Ramecek kolem hodnoty a hodnota
    gdisplay.rect({VALUE_X, absY-1}, VALUE_WIDTH, BORDER_HEIGHT, modeSet.box, modeSet.fill)
    gdisplay.write({VALUE_X + 1, absY}, MenuList[row].Values[MenuList[row].SelIndex], modeSet.fg, modeSet.bg)
    --
end

-- Zobrazi jeden radek menu
-- <row>        - index zobrazovaneho radku
-- <itemMode>   - indikuje zpusob zobrazeni (ITEM_MODE_*)
function PrintRow(row, itemMode)
    local modeSet = TEXT_SET[itemMode]
    local absY = POS_Y + ROW_HEIGHT * (row - PageTop)

    -- Ramecek kolem textu a text
    gdisplay.rect( {TEXT_X, absY-1}, TEXT_WIDTH, BORDER_HEIGHT, modeSet.box, modeSet.fill)    
    gdisplay.write({TEXT_X + 1, absY}, MenuList[row].Text, modeSet.fg, modeSet.bg)
    --

    PrintValue(row, itemMode)
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
        if (row==pos) then
            PrintRow(row, ITEM_MODE_SELECTED);
        else
            PrintRow(row, ITEM_MODE_PRINTED);
        end
    end
end

-- Vraci delku pole
-- <array>  - zkoumane pole
function ArrayLength(array)
    local result = 0

    for i in pairs(array) do 
        result = i
    end

    return result
end

function SetValue(menuItem, dir)
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

    PrintValue(CursorPos, ITEM_MODE_EDITED)
end

-- Obsluha rotacniho enkoderu s vazbou na menu
-- <dir>        - smer otaceni
-- <counter>    - pozice ankoderu
-- <button>     - stisk tlacitka
function callback(dir, counter, button)
    
    if (button==1 and IsSetValue==true) then
        IsSetValue = false
        PrintValue(CursorPos, ITEM_MODE_SELECTED)
    elseif (button==1 and IsSetValue==false) then
        IsSetValue = true 
        PrintValue(CursorPos, ITEM_MODE_EDITED)
    elseif (IsSetValue) then
        SetValue(MenuList[CursorPos], dir)
    elseif (not IsSetValue and dir ~=0) then
        Move(CursorPos + dir);
    end
end

-- Nastavi atribut ValuesCount
-- <menuList> - zkoumane pole
function SetValuesCount(menuList)
    for k, item in ipairs(menuList) do 
        if (item.Text ~= nil) then
            for i in pairs(item.Values) do 
                item.ValuesCount = i
            end
        end
    end
end

MenuList = 
{ 
    { Text="1.Modul",  SelIndex=1, Values={"--", "A1", "B1", "C1", "D1", "E1", "F1"}},
    { Text="2.Speed",  SelIndex=1, Values={10,20,30,40,50,60,70,80,90,100}},
    { Text="3.Random", SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="4.Red",    SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="5.Green",  SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="6.Black",  SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="7.White",  SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="8.Yellow", SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="9.Santin", SelIndex=1, Values={1,2,3,4,5,6}}
}

SetValuesCount(MenuList)

POS_Y = 0;

TEXT_X = 1;
TEXT_WIDTH = 72

VALUE_X = 75
VALUE_WIDTH = 50

ROW_HEIGHT = 12;
BORDER_HEIGHT = 13

CursorPos = 1
LastPos = CursorPos
MenuLength = ArrayLength(MenuList);
PageTop = 1;
PageHeight = 4;
PageEnd = PageTop + PageHeight - 1;

IsSetValue = false

-- Zahajujeme
InitDisplay()
PrintMenu();
PrintRow(CursorPos, ITEM_MODE_SELECTED);

enc = encoder.attach(pio.GPIO34, pio.GPIO35, pio.GPIO32, callback)
--

