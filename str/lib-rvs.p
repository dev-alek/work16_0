/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Библиотека процедур работы со сверками

Автор: Уханов Дмитрий Юрьевич
Дата создания: 11/29/06
Author: Dmitry Ukhanov
Creation date: 11/29/06

Автор1: Булгаков Андрей Николаевич
Дата создания1: 12/23/05

*/

/* ********************************************************************************************************************* *\
 *                                                                                                                       *
 * procedure lib-rvs_place-sh - place-sh                                                                                 *
 * procedure lib-rvs_meas-plc - init-meas-place                                                                          *
 * procedure lib-rvs_fall-plc - fill-all-place                                                                           *
 * procedure lib-rvs_pump-sh  - pump-sh                                                                                  *
 * procedure lib-rvs_measpmnz - init-meas-pump-nozzle                                                                    *
 * procedure lib-rvs_rvs-pump - revision-pump                                                                            *
 * procedure lib-rvs_crttpmnz - cr_tt-pump-nozzle                                                                        *
 * procedure lib-rvs_fill1pmp - fill-one-pump                                                                            *
 * procedure lib-rvs_crrvslin - create-rvs-line                                                                          *
 * procedure lib-rvs_crrvslnp - create-rvs-line-pump                                                                     *
 * procedure lib-rvs_rvsplace - revision-place                                                                           *
 * procedure lib-rvs_fill1plc - fill-one-place                                                                           *
 * procedure lib-rvs_rvs-full                                                                                            *
 * procedure lib-rvs_rvsclose - rvs-clos                                                                                 *
 * procedure lib-rvs_crtt-rvs - cr-tt-param                                                                              *
 * procedure lib-rvs_crtt-pmp - cr-tt-param-pump                                                                         *
 * procedure lib-rvs_anls-pmp - analysis-pump                                                                            *
 * procedure lib-rvs_rvsclchd - recalc-header                                                                            *
 * procedure lib-rvs_rvsclcln - recalc-line                                                                              *
 * procedure lib-rvs_hstc-rvs - history-rvs                                                                              *
 *                                                                                                                       *
\* ********************************************************************************************************************* */

define variable vss-revision    as character no-undo initial "$Revision$":U.
define variable vss-author      as character no-undo initial "$Author$":U.
define variable vss-date        as character no-undo initial "$Date$":U.
define variable vss-workfile    as character no-undo initial "$Workfile$":U.
define variable vss-archive     as character no-undo initial "$Archive$":U.
define variable vss-description as character no-undo initial "Библиотека процедур работы со сверками":U.

{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/trg-def.i  }
{ cmp/library.i  }
{ str/lib-trn.i  }
{ str/libbcrcn.i }
{ str/lib-rvs.i  }
{ str/rvsttdef.i }
{ gbl/cur-time.i }
{ ref/gds-attr.i }
{ str/placelib.i }
/*{ ref/sr-izm.i sr-izmerenia ds}*/
/*{ ref/sr-izm.i " " proc }*/
{ gbl/ptrlprop.i def}
{ gbl/cur-time.i }
{ gbl/getsect.i def }
{ str/is-sug.i }
{ gbl/db-attr.i }

define stream str-anl.
define stream str-err.
define stream outstream.
define stream sinp .
define VARIABLE ii as integer no-undo .
    DEFINE VARIABLE rdc-value AS CHARACTER NO-UNDO INITIAL ?.
    DEFINE VARIABLE rdc-type  AS CHARACTER NO-UNDO INITIAL ?.
