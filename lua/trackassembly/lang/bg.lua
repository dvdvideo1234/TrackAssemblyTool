﻿return function(sTool, sLimit) local tSet = {} -- Bulgarian
  tSet["tool."..sTool..".info.1"        ] = "Обикновено създаване/залепяне"
  tSet["tool."..sTool..".info.2"        ] = "Пресичане на активни точки"
  tSet["tool."..sTool..".info.3"        ] = "Линейна сегментна интерполация"
  tSet["tool."..sTool..".info.4"        ] = "Преобръщане спрямо нормалата"
  tSet["tool."..sTool..".left.1"        ] = "Създаване/залепване на парче. Задръжте SHIFT за натрупване"
  tSet["tool."..sTool..".left.2"        ] = "Създаване на парче в пресечената точна на лъчите"
  tSet["tool."..sTool..".left.3"        ] = "Създаване на интерполирана крива на трасе от предмети"
  tSet["tool."..sTool..".left.4"        ] = "Създаване на огледалните парчета на избрания списък"
  tSet["tool."..sTool..".right.1"       ] = "Копиране на модела на парчето или отваряне на чести записи"
  tSet["tool."..sTool..".right.2"       ] = tSet["tool."..sTool..".right.1"]
  tSet["tool."..sTool..".right.3"       ] = "Създаване на възел за сегментна крива. Задръжте SHIFT да обновите"
  tSet["tool."..sTool..".right.4"       ] = "Регистриране на предмет в списъка за обръщане. Задръжте SHIFT за смяна на модела"
  tSet["tool."..sTool..".right_use.1"   ] = "Смяна на краищата при забранен SCROLL. Задръжте SHIFT за обратно и CTRL за следваща"
  tSet["tool."..sTool..".right_use.2"   ] = tSet["tool."..sTool..".right_use.1"]
  tSet["tool."..sTool..".right_use.3"   ] = tSet["tool."..sTool..".right_use.1"]
  tSet["tool."..sTool..".right_use.4"   ] = tSet["tool."..sTool..".right_use.1"]
  tSet["tool."..sTool..".reload.1"      ] = "Премахване на парче трасе. Задръжте SHIFT за да изберете опора"
  tSet["tool."..sTool..".reload.2"      ] = "Премахване на парче трасе. Задръжте SHIFT изберете релационен лъч"
  tSet["tool."..sTool..".reload.3"      ] = "Премахване на възел от интерполационната крива. Задръжте SHIFT за да изчистите стека"
  tSet["tool."..sTool..".reload.4"      ] = "Премахване на всички предмети от списъка за обръщане. Ако няма списък маха парче"
  tSet["tool."..sTool..".reload_use.1"  ] = "Позволете експорт на данните за да отворите DSV мениджър"
  tSet["tool."..sTool..".reload_use.2"  ] = tSet["tool."..sTool..".reload_use.1"]
  tSet["tool."..sTool..".reload_use.3"  ] = tSet["tool."..sTool..".reload_use.1"]
  tSet["tool."..sTool..".reload_use.4"  ] = tSet["tool."..sTool..".reload_use.1"]
  tSet["tool."..sTool..".desc"          ] = "Сглобява трасе по което да вървят превозните средства"
  tSet["tool."..sTool..".name"          ] = "Монтаж на трасе"
  tSet["tool."..sTool..".phytype"       ] = "Изберете типа на физическите свойства от дадените тук"
  tSet["tool."..sTool..".phytype_con"   ] = "Тип на повърхността:"
  tSet["tool."..sTool..".phytype_def"   ] = "<Избери тип на повърхността>"
  tSet["tool."..sTool..".phyname"       ] = "Изберете името на физическите свойства което да се използва при създаване на трасе като това ще повлияе на повърхностното триене"
  tSet["tool."..sTool..".phyname_con"   ] = "Име на повърхността:"
  tSet["tool."..sTool..".phyname_def"   ] = "<Избери име на повърхността>"
  tSet["tool."..sTool..".bgskids"       ] = "Селекционен код за избор на Телесна-група/Кожа ID"
  tSet["tool."..sTool..".bgskids_con"   ] = "Телесна-група/Кожа:"
  tSet["tool."..sTool..".bgskids_def"   ] = "Запишете селекционен код тук. Например 1,0,0,2,1/3"
  tSet["tool."..sTool..".mass"          ] = "Колко тежко ще бъде създаденото парче"
  tSet["tool."..sTool..".mass_con"      ] = "Маса на парчето:"
  tSet["tool."..sTool..".model"         ] = "Изберете парче за да започнете/продължите трасето си избирайки типа в дървото и кликайки на листо"
  tSet["tool."..sTool..".model_con"     ] = "Модел на парчето:"
  tSet["tool."..sTool..".activrad"      ] = "Минимално разстояние за да се избере активна точка"
  tSet["tool."..sTool..".activrad_con"  ] = "Активен радиус:"
  tSet["tool."..sTool..".stackcnt"      ] = "Максимален брой парчета които може да се създадат при натрупване"
  tSet["tool."..sTool..".stackcnt_con"  ] = "Брой парчета:"
  tSet["tool."..sTool..".angsnap"       ] = "Залепете първото създадено парче на толкова градуса"
  tSet["tool."..sTool..".angsnap_con"   ] = "Ъглово подравняване:"
  tSet["tool."..sTool..".resetvars"     ] = "Цъкнете за да нулирате допълнителните стойности"
  tSet["tool."..sTool..".resetvars_con" ] = "V Нулиране на променливите V"
  tSet["tool."..sTool..".nextpic"       ] = "Допълнително отместване на началото по тангаж"
  tSet["tool."..sTool..".nextpic_con"   ] = "Тангаж на началото:"
  tSet["tool."..sTool..".nextyaw"       ] = "Допълнително отместване на началото по азимут"
  tSet["tool."..sTool..".nextyaw_con"   ] = "Азимут на началото:"
  tSet["tool."..sTool..".nextrol"       ] = "Допълнително отместване на началото по крен"
  tSet["tool."..sTool..".nextrol_con"   ] = "Крен на началото:"
  tSet["tool."..sTool..".nextx"         ] = "Допълнително отместване на началото по абсциса"
  tSet["tool."..sTool..".nextx_con"     ] = "Отместване по абсциса:"
  tSet["tool."..sTool..".nexty"         ] = "Допълнително отместване на началото по ордината"
  tSet["tool."..sTool..".nexty_con"     ] = "Отместване по ордината:"
  tSet["tool."..sTool..".nextz"         ] = "Допълнително отместване на началото по апликата"
  tSet["tool."..sTool..".nextz_con"     ] = "Отместване по апликата:"
  tSet["tool."..sTool..".gravity"       ] = "Управлява гравитацията върху създаденото парче"
  tSet["tool."..sTool..".gravity_con"   ] = "Приложи гравитация върху парчето"
  tSet["tool."..sTool..".weld"          ] = "Създава заварки между парчетата или парчета/опора"
  tSet["tool."..sTool..".weld_con"      ] = "Създай заварка"
  tSet["tool."..sTool..".forcelim"      ] = "Управлява колко сила е необходима за да се счупи заварката"
  tSet["tool."..sTool..".forcelim_con"  ] = "Якост на заварката:"
  tSet["tool."..sTool..".ignphysgn"     ] = "Пренебрегва хващането с физическо оръдие на парчето създадено/залепено/натрупано"
  tSet["tool."..sTool..".ignphysgn_con" ] = "Пренебрегни хващането с физическо оръдие"
  tSet["tool."..sTool..".nocollide"     ] = "Създава не-сблъсък между парчетата или парчета/опора"
  tSet["tool."..sTool..".nocollide_con" ] = "Създай не-сблъсък"
  tSet["tool."..sTool..".nocollidew"    ] = "Създава не-сблъсък между парчетата и света"
  tSet["tool."..sTool..".nocollidew_con"] = "Създай не-сблъсък свят"
  tSet["tool."..sTool..".freeze"        ] = "Създава парчето в замразено състояние"
  tSet["tool."..sTool..".freeze_con"    ] = "Замрази парчето"
  tSet["tool."..sTool..".igntype"       ] = "Пренебрегва различните типове парчета при лепене/натрупване"
  tSet["tool."..sTool..".igntype_con"   ] = "Пренебрегни типа на парчето"
  tSet["tool."..sTool..".spnflat"       ] = "Следващото парче ще бъде създадено/залепено/натрупано хоризонтално"
  tSet["tool."..sTool..".spnflat_con"   ] = "Създай хоризонтално"
  tSet["tool."..sTool..".spawncn"       ] = "Създава парчето в центъра иначе спрямо избраната активна точка"
  tSet["tool."..sTool..".spawncn_con"   ] = "Начало спрямо центъра"
  tSet["tool."..sTool..".surfsnap"      ] = "Залепи парчето по повърхнината към която сочи потребителя"
  tSet["tool."..sTool..".surfsnap_con"  ] = "Залепи по повърхнината"
  tSet["tool."..sTool..".appangfst"     ] = "Приложи ъгловото отместване само върху първото парче за насочване"
  tSet["tool."..sTool..".appangfst_con" ] = "Приложи ъгловото на пръви"
  tSet["tool."..sTool..".applinfst"     ] = "Приложи линейното отместване само върху първото парче за позициониране"
  tSet["tool."..sTool..".applinfst_con" ] = "Приложи линейното на пръви"
  tSet["tool."..sTool..".adviser"       ] = "Управлява изобразяването на позиционен/ъглов съветник"
  tSet["tool."..sTool..".adviser_con"   ] = "Изобразявай съветника"
  tSet["tool."..sTool..".pntasist"      ] = "Управлява изобразяването на асистента за лепене"
  tSet["tool."..sTool..".pntasist_con"  ] = "Изобразявай асистента"
  tSet["tool."..sTool..".ghostcnt"      ] = "Управлява изобразяването на броя парчета сенки"
  tSet["tool."..sTool..".ghostcnt_con"  ] = "Изобразявай парчета сенки"
  tSet["tool."..sTool..".engunsnap"     ] = "Управлява залепването когато парчето е изпуснато с физическото оръдие на играча"
  tSet["tool."..sTool..".engunsnap_con" ] = "Залепване при изпускане"
  tSet["tool."..sTool..".type"          ] = "Изберете типа трасе коeто да използвате като разширите папката"
  tSet["tool."..sTool..".type_con"      ] = "Тип трасе:"
  tSet["tool."..sTool..".category"      ] = "Изберете категорията трасе която да използвате като разширите папката"
  tSet["tool."..sTool..".category_con"  ] = "Категория трасе:"
  tSet["tool."..sTool..".workmode"      ] = "Сменете тази опция за да изберете различен режим на работа"
  tSet["tool."..sTool..".workmode_con"  ] = "Работен режим:"
  tSet["tool."..sTool..".pn_export"     ] = "Цъкнете за да съхраните базата данни на файл"
  tSet["tool."..sTool..".pn_export_lb"  ] = "Съхрани DB"
  tSet["tool."..sTool..".pn_routine"    ] = "Списъкът с редовно използваните ви парчета трасе"
  tSet["tool."..sTool..".pn_routine_hd" ] = "Редовни парчета на:"
  tSet["tool."..sTool..".pn_externdb"   ] = "Налични външни бази данни на:"
  tSet["tool."..sTool..".pn_externdb_hd"] = "Външни бази данни на:"
  tSet["tool."..sTool..".pn_externdb_lb"] = "Десен клик за опции:"
  tSet["tool."..sTool..".pn_externdb_1" ] = "Копирай уникален префикс"
  tSet["tool."..sTool..".pn_externdb_2" ] = "Копирай пътя към DSV папката"
  tSet["tool."..sTool..".pn_externdb_3" ] = "Копирай ника на таблицата"
  tSet["tool."..sTool..".pn_externdb_4" ] = "Копирай пътя към таблицата"
  tSet["tool."..sTool..".pn_externdb_5" ] = "Копирай времето на таблицата"
  tSet["tool."..sTool..".pn_externdb_6" ] = "Копирай размера на таблицата"
  tSet["tool."..sTool..".pn_externdb_7" ] = "Редактирай елементите (Luapad)"
  tSet["tool."..sTool..".pn_externdb_8" ] = "Изтрий файла на базата данни"
  tSet["tool."..sTool..".pn_ext_dsv_lb" ] = "Външен DSV списък"
  tSet["tool."..sTool..".pn_ext_dsv_hd" ] = "Списъкъ на DSV базите данни е показан тук"
  tSet["tool."..sTool..".pn_ext_dsv_1"  ] = "Уникален префикс на базата"
  tSet["tool."..sTool..".pn_ext_dsv_2"  ] = "Активен"
  tSet["tool."..sTool..".pn_display"    ] = "Моделът на вашето парче трасе се показва тук"
  tSet["tool."..sTool..".pn_pattern"    ] = "Напишете шаблон тук и натиснете ЕНТЪР за да извършите търсене"
  tSet["tool."..sTool..".pn_srchcol"    ] = "Изберете по коя колона да извършите търсене"
  tSet["tool."..sTool..".pn_srchcol_lb" ] = "<Търси по>"
  tSet["tool."..sTool..".pn_srchcol_lb1"] = "Модел"
  tSet["tool."..sTool..".pn_srchcol_lb2"] = "Тип"
  tSet["tool."..sTool..".pn_srchcol_lb3"] = "Име"
  tSet["tool."..sTool..".pn_srchcol_lb4"] = "Ръб"
  tSet["tool."..sTool..".pn_routine_lb" ] = "Рутинни обекти"
  tSet["tool."..sTool..".pn_routine_lb1"] = "Срок"
  tSet["tool."..sTool..".pn_routine_lb2"] = "Ръб"
  tSet["tool."..sTool..".pn_routine_lb3"] = "Тип"
  tSet["tool."..sTool..".pn_routine_lb4"] = "Име"
  tSet["tool."..sTool..".pn_display_lb" ] = "Дисплей за парчето"
  tSet["tool."..sTool..".pn_pattern_lb" ] = "Напишете шаблон"
  tSet["Cleanup_"..sLimit               ] = "Сглобени парчета трасе"
  tSet["Cleaned_"..sLimit               ] = "Всички парчета трасе са почистени"
  tSet["SBoxLimit_"..sLimit             ] = "Достигнахте границата на създадените парчета трасе!"
return tSet end
