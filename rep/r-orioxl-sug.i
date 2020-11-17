/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Шапка и подвал для отчета инвентаризации СУГ

Автор: Булгаков Андрей Николаевич
Дата создания: 05/23/06
Author: Andrew Bulgakoff
Creation date: 05/23/06

*/

&scoped-define vssseq {&sequence}

define variable vss-include-info{&vssseq} as character no-undo format "x(65)":U
  initial "@(#)$Workfile$ $Revision$":U .

{ gbl/std-func.i {&f-l} }

procedure shapka-inv :
  put stream OutStr-html unformatted
    '<body>' skip
    /*Первая таблица*/
    '<TABLE name="1"  fit_to_page="true" orientation="portrait" CELLSPACING="0" BORDER="0">'skip
    '<thead>' skip
    .
  put stream OutStr-html unformatted
    '<tr class="set_columns">' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '</tr>' skip
    .  
  put stream OutStr-html unformatted
    '<TR><TD colspan="86"></TD></TR>' skip

    '<TR>' skip
    '<TD colspan="25" style="height: 14px; text-align: left;">Госкомнефтепродукт_________________________________</TD>' skip
    '<TD colspan="61" style="text-align: right;">Форма № 32-НП</TD>' skip
    '</TR>'skip
                                    
    '<TR>' skip
    '<TD colspan="25" style="height: 14px; border-bottom: 1px solid black; text-align: left;">' + v-host-name + '</TD>' skip
    '<TD colspan="61" style="text-align: right;">Утверждена Госкомнефтепродуктом СССР</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD colspan="25" style="border-top: 1px solid black; text-align: left; border-bottom: 1px solid black; text-align: left;"></TD>' skip
    '<TD colspan="61" style="text-align: right;">15 августа 1985 г. № 06/21-8-446</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD colspan="25" style="height: 14px; border-bottom: 1px solid black; text-align: left;">' + string( bf_object.obj-name) + '</TD>' skip
    '<TD colspan="61" style="text-align: right;"></TD>' skip
    '</TR>'skip
        
    '<TR>' skip
    '<TD colspan="86" style="text-align: center;">ИНВЕНТАРИЗАЦИОННАЯ ОПИСЬ НЕФТИ И НЕФТЕПРОДУКТОВ, СУГ</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD colspan="86" style="text-align: center;">' + "№ " + string(bf_trn-doc.doc-code) + " от " + string (day( t_inv-date )) + " " + string(MonthNameRusCase( month( t_inv-date ), 2 )) + " " + string(year( t_inv-date )) + "г. " + '</TD>' skip
    '</TR>'skip
    .
  put stream OutStr-html unformatted
    '<TR>' skip
    '<TD colspan="86" style="height: 14px;"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD colspan="86" style="">Расписка.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="86" style="">К началу проведения инвентаризации все приходные и расходные документы и товарно-материальные ценности включены в отчеты (реестры), сданы в бухгалтерию и все ценности, поступившие на мою (нашу) ответственность, оприходованы, а выбывшие списаны в расход.</TD>' skip
    '</TR>'skip
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="86" style="">Остатки на момент инвентаризации по данным моего (нашего) отчета составляют:</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style="">СУГ, нефти и нефтепродуктов на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style="">тары на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style="">наличных денег на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR style="height: 35px">' skip
    '<TD text_wrap="true" colspan="21" style="">отоваренных и погашаенных: единых талонов на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style="">талонов рыночного фонда на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
    .
  put stream OutStr-html unformatted
    '<TR style="height: 35px">' skip
    '<TD text_wrap="true" colspan="21" style="">нереализованных (неиспользованных) талонов:</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style="">рыночного фонда на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR style="height: 35px">' skip
    '<TD text_wrap="true" colspan="21" style="">единых (полученных для "сдачи") на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR style="height:20px;">' skip
    '<TD text_wrap="true" colspan="30" style="">Материально ответственные (ое) лица (лицо)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="text-align: center;">(прописью)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: center;">(фамилия имя отчество)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip                                                        

    '<TR style="height:20px;">' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="text-align: center;">(прописью)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: center;">(фамилия имя отчество)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip                                                        

    '<TR style="height:20px;">' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="text-align: center;">(прописью)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: center;">(фамилия имя отчество)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip            
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="86" style="">На основании распоряжения от "_____" _______________ 20____ г. № __________ </TD>' skip
    '</TR>'skip
                                                            
    '<TR>' skip
    '<TD text_wrap="true" colspan="86" style="">произведено снятие фактических остатков нефтепродуктов, денежных средств, талонов по состоянию на "_____" _______________ 20____ г.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: right;">Инвентаризация начата</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="54" style="">"_____" ______________ 20 _____ г. в _____ час. _____ мин.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: right;">окончена</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="54" style="">"_____" ______________ 20 _____ г. в _____ час. _____ мин.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="86" style="">При инвентаризации установлено следующее:</TD>' skip
    '</TR>'skip
        

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style="">СУГ, нефти и нефтепродуктов на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style="">тары на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style="">наличных денег на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR style="height: 35px">' skip
    '<TD text_wrap="true" colspan="21" style="">отоваренных и погашаенных: единых талонов на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style="">талонов рыночного фонда на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR style="height: 35px">' skip
    '<TD text_wrap="true" colspan="21" style="">нереализованных (неиспользованных) талонов:</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style="">рыночного фонда на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '</TR>'skip
        
    '<TR style="height: 35px">' skip
    '<TD text_wrap="true" colspan="21" style="">единых (полученных для "сдачи") на</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_rub}.</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style="">{&abbr_kop}.</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="21" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="15" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="6" style=""></TD>' skip
    .
                
  put stream OutStr-html unformatted            
    '</thead>' skip
    .        
