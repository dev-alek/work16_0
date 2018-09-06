/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

создание записи _user при создании логина user-login

Автор: Белоусов Илья Александрович
Дата создания:
Author: Ilia Belousov
Creation date:

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

    if {1}.user-login.status_ = {&bef-user-status-normal}
    then do:
      find first {1}.user-account
           where {1}.user-account.user-id = {1}.user-login.user-id
           no-lock
           no-error .
      if not available {1}.user-account
      then do:
        message
          vss-workfile vss-revision vss-description skip
          "Не найден пользователь" skip
          "Идентификатор" {1}.user-login.user-id skip
          view-as alert-box error .
        undo, return error return-value .
      end.


      find first {1}._user
           where {1}._user._userid    = {1}.user-login.user-login
           no-error
           .
      if not available {1}._user then do:
         create {1}._user .
         assign
            {1}._user._userid    = {1}.user-login.user-login
            {1}._user._password  = {1}.user-login.user-password-encoded
         .
      end.
      ELSE DO:
         DEFINE TEMP-TABLE tempUser NO-UNDO LIKE {1}._User.

         BUFFER-COPY {1}._User EXCEPT {1}._User._Password {1}._User._TenantId TO tempUser ASSIGN tempUser._Password = {1}.user-login.user-password-encoded
         .
         DELETE {1}._User.
         CREATE {1}._User.
         BUFFER-COPY tempUser EXCEPT tempUser._TenantId TO _User.
      END.
      assign
        {1}._user._user-name = substitute('&1 &2 &3'
                                        ,{1}.user-account.last-name
                                        ,{1}.user-account.first-name
                                        ,{1}.user-account.second-name
                                        )
      .
    end.

/* $Workfile$ e n d */