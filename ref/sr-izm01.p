/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Сохранение изменений в карточке средства измерения (прибора)

Автор: Молотков Сергей
Дата создания: 04/12/17
Author: Molotkov Sergey
Creation date: 04/12/17

Мастеръ Гамбсъ этимъ полукресломъ
начинаетъ новую партiю мебели.
1865 г.
Санктъ-Петербургъ.

ОТДЕЛЕНИЕ БИЗНЕС-ЛОГИКИ ОТ ИНТЕРФЕЙСА!!!!!

*/
block-level on error undo, throw.

/*define input parameter p-mode     as character no-undo .*/
define input parameter p-node-code             as integer no-undo . /* like ub.sr-izmerenia.node-code */
define input parameter p-sr-model              as character no-undo . /* like ub.sr-izmerenia.sr-model */
define input parameter p-sr-type-id            as integer no-undo . /* like ub.sr-izmerenia.sr-type-id */
define input parameter p-sr-abs-err-neft-water as decimal no-undo . /* like ub.sr-izmerenia.sr-abs-err-neft-water */
define input parameter p-sr-abs-err-water      as decimal no-undo . /* like ub.sr-izmerenia.sr-abs-err-water */
define input parameter p-sr-abs-err-dens       as decimal no-undo . /* like ub.sr-izmerenia.sr-abs-err-dens */
define input parameter p-sr-abs-err-temp-vol   as decimal no-undo . /* like ub.sr-izmerenia.sr-abs-err-temp-vol */
define input parameter p-sr-abs-err-temp-dens  as decimal no-undo . /* like ub.sr-izmerenia.sr-abs-err-temp-dens */
define input parameter p-sr-otnos              as decimal no-undo . /* like ub.sr-izmerenia.sr-otnos */
define input parameter p-sr-temp-line          as decimal no-undo . /* like ub.sr-izmerenia.sr-temp-line */
define output parameter p-err-fld as character no-undo . /* имя поля с невалидным значением */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Сохранение изменений в карточке средства измерения (прибора)".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }

/* проверки значений */
define variable v-msg1  as character no-undo . /* "Абсолютная погреность измерений..." */
define variable v-msg2  as character no-undo . /* "...воды выходит за границы допустимого диапазона..." */
define variable v-delta as decimal decimals 2 no-undo . /* границы допустимого диапазона абсолютной погрешности измерений */

define buffer buf_sr-izmerenia for ub.sr-izmerenia .

