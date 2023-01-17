local _, ns = ...
local oUF = ns.oUF or oUF

local StringFormat = LibStub('LibStringFormat-1.0')

local function Update(self, event, args)
    local element = self.Widget
    local widgetSetId = UnitWidgetSet(self.unit)

    if not widgetSetId then
        element:Hide()
        element.text:SetText('')
        return
    else
        element:Show()
    end

    local widgets = C_UIWidgetManager.GetAllWidgetsBySetID(widgetSetId)
    local widgetID = widgets[1].widgetID

    local widgetType = widgets[1].widgetType
    local widgetTypeInfo = UIWidgetManager:GetWidgetTypeInfo(widgetType)

    local widgetInfo = widgetTypeInfo.visInfoDataFunction(widgetID);

    if not widgetInfo then
        element:Hide()
        element.text:SetText('')
        return
    end

    --local widgetsOnlyMode = UnitNameplateShowsWidgetsOnly(self.unit)

    local min, max, current = widgetInfo.barMin, widgetInfo.barMax, widgetInfo.barValue
    local text = widgetInfo.text

    if widgetInfo.hasTimer then
        text = ('%s %s'):format(text, StringFormat:ToTime(current))
    end

    element:SetMinMaxValues(min, max)
    element:SetValue(current)
    element.text:SetText(text)
end

local function Path(self, ...)
    return (self.Widget.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
    local element = self.Widget
    if element then
        element.__owner = self
        element.ForceUpdate = ForceUpdate

        return true
    end
end

local function Disable(self)
    local element = self.Widget
    if element then
        element:Hide()
    end
end

oUF:AddElement('Widget', Path, Enable, Disable)