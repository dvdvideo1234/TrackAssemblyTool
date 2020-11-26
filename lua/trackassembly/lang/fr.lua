return function(sTool, sLimit) local tSet = {} -- French
  tSet["tool."..sTool..".1"             ] = "Assemble une piste segmenté"
  tSet["tool."..sTool..".left"          ] = "Créer/aligner une pièce. Maintenez SHIFT pour empiler"
  tSet["tool."..sTool..".right"         ] = "Changer de point de rassemblement. Maintenez SHIFT pour le verso (Rapide: ALT + MOLETTE)"
  tSet["tool."..sTool..".right_use"     ] = "Ouvrir le menu des pièces utilisés fréquemment"
  tSet["tool."..sTool..".reload"        ] = "Retirer une pièce. Maintenez SHIFT pour sélectionner une ancre"
  tSet["tool."..sTool..".desc"          ] = "Assemble une piste auquel les véhicules peuvent rouler dessus"
  tSet["tool."..sTool..".name"          ] = "Assembleur à piste"
  tSet["tool."..sTool..".phytype"       ] = "Sélectionnez une des propriétés physiques dans la liste"
  tSet["tool."..sTool..".phytype_def"   ] = "<Sélectionner un TYPE de matériau de surface>"
  tSet["tool."..sTool..".phyname"       ] = "Sélectionnez une des noms de propriétés physiques à utiliser lorsque qu'une piste sera créée. Ceci va affecter la friction de la surface"
  tSet["tool."..sTool..".phyname_con"   ] = "Nom de matériau de surface:"
  tSet["tool."..sTool..".phyname_def"   ] = "<Sélectionner un NOM de matériau de surface>"
  tSet["tool."..sTool..".bgskids"       ] = "Cette ensemble de code est delimité par une virgule pour chaque Bodygroup/Skin ID"
  tSet["tool."..sTool..".bgskids_con"   ] = "Bodygroup/Skin:"
  tSet["tool."..sTool..".bgskids_def"   ] = "Écrivez le code de sélection ici. Par exemple 1,0,0,2,1/3"
  tSet["tool."..sTool..".mass"          ] = "À quel point la pièce créée sera lourd"
  tSet["tool."..sTool..".mass_con"      ] = "Masse de la pièce:"
  tSet["tool."..sTool..".model"         ] = "Sélectionnez une pièce pour commencer/continuer votre piste avec en étendant un type et en cliquant sur un nœud"
  tSet["tool."..sTool..".model_con"     ] = "Modèle de la pièce:"
  tSet["tool."..sTool..".activrad"      ] = "Distance minimum nécessaire pour sélectionner un point actif"
  tSet["tool."..sTool..".activrad_con"  ] = "Rayon actif:"
  tSet["tool."..sTool..".stackcnt"      ] = "Nombre maximum de pièces à créer pendant l'empilement"
  tSet["tool."..sTool..".stackcnt_con"  ] = "Nombre de pièces:"
  tSet["tool."..sTool..".angsnap"       ] = "Aligner la première pièce créée sur ce degré"
  tSet["tool."..sTool..".angsnap_con"   ] = "Alignement angulaire:"
  tSet["tool."..sTool..".resetvars"     ] = "Cliquez pour réinitialiser les valeurs supplémentaires"
  tSet["tool."..sTool..".resetvars_con" ] = "V Réinitialiser les variables V"
  tSet["tool."..sTool..".nextpic"       ] = "Décalage angulaire supplémentaire sur la position initial du tangage"
  tSet["tool."..sTool..".nextpic_con"   ] = "Angle du tangage:"
  tSet["tool."..sTool..".nextyaw"       ] = "Décalage angulaire supplémentaire sur la position initial du lacet"
  tSet["tool."..sTool..".nextyaw_con"   ] = "Angle du lacet:"
  tSet["tool."..sTool..".nextrol"       ] = "Décalage angulaire supplementaire sur la position initial du roulis"
  tSet["tool."..sTool..".nextrol_con"   ] = "Angle du roulis:"
  tSet["tool."..sTool..".nextx"         ] = "Décalage linéaire supplémentaire sur la position initial de X"
  tSet["tool."..sTool..".nextx_con"     ] = "Décalage en X:"
  tSet["tool."..sTool..".nexty"         ] = "Décalage linéaire supplémentaire sur la position initial de Y"
  tSet["tool."..sTool..".nexty_con"     ] = "Décalage en Y:"
  tSet["tool."..sTool..".nextz"         ] = "Décalage linéaire supplémentaire sur la position initial de Z"
  tSet["tool."..sTool..".nextz_con"     ] = "Décalage en Z:"
  tSet["tool."..sTool..".gravity"       ] = "Contrôle la gravité sur la pièce créée"
  tSet["tool."..sTool..".gravity_con"   ] = "Appliquer la gravité sur la pièce"
  tSet["tool."..sTool..".weld"          ] = "Créer une soudure entre les pièces/ancres"
  tSet["tool."..sTool..".weld_con"      ] = "Souder"
  tSet["tool."..sTool..".forcelim"      ] = "Force nécessaire pour casser la soudure"
  tSet["tool."..sTool..".forcelim_con"  ] = "Limite de force:"
  tSet["tool."..sTool..".ignphysgn"     ] = "Ignore la saisie du pistolet physiques sur la pièce créée/alignée/empilé"
  tSet["tool."..sTool..".ignphysgn_con" ] = "Ignorer le pistolet physiques"
  tSet["tool."..sTool..".nocollide"     ] = "Faire en sorte que les pièces/ancres ne puissent jamais entrer en collision"
  tSet["tool."..sTool..".nocollide_con" ] = "Pas de collisions"
  tSet["tool."..sTool..".nocollidew"    ] = "Faire en sorte que les pièces/monde ne puisse jamais entrer en collision"
  tSet["tool."..sTool..".nocollidew_con"] = "Pas de collisions monde"
  tSet["tool."..sTool..".freeze"        ] = "La pièce qui sera créée sera dans un état gelé"
  tSet["tool."..sTool..".freeze_con"    ] = "Geler la pièce"
  tSet["tool."..sTool..".igntype"       ] = "Faire ignorer à l'outil les différents types de pièce dès l'alignement/empilement"
  tSet["tool."..sTool..".igntype_con"   ] = "Ignorer le type de piste"
  tSet["tool."..sTool..".spnflat"       ] = "La prochaine pièce sera créée/alignée/empilé horizontalement"
  tSet["tool."..sTool..".spnflat_con"   ] = "Créer horizontalement"
  tSet["tool."..sTool..".spawncn"       ] = "Créer la pièce vers le centre, sinon, la créer relativement vers le point active choisi"
  tSet["tool."..sTool..".spawncn_con"   ] = "Partir du centre"
  tSet["tool."..sTool..".surfsnap"      ] = "Aligne la pièce vers la surface auquel le joueur vise actuellement"
  tSet["tool."..sTool..".surfsnap_con"  ] = "Aligner vers la surface tracé"
  tSet["tool."..sTool..".appangfst"     ] = "Appliquer les décalages angulaires seulement sur la première pièce"
  tSet["tool."..sTool..".appangfst_con" ] = "Appliquer angulaire en premier"
  tSet["tool."..sTool..".applinfst"     ] = "Appliquer les décalages linéaires seulement sur la première pièce"
  tSet["tool."..sTool..".applinfst_con" ] = "Appliquer linéaire en premier"
  tSet["tool."..sTool..".adviser"       ] = "Montrer le conseiller de position/angle de l'outil"
  tSet["tool."..sTool..".adviser_con"   ] = "Montrer le conseiller"
  tSet["tool."..sTool..".pntasist"      ] = "Montrer l'assistant d'alignement de l'outil"
  tSet["tool."..sTool..".pntasist_con"  ] = "Montrer l'assistant"
  tSet["tool."..sTool..".ghostcnt"      ] = "Montrer un aperçu de la pièces compter active"
  tSet["tool."..sTool..".ghostcnt_con"  ] = "Activer compter l'aperçu de l'outil"
  tSet["tool."..sTool..".engunsnap"     ] = "Contrôle l'alignement quand la pièce est tombée par le pistolet physique d'un joueur"
  tSet["tool."..sTool..".engunsnap_con" ] = "Activer l'alignement par pistolet physique"
  tSet["tool."..sTool..".type"          ] = "Sélectionnez le type de piste à utiliser en développant le dossier"
  tSet["tool."..sTool..".type_con"      ] = "Type de piste:"
  tSet["tool."..sTool..".category"      ] = "Sélectionnez la catégorie de piste à utiliser en développant le dossier"
  tSet["tool."..sTool..".category_con"  ] = "Catégorie de piste:"
  tSet["tool."..sTool..".workmode"      ] = "Modifiez cette option pour utiliser différents modes de travail"
  tSet["tool."..sTool..".workmode_1"    ] = "Général créer/aligner pieces"
  tSet["tool."..sTool..".workmode_2"    ] = "Intersection de point actif"
  tSet["tool."..sTool..".workmode_3"    ] = "Ajustement de segment de ligne"
  tSet["tool."..sTool..".pn_export"     ] = "Cliquer pour exporter la base de données client dans un fichier"
  tSet["tool."..sTool..".pn_export_lb"  ] = "Exporter BD"
  tSet["tool."..sTool..".pn_routine"    ] = "La liste de vos pièces de pistes utilisés fréquemment"
  tSet["tool."..sTool..".pn_routine_hd" ] = "Pièces fréquents par:"
  tSet["tool."..sTool..".pn_externdb"   ] = "Les base de données disponibles pour:"
  tSet["tool."..sTool..".pn_externdb_hd"] = "Base de données de:"
  tSet["tool."..sTool..".pn_externdb_lb"] = "Clic droit pour les options:"
  tSet["tool."..sTool..".pn_externdb_1" ] = "Copier préfixe unique"
  tSet["tool."..sTool..".pn_externdb_2" ] = "Copier chemin dossier DSV"
  tSet["tool."..sTool..".pn_externdb_3" ] = "Copier le nom de la table"
  tSet["tool."..sTool..".pn_externdb_4" ] = "Copier le chemin de la table"
  tSet["tool."..sTool..".pn_externdb_5" ] = "Copier l'heure de la table"
  tSet["tool."..sTool..".pn_externdb_6" ] = "Copier la taille de la table"
  tSet["tool."..sTool..".pn_externdb_7" ] = "Modifier le contenu de la table (Luapad)"
  tSet["tool."..sTool..".pn_externdb_8" ] = "Supprimer l'entrée de la base de donnée"
  tSet["tool."..sTool..".pn_ext_dsv_lb" ] = "Liste DSV externe"
  tSet["tool."..sTool..".pn_ext_dsv_hd" ] = "La liste des base de données DSV sont affichées ici"
  tSet["tool."..sTool..".pn_ext_dsv_1"  ] = "Préfixe unique de la base de donnée"
  tSet["tool."..sTool..".pn_ext_dsv_2"  ] = "Active"
  tSet["tool."..sTool..".pn_display"    ] = "Le modèle de votre pièce de piste est affiché ici"
  tSet["tool."..sTool..".pn_pattern"    ] = "Écrire un modèle ici et appuyer sur ENTRÉE pour effectuer une recherche"
  tSet["tool."..sTool..".pn_srchcol"    ] = "Choisir la liste de colonne auquel vous voulez effectuer une recherche sur"
  tSet["tool."..sTool..".pn_srchcol_lb" ] = "<Recherche>"
  tSet["tool."..sTool..".pn_srchcol_lb1"] = "Modèle"
  tSet["tool."..sTool..".pn_srchcol_lb2"] = "Type"
  tSet["tool."..sTool..".pn_srchcol_lb3"] = "Nom"
  tSet["tool."..sTool..".pn_srchcol_lb4"] = "Fin"
  tSet["tool."..sTool..".pn_routine_lb" ] = "Articles de routine"
  tSet["tool."..sTool..".pn_routine_lb1"] = "Utilisé"
  tSet["tool."..sTool..".pn_routine_lb2"] = "Fin"
  tSet["tool."..sTool..".pn_routine_lb3"] = "Type"
  tSet["tool."..sTool..".pn_routine_lb4"] = "Nom"
  tSet["tool."..sTool..".pn_display_lb" ] = "Affichage pièce"
  tSet["tool."..sTool..".pn_pattern_lb" ] = "Écrire modèle"
  tSet["Cleanup_"..sLimit               ] = "Pièces de piste assemblées"
  tSet["Cleaned_"..sLimit               ] = "Pistes nettoyées"
  tSet["SBoxLimit_"..sLimit             ] = "Vous avez atteint la limite des pistes créées!"
return tSet end
