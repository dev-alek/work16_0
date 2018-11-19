/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Обновление схемы БД через df 

Автор: Морозов Александр Сергеевич
Дата создания: 04/23/18
Author: Morozov Alexandr
Creation date: 04/23/18


*/


run prodict/load_df.r (session:parameter + ",yes").
quit.