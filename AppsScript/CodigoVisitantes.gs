//Visitantes
function doPost(e) {
  var lock = LockService.getScriptLock();
  
  try {
    lock.waitLock(10000); 
  } catch (e) {
    return ContentService.createTextOutput(JSON.stringify({"status": "erro", "mensagem": "Servidor ocupado, tentando novamente depois"}))
        .setMimeType(ContentService.MimeType.JSON);
  }

  try {
    var data = JSON.parse(e.postData.contents);
    var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
    
    sheet.appendRow([
      data.id,
      data.email,
      data.genero,
      data.estadoCivil,
      data.faixaEtaria,
      data.escolaridade,
      data.renda,
      data.cidade,
      data.hospedado,
      data.tipoHospedagem || "",
      data.localHospedagem || "",
      data.qtdPessoasHospedadas || "",
      data.nomeHotel || "",
      data.diasVisita,
      data.gastoPorDia,
      data.comoConheceu,
      data.aspectosGostou,
      data.pretendeRetornar,
      data.recomendaria,
      data.iniciativaGarrafas,
      data.sugestoes || "",
      data.dataHora || ""
    ]);
    
    return ContentService.createTextOutput(JSON.stringify({"status": "sucesso"}))
        .setMimeType(ContentService.MimeType.JSON);
        
  } catch (error) {
    return ContentService.createTextOutput(JSON.stringify({"status": "erro", "mensagem": error.toString()}))
        .setMimeType(ContentService.MimeType.JSON);
  } finally {
    lock.releaseLock();
  }
}