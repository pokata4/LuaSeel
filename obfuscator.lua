local itemName = 'voce finalizou a task'
onTextMessage(function(mode, text)
if mode == 35 then
textoTratado = text:lower()
    if string.find(textoTratado,itemName) then
      CaveBot.gotoLabel('task')
end
end
end)
