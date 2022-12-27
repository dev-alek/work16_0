/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$
Процедура для записи истории по БД добавляемые в группу
Автор: 
Дата 
Author: 
Creation date: 
*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Процедура для записи истории по БД добавляемые в группу".
{cmp\vssrevis.i }
{cmp\trg-def.i}
{adm\userpro.i}   
DEFINE VARIABLE v-TabUserAdm as handle no-undo.
DEFINE stream OutStr-html.
DEFINE INPUT  PARAMETER  v-report-name-html-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE us_id AS CHARACTER LABEL "id" FORMAT "x(15)" no-undo. 
DEFINE VARIABLE us_name AS CHARACTER LABEL "us_NAME" FORMAT "x(50)" no-undo. 
DEFINE VARIABLE us_phone AS CHARACTER  FORMAT "x(32)" no-undo. 
DEFINE VARIABLE us_mobile AS CHARACTER  FORMAT "x(32)" no-undo. 
DEFINE VARIABLE us_email AS CHARACTER  FORMAT "x(32)"no-undo. 
DEFINE VARIABLE us_dep AS CHARACTER  FORMAT "x(32)" no-undo. 
DEFINE VARIABLE us_dbnum AS CHARACTER  no-undo. 
DEFINE VARIABLE us_adm AS CHARACTER  no-undo. 
DEFINE VARIABLE vdate AS CHARACTER  no-undo. 
DEFINE VARIABLE vtime AS INT  no-undo. 


  output stream OutStr-html to value(v-report-name-html-list) convert target 'UTF-8' /*no-convert*/.
    put stream OutStr-html unformatted
        "<!DOCTYPE HTML>" skip
        ' <html>' skip
        '  <head>' skip
        '   <meta charset="utf-8">' skip
        '    <style type="text/css">' skip
        '      table ' + chr(123) + ' border-collapse: collapse; ' + chr(125) skip
        '      .class1 ' + chr(123) + ' border-collapse: collapse; ' + chr(125) skip
        '      tbody td, th ' + chr(123) + ' border-collapse: collapse; border: 1px solid black; height: 14px;' + chr(125) skip
        '   </style>' skip
        '  </head>' skip
        '<body>' skip
        '<TABLE name="1"  fit_to_page="true" orientation="portrait" CELLSPACING="0" BORDER="0">'skip
        '<thead>' skip
        ' <tr class="set_columns">' skip
        ' <td style="width:50px"></td>' skip
        ' <td style="width:200px"></td>' skip
        ' <td style="width:120px"></td>' skip
        ' <td style="width:70px"></td>' skip
        ' <td style="width:70px"></td>' skip
        ' <td style="width:70px"></td>' skip
        ' <td style="width:70px"></td>' skip
        ' <td style="width:70px"></td>' skip
        ' <td style="width:70px"></td>' skip
        '</tr>' skip
        '<tr><!-- шапка таблицы -->' skip
        '<td colspan="8" style="text-align: right;"></td>' skip
        '</tr>' skip
        '<tr>' skip
        '<td colspan="8" style="font-weight: bold; text-align: center;">Отчет о смене пароля пользователем</td>' skip
        '</tr>' skip
        '</thead>' skip
        '<tr>' skip
        '<td style="width: 50px; text-align: center;">User ID </td>' skip
        '<td style="width: 200px; text-align: center;">Пользователь</td>' skip
        '<td style="width: 120px; text-align: center;">Дата и время смены пароля</td>' skip
        '<td style="width: 70px; text-align: center;">Телефон</td>' skip
        '<td style="width: 70px; text-align: center;">Мобильный телефон</td>' skip
        '<td style="width: 70px; text-align: center;">e-mail</td>' skip
        '<td style="width: 70px; text-align: center;">Отдел</td>' skip
        '<td style="width: 70px; text-align: center;">ном.бд</td>' skip
        '<td style="width: 70px; text-align: center;">Адм.бд</td>' skip
        '</tr>' skip
	'<tbody>' 
        .

FOR EACH user-account NO-LOCK:
    FOR EACH user-login WHERE user-login.user-id = user-account.user-id NO-LOCK:
      vdate  = ''.
      vtime  = 0.
      if user-account.status_ = {&bef-user-status-normal} AND user-login.status_ = {&bef-user-status-normal}
      then do:
        us_id = user-account.user-id.
        us_name = user-account.first-name + " " + user-account.last-name.
        us_phone = user-account.phone-number.
        us_mobile = user-account.mobile-phone-number.
        us_email = user-account.e-mail.
        us_dep  = user-account.department.
        us_dbnum = STRING(user-login.db-num).
        if user-login.user-administrator = yes then us_adm = 'админ.бд.'.
        else if user-login.user-administrator <> yes  then us_adm = ' '.
        run cur-time-mjd-to-date (user-login.user-password-set-mjd, output vdate, output vtime).
        put stream OutStr-html unformatted
            '<tr>' skip
            '<td style="width: 50px;">' us_id '</td>' skip
            '<td style="width: 200px;">' us_name '</td>' skip
            /* '<td style="width: 120px;">' sys-time_mjd-to-loc-str-func(user-login.user-password-set-mjd) '</td>' skip */
            '<td style="width: 120px;">' vdate ' ' STRING(vtime, "HH:MM")  '</td>' skip 
            '<td style="width: 70px;">' us_phone '</td>' skip
            '<td style="width: 70px;">' us_mobile '</td>' skip
            '<td style="width: 70px;">' us_email '</td>' skip
            '<td style="width: 70px;">' us_dep '</td>' skip
            '<td style="width: 70px;">' us_dbnum  '</td>' skip
            '<td style="width: 70px;">' us_adm  '</td>' skip
            '</tr>' skip
            .
      END.
    END. 
END. 

put stream OutStr-html unformatted
'<tbody>' skip
'</table>'
.

output stream OutStr-html close.   





