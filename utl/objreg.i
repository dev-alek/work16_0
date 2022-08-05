

&if "{3}" eq ""
&then
{1} = new {2} ().
&elseif "{4}" eq ""
&then
{1} = new {2} ({3}).
&elseif "{5}" eq ""
&then
{1} = new {2} ({3},{4}).
&else 
{1} = new {2} ({3},{4},{5}).
&endif
&if defined(GlobObjSrv) eq 0
&then
ObjSrv:Regobj(this-object,{1}).
&else
    Regobj(this-object,{1}).
&endif