 
 /*------------------------------------------------------------------------
    File        : tanksecsproc
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Mon Oct 01 17:03:48 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.str.ptrl.forms.tanksections.
using ibs.th.str.*.


class ibs.th.str.ptrl.tanksecsproc inherits tanksections: 

  define property Parentproc as handle no-undo
    get.
    private set.

  define property Mode as character no-undo
    get.
    private set.
 
  define property infoSecsObj as class ibs.th.str.InfoSectionsTotal no-undo
    get.
    private set.
 
  define property WasSetting as logical no-undo
    get.
    private set.
 
/*  define private variable infoSecsObj    as class     InfoSection no-undo.*/
    
  constructor public tanksecsproc (inInfoSecsObj as class ibs.th.str.InfoSectionsTotal, inparparent as handle, inmode as character):
    
    super ().
    if not valid-object (infoSecsObj)
    then do:
      undo, throw new Progress.Lang.AppError ("Ошибка при создании формы, передан неверный параметр, не иницализирован объект типа InfoSectionsTotal").
    end.
    Parentproc = inparparent.
    Mode = inmode.
    this-object:infoSecsObj = inInfoSecsObj.
    Initialization ().
    catch e as Progress.Lang.AppError:
      message e:ReturnValue view-as alert-box.
      undo, throw e.
    end catch.
    
  end constructor.
  
  method private void Initialization ():
    
    initSec(1).
    
  end.
  
  method private void initSec (ii as int):
    
    infoSecsObj:GetInfoSectionProp(ii).
    this-object:ShowSec ().
    catch e as Progress.Lang.AppError:
      undo, throw e.
    end catch.
    
  end.
  
  method private void ShowSec ():
    
    textBoxDocDens:Text = "dasfsd".
    
    
  end.
  
  
  method private void initProc ( input sender as System.Object, input e as System.EventArgs ):
  
    def var PtrlProp as class ibs.th.gbl.ptrl.opt.ptrlprop no-undo.

/*    this-object:CurrPage = 1.*/
/*    v-section-names = "".*/

/*    do ii = 1 to infoSecsObj:SectionNum:                                                                                                                                                  */
/*      v-section-names = v-section-names + "|" + 'Секция - ' + if infoSecsObj:GetInfoSectionProp(ii):SectionName = "" then string (ii) else infoSecsObj:GetInfoSectionProp(ii):SectionName.*/
/*    end.                                                                                                                                                                                  */
/*    if infoSecsObj:FlagTrn                                                                                                                                                            */
/*      then v-section-names = trim (v-section-names, "|") + (if (p-mode = {&update} or p-mode = {&add-def}) and infoSecsObj:SectionNum < maxSec then "|         +" else "") + "|Сумма".*/
/*      else v-section-names = trim (v-section-names, "|") + (if (p-mode = {&update} or p-mode = {&add-def}) and infoSecsObj:SectionNum < maxSec then "|         +" else "").           */
/*    run set-size(input frame {&FRAME-NAME}:height-pixels - 73, input frame {&FRAME-NAME}:width-pixels - 20).                                                                          */
/*    run initialize-folder (v-section-names).                                                                                                                                          *///    run show-current-page(input CurrPage).
/*    find first buf_goods no-lock           */
/*      where buf_goods.gds-code = p-gds-code*/
/*      .                                    */
    
    
    
/*    find first ub.trn-doc no-lock where ub.trn-doc.doc-code = p-doc-code no-error.*/
/*    if not infoSecsObj:IsRnAlgo*/
/*      then                     */
/*        hide                   */
/*          f-acc-weight         */
/*        in frame Dialog-Frame .*/
  
/*    wait-for go of frame {&FRAME-NAME} focus f-sec-num.*/
    
  end.


end class.