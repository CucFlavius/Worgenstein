-- WoW global definitions
-- Strictly used just for visual studio code for wow api
-- Not compiled by wow


-- Bit operations --
bit = {};
function bit.tobit() end
function bit.tohex() end
function bit.bnot() end
function bit.band() end
function bit.bor() end
function bit.bxor() end
function bit.lshift() end
function bit.rshift() end
function bit.arshift() end
function bit.rol() end
function bit.ror() end
function bit.bswap() end

-- unpack(tableName, i, j)
function unpack() end

-- assert
function assert(value) end

-- math
function abs(value) end
function fabs(value) end
function floor(value) end
function rad(value) end
function max(value) end
function min(value) end
function distance(value) end
sin = 0;
cos = 0;
tan = 0;
atan = 0;
abs = 0;
floor = 0;
sqrt = 0;

-- ui
UIParent = {}
function CreateFrame() end
function CreateFrame(name) end

-- table
function getn(value) end

-- string
function strlen(value) end
function strmatch(value, value2) end

-- player
function UnitPosition(unit) end

-- game frames
DEFAULT_CHAT_FRAME = {};
GeneralDockManager = {};
ChatFrameMenuButton = {};
ChatFrameChannelButton = {};
QuickJoinToastButton = {};
MainMenuBar = {};
PlayerFrame = {};
ObjectiveTrackerFrame = {};

-- other
LibStub = {};
ZWindowAPI = {};
function GetTime() end;