/*  if lookup(p-mode, "{&bef-add-def},{&bef-update}") = 0 then do:                      */
/*    undo, throw new Progress.Lang.AppError(                                           */
/*      substitute("&1 &2 &3&4Неверный параметр p-mode. Не предусмотрена операция [&5]",*/
/*                 vss-workfile, vss-revision, vss-description, {&new-line},            */
/*                 p-mode )                                                             */
/*    ) .                                                                               */
/*  end .                                                                               */

  if p-sr-model > "" then .
  else do: /* Название не может быть пустым */
    p-err-fld = "sr-model":U .
    undo, throw new Progress.Lang.AppError(
      substitute("&1 &2 &3&4Пожалуйста заполните наименование модели средства измерения",
                 vss-workfile, vss-revision, vss-description, {&new-line})
    ) .
  end .
  
  assign
    v-msg1 = "Абсолютная погрешность измерений"
    v-msg2 = "выходит за границы допустимого диапазона"
    v-delta = 3 
  .
  if p-sr-abs-err-neft-water > v-delta or p-sr-abs-err-neft-water < (-1) * v-delta then do :
    p-err-fld = "sr-abs-err-neft-water":U .
    undo, throw new Progress.Lang.AppError(
      substitute("&1 &2 &3&4&5 уровня нефтепродукта и подтоварной воды &6 (+/-)&7 мм",
                 vss-workfile, vss-revision, vss-description, {&new-line}, 
                 v-msg1, v-msg2, v-delta)
    ) .
  end.
  if p-sr-abs-err-water > v-delta or p-sr-abs-err-water < (-1) * v-delta then do :
    p-err-fld = "sr-abs-err-water":U .
    undo, throw new Progress.Lang.AppError(
      substitute("&1 &2 &3&4&5 уровня подтоварной воды &6 (+/-)&7 мм",
                 vss-workfile, vss-revision, vss-description, {&new-line}, 
                 v-msg1, v-msg2, v-delta)
    ) .
  end.
  v-delta = 0.5 .
  if p-sr-abs-err-dens > v-delta or p-sr-abs-err-dens < (-1) * v-delta then do :
    p-err-fld = "sr-abs-err-dens":U .
    undo, throw new Progress.Lang.AppError(
      substitute("&1 &2 &3&4&5 плотности нефтепродукта ареометром &6 (+/-)&7 кг/м3",
                 vss-workfile, vss-revision, vss-description, {&new-line}, 
                 v-msg1, v-msg2, v-delta)
    ) .
  end.
  if p-sr-abs-err-temp-vol > v-delta or p-sr-abs-err-temp-vol < (-1) * v-delta then do :
    p-err-fld = "sr-abs-err-temp-vol":U .
    undo, throw new Progress.Lang.AppError(
      substitute("&1 &2 &3&4&5 температуры нефтепродукта при измерении его объема &6 (+/-)&7 °С",
                 vss-workfile, vss-revision, vss-description, {&new-line}, 
                 v-msg1, v-msg2, v-delta)
    ) .
  end.
  if p-sr-abs-err-temp-dens > v-delta or p-sr-abs-err-temp-dens < (-1) * v-delta then do :
    p-err-fld = "sr-abs-err-temp-dens":U .
    undo, throw new Progress.Lang.AppError(
      substitute("&1 &2 &3&4&5 температуры нефтепродукта при измерении его плотности &6 (+/-)&7 °С",
                 vss-workfile, vss-revision, vss-description, {&new-line}, 
                 v-msg1, v-msg2, v-delta)
    ) .
  end.
  v-delta = 0.05 .
  if p-sr-otnos > v-delta or p-sr-otnos < (-1) * v-delta then do :
    p-err-fld = "sr-otnos":U .
    undo, throw new Progress.Lang.AppError(
      substitute("&1 &2 &3&4Предел допускаемой относительной погрешности средства обработки результатов измерений &5 (+/-)&6 %",
                 vss-workfile, vss-revision, vss-description, {&new-line}, 
                 v-msg2, v-delta)
    ) .
  end.
  
  if p-sr-temp-line <> 0.0000125 /* сталь */ and
     p-sr-temp-line <> 0.000023  /* алюминий */ then do:
    p-err-fld = "sr-temp-line":U .
    undo, throw new Progress.Lang.AppError(
      substitute("&1 &2 &3&4Температурный коэффициент линейного расширения материала средства измерения уровня отличается от предопределённых значений для ~"сталь~" и для ~"алюминий~"",
                 vss-workfile, vss-revision, vss-description, {&new-line}) 
    ) .
  end .

  if can-find (first buf_sr-izmerenia
  where buf_sr-izmerenia.sr-model               =  p-sr-model
    AND buf_sr-izmerenia.sr-type-id             =  p-sr-type-id
    AND buf_sr-izmerenia.sr-abs-err-neft-water  =  p-sr-abs-err-neft-water
    AND buf_sr-izmerenia.sr-abs-err-water       =  p-sr-abs-err-water
    AND buf_sr-izmerenia.sr-abs-err-dens        =  p-sr-abs-err-dens
    AND buf_sr-izmerenia.sr-abs-err-temp-vol    =  p-sr-abs-err-temp-vol
    AND buf_sr-izmerenia.sr-abs-err-temp-dens   =  p-sr-abs-err-temp-dens
    AND buf_sr-izmerenia.sr-otnos               =  p-sr-otnos
    AND buf_sr-izmerenia.sr-temp-line           =  p-sr-temp-line
    AND buf_sr-izmerenia.node-code             <>  p-node-code
  ) then do:
    p-err-fld = "":U .
    undo, throw new Progress.Lang.AppError(
      substitute("&1 &2 &3&4Уже существует запись с совпадающими характеристиками, код которой отличается от [&5]",
                 vss-workfile, vss-revision, vss-description, {&new-line},
                 p-node-code) 
    ) .
  end .

  
  find first buf_sr-izmerenia exclusive-lock
       where buf_sr-izmerenia.node-code = p-node-code no-error no-wait .
  if locked(buf_sr-izmerenia) then do:
    undo, throw new Progress.Lang.AppError(
      substitute("&1 &2 &3&4Запись о средстве измерения с ид. [&5] занята другим пользователем",
                 vss-workfile, vss-revision, vss-description, {&new-line}, 
                 p-node-code )
      ) .
  end . 
  
  if available buf_sr-izmerenia then do:
  end .
  else do :
    create buf_sr-izmerenia .
    assign
      buf_sr-izmerenia.node-code = p-node-code
    .
  end .
  assign
    buf_sr-izmerenia.sr-model   = p-sr-model
    buf_sr-izmerenia.sr-type-id = p-sr-type-id
    buf_sr-izmerenia.sr-abs-err-neft-water = p-sr-abs-err-neft-water
    buf_sr-izmerenia.sr-abs-err-water      = p-sr-abs-err-water
    buf_sr-izmerenia.sr-abs-err-dens       = p-sr-abs-err-dens
    buf_sr-izmerenia.sr-abs-err-temp-vol   = sr-abs-err-temp-vol
    buf_sr-izmerenia.sr-abs-err-temp-dens  = p-sr-abs-err-temp-dens
    buf_sr-izmerenia.sr-otnos              = p-sr-otnos
    buf_sr-izmerenia.sr-temp-line          = p-sr-temp-line
  .
  validate buf_sr-izmerenia .
