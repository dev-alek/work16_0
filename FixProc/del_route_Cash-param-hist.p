block-level on error undo, throw.
{utl\runpro.i}
{cmp\str-glbl.i}
for each route where route.name-rec begins "command" + {&delim-nws} + "delete"  + {&delim-nws} + "Cash-param-hist" :
delete route.
end.          
