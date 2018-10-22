﻿return {  -- French
  ["tool."..gsToolNameL..".1"             ] = "Assemble une piste segmente",
  ["tool."..gsToolNameL..".left"          ] = "Creer/aligner une piece. Maintenez SHIFT pour empiler",
  ["tool."..gsToolNameL..".right"         ] = "Changer de point de rassemblement. Maintenez SHIFT pour le verso (Rapide: ALT + MOLETTE",)
  ["tool."..gsToolNameL..".right_use"     ] = "Ouvrir le menu des pieces utilises frequemment",
  ["tool."..gsToolNameL..".reload"        ] = "Retirer une piece. Maintenez SHIFT pour selectionner une ancre",
  ["tool."..gsToolNameL..".desc"          ] = "Assemble une piste auquel les vehicules peuvent rouler dessus",
  ["tool."..gsToolNameL..".name"          ] = "Assembleur a piste",
  ["tool."..gsToolNameL..".phytype"       ] = "Selectionnez une des proprietes physiques dans la liste",
  ["tool."..gsToolNameL..".phytype_def"   ] = "<Selectionner un TYPE de materiau de surface>",
  ["tool."..gsToolNameL..".phyname"       ] = "Selectionnez une des noms de proprietes physiques a utiliser lorsque qu'une piste sera creee. Ceci va affecter la friction de la surface",
  ["tool."..gsToolNameL..".phyname_def"   ] = "<Selectionner un NOM de materiau de surface>",
  ["tool."..gsToolNameL..".bgskids"       ] = "Cette ensemble de code est delimite par une virgule pour chaque Bodygroup/Skin IDs > ENTREE pour accepter, TAB pour copier depuis la trace",
  ["tool."..gsToolNameL..".bgskids_def"   ] = "Ecrivez le code de selection ici. Par exemple 1,0,0,2,1/3",
  ["tool."..gsToolNameL..".mass"          ] = "A quel point la piece creee sera lourd",
  ["tool."..gsToolNameL..".mass_con"      ] = "Masse de la piece:",
  ["tool."..gsToolNameL..".model"         ] = "Selectionner le modele de la piece a utiliser",
  ["tool."..gsToolNameL..".model_con"     ] = "Selectionnez une piece pour commencer/continuer votre piste avec, en etendant un type et en cliquant sur un n?ud",
  ["tool."..gsToolNameL..".activrad"      ] = "Distance minimum necessaire pour selectionner un point actif",
  ["tool."..gsToolNameL..".activrad_con"  ] = "Rayon actif:",
  ["tool."..gsToolNameL..".count"         ] = "Nombre maximum de pieces a creer pendant l'empilement",
  ["tool."..gsToolNameL..".count_con"     ] = "Nombre de pieces:",
  ["tool."..gsToolNameL..".angsnap"       ] = "Aligner la premiere piece creee sur ce degre",
  ["tool."..gsToolNameL..".angsnap_con"   ] = "Alignement angulaire:",
  ["tool."..gsToolNameL..".resetvars"     ] = "Cliquez pour reinitialiser les valeurs supplementaires",
  ["tool."..gsToolNameL..".resetvars_con" ] = "V Reinitialiser les variables V",
  ["tool."..gsToolNameL..".nextpic"       ] = "Decalage angulaire supplementaire sur la position initial du tangage",
  ["tool."..gsToolNameL..".nextpic_con"   ] = "Angle du tangage:",
  ["tool."..gsToolNameL..".nextyaw"       ] = "Decalage angulaire supplementaire sur la position initial du lacet",
  ["tool."..gsToolNameL..".nextyaw_con"   ] = "Angle du lacet:",
  ["tool."..gsToolNameL..".nextrol"       ] = "Decalage angulaire supplementaire sur la position initial du roulis",
  ["tool."..gsToolNameL..".nextrol_con"   ] = "Angle du roulis:",
  ["tool."..gsToolNameL..".nextx"         ] = "Decalage lineaire supplementaire sur la position initial de X",
  ["tool."..gsToolNameL..".nextx_con"     ] = "Decalage en X:",
  ["tool."..gsToolNameL..".nexty"         ] = "Decalage lineaire supplementaire sur la position initial de Y",
  ["tool."..gsToolNameL..".nexty_con"     ] = "Decalage en Y:",
  ["tool."..gsToolNameL..".nextz"         ] = "Decalage lineaire supplementaire sur la position initial de Z",
  ["tool."..gsToolNameL..".nextz_con"     ] = "Decalage en Z:",
  ["tool."..gsToolNameL..".gravity"       ] = "Controle la gravite sur la piece creee",
  ["tool."..gsToolNameL..".gravity_con"   ] = "Appliquer la gravite sur la piece",
  ["tool."..gsToolNameL..".weld"          ] = "Creer une soudure entre les pieces/ancres",
  ["tool."..gsToolNameL..".weld_con"      ] = "Souder",
  ["tool."..gsToolNameL..".forcelim"      ] = "Force necessaire pour casser la soudure",
  ["tool."..gsToolNameL..".forcelim_con"  ] = "Limite de force:",
  ["tool."..gsToolNameL..".ignphysgn"     ] = "Ignore la saisie du pistolet physiques sur la piece creee/alignee/empile",
  ["tool."..gsToolNameL..".ignphysgn_con" ] = "Ignorer le pistolet physiques",
  ["tool."..gsToolNameL..".nocollide"     ] = "Faire en sorte, que les pieces/ancres, ne puissent jamais entrer en collision",
  ["tool."..gsToolNameL..".nocollide_con" ] = "Pas de collisions",
  ["tool."..gsToolNameL..".freeze"        ] = "La piece qui sera creee, sera dans un etat gele",
  ["tool."..gsToolNameL..".freeze_con"    ] = "Geler des la creation",
  ["tool."..gsToolNameL..".igntype"       ] = "Faire ignorer a l'outil, les differents types de piece des l'alignement/empilement",
  ["tool."..gsToolNameL..".igntype_con"   ] = "Ignorer le type de piste",
  ["tool."..gsToolNameL..".spnflat"       ] = "La prochaine piece sera creee/alignee/empile horizontalement",
  ["tool."..gsToolNameL..".spnflat_con"   ] = "Creer horizontalement",
  ["tool."..gsToolNameL..".spawncn"       ] = "Creer la piece vers le centre, sinon, la creer relativement vers le point active choisi",
  ["tool."..gsToolNameL..".spawncn_con"   ] = "Partir du centre",
  ["tool."..gsToolNameL..".surfsnap"      ] = "Aligne la piece vers la surface auquel le joueur vise actuellement",
  ["tool."..gsToolNameL..".surfsnap_con"  ] = "Aligner vers la surface trace",
  ["tool."..gsToolNameL..".appangfst"     ] = "Appliquer les decalages angulaires seulement sur la premiere piece",
  ["tool."..gsToolNameL..".appangfst_con" ] = "Appliquer angulaire en premier",
  ["tool."..gsToolNameL..".applinfst"     ] = "Appliquer les decalages lineaires seulement sur la premiere piece",
  ["tool."..gsToolNameL..".applinfst_con" ] = "Appliquer lineaire en premier",
  ["tool."..gsToolNameL..".adviser"       ] = "Montrer le conseiller de position/angle de l'outil",
  ["tool."..gsToolNameL..".adviser_con"   ] = "Montrer le conseiller",
  ["tool."..gsToolNameL..".pntasist"      ] = "Montrer l'assistant d'alignement de l'outil",
  ["tool."..gsToolNameL..".pntasist_con"  ] = "Montrer l'assistant",
  ["tool."..gsToolNameL..".ghosthold"     ] = "Montrer un apercu de la piece active",
  ["tool."..gsToolNameL..".ghosthold_con" ] = "Activer l'apercu de l'outil",
  ["tool."..gsToolNameL..".engunsnap"     ] = "Controle l'alignement quand la piece est tombee par le pistolet physique d'un joueur",
  ["tool."..gsToolNameL..".engunsnap_con" ] = "Activer l'alignement par pistolet physique",
  ["tool."..gsToolNameL..".workmode"      ] = "Modifiez cette option pour utiliser differents modes de travail",
  ["tool."..gsToolNameL..".workmode_1"    ] = "General creer/aligner pieces",
  ["tool."..gsToolNameL..".workmode_2"    ] = "Intersection de point actif",
  ["tool."..gsToolNameL..".pn_export"     ] = "Cliquer pour exporter la base de donnees client dans un fichier",
  ["tool."..gsToolNameL..".pn_export_lb"  ] = "Exporter",
  ["tool."..gsToolNameL..".pn_routine"    ] = "La liste de vos pieces de pistes utilises frequemment",
  ["tool."..gsToolNameL..".pn_routine_hd" ] = "Pieces frequents par: ",
  ["tool."..gsToolNameL..".pn_display"    ] = "Le modele de votre piece de piste est affiche ici",
  ["tool."..gsToolNameL..".pn_pattern"    ] = "Ecrire un modele ici et appuyer sur ENTREE pour effectuer une recherche",
  ["tool."..gsToolNameL..".pn_srchcol"    ] = "Choisir la liste de colonne auquel vous voulez effectuer une recherche sur",
  ["tool."..gsToolNameL..".pn_srchcol_lb" ] = "<Recherche>",
  ["tool."..gsToolNameL..".pn_srchcol_lb1"] = "Modele",
  ["tool."..gsToolNameL..".pn_srchcol_lb2"] = "Type",
  ["tool."..gsToolNameL..".pn_srchcol_lb3"] = "Nom",
  ["tool."..gsToolNameL..".pn_srchcol_lb4"] = "Fin",
  ["tool."..gsToolNameL..".pn_routine_lb" ] = "Articles de routine",
  ["tool."..gsToolNameL..".pn_routine_lb1"] = "Utilise",
  ["tool."..gsToolNameL..".pn_routine_lb2"] = "Fin",
  ["tool."..gsToolNameL..".pn_routine_lb3"] = "Type",
  ["tool."..gsToolNameL..".pn_routine_lb4"] = "Nom",
  ["tool."..gsToolNameL..".pn_display_lb" ] = "Affichage piece",
  ["tool."..gsToolNameL..".pn_pattern_lb" ] = "Ecrire modele",
  ["Cleanup_"..gsLimitName                ] = "Pieces de piste assemblees",
  ["Cleaned_"..gsLimitName                ] = "Pistes nettoyees",
  ["SBoxLimit_"..gsLimitName              ] = "Vous avez atteint la limite des pistes creees!"
}