end procedure. /* shapka-inv */

procedure foot-inv :
  put stream OutStr-html unformatted
    '<tfoot>' skip
    .
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '<td style="width: 6px;"></td>' skip
    '</tr>' skip
    .  
  put stream OutStr-html unformatted
    '<TR>' skip
    '<TD colspan="86" style="height: 14px;"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="20" style="">Итого по описи:</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="">а) порядковый номер _______________________________</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style=""></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="20" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style=""></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="20" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="">б) масса (кг) _____________________________________</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style=""></TD>' skip
    '</TR>'skip
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="20" style=""></TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: center;">(прописью)</TD>' skip
    '<TD text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="34" style=""></TD>' skip
    '</TR>'skip

      
    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style="">Председатель комиссии:</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="text-align: center;">(должность)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: center;">(фамилия имя отчество)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip                                                        

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style="">Члены комиссии:</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="text-align: center;">(должность)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: center;">(фамилия имя отчество)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip                                                        

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="text-align: center;">(должность)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: center;">(фамилия имя отчество)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip            
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="text-align: center;">(должность)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: center;">(фамилия имя отчество)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip            

    '<TR>' skip
    '<TD text_wrap="true" colspan="86" style="">Все ценности, поименованные в настоящей инвентаризационной описи, комиссией проверены в натуре в моем (нашем) присутствии и </TD>' skip
    '</TR>'skip
    '<TR>' skip
    '<TD text_wrap="true" colspan="86" style="">внесены в опись, в связи с чем претензий к инвентаризационной комиссии не имею (не имеем).</TD>' skip
    '</TR>'skip
    

    '<TR>' skip
    '<TD text_wrap="true" colspan="86" style="">Ценности, перечисленные в описи, находятся на моем (нашем) ответственном хранении</TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style="">Материально ответственное лицо:</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="50" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="4" text_wrap="true"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="50" style="text-align: center;">(подпись)</TD>' skip
    '<TD colspan="4" text_wrap="true"></TD>' skip
    '</TR>'skip                                                        
                                                            
    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="50" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="4" text_wrap="true"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="50" style="text-align: center;">(подпись)</TD>' skip
    '<TD colspan="4" text_wrap="true"></TD>' skip
    '</TR>'skip                                                        

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="50" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="4" text_wrap="true"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="50" style="text-align: center;">(подпись)</TD>' skip
    '<TD colspan="4" text_wrap="true"></TD>' skip
    '</TR>'skip                                                                

    '<TR>' skip
    '<TD text_wrap="true" colspan="86" style="">Указанные в настоящей инвентаризационной описи данные и подсчеты проверил:</TD>' skip
    '</TR>'skip
                
    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="border-bottom: 1px solid black;"></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip

    '<TR>' skip
    '<TD text_wrap="true" colspan="30" style=""></TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="20" style="text-align: center;">(должность)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '<TD text_wrap="true" colspan="30" style="text-align: center;">(фамилия имя отчество)</TD>' skip
    '<TD colspan="2" text_wrap="true"></TD>' skip
    '</TR>'skip                 
        
    '<TR>' skip
    '<TD text_wrap="true" colspan="86" style="">____ _______________ 20 _____ г.</TD>' skip
    '</TR>'skip
    .  
                
  put stream OutStr-html unformatted            
    '</tfoot>' skip
    .        

end procedure. /* foot-inv */
/* $Workfile$   E n d */