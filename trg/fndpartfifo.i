find {1} buf_parts
  where buf_parts.obj-type  = buf_doc-line.obj-type
    and buf_parts.obj-code  = buf_doc-line.obj-code
    and buf_parts.artic     = buf_doc-line.artic
    and buf_parts.prod-type = buf_doc-line.prod-type
    and buf_parts.prod-code = buf_doc-line.prod-code
    and buf_parts.out-code  = v-rsrv-code
    and buf_parts.status_   = no
    and buf_parts.fact-qnty >= p-chg-qnty
    {2}
  use-index FIFO
  no-error.
