-- Obecne menu pro pouziti s OLED displejem
--
-- Struktura menu se definuje jako pole
-- -----------------------------------------

function InitDisplay()
    -- Inicializace
    gdisplay.attach(gdisplay.SSD1306_128_64, gdisplay.LANDSCAPE_FLIP, true, 0x3C)
	gdisplay.on()
    gdisplay.clear()
    gdisplay.settransp(false) -- co je za textem bude prepsano

    gdisplay.setfont(gdisplay.FONT_DEFAULT)    
end

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

function PrintRow(row, isEmpty)
    -- Barvy podle 'isEmpty'
    local colorText, colorBack = gdisplay.WHITE, gdisplay.BLACK

    if (isEmpty) then
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

function PrintMenu(reverse, pos)
    local from, to, step = PageTop, PageEnd, 1

    if reverse then
        from, to, step = PageEnd, PageTop, -1
    end

    for row = from, to, step do
        PrintRow(row, row==pos);
    end
end

-- Obsluha rotacniho enkoderu s vazbou na menu
function callback(dir, counter, button)
    Move(CursorPos + dir);
end

-- Vraci delku pole
function ArrayLength(array)
    local result = 0

    for k in pairs(array) do 
        result = result + 1 
    end

    return result
end

MenuList = 
{ 
    { Text="1.Modul",  Value="Nahodna",    Type=1, Values={1,2,3,4,5,6}},
    { Text="2.Speed",  Value=  1,          Type=1, Values={1,2,3,4,5,6}},
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


-- Zahajujeme
InitDisplay()
PrintMenu();
PrintRow(CursorPos, true);

enc = encoder.attach(pio.GPIO34, pio.GPIO35, pio.GPIO32, callback)
--

