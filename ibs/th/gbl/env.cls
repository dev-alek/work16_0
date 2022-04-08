 
 /*------------------------------------------------------------------------
    File        : env
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Wed Feb 19 22:50:18 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.objth.
using ibs.th.gbl.env.utd.
using ibs.th.gbl.env.marking.
using ibs.th.gbl.sys.env.ini.
using ibs.th.gbl.env.conf.
using ibs.th.gbl.env.prmtrs.section.


class ibs.th.gbl.env inherits objth: 
  
  define property Utd as class utd no-undo
    get.
    private set. 
    
  define property Marking as class marking no-undo
    get.
    private set.

  /* define property Conf as class conf no-undo
    get.
    private set.
из-за говно реализации клас оказался пустой 
*/
  define property ParametrsOfSection as class section no-undo
    get.
    private set.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  constructor public env (  ):
    super ().
    {utl\objreg.i Utd utd}.
    {utl\objreg.i Marking marking}
/*    {utl\objreg.i Conf conf }*/
    {utl\objreg.i ParametrsOfSection section }.
  end constructor.

end class.