if valid-handle( g#lib-rvs ) and
   g#lib-rvs <> this-procedure :handle and
   g#lib-rvs :get-signature( 'lib-rvs_place-sh':U ) <> ''
then do:
  message vss-workfile skip( 0 ) vss-date skip( 0 ) vss-revision skip( 1 ) vss-description skip( 1 )
          'Попытка повторной загрузки библиотеки для работы со сверками' skip( 0 )
          g#lib-rvs                      skip( 0 )
          g#lib-rvs      :type           skip( 0 )
          g#lib-rvs      :file-name      skip( 0 )
          valid-handle( g#lib-rvs      ) skip( 0 )
          this-procedure :handle         skip( 0 )
          this-procedure :type           skip( 0 )
          this-procedure :file-name      skip( 0 )
          valid-handle( this-procedure ) skip( 1 )
  view-as alert-box error.
  undo, return error.
end.
else do:
  assign
    g#lib-rvs = this-procedure :handle
  .
end.
RUN gbl/conf-rd.p ("rdc-dnst", "", "", 0, "", "", "", NO, OUTPUT rdc-value, OUTPUT rdc-type) NO-ERROR.

if this-procedure :persistent <> yes then do:
  message vss-workfile skip( 0 ) vss-date skip( 0 ) vss-revision skip( 1 ) vss-description skip( 1 )
          'Ошибка запуска библиотеки' program-name( 1 ) skip( 0 )
          'Попытка запустить ее как обычную процедуру.' skip( 1 )
  view-as alert-box error.
end.

on delete of this-procedure do:
  assign
    g#lib-rvs = ?
  .
end.

procedure lib-rvs_place-sh : /* place-sh */
  define input parameter p-obj-type   like ub.place.obj-type     no-undo.
  define input parameter p-obj-code   like ub.place.obj-code     no-undo.
  define input parameter p-rvs-code   like ub.rvs-doc.rvs-code   no-undo.
  define input parameter p-rvs-type   like ub.rvs-doc.rvs-type   no-undo.
  define input parameter p-prev-code  like ub.rvs-doc.rvs-code   no-undo.
  define input parameter p-shift-date like ub.rvs-doc.shift-date no-undo.
  define input parameter p-shift-num  like ub.rvs-doc.shift-num  no-undo.
  define input parameter p-rvs-full   like ub.rvs-doc.is-full       no-undo.

  define buffer buf_place  for ub.place.
  define buffer buf_pl-gds for ub.pl-gds.

  define variable v-attr-value    as character no-undo .
  define variable v-attr-type     as character no-undo .

  tr:
  do transaction
  on error  undo tr, return error substitute( "&1 (place-sh). &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
  on stop   undo tr, return error substitute( "&1 (place-sh). stop", vss-workfile )
  on endkey undo tr, return error substitute( "&1 (place-sh). endkey", vss-workfile )
  :
    for each buf_place  no-lock
      where buf_place.obj-type = p-obj-type
        and buf_place.obj-code = p-obj-code
        and buf_place.status_  = ""
      ,each buf_pl-gds no-lock
      where buf_pl-gds.obj-type = buf_place.obj-type
        and buf_pl-gds.obj-code = buf_place.obj-code
        and buf_pl-gds.pl-code  = buf_place.pl-code
    on error undo, return error return-value
    :
      
          IF CAN-FIND( FIRST doc-attr
      WHERE doc-attr.doc-code  = p-rvs-code
        AND doc-attr.attr-code = "rvs-auto":U
        AND doc-attr.attr-value = "Yes":U and  p-rvs-full = yes and buf_place.is-meas = no
      NO-LOCK)
  THEN next.
        
      run gds-attr-value in this-procedure
        ( input  buf_pl-gds.gds-code
         ,input  {&attr-ptrl-without-rvs}
         ,output v-attr-value
         ,output v-attr-type
        ) .

      if lookup(v-attr-value, 'true,yes':u) = 0 then do:
        { str/crrvslin.i
          p-obj-type
          p-obj-code
          p-rvs-code
          p-rvs-type
          buf_pl-gds.pl-code
          buf_pl-gds.gds-code
          p-prev-code
          p-shift-date
          p-shift-num
          no-error
        }
        if error-status :error then do:
          undo tr, return error substitute( 'Ошибка из процедуры lib-rvs_crrvslin.&1&2&1&3'
                                          , {&new-line}
                                          , error-status :get-message( 1 )
                                          , return-value ) .
        end.
      end.
    end. /* for each bf_place, each bf_pl-gds */
  end. /* transaction */
  return .
end procedure. /* lib-rvs_place-sh */

procedure lib-rvs_meas-plc : /* init-meas-place */
  define input        parameter           p-obj-type like ub.place.obj-type no-undo.
  define input        parameter           p-obj-code like ub.place.obj-code no-undo.
  define input-output parameter table for tt-meas.

  define buffer bf_place     for ub.place.
  define buffer bf_place-err for ub.place.
  define buffer bf_goods     for ub.goods.

  for each tt-meas :
    delete tt-meas .
  end.
  for each bf_place no-lock where
           bf_place.obj-type = p-obj-type and
           bf_place.obj-code = p-obj-code and
           bf_place.is-meas  = yes and
           bf_place.status_ = ""
  :
    if trim( bf_place.loc1 ) = '':U or
             bf_place.loc1   = ?
    then do:
      return error substitute( 'В измеряемом резервуаре &1 задан неверный локальный номер "&2".'
                             , bf_place.pl-code
                             , bf_place.loc1 ) .
    end.
    find first bf_place-err no-lock
      where bf_place-err.obj-type =  bf_place.obj-type
        and bf_place-err.obj-code =  bf_place.obj-code
        and bf_place-err.is-meas  =  yes
        and bf_place-err.loc1     =  bf_place.loc1
        and recid( bf_place-err ) <> recid( bf_place )
        and bf_place-err.status_ = ""
      no-error.
    if available bf_place-err then do:
      return error substitute( 'В измеряемом резервуаре &1 задан локальный номер &2, установленный также в резервуаре &3.'
                             , bf_place.pl-code
                             , bf_place.loc1
                             , bf_place-err.pl-code ) .
    end.
    create tt-meas.
    assign
           tt-meas.obj-type = p-obj-type
           tt-meas.obj-code = p-obj-code
           tt-meas.pl-code  = bf_place.pl-code
           tt-meas.loc1 = bf_place.loc1
    .
  end. /* Все складские измеряемые места */
  return .
end procedure. /* lib-rvs_meas-plc */

procedure lib-rvs_fall-plc : /* fill-all-place */
  define input parameter p-obj-type like ub.rvs-doc.obj-type no-undo.
  define input parameter p-obj-code like ub.rvs-doc.obj-code no-undo.
  define input parameter p-rvs-code like ub.rvs-doc.rvs-code no-undo.
  define input parameter p-is-full  as   logical             no-undo.

  define buffer bf_place  for ub.place.
  define buffer bf_r-line for ub.rvs-line.
  define buffer buf_doc-attr     for ub.doc-attr .

  define variable v-auto    as logical      no-undo.


  IF CAN-FIND( FIRST buf_doc-attr
      WHERE buf_doc-attr.doc-code  = p-rvs-code
        AND buf_doc-attr.attr-code = "rvs-auto":U
        AND buf_doc-attr.attr-value = "Yes":U
      NO-LOCK)
  THEN DO:
     assign
         v-auto = true
     .
  END.

  tr:
  do transaction on error undo, return error
                 on stop  undo, return error
                 on quit  undo, return error :
    for  each bf_r-line where
              bf_r-line.rvs-code = p-rvs-code and
              bf_r-line.obj-type = p-obj-type and
              bf_r-line.obj-code = p-obj-code
      , first bf_place    where
              bf_place.obj-type = bf_r-line.obj-type and
              bf_place.obj-code = bf_r-line.obj-code and
              bf_place.pl-code  = bf_r-line.pl-code and
              bf_place.status_  = ""
              /*and   bf_place.is-meas  = yes */
    :
      IF bf_place.is-meas  = yes THEN DO:
      if p-is-full <> yes then do:
        find first tt-meas where
                   tt-meas.obj-type = p-obj-type       and
                   tt-meas.obj-code = p-obj-code       and
                   tt-meas.pl-code  = bf_place.pl-code no-error .
        if not available tt-meas then do:
          next .
        end.
      end.
      { str/fill1plc.i
          bf_r-line.obj-type
          bf_r-line.obj-code
          bf_r-line.pl-code
          "recid( bf_r-line )"
          bf_r-line.rvs-prev-code
          tt-meas
          no-error
      }
      if error-status :error then do:
        undo tr, return error substitute( 'Ошибка при заполнении данных.&1&2&1&3'
                                        , {&new-line}
                                        , error-status :get-message( 1 )
                                        , return-value ) .
      end.
      END.
      ELSE DO:
         IF v-auto THEN DO:
            { str/fill2plc.i
               bf_r-line.obj-type
               bf_r-line.obj-code
               bf_r-line.pl-code
               "recid( bf_r-line )"
               bf_r-line.rvs-prev-code
               tt-meas
               no-error
            }
            if error-status :error then do:
            undo tr, return error substitute( 'Ошибка при заполнении данных из документов.&1&2&1&3'
                                             , {&new-line}
                                             , error-status :get-message( 1 )
                                             , return-value ).
            end.
         END.
      END.
    end. /* for each */
  end. /* transaction */
  return .
end procedure. /* lib-rvs_fall-plc */

procedure lib-rvs_pump-sh : /* pump-sh */
  define input parameter p-obj-type         like ub.place.obj-type     no-undo.
  define input parameter p-obj-code         like ub.place.obj-code     no-undo.
  define input parameter p-rvs-code         like ub.rvs-doc.rvs-code   no-undo.
  define input parameter p-rvs-type         like ub.rvs-doc.rvs-type   no-undo.
  define input parameter p-prev-rvs-code    like ub.rvs-doc.rvs-code   no-undo.
  define input parameter p-prev-icnt-code   like ub.icnt-doc.doc-code  no-undo.
  define input parameter p-shift-date       like ub.rvs-doc.shift-date no-undo.
  define input parameter p-shift-num        like ub.rvs-doc.shift-num  no-undo.
  define input parameter p-qst_icnt-gds-all as   logical               no-undo.
  define input parameter p-message-on       as   logical               no-undo.

  define buffer buf_rvs-line for ub.rvs-line.

  tr:
  do transaction
  on error undo tr, return error return-value
  :
    for each buf_rvs-line
      where buf_rvs-line.rvs-code = p-rvs-code
        and buf_rvs-line.obj-type = p-obj-type
        and buf_rvs-line.obj-code = p-obj-code
    on error undo tr, return error return-value
    :
      { str/crrvslnp.i
          p-obj-type
          p-obj-code
          p-rvs-code
          p-rvs-type
          buf_rvs-line.pl-code
          buf_rvs-line.gds-code
          p-qst_icnt-gds-all
          p-prev-rvs-code
          p-shift-date
          p-shift-num
          p-prev-icnt-code
          p-message-on
          no-error
      }
      if error-status :error then do:
        undo tr, return error substitute( 'Ошибка при создании строки данных по ТРК.&1&2&1&3'
                                        , {&new-line}
                                        , error-status :get-message( 1 )
                                        , return-value ) .
      end.
    end. /* for each buf_rvs-line */
  end. /* transaction */
  return .
end procedure. /* lib-rvs_pump-sh */

procedure lib-rvs_measpmnz : /* init-meas-pump-nozzle */
  define input        parameter           p-obj-type     like ub.pump-nozzle.obj-type no-undo.
  define input        parameter           p-obj-code     like ub.pump-nozzle.obj-code no-undo.
  define input-output parameter table for tt-pump-nozzle.

  define buffer bf_pump-nozzle    for ub.pump-nozzle.
  define buffer bf_pl-pump-nozzle for ub.pl-pump-nozzle.
  define buffer bf_pl-gds         for ub.pl-gds.

  for each tt-pump-nozzle :
    delete tt-pump-nozzle .
  end.
  for each bf_pump-nozzle where
           bf_pump-nozzle.obj-type = p-obj-type and
           bf_pump-nozzle.obj-code = p-obj-code and
           bf_pump-nozzle.is-meas  = yes
  :
    /*
    { str/crttpmnz.i
        bf_pump-nozzle.obj-type
        bf_pump-nozzle.obj-code
        bf_pump-nozzle.pump-code
        bf_pump-nozzle.nozzle-code
        tt-pump-nozzle
        no-error
    }
    if error-status :error then do:
      return error return-value .
    end.
    */
    find first bf_pl-pump-nozzle no-lock where
               bf_pl-pump-nozzle.obj-type    = bf_pump-nozzle.obj-type    and
               bf_pl-pump-nozzle.obj-code    = bf_pump-nozzle.obj-code    and
               bf_pl-pump-nozzle.pump-code   = bf_pump-nozzle.pump-code   and
               bf_pl-pump-nozzle.nozzle-code = bf_pump-nozzle.nozzle-code no-error .
    if available bf_pl-pump-nozzle then do:
      find first bf_pl-gds no-lock where
                 bf_pl-gds.obj-type = bf_pl-pump-nozzle.obj-type and
                 bf_pl-gds.obj-code = bf_pl-pump-nozzle.obj-code and
                 bf_pl-gds.pl-code  = bf_pl-pump-nozzle.pl-code  no-error .
      if available bf_pl-gds then do:
        create tt-pump-nozzle.
        assign
               tt-pump-nozzle.obj-type    = bf_pl-pump-nozzle.obj-type
               tt-pump-nozzle.obj-code    = bf_pl-pump-nozzle.obj-code
               tt-pump-nozzle.pump-code   = bf_pl-pump-nozzle.pump-code
               tt-pump-nozzle.nozzle-code = bf_pl-pump-nozzle.nozzle-code
               tt-pump-nozzle.gds-code    = bf_pl-gds.gds-code
        .
      end. /* if available bf_pl-gds */
    end. /* if available bf_pl-pump-nozzle */
  end. /* for each */
  return .
end procedure. /* lib-rvs_measpmnz */

procedure lib-rvs_rvs-pump : /* revision-pump */
  define input        parameter           p-parent-proc       as   widget-handle             no-undo.
  define input        parameter           p-obj-type          like ub.rvs-line-pump.obj-type no-undo.
  define input        parameter           p-obj-code          like ub.rvs-line-pump.obj-code no-undo.
  define input        parameter           p-rvs-code          like ub.rvs-line-pump.rvs-code no-undo.
  define input        parameter           p-cur-pump          as   logical                   no-undo.
  define input-output parameter table for tt-pump-nozzle-file.
  define input-output parameter table for tt-pump-nozzle.

  define buffer bf_pump-nozzle   for ub.pump-nozzle.
  define buffer bf_rvs-line-pump for ub.rvs-line-pump.

  define variable v-msg as character no-undo initial "":U .

  { str/anls-pmp.i
      p-parent-proc
      p-obj-type
      p-obj-code
      yes
      tt-pump-nozzle-file
      tt-pump-nozzle
      p-cur-pump
      no
      no-error
  }
  if error-status :error then do:
    return error return-value .
  end.
  assign
    v-msg = return-value
  .

  tr:
  do transaction
  on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
  on stop  undo, return error substitute( "&1. stop", vss-workfile )
  on quit  undo, return error substitute( "&1. quit", vss-workfile )
  :
    for each bf_rvs-line-pump
      where bf_rvs-line-pump.rvs-code = p-rvs-code
        and bf_rvs-line-pump.obj-type = p-obj-type
        and bf_rvs-line-pump.obj-code = p-obj-code
      ,first bf_pump-nozzle
      where bf_pump-nozzle.obj-type    = bf_rvs-line-pump.obj-type
        and bf_pump-nozzle.obj-code    = bf_rvs-line-pump.obj-code
        and bf_pump-nozzle.pump-code   = bf_rvs-line-pump.pump-code
        and bf_pump-nozzle.nozzle-code = bf_rvs-line-pump.nozzle-code
        and bf_pump-nozzle.is-meas     = yes
    on error undo tr, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
    :
      { str/fill1pmp.i
          "recid( bf_rvs-line-pump )"
          tt-pump-nozzle
          no-error
      }
      if error-status :error then do:
        undo tr, return error 'Ошибка при сохранении данных в строку счетчиков ТРК ' + return-value + ' .' .
      end.
    end. /* for each */
  end. /* transaction */
  return v-msg .
end procedure. /* lib-rvs_rvs-pump */

procedure lib-rvs_crttpmnz : /* cr_tt-pump-nozzle */
  define input        parameter           p-obj-type     like ub.pump-nozzle.obj-type    no-undo.
  define input        parameter           p-obj-code     like ub.pump-nozzle.obj-code    no-undo.
  define input        parameter           p-pump-code    like ub.pump-nozzle.pump-code   no-undo.
  define input        parameter           p-nozzle-code  like ub.pump-nozzle.nozzle-code no-undo.
  define input-output parameter table for tt-pump-nozzle.

  define buffer bf_pl-pump-nozzle for ub.pl-pump-nozzle.
  define buffer bf_pl-gds         for ub.pl-gds.

  find first bf_pl-pump-nozzle no-lock where
             bf_pl-pump-nozzle.obj-type    = p-obj-type    and
             bf_pl-pump-nozzle.obj-code    = p-obj-code    and
             bf_pl-pump-nozzle.pump-code   = p-pump-code   and
             bf_pl-pump-nozzle.nozzle-code = p-nozzle-code no-error .
  if available bf_pl-pump-nozzle then do:
    find first bf_pl-gds no-lock where
               bf_pl-gds.obj-type = bf_pl-pump-nozzle.obj-type and
               bf_pl-gds.obj-code = bf_pl-pump-nozzle.obj-code and
               bf_pl-gds.pl-code  = bf_pl-pump-nozzle.pl-code  no-error .
    if available bf_pl-gds then do:
      create tt-pump-nozzle.
      assign
             tt-pump-nozzle.obj-type    = bf_pl-pump-nozzle.obj-type
             tt-pump-nozzle.obj-code    = bf_pl-pump-nozzle.obj-code
             tt-pump-nozzle.pump-code   = bf_pl-pump-nozzle.pump-code
             tt-pump-nozzle.nozzle-code = bf_pl-pump-nozzle.nozzle-code
             tt-pump-nozzle.gds-code    = bf_pl-gds.gds-code
      .
    end. /* if available bf_pl-gds */
  end. /* if available bf_pl-pump-nozzle */
  return .
end procedure. /* lib-rvs_crttpmnz */

procedure lib-rvs_fill1pmp : /* fill-one-pump */
  define input parameter           p-rec_rvs-line-pump as recid no-undo.
  define input parameter table for tt-pump-nozzle.

  define buffer start_icnt-line     for ub.icnt-line.
  define buffer start_rvs-line-pump for ub.rvs-line-pump.
  define buffer fill_rvs-line       for ub.rvs-line.
  define buffer fill_rvs-line-pump  for ub.rvs-line-pump.
  define buffer bf_goods            for ub.goods.

  find first fill_rvs-line-pump where
      recid( fill_rvs-line-pump ) = p-rec_rvs-line-pump no-error .
  if not available fill_rvs-line-pump then do:
    return error substitute( 'Неверные параметры переданы процедуре lib-rvs_fill1pmp. '
                           + 'Не найдена запись rvs-line-pump c recid: &1 .'
                           , p-rec_rvs-line-pump ) .
  end.

  find first tt-pump-nozzle where
             tt-pump-nozzle.obj-type    = fill_rvs-line-pump.obj-type    and
             tt-pump-nozzle.obj-code    = fill_rvs-line-pump.obj-code    and
             tt-pump-nozzle.pump-code   = fill_rvs-line-pump.pump-code   and
             tt-pump-nozzle.nozzle-code = fill_rvs-line-pump.nozzle-code no-error .
  find first fill_rvs-line no-lock where
             fill_rvs-line.rvs-code = fill_rvs-line-pump.rvs-code and
             fill_rvs-line.obj-type = fill_rvs-line-pump.obj-type and
             fill_rvs-line.obj-code = fill_rvs-line-pump.obj-code and
             fill_rvs-line.pl-code  = fill_rvs-line-pump.pl-code  .
  find first bf_goods no-lock where
             bf_goods.gds-code = fill_rvs-line.gds-code .
  if not available tt-pump-nozzle then do:
    return error substitute( 'Ошибка. Со счетчиков не получены данные по ТРК &1 пистолету &2 '
                           + 'через который продается топливо &3 &4 &5 &6.'
                           , fill_rvs-line-pump.pump-code
                           , fill_rvs-line-pump.nozzle-code
                           , bf_goods.artic
                           , bf_goods.prod-type
                           , bf_goods.prod-code
                           , bf_goods.gds-name ) .
  end.
  /* Заполняем измеряемые и устанавливаемые поля */
  assign
    fill_rvs-line-pump.meas-el-cnt  = tt-pump-nozzle.meas-el-cnt
    fill_rvs-line-pump.meas-am-cnt  = tt-pump-nozzle.meas-am-cnt
    fill_rvs-line-pump.meas-cf-cnt  = tt-pump-nozzle.meas-cf-cnt
    fill_rvs-line-pump.state-el-cnt = fill_rvs-line-pump.meas-el-cnt
    fill_rvs-line-pump.state-am-cnt = fill_rvs-line-pump.meas-am-cnt
    fill_rvs-line-pump.state-cf-cnt = fill_rvs-line-pump.meas-cf-cnt
  .
  /* Устанавливаем оборот по механическому счетчику */
  if fill_rvs-line-pump.icnt-code <> ? then do:
    find first start_icnt-line no-lock where
               start_icnt-line.doc-code    = fill_rvs-line-pump.icnt-code   and
               start_icnt-line.obj-type    = fill_rvs-line-pump.obj-type    and
               start_icnt-line.obj-code    = fill_rvs-line-pump.obj-code    and
               start_icnt-line.pump-code   = fill_rvs-line-pump.pump-code   and
               start_icnt-line.nozzle-code = fill_rvs-line-pump.nozzle-code .
    assign
      fill_rvs-line-pump.meas-mh-cnt  = fill_rvs-line-pump.meas-el-cnt - start_icnt-line.state-el-cnt
                                                                       + start_icnt-line.state-mh-cnt
      fill_rvs-line-pump.state-mh-cnt = fill_rvs-line-pump.meas-mh-cnt
    .
  end.
  /* Устанавливаем количества, исходя из нарастающего итога */
  if fill_rvs-line-pump.rvs-prev-code <> ? then do:
    find first start_rvs-line-pump no-lock where
               start_rvs-line-pump.rvs-code    = fill_rvs-line-pump.rvs-prev-code and
               start_rvs-line-pump.obj-type    = fill_rvs-line-pump.obj-type      and
               start_rvs-line-pump.obj-code    = fill_rvs-line-pump.obj-code      and
               start_rvs-line-pump.pl-code     = fill_rvs-line-pump.pl-code       and
               start_rvs-line-pump.gds-code    = fill_rvs-line-pump.gds-code      and
               start_rvs-line-pump.pump-code   = fill_rvs-line-pump.pump-code     and
               start_rvs-line-pump.nozzle-code = fill_rvs-line-pump.nozzle-code   .
    assign
      fill_rvs-line-pump.meas-mh-qnty  = fill_rvs-line-pump.meas-mh-cnt  - start_rvs-line-pump.meas-mh-cnt
      fill_rvs-line-pump.meas-am-qnty  = fill_rvs-line-pump.meas-am-cnt  - start_rvs-line-pump.meas-am-cnt
      fill_rvs-line-pump.meas-cf-qnty  = fill_rvs-line-pump.meas-cf-cnt  - start_rvs-line-pump.meas-cf-cnt
      fill_rvs-line-pump.state-mh-qnty = fill_rvs-line-pump.state-mh-cnt - start_rvs-line-pump.state-mh-cnt
      fill_rvs-line-pump.state-am-qnty = fill_rvs-line-pump.state-am-cnt - start_rvs-line-pump.state-am-cnt
      fill_rvs-line-pump.state-cf-qnty = fill_rvs-line-pump.state-cf-cnt - start_rvs-line-pump.state-cf-cnt
    .
  end.
  return .
end procedure. /* lib-rvs_fill1pmp */

procedure lib-rvs_crrvslin : /* create-rvs-line */
  define input parameter p-obj-type                 like ub.rvs-doc.obj-type     no-undo.
  define input parameter p-obj-code                 like ub.rvs-doc.obj-code     no-undo.
  define input parameter p-rvs-code                 like ub.rvs-doc.rvs-code     no-undo.
  define input parameter p-rvs-type                 like ub.rvs-doc.rvs-type     no-undo.
  define input parameter p-pl-code                  like ub.pl-gds.pl-code       no-undo.
  define input parameter p-gds-code                 like ub.pl-gds.gds-code      no-undo.
  define input parameter p-prev_rvs-code            like ub.rvs-doc.rvs-code     no-undo.
  define input parameter p-cur_shift-obj_shift-date like ub.shift-obj.shift-date no-undo.
  define input parameter p-cur_shift-obj_shift-num  like ub.shift-obj.shift-num  no-undo.

  define buffer bf_prev_rvs-line for ub.rvs-line.
  define buffer prev_rvs-line    for ub.rvs-line.
  define buffer buf_goods        for ub.goods .
  define buffer buf_rvs-line     for ub.rvs-line.
  define buffer buf_rvs-doc      for ub.rvs-doc.
  define buffer contr_rvs-doc    for ub.rvs-doc.
  define buffer crl_prev_rvs-doc for ub.rvs-doc.
  define buffer buf_place        for ub.place.




  do on error undo, return error return-value :

    if p-prev_rvs-code <> ? then do:
      find first crl_prev_rvs-doc no-lock
        where crl_prev_rvs-doc.rvs-code = p-prev_rvs-code
      .
    end.

    define variable varis-petrol   as logical no-undo.
    define variable varis-pieces   as logical no-undo.

    find first buf_goods no-lock
      where buf_goods.gds-code = p-gds-code
    .
    /* только жидкое топливо */
    { str/is-petrl.i
      buf_goods.artic
      buf_goods.prod-type
      buf_goods.prod-code
      varis-petrol
      varis-pieces
      no-error
    }
    if error-status :error then do:
      return error 'Ошибка при вызове программы is-petrl.i ' + return-value .
    end.
    if varis-petrol <> yes
      or varis-pieces =  yes
    then do:
      return 'Товар не является жидким топливом' .
    end.

    { gbl/ptrlprop.i run p-obj-type p-obj-code }

    find first buf_rvs-line no-lock
      where buf_rvs-line.rvs-code = p-rvs-code
        and buf_rvs-line.obj-type = p-obj-type
        and buf_rvs-line.obj-code = p-obj-code
        and buf_rvs-line.pl-code  = p-pl-code
        and buf_rvs-line.gds-code = p-gds-code
      no-error .
    if not available buf_rvs-line then do:
      /* Если сверка по смене, то для бака с товаром должна существовать
         сверка в предыдущей смене или контрольная сверка в текущей смене */
      if available prev_rvs-line then do:
        release prev_rvs-line .
      end.
      if available crl_prev_rvs-doc then do:
        find first prev_rvs-line no-lock
          where prev_rvs-line.rvs-code = crl_prev_rvs-doc.rvs-code
            and prev_rvs-line.obj-type = p-obj-type
            and prev_rvs-line.obj-code = p-obj-code
            and prev_rvs-line.pl-code  = p-pl-code
            and prev_rvs-line.gds-code = p-gds-code
          no-error .
      end.
      /* Не было остатка по баку за прошлую смену. Ищем закрытую сверку за текущую смену по этому баку */
      if not available prev_rvs-line then do:
        prev:
        for each contr_rvs-doc no-lock
          where contr_rvs-doc.obj-type   = p-obj-type
            and contr_rvs-doc.obj-code   = p-obj-code
            and contr_rvs-doc.shift-date = p-cur_shift-obj_shift-date
            and contr_rvs-doc.shift-num  = p-cur_shift-obj_shift-num
            and contr_rvs-doc.status_    = {&fact}
          by contr_rvs-doc.fact-order
        on error undo, return error return-value
        :
          find first prev_rvs-line no-lock
            where prev_rvs-line.rvs-code = contr_rvs-doc.rvs-code
              and prev_rvs-line.obj-type = p-obj-type
              and prev_rvs-line.obj-code = p-obj-code
              and prev_rvs-line.pl-code  = p-pl-code
              and prev_rvs-line.gds-code = p-gds-code
            no-error .
          if available prev_rvs-line then do:
            leave prev .
          end.
        end. /* prev: for each contr_rvs-doc */
        if not available prev_rvs-line
          and p-rvs-type = {&rvs-shift}
        then do:
          return error substitute( 'На объекте &1 &2 для резервуара &3 в котором находится топливо &4'
                                   + 'нет сверки по смене за прошлую смену и нет ни одной контрольной сверки за текущую смену.'
                                   ,p-obj-type
                                   ,p-obj-code
                                   ,p-pl-code
                                   ,p-gds-code
                                  ) .
        end.
      end. /* if not available prev_rvs-line */
      create buf_rvs-line.
      assign
        buf_rvs-line.rvs-code      = p-rvs-code
        buf_rvs-line.obj-type      = p-obj-type
        buf_rvs-line.obj-code      = p-obj-code
        buf_rvs-line.pl-code       = p-pl-code
        buf_rvs-line.gds-code      = p-gds-code
        buf_rvs-line.rvs-prev-code = ( if available prev_rvs-line then prev_rvs-line.rvs-code else ? )
        buf_rvs-line.measure-qnty = ?
        buf_rvs-line.brutto-qnty = ?
        buf_rvs-line.measure-cli-qnty = ?
        buf_rvs-line.brutto-cli-qnty = ?
        buf_rvs-line.density = ?
        buf_rvs-line.temperature = ?
        buf_rvs-line.level-total = ?
        buf_rvs-line.level-petrol = ?
        buf_rvs-line.level-water = ?
        buf_rvs-line.temp-layer1 = ?
        buf_rvs-line.temp-layer2 = ?
        buf_rvs-line.temp-layer3 = ?
        buf_rvs-line.measure-tc-qnty = ?
        buf_rvs-line.brutto-tc-qnty = ?
        buf_rvs-line.state-measure-qnty = ?
        buf_rvs-line.state-brutto-qnty = ?
        buf_rvs-line.state-measure-cli-qnty = ?
        buf_rvs-line.state-brutto-cli-qnty = ?
        buf_rvs-line.state-density = ?
        buf_rvs-line.state-temperature = ?
        buf_rvs-line.state-level-total = ?
        buf_rvs-line.state-level-petrol = ?
        buf_rvs-line.state-level-water = ?
        buf_rvs-line.state-temp-layer1 = ?
        buf_rvs-line.state-temp-layer2 = ?
        buf_rvs-line.state-temp-layer3 = ?
        buf_rvs-line.state-measure-tc-qnty = ?
        buf_rvs-line.state-brutto-tc-qnty = ?
      .
      
      find first buf_place no-lock  where buf_place.obj-type = p-obj-type
                                    and buf_place.obj-code = p-obj-code
                                    and buf_place.pl-code  = p-pl-code
                                    no-error .
      if available buf_place
      then do :
        assign
          buf_rvs-line.add-qnty       = buf_place.add-qnty
          buf_rvs-line.state-add-qnty = buf_place.add-qnty
        .
      end.                              

      if buf_goods.unit-base = buf_goods.unit-cli then do:
        assign
          buf_rvs-line.state-density = 1.0
        .
      end.
      else do:
        if ptrlprop-olddens = true
        and not is-sug(buf_rvs-line.gds-code)  
        then do:

              prev:
              for each contr_rvs-doc no-lock
                  where contr_rvs-doc.obj-type   = p-obj-type
                  and contr_rvs-doc.obj-code   = p-obj-code
                  and contr_rvs-doc.shift-date = p-cur_shift-obj_shift-date
                  and contr_rvs-doc.shift-num  = p-cur_shift-obj_shift-num
                  and contr_rvs-doc.status_    = {&fact}
                  /* and contr_rvs-doc.rvs-type = {&rvs-control} */
                  by contr_rvs-doc.fact-order desc
                  on error undo, return error return-value
                  :
                  find last bf_prev_rvs-line no-lock
                      where bf_prev_rvs-line.rvs-code = contr_rvs-doc.rvs-code
                      and bf_prev_rvs-line.obj-type = p-obj-type
                      and bf_prev_rvs-line.obj-code = p-obj-code
                      and bf_prev_rvs-line.pl-code  = p-pl-code
                      and bf_prev_rvs-line.gds-code = p-gds-code
                      no-error .
                  if available bf_prev_rvs-line then 
                  do:           
                      buf_rvs-line.state-temperature = bf_prev_rvs-line.state-temperature.    
                      buf_rvs-line.state-density = bf_prev_rvs-line.state-density.
                     
                      find first rvs-line-attr exclusive-lock
                           where rvs-line-attr.obj-code  = buf_rvs-line.obj-code
                             and rvs-line-attr.obj-type  = buf_rvs-line.obj-type
                             and rvs-line-attr.gds-code  = buf_rvs-line.gds-code
                             and rvs-line-attr.pl-code   = buf_rvs-line.pl-code
                             and rvs-line-attr.rvs-code  = buf_rvs-line.rvs-code
                             and rvs-line-attr.attr-code = "is-olddens" no-error.
                      if not available rvs-line-attr then do :
                        create rvs-line-attr.
                        assign
                          rvs-line-attr.obj-code  = buf_rvs-line.obj-code
                          rvs-line-attr.obj-type  = buf_rvs-line.obj-type
                          rvs-line-attr.gds-code  = buf_rvs-line.gds-code
                          rvs-line-attr.pl-code   = buf_rvs-line.pl-code
                          rvs-line-attr.rvs-code  = buf_rvs-line.rvs-code
                          rvs-line-attr.attr-code = "is-olddens"
                        .
                      end.
                      rvs-line-attr.attr-value = 'yes' .
                      leave prev .
                  end.
              end.
              
              if  buf_rvs-line.state-temperature = 0 then  buf_rvs-line.state-temperature = prev_rvs-line.state-temperature. 
              if  buf_rvs-line.state-density = 0 then 
              do: 
                  buf_rvs-line.state-density = prev_rvs-line.state-density.
                  find first rvs-line-attr exclusive-lock
                       where rvs-line-attr.obj-code  = buf_rvs-line.obj-code
                         and rvs-line-attr.obj-type  = buf_rvs-line.obj-type
                         and rvs-line-attr.gds-code  = buf_rvs-line.gds-code
                         and rvs-line-attr.pl-code   = buf_rvs-line.pl-code
                         and rvs-line-attr.rvs-code  = buf_rvs-line.rvs-code
                         and rvs-line-attr.attr-code = "is-olddens" no-error.
                  if not available rvs-line-attr then do :
                    create rvs-line-attr.
                    assign
                      rvs-line-attr.obj-code  = buf_rvs-line.obj-code
                      rvs-line-attr.obj-type  = buf_rvs-line.obj-type
                      rvs-line-attr.gds-code  = buf_rvs-line.gds-code
                      rvs-line-attr.pl-code   = buf_rvs-line.pl-code
                      rvs-line-attr.rvs-code  = buf_rvs-line.rvs-code
                      rvs-line-attr.attr-code = "is-olddens"
                    .
                  end.
                  rvs-line-attr.attr-value = 'yes' .
              end.
          end.
      end.
          assign
              buf_rvs-line.system-qnty          = 0.00
              buf_rvs-line.system-cli-qnty      = 0.00
              buf_rvs-line.orig-system-cli-qnty = buf_rvs-line.system-cli-qnty
              buf_rvs-line.orig-system-qnty     = buf_rvs-line.system-qnty
              .
      end. /* Добавление строки */
      find first rvs-line-attr exclusive-lock
           where rvs-line-attr.obj-code  = buf_rvs-line.obj-code
             and rvs-line-attr.obj-type  = buf_rvs-line.obj-type
             and rvs-line-attr.gds-code  = buf_rvs-line.gds-code
             and rvs-line-attr.pl-code   = buf_rvs-line.pl-code
             and rvs-line-attr.rvs-code  = buf_rvs-line.rvs-code
             and rvs-line-attr.attr-code = "input-type" no-error.
      if not available rvs-line-attr then do :
        create rvs-line-attr.
        assign
          rvs-line-attr.obj-code  = buf_rvs-line.obj-code
          rvs-line-attr.obj-type  = buf_rvs-line.obj-type
          rvs-line-attr.gds-code  = buf_rvs-line.gds-code
          rvs-line-attr.pl-code   = buf_rvs-line.pl-code
          rvs-line-attr.rvs-code  = buf_rvs-line.rvs-code
          rvs-line-attr.attr-code = "input-type"
          rvs-line-attr.attr-value = ''
        .
      end.
 
  end. /* on error */
  return .
end procedure. /* lib-rvs_crrvslin */

procedure lib-rvs_crrvslnp : /* create-rvs-line-pump */
  define input parameter p-obj-type                 like ub.rvs-doc.obj-type     no-undo.
  define input parameter p-obj-code                 like ub.rvs-doc.obj-code     no-undo.
  define input parameter p-rvs-code                 like ub.rvs-line.rvs-code    no-undo.
  define input parameter p-rvs-type                 like ub.rvs-doc.rvs-type     no-undo.
  define input parameter p-pl-code                  like ub.rvs-line.pl-code     no-undo.
  define input parameter p-gds-code                 like ub.rvs-line.gds-code    no-undo.
  define input parameter p-quest_icnt-goods         as   logical                 no-undo.
  define input parameter p-prev_rvs-code            like ub.rvs-doc.rvs-code     no-undo.
  define input parameter p-cur_shift-obj_shift-date like ub.shift-obj.shift-date no-undo.
  define input parameter p-cur_shift-obj_shift-num  like ub.shift-obj.shift-num  no-undo.
  define input parameter p-prev_icnt-code           like ub.icnt-doc.doc-code    no-undo.
  define input parameter p-message-on               as   logical                 no-undo.

  /* для вирт рез */
  define variable is-vir as logical no-undo.
  define variable v-value as character no-undo.
  define variable v-ok as logical no-undo.
  
  do
  on error  undo, return error substitute( "&1(lib-rvs_crrvslnp). &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
  on stop   undo, return error substitute( "&1(lib-rvs_crrvslnp). stop", vss-workfile )
  on endkey undo, return error substitute( "&1(lib-rvs_crrvslnp). endkey", vss-workfile )
  :
    define buffer buf_pl-pump-nozzle for ub.pl-pump-nozzle.
    define buffer contr_rvs-doc      for ub.rvs-doc.
    define buffer buf_rvs-line       for ub.rvs-line.
    define buffer buf_rvs-line-pump  for ub.rvs-line-pump.
    define buffer prev-contr_rvs-doc for ub.rvs-doc.
    define buffer prev_rvs-line-pump for ub.rvs-line-pump.
    define buffer other-line-pump    for ub.rvs-line-pump.
    define buffer prev_icnt-line     for ub.icnt-line.
    define buffer bf_pump-nozzle     for ub.pump-nozzle.
    define buffer bf_goods           for ub.goods.
    define buffer icnt-goods         for ub.goods.
    define buffer crl_prev_rvs-doc   for ub.rvs-doc.
    define buffer crl_prev_icnt-doc  for ub.icnt-doc.

    define variable varnoeqgds as logical no-undo.
    define variable g-log      as logical no-undo.

    if p-prev_rvs-code <> ? then do:
      find first crl_prev_rvs-doc no-lock
        where crl_prev_rvs-doc.rvs-code = p-prev_rvs-code
      .
    end.
    if p-prev_icnt-code <> ? then do:
      find first crl_prev_icnt-doc no-lock
        where crl_prev_icnt-doc.doc-code = p-prev_icnt-code
      .
    end.

    tr:
    do transaction
    on error  undo tr, return error substitute( "&1 (crrvslnp). &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
    on stop   undo tr, return error substitute( "&1 (crrvslnp). stop", vss-workfile )
    on endkey undo tr, return error substitute( "&1 (crrvslnp). endkey", vss-workfile )
    :
      for each buf_pl-pump-nozzle
        where buf_pl-pump-nozzle.obj-type = p-obj-type
          and buf_pl-pump-nozzle.obj-code = p-obj-code
          and buf_pl-pump-nozzle.pl-code  = p-pl-code
      on error undo, return error return-value
      :
        find first buf_rvs-line no-lock
          where buf_rvs-line.rvs-code = p-rvs-code
            and buf_rvs-line.obj-type = buf_pl-pump-nozzle.obj-type
            and buf_rvs-line.obj-code = buf_pl-pump-nozzle.obj-code
            and buf_rvs-line.pl-code  = buf_pl-pump-nozzle.pl-code
            and buf_rvs-line.gds-code = p-gds-code
          no-error .
        if not available buf_rvs-line then do:
          /* раз не нужна сверка по резервуару, значит не нужна и сверка счетчиков ТРК */
          next.
        end.
        find first buf_rvs-line-pump
          where buf_rvs-line-pump.rvs-code    = p-rvs-code
            and buf_rvs-line-pump.obj-type    = p-obj-type
            and buf_rvs-line-pump.obj-code    = p-obj-code
            and buf_rvs-line-pump.pl-code     = p-pl-code
            and buf_rvs-line-pump.gds-code    = p-gds-code
            and buf_rvs-line-pump.pump-code   = buf_pl-pump-nozzle.pump-code
            and buf_rvs-line-pump.nozzle-code = buf_pl-pump-nozzle.nozzle-code
          no-error .
        if not available buf_rvs-line-pump then do:
          /* Если сверка по смене, то для бака с товаром должна существовать
          сверка в предыдущей смене или контрольная сверка в текущей смене */
          if available prev_rvs-line-pump then do:
            release prev_rvs-line-pump .
          end.
          if available crl_prev_rvs-doc then do:
            find first prev_rvs-line-pump no-lock
              where prev_rvs-line-pump.rvs-code    = crl_prev_rvs-doc.rvs-code
                and prev_rvs-line-pump.obj-type    = p-obj-type
                and prev_rvs-line-pump.obj-code    = p-obj-code
                and prev_rvs-line-pump.pl-code     = p-pl-code
                and prev_rvs-line-pump.gds-code    = p-gds-code
                and prev_rvs-line-pump.pump-code   = buf_pl-pump-nozzle.pump-code
                and prev_rvs-line-pump.nozzle-code = buf_pl-pump-nozzle.nozzle-code
              no-error .
          end.
          /* Не было остатка по баку за прошлую смену. Ищем закрытую сверку за текущую смену по этому баку */
          if not available prev_rvs-line-pump then do:
            prev:
            for each contr_rvs-doc no-lock where
                     contr_rvs-doc.obj-type   = p-obj-type                 and
                     contr_rvs-doc.obj-code   = p-obj-code                 and
                     contr_rvs-doc.shift-date = p-cur_shift-obj_shift-date and
                     contr_rvs-doc.shift-num  = p-cur_shift-obj_shift-num  and
                     contr_rvs-doc.status_    = {&fact}
            :
              find first prev_rvs-line-pump no-lock
                where prev_rvs-line-pump.rvs-code    = contr_rvs-doc.rvs-code
                  and prev_rvs-line-pump.obj-type    = p-obj-type
                  and prev_rvs-line-pump.obj-code    = p-obj-code
                  and prev_rvs-line-pump.pl-code     = p-pl-code
                  and prev_rvs-line-pump.gds-code    = p-gds-code
                  and prev_rvs-line-pump.pump-code   = buf_pl-pump-nozzle.pump-code
                  and prev_rvs-line-pump.nozzle-code = buf_pl-pump-nozzle.nozzle-code
                no-error .
              if available prev_rvs-line-pump then do:
                leave prev .
              end.
            end.
            if not available prev_rvs-line-pump and
               p-rvs-type = {&rvs-shift}
            then do:
              find first bf_goods no-lock where
                         bf_goods.gds-code = p-gds-code .
              undo tr, return error
              substitute( 'На объекте &1 &2 для резервуара &3 в котором находится топливо &4 &5 &6 &7 ТРК &8 '
                        + 'пистолет &9 нет сверки по смене за прошлую смену и нет ни одной контрольной сверки '
                        + 'за текущую смену.'
                        , p-obj-type
                        , p-obj-code
                        , p-pl-code
                        , bf_goods.artic
                        , bf_goods.prod-type
                        , bf_goods.prod-code
                        , bf_goods.gds-name
                        , buf_pl-pump-nozzle.pump-code
                        , buf_pl-pump-nozzle.nozzle-code ) .
            end.
          end.

          find first bf_pump-nozzle no-lock where
                     bf_pump-nozzle.obj-type    = buf_pl-pump-nozzle.obj-type    and
                     bf_pump-nozzle.obj-code    = buf_pl-pump-nozzle.obj-code    and
                     bf_pump-nozzle.pump-code   = buf_pl-pump-nozzle.pump-code   and
                     bf_pump-nozzle.nozzle-code = buf_pl-pump-nozzle.nozzle-code .
          if bf_pump-nozzle.is-meas = yes then do:
            find first bf_goods no-lock where
                       bf_goods.gds-code = p-gds-code .
            /* Ищем строку в инвентаризации счетчиков ТРК по данному счетчику */
            if available crl_prev_icnt-doc then do:
              find first prev_icnt-line no-lock where
                         prev_icnt-line.doc-code    = crl_prev_icnt-doc.doc-code and
                         prev_icnt-line.obj-type    = bf_pump-nozzle.obj-type    and
                         prev_icnt-line.obj-code    = bf_pump-nozzle.obj-code    and
                         prev_icnt-line.pump-code   = bf_pump-nozzle.pump-code   and
                         prev_icnt-line.nozzle-code = bf_pump-nozzle.nozzle-code no-error .
              if not available prev_icnt-line then do:
                 undo tr, return error substitute( 'Нет инвентаризации счетчика ТРК на ТРК &1 пистолет &2 через который '
                                                 + 'сейчас наливается бензин &3 &4 &5 &6'
                                                 , bf_pump-nozzle.pump-code
                                                 , bf_pump-nozzle.nozzle-code
                                                 , bf_goods.artic
                                                 , bf_goods.prod-type
                                                 , bf_goods.prod-code
                                                 , bf_goods.gds-name ) .
              end.
              /* Сверка на то, что через данный пистолет лил при инвентаризации наше топливо */
              if prev_icnt-line.gds-code <> bf_goods.gds-code then do:
                assign
                  varnoeqgds = yes
                .
                /* Если сверки по пистолету уже были после инвентаризации, то вопросов не задаем */
                if available prev_rvs-line-pump then do:
                   find first prev-contr_rvs-doc no-lock where
                              prev-contr_rvs-doc.rvs-code = prev_rvs-line-pump.rvs-code .
                   if prev-contr_rvs-doc.fact-order > crl_prev_icnt-doc.fact-order then do:
                     assign
                       varnoeqgds = no
                     .
                   end.
                end.
                if varnoeqgds = yes then do:
                  if prev_icnt-line.gds-code <> ? then do:
                    find first icnt-goods no-lock where
                               icnt-goods.gds-code = prev_icnt-line.gds-code .
                  end.
                  else do:
                    if p-quest_icnt-goods = no then do:
                      assign
                        varnoeqgds = no
                      .
                    end.
                  end.
                  if varnoeqgds = yes then do:
                    if p-quest_icnt-goods = no then do:
                      undo tr, return error
                      substitute( 'Несоответствие по товару, продающемуся через пистолет ТРК. В данный момент '
                                + 'реализуется товар &1 &2 &3 &4 . Во время инвентаризации через пистолет &5 ТРК &6 '
                                + 'реализовывался товар &7 &8 &9 .'
                                , bf_goods.artic
                                , bf_goods.prod-type
                                , bf_goods.prod-code
                                , bf_goods.gds-name
                                , buf_pl-pump-nozzle.nozzle-code
                                , buf_pl-pump-nozzle.pump-code
                                , icnt-goods.artic
                                , icnt-goods.prod-type
                                , icnt-goods.prod-code ) .
                    end. /* if p-quest_icnt-goods = no */
                    else do: /* if p-quest_icnt-goods = yes */
                      if p-message-on = yes then do:
                        assign
                          g-log = no
                        .
                        message 'Несоответствие по товару, продающемуся через пистолет ТРК.' skip
                                'В данный момент реализуется товар '
                                bf_goods.artic ' ' bf_goods.prod-type ' ' bf_goods.prod-code ' .' skip
                                'Во время инвентаризации через пистолет ' buf_pl-pump-nozzle.nozzle-code ' ТРК ' buf_pl-pump-nozzle.pump-code
                                ( if prev_icnt-line.gds-code <> ? then 'реализовывался товар ' +
                                                                       icnt-goods.artic               + ' ' +
                                                                       icnt-goods.prod-type           + ' ' +
                                                                       string( icnt-goods.prod-code ) + ' ' +
                                                                       icnt-goods.gds-name            + ' .'
                                                                 else 'товар не продавался.' )
                                'Будем делать сверку?'
                        view-as alert-box question buttons yes-no update g-log.
                        if g-log <> yes then do:
                          undo tr, return error return-value .
                        end.
                      end. /* message-on */
                    end. /* if p-quest_icnt-goods = yes */
                  end. /* no equal goods */
                end. /* no equal goods */
              end. /* if prev_icnt-line.gds-code <> bf_goods.gds-code */
            end. /* if available crl_prev_icnt-doc */
            else do: /* if not available crl_prev_icnt-doc */
              undo tr, return error substitute( 'ТРК &1 &2 &3 &4 измеряется прибором. '
                                              + 'Должен быть документ инвентаризации счетчиков ТРК.'
                                              , bf_pump-nozzle.obj-type
                                              , bf_pump-nozzle.obj-code
                                              , bf_pump-nozzle.pump-code
                                              , bf_pump-nozzle.nozzle-code ) .
            end. /* if not available crl_prev_icnt-doc */
          end. /* if bf_pump-nozzle.is-meas = yes */

          create buf_rvs-line-pump.
          assign
            buf_rvs-line-pump.rvs-code      = p-rvs-code
            buf_rvs-line-pump.obj-type      = p-obj-type
            buf_rvs-line-pump.obj-code      = p-obj-code
            buf_rvs-line-pump.pl-code       = p-pl-code
            buf_rvs-line-pump.gds-code      = p-gds-code
            buf_rvs-line-pump.pump-code     = buf_pl-pump-nozzle.pump-code
            buf_rvs-line-pump.nozzle-code   = buf_pl-pump-nozzle.nozzle-code
            buf_rvs-line-pump.rvs-prev-code = ( if available prev_rvs-line-pump then prev_rvs-line-pump.rvs-code else ? )
            buf_rvs-line-pump.icnt-code     = ( if available prev_icnt-line     then prev_icnt-line.doc-code     else ? )
            buf_rvs-line-pump.meas-el-cnt   = ?
            buf_rvs-line-pump.meas-am-cnt   = ?
            buf_rvs-line-pump.meas-cf-cnt   = ?
            buf_rvs-line-pump.meas-mh-cnt   = ?
            buf_rvs-line-pump.meas-am-qnty  = ?
            buf_rvs-line-pump.meas-cf-qnty  = ?
            buf_rvs-line-pump.meas-mh-qnty  = ?
            buf_rvs-line-pump.state-el-cnt  = ?
            buf_rvs-line-pump.state-am-cnt  = ?
            buf_rvs-line-pump.state-cf-cnt  = ?
            buf_rvs-line-pump.state-mh-cnt  = ?
            buf_rvs-line-pump.state-am-qnty = ?
            buf_rvs-line-pump.state-cf-qnty = ?
            buf_rvs-line-pump.state-mh-qnty = ?
          .
          find first other-line-pump no-lock
            where other-line-pump.rvs-code    = buf_rvs-line-pump.rvs-code
              and other-line-pump.obj-type    = buf_rvs-line-pump.obj-type
              and other-line-pump.obj-code    = buf_rvs-line-pump.obj-code
              and other-line-pump.gds-code    = buf_rvs-line-pump.gds-code
              and other-line-pump.pump-code   = buf_rvs-line-pump.pump-code
              and other-line-pump.nozzle-code = buf_rvs-line-pump.nozzle-code
          no-error .
          if available other-line-pump then do:
            assign
              buf_rvs-line-pump.state-am-cnt  = other-line-pump.state-am-cnt
              buf_rvs-line-pump.state-am-qnty = other-line-pump.state-am-qnty
              buf_rvs-line-pump.state-cf-cnt  = other-line-pump.state-cf-cnt
              buf_rvs-line-pump.state-cf-qnty = other-line-pump.state-cf-qnty
              buf_rvs-line-pump.state-el-cnt  = other-line-pump.state-el-cnt
              buf_rvs-line-pump.state-mh-cnt  = other-line-pump.state-mh-cnt
              buf_rvs-line-pump.state-mh-qnty = other-line-pump.state-mh-qnty
            .
          end. /* if available other-line-pump */
          
          /* Для виртуального резервуара */
          run placelib_get-attr(input {&place-virtual}
                           ,input buf_rvs-line-pump.obj-code
                           ,input buf_rvs-line-pump.obj-type
                           ,input buf_rvs-line-pump.pl-code
                           ,output v-value
                           ,output v-ok) no-error.

          is-vir = if (v-ok and logical(v-value)) then true else false.
          
          if is-vir then
            assign
            buf_rvs-line-pump.meas-el-cnt   = 0
            buf_rvs-line-pump.meas-am-cnt   = 0
            buf_rvs-line-pump.meas-cf-cnt   = 0
            buf_rvs-line-pump.meas-mh-cnt   = 0
            buf_rvs-line-pump.meas-am-qnty  = 0
            buf_rvs-line-pump.meas-cf-qnty  = 0
            buf_rvs-line-pump.meas-mh-qnty  = 0
            buf_rvs-line-pump.state-el-cnt  = 0
            buf_rvs-line-pump.state-am-cnt  = 0
            buf_rvs-line-pump.state-cf-cnt  = 0
            buf_rvs-line-pump.state-mh-cnt  = 0
            buf_rvs-line-pump.state-am-qnty = 0
            buf_rvs-line-pump.state-cf-qnty = 0
            buf_rvs-line-pump.state-mh-qnty = 0
            .
        end. /* if not available buf_rvs-line-pump */
      end. /* for each bf_pl-pump-nozzle */
    end. /* transaction */
  end. /* on error */
  return .
end procedure. /* lib-rvs_crrvslnp */

procedure lib-rvs_rvsplace : /* revision-place */

  define input        parameter           p-obj-type   like ub.rvs-doc.obj-type no-undo.
  define input        parameter           p-obj-code   like ub.rvs-doc.obj-code no-undo.
  define input        parameter           p-one-place  as   logical             no-undo.
  define input        parameter           p-read-cur   as   integer             no-undo.
  define input        parameter           p-message-on as   logical             no-undo.
  define input-output parameter table for tt-meas-file.
  define input-output parameter table for tt-meas.
  define buffer bf_pl-level     for ub.pl-level.
  define buffer bf-nxt_pl-level for ub.pl-level.

  do
  on error  undo, return error substitute( "&1(lib-rvs_rvsplace). &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
  on stop   undo, return error substitute( "&1(lib-rvs_rvsplace). stop", vss-workfile )
  on endkey undo, return error substitute( "&1(lib-rvs_rvsplace). endkey", vss-workfile )
  :

    

      define variable v-value       as character no-undo.
      define variable v-ok          as logical   no-undo.
      define variable pl-twice-code as character no-undo.
      define variable place-asi-sertif  as logical no-undo.
      define variable v-pl-code     as integer   no-undo.
      
    define variable anl-loc       like ub.place.loc1 no-undo.
    define variable v_string-tmp  as   character     no-undo.
    define variable v_command     as   character     no-undo.
    define variable v_File-Name   as   character     no-undo.
    define variable v-err-file-name as character no-undo .
    define variable is_FatalError as   logical       no-undo.
    define variable l_read        as   logical       no-undo.
    define variable j_num         as   integer       no-undo.
    define variable v_DirFilervs  as   character     no-undo.
    define variable l_log         as   logical       no-undo.
    define variable v_comstring   as   character     no-undo.
    define variable v_comment     as   character     no-undo.
    define variable v_StartString as   character     no-undo.
    define variable vartarirvalue as   character     no-undo.
    define variable vartarirtype  as   character     no-undo.
    define variable varlevel-sm   as   integer       no-undo.
    define variable ii            as   integer       no-undo.
    

 define variable tt-level-water as integer no-undo.
 define variable tt-level-water-dec as decimal no-undo.
define variable      v-water-qnty as decimal no-undo. 
    define variable v-bh as handle    no-undo .
    define variable v-fh as handle    no-undo .
    define buffer   bf-water-nxt_pl-level for pl-level.
      define variable varlevel-sm-water as decimal no-undo.
    define buffer bf_place for ub.place.
    define buffer buf_place for ub.place.
    define buffer buf_pl-gds for ub.pl-gds .
    run gbl/conf-rd.p ("tarir", "", "", 0, "", "", "", no, output vartarirvalue, output vartarirtype) no-error.
    
    { str/crtt-rvs.i
        tt-param
        v_comstring
        v_comment
        v_StartString
        no-error
    }
    if error-status :error then do:
      return error substitute( 'Ошибка при установке параметров для считывания данных с резервуаров.&1&2&1&3'
                            , {&new-line}
                            , error-status :get-message( 1 )
                            , return-value ) .
    end.

    empty temp-table tt-meas-file .
    
    /* Если запрос по одному баку */
    if p-one-place = yes then do:
      find first tt-meas no-error .
      if not available tt-meas then do:
        return error 'Ошибка. Данные по резервуару не найдены (возможно, не были считаны).' .
      end.
      find first bf_place no-lock
        where bf_place.obj-type = tt-meas.obj-type
          and bf_place.obj-code = tt-meas.obj-code
          and bf_place.pl-code  = tt-meas.pl-code
          and bf_place.status_ = ""
        no-error.
      assign
        anl-loc = trim( bf_place.loc1 )
      .
    end.
    else do:
      assign
        anl-loc = '0':U
      .
    end.
/*    if p-read-cur = ? then do:                                                             */
/*      if p-message-on = no then do:                                                        */
/*        assign                                                                             */
/*          p-read-cur = yes                                                                 */
/*        .                                                                                  */
/*      end.                                                                                 */
/*      else do:                                                                             */
/*        run gbl/d-askw.w                                                                   */
/*          (  input 'Выбор источника данных с информацией по резервуарам'                   */
/*          ,  input 'Будем читать текущие данные с резервуаров или возьмем данные из файла?'*/
/*          ,  input '|^'                                                                    */
/*          ,  input 'Текущие данные|Из файлов|Отмена'                                       */
/*          ,  input 'Запускается программа для обращения к датчикам резервуаров|'           */
/*          +        'Берутся уже сохраненные данные из файла|Ничего не делаем'              */
/*          ,  input 1                                                                       */
/*          ,  input 3                                                                       */
/*          , output j_num                                                                   */
/*          ) .                                                                              */
/*        case j_num :                                                                       */
/*          when 3 then do:                                                                  */
/*            return error .                                                                 */
/*          end.                                                                             */
/*          when 2 then do:                                                                  */
/*            assign                                                                         */
/*              p-read-cur = yes                                                             */
/*            .                                                                              */
/*          end.                                                                             */
/*          when 1 then do:                                                                  */
/*            assign                                                                         */
/*              p-read-cur = no                                                              */
/*            .                                                                              */
/*          end.                                                                             */
/*        end case.                                                                          */
/*      end.                                                                                 */
/*    end.                                                                                   */
    case p-read-cur :
      when 0
      then do :
        get-key-value section 'revision'
                      key     'dirflrvs'
                      value   v_DirFilervs.
        if v_DirFilervs = '':U
          or v_DirFilervs = ?
        then do:
          assign
            v_DirFilervs = '.':U
          .
        end.
        system-dialog get-file v_File-Name
          initial-dir v_DirFilervs
          title 'Выберите файл с данными из резервуаров'
          update l_log.
        if l_log <> yes then do:
          return error .
        end.
        
      end.
      when 1
      then do :
        assign
          v_File-Name = 'revis.txt':U
        .
        os-delete value( v_File-Name ) .
        if v_comstring = '':U
          or v_comstring = ?
        then do:
          return error 'Не задан парам. comstr в секции revision ini файла.' .
        end.
        assign
          anl-loc = '0':U
        .
        assign
          v_command = substitute( "&1 &2 &3 &4", v_comstring, string( anl-loc ), v_File-Name, p-obj-code)
        .
        os-command silent value( v_command ) .
        if search( v_File-Name ) = ? then do:
          return error 'Файл с прибора не получен.' .
        end.
        else do: 
          v_File-Name  = search( v_File-Name ) . 
        end.
  
        
      end.
      when 2 /* Агент */
      then do :
        run str/getAsiDataAgent.p (output v_File-Name) no-error.
        if error-status:error
        then do :
          return error return-value .
        end.
        
      end.
      when 3 /* ifsf */
      then do :
        run get-from-ifsf no-error.
        if error-status:error
        then do :
          return error return-value .
        end.
        v_File-Name = "revis.ifsf" .
        
      end.
    end case .
    /*
    if p-read-cur = yes then do:
      assign
        v_File-Name = 'revis.txt':U
      .
      os-delete value( v_File-Name ) .
      if v_comstring = '':U
        or v_comstring = ?
      then do:
        return error substitute('Не задан параметр &1', ibs.th.gbl.gbl-inipar:comstrKeyName) .
      end.
      assign
        anl-loc = '0':U
      .
      assign
        v_command = substitute( "&1 &2 &3 &4", v_comstring, string( anl-loc ), v_File-Name, p-obj-code)
      .
      os-command silent value( v_command ) .
      if search( v_File-Name ) = ? then do:
        return error 'Файл с прибора не получен.' .
      end.
      else do: 
     v_File-Name  = search( v_File-Name ) . 
     end.

    end.
    else do:
      
      v_DirFilervs = ibs.th.gbl.gbl-inipar:dirflrvs .
      if v_DirFilervs = '':U
        or v_DirFilervs = ?
      then do:
        assign
          v_DirFilervs = '.':U
        .
      end.
      system-dialog get-file v_File-Name
        initial-dir v_DirFilervs
        title 'Выберите файл с данными из резервуаров'
        update l_log.
      if l_log <> yes then do:
        return error .
      end.
    end.
*/
    v-err-file-name = substitute('&1revis.err', ibs.th.gbl.gbl-inipar:logDir) .
    input  stream str-anl from  value (  v_File-Name  )  .
    output stream str-err to    value (  v-err-file-name  ) .

    rpt:
    repeat :
         is_FatalError = no.
        pl-twice-code = "" . 
      import stream str-anl unformatted v_string-tmp.
      /* Отсекем комментарий */
      if index( v_string-tmp, v_comment ) > 0 then do:
          
        assign
          v_string-tmp = substring( v_string-tmp, 1, index( v_string-tmp, v_comment ) - 1 )
        .
      end.
      if v_string-tmp = '':U then next rpt .
      
      if index( v_string-tmp, v_StartString ) > 0 then do:
        /* перешли к новому баку, следует в старом баке проставить */
        assign
          l_read = no
        .
        /* Ищем бак в нашей системе */
        find first bf_place no-lock
          where bf_place.obj-type = p-obj-type
            and bf_place.obj-code = p-obj-code
            and bf_place.loc1     = trim( entry( 2, v_string-tmp, '=' ) )
            and bf_place.status_ = ""
          no-error.
          
          
          if not available bf_place  then 
          do:
              v-pl-code = ? .
              twice-code:  for each  place where place.obj-code =  p-obj-code and place.obj-type = p-obj-type and place.is-meas = yes : 
                  run placelib_get-attr  ( input {&place-twice-code}
                      ,input p-obj-code
                      ,input p-obj-type
                      ,input place.pl-code
                      ,output v-value
                      ,output v-ok      ) no-error.   
        
                  if v-ok then pl-twice-code = v-value .
                  if num-entries(pl-twice-code) > 1
                  then do :
                    do ii = 1 to num-entries(pl-twice-code) :
                      if trim( entry( ii, pl-twice-code ) ) = trim( entry( 2, v_string-tmp, '=' ) )
                      then do :
                        pl-twice-code = trim( entry( ii, pl-twice-code ) ) .
                        v-pl-code = place.pl-code .
                        leave twice-code.
                      end.
                    end.
                  end.
                  else do :
                    if pl-twice-code =  trim( entry( 2, v_string-tmp, '=' ) )
                    then do :
                      v-pl-code = place.pl-code .
                      leave twice-code.
                    end.
                  end.
                  pl-twice-code = "" .
                  v-pl-code = ? .
              end.
              
              if pl-twice-code = ""  then 
              do: 
          put stream str-err unformatted
            substitute( '&2 Не найден резервуар по системе с локальным кодом(коорд1) &1 .'
                      , trim( entry( 2, v_string-tmp, '=' ) )
                      , cur-time-string-sec()
                      ) skip .
          assign
            is_FatalError = yes
          .
          next rpt .
        end.
          end.
          
          if   pl-twice-code = "" and available bf_place then 
          do: 
              if bf_place.is-meas = no   then 
              do:
          put stream str-err unformatted
            substitute( '&3 Получены данные с приборов по резервуару &1 '
                      + 'с локальным кодом(коорд1) &2, определенного в системе как неизмеряемый.'
                      , bf_place.pl-code
                      , trim( entry( 2, v_string-tmp, '=' ) ) 
                      , cur-time-string-sec()
                      ) skip .
          assign
            is_FatalError = yes
          .
          next rpt .
        end.
          end.
          if   pl-twice-code = "" then 
          do: 
              create tt-meas-file.
              assign
                  tt-meas-file.obj-type = p-obj-type
                  tt-meas-file.obj-code = p-obj-code
                  tt-meas-file.pl-code  = bf_place.pl-code
                  tt-meas-file.loc1     = bf_place.loc1
              no-error .
              if error-status:error then do:
                put stream str-err unformatted
                  substitute( '&4 Ошибка принятия к обработке резервуара id &1 с локальным кодом(коорд1) &2 &3'
                       , bf_place.pl-code
                       , bf_place.loc1
                       , error-status:get-message(1)
                       , cur-time-string-sec()
                  )
                  skip
                .
                is_FatalError = yes.
                undo, leave rpt .
              end .
              l_read = yes .
          end.
          else 
          do: 
              create tt-meas-file.
              assign
                  tt-meas-file.obj-type = p-obj-type
                  tt-meas-file.obj-code = p-obj-code
                  /*          tt-meas-file.pl-code  = bf_place.pl-code*/
                  tt-meas-file.loc1     = pl-twice-code
              no-error .
              if error-status:error then do:
                put stream str-err unformatted
                  substitute( '&3 Ошибка принятия к обработке резервуара с локальным кодом(коорд1) &1 &2'
                       , pl-twice-code
                       , error-status:get-message(1)
                       , cur-time-string-sec()
                  )
                  skip
                .
                is_FatalError = yes.
                undo, leave rpt .
              end .
              l_read = yes .
          end.
      end.
      else do:
        /* если резервуар корректный, то читаем по нему данные */
        if l_read = yes then do:
          find first tt-param
            where tt-param.strfrfile = trim( entry( 1, v_string-tmp, '=' ) )
            no-error.
          if available tt-param then do:
            assign
              v-bh = buffer tt-meas-file:handle
            .
            case tt-param.flddb :
              when 'measure-qnty':U
              or when 'brutto-qnty':U
              or when 'measure-cli-qnty':U
              or when 'brutto-cli-qnty':U
              or when 'density':U
              or when 'temperature':U
              or when 'level-total':U
              or when 'level-petrol':U
              or when 'level-water':U
              or when 'temp-layer1':U
              or when 'temp-layer2':U
              or when 'temp-layer3':U
              or when 'measure-tc-qnty':U
              or when 'brutto-tc-qnty':U
              or when 'water-qnty':U
              or when 'vapor-density':U
              or when 'vapor-pressure':U
              then do:
                assign
                  v-fh                = v-bh:buffer-field( tt-param.flddb )
                  v-fh:buffer-value() = decimal( trim( entry( 2, v_string-tmp, '=' ) ) )
                .
              end.
            end case.
            if tt-param.strfrfile = 'temperature':U   then do:
              assign
                tt-meas-file.temp-not-null   = yes
              .
            end.
            if tt-param.strfrfile = 'temp-layer1':U   then do:
              assign
                tt-meas-file.t1-not-null   = yes
              .
            end.
            if tt-param.strfrfile = 'temp-layer2':U   then do:
              assign
                tt-meas-file.t2-not-null   = yes
              .
            end.
            if tt-param.strfrfile = 'temp-layer3':U   then do:
              assign
                tt-meas-file.t3-not-null   = yes
              .
            end.
            if tt-param.strfrfile = 'volume_oil':U   then do:
              assign
                tt-meas-file.meas-vol-oil   = yes
              .
            end.
            if tt-param.strfrfile = 'volume_water':U then do:
              assign
                tt-meas-file.meas-vol-water = yes
              .
            end.
            if tt-param.strfrfile = 'mass_total':U  then 
            do: 
              run placelib_get-attr  ( input {&place-asi-sertif}
                ,input p-obj-code
                ,input p-obj-type
                ,input (if tt-meas-file.pl-code <> 0 then tt-meas-file.pl-code else v-pl-code)
                ,output v-value
                ,output v-ok      ) no-error.
              if v-ok and v-value = "yes" then do: 
                if trim( entry( 2, v_string-tmp, '=' ) )  <> "-" and trim( entry( 2, v_string-tmp, '=' ) )  <> "" then 
                do:
                  assign
                    tt-meas-file.log-brutto       = yes
                    tt-meas-file.measure-cli-qnty = decimal( trim( entry( 2, v_string-tmp, '=' ) ) )
                    . 
                end.
              end.
            end.  
          end.
          else do:
            put stream str-err unformatted
              substitute('&2 Неизвестный параметр: &1'
                         , trim( entry(1, v_string-tmp, '=') )
                         , cur-time-string-sec()
                         ) skip .
          end.
        end. /* читаем данные по резервуару */
      end. /* не номер танка */
    end. /* repeat rpt */

    if is_FatalError = no then do:
    _recalc:
    for each tt-meas-file
          on error undo, return error return-value
          :
            
          if tt-meas-file.pl-code <> 0
          then do :
            find first buf_place no-lock where buf_place.obj-type = p-obj-type
                                           and buf_place.obj-code = p-obj-code
                                           and buf_place.pl-code  = tt-meas-file.pl-code
                                           and buf_place.is-meas  = yes
                                           no-error .
          end.
          else do :
            twice-code:
            for each  buf_place where buf_place.obj-code = p-obj-code
                                  and buf_place.obj-type = p-obj-type
                                  and buf_place.is-meas  = yes : 
                run placelib_get-attr  ( input {&place-twice-code}
                    ,input p-obj-code
                    ,input p-obj-type
                    ,input buf_place.pl-code
                    ,output v-value
                    ,output v-ok      ) no-error.   
      
                if v-ok then pl-twice-code = v-value .
                if num-entries(pl-twice-code) > 1
                then do :
                  do ii = 1 to num-entries(pl-twice-code) :
                    if trim( entry( ii, pl-twice-code ) ) = trim( tt-meas-file.loc1 )
                    then do :
                      leave twice-code.
                    end.
                  end.
                end.
                else do :
                  if trim(pl-twice-code) =  trim( tt-meas-file.loc1 ) then leave twice-code.
                end.
                pl-twice-code = "" .
            end.
          end.
          
          if available buf_place
          then do :
            find first buf_pl-gds no-lock where buf_pl-gds.obj-type     = buf_place.obj-type
                                            and buf_pl-gds.obj-code     = buf_place.obj-code
                                            and buf_pl-gds.pl-code      = buf_place.pl-code
                                            and buf_pl-gds.status_      = {&current-status}
                                            no-error .
            if available buf_pl-gds
            and is-sug(buf_pl-gds.gds-code) then next _recalc.                                
          end.  
          
          place-asi-sertif = no .  
          run placelib_get-attr  ( input {&place-asi-sertif}
                                ,input p-obj-code
                                ,input p-obj-type
                                ,input (if tt-meas-file.pl-code <> 0 then tt-meas-file.pl-code else v-pl-code)
                                ,output v-value
                                ,output v-ok      ) no-error.
          if v-ok then place-asi-sertif = logical(v-value) .                      
        
          /*Если работаем по тарировочным таблицам*/
          if tt-meas-file.meas-vol-oil   = no and
              vartarirvalue = "yes"  
              and tt-meas-file.log-brutto = no
/*              and not place-asi-sertif*/
/*              and rdc-value <> "pomi-rn"*/
              then 
          do:
  
              if tt-meas-file.level-total = ? then 
              do:
                  assign
                      is_FatalError = yes
                      .
                  put stream str-err unformatted
                    substitute("&2 Вычисляем объем резервуаров через градуировочные таблицы. Для резервуара &1 не задан уровень в резервуаре."
                      , tt-meas-file.loc1
                      , cur-time-string-sec()
                     ) skip.
              end.
              else 
              do:
                  assign
                      varlevel-sm = trunc (tt-meas-file.level-total, 0).
        
                  find first bf_pl-level where bf_pl-level.obj-type = tt-meas-file.obj-type and
                      bf_pl-level.obj-code = tt-meas-file.obj-code and
                      bf_pl-level.pl-code  = tt-meas-file.pl-code  and
                      bf_pl-level.pl-level = varlevel-sm           no-error.
                  if not available bf_pl-level then 
                  do:  
                      if tt-meas-file.pl-code <> 0 then 
                      do: 
                          assign
                              is_FatalError = yes
                              .
                          put stream str-err unformatted
                            substitute("&3 Вычисляем объем резервуаров через градуировочные таблицы. Для резервуара &1 не задан объем для уровня &2" 
                            , tt-meas-file.loc1
                            , varlevel-sm 
                            , cur-time-string-sec()
                            ) skip.
                      end.
                  end.
                  else 
                  do:
                      if varlevel-sm = tt-meas-file.level-total then 
                      do:
                          assign
                              tt-meas-file.brutto-qnty      = bf_pl-level.pl-qnty
                              tt-meas-file.brutto-cli-qnty  = tt-meas-file.density * tt-meas-file.brutto-qnty
                              tt-meas-file.measure-qnty     = tt-meas-file.brutto-qnty
                              tt-meas-file.measure-cli-qnty = tt-meas-file.measure-qnty * tt-meas-file.density
                              .
                      end.
                      else 
                      do:
                          assign
                              varlevel-sm = varlevel-sm + 1.
                          find first bf-nxt_pl-level where bf-nxt_pl-level.obj-type = tt-meas-file.obj-type and
                              bf-nxt_pl-level.obj-code = tt-meas-file.obj-code and
                              bf-nxt_pl-level.pl-code  = tt-meas-file.pl-code  and
                              bf-nxt_pl-level.pl-level  = varlevel-sm           no-error.
                          if not available bf-nxt_pl-level then 
                          do:
                              assign
                                  is_FatalError = yes
                                  .
                              put stream str-err unformatted
                                substitute("&4 Вычисляем объем резервуаров через градуировочные таблицы. Для резервуара &1 не задан объем для уровня &2 измерение &3"
                                , tt-meas-file.loc1
                                , varlevel-sm
                                , tt-meas-file.level-total
                                , cur-time-string-sec()
                                ) skip.
                          end.
                          else 
                          do:

                              assign
                                  tt-meas-file.brutto-qnty      = bf_pl-level.pl-qnty + (bf-nxt_pl-level.pl-qnty - bf_pl-level.pl-qnty) * (tt-meas-file.level-total - trunc(tt-meas-file.level-total, 0))
                                  tt-meas-file.brutto-cli-qnty  = tt-meas-file.density * tt-meas-file.brutto-qnty
                                  tt-meas-file.measure-qnty     = tt-meas-file.brutto-qnty
                                  tt-meas-file.measure-cli-qnty = tt-meas-file.measure-qnty * tt-meas-file.density.
                          end.           
                      end.
                      if  tt-meas-file.meas-vol-water = no  and tt-meas-file.level-water <> 0  then
                      do:

                          find first bf-nxt_pl-level where bf-nxt_pl-level.obj-type = tt-meas-file.obj-type and
                              bf-nxt_pl-level.obj-code = tt-meas-file.obj-code and
                              bf-nxt_pl-level.pl-code  = tt-meas-file.pl-code  and
                              bf-nxt_pl-level.pl-level  =    tt-meas-file.level-water    no-error.

                          if  not available bf-nxt_pl-level then
                          do:
                              assign
                                  varlevel-sm-water = tt-meas-file.level-water + 1.
                              for each  bf-water-nxt_pl-level where bf-water-nxt_pl-level.obj-type = tt-meas-file.obj-type and
                                  bf-water-nxt_pl-level.obj-code = tt-meas-file.obj-code and
                                  bf-water-nxt_pl-level.pl-code  = tt-meas-file.pl-code  and
                                  bf-water-nxt_pl-level.pl-level  <  varlevel-sm-water   and        
                                  bf-water-nxt_pl-level.pl-level > tt-meas-file.level-water - 1 no-lock  :  
                                  v-water-qnty = abs (  abs (v-water-qnty )  -  bf-water-nxt_pl-level.pl-qnty / 10 )  .
                                  
                                  if  bf-water-nxt_pl-level.pl-level > tt-meas-file.level-water - 1 and bf-water-nxt_pl-level.pl-level < tt-meas-file.level-water then 
                                  do: 
                                      tt-level-water =  bf-water-nxt_pl-level.pl-qnty.
                                      tt-level-water-dec = tt-meas-file.level-water - bf-water-nxt_pl-level.pl-level .
                                  end.
                              end. 
                              tt-meas-file.water-qnty =  tt-level-water +  tt-level-water-dec *  v-water-qnty * 10  . 
                          end.
                          else
                          do:
                              assign
                                  tt-meas-file.water-qnty = bf-nxt_pl-level.pl-qnty  .
                          end.
                      end.
                      
                  end.
              end.
          end.
        if vartarirvalue = "no" or vartarirvalue = "" then 
        do:
          if tt-meas-file.log-brutto = yes then 
          do:
              if place-asi-sertif
              then do :
                assign
                  tt-meas-file.measure-qnty = tt-meas-file.measure-cli-qnty / tt-meas-file.density
                  tt-meas-file.water-qnty =  tt-meas-file.brutto-qnty - tt-meas-file.measure-qnty 
                .
                if tt-meas-file.water-qnty < 0 then tt-meas-file.water-qnty = 0 .
              end.
              else
              if tt-meas-file.brutto-qnty <> 0 or tt-meas-file.brutto-qnty <> ? then 
              do:
                assign
                  tt-meas-file.density         = tt-meas-file.measure-cli-qnty / tt-meas-file.brutto-qnty
                  tt-meas-file.measure-qnty    = tt-meas-file.brutto-qnty
                  tt-meas-file.brutto-cli-qnty = tt-meas-file.density * tt-meas-file.brutto-qnty
                  .
              end.
              else 
              do:
                put stream str-err unformatted 
                  'Не заданы объем и плотность'  skip .
              end.    
          end.  
        end.  

                if tt-meas-file.level-petrol  = 0 and
                   tt-meas-file.level-total  <> 0 then do:
                  assign
                    tt-meas-file.level-petrol = tt-meas-file.level-total - tt-meas-file.level-water.
                end.
        
        if tt-meas-file.meas-vol-oil   = no
            and tt-meas-file.meas-vol-water = no
            then 
        do:
            /* Если один из трех счетных параметров не задан, то зададим его */
            if tt-meas-file.density <> 0 and
                tt-meas-file.density <> ?
                then 
            do:
                if ( tt-meas-file.brutto-cli-qnty =  0   or
                    tt-meas-file.brutto-cli-qnty =  ? ) and
                    tt-meas-file.brutto-qnty     <> 0   and
                    tt-meas-file.brutto-qnty     <> ?
                    then 
                do:
                    assign
                        tt-meas-file.brutto-cli-qnty = tt-meas-file.density * tt-meas-file.brutto-qnty
                        .
                end.
                if ( tt-meas-file.brutto-qnty     =  0   or
                    tt-meas-file.brutto-qnty     =  ? ) and
                    tt-meas-file.brutto-cli-qnty <> 0   and
                    tt-meas-file.brutto-cli-qnty <> ?
                    then 
                do:
                    assign
                        tt-meas-file.brutto-qnty = tt-meas-file.brutto-cli-qnty / tt-meas-file.density
                        .
                end.
            end.
            else 
            do:
                if tt-meas-file.brutto-cli-qnty <> 0 and
                    tt-meas-file.brutto-cli-qnty <> ? and
                    tt-meas-file.brutto-qnty     <> 0 and
                    tt-meas-file.brutto-qnty     <> ?
                    then 
                do:
                    assign
                        tt-meas-file.density = tt-meas-file.brutto-cli-qnty / tt-meas-file.brutto-qnty
                        .
                end.
            end.
            if tt-meas-file.log-brutto
            then do :
              tt-meas-file.measure-qnty = tt-meas-file.measure-cli-qnty / tt-meas-file.density .
              tt-meas-file.water-qnty = tt-meas-file.brutto-qnty - tt-meas-file.measure-qnty  .
              if tt-meas-file.water-qnty < 0
              then do :
                tt-meas-file.water-qnty = 0 .
                tt-meas-file.brutto-qnty = tt-meas-file.measure-qnty .
              end.
            end.
            else do : 
              assign
                tt-meas-file.measure-qnty = tt-meas-file.brutto-qnty -  tt-meas-file.water-qnty
                tt-meas-file.measure-cli-qnty = tt-meas-file.measure-qnty * tt-meas-file.density
              .
            end.
         
        end.
        else 
        do:
            /* Если считалась только вода и брутто, то восстанавливаем объем топлива */
            if tt-meas-file.meas-vol-oil = no then 
            do:
                assign
                    tt-meas-file.measure-qnty = tt-meas-file.brutto-qnty - tt-meas-file.water-qnty
                    .
            end.
            if tt-meas-file.meas-vol-oil = yes and tt-meas-file.meas-vol-water = no then do:
                assign
                    tt-meas-file.water-qnty = tt-meas-file.brutto-qnty - tt-meas-file.measure-qnty
                    .
            end.  
            if tt-meas-file.log-brutto
            then do :
              tt-meas-file.measure-qnty = tt-meas-file.measure-cli-qnty / tt-meas-file.density .
              tt-meas-file.water-qnty = tt-meas-file.brutto-qnty - tt-meas-file.measure-qnty  .
              if tt-meas-file.water-qnty < 0
              then do :
                tt-meas-file.water-qnty = 0 .
                tt-meas-file.brutto-qnty = tt-meas-file.measure-qnty .
              end.
            end.
            else do : 
              assign
                tt-meas-file.measure-cli-qnty = tt-meas-file.measure-qnty * tt-meas-file.density
              .
            end.
        end.
/*    end.*/
      /* Если уровень воды нулевой, но при этом вес общий, который пришел с видерута, меньше, чем то, что мы расчитали исходя из плотности, то подставляем расчетное значение.  Иначе вода лезет в минус */
      if tt-meas-file.meas-vol-water and tt-meas-file.level-water  = 0 and abs(tt-meas-file.brutto-cli-qnty - tt-meas-file.measure-cli-qnty) <= 0.1 then tt-meas-file.brutto-cli-qnty = tt-meas-file.measure-cli-qnty.
    end. /* for each tt-meas-file */

    /* Сравниваем запрос и полученные данные */
    for each tt-meas
    on error undo, return error return-value
    :
      find first tt-meas-file where
                tt-meas-file.obj-type = tt-meas.obj-type and
                tt-meas-file.obj-code = tt-meas.obj-code and
                tt-meas-file.pl-code  = tt-meas.pl-code  no-error .
      if not available tt-meas-file then do:
        if p-one-place = ? then do:
          delete tt-meas.
          next.
        end.
        else do:
          assign
            is_FatalError = yes
          .
          put stream str-err unformatted
            substitute( '&2 Не получены данные по резервуару &1 .'
                      , tt-meas.pl-code
                      , cur-time-string-sec()
                       ) skip .
        end.
      end. /* if not available tt-meas-file */
    end. /* tt-meas */
    for each tt-meas-file
    on error undo, return error return-value
    :
      find first tt-meas where
                tt-meas.obj-type = tt-meas-file.obj-type and
                tt-meas.obj-code = tt-meas-file.obj-code and
                tt-meas.pl-code  = tt-meas-file.pl-code  and
                tt-meas.loc1     = tt-meas-file.loc1 no-error .
      if not available tt-meas then do:
          if tt-meas-file.loc1 <> "" and tt-meas-file.pl-code = 0  then 
          do: 
              create tt-meas .
              assign
                  tt-meas.obj-type = tt-meas-file.obj-type 
                  tt-meas.obj-code = tt-meas-file.obj-code 
                  tt-meas.loc1     = tt-meas-file.loc1 no-error.
          end.
          else 
          do: 
              if p-one-place = ? then 
              do:
          assign
            is_FatalError = yes
          .
        end.
        put stream str-err unformatted
          substitute( '&2 Получены данные по резервуару &1 по которому нет запроса.'
                     , tt-meas-file.pl-code
                     , cur-time-string-sec()
                      ) skip .
      end.
      end.
    end. /* tt-meas-file */
    end . /* end of if_is_FatalError = no  */
    input  stream str-anl close.

    if is_FatalError = yes then do:
      return error 'При считывании данных с резервуаров произошли ошибки НЕПОЗВОЛЯЮЩИЕ ЗАГРУЗИТЬ ДАННЫЕ.' .
    end.

    for  each tt-meas,
      first tt-meas-file
      where tt-meas-file.obj-type = tt-meas.obj-type
        and tt-meas-file.obj-code = tt-meas.obj-code
        and ((tt-meas-file.pl-code  = tt-meas.pl-code
        and tt-meas.pl-code <> 0) or tt-meas-file.loc1 = tt-meas.loc1) 
        
    on error undo, return error return-value
    :
      assign
        tt-meas.measure-qnty     = tt-meas-file.measure-qnty
        tt-meas.brutto-qnty      = tt-meas-file.brutto-qnty
        tt-meas.measure-cli-qnty = tt-meas-file.measure-cli-qnty
        tt-meas.brutto-cli-qnty  = tt-meas-file.brutto-cli-qnty
        tt-meas.density          = tt-meas-file.density
        tt-meas.temperature      = (if tt-meas-file.temp-not-null then tt-meas-file.temperature else ?)
        tt-meas.level-total      = tt-meas-file.level-total
        tt-meas.level-petrol     = tt-meas-file.level-petrol
        tt-meas.level-water      = tt-meas-file.level-water
        tt-meas.temp-layer1      = (if tt-meas-file.t1-not-null then tt-meas-file.temp-layer1 else ?)
        tt-meas.temp-layer2      = (if tt-meas-file.t2-not-null then tt-meas-file.temp-layer2 else ?)
        tt-meas.temp-layer3      = (if tt-meas-file.t3-not-null then tt-meas-file.temp-layer3 else ?)
        tt-meas.measure-tc-qnty  = tt-meas-file.measure-tc-qnty
        tt-meas.brutto-tc-qnty   = tt-meas-file.brutto-tc-qnty
        tt-meas.vapor-density    = tt-meas-file.vapor-density
        tt-meas.vapor-pressure   = tt-meas-file.vapor-pressure
        tt-meas.water-qnty       = tt-meas-file.water-qnty
      .
    end. /* for each */
end.
  return .
  
  finally:
    input  stream str-anl close.
    put stream str-err unformatted skip(0) .
    output stream str-err close.

    define variable v-save-file-name as character no-undo .
    v-save-file-name = substitute("&1rvs-err.log", ibs.th.gbl.gbl-inipar:logDir) .
    OS-APPEND value(v-err-file-name) value(v-save-file-name).
  end finally .
end procedure. /* lib-rvs_rvsplace */

procedure lib-rvs_fill1plc : /* fill-one-place */
  define input        parameter           p-obj-type  like ub.rvs-line.obj-type no-undo.
  define input        parameter           p-obj-code  like ub.rvs-line.obj-code no-undo.
  define input        parameter           p-pl-code   like ub.rvs-line.pl-code  no-undo.
  define input        parameter           p-rec-line  as   recid                no-undo.
  define input        parameter           p-prev-code like ub.rvs-doc.rvs-code  no-undo.
  define input-output parameter table for tt-meas.

    DEFINE VARIABLE rdc-dnstvalue AS CHARACTER NO-UNDO INITIAL ?.
    DEFINE VARIABLE rdc-dnsttype  AS CHARACTER NO-UNDO INITIAL ?.
    
  define variable varnum-rsrv  as integer   no-undo.
  define variable v-code            as character no-undo.
  define variable ii                as integer   no-undo.
  define variable v-value           as character no-undo.
  define variable v-ok              as logical   no-undo.
  define variable  p-prev-rvs-date  as logical no-undo.

    /*параметры для видеонаблюдения */
    define variable v-vid-ok  as logical   no-undo .
    define variable v-vid-mes as character no-undo .
    define variable v-vid-action as integer    no-undo .
    define variable v-vid-param  as longchar   no-undo .  
    /*параметры для работы с библиотекой ПО МИ*/
    define variable v-mm         as com-handle.
    define variable v-proc       as character  no-undo.

  define variable place-type        as integer no-undo.
  define variable place-SI          as integer no-undo.
  define variable place-diameter    as decimal no-undo.
  define variable place-ratio-error as decimal no-undo.
  define variable place-asi-sertif  as logical no-undo.
  define variable dens-prov         as decimal no-undo format "9.9999999999":U.
  define variable pl-twice-code as character no-undo.
  define variable CalibTable        as character no-undo initial "".
  define variable ToolType          as integer no-undo.
  define variable A_LevelMeasurementTool  as decimal no-undo.
  define variable DeltaAbs_H              as decimal no-undo.
  define variable DeltaAbs_H_Water        as decimal no-undo.
  define variable DeltaAbs_R              as decimal no-undo.
  define variable DeltaAbs_Tv             as decimal no-undo.
  define variable DeltaAbs_Tr             as decimal no-undo.
  define variable DeltaOtn_N              as decimal no-undo.
  define variable DeltaOtn_K              as decimal no-undo.
  define variable mass-float-cov          as decimal no-undo format ">>,>>9.999":U.
  define variable temp-for-pomi           as integer no-undo.
  define variable error-string            as character no-undo.
  define variable v-mm-density            as decimal no-undo.
  /*........................................*/
        define variable v-full-name as character no-undo .
define variabl v-file-name as character no-undo.
  define buffer crl_prev_rvs-doc for ub.rvs-doc.
  define buffer prev_rvs-line    for ub.rvs-line.
  define buffer bf_goods         for ub.goods.
  define buffer bf_gds-obj       for ub.gds-obj.
  define buffer bf-prev_doc-line for ub.doc-line.
  define buffer bf-prev_inv-line for ub.inv-line.
  define buffer bf-prp_goods     for ub.goods.
  define buffer bf-prp_pl-gds    for ub.pl-gds.
  define buffer bf_rvs-line      for ub.rvs-line.
/*  define buffer buf_clob-bind    for ub.clob-bind.*/
  define buffer buf_sr-izmerenia for ub.sr-izmerenia .
  define buffer buf_doc-attr     for ub.doc-attr.
  define buffer buf_tt-meas      for tt-meas .
  define variable  v-cardif as integer no-undo.

  define variable v-delta-mas-qnty as decimal no-undo.
  define variable v-is-olddens as logical no-undo .
  
  define variable twice-num   as integer no-undo.
  define variable twice-place-data as character no-undo .
  define variable sug-density as decimal no-undo .
  define variable sug-water-qnty as decimal no-undo .
  define variable vapor-density as decimal no-undo .
  define variable vapor-pressure as decimal no-undo .

  find first bf_rvs-line exclusive-lock
    where recid( bf_rvs-line ) = p-rec-line
  .
  find first tt-meas
    where tt-meas.obj-type = p-obj-type
      and tt-meas.obj-code = p-obj-code
      and tt-meas.pl-code  = p-pl-code
    no-error.
  if not available tt-meas then do:
    return error substitute( 'Ошибка. С приборов не получены данные по резервуару &1 .'
                           , p-pl-code ) .
  end.
    find first tt-meas-file
    where tt-meas-file.obj-type = tt-meas.obj-type
      and tt-meas-file.obj-code = tt-meas.obj-code
      and tt-meas-file.pl-code  = tt-meas.pl-code
    no-error.
  
  { gbl/ptrlprop.i run p-obj-type p-obj-code }

  assign
    bf_rvs-line.measure-qnty           = tt-meas.measure-qnty
    bf_rvs-line.brutto-qnty            = tt-meas.brutto-qnty
    bf_rvs-line.measure-cli-qnty       = tt-meas.measure-cli-qnty
    bf_rvs-line.brutto-cli-qnty        = tt-meas.brutto-cli-qnty
    bf_rvs-line.level-total            = tt-meas.level-total
    bf_rvs-line.level-petrol           = tt-meas.level-petrol
    bf_rvs-line.level-water            = tt-meas.level-water
    bf_rvs-line.temp-layer1            = tt-meas.temp-layer1
    bf_rvs-line.temp-layer2            = tt-meas.temp-layer2
    bf_rvs-line.temp-layer3            = tt-meas.temp-layer3
    bf_rvs-line.measure-tc-qnty        = tt-meas.measure-tc-qnty
    bf_rvs-line.brutto-tc-qnty         = tt-meas.brutto-tc-qnty
/*    bf_rvs-line.density                = if tt-meas.density > 0 then tt-meas.density else  bf_rvs-line.state-density         */
/*    bf_rvs-line.state-density          = if  bf_rvs-line.density > 0 then  bf_rvs-line.density else bf_rvs-line.state-density*/
    bf_rvs-line.state-measure-qnty     = bf_rvs-line.measure-qnty
    bf_rvs-line.state-brutto-qnty      = bf_rvs-line.brutto-qnty

/*    bf_rvs-line.density                =   bf_rvs-line.brutto-cli-qnty /  bf_rvs-line.measure-qnty*/
    bf_rvs-line.state-level-total      = bf_rvs-line.level-total
    bf_rvs-line.state-level-petrol     = bf_rvs-line.level-petrol
    bf_rvs-line.state-level-water      = bf_rvs-line.level-water
    bf_rvs-line.state-temp-layer1      = bf_rvs-line.temp-layer1
    bf_rvs-line.state-temp-layer2      = bf_rvs-line.temp-layer2
    bf_rvs-line.state-temp-layer3      = bf_rvs-line.temp-layer3
    bf_rvs-line.state-measure-tc-qnty  = bf_rvs-line.measure-tc-qnty
    bf_rvs-line.state-brutto-tc-qnty   = bf_rvs-line.brutto-tc-qnty
  .


  find first rvs-line-attr exclusive-lock
       where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
         and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
         and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
         and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
         and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
         and rvs-line-attr.attr-code = "input-type" no-error.
  if not available rvs-line-attr then do :
    create rvs-line-attr.
    assign
      rvs-line-attr.obj-code  = bf_rvs-line.obj-code
      rvs-line-attr.obj-type  = bf_rvs-line.obj-type
      rvs-line-attr.gds-code  = bf_rvs-line.gds-code
      rvs-line-attr.pl-code   = bf_rvs-line.pl-code
      rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
      rvs-line-attr.attr-code = "input-type"
    .
  end.
  rvs-line-attr.attr-value = 'а' .







place-asi-sertif = no .  
run placelib_get-attr  ( input {&place-asi-sertif}
                      ,input p-obj-code
                      ,input p-obj-type
                      ,input p-pl-code
                      ,output v-value
                      ,output v-ok      ) no-error.
if v-ok then place-asi-sertif = logical(v-value) .



if ptrlprop-olddens = true
and not is-sug(bf_rvs-line.gds-code)
then do:
  if tt-meas.density = 0 then do:
    assign
      tt-meas.temperature                = bf_rvs-line.state-temperature
      tt-meas.density                    = bf_rvs-line.state-density  
    .
    find first rvs-line-attr exclusive-lock
         where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
           and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
           and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
           and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
           and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
           and rvs-line-attr.attr-code = "is-olddens" no-error.
    if not available rvs-line-attr then do :
      create rvs-line-attr.
      assign
        rvs-line-attr.obj-code  = bf_rvs-line.obj-code
        rvs-line-attr.obj-type  = bf_rvs-line.obj-type
        rvs-line-attr.gds-code  = bf_rvs-line.gds-code
        rvs-line-attr.pl-code   = bf_rvs-line.pl-code
        rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
        rvs-line-attr.attr-code = "is-olddens"
      .
    end.
    rvs-line-attr.attr-value = 'yes' .
  end.    
  else do :
    find first rvs-line-attr exclusive-lock
         where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
           and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
           and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
           and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
           and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
           and rvs-line-attr.attr-code = "is-olddens" no-error.
    if not available rvs-line-attr then do :
      create rvs-line-attr.
      assign
        rvs-line-attr.obj-code  = bf_rvs-line.obj-code
        rvs-line-attr.obj-type  = bf_rvs-line.obj-type
        rvs-line-attr.gds-code  = bf_rvs-line.gds-code
        rvs-line-attr.pl-code   = bf_rvs-line.pl-code
        rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
        rvs-line-attr.attr-code = "is-olddens"
      .
    end.
    rvs-line-attr.attr-value = 'no' .
  end.
  if tt-meas.temperature = 0 then do:
      tt-meas.temperature                = bf_rvs-line.state-temperature .      
  end. 
 end.    
 
  assign
    sug-density = tt-meas.density
    vapor-density = tt-meas.vapor-density
    vapor-pressure = tt-meas.vapor-pressure
    sug-water-qnty = tt-meas.water-qnty
  .
  
  if is-sug(bf_rvs-line.gds-code)
  then do :
    assign
      bf_rvs-line.temperature            = tt-meas.temperature    
      bf_rvs-line.state-temperature      = bf_rvs-line.temperature
      bf_rvs-line.density                = tt-meas.density
      bf_rvs-line.state-density          = if bf_rvs-line.density > 0 then bf_rvs-line.density else bf_rvs-line.state-density
    .
    assign
      bf_rvs-line.measure-qnty           = tt-meas.brutto-qnty
      bf_rvs-line.brutto-qnty            = tt-meas.brutto-qnty + bf_rvs-line.add-qnty
      bf_rvs-line.measure-cli-qnty       = tt-meas.brutto-cli-qnty
      bf_rvs-line.brutto-cli-qnty        = tt-meas.brutto-cli-qnty + (bf_rvs-line.add-qnty * bf_rvs-line.density)
    .
    assign
      bf_rvs-line.state-level-petrol = bf_rvs-line.level-petrol
      bf_rvs-line.state-level-total = bf_rvs-line.level-total
      bf_rvs-line.state-brutto-cli-qnty      = bf_rvs-line.brutto-cli-qnty
      bf_rvs-line.state-measure-cli-qnty     = bf_rvs-line.measure-cli-qnty
      bf_rvs-line.state-measure-qnty     = bf_rvs-line.measure-qnty
      bf_rvs-line.state-brutto-qnty      = bf_rvs-line.brutto-qnty
    .
  end .
  else do :
    assign
      bf_rvs-line.temperature            = tt-meas.temperature    
      bf_rvs-line.state-temperature      = bf_rvs-line.temperature
      bf_rvs-line.density                = if tt-meas.density > 0 then tt-meas.density else  bf_rvs-line.state-density
      bf_rvs-line.brutto-cli-qnty        = if bf_rvs-line.brutto-cli-qnty <> 0 then bf_rvs-line.brutto-cli-qnty else bf_rvs-line.brutto-qnty * bf_rvs-line.density     
      bf_rvs-line.measure-cli-qnty       = if bf_rvs-line.measure-cli-qnty <> 0 then bf_rvs-line.measure-cli-qnty else bf_rvs-line.measure-qnty * bf_rvs-line.density
      bf_rvs-line.state-density          = if bf_rvs-line.density > 0 then bf_rvs-line.density else bf_rvs-line.state-density
      bf_rvs-line.state-measure-cli-qnty = bf_rvs-line.state-measure-qnty * bf_rvs-line.state-density
      bf_rvs-line.state-brutto-cli-qnty  = bf_rvs-line.state-brutto-qnty  * bf_rvs-line.state-density
    .
  end .
    run placelib_get-attr  ( input {&place-twice-code}
        ,input p-obj-code
        ,input p-obj-type
        ,input p-pl-code
        ,output v-value
        ,output v-ok      ) no-error.
    if v-ok then pl-twice-code = v-value .
  
    if pl-twice-code <> "" then 
    do:
        if is-sug(bf_rvs-line.gds-code)
        then do :
          find first place no-lock where place.obj-type = p-obj-type
                                     and place.obj-code = p-obj-code
                                     and place.pl-code  = p-pl-code
                                     no-error .
          if tt-meas.measure-qnty = 0 then tt-meas.measure-qnty = tt-meas.brutto-qnty .
          if tt-meas.measure-cli-qnty = 0 then tt-meas.measure-cli-qnty = tt-meas.brutto-cli-qnty .
          twice-place-data = "Резервуар " + (if available place then place.loc1 else tt-meas.loc1) + {&new-line} +
                             "Объем СУГ:       " + string(tt-meas.measure-qnty) + {&new-line} +
                             "Общий объем:     " + string(tt-meas.brutto-qnty) + {&new-line} +
                             "Масса СУГ:       " + string(tt-meas.measure-cli-qnty) + {&new-line} +
                             "Общая масса:     " + string(tt-meas.brutto-cli-qnty) + {&new-line} +
                             "Плотность:       " + string(tt-meas.density, ">>>9.9<<<") + {&new-line} +
                             "Температура:     " + (if tt-meas.temperature = ? then "?" else string(tt-meas.temperature)) + {&new-line} +
                             "Общий уровень:   " + string(tt-meas.level-total) + {&new-line} +
                             "Уровень СУГ:     " + string(tt-meas.level-petrol) + {&new-line} +
                             "Уровень воды:    " + string(tt-meas.level-water) + {&new-line} +
                             "T1:              " + (if tt-meas.temp-layer1 = ? then "?" else string(tt-meas.temp-layer1)) + {&new-line} +
                             "T2:              " + (if tt-meas.temp-layer2 = ? then "?" else string(tt-meas.temp-layer2)) + {&new-line} +
                             "T3:              " + (if tt-meas.temp-layer3 = ? then "?" else string(tt-meas.temp-layer3)) + {&new-line} +
                             "Вода:            " + string(tt-meas.water-qnty) + {&new-line} +
                             "Плотность ПФ:    " + string(tt-meas.vapor-density, ">>>9.9<<<") + {&new-line} +
                             "Давление:        " + string(tt-meas.vapor-pressure / 1000, ">>>9.9<<<")
                             .
          find first rvs-line-attr exclusive-lock
                where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                  and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                  and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                  and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                  and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                  and rvs-line-attr.attr-code = "twice-place-data" no-error.
          if available rvs-line-attr then do :
            rvs-line-attr.attr-value = twice-place-data .
          end.
          else do :
            create rvs-line-attr.
            assign
              rvs-line-attr.obj-code  = bf_rvs-line.obj-code
              rvs-line-attr.obj-type  = bf_rvs-line.obj-type
              rvs-line-attr.gds-code  = bf_rvs-line.gds-code
              rvs-line-attr.pl-code   = bf_rvs-line.pl-code
              rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
              rvs-line-attr.attr-code = "twice-place-data"
              rvs-line-attr.attr-value = twice-place-data
            .
          end.
        end.
        if num-entries(pl-twice-code) > 1
        then do :
          twice-num = 1 .
          do ii = 1 to num-entries(pl-twice-code) :
            find first buf_tt-meas
              where buf_tt-meas.obj-type = p-obj-type
              and buf_tt-meas.obj-code = p-obj-code
              and buf_tt-meas.loc1  = entry(ii, pl-twice-code)
              no-error.
            if available buf_tt-meas
            then do :
              twice-num = twice-num + 1 .
              if is-sug(bf_rvs-line.gds-code)
              then do :
                assign
                 sug-density = sug-density + buf_tt-meas.density
    	           vapor-density = vapor-density + buf_tt-meas.vapor-density
    	           vapor-pressure = vapor-pressure + buf_tt-meas.vapor-pressure
    	           sug-water-qnty = sug-water-qnty + buf_tt-meas.water-qnty
    	          .
  
                if buf_tt-meas.measure-qnty = 0 then buf_tt-meas.measure-qnty = buf_tt-meas.brutto-qnty .
                if buf_tt-meas.measure-cli-qnty = 0 then buf_tt-meas.measure-cli-qnty = buf_tt-meas.brutto-cli-qnty .
                twice-place-data = "Резервуар " + buf_tt-meas.loc1 + {&new-line} +
                                   "Объем СУГ:       " + string(buf_tt-meas.measure-qnty) + {&new-line} +
                                   "Общий объем:     " + string(buf_tt-meas.brutto-qnty) + {&new-line} +
                                   "Масса СУГ:       " + string(buf_tt-meas.measure-cli-qnty) + {&new-line} +
                                   "Общая масса:     " + string(buf_tt-meas.brutto-cli-qnty) + {&new-line} +
                                   "Плотность:       " + string(buf_tt-meas.density, ">>>9.9<<<") + {&new-line} +
                                   "Температура:     " + (if buf_tt-meas.temperature = ? then "?" else string(buf_tt-meas.temperature)) + {&new-line} +
                                   "Общий уровень:   " + string(buf_tt-meas.level-total) + {&new-line} +
                                   "Уровень СУГ:     " + string(buf_tt-meas.level-petrol) + {&new-line} +
                                   "Уровень воды:    " + string(buf_tt-meas.level-water) + {&new-line} +
                                   "T1:              " + (if buf_tt-meas.temp-layer1 = ? then "?" else string(buf_tt-meas.temp-layer1)) + {&new-line} +
                                   "T2:              " + (if buf_tt-meas.temp-layer2 = ? then "?" else string(buf_tt-meas.temp-layer2)) + {&new-line} +
                                   "T3:              " + (if buf_tt-meas.temp-layer3 = ? then "?" else string(buf_tt-meas.temp-layer3)) + {&new-line} +
                                   "Вода:            " + string(buf_tt-meas.water-qnty) + {&new-line} +
                                   "Плотность ПФ:    " + string(buf_tt-meas.vapor-density, ">>>9.9<<<") + {&new-line} +
                                   "Давление:        " + string(buf_tt-meas.vapor-pressure / 1000, ">>>9.9<<<")
                                   .
                find first rvs-line-attr exclusive-lock
                      where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                        and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                        and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                        and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                        and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                        and rvs-line-attr.attr-code = "twice-place-data" no-error.
                if available rvs-line-attr then do :
                  rvs-line-attr.attr-value = rvs-line-attr.attr-value + {&new-line} + {&new-line} + twice-place-data .
                end.
                else do :
                  create rvs-line-attr.
                  assign
                    rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                    rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                    rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                    rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                    rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                    rvs-line-attr.attr-code = "twice-place-data"
                    rvs-line-attr.attr-value = twice-place-data
                  .
                end.
              end.
	          
  	          if not is-sug(bf_rvs-line.gds-code)
  	          then do :
    	          if place-asi-sertif then 
    	          do:
                  assign
    	              bf_rvs-line.measure-qnty           = bf_rvs-line.measure-qnty + buf_tt-meas.measure-qnty
    	              bf_rvs-line.brutto-qnty            = bf_rvs-line.brutto-qnty + buf_tt-meas.brutto-qnty
    	              bf_rvs-line.measure-cli-qnty       = bf_rvs-line.measure-cli-qnty + (if buf_tt-meas.measure-cli-qnty <> 0 then buf_tt-meas.measure-cli-qnty else buf_tt-meas.measure-qnty * buf_tt-meas.density) 
    	              bf_rvs-line.brutto-cli-qnty        = bf_rvs-line.brutto-cli-qnty  + (if buf_tt-meas.brutto-cli-qnty <> 0 then buf_tt-meas.brutto-cli-qnty else buf_tt-meas.brutto-qnty * buf_tt-meas.density) 
    	              bf_rvs-line.temperature            = (bf_rvs-line.temperature + buf_tt-meas.temperature)
    	              bf_rvs-line.level-total            = (bf_rvs-line.level-total + buf_tt-meas.level-total)
    	              bf_rvs-line.level-petrol           = (bf_rvs-line.level-petrol + buf_tt-meas.level-petrol)
    	              bf_rvs-line.level-water            = (bf_rvs-line.level-water + buf_tt-meas.level-water)
    	              bf_rvs-line.temp-layer1            = (bf_rvs-line.temp-layer1 + buf_tt-meas.temp-layer1)
    	              bf_rvs-line.temp-layer2            = (bf_rvs-line.temp-layer2  + buf_tt-meas.temp-layer2)
    	              bf_rvs-line.temp-layer3            = (bf_rvs-line.temp-layer3 +  buf_tt-meas.temp-layer3)
    	              bf_rvs-line.measure-tc-qnty        = bf_rvs-line.measure-tc-qnty  + buf_tt-meas.measure-tc-qnty
    	              bf_rvs-line.brutto-tc-qnty         = bf_rvs-line.brutto-tc-qnty +  buf_tt-meas.brutto-tc-qnty
                  .
                end.
                else do :
                  assign
    	              bf_rvs-line.measure-cli-qnty       = (bf_rvs-line.measure-qnty * bf_rvs-line.density) + (buf_tt-meas.measure-qnty * buf_tt-meas.density) 
    	              bf_rvs-line.brutto-cli-qnty        = (bf_rvs-line.brutto-qnty * bf_rvs-line.density)  + (buf_tt-meas.brutto-qnty * buf_tt-meas.density) 
    	              bf_rvs-line.measure-qnty           = bf_rvs-line.measure-qnty + buf_tt-meas.measure-qnty
    	              bf_rvs-line.brutto-qnty            = bf_rvs-line.brutto-qnty + buf_tt-meas.brutto-qnty
    	              bf_rvs-line.temperature            = (bf_rvs-line.temperature + buf_tt-meas.temperature)
    	              bf_rvs-line.level-total            = (bf_rvs-line.level-total + buf_tt-meas.level-total)
    	              bf_rvs-line.level-petrol           = (bf_rvs-line.level-petrol + buf_tt-meas.level-petrol)
    	              bf_rvs-line.level-water            = (bf_rvs-line.level-water + buf_tt-meas.level-water)
    	              bf_rvs-line.temp-layer1            = (bf_rvs-line.temp-layer1 + buf_tt-meas.temp-layer1)
    	              bf_rvs-line.temp-layer2            = (bf_rvs-line.temp-layer2  + buf_tt-meas.temp-layer2)
    	              bf_rvs-line.temp-layer3            = (bf_rvs-line.temp-layer3 +  buf_tt-meas.temp-layer3)
    	              bf_rvs-line.measure-tc-qnty        = bf_rvs-line.measure-tc-qnty  + buf_tt-meas.measure-tc-qnty
    	              bf_rvs-line.brutto-tc-qnty         = bf_rvs-line.brutto-tc-qnty +  buf_tt-meas.brutto-tc-qnty
    	            .
                end.
              end.
              else do :
                assign
                  bf_rvs-line.measure-qnty           = bf_rvs-line.measure-qnty + buf_tt-meas.brutto-qnty
                  bf_rvs-line.brutto-qnty            = bf_rvs-line.brutto-qnty + buf_tt-meas.brutto-qnty
                  bf_rvs-line.measure-cli-qnty       = bf_rvs-line.measure-cli-qnty + buf_tt-meas.brutto-cli-qnty 
                  bf_rvs-line.brutto-cli-qnty        = bf_rvs-line.brutto-cli-qnty  + buf_tt-meas.brutto-cli-qnty 
                  bf_rvs-line.temperature            = (bf_rvs-line.temperature + buf_tt-meas.temperature) 
                  bf_rvs-line.level-total            = (bf_rvs-line.level-total + buf_tt-meas.level-total)
                  bf_rvs-line.level-petrol           = (bf_rvs-line.level-petrol + buf_tt-meas.level-petrol)
                  bf_rvs-line.level-water            = (bf_rvs-line.level-water + buf_tt-meas.level-water)
                  bf_rvs-line.temp-layer1            = (bf_rvs-line.temp-layer1 + buf_tt-meas.temp-layer1)
                  bf_rvs-line.temp-layer2            = (bf_rvs-line.temp-layer2  + buf_tt-meas.temp-layer2)
                  bf_rvs-line.temp-layer3            = (bf_rvs-line.temp-layer3 +  buf_tt-meas.temp-layer3)
                  bf_rvs-line.measure-tc-qnty        = bf_rvs-line.measure-tc-qnty  + buf_tt-meas.measure-tc-qnty
                  bf_rvs-line.brutto-tc-qnty         = bf_rvs-line.brutto-tc-qnty +  buf_tt-meas.brutto-tc-qnty
                .
              end.
            end.
          end.
          assign
           sug-density = sug-density / twice-num
           vapor-density = vapor-density / twice-num
           vapor-pressure = vapor-pressure / twice-num
          .
          assign
            bf_rvs-line.temperature            = bf_rvs-line.temperature / twice-num
            bf_rvs-line.temp-layer1            = bf_rvs-line.temp-layer1 / twice-num
            bf_rvs-line.temp-layer2            = bf_rvs-line.temp-layer2 / twice-num
            bf_rvs-line.temp-layer3            = bf_rvs-line.temp-layer3 / twice-num
            bf_rvs-line.density                = bf_rvs-line.brutto-cli-qnty / bf_rvs-line.brutto-qnty    
            bf_rvs-line.state-temperature      = bf_rvs-line.temperature 

            bf_rvs-line.state-measure-qnty     = bf_rvs-line.measure-qnty
            bf_rvs-line.state-brutto-qnty      = bf_rvs-line.brutto-qnty
            bf_rvs-line.state-measure-cli-qnty = bf_rvs-line.measure-cli-qnty
            bf_rvs-line.state-brutto-cli-qnty  = bf_rvs-line.brutto-cli-qnty
            bf_rvs-line.state-density          = bf_rvs-line.density
            bf_rvs-line.state-level-total      = bf_rvs-line.level-total
            bf_rvs-line.state-level-petrol     = bf_rvs-line.level-petrol
            bf_rvs-line.state-level-water      = bf_rvs-line.level-water
            bf_rvs-line.state-temp-layer1      = bf_rvs-line.temp-layer1
            bf_rvs-line.state-temp-layer2      = bf_rvs-line.temp-layer2
            bf_rvs-line.state-temp-layer3      = bf_rvs-line.temp-layer3
            bf_rvs-line.state-measure-tc-qnty  = bf_rvs-line.measure-tc-qnty
            bf_rvs-line.state-brutto-tc-qnty   = bf_rvs-line.brutto-tc-qnty
          .
          if is-sug(bf_rvs-line.gds-code)
          then do :
            assign
              bf_rvs-line.density       = sug-density
              bf_rvs-line.state-density = bf_rvs-line.density
            .
          end.
        end.
        else do :
          find first buf_tt-meas
              where buf_tt-meas.obj-type = p-obj-type
              and buf_tt-meas.obj-code = p-obj-code
              and buf_tt-meas.loc1  = pl-twice-code
              no-error.
          if available buf_tt-meas then 
          do:
            if is-sug(bf_rvs-line.gds-code)
            then do :
              assign
               sug-density = sug-density + buf_tt-meas.density
               vapor-density = vapor-density + buf_tt-meas.vapor-density
               vapor-pressure = vapor-pressure + buf_tt-meas.vapor-pressure
               sug-water-qnty = sug-water-qnty + buf_tt-meas.water-qnty
              . 
              if buf_tt-meas.measure-qnty = 0 then buf_tt-meas.measure-qnty = buf_tt-meas.brutto-qnty .
              if buf_tt-meas.measure-cli-qnty = 0 then buf_tt-meas.measure-cli-qnty = buf_tt-meas.brutto-cli-qnty .
              twice-place-data = "Резервуар " + buf_tt-meas.loc1 + {&new-line} +
                                 "Объем СУГ:       " + string(buf_tt-meas.measure-qnty) + {&new-line} +
                                 "Общий объем:     " + string(buf_tt-meas.brutto-qnty) + {&new-line} +
                                 "Масса СУГ:       " + string(buf_tt-meas.measure-cli-qnty) + {&new-line} +
                                 "Общая масса:     " + string(buf_tt-meas.brutto-cli-qnty) + {&new-line} +
                                 "Плотность:       " + string(buf_tt-meas.density, ">>>9.9<<<") + {&new-line} +
                                 "Температура:     " + (if buf_tt-meas.temperature = ? then "?" else string(buf_tt-meas.temperature)) + {&new-line} +
                                 "Общий уровень:   " + string(buf_tt-meas.level-total) + {&new-line} +
                                 "Уровень СУГ:     " + string(buf_tt-meas.level-petrol) + {&new-line} +
                                 "Уровень воды:    " + string(buf_tt-meas.level-water) + {&new-line} +
                                 "T1:              " + (if buf_tt-meas.temp-layer1 = ? then "?" else string(buf_tt-meas.temp-layer1)) + {&new-line} +
                                 "T2:              " + (if buf_tt-meas.temp-layer2 = ? then "?" else string(buf_tt-meas.temp-layer2)) + {&new-line} +
                                 "T3:              " + (if buf_tt-meas.temp-layer3 = ? then "?" else string(buf_tt-meas.temp-layer3)) + {&new-line} +
                                 "Вода:            " + string(buf_tt-meas.water-qnty) + {&new-line} +
                                 "Плотность ПФ:    " + string(buf_tt-meas.vapor-density, ">>>9.9<<<") + {&new-line} +
                                 "Давление:        " + string(buf_tt-meas.vapor-pressure / 1000, ">>>9.9<<<")
                                 .
              find first rvs-line-attr exclusive-lock
                    where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                      and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                      and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                      and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                      and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                      and rvs-line-attr.attr-code = "twice-place-data" no-error.
              if available rvs-line-attr then do :
                rvs-line-attr.attr-value = rvs-line-attr.attr-value + {&new-line} + {&new-line} + twice-place-data .
              end.
              else do :
                create rvs-line-attr.
                assign
                  rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                  rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                  rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                  rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                  rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                  rvs-line-attr.attr-code = "twice-place-data"
                  rvs-line-attr.attr-value = twice-place-data
                .
              end.
              
            
              assign
               sug-density = sug-density / 2
               vapor-density = vapor-density / 2
               vapor-pressure = vapor-pressure / 2
              .
            end.
            
            if not is-sug(bf_rvs-line.gds-code)  
            then do :
  	          if place-asi-sertif then
  	          do:
  	            assign
  	              bf_rvs-line.measure-qnty           = bf_rvs-line.measure-qnty + buf_tt-meas.measure-qnty
  	              bf_rvs-line.brutto-qnty            = bf_rvs-line.brutto-qnty + buf_tt-meas.brutto-qnty
  	              bf_rvs-line.measure-cli-qnty       = bf_rvs-line.measure-cli-qnty + (if buf_tt-meas.measure-cli-qnty <> 0 then buf_tt-meas.measure-cli-qnty else buf_tt-meas.measure-qnty * buf_tt-meas.density) 
  	              bf_rvs-line.brutto-cli-qnty        = bf_rvs-line.brutto-cli-qnty  + (if buf_tt-meas.brutto-cli-qnty <> 0 then buf_tt-meas.brutto-cli-qnty else buf_tt-meas.brutto-qnty * buf_tt-meas.density) 
  	              bf_rvs-line.density                = bf_rvs-line.brutto-cli-qnty / bf_rvs-line.brutto-qnty    
  	              bf_rvs-line.temperature            = (bf_rvs-line.temperature + buf_tt-meas.temperature) / 2
  	              bf_rvs-line.state-temperature      = bf_rvs-line.temperature 
  	              bf_rvs-line.level-total            = (bf_rvs-line.level-total + buf_tt-meas.level-total)
  	              bf_rvs-line.level-petrol           = (bf_rvs-line.level-petrol + buf_tt-meas.level-petrol)
  	              bf_rvs-line.level-water            = (bf_rvs-line.level-water + buf_tt-meas.level-water)
  	              bf_rvs-line.temp-layer1            = (bf_rvs-line.temp-layer1 + buf_tt-meas.temp-layer1) / 2
  	              bf_rvs-line.temp-layer2            = (bf_rvs-line.temp-layer2  + buf_tt-meas.temp-layer2) / 2
  	              bf_rvs-line.temp-layer3            = (bf_rvs-line.temp-layer3 +  buf_tt-meas.temp-layer3) / 2
  	              bf_rvs-line.measure-tc-qnty        = bf_rvs-line.measure-tc-qnty  + buf_tt-meas.measure-tc-qnty
  	              bf_rvs-line.brutto-tc-qnty         = bf_rvs-line.brutto-tc-qnty +  buf_tt-meas.brutto-tc-qnty
  	
  	              bf_rvs-line.state-measure-qnty     = bf_rvs-line.measure-qnty
  	              bf_rvs-line.state-brutto-qnty      = bf_rvs-line.brutto-qnty
  	              bf_rvs-line.state-measure-cli-qnty = bf_rvs-line.measure-cli-qnty
  	              bf_rvs-line.state-brutto-cli-qnty  = bf_rvs-line.brutto-cli-qnty
  	              bf_rvs-line.state-density          = bf_rvs-line.density
  	              bf_rvs-line.state-level-total      = bf_rvs-line.level-total
  	              bf_rvs-line.state-level-petrol     = bf_rvs-line.level-petrol
  	              bf_rvs-line.state-level-water      = bf_rvs-line.level-water
  	              bf_rvs-line.state-temp-layer1      = bf_rvs-line.temp-layer1
  	              bf_rvs-line.state-temp-layer2      = bf_rvs-line.temp-layer2
  	              bf_rvs-line.state-temp-layer3      = bf_rvs-line.temp-layer3
  	              bf_rvs-line.state-measure-tc-qnty  = bf_rvs-line.measure-tc-qnty
  	              bf_rvs-line.state-brutto-tc-qnty   = bf_rvs-line.brutto-tc-qnty
  	              .
  	              
  	          end.
  	          else 
  	          do: 	
  	              assign
  	              bf_rvs-line.measure-cli-qnty       = (bf_rvs-line.measure-qnty * bf_rvs-line.density) + (buf_tt-meas.measure-qnty * buf_tt-meas.density) 
  	              bf_rvs-line.brutto-cli-qnty        = (bf_rvs-line.brutto-qnty * bf_rvs-line.density)  + (buf_tt-meas.brutto-qnty * buf_tt-meas.density) 
  	              bf_rvs-line.measure-qnty           = bf_rvs-line.measure-qnty + buf_tt-meas.measure-qnty
  	              bf_rvs-line.brutto-qnty            = bf_rvs-line.brutto-qnty + buf_tt-meas.brutto-qnty
  	              bf_rvs-line.density                = (bf_rvs-line.density + buf_tt-meas.density) / 2    
  	              bf_rvs-line.temperature            = (bf_rvs-line.temperature + buf_tt-meas.temperature) / 2
  	              bf_rvs-line.state-temperature      = bf_rvs-line.temperature 
  	              bf_rvs-line.level-total            = (bf_rvs-line.level-total + buf_tt-meas.level-total)
  	              bf_rvs-line.level-petrol           = (bf_rvs-line.level-petrol + buf_tt-meas.level-petrol)
  	              bf_rvs-line.level-water            = (bf_rvs-line.level-water + buf_tt-meas.level-water)
  	              bf_rvs-line.temp-layer1            = (bf_rvs-line.temp-layer1 + buf_tt-meas.temp-layer1) / 2
  	              bf_rvs-line.temp-layer2            = (bf_rvs-line.temp-layer2  + buf_tt-meas.temp-layer2) / 2
  	              bf_rvs-line.temp-layer3            = (bf_rvs-line.temp-layer3 +  buf_tt-meas.temp-layer3) / 2
  	              bf_rvs-line.measure-tc-qnty        = bf_rvs-line.measure-tc-qnty  + buf_tt-meas.measure-tc-qnty
  	              bf_rvs-line.brutto-tc-qnty         = bf_rvs-line.brutto-tc-qnty +  buf_tt-meas.brutto-tc-qnty
  	
  	              bf_rvs-line.state-measure-qnty     = bf_rvs-line.measure-qnty
  	              bf_rvs-line.state-brutto-qnty      = bf_rvs-line.brutto-qnty
  	              bf_rvs-line.state-measure-cli-qnty = bf_rvs-line.measure-cli-qnty
  	              bf_rvs-line.state-brutto-cli-qnty  = bf_rvs-line.brutto-cli-qnty
  	              bf_rvs-line.state-density          = bf_rvs-line.density
  	              bf_rvs-line.state-level-total      = bf_rvs-line.level-total
  	              bf_rvs-line.state-level-petrol     = bf_rvs-line.level-petrol
  	              bf_rvs-line.state-level-water      = bf_rvs-line.level-water
  	              bf_rvs-line.state-temp-layer1      = bf_rvs-line.temp-layer1
  	              bf_rvs-line.state-temp-layer2      = bf_rvs-line.temp-layer2
  	              bf_rvs-line.state-temp-layer3      = bf_rvs-line.temp-layer3
  	              bf_rvs-line.state-measure-tc-qnty  = bf_rvs-line.measure-tc-qnty
  	              bf_rvs-line.state-brutto-tc-qnty   = bf_rvs-line.brutto-tc-qnty
  	              .
  	          end.
  	        end .
	          else do :
	            assign
                  bf_rvs-line.measure-qnty           = bf_rvs-line.measure-qnty + buf_tt-meas.brutto-qnty
                  bf_rvs-line.brutto-qnty            = bf_rvs-line.brutto-qnty + buf_tt-meas.brutto-qnty
                  bf_rvs-line.measure-cli-qnty       = bf_rvs-line.measure-cli-qnty + buf_tt-meas.brutto-cli-qnty 
                  bf_rvs-line.brutto-cli-qnty        = bf_rvs-line.brutto-cli-qnty  + buf_tt-meas.brutto-cli-qnty 
                  bf_rvs-line.density                = sug-density    
                  bf_rvs-line.temperature            = (bf_rvs-line.temperature + buf_tt-meas.temperature) / 2
                  bf_rvs-line.state-temperature      = bf_rvs-line.temperature 
                  bf_rvs-line.level-total            = (bf_rvs-line.level-total + buf_tt-meas.level-total)
                  bf_rvs-line.level-petrol           = (bf_rvs-line.level-petrol + buf_tt-meas.level-petrol)
                  bf_rvs-line.level-water            = (bf_rvs-line.level-water + buf_tt-meas.level-water)
                  bf_rvs-line.temp-layer1            = (bf_rvs-line.temp-layer1 + buf_tt-meas.temp-layer1) / 2
                  bf_rvs-line.temp-layer2            = (bf_rvs-line.temp-layer2  + buf_tt-meas.temp-layer2) / 2
                  bf_rvs-line.temp-layer3            = (bf_rvs-line.temp-layer3 +  buf_tt-meas.temp-layer3) / 2
                  bf_rvs-line.measure-tc-qnty        = bf_rvs-line.measure-tc-qnty  + buf_tt-meas.measure-tc-qnty
                  bf_rvs-line.brutto-tc-qnty         = bf_rvs-line.brutto-tc-qnty +  buf_tt-meas.brutto-tc-qnty
  
                  bf_rvs-line.state-measure-qnty     = bf_rvs-line.measure-qnty
                  bf_rvs-line.state-brutto-qnty      = bf_rvs-line.brutto-qnty
                  bf_rvs-line.state-measure-cli-qnty = bf_rvs-line.measure-cli-qnty
                  bf_rvs-line.state-brutto-cli-qnty  = bf_rvs-line.brutto-cli-qnty
                  bf_rvs-line.state-density          = bf_rvs-line.density
                  bf_rvs-line.state-level-total      = bf_rvs-line.level-total
                  bf_rvs-line.state-level-petrol     = bf_rvs-line.level-petrol
                  bf_rvs-line.state-level-water      = bf_rvs-line.level-water
                  bf_rvs-line.state-temp-layer1      = bf_rvs-line.temp-layer1
                  bf_rvs-line.state-temp-layer2      = bf_rvs-line.temp-layer2
                  bf_rvs-line.state-temp-layer3      = bf_rvs-line.temp-layer3
                  bf_rvs-line.state-measure-tc-qnty  = bf_rvs-line.measure-tc-qnty
                  bf_rvs-line.state-brutto-tc-qnty   = bf_rvs-line.brutto-tc-qnty
                .
            end.
          end.
        end.
    end.
    
    if is-sug(bf_rvs-line.gds-code)
    then do :
      find first rvs-line-attr exclusive-lock
            where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
              and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
              and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
              and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
              and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
              and rvs-line-attr.attr-code = "sug-water-qnty" no-error.
      if available rvs-line-attr then do :
        rvs-line-attr.attr-value = string(sug-water-qnty) .
      end.
      else do :
        create rvs-line-attr.
        assign
          rvs-line-attr.obj-code  = bf_rvs-line.obj-code
          rvs-line-attr.obj-type  = bf_rvs-line.obj-type
          rvs-line-attr.gds-code  = bf_rvs-line.gds-code
          rvs-line-attr.pl-code   = bf_rvs-line.pl-code
          rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
          rvs-line-attr.attr-code = "sug-water-qnty"
          rvs-line-attr.attr-value = string(sug-water-qnty)
        .
      end.
      
      find first rvs-line-attr exclusive-lock
            where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
              and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
              and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
              and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
              and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
              and rvs-line-attr.attr-code = "dens-pf-sug" no-error.
      if available rvs-line-attr then do :
        rvs-line-attr.attr-value = string(vapor-density) .
      end.
      else do :
        create rvs-line-attr.
        assign
          rvs-line-attr.obj-code  = bf_rvs-line.obj-code
          rvs-line-attr.obj-type  = bf_rvs-line.obj-type
          rvs-line-attr.gds-code  = bf_rvs-line.gds-code
          rvs-line-attr.pl-code   = bf_rvs-line.pl-code
          rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
          rvs-line-attr.attr-code = "dens-pf-sug"
          rvs-line-attr.attr-value = string(vapor-density)
        .
      end.
      
      find first rvs-line-attr exclusive-lock
            where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
              and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
              and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
              and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
              and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
              and rvs-line-attr.attr-code = "pressure-sug" no-error.
      if available rvs-line-attr then do :
        rvs-line-attr.attr-value = string(vapor-pressure / 1000) .
      end.
      else do :
        create rvs-line-attr.
        assign
          rvs-line-attr.obj-code  = bf_rvs-line.obj-code
          rvs-line-attr.obj-type  = bf_rvs-line.obj-type
          rvs-line-attr.gds-code  = bf_rvs-line.gds-code
          rvs-line-attr.pl-code   = bf_rvs-line.pl-code
          rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
          rvs-line-attr.attr-code = "pressure-sug"
          rvs-line-attr.attr-value = string(vapor-pressure / 1000)
        .
      end.
    end.
    
    define variable v-lvl-qnty as decimal no-undo.
    
    /*Проверка на параметр*/
    
    /*    v-file-name =   "delta.txt".*/
    v-delta-mas-qnty = 0.
    v-lvl-qnty = 0 .
    /*     if search(v-file-name ) <> ? then do:*/

    IF rdc-value = "pomi-rn"
    and available tt-meas-file 
    and   tt-meas-file.log-brutto = yes
    and not is-sug(bf_rvs-line.gds-code)
    then do:
    /*Тип резервуара*/
    run placelib_get-attr in this-procedure  (
        input {&place-type}
        ,input p-obj-code
        ,input p-obj-type
        ,input p-pl-code
        ,output v-value
        ,output v-ok      ) no-error.
    if v-ok then 
    do :

        { gbl/getsect.i run  p-obj-type  p-obj-code  {&attr-petrol} }
    
        if integer(v-value) = 1 then 
        do:
            for each thbjattr_thbj-attr where thbjattr_thbj-attr.prop-code = {&attr-petrol_Delta-mass-vert}:    
                 assign v-full-name = thbjattr_thbj-attr.property-value-character .
            end.
        end.    
        else 
        do:
            for each thbjattr_thbj-attr where thbjattr_thbj-attr.prop-code = {&attr-petrol_Delta-mass-horiz}:    
                assign v-full-name = thbjattr_thbj-attr.property-value-character .
            end.
        end.    
    
        do ii = 1 to NUM-ENTRIES(v-full-name,{&new-line}): 
            v-file-name = string(entry(ii,v-full-name,{&new-line})).
            if v-lvl-qnty < bf_rvs-line.state-level-total and bf_rvs-line.state-level-total <=  (decimal ( entry(1, v-file-name, ";")) * 100) then 
            do: 
                v-delta-mas-qnty =  decimal( entry(2, v-file-name, ";") ) no-error.
            end.
            v-lvl-qnty =  decimal ( entry(1, v-file-name, ";")  ) * 100   .
        end.
    end.
    find first rvs-line-attr exclusive-lock
        where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
        and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
        and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
        and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
        and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
        and rvs-line-attr.attr-code = "delta-mass-qnty" no-error.
    if available rvs-line-attr then
    do :
        if v-delta-mas-qnty > 0.65 then rvs-line-attr.attr-value = "0.65" . else rvs-line-attr.attr-value = string(v-delta-mas-qnty  ).
    end.
    else
    do :
        create rvs-line-attr.
        assign
            rvs-line-attr.obj-code   = bf_rvs-line.obj-code
            rvs-line-attr.obj-type   = bf_rvs-line.obj-type
            rvs-line-attr.gds-code   = bf_rvs-line.gds-code
            rvs-line-attr.pl-code    = bf_rvs-line.pl-code
            rvs-line-attr.rvs-code   = bf_rvs-line.rvs-code
            rvs-line-attr.attr-code  = "delta-mass-qnty"
            .
            if v-delta-mas-qnty > 0.65 then rvs-line-attr.attr-value = "0.65" . else rvs-line-attr.attr-value = string(v-delta-mas-qnty  ).

    end.
    find first rvs-line-attr no-lock
         where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
           and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
           and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
           and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
           and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
           and rvs-line-attr.attr-code = "is-olddens" no-error.
    if available rvs-line-attr
    then do :
      v-is-olddens = logical(rvs-line-attr.attr-value) no-error.
      if error-status:error then v-is-olddens = no .
    end.
    else do :
      v-is-olddens = no .
    end.    
    find first rvs-line-attr exclusive-lock
          where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
            and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
            and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
            and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
            and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
            and rvs-line-attr.attr-code = "izmer-density" no-error.
    if available rvs-line-attr then do :
      rvs-line-attr.attr-value = if not v-is-olddens then string(bf_rvs-line.density) else string(?) .
    end.
    else do :
      create rvs-line-attr.
        assign
            rvs-line-attr.obj-code   = bf_rvs-line.obj-code
            rvs-line-attr.obj-type   = bf_rvs-line.obj-type
            rvs-line-attr.gds-code   = bf_rvs-line.gds-code
            rvs-line-attr.pl-code    = bf_rvs-line.pl-code
            rvs-line-attr.rvs-code   = bf_rvs-line.rvs-code
            rvs-line-attr.attr-code  = "izmer-density"
            rvs-line-attr.attr-value = if not v-is-olddens then string(bf_rvs-line.density) else string(?)
            .
    END.
    end.

/*end.*/
/*end. /**/*/
    IF ( NOT bf_rvs-line.state-density > 0 OR bf_rvs-line.state-density = ? )  or (bf_rvs-line.state-temperature  = 0 or bf_rvs-line.state-temperature = ? )  THEN 
    DO:
      /* Для тех у кого установлен параметр olddens */
    { gbl/ptrlprop.i run p-obj-type p-obj-code }
    
        IF ptrlprop-olddens = true
        and not is-sug(bf_rvs-line.gds-code)
        THEN 
        DO:
            p-prev-rvs-date = NO.
            FIND FIRST rvs-doc WHERE rvs-doc.rvs-code = bf_rvs-line.rvs-code NO-LOCK NO-ERROR.
          
            prev: FOR EACH crl_prev_rvs-doc NO-LOCK
                WHERE crl_prev_rvs-doc.obj-type   = p-obj-type
                AND crl_prev_rvs-doc.obj-code   = p-obj-code
                AND crl_prev_rvs-doc.shift-date = rvs-doc.shift-date 
                AND crl_prev_rvs-doc.shift-num  = rvs-doc.shift-num
                AND crl_prev_rvs-doc.status_    = {&fact}
                /* and contr_rvs-doc.rvs-type = {&rvs-control} */
                BY crl_prev_rvs-doc.fact-order DESC
                ON ERROR UNDO, RETURN ERROR RETURN-VALUE
                :
                FIND LAST prev_rvs-line NO-LOCK
                    WHERE prev_rvs-line.rvs-code = crl_prev_rvs-doc.rvs-code
                    AND prev_rvs-line.obj-type = p-obj-type
                    AND prev_rvs-line.obj-code = p-obj-code
                    AND prev_rvs-line.pl-code  =  bf_rvs-line.pl-code
                    AND prev_rvs-line.gds-code = bf_rvs-line.gds-code
                    NO-ERROR .
                IF AVAILABLE prev_rvs-line THEN 
                DO:
                    if bf_rvs-line.state-density > 1 or bf_rvs-line.state-density = ? then 
                    do:    
                        bf_rvs-line.state-temperature = prev_rvs-line.state-temperature. 
                        bf_rvs-line.temperature  = prev_rvs-line.temperature.
                           
                        bf_rvs-line.state-density = prev_rvs-line.state-density.
                        bf_rvs-line.density = bf_rvs-line.state-density .
                        p-prev-rvs-date = YES.  
                        find first rvs-line-attr exclusive-lock
                             where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                               and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                               and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                               and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                               and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                               and rvs-line-attr.attr-code = "is-olddens" no-error.
                        if not available rvs-line-attr then do :
                          create rvs-line-attr.
                          assign
                            rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                            rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                            rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                            rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                            rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                            rvs-line-attr.attr-code = "is-olddens"
                          .
                        end.
                        rvs-line-attr.attr-value = 'yes' .
                    end.
                    if bf_rvs-line.state-temperature  = 0 or bf_rvs-line.state-temperature = ? then 
                    do:
                        bf_rvs-line.state-temperature = prev_rvs-line.state-temperature. 
                        bf_rvs-line.temperature  = prev_rvs-line.temperature.
                        p-prev-rvs-date = YES.  
                    end.    
                    if bf_rvs-line.temperature  = 0 or bf_rvs-line.temperature = ? then 
                    do:
                        bf_rvs-line.temperature  = prev_rvs-line.temperature. 
                    end. 
                    if bf_rvs-line.temperature  = 0 or bf_rvs-line.temperature = ? then 
                    do:
                        bf_rvs-line.temperature  = bf_rvs-line.state-temperature. 
                    end.
                    LEAVE prev .
                END.
            END.
            IF   p-prev-rvs-date = NO THEN 
            DO :
                FIND FIRST crl_prev_rvs-doc NO-LOCK WHERE
                    crl_prev_rvs-doc.rvs-code = p-prev-code NO-ERROR .
                IF AVAILABLE crl_prev_rvs-doc THEN 
                DO:
                    FIND FIRST prev_rvs-line NO-LOCK WHERE
                        prev_rvs-line.rvs-code = crl_prev_rvs-doc.rvs-code AND
                        prev_rvs-line.obj-type = bf_rvs-line.obj-type      AND
                        prev_rvs-line.obj-code = bf_rvs-line.obj-code      AND
                        prev_rvs-line.pl-code  = bf_rvs-line.pl-code       AND
                        prev_rvs-line.gds-code = bf_rvs-line.gds-code      NO-ERROR .
                    IF AVAILABLE prev_rvs-line THEN 
                    DO:
                        if bf_rvs-line.state-density > 1 or bf_rvs-line.state-density = ? then 
                        do:
                            ASSIGN
                                bf_rvs-line.density           = prev_rvs-line.state-density
                                bf_rvs-line.state-density     = prev_rvs-line.state-density
                                bf_rvs-line.temperature       = prev_rvs-line.temperature
                                bf_rvs-line.state-temperature = prev_rvs-line.state-temperature
                                .
                            find first rvs-line-attr exclusive-lock
                                 where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                                   and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                                   and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                                   and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                                   and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                                   and rvs-line-attr.attr-code = "is-olddens" no-error.
                            if not available rvs-line-attr then do :
                              create rvs-line-attr.
                              assign
                                rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                                rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                                rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                                rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                                rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                                rvs-line-attr.attr-code = "is-olddens"
                              .
                            end.
                            rvs-line-attr.attr-value = 'yes' .
                        END.
                        if bf_rvs-line.state-temperature  = 0 or bf_rvs-line.state-temperature = ? then 
                        do:
                            bf_rvs-line.temperature            = prev_rvs-line.temperature.
                            bf_rvs-line.state-temperature      = prev_rvs-line.state-temperature.
                        END.
                        
                        ASSIGN
                            bf_rvs-line.measure-cli-qnty       = bf_rvs-line.measure-qnty       * bf_rvs-line.density
                            bf_rvs-line.brutto-cli-qnty        = bf_rvs-line.brutto-qnty        * bf_rvs-line.density
                            bf_rvs-line.state-measure-cli-qnty = bf_rvs-line.state-measure-qnty * bf_rvs-line.density
                            bf_rvs-line.state-brutto-cli-qnty  = bf_rvs-line.state-brutto-qnty  * bf_rvs-line.density
                            .
                           
                    END. /* if available prev_rvs-line */
                END.
            END. /* if available crl_prev_rvs-doc */
        END. /* if ptrlprop-olddens = true */
    END.
  
FIND FIRST tt-meas-file WHERE tt-meas-file.pl-code =  tt-meas.pl-code NO-LOCK NO-ERROR.
  

IF available tt-meas-file
and   tt-meas-file.log-brutto = no
and not is-sug(bf_rvs-line.gds-code)
THEN DO: 


        RUN gbl/conf-rd.p ("rdc-dnst", "", "", 0, "", "", "", NO, OUTPUT rdc-dnstvalue, OUTPUT rdc-dnsttype) NO-ERROR.

        IF rdc-dnstvalue = "pomi-rn" THEN 
        DO :
    _trpomi :
      do on error undo, return error :
      /*данные по резервуару для ПО МИ*/
      do ii = 1 to num-entries({&list-place-attr},','):
        v-code = entry(ii,{&list-place-attr}) .
        run placelib_get-attr  ( input v-code
                                ,input p-obj-code
                                ,input p-obj-type
                                ,input p-pl-code
                                ,output v-value
                                ,output v-ok      ) no-error.
        case v-code :
          when {&place-type} then do :
            if v-ok then place-type = integer(v-value) .
          end.
          when {&place-SI} then do :
            if v-ok then place-si = integer(v-value) .
          end.
          when {&place-diameter} then do :
            if v-ok then place-diameter = decimal(v-value) .
          end.
          when {&place-ratio-error} then do :
            if v-ok then place-ratio-error = decimal(v-value) .
          end.
          when {&place-dens-prov} then do :
            if v-ok then dens-prov = decimal(v-value) .
          end.
          when {&place-asi-sertif} then do :
            if v-ok then place-asi-sertif = logical(v-value) .
          end.
        end case.
      end.
      
      if place-asi-sertif
      then do :
        run placelib_get-attr in this-procedure  (
            input {&place-type}
            ,input p-obj-code
            ,input p-obj-type
            ,input p-pl-code
            ,output v-value
            ,output v-ok      ) no-error.
        if v-ok then 
        do :
    
            { gbl/getsect.i run  p-obj-type  p-obj-code  {&attr-petrol} }
        
            if integer(v-value) = 1 then 
            do:
                for each thbjattr_thbj-attr where thbjattr_thbj-attr.prop-code = {&attr-petrol_Delta-mass-vert}:    
                     assign v-full-name = thbjattr_thbj-attr.property-value-character .
                end.
            end.    
            else 
            do:
                for each thbjattr_thbj-attr where thbjattr_thbj-attr.prop-code = {&attr-petrol_Delta-mass-horiz}:    
                    assign v-full-name = thbjattr_thbj-attr.property-value-character .
                end.
            end.    
        
            do ii = 1 to NUM-ENTRIES(v-full-name,{&new-line}): 
                v-file-name = string(entry(ii,v-full-name,{&new-line})).
                if v-lvl-qnty < bf_rvs-line.state-level-total and bf_rvs-line.state-level-total <=  (decimal ( entry(1, v-file-name, ";")) * 100) then 
                do: 
                    v-delta-mas-qnty =  decimal( entry(2, v-file-name, ";") ) no-error.
                end.
                v-lvl-qnty =  decimal ( entry(1, v-file-name, ";")  ) * 100   .
            end.
        end.
        find first rvs-line-attr exclusive-lock
            where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
            and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
            and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
            and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
            and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
            and rvs-line-attr.attr-code = "delta-mass-qnty" no-error.
        if available rvs-line-attr then
        do :
            if v-delta-mas-qnty > 0.65 then rvs-line-attr.attr-value = "0.65" . else rvs-line-attr.attr-value = string(v-delta-mas-qnty  ).
        end.
        else
        do :
            create rvs-line-attr.
            assign
                rvs-line-attr.obj-code   = bf_rvs-line.obj-code
                rvs-line-attr.obj-type   = bf_rvs-line.obj-type
                rvs-line-attr.gds-code   = bf_rvs-line.gds-code
                rvs-line-attr.pl-code    = bf_rvs-line.pl-code
                rvs-line-attr.rvs-code   = bf_rvs-line.rvs-code
                rvs-line-attr.attr-code  = "delta-mass-qnty"
                .
                if v-delta-mas-qnty > 0.65 then rvs-line-attr.attr-value = "0.65" . else rvs-line-attr.attr-value = string(v-delta-mas-qnty  ).
    
        end.
        find first rvs-line-attr no-lock
             where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
               and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
               and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
               and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
               and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
               and rvs-line-attr.attr-code = "is-olddens" no-error.
        if available rvs-line-attr
        then do :
          v-is-olddens = logical(rvs-line-attr.attr-value) no-error.
          if error-status:error then v-is-olddens = no .
        end.
        else do :
          v-is-olddens = no .
        end.    
        find first rvs-line-attr exclusive-lock
              where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                and rvs-line-attr.attr-code = "izmer-density" no-error.
        if available rvs-line-attr then do :
          rvs-line-attr.attr-value = if not v-is-olddens then string(bf_rvs-line.density) else string(?) .
        end.
        else do :
          create rvs-line-attr.
            assign
                rvs-line-attr.obj-code   = bf_rvs-line.obj-code
                rvs-line-attr.obj-type   = bf_rvs-line.obj-type
                rvs-line-attr.gds-code   = bf_rvs-line.gds-code
                rvs-line-attr.pl-code    = bf_rvs-line.pl-code
                rvs-line-attr.rvs-code   = bf_rvs-line.rvs-code
                rvs-line-attr.attr-code  = "izmer-density"
                rvs-line-attr.attr-value = if not v-is-olddens then string(bf_rvs-line.density) else string(?)
                .
        END.
        leave _trpomi .
      end.  
        
      /*..........................................*/

        /*градуировочная таблица резервуара для ПО МИ*/
        for last pl-level no-lock
            where pl-level.pl-code  = bf_rvs-line.pl-code
            and pl-level.obj-code =  bf_rvs-line.obj-code
            and pl-level.obj-type = bf_rvs-line.obj-type 
            by pl-level.pl-level
            :
            CalibTable = Substitute("&1=&2","1",(pl-level.pl-qnty / (pl-level.pl-level))) .
        end.
      for each  pl-level no-lock
          where pl-level.pl-code  = bf_rvs-line.pl-code
            and pl-level.obj-code = bf_rvs-line.obj-code
            and pl-level.obj-type = bf_rvs-line.obj-type 
            and pl-level.pl-level / bf_rvs-line.level-total > 0.7 and pl-level.pl-level / bf_rvs-line.level-total < 1.3
            by pl-level.pl-level
            :
            if CalibTable = "" then CalibTable = Substitute("&1=&2",(pl-level.pl-level ),pl-level.pl-qnty ) .
                              else CalibTable = CalibTable + ";" + Substitute("&1=&2",(pl-level.pl-level ),pl-level.pl-qnty ) .
      end.
      CalibTable = CalibTable + ";" + fill({&space-char},(2048 - length(CalibTable))).
      /*..........................................*/

      /*данные по средству измерения резервуара для ПО МИ*/
      find first buf_sr-izmerenia no-lock where buf_sr-izmerenia.node-code = place-si no-error.
      if available buf_sr-izmerenia then assign
          ToolType               = buf_sr-izmerenia.sr-type
          A_LevelMeasurementTool = buf_sr-izmerenia.sr-temp-line
          DeltaAbs_H             = buf_sr-izmerenia.sr-abs-err-neft-water
          DeltaAbs_H_Water       = buf_sr-izmerenia.sr-abs-err-water
          DeltaAbs_R             = buf_sr-izmerenia.sr-abs-err-dens
          DeltaAbs_Tv            = buf_sr-izmerenia.sr-abs-err-temp-vol
          DeltaAbs_Tr            = buf_sr-izmerenia.sr-abs-err-temp-dens
          DeltaOtn_N             = buf_sr-izmerenia.sr-otnos
      .
      else undo _trpomi, return error substitute( 'Не найдено средство измерения с кодом &1', place-si ) .
      /*..........................................*/

      /*дополнительные данные(берем из предыдущей сверки)*/
      find first rvs-line-attr no-lock
          where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
            and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
            and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
            and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
            and rvs-line-attr.rvs-code  = p-prev-code
            and rvs-line-attr.attr-code = "mass-float-cov" no-error.
      if available rvs-line-attr then do :
        mass-float-cov = decimal(rvs-line-attr.attr-value) .
      end.
      else do :
        mass-float-cov = 0 .
      end.
      /*......................................................*/
      { gbl/ptrlprop.i
        run
        bf_rvs-line.obj-type
        bf_rvs-line.obj-code
      }
      if not error-status :error then do:
        if ptrlprop-temp-for-pomi = 1 then temp-for-pomi = 15 .
                                      else temp-for-pomi = 20 .
      end.
      /*метод применяемый к данному типу резервуара и */
      if place-type = 1 then do :
        v-proc = "Rosneft.MethodOfMetering13" .
        DeltaOtn_K = 0.20 .
      end.
      else do :
        v-proc = "Rosneft.MethodOfMetering6" .
        DeltaOtn_K = 0.25 .
      end.
      /*..............................................*/

      RELEASE OBJECT v-mm NO-ERROR.
      v-mm = ?.

      CREATE value(v-proc) v-mm no-error.
      IF ERROR-STATUS:ERROR
      OR NOT VALID-HANDLE(v-mm)
      THEN DO:
        RELEASE OBJECT v-mm NO-ERROR.
        v-mm = ?.
        undo _trpomi, return error substitute( 'Не удается подключиться к COM-серверу библиотеки для работы с ПО МИ ' ) .
      END.
      ELSE DO :
        ASSIGN
          v-mm:H                      = integer(round( bf_rvs-line.level-total, 1) * 10)
          v-mm:H_water                = integer(round( bf_rvs-line.level-water, 1) * 10)
          v-mm:CalibrationTable       = CalibTable
          v-mm:Tv                     = (if bf_rvs-line.state-temp-layer1 <> ? then bf_rvs-line.state-temp-layer1 else 0)
          v-mm:Tr                     = bf_rvs-line.temperature
          v-mm:R                      = ( bf_rvs-line.density * 1000 )
          v-mm:Tcy                    = temp-for-pomi
          v-mm:ToolType               = ToolType
          v-mm:DeltaOtn_K             = DeltaOtn_K
          v-mm:A_Reservoir            = 0.0000125
          v-mm:DeltaAbs_H             = DeltaAbs_H
          v-mm:DeltaAbs_H_Water       = DeltaAbs_H_Water
          v-mm:DeltaAbs_R             = DeltaAbs_R
          v-mm:DeltaAbs_Tv            = DeltaAbs_Tv
          v-mm:DeltaAbs_Tr            = DeltaAbs_Tr
          v-mm:DeltaOtn_N             = DeltaOtn_N
        .
                    OUTPUT stream outstream to value ("pomi.log") append.
                    PUT STREAM outstream
                    "    " SKIP
                    "    " SKIP
                    cur-time-string()           FORMAT "x(16)"    SKIP
                    'Процедура'                 v-proc                   FORMAT "x(128)"   SKIP
                    'CODE_PL                = ' bf_rvs-line.pl-code format "99999999999":U SKIP
                    'H                      = ' v-mm:H                                     SKIP
                    'H_water                = ' v-mm:H_water                               SKIP
                    'CalibrationTable       = ' v-mm:CalibrationTable    FORMAT "x(2048)"  SKIP
                    'Tv                     = ' v-mm:Tv                                    SKIP
                    'Tr                     = ' v-mm:Tr                                    SKIP
                    'R                      = ' v-mm:R                                     SKIP
                    'Tcy                    = ' v-mm:Tcy                                   SKIP
                    'ToolType               = ' v-mm:ToolType                              SKIP
                    'DeltaOtn_K             = ' v-mm:DeltaOtn_K                            SKIP
                    'A_Reservoir            = ' v-mm:A_Reservoir                           SKIP
                    'DeltaAbs_H             = ' v-mm:DeltaAbs_H                            SKIP
                    'DeltaAbs_H_Water       = ' v-mm:DeltaAbs_H_Water                      SKIP
                    'DeltaAbs_R             = ' v-mm:DeltaAbs_R                            SKIP
                    'DeltaAbs_Tv            = ' v-mm:DeltaAbs_Tv                           SKIP
                    'DeltaAbs_Tr            = ' v-mm:DeltaAbs_Tr                           SKIP
                    'DeltaOtn_N             = ' v-mm:DeltaOtn_N                            SKIP
                    
                        SKIP SKIP 
        .

        if place-type = 1 then do :
          v-mm:Rprov = ( dens-prov * 1000 ) .
          v-mm:Mpokr = mass-float-cov.
          put stream outstream

            "v-mm:Rprov = " ( dens-prov * 1000 ) skip
            "v-mm:Mpokr = " mass-float-cov skip
          .
        end.
        find first place no-lock
          where place.obj-code =  bf_rvs-line.obj-code
            and place.obj-type =  bf_rvs-line.obj-type
            and place.pl-code  =  bf_rvs-line.pl-code no-error.
      if place.is-meas  = yes then do :
         v-mm:Tv =  (if bf_rvs-line.state-temperature <> ? then bf_rvs-line.state-temperature else 0) .
      end.
        
        output stream outstream close.
        v-mm:Exec() no-error.

        if v-mm:Result <> 0 then do :
          error-string = v-mm:ResultDetail .
          output stream outstream to value ("pomi.log")  append.
          put stream outstream error-string format "X(1024)" skip.
          RELEASE OBJECT v-mm NO-ERROR.
          v-mm = ?.
          output stream outstream close.
          undo _trpomi, return error substitute('Ошибка работы библиотеки ПО МИ &1',error-string).
        end.

        else do :
          v-mm-density = decimal(v-mm:Rcy) / 1000 .
          find first rvs-line-attr exclusive-lock
                where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                  and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                  and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                  and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                  and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                  and rvs-line-attr.attr-code = "meas-calc-qnty" no-error.
          if available rvs-line-attr then do :
            rvs-line-attr.attr-value = v-mm:Vcy .
          end.
          else do :
            create rvs-line-attr.
            assign
              rvs-line-attr.obj-code  = bf_rvs-line.obj-code
              rvs-line-attr.obj-type  = bf_rvs-line.obj-type
              rvs-line-attr.gds-code  = bf_rvs-line.gds-code
              rvs-line-attr.pl-code   = bf_rvs-line.pl-code
              rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
              rvs-line-attr.attr-code = "meas-calc-qnty"
              rvs-line-attr.attr-value = v-mm:Vcy
            .
          end.
          find first rvs-line-attr exclusive-lock
                where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                  and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                  and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                  and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                  and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                  and rvs-line-attr.attr-code = "meas-calc-dens" no-error.
          if available rvs-line-attr then do :
            rvs-line-attr.attr-value = string ( v-mm-density ) .
          end.
          else do :
            create rvs-line-attr.
            assign
              rvs-line-attr.obj-code  = bf_rvs-line.obj-code
              rvs-line-attr.obj-type  = bf_rvs-line.obj-type
              rvs-line-attr.gds-code  = bf_rvs-line.gds-code
              rvs-line-attr.pl-code   = bf_rvs-line.pl-code
              rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
              rvs-line-attr.attr-code = "meas-calc-dens"
              rvs-line-attr.attr-value = string ( v-mm-density )
            .
          end.
          find first rvs-line-attr exclusive-lock
                where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                  and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                  and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                  and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                  and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                  and rvs-line-attr.attr-code = "meas-cli-calc-qnty" no-error.
          if available rvs-line-attr then do :
            rvs-line-attr.attr-value = v-mm:Mcy .
          end.
          else do :
            create rvs-line-attr.
            assign
              rvs-line-attr.obj-code  = bf_rvs-line.obj-code
              rvs-line-attr.obj-type  = bf_rvs-line.obj-type
              rvs-line-attr.gds-code  = bf_rvs-line.gds-code
              rvs-line-attr.pl-code   = bf_rvs-line.pl-code
              rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
              rvs-line-attr.attr-code = "meas-cli-calc-qnty"
              rvs-line-attr.attr-value = v-mm:Mcy
            .
          end.
          find first rvs-line-attr no-lock
               where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                 and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                 and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                 and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                 and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                 and rvs-line-attr.attr-code = "is-olddens" no-error.
          if available rvs-line-attr
          then do :
            v-is-olddens = logical(rvs-line-attr.attr-value) no-error.
            if error-status:error then v-is-olddens = no .
          end.
          else do :
            v-is-olddens = no .
          end.    
          find first rvs-line-attr exclusive-lock
                where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                  and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                  and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                  and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                  and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                  and rvs-line-attr.attr-code = "izmer-density" no-error.
          if available rvs-line-attr then do :
            rvs-line-attr.attr-value = if not v-is-olddens then string(bf_rvs-line.density) else string(?) .
          end.
          else do :
            create rvs-line-attr.
              assign
                  rvs-line-attr.obj-code   = bf_rvs-line.obj-code
                  rvs-line-attr.obj-type   = bf_rvs-line.obj-type
                  rvs-line-attr.gds-code   = bf_rvs-line.gds-code
                  rvs-line-attr.pl-code    = bf_rvs-line.pl-code
                  rvs-line-attr.rvs-code   = bf_rvs-line.rvs-code
                  rvs-line-attr.attr-code  = "izmer-density"
                  rvs-line-attr.attr-value = if not v-is-olddens then string(bf_rvs-line.density) else string(?)
                  .
          END.
          
            find first rvs-line-attr exclusive-lock
                where rvs-line-attr.obj-code  = bf_rvs-line.obj-code
                and rvs-line-attr.obj-type  = bf_rvs-line.obj-type
                and rvs-line-attr.gds-code  = bf_rvs-line.gds-code
                and rvs-line-attr.pl-code   = bf_rvs-line.pl-code
                and rvs-line-attr.rvs-code  = bf_rvs-line.rvs-code
                and rvs-line-attr.attr-code = "delta-mass-qnty" no-error.
            if available rvs-line-attr then 
            do :
                rvs-line-attr.attr-value = v-mm:DeltaOtn_M .
                if rvs-line-attr.attr-value > "0.65" then rvs-line-attr.attr-value = "0.65". 
            end.
            else 
            do :
                create rvs-line-attr.
                assign
                    rvs-line-attr.obj-code   = bf_rvs-line.obj-code
                    rvs-line-attr.obj-type   = bf_rvs-line.obj-type
                    rvs-line-attr.gds-code   = bf_rvs-line.gds-code
                    rvs-line-attr.pl-code    = bf_rvs-line.pl-code
                    rvs-line-attr.rvs-code   = bf_rvs-line.rvs-code
                    rvs-line-attr.attr-code  = "delta-mass-qnty"
                    .
                    if v-mm:DeltaOtn_M > "0.65" then rvs-line-attr.attr-value = "0.65". else rvs-line-attr.attr-value = v-mm:DeltaOtn_M  .
                   
         end.
            ASSIGN
            
                bf_rvs-line.state-measure-qnty     = v-mm:V        
        bf_rvs-line.state-measure-cli-qnty = v-mm:M        
        bf_rvs-line.state-brutto-qnty      =  bf_rvs-line.state-measure-qnty  + tt-meas-file.water-qnty
        bf_rvs-line.state-density          =  DECIMAL(v-mm:Rv) / 1000 
        bf_rvs-line.state-brutto-cli-qnty  = bf_rvs-line.state-measure-cli-qnty + tt-meas-file.water-qnty
                .
                        OUTPUT stream outstream to value ("pomi.log")  append.
                        PUT STREAM outstream
                            "v-mm:Vcy = "  v-mm:Vcy     SKIP
                            "v-mm:Rcy = "  v-mm:Rcy          SKIP
                            "v-mm:Mcy = "  v-mm:Mcy SKIP
                            "v-mm:V_product = " v-mm:V_product  SKIP
                            "v-mm:V = " v-mm:V  SKIP 
                            "v-mm:Rv = " v-mm:Rv  SKIP
                            "v-mm:M = " v-mm:M  SKIP
                            "v-mm:CTL_base_alt = " v-mm:CTL_base_alt  SKIP
                            "v-mm:CPL_base_alt = " v-mm:CPL_base_alt SKIP
                            "v-mm:CTPL_base_alt = " v-mm:CTPL_base_alt  SKIP
                            "v-mm:Fp_base_alt = " v-mm:Fp_base_alt  SKIP
                            "v-mm:CTL_obs_base = " v-mm:CTL_obs_base SKIP
                            "v-mm:CPL_obs_base = " v-mm:CPL_obs_base  SKIP
                            "v-mm:CTPL_obs_base = " v-mm:CTPL_obs_base  SKIP
                            "v-mm:Fp_obs_base = " v-mm:Fp_obs_base  SKIP
                            "v-mm:DeltaOtn_Vcy = " v-mm:DeltaOtn_Vcy  SKIP
                            "v-mm:DeltaOtn_M = " v-mm:DeltaOtn_M  SKIP
                
                            .
                    OUTPUT stream outstream close.
                    RELEASE OBJECT v-mm NO-ERROR.
                    v-mm = ?.
                END.
            END.
        END.
   END.
END.
    { str/initiator.i }
    
    

      /* на объекте включены смены */

    define variable v-shift-date like ub.shift-obj.shift-date no-undo .
    define variable v-shift-num  like ub.shift-obj.shift-num no-undo .
    define variable v-shift-name like ub.shift-obj.shift-name no-undo.
    define variable v-person     as character no-undo.
    
          { gbl/curshift.i
        bf_rvs-line.obj-type
        bf_rvs-line.obj-code
        v-shift-date
        v-shift-num
        v-shift-name
        no-error
      }

    for first  ub.rvs-doc no-lock
        where ub.rvs-doc.rvs-code = bf_rvs-line.rvs-code : 
    
        
        v-vid-action = 56 .
        v-vid-param = 
             "Initiator=" + v-initiator + {&delim-par} +
            "SHOP_NUM=" + string(ub.rvs-doc.obj-code) + {&delim-par} +
            "DocType=" + string(ub.rvs-doc.rvs-type) + {&delim-par} +
            "DocNum=" + string(ub.rvs-doc.rvs-code) + {&delim-par} +
             /*            "ShiftNum=" + string(ub.rvs-doc.shift-num) + {&delim-par} +  */
             /*            "ShiftDate=" + string(ub.rvs-doc.shift-date) + {&delim-par} +*/

             "SHIFT_NUM_DOC=" + (if string(ub.rvs-doc.shift-num) = ? then '' else string(ub.rvs-doc.shift-num)) + (if string(ub.rvs-doc.shift-date) = ? then '' else string(ub.rvs-doc.shift-date, "99999999")) + {&delim-par} +  
             "SHIFT_NUM=" + (if string(v-shift-num) = ? then '' else string(v-shift-num)) + (if string(v-shift-date) = ? then '' else string(v-shift-date, "99999999")) + {&delim-par} +


            "PlCode=" + string(bf_rvs-line.pl-code) + {&delim-par} +
/*            "Density=" + string( bf_rvs-line.density ) + {&delim-par} +*/
            "Temperature=" + string(bf_rvs-line.state-temperature) + {&delim-par} +
            "StateDensity=" + string( bf_rvs-line.state-density) + {&delim-par} +
            "StateMeasureQnty=" + string(  bf_rvs-line.state-measure-qnty  ) + {&delim-par} + 
            "StateBruttoQnty=" +  string(bf_rvs-line.state-brutto-qnty ) + {&delim-par} +
            "StateMeasureCliQnty=" + string(bf_rvs-line.state-measure-cli-qnty)  + {&delim-par} +
            "StateBruttoCliQnty=" + string(bf_rvs-line.state-brutto-cli-qnty ) +  {&delim-par} +
            "StateLevelTotal=" + string(  bf_rvs-line.state-level-total) +  {&delim-par} +
            "StateLevelPetrol=" + string(  bf_rvs-line.state-level-petrol  ) +  {&delim-par} + 
            "StateLevelWater=" + string(  bf_rvs-line.state-level-water    ) +  {&delim-par} +  
            "StateMeasureTcQnty=" + string(  bf_rvs-line.state-measure-tc-qnty  ) +   {&delim-par} +  
            "StateBruttoTcQnty=" + string(   bf_rvs-line.state-brutto-tc-qnty ) +   {&delim-par} +              
            "RESULT=" + string( 0 ) + {&delim-par} + 
            "Description="  no-error.
        
        /*    run trg/video-action.p (input v-vid-action,*/
        /*        input v-vid-param,                     */
        /*        output v-vid-ok,                       */
        /*        output v-vid-mes) .                    */
        /*                                               */
        
        run trg/userlog.p (
            input {&nwsdochs_action_create}
            , input {&table_rvs-doc}
            , input ( buffer ub.rvs-doc :handle )
            , input v-vid-action
            , input v-vid-param
            ) no-error.
        if error-status :error
            then
        do:
          return error substitute( "&2&1Ошибка при записи истории пользователя&1&3&1&4"
                , {&new-line}
                , vss-workfile
                , return-value
                , error-status :get-message ( 1 ) ).
        end.
    end.
  RETURN .
END PROCEDURE. /* lib-rvs_fill1plc */

 


procedure lib-rvs_fill2plc : /* fill-one-place without measure */
  define input        parameter           p-obj-type  like ub.rvs-line.obj-type no-undo.
  define input        parameter           p-obj-code  like ub.rvs-line.obj-code no-undo.
  define input        parameter           p-pl-code   like ub.rvs-line.pl-code  no-undo.
  define input        parameter           p-rec-line  as   recid                no-undo.
  define input        parameter           p-prev-code like ub.rvs-doc.rvs-code  no-undo.
  define input-output parameter table for tt-meas.

define variable p-prev-rvs-date as logical no-undo.
  define variable olddensvalue as character no-undo initial ?.
  define variable olddenstype  as character no-undo initial ?.
  define variable varnum-rsrv  as integer   no-undo.

  define buffer crl_prev_rvs-doc  for ub.rvs-doc.
  define buffer prev_rvs-line     for ub.rvs-line.
  define buffer bf_goods          for ub.goods.
  define buffer bf_gds-obj        for ub.gds-obj.
  define buffer bf-prev_doc-line  for ub.doc-line.
  define buffer bf-prev_inv-line  for ub.inv-line.
  define buffer bf-prp_goods      for ub.goods.
  define buffer bf-prp_pl-gds     for ub.pl-gds.
  define buffer bf_rvs-line       for ub.rvs-line.
  define buffer buf_doc-line-attr for ub.doc-line-attr .

  define variable v-qnty    as decimal      no-undo.

  find first bf_rvs-line
    where recid( bf_rvs-line ) = p-rec-line
  .

  find first buf_doc-line-attr
    where buf_doc-line-attr.doc-code   = bf_rvs-line.rvs-code
      and buf_doc-line-attr.gds-code   = bf_rvs-line.gds-code
      and buf_doc-line-attr.attr-code  = substitute("rvs-&1",bf_rvs-line.pl-code)
    no-error.
  if not available buf_doc-line-attr then do:
    return error substitute ( 'Ошибка. Данные по документам не заполнены по месту хранения &1.', p-pl-code ).
  end.
  else do:
    assign
      v-qnty = decimal(entry(1, buf_doc-line-attr.attr-value, {&delim-par}))
    .
  end.

  assign
    bf_rvs-line.state-measure-qnty     = v-qnty
    bf_rvs-line.state-measure-tc-qnty  = v-qnty
  .

    find first crl_prev_rvs-doc no-lock
      where crl_prev_rvs-doc.rvs-code = p-prev-code
      no-error.

    if available crl_prev_rvs-doc then do:
      find first prev_rvs-line no-lock where
                 prev_rvs-line.rvs-code = crl_prev_rvs-doc.rvs-code and
                 prev_rvs-line.obj-type = bf_rvs-line.obj-type      and
                 prev_rvs-line.obj-code = bf_rvs-line.obj-code      and
                 prev_rvs-line.pl-code  = bf_rvs-line.pl-code       and
                 prev_rvs-line.gds-code = bf_rvs-line.gds-code      no-error.
      if available prev_rvs-line then do:
        assign
          bf_rvs-line.state-level-water      = prev_rvs-line.state-level-water
          bf_rvs-line.state-density          = prev_rvs-line.state-density
          bf_rvs-line.state-brutto-qnty      = bf_rvs-line.state-measure-qnty + ( prev_rvs-line.state-brutto-qnty - prev_rvs-line.state-measure-qnty )

          bf_rvs-line.state-brutto-tc-qnty  = bf_rvs-line.state-brutto-qnty
          bf_rvs-line.state-measure-cli-qnty = bf_rvs-line.state-measure-qnty * bf_rvs-line.state-density
          bf_rvs-line.state-brutto-cli-qnty  = bf_rvs-line.state-brutto-qnty  * bf_rvs-line.state-density
        .
        find first bf_goods   no-lock where
                   bf_goods.gds-code    = bf_rvs-line.gds-code.
        find first bf_gds-obj no-lock where
                   bf_gds-obj.obj-type  = bf_rvs-line.obj-type and
                   bf_gds-obj.obj-code  = bf_rvs-line.obj-code and
                   bf_gds-obj.artic     = bf_goods.artic       and
                   bf_gds-obj.prod-code = bf_goods.prod-code   and
                   bf_gds-obj.prod-code = bf_goods.prod-code   no-error.
        if available bf_gds-obj then do:
          if bf_gds-obj.fact-qnty <> 0 then do:
            find last bf-prev_doc-line no-lock where
                      bf-prev_doc-line.obj-type   = bf_rvs-line.obj-type and
                      bf-prev_doc-line.obj-code   = bf_rvs-line.obj-code and
                      bf-prev_doc-line.prod-type  = bf_goods.prod-type   and
                      bf-prev_doc-line.prod-code  = bf_goods.prod-code   and
                      bf-prev_doc-line.artic      = bf_goods.artic       and
                      bf-prev_doc-line.status_    = {&fact}              and
                      bf-prev_doc-line.fact-order > 0                    use-index fact-order no-error.
            if available bf-prev_doc-line then do:
              find first bf-prev_inv-line no-lock where
                         bf-prev_inv-line.doc-code  = bf-prev_doc-line.doc-code  and
                         bf-prev_inv-line.artic     = bf-prev_doc-line.artic     and
                         bf-prev_inv-line.prod-code = bf-prev_doc-line.prod-code and
                         bf-prev_inv-line.prod-type = bf-prev_doc-line.prod-type no-error.
              if available bf-prev_inv-line then do:
                assign
                  bf_rvs-line.system-cli-qnty = bf_rvs-line.system-qnty * bf-prev_inv-line.after-cli-qnty
                                                                        / bf_gds-obj.fact-qnty
                .
              end.
            end.
            else do:
              assign
                bf_rvs-line.system-cli-qnty = 0.00
              .
            end.
          end.
          else do: /* gds-obj.fact-qnty = 0 */
            find last bf-prev_doc-line no-lock where
                      bf-prev_doc-line.obj-type   = bf_rvs-line.obj-type and
                      bf-prev_doc-line.obj-code   = bf_rvs-line.obj-code and
                      bf-prev_doc-line.prod-type  = bf_goods.prod-type   and
                      bf-prev_doc-line.prod-code  = bf_goods.prod-code   and
                      bf-prev_doc-line.artic      = bf_goods.artic       and
                      bf-prev_doc-line.status_    = {&fact}              and
                      bf-prev_doc-line.fact-order > 0                    use-index fact-order no-error.
            if available bf-prev_doc-line then do:
              find first bf-prev_inv-line no-lock where
                         bf-prev_inv-line.doc-code  = bf-prev_doc-line.doc-code  and
                         bf-prev_inv-line.artic     = bf-prev_doc-line.artic     and
                         bf-prev_inv-line.prod-code = bf-prev_doc-line.prod-code and
                         bf-prev_inv-line.prod-type = bf-prev_doc-line.prod-type no-error.
              if available bf-prev_inv-line then do:
                find first bf-prp_goods no-lock where
                           bf-prp_goods.artic     = bf-prev_inv-line.artic     and
                           bf-prp_goods.prod-type = bf-prev_inv-line.prod-type and
                           bf-prp_goods.prod-code = bf-prev_inv-line.prod-code .
                assign
                  varnum-rsrv = 0
                .
                for each bf-prp_pl-gds no-lock where
                         bf-prp_pl-gds.gds-code = bf-prp_goods.gds-code and
                         bf-prp_pl-gds.obj-type = bf_rvs-line.obj-type  and
                         bf-prp_pl-gds.obj-code = bf_rvs-line.obj-code
                on error undo, return error return-value
                :
                  assign
                    varnum-rsrv = varnum-rsrv + 1
                  .
                end. /* for each bf-prp_pl-gds */
                /* Пропорционально размазываем остаток в килограммах по количеству баков */
                assign
                  bf_rvs-line.system-cli-qnty = bf-prev_inv-line.after-cli-qnty / varnum-rsrv
                .
              end. /* if available bf-prev_inv-line */
            end. /* if available bf-prev_doc-line */
            else do:
              assign
                bf_rvs-line.system-cli-qnty = 0.00
              .
            end.
          end. /* gds-obj.fact-qnty = 0 */
        end. /* if available bf_gds-obj */
        else do: /* if not available bf_gds-obj */
          assign
            bf_rvs-line.system-cli-qnty = 0.00
          .
        end. /* if not available bf_gds-obj */
      end. /* if available prev_rvs-line */
    end. /* if available crl_prev_rvs-doc */
    
    { gbl/ptrlprop.i run p-obj-type p-obj-code }    
        IF ptrlprop-olddens = true
        and not is-sug(bf_rvs-line.gds-code)
        THEN 
        DO:
            p-prev-rvs-date = NO.
            FIND FIRST rvs-doc WHERE rvs-doc.rvs-code = bf_rvs-line.rvs-code NO-LOCK NO-ERROR.
          
            prev: FOR EACH crl_prev_rvs-doc NO-LOCK
                WHERE crl_prev_rvs-doc.obj-type   = p-obj-type
                AND crl_prev_rvs-doc.obj-code   = p-obj-code
                AND crl_prev_rvs-doc.shift-date = rvs-doc.shift-date 
                AND crl_prev_rvs-doc.shift-num  = rvs-doc.shift-num
                AND crl_prev_rvs-doc.status_    = {&fact}
                /* and contr_rvs-doc.rvs-type = {&rvs-control} */
                BY crl_prev_rvs-doc.fact-order DESC
                ON ERROR UNDO, RETURN ERROR RETURN-VALUE
                :
                    
                IF CAN-FIND( FIRST doc-attr
                    WHERE doc-attr.doc-code  = crl_prev_rvs-doc.rvs-code
                    AND doc-attr.attr-code = "rvs-auto":U
                    AND doc-attr.attr-value = "Yes":U 
                    NO-LOCK)
                    THEN next prev.
                    
                    
                FIND LAST prev_rvs-line NO-LOCK
                    WHERE prev_rvs-line.rvs-code = crl_prev_rvs-doc.rvs-code
                    AND prev_rvs-line.obj-type = p-obj-type
                    AND prev_rvs-line.obj-code = p-obj-code
                    AND prev_rvs-line.pl-code  =  bf_rvs-line.pl-code
                    AND prev_rvs-line.gds-code = bf_rvs-line.gds-code
                    NO-ERROR .
                IF AVAILABLE prev_rvs-line THEN 
                DO:
                    bf_rvs-line.state-density = prev_rvs-line.state-density.
                    bf_rvs-line.state-temperature = prev_rvs-line.state-temperature.
                    p-prev-rvs-date = YES.  
                    LEAVE prev .
                END.
            END.
     
          
            IF   p-prev-rvs-date = NO THEN 
            DO :
                FIND FIRST crl_prev_rvs-doc NO-LOCK WHERE
                    crl_prev_rvs-doc.rvs-code = p-prev-code NO-ERROR .
                IF AVAILABLE crl_prev_rvs-doc THEN 
                DO:
                    FIND FIRST prev_rvs-line NO-LOCK WHERE
                        prev_rvs-line.rvs-code = crl_prev_rvs-doc.rvs-code AND
                        prev_rvs-line.obj-type = bf_rvs-line.obj-type      AND
                        prev_rvs-line.obj-code = bf_rvs-line.obj-code      AND
                        prev_rvs-line.pl-code  = bf_rvs-line.pl-code       AND
                        prev_rvs-line.gds-code = bf_rvs-line.gds-code      NO-ERROR .
                    IF AVAILABLE prev_rvs-line THEN 
                    DO:
                        ASSIGN
                            bf_rvs-line.state-temperature = prev_rvs-line.state-temperature
                            bf_rvs-line.density                = prev_rvs-line.state-density
                            bf_rvs-line.state-density          = prev_rvs-line.state-density
                            bf_rvs-line.measure-cli-qnty       = bf_rvs-line.measure-qnty       * bf_rvs-line.density
                            bf_rvs-line.brutto-cli-qnty        = bf_rvs-line.brutto-qnty        * bf_rvs-line.density
                            bf_rvs-line.state-measure-cli-qnty = bf_rvs-line.state-measure-qnty * bf_rvs-line.density
                            bf_rvs-line.state-brutto-cli-qnty  = bf_rvs-line.state-brutto-qnty  * bf_rvs-line.density
                            .
                    END. /* if available prev_rvs-line */
                END.
            END. /* if available crl_prev_rvs-doc */
        END. /* if ptrlprop-olddens = true */
    
    
    
    
  return .
end procedure. /* lib-rvs_fill2plc */


procedure lib-rvs_rvs-full :
  define input parameter p-rvs-code like ub.rvs-doc.rvs-code no-undo.

  define variable l_rvs-is-full as logical no-undo initial yes.
  define variable v-attr-value  as character no-undo .
  define variable v-attr-type   as character no-undo .

  define buffer bf_place    for ub.place.
  define buffer bf_pl-gds   for ub.pl-gds.
  define buffer bf_rvs-doc  for ub.rvs-doc.
  define buffer bf_rvs-line for ub.rvs-line.

  tr:
  do
  on error undo tr, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
  on stop  undo tr, return error substitute( "&1 (stop).", vss-workfile )
  on quit  undo tr, return error substitute( "&1 (quit).", vss-workfile )
  :
    find first bf_rvs-doc exclusive-lock
      where bf_rvs-doc.rvs-code = p-rvs-code
      no-error.
    if not available bf_rvs-doc then do:
      undo tr, return error substitute( 'lib-rvs_rvs-full: не найдена сверка "&1"', p-rvs-code ).
    end.

    for each bf_place  no-lock
      where bf_place.obj-type = bf_rvs-doc.obj-type
        and bf_place.obj-code = bf_rvs-doc.obj-code
      ,each bf_pl-gds no-lock
      where bf_pl-gds.obj-type = bf_place.obj-type
        and bf_pl-gds.obj-code = bf_place.obj-code
        and bf_pl-gds.pl-code  = bf_place.pl-code
    on error undo tr, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
    :
      run gds-attr-value in this-procedure
        ( input  bf_pl-gds.gds-code
         ,input  {&attr-ptrl-without-rvs}
         ,output v-attr-value
         ,output v-attr-type
        ) .
      if lookup(v-attr-value, 'true,yes':u) = 0 then do:
        find first bf_rvs-line no-lock
          where bf_rvs-line.rvs-code = bf_rvs-doc.rvs-code
            and bf_rvs-line.obj-type = bf_pl-gds.obj-type
            and bf_rvs-line.obj-code = bf_pl-gds.obj-code
            and bf_rvs-line.pl-code  = bf_pl-gds.pl-code
            and bf_rvs-line.gds-code = bf_pl-gds.gds-code
          no-error.
        if not available bf_rvs-line then do:
          assign
            l_rvs-is-full = no
          .
          leave .
        end.
      end.
    end. /* for each */

    if l_rvs-is-full = yes then do:
      assign
        bf_rvs-doc.is-full = yes
      .
    end.
  end. /* on error */
  return .
end procedure. /* lib-rvs_rvs-full */

procedure lib-rvs_rvsclose : /* rvs-clos */

  define input  parameter parparentproc as widget-handle no-undo.
  define input  parameter p-rec-rvs-doc as recid   no-undo.
  define input  parameter p-message-on  as logical no-undo.

  define buffer rc_rvs-doc  for ub.rvs-doc.
  define buffer bef-rvs-doc for ub.rvs-doc.
  define buffer bf_trn-doc  for ub.trn-doc.

  define variable varchk-prs  as character no-undo.
  define variable v_data-type as character no-undo.
  define variable g-log       as logical   no-undo.
  define variable v-chk-act   as character no-undo .

  { gbl/getcntxt.i def }
  run get-userid in parparentproc ( output v-cntxt-userid).
  run get-db-num in parparentproc ( output v-cntxt-db-num).

  do
  on error undo, return error substitute( "lib-rvs_rvsclose: &1&2&3", return-value, {&new-line}, error-status :get-message ( 1 ) )
  :
    find first rc_rvs-doc
      where recid( rc_rvs-doc ) = p-rec-rvs-doc
    .
    if rc_rvs-doc.rvs-type <> {&rvs-before-doc}
      and rc_rvs-doc.rvs-type <> {&rvs-after-doc}
    then do:

      { gbl/getsect.i run "''" 0 {&attr-nakl-glob} }
      for each thbjattr_thbj-attr :
        if thbjattr_thbj-attr.prop-code = 'chk-prs' then varchk-prs = string(thbjattr_thbj-attr.property-value-logical,"yes/no") .
      end.
      empty temp-table thbjattr_thbj-attr.
      if varchk-prs <> 'no' then do:
        if not can-find( ub.clients no-lock where
                         ub.clients.obj-type = {&prs} and
                         ub.clients.obj-code = rc_rvs-doc.boss )
        then do:
          return error 'Не указан или неправильный менеджер.' .
        end.
        if not can-find( ub.clients no-lock where
                         ub.clients.obj-type = {&prs} and
                         ub.clients.obj-code = rc_rvs-doc.agnt )
        then do:
          return error 'Не указан или неправильный исполнитель.' .
        end.
      end.
    end.

    case rc_rvs-doc.rvs-type :
      when {&rvs-before-doc}
      or when {&rvs-after-doc}
      then do:
        assign
          v-chk-act = 'actn_rvs-on-doc_fact':U
        .
      end.
      when {&rvs-shift}
      then do:
        assign
          v-chk-act = 'actn_rvs-shift_fact':U
        .
      end.
      when {&rvs-control}
      then do:
        assign
          v-chk-act = 'actn_rvs-control_fact':U
        .
      end.
      otherwise do:
        message
          vss-workfile vss-revision vss-description skip
          "Неизвестный тип документа сверки" skip
          "Тип документа сверки" rc_rvs-doc.rvs-type skip
          "Код документа сверки" rc_rvs-doc.rvs-code skip
          view-as alert-box error .
        undo, return error return-value .
      end.
    end case .
    if not g#auto then do:
      { gbl/chk-actg.i
        v-cntxt-db-num
        v-cntxt-userid
        {&action-head-code-main}
        v-chk-act
        {&cntxt-object}
        rc_rvs-doc.host-code
        rc_rvs-doc.obj-type
        rc_rvs-doc.obj-code
        0
        0
        0
        p-message-on
        g-log
      }
      if g-log <> yes then do:
        return error substitute( 'У Вас недостаточно прав для выполнения данного действия:&5'
                               + '"закрытие сверки типа <<&1>> на факт" на объекте: &2 &3.&5'
                               + '&4&5'
                               + 'Обратитесь к администратору.'
                               , rc_rvs-doc.rvs-type
                               , rc_rvs-doc.obj-type
                               , rc_rvs-doc.obj-code
                               , return-value
                               , {&new-line} ) .
      end.
    end.
    tr:
    do transaction
    on error   undo tr, return error return-value
    on end-key undo tr, return error return-value
    :
      run gbl/chk-date.p
        ( input rc_rvs-doc.obj-type
        , input rc_rvs-doc.obj-code
        , input rc_rvs-doc.fact-date
        , input rc_rvs-doc.fact-time
        , input rc_rvs-doc.shift-date
        , input rc_rvs-doc.shift-num
        , input p-message-on
        ) no-error .
      if error-status :error then do:
        undo tr, return error substitute( 'lib-rvs_rvsclose: Ошибка при установке даты в документе (rvs-doc)&1&2.', {&new-line}, return-value ) .
      end.

      if rc_rvs-doc.rvs-type = {&rvs-shift}
        and rc_rvs-doc.status_  = {&permitted}
      then do:
        { str/rvschtrn.i
          rc_rvs-doc.obj-type
          rc_rvs-doc.obj-code
          rc_rvs-doc.shift-date
          rc_rvs-doc.shift-num
          rc_rvs-doc.rvs-code
          no
          yes
          g-log
          no-error
        }
        if error-status :error then do:
          undo tr, return error 'lib-rvs_rvsclose: Ошибка поиска незакрытых документов. '  + return-value .
        end.
        if g-log <> no then do:
          undo tr, return error 'lib-rvs_rvsclose: Невозможно создать сверку. ' + return-value .
        end.
      end.

      /* прописывание оборота по документам в атрибуты */
      define variable v-ok    as logical      no-undo.
      run str/rvs-attr.p
        ( input rc_rvs-doc.rvs-code
        , input rc_rvs-doc.obj-type
        , input rc_rvs-doc.obj-code
        , output v-ok
        ) no-error.
      if error-status :error
        or v-ok = false
      then do:
         /*
         undo tr, return error SUBSTITUTE( "Ошибка прописывания остатков. &1", return-value ) .
         */
      end.

      run str/rvs-stat.p
        ( input parparentproc
         ,input recid( rc_rvs-doc )
         ,input 'close':U
        ) no-error .
      if error-status :error then do:
        undo tr, return error substitute( 'lib-rvs_rvsclose: Ошибка при изменении статуса&1&2.', {&new-line}, return-value ) .
      end.
      release rc_rvs-doc no-error.
      if error-status:error then    undo tr, return error  return-value .

      
      find first rc_rvs-doc where recid( rc_rvs-doc ) = p-rec-rvs-doc .
      /* Если закрыли сменную сверку, то закрываем смену */
      if rc_rvs-doc.rvs-type = {&rvs-shift}
        and rc_rvs-doc.status_  = {&fact}
      then do:
        run gbl/sht-clos.p
          ( input parparentproc
           ,input rc_rvs-doc.obj-type
           ,input rc_rvs-doc.obj-code
           ,input false /* без кассовых проверок т.к. они производятся при создании сверки */
           ,input (if p-message-on = true then false else true )
          ) no-error .
        if error-status :error then do:
          undo tr, return error 'Ошибка при закрытии смены. ' + return-value .
        end.
      end.
    end. /* transaction */
  end. /* on error */
  return .
end procedure. /* lib-rvs_rvsclose */

procedure lib-rvs_crtt-rvs : /* cr-tt-param */
  define input-output parameter table for tt-param.
  define       output parameter           p-comstring   as character no-undo initial ?.
  define       output parameter           p-comment     as character no-undo initial ?.
  define       output parameter           p-StartString as character no-undo initial ?.

  define variable rvsvalue       as character no-undo initial ?.
  define variable rvstype        as character no-undo initial ?.
  define variable StrFrFile-list as character no-undo initial '':U.
  define variable FldDb-list     as character no-undo initial '':U.
  define variable jj             as integer   no-undo.

  { gbl/conf-rd.i
      "'revision'"
      "''"
      "''"
      0
      "''"
      "''"
      "''"
      no
      rvsvalue
      rvstype
      no-error
  }
  assign
    rvsvalue       = trim( rvsvalue )
    StrFrFile-list = 'level_total,level_water,level_oil,t1,t2,t3,temperature,density,'
                   + 'volume_total,volume_total_tc,mass_total,volume_oil,volume_water,vapor_density,vapor_pressure'
    FldDb-list     = 'level-total,level-water,level-petrol,temp-layer1,temp-layer2,temp-layer3,temperature,density,'
                   + 'brutto-qnty,brutto-qnty-tc,brutto-cli-qnty,measure-qnty,water-qnty,vapor-density,vapor-pressure'
  .
  if rvsvalue = ? then do:
    assign
      rvsvalue = 'struna'
    .
  end.

  p-comstring = ibs.th.gbl.gbl-inipar:comstr .
  if p-comstring <> ?    and
     p-comstring <> '':U
  then do:
    case rvsvalue :
      when 'struna'     or
      when 'vedee-root'
      then do:
        for each tt-param :
          delete tt-param .
        end.
        assign
          p-comment     = '#'
          p-StartString = 'tank'
        .
        do jj = 1 to min( num-entries( StrFrFile-list ), num-entries( FldDb-list ) ) :
          create tt-param.
          assign
                 tt-param.strfrfile = entry( jj, StrFrFile-list )
                 tt-param.flddb     = entry( jj, FldDb-list     )
          .
        end.
      end.
      otherwise do:
        return error 'Неизвестный тип прибора в параметре revision.' .
      end.
    end case.
  end.
  return .
end procedure. /* lib-rvs_crtt-rvs */

procedure lib-rvs_crtt-pmp : /* cr-tt-param-pump */
  define input-output parameter table for tt-param-pump.
  define       output parameter           p-comstrpump   as character no-undo initial ?.

  define variable StrFrFile-list as character no-undo initial 'PUMP,NZL,VOL,VAL,GRADE,CNT,STATUS':U.
  define variable jj             as integer   no-undo.

  get-key-value section 'revision'
                key     'comstrpump'
                value    p-comstrpump.
  if p-comstrpump <> ?    and
     p-comstrpump <> '':U
  then do:
    for each tt-param-pump :
      delete tt-param-pump .
    end.
    do jj = 1 to num-entries( StrFrFile-list ) :
      create tt-param-pump.
      assign
             tt-param-pump.strfrfile = entry( jj, StrFrFile-list )
      .
    end.
  end.
  else do:
    return error 'Не указана командная строка для чтения данных с ТРК. Секция revision. Ключ comstrpump.' .
  end.
  return .
end procedure. /* lib-rvs_crtt-pmp */

procedure lib-rvs_anls-pmp : /* analysis-pump */
  define input        parameter           p-parent-proc       as   widget-handle       no-undo.
  define input        parameter           p-obj-type          like ub.rvs-doc.obj-type no-undo.
  define input        parameter           p-obj-code          like ub.rvs-doc.obj-code no-undo.
  define input        parameter           p-check-goods       as   logical             no-undo.
  define input-output parameter table for tt-pump-nozzle-file.
  define input-output parameter table for tt-pump-nozzle.
  define input        parameter           p-read-cur          as   logical             no-undo.
  define input        parameter           p-message-on        as   logical             no-undo.

  define variable j_pump-code   like ub.pump-nozzle.pump-code   no-undo.
  define variable j_nozzle-code like ub.pump-nozzle.nozzle-code no-undo.
  define variable j_gds-code    like ub.goods.gds-code          no-undo.
  define variable is_Error      as   logical                    no-undo initial no.
  define variable is_FatalError as   logical                    no-undo initial no.

  /* Объявляем переменные для чтения из строки */
  define variable v_File-Name   as character no-undo.
  define variable v_File-Err    as character no-undo.
  define variable v_command     as character no-undo.
  define variable v_String-Temp as character no-undo.
  define variable v_String      as character no-undo.
  define variable v_Prefix      as character no-undo.
  define variable v_Param       as character no-undo.
  define variable v_String-Tail as character no-undo.
  define variable j_Space       as integer   no-undo.

  define variable j_b-code      like ub.bar-code.b-code        no-undo.
  define variable d_rate        like ub.bar-code.cli-base-rate no-undo.
  define variable conf-par      as   character                 no-undo.
  define variable par-type      as   character                 no-undo.
  define variable v_result      as   character                 no-undo.
  define variable v_type-bc     as   character                 no-undo.
  define variable d_weight      as   decimal                   no-undo.
  define variable v_DirFilePump as   character                 no-undo.
  define variable j_num         as   integer                   no-undo.
  define variable l_log         as   logical                   no-undo.
  define variable v_CommandPump as   character                 no-undo initial ?.

  define buffer bf_goods      for ub.goods.
  define buffer bf_goods-file for ub.goods.
  define buffer bf_bar-code   for ub.bar-code.

  { str/sclspref.i }

  { str/crtt-pmp.i
      tt-param-pump
      v_CommandPump
      no-error
  }
  if error-status :error then do:
    {&SetCursorNo}
    return error substitute( 'Ошибка при установке параметров для считывания данных с ТРК.&1&2&1&3'
                           , {&new-line}
                           , error-status :get-message( 1 )
                           , return-value ) .
  end.

  if p-read-cur = ? then do:
    if p-message-on = no then do:
      assign
        p-read-cur = yes
      .
    end.
    else do:
      run gbl/d-askw.w
        (  input 'Выбор источника данных с информацией по ТРК'
        ,  input 'Будем читать текущие данные с ТРК или возьмем данные из файла?'
        ,  input '|^'
        ,  input 'Текущие данные|Из файлов|Отмена'
        ,  input 'Запускается программа для обращения к датчикам ТРК|'
        +        'Берутся уже сохраненные данные из файла|Ничего не делаем'
        ,  input 1
        ,  input 3
        , output j_num
        ) .
      case j_num :
        when 3 then do:
          return error .
        end.
        when 2 then do:
          assign
            p-read-cur = yes
          .
        end.
        when 1 then do:
          assign
            p-read-cur = no
          .
        end.
      end case. /* j_num */
    end.
  end.

  if p-read-cur = yes then do:
    assign
      v_File-Name = './pump.txt'
      v_File-Err  = substitute('&1pump.err', ibs.th.gbl.gbl-inipar:logDir) .
    .
    os-delete value( v_File-Name ) .
    assign
      v_command = v_CommandPump + ' ':U + v_File-Name
    .
    os-command silent value( v_command ) .
    if search( v_File-Name ) = ? then do:
      return /* error */ 'Файл с данными ТРК не получен.' . /* технологи сказали, что это не должно стопорить создание сверки */
    end.
  end.
  else do:
    v_DirFilePump = ibs.th.gbl.gbl-inipar:dirflpmp .
    if v_DirFilePump = '':U or
       v_DirFilePump = ?
    then do:
      assign
        v_DirFilePump = ' .'
      .
    end.
    system-dialog get-file v_File-Name
      initial-dir v_DirFilePump
      title       'Выберите файл с данными по ТРК'
      update      l_log.
    if l_log <> yes then do:
      return error .
    end.
    v_File-Err  = substitute("&1.err":U,  entry(1, v_File-Name, '.':U)) .
  end.

  &scop pf-put-err  output stream str-err to value( v_File-Err ) append.~
                    put stream str-err unformatted cur-time-string-sec() ' '
  &scop wsf-put-err skip . ~
                    output stream str-err close.~
                    assign ~
                      is_Error = yes ~
                    .
  &scop ksf-put-err ' в строке: ' v_String-Temp ~
                    {&wsf-put-err}
  &scop sf-put-err  {&ksf-put-err} ~
                    next main-cycle.

  for each tt-pump-nozzle-file :
    delete tt-pump-nozzle-file .
  end.

  input stream str-anl from value( v_File-Name ) .
  main-cycle:
  repeat :
    import stream str-anl unformatted v_String-Temp.
    /* Отсекем комментарий */
    if trim( v_String-Temp ) = '':U then next main-cycle .
    if substring( v_String-Temp, 1, 3 ) <> '212' then next main-cycle .
    
    assign
      v_Prefix =       substring( v_String-Temp, 1, 4 )
      v_String = trim( substring( v_String-Temp, 5    ) )
    .
    /* Очищаем прошлые значения */
    for each tt-param-pump :
      assign
             tt-param-pump.meaning = ? .
    end.

    /* Читаем очередную строку */
    assign
      v_String-Tail = v_String
    .
    do while v_String-Tail <> '':U :
      assign
        j_Space = index( v_String-Tail, ' ':U )
      .
      /* последний параметр */
      if j_Space = 0 then do:
        assign
          v_Param       = trim( v_String-Tail )
          v_String-Tail = '':U
        .
      end.
      else do:
        assign
          v_Param       = trim( substring( v_String-Tail, 1, j_Space - 1 ) )
          v_String-Tail = trim( substring( v_String-Tail,    j_Space     ) )
        .
      end.

      find first tt-param-pump where
                 tt-param-pump.strfrfile = trim( entry( 1, v_Param, '=' ) ) no-error .
      if not available tt-param-pump then do:
        {&pf-put-err} 'Обнаружен неизвестный параметр: ' v_Param {&ksf-put-err}
      end.
      else do:
        assign
          tt-param-pump.meaning = trim( entry( 2, v_Param, '=' ) )
        .
      end.
    end. /* while */

    /* Проверяем, что указана правильная ТРК */
    find first tt-param-pump where
               tt-param-pump.strfrfile = 'PUMP' .
    if       tt-param-pump.meaning   = ?    or
       trim( tt-param-pump.meaning ) = '':U
    then do:
      {&pf-put-err} 'Неизвестный код ТРК: ' tt-param-pump.meaning {&sf-put-err}
    end.
    assign
      j_pump-code = integer( tt-param-pump.meaning )
    .

    /* Проверяем то, что указан правильный пистолет */
    find first tt-param-pump where
               tt-param-pump.strfrfile = 'NZL' .
    if       tt-param-pump.meaning   = ?    or
       trim( tt-param-pump.meaning ) = '':U
    then do:
      {&pf-put-err} 'Неизвестный код пистолета ТРК: ' tt-param-pump.meaning {&sf-put-err}
    end.
    assign
      j_nozzle-code = integer( tt-param-pump.meaning )
    .

    /* Если некорректный статус, то пишем в log */
    find first tt-param-pump where
               tt-param-pump.strfrfile = 'STATUS' .
    if integer( tt-param-pump.meaning ) <> 0 then do:
      {&pf-put-err} 'Ошибка при чтении данных с ТРК(статус из поля status): ' tt-param-pump.meaning {&sf-put-err}
    end.

    /* Находим товар по топливному коду */
    find first tt-param-pump where
               tt-param-pump.strfrfile = 'GRADE' .
    if       tt-param-pump.meaning   = ?    or
       trim( tt-param-pump.meaning ) = '':U
    then do:
      if p-check-goods = yes then do:
        {&pf-put-err} 'Неизвестный топливный код товара: ' tt-param-pump.meaning {&sf-put-err}
      end.
      else do:
        assign
          j_gds-code = ?
        .
        {&pf-put-err} 'Неизвестный топливный код товара: ' tt-param-pump.meaning {&ksf-put-err}
      end.
    end.
    else do:
      /* Если указан, что код топлива 0, то полагаем, что топливо из этого пистолета не льется */
      if integer( tt-param-pump.meaning ) = 0 then do:
        assign
          j_gds-code = ?
        .
      end.
      else do:
        assign
          j_b-code = ?
          d_rate   = ?
        .
        { str/bc-rcnz.i
            p-parent-proc
            tt-param-pump.meaning
            ?
            p-obj-type
            p-obj-code
            yes
            no
            varscales-pref
            varpgscales-pref
            v_result
            v_type-bc
            d_weight
            ub.bar-code
            ub.prod-bc
            ub.place
            no-error
        }
        if error-status :error then do:
          if p-message-on = yes then do:
            return error 'Ошибка при разборе бар-кода' .
          end.
          else do:
            message 'Ошибка при разборе бар-кода' view-as alert-box.
            return error .
          end.
        end.
        if not available ub.bar-code then do:
          assign
            j_b-code = ?
          .
        end.
        else do:
          assign
            j_b-code = ub.bar-code.b-code
            d_rate   = ub.bar-code.cli-base-rate
          .
        end.
        if j_b-code = ? then do:
          if p-check-goods = yes then do:
            {&pf-put-err}
              'Невозможно определить основной бар-код по топливному коду: ' tt-param-pump.meaning
            {&sf-put-err}
          end.
          else do:
            assign
              j_gds-code = ?
            .
            {&pf-put-err}
              'Невозможно определить основной бар-код по топливному коду: ' tt-param-pump.meaning
            {&ksf-put-err}
          end.
        end.
        else do:
          if d_rate <> 1.00 then do:
            {&pf-put-err}
              'Замечание(cтрока обработана) . Некорректный курс: ' d_rate ' основного бар-кода: ' j_b-code
            {&ksf-put-err}
          end.
          find first bf_bar-code no-lock
            where bf_bar-code.b-code = j_b-code
            .
          find first bf_goods no-lock
            where bf_goods.gds-code  = bf_bar-code.gds-code
            .
          assign
            j_gds-code = bf_goods.gds-code
          .
        end.
      end.
    end. /* товар по топливному коду */

    /* Создаем запись по считаному */
    create tt-pump-nozzle-file.
    assign
           tt-pump-nozzle-file.obj-type    = p-obj-type
           tt-pump-nozzle-file.obj-code    = p-obj-code
           tt-pump-nozzle-file.pump-code   = j_pump-code
           tt-pump-nozzle-file.nozzle-code = j_nozzle-code
           tt-pump-nozzle-file.gds-code    = j_gds-code
    .

    find first tt-param-pump where
               tt-param-pump.strfrfile = 'VOL' .
    assign
      tt-pump-nozzle-file.meas-el-cnt = decimal( tt-param-pump.meaning )
    .
    find first tt-param-pump where
               tt-param-pump.strfrfile = 'VAL' .
    assign
      tt-pump-nozzle-file.meas-am-cnt = decimal( tt-param-pump.meaning )
    .
    find first tt-param-pump where
               tt-param-pump.strfrfile = 'CNT' .
    assign
      tt-pump-nozzle-file.meas-cf-cnt = decimal( tt-param-pump.meaning )
    .
  end. /* конец чтения из файла */
  input stream str-anl close.

  /* Считаные и запрошенные таблицы должны совпадать */
  for each tt-pump-nozzle-file :
    find first tt-pump-nozzle where
               tt-pump-nozzle.obj-type    = tt-pump-nozzle-file.obj-type    and
               tt-pump-nozzle.obj-code    = tt-pump-nozzle-file.obj-code    and
               tt-pump-nozzle.pump-code   = tt-pump-nozzle-file.pump-code   and
               tt-pump-nozzle.nozzle-code = tt-pump-nozzle-file.nozzle-code no-error .
    if not available tt-pump-nozzle then do:
        /*
      assign
        is_FatalError = yes
      .
      */
      {&pf-put-err}
        'Из файла получены данные по ТРК ' + string( tt-pump-nozzle-file.pump-code   ) +
        ' и пистолету '                    + string( tt-pump-nozzle-file.nozzle-code ) +
        ' на объекте '                     +         tt-pump-nozzle-file.obj-type      + ' ':U
                                           + string( tt-pump-nozzle-file.obj-code    ) +
        ' которого нет в конфигурации.'
      {&wsf-put-err}
      delete tt-pump-nozzle-file.
    end. /* if not available tt-pump-nozzle */
    else do: /* if available tt-pump-nozzle */
      /* Проверим на соответствие товаров */
      if tt-pump-nozzle-file.gds-code <> tt-pump-nozzle.gds-code then do:
        if tt-pump-nozzle-file.gds-code <> ? then do:
          find first bf_goods-file no-lock where
                     bf_goods-file.gds-code = tt-pump-nozzle-file.gds-code .
        end.
        if tt-pump-nozzle.gds-code <> ? then do:
          find first bf_goods no-lock where
                     bf_goods.gds-code = tt-pump-nozzle.gds-code .
        end.
        {&pf-put-err}
          'Из файла получены данные по ТРК ' + string( tt-pump-nozzle-file.pump-code   ) +
          ' пистолету '                      + string( tt-pump-nozzle-file.nozzle-code ) +
          ( if tt-pump-nozzle-file.gds-code = ? then ' c неопределенным кодом товара'
                                                else ' товар ' +
                                               string( bf_goods-file.artic             ) + ' ':U +
                                               string( bf_goods-file.prod-type         ) + ' ':U +
                                               string( bf_goods-file.prod-code         ) )       +
          ' на объекте '                     + string( tt-pump-nozzle-file.obj-type    ) + ' ':U +
                                               string( tt-pump-nozzle-file.obj-code    ) +
          ' для которых не совпадает конфигурация товара по системе: '                   +
          ( if tt-pump-nozzle.gds-code = ? then ' по системе нет связи с товаром '
                                           else ' товар ' +
                                               string( bf_goods.artic                  ) + ' ':U +
                                               string( bf_goods.prod-type              ) + ' ':U +
                                               string( bf_goods.prod-code              ) )
        {&wsf-put-err}
        if p-check-goods = yes then do:
          assign
            is_FatalError = yes
          .
        end.
      end. /* if tt-pump-nozzle-file.gds-code <> tt-pump-nozzle.gds-code */
    end. /* if available tt-pump-nozzle */
  end. /* for each tt-pump-nozzle-file */

  for each tt-pump-nozzle :
    find first tt-pump-nozzle-file where
               tt-pump-nozzle-file.obj-type    = tt-pump-nozzle.obj-type    and
               tt-pump-nozzle-file.obj-code    = tt-pump-nozzle.obj-code    and
               tt-pump-nozzle-file.pump-code   = tt-pump-nozzle.pump-code   and
               tt-pump-nozzle-file.nozzle-code = tt-pump-nozzle.nozzle-code no-error .
    if not available tt-pump-nozzle-file then do:
      assign
        is_FatalError = yes
      .
      {&pf-put-err}
        'Неполучены данные по ТРК ' + string( tt-pump-nozzle.pump-code   ) +
        ' и пистолету '             + string( tt-pump-nozzle.nozzle-code ) +
        ' на объекте '              +         tt-pump-nozzle.obj-type      +
        ' ':U                       + string( tt-pump-nozzle.obj-code    ) +
        ' по конфигурации.'
      {&wsf-put-err}
    end. /* if not available tt-pump-nozzle-file */
  end. /* for each tt-pump-nozzle */

  output stream str-err to value( v_File-Err ) append.
  put stream str-err unformatted skip(0) .
  output stream str-err close .
  define variable v-save-file-name as character no-undo .
  v-save-file-name = substitute("&1pmp-err.log", ibs.th.gbl.gbl-inipar:logDir) .
  OS-APPEND value(v_File-Err) value(v-save-file-name).

  if is_FatalError = yes then do:
    return error 'Во время загрузки файла произошли фатальные ошибки, НЕПОЗВОЛЯЮЩИЕ ЗАГРУЗИТЬ ДАННЫЕ С ТРК. ' +
                 'Log-файл с описанием ошибок ' + v_File-Err + ' .' .
  end.

  /* Записываем данные для возврата */
  for each tt-pump-nozzle :
    find first tt-pump-nozzle-file where
               tt-pump-nozzle-file.obj-type    = tt-pump-nozzle.obj-type    and
               tt-pump-nozzle-file.obj-code    = tt-pump-nozzle.obj-code    and
               tt-pump-nozzle-file.pump-code   = tt-pump-nozzle.pump-code   and
               tt-pump-nozzle-file.nozzle-code = tt-pump-nozzle.nozzle-code .
    assign
      tt-pump-nozzle.meas-el-cnt = tt-pump-nozzle-file.meas-el-cnt
      tt-pump-nozzle.meas-am-cnt = tt-pump-nozzle-file.meas-am-cnt
      tt-pump-nozzle.meas-cf-cnt = tt-pump-nozzle-file.meas-cf-cnt
    .
  end. /* for each tt-pump-nozzle */

  if is_Error = yes then do:
    return 'Во время загрузки файла были ошибки. Log-файл с описанием ошибок ' + v_File-Err + ' .' +
           'ДАННЫЕ С ТРК ЗАГРУЖЕНЫ В СИСТЕМУ.' .
  end.
  return .
end procedure. /* lib-rvs_anls-pmp */

procedure lib-rvs_rvsclchd : /* recalc-header */
  define input parameter p-rec-rvs-doc as recid   no-undo.
  define input parameter p-recalc-line as logical no-undo.

  define buffer bf_rvs-doc  for ub.rvs-doc.
  define buffer bf_rvs-line for ub.rvs-line.

  tr:
  do transaction
  on error undo tr, return error
  on stop  undo tr, return error
  on quit  undo tr, return error
  :
    find first bf_rvs-doc
      where recid( bf_rvs-doc ) = p-rec-rvs-doc
    .
    for each bf_rvs-line
      where bf_rvs-line.rvs-code = bf_rvs-doc.rvs-code
        and bf_rvs-line.obj-type = bf_rvs-doc.obj-type
        and bf_rvs-line.obj-code = bf_rvs-doc.obj-code
    on error undo, return error return-value
    :
      if p-recalc-line = yes then do:
         { str/rvsclcln.i
             "recid( bf_rvs-line )"
             no-error
         }
         if error-status :error then do:
           undo tr, return error substitute( 'Ошибка при расчете строки (место: &2, код товара: &3) сверки "&1".&4&5&4&6'
                                           , bf_rvs-doc.rvs-code
                                           , bf_rvs-line.pl-code
                                           , bf_rvs-line.gds-code
                                           , {&new-line}
                                           , error-status :get-message( 1 )
                                           , return-value ) .
         end.
      end.
      accumulate
        bf_rvs-line.measure-qnty ( total )
        bf_rvs-line.brutto-qnty ( total )
        bf_rvs-line.measure-cli-qnty ( total )
        bf_rvs-line.brutto-cli-qnty ( total )
        bf_rvs-line.level-total ( total )
        bf_rvs-line.level-petrol ( total )
        bf_rvs-line.level-water ( total )
        bf_rvs-line.state-measure-qnty ( total )
        bf_rvs-line.state-brutto-qnty ( total )
        bf_rvs-line.state-measure-cli-qnty ( total )
        bf_rvs-line.state-brutto-cli-qnty ( total )
        bf_rvs-line.state-level-total ( total )
        bf_rvs-line.state-level-petrol ( total )
        bf_rvs-line.state-level-water ( total )
        bf_rvs-line.meas-am-qnty ( total )
        bf_rvs-line.meas-mh-qnty ( total )
        bf_rvs-line.meas-cf-qnty ( total )
        bf_rvs-line.state-am-qnty ( total )
        bf_rvs-line.state-cf-qnty ( total )
        bf_rvs-line.state-mh-qnty ( total )
        bf_rvs-line.system-qnty ( total )
        bf_rvs-line.system-cli-qnty ( total )
        bf_rvs-line.add-qnty ( total )
        bf_rvs-line.state-add-qnty ( total )
        bf_rvs-line.system-cli-avrg-qnty ( total )
        bf_rvs-line.measure-tc-qnty ( total )
        bf_rvs-line.brutto-tc-qnty ( total )
      .
    end. /* for each bf_rvs-line */


    assign
       bf_rvs-doc.measure-qnty = ( accum total bf_rvs-line.measure-qnty )
       bf_rvs-doc.brutto-qnty = ( accum total bf_rvs-line.brutto-qnty )
       bf_rvs-doc.measure-cli-qnty = ( accum total bf_rvs-line.measure-cli-qnty )
       bf_rvs-doc.brutto-cli-qnty = ( accum total bf_rvs-line.brutto-cli-qnty )
       bf_rvs-doc.level-total = ( accum total bf_rvs-line.level-total )
       bf_rvs-doc.level-petrol = ( accum total bf_rvs-line.level-petrol )
       bf_rvs-doc.level-water = ( accum total bf_rvs-line.level-water )
       bf_rvs-doc.state-measure-qnty = ( accum total bf_rvs-line.state-measure-qnty )
       bf_rvs-doc.state-brutto-qnty = ( accum total bf_rvs-line.state-brutto-qnty )
       bf_rvs-doc.state-measure-cli-qnty = ( accum total bf_rvs-line.state-measure-cli-qnty )
       bf_rvs-doc.state-brutto-cli-qnty = ( accum total bf_rvs-line.state-brutto-cli-qnty )
       bf_rvs-doc.state-level-total = ( accum total bf_rvs-line.state-level-total )
       bf_rvs-doc.state-level-petrol = ( accum total bf_rvs-line.state-level-petrol )
       bf_rvs-doc.state-level-water = ( accum total bf_rvs-line.state-level-water )
       bf_rvs-doc.meas-am-qnty = ( accum total bf_rvs-line.meas-am-qnty )
       bf_rvs-doc.meas-mh-qnty = ( accum total bf_rvs-line.meas-mh-qnty )
       bf_rvs-doc.meas-cf-qnty = ( accum total bf_rvs-line.meas-cf-qnty )
       bf_rvs-doc.state-am-qnty = ( accum total bf_rvs-line.state-am-qnty )
       bf_rvs-doc.state-cf-qnty = ( accum total bf_rvs-line.state-cf-qnty )
       bf_rvs-doc.state-mh-qnty = ( accum total bf_rvs-line.state-mh-qnty )
       bf_rvs-doc.system-qnty = ( accum total bf_rvs-line.system-qnty )
       bf_rvs-doc.system-cli-qnty = ( accum total bf_rvs-line.system-cli-qnty )
       bf_rvs-doc.add-qnty = ( accum total bf_rvs-line.add-qnty )
       bf_rvs-doc.state-add-qnty = ( accum total bf_rvs-line.state-add-qnty )
       bf_rvs-doc.system-cli-avrg-qnty = ( accum total bf_rvs-line.system-cli-avrg-qnty )
       bf_rvs-doc.measure-tc-qnty = ( accum total bf_rvs-line.measure-tc-qnty )
       bf_rvs-doc.brutto-tc-qnty = ( accum total bf_rvs-line.brutto-tc-qnty )
    .
  end. /* transaction */
  return .
end procedure. /* lib-rvs_rvsclchd */

procedure lib-rvs_rvsclcln : /* recalc-line */
  define input parameter p-rec-id as recid no-undo.

  define buffer bf_rvs-line      for ub.rvs-line.
  define buffer bf_rvs-line-pump for ub.rvs-line-pump.
  define buffer bf_goods for ub.goods.

  find first bf_rvs-line
    where recid( bf_rvs-line ) = p-rec-id
  .
  for each bf_rvs-line-pump
    where bf_rvs-line-pump.rvs-code = bf_rvs-line.rvs-code
      and bf_rvs-line-pump.obj-type = bf_rvs-line.obj-type
      and bf_rvs-line-pump.obj-code = bf_rvs-line.obj-code
      and bf_rvs-line-pump.pl-code  = bf_rvs-line.pl-code
      and bf_rvs-line-pump.gds-code = bf_rvs-line.gds-code
  on error undo, return error return-value
  :
    accumulate
      bf_rvs-line-pump.meas-am-qnty ( total )
      bf_rvs-line-pump.meas-cf-qnty ( total )
      bf_rvs-line-pump.meas-mh-qnty ( total )
      bf_rvs-line-pump.state-am-qnty ( total )
      bf_rvs-line-pump.state-cf-qnty ( total )
      bf_rvs-line-pump.state-mh-qnty ( total )
    .
  end. /* for each bf_rvs-line-pump */

  assign
    bf_rvs-line.meas-am-qnty = ( accum total bf_rvs-line-pump.meas-am-qnty )
    bf_rvs-line.meas-cf-qnty = ( accum total bf_rvs-line-pump.meas-cf-qnty )
    bf_rvs-line.meas-mh-qnty = ( accum total bf_rvs-line-pump.meas-mh-qnty )
    bf_rvs-line.state-am-qnty = ( accum total bf_rvs-line-pump.state-am-qnty )
    bf_rvs-line.state-cf-qnty = ( accum total bf_rvs-line-pump.state-cf-qnty )
    bf_rvs-line.state-mh-qnty = ( accum total bf_rvs-line-pump.state-mh-qnty )
  .
  /* Проставим плотность для виртуального резервуара (из карточки товара) */
  define variable is-vir as logical no-undo.
  define variable v-value as character no-undo.
  define variable v-ok as logical no-undo.
  
  run placelib_get-attr(input {&place-virtual}
                       ,input bf_rvs-line.obj-code
                       ,input bf_rvs-line.obj-type
                       ,input bf_rvs-line.pl-code
                       ,output v-value
                       ,output v-ok) no-error.
  is-vir = if (v-ok and logical(v-value)) then true else false.
  if is-vir then do:
    if bf_rvs-line.system-cli-qnty <> 0 and bf_rvs-line.system-qnty <> 0 then
        bf_rvs-line.state-density = bf_rvs-line.system-cli-qnty / (bf_rvs-line.system-qnty).
    else do:
      find first bf_goods where bf_goods.gds-code = bf_rvs-line.gds-code no-lock.
      bf_rvs-line.state-density = 1 / bf_goods.cli-base-rate.
    end.
  end.
  return .
end procedure. /* lib-rvs_rvsclcln */

/* Запись скорректированных сверок в историю */
procedure lib-rvs_hstc-rvs :

  define parameter buffer buf_rvs-doc for  ub.rvs-doc .
  define input  parameter p-action    like ub.c-rvs-doc.action no-undo.
  define input  parameter p-out-code  like ub.rvs-doc.out-code no-undo.
  define input  parameter parchip-num as   integer             no-undo.

  do
  on error undo, return error substitute( "&1 (hstc-rvs). &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
  :
    define buffer buf_doc-attr        for ub.doc-attr.
    define buffer buf_c-doc-attr      for ub.c-doc-attr.
    define buffer buf_rvs-line        for ub.rvs-line.
    define buffer buf_rvs-line-pump   for ub.rvs-line-pump.
    define buffer buf_c-rvs-doc       for ub.c-rvs-doc.
    define buffer buf_c-rvs-line      for ub.c-rvs-line.
    define buffer buf_c-rvs-line-pump for ub.c-rvs-line-pump.

    define variable v-date        as   date                    no-undo .
    define variable v-time        as   integer                 no-undo .
    define variable v-shift-on    as   logical                 no-undo .
    define variable v-shift-date  like ub.shift-obj.shift-date no-undo .
    define variable v-shift-num   like ub.shift-obj.shift-num  no-undo .
    define variable v-shift-name  like ub.shift-obj.shift-name no-undo.


    if not available buf_rvs-doc then do:
      undo, return error substitute( "&1 (hstc-rvs). Ошибка задания входных параметров. Отсутствует запись сверки по которой создается история", vss-workfile ) .
    end.

    if parchip-num = ?
      or parchip-num = 0
    then do:
      undo, return error substitute( "&1 (hstc-rvs). Ошибка задания входных параметров. Не указан номер щепки (chip-num)", vss-workfile ) .
    end.

    find first buf_c-rvs-doc no-lock
      where buf_c-rvs-doc.rvs-code = buf_rvs-doc.rvs-code
        and buf_c-rvs-doc.chip-num = parchip-num
      no-error .
    if available buf_c-rvs-doc then do:
      return.
    end.

    run cur-time in this-procedure
      ( output v-date
       ,output v-time
      ).

    assign
      v-shift-date = ?
      v-shift-num  = ?
      v-shift-name = ?
    .

    { gbl/objat.i
      buf_rvs-doc.obj-type
      buf_rvs-doc.obj-code
      "'shift-on=request'"
      v-shift-on
    }
    if v-shift-on = yes then do:
      /* на объекте включены смены */
      { gbl/curshift.i
        buf_rvs-doc.obj-type
        buf_rvs-doc.obj-code
        v-shift-date
        v-shift-num
        v-shift-name
        no-error
      }
    end.

    create buf_c-rvs-doc.
    buffer-copy buf_rvs-doc to buf_c-rvs-doc
      assign
        buf_c-rvs-doc.action           = p-action
        buf_c-rvs-doc.chip-num         = parchip-num
        buf_c-rvs-doc.corr-doc-code    = p-out-code
        buf_c-rvs-doc.corr-date        = v-date
        buf_c-rvs-doc.corr-time        = v-time
        buf_c-rvs-doc.corr-shift-date  = v-shift-date
        buf_c-rvs-doc.corr-shift-num   = v-shift-num
        buf_c-rvs-doc.corr-shift-name  = v-shift-name
        buf_c-rvs-doc.corr-user-name   = g#userid
        buf_c-rvs-doc.corr-user-db-num = g#db-num
    .
    for each buf_doc-attr
      where buf_doc-attr.doc-code = buf_rvs-doc.rvs-code
    on error undo, return error return-value
    :
      create buf_c-doc-attr.
      buffer-copy buf_doc-attr to buf_c-doc-attr
        assign
          buf_c-doc-attr.chip-num         = buf_c-rvs-doc.chip-num
          buf_c-doc-attr.corr-user-name   = buf_c-rvs-doc.corr-user-name
          buf_c-doc-attr.corr-user-db-num = buf_c-rvs-doc.corr-user-db-num
      .
    end.
    for each buf_rvs-line
      where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
    on error undo, return error return-value
    :
      create buf_c-rvs-line.
      buffer-copy buf_rvs-line to buf_c-rvs-line
        assign
          buf_c-rvs-line.chip-num         = buf_c-rvs-doc.chip-num
          buf_c-rvs-line.corr-user-db-num = buf_c-rvs-doc.corr-user-db-num
      .
    end.
    for each buf_rvs-line-pump where buf_rvs-line-pump.rvs-code = buf_rvs-doc.rvs-code :
      create buf_c-rvs-line-pump.
      buffer-copy buf_rvs-line-pump to buf_c-rvs-line-pump
        assign
          buf_c-rvs-line-pump.chip-num         = buf_c-rvs-doc.chip-num
          buf_c-rvs-line-pump.corr-user-db-num = buf_c-rvs-doc.corr-user-db-num
      .
    end.
  end.
  return .
end procedure.

procedure get-from-ifsf :
  define variable v-asi-ip  as character no-undo .
  define variable v-asi-port as character no-undo .
  define variable v-attr-type as character no-undo .
  define variable v_command     as   character     no-undo.
  define variable v_File-Name   as   character     no-undo.
  define variable v-log     as logical no-undo .
  define variable v-bytes   as integer no-undo .
  define variable v-out-data as character no-undo .
  define variable v-line-str as character no-undo .
  define variable ii        as integer no-undo .
  define variable str       as character no-undo .
  define variable str1      as character no-undo .
  
  define variable hSocket   as handle no-undo .
  define variable mDataIn   as memptr no-undo .
  define variable mDataout  as memptr no-undo .
  define variable cmd       as character no-undo .
  define variable connStr   as character no-undo .
  
  define variable StrFrFile-list as character no-undo initial '':U.
  
  StrFrFile-list = 'tank,level_total,level_water,level_oil,t1,t2,t3,temperature,density,'
                   + 'volume_total,volume_total_tc,mass_total,volume_oil,volume_water,vapor_density,vapor_pressure' .
  
  assign
    v_File-Name = 'revis.ifsf':U
  .
  os-delete value( v_File-Name ) .
  
  cmd = 'KOI8-R 1 0 1' + {&new-line} .
  set-size(mDataIn) = 0 .
  set-size(mDataIn) = length(cmd , "RAW":U) + 1 .
  put-string(mDataIn,1) = cmd .
  
  find first sys-ctrl no-lock.
  run db-attr-value(sys-ctrl.db,"AsiIp",output v-asi-ip,output v-attr-type).
  run db-attr-value(sys-ctrl.db,"AsiPort",output v-asi-port,output v-attr-type).
  
  create socket hSocket .
  connStr = '-H ' + v-asi-ip + ' -S ' + v-asi-port .
  hSocket:connect(connStr) no-error.
  
  if hSocket:connected() = false
  then do :
    return error "Не могу подключиться к IFSF серверу." .
  end.
  
  hSocket:set-socket-option('TCP-NODELAY', 'true').
  hSocket:set-socket-option('SO-KEEPALIVE', 'true').
  hSocket:set-socket-option('SO-REUSEADDR', 'true').
  
  v-log = hSocket:write(mDataIn, 1, get-size(mDataIn)) no-error.
  if v-log = false or error-status:get-message(1) <> ''
  then do:
    return error "Не могу отправить команду на IFSF сервер." .
  end.
  run sleep (1000) .
  
  set-size(mDataOut) = 0 .
  v-bytes = hSocket:get-bytes-available() .
  set-size(mDataOut) = v-bytes + 1 .
  
  v-log = hSocket:read(mDataOut, 1, v-bytes, 2) no-error.
  if v-log = false or error-status:get-message(1) <> ''
  then do:
    return error "Не могу прочитать ответ от IFSF сервера." .
  end.
  
  v-out-data = get-string(mDataOut,1) .
  
  hSocket:disconnect() no-error.
  delete object hSocket.
  set-size(mDataIn) = 0.
  set-size(mDataOut)   = 0.
  
  output to value(v_File-Name) .
  
  do ii = 1 to num-entries(v-out-data, {&new-line}) :
    str = entry(ii, v-out-data, {&new-line}) .
    str1 = trim(entry(1, str, "=")) .
    if can-do(StrFrFile-list, str1)
    then do :
      put unformatted str skip .
    end.
  end.
  
  output close.

end procedure .

PROCEDURE Sleep EXTERNAL "kernel32.DLL":
  DEFINE INPUT PARAMETER intMilliseconds AS LONG.
END PROCEDURE.


/* $Workfile$   E n d */