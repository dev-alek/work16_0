{&CommentStartNoClass}
method public void CRnewDocum
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function CRnewDocum return character
{utl\comment.i} */
(
 iDocument as component-handle):

/*(Organization, Counteragent)*/
define variable vOrganization as component-handle no-undo.
define variable vSendTask as component-handle no-undo.
define variable vDocumentToSend as component-handle no-undo.
    vOrganization = mDiadocConnection:GetOrganizationById(iDocument:OrganizationGuid) no-error.
    if vOrganization ne ?
    then do:
    /* Создание задания на отправку */
       vSendTask = vOrganization:CreatePackageSendTask2().
       getdesc(vSendTask).
/*       vSendTask:CounterAgentId = iDocument:Counteragent:Id.*/
   
       /* Добавление документа для заполнения контента средствами компоненты */
       /* Предполагаем, что процедура заполнения контента уже существует */
       vDocumentToSend = vSendTask:AddDocument("UniversalTransferDocument", "СЧФДОП", "utd820_05_01_01").
       vDocumentToSend = vSendTask:AddDocument("Nonformalized", "default", "v1").
       message 
       view-as alert-box.
       release object vSendTask.
       getdesc(vDocumentToSend).
       vDocumentToSend:Comment = "Это УПД с заполнением контента средствами компоненты".
/*       ЗаполнитьДинамическийКонтентДокумента(First_DocumentToSend.Content);

    // Добавление документа УПД с контентом, взятым из файла
    Second_DocumentToSend = SendTask.AddDocumentFromFile("UniversalTransferDocument", "СЧФДОП", "utd820_05_01_01", "С:\\Moй УПД.xml");
    Second_DocumentToSend.Comment = "Это УПД с контентом, загруженным из файла";

    // Добавление неформализованного документа
    Third_DocumentToSend = SendTask.AddDocumentFromFile("Nonformalized", "default", "v1", "С:\\Документ.pdf");
    Third_DocumentToSend.Comment = "Это неформализованный документ";
    MetaDataItem = Third_DocumentToSend.AddMetadata();
    MetaDataItem.Key   = "FileName";
    MetaDataItem.Value = "Имя Файла Для Передачи.xml";

    ОтправленныеДокументы = SendTask.Send();

КонецПроцедуры
*/
      release object vDocumentToSend.
      release object vOrganization.
   end.
end.
