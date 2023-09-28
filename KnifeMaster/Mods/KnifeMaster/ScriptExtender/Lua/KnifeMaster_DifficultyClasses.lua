Ext.Utils.Print("KnifeMaster_DifficultyClasses.lua loaded...")

local DCTable = {

    [0] = "4dfcb0ff-e02a-4efd-b132-77dfd956055e",
    [1] = "9da4e959-4db9-4669-9da1-153cd250d5fc",
    [2] = "2728289e-841d-4273-a29a-f24ae9f8c4fb",
    [3] = "d262a38e-2d86-4342-84fc-b28271f23282",
    [4] = "365fe522-c9d4-470d-ab7e-c64e60eaef4d",
    [5] = "8d398021-34e0-40b9-b7b2-0445f38a4c0b",
    [6] = "9d1f2171-fef1-4c03-9e83-523485174c46",
    [7] = "b9cea18d-f40a-444d-a692-76582a69130c",
    [8] = "f149a3ce-7625-4b9c-97b5-cfefaf791b64",
    [9] = "34bf414f-9f89-4b51-bdfe-158ef1eb90b1",
    [10] = "fa621d38-6f83-4e42-a55c-6aa651a75d46",
    [11] = "f4c9d750-49a9-4b7d-a27c-92b801b7d808",
    [12] = "5e7ff0e9-6c80-459c-a636-3a3e8417a61a",
    [13] = "9b60e4f9-ad8d-43fa-bf15-7c13a47b2b30",
    [14] = "598ee99a-f9e9-4a07-a98a-d1379131daa1",
    [15] = "bddbb9b8-a242-4c3e-a2eb-3fd274c0c539",
    [16] = "c44bfd7d-84de-4568-9c57-a059b8df5435",
    [17] = "6bcc9696-22b9-45a7-a1b4-257a0c76526e",
    [18] = "8986db4d-09af-46ee-9781-ac88ec10fa0e",
    [19] = "1afda678-eb97-4b25-9548-0908e84b5475",
    [20] = "6298329e-255c-4826-9209-e911873b64e7",
    [21] = "f3aa825b-785e-4f4a-90af-565c7e943609",
    [22] = "0850ab61-c07d-4958-9a13-b34c9920951e",
    [23] = "adbf5e98-0866-4140-aa0e-46f7b706e5c8",
    [24] = "753ed8df-b5dc-4584-b9fa-de18c4c956b2",
    ['vinticinco'] = "60916b01-ba4c-418e-9f30-19a669704b4d",
    [26] = "68e69a5f-1f79-4ead-9352-1c5d7545aa31",
    [27] = "583c03f3-f1ef-498e-bd7a-f8382795d4e9",
    [28] = "d1675e97-fa98-4b1e-85f4-e94e0ff21013",
    [29] = "52060dcd-927a-4178-a8e6-213b95b1d929",
    [30] = "7bf230a0-b68a-4c79-a785-79b498d6c36b"

}

local function KM_getDCString(DCNum) 
    if (DCNum == 25) then
        DCNum = 'vinticinco'
    end
    if DCTable[DCNum] ~= nil then
        return DCTable[DCNum]
    else
        Ext.Utils.PrintWarning("No match for the requested DC")
        return DCTable[10]
    end
end

return {

    getDCString = KM_getDCString;
}
