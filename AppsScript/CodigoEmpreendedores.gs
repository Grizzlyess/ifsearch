//Empreendedores
function doPost(e) {
  var lock = LockService.getScriptLock();
  
  try {
    lock.waitLock(10000); 
  } catch (e) {
    return ContentService.createTextOutput(JSON.stringify({"status": "erro", "mensagem": "Servidor ocupado"}))
        .setMimeType(ContentService.MimeType.JSON);
  }

  try {
    var data = JSON.parse(e.postData.contents);
    var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
    
    // A ordem aqui dita como entra na planilha (da coluna A até à AD)
    sheet.appendRow([
      data.id,
      data.dataHora || "",
      data.email,
      data.nomeNegocio,
      data.genero,
      data.categoria,
      data.investimento,
      data.faturamento,
      data.equipeTotal,
      data.equipeMulheres,
      data.equipeHomens,
      data.gastosEquipe,
      data.familiasBeneficiadas,
      data.localInsumos,
      data.unidAgua || "",
      data.unidRefrigerante || "",
      data.unidCerveja || "",
      data.unidSuco || "",
      data.unidEnergetico || "",
      data.unidDrinks || "",
      data.avaliacaoOrganizacao,
      data.apoioPrefeitura,
      data.dificuldades,
      data.quaisDificuldades || "",
      data.divulgouNegocio,
      data.parcerias,
      data.salaEmpreendedor,
      data.proximasEdicoes,
      data.outrosEventos,
      data.sugestoes || ""
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