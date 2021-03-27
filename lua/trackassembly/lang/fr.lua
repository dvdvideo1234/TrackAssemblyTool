return function(sTool, sLimit) local tSet = {} -- French
  tSet["tool."..sTool..".workmode.1"       ] = "Général créer/aligner des pièces"
  tSet["tool."..sTool..".workmode.2"       ] = "Point d'intersection actif"
  tSet["tool."..sTool..".workmode.3"       ] = "Ajuster des segments de ligne courbés"
  tSet["tool."..sTool..".workmode.4"       ] = "Retourner la normale d'une surface"
  tSet["tool."..sTool..".info.1"           ] = "Créer des pièces sur la carte ou les aligner relativement entre elles"
  tSet["tool."..sTool..".info.2"           ] = "Connecte les sections de piste avec un segment spécialement dédié pour cela"
  tSet["tool."..sTool..".info.3"           ] = "Forme une piste continue passant par les points de passage définis"
  tSet["tool."..sTool..".info.4"           ] = "Retourne les entités sélectionnées de la liste à travers les origines et normales définis"
  tSet["tool."..sTool..".left.1"           ] = "Créer/Aligner une pièce de piste. Maintenir MAJUSCULE pour empiler"
  tSet["tool."..sTool..".left.2"           ] = "Créer une pièce de piste au point d'intersection"
  tSet["tool."..sTool..".left.3"           ] = "Créer la piste segmentée par interpolation de courbe"
  tSet["tool."..sTool..".left.4"           ] = "Créer les pistes retournées de la liste sélectionnée"
  tSet["tool."..sTool..".right.1"          ] = "Copier le modèle de la pièce de piste ou ouvrir la fenêtre des pièces fréquentes"
  tSet["tool."..sTool..".right.2"          ] = tSet["tool."..sTool..".right.1"]
  tSet["tool."..sTool..".right.3"          ] = "Créer un nœud pour la courbe segmentée. Maintenir MAJUSCULE pour réactualiser"
  tSet["tool."..sTool..".right.4"          ] = "Enregistrer l'entité dans la liste à retourner. Maintenir MAJUSCULE pour changer le modèle"
  tSet["tool."..sTool..".right_use.1"      ] = "MOLETTE désactivée. "..tSet["tool."..sTool..".right.1"]
  tSet["tool."..sTool..".right_use.2"      ] = tSet["tool."..sTool..".right_use.1"]
  tSet["tool."..sTool..".right_use.3"      ] = "Générer un nœud depuis le point actif de la pièce de piste la plus proche"
  tSet["tool."..sTool..".right_use.4"      ] = tSet["tool."..sTool..".right_use.1"]
  tSet["tool."..sTool..".reload.1"         ] = "Retirer une pièce de piste. Maintenir MAJUSCULE pour sélectionner une ancre"
  tSet["tool."..sTool..".reload.2"         ] = "Retirer une pièce de piste. Maintenir MAJUSCULE pour sélectionner le rayon de sélection"
  tSet["tool."..sTool..".reload.3"         ] = "Retire un nœud de l'interpolation de courbe. Maintenir MAJUSCULE pour vider le tas"
  tSet["tool."..sTool..".reload.4"         ] = "Vider la liste des entités à retourner. Retire une pièce si la liste est vide"
  tSet["tool."..sTool..".reload_use.1"     ] = "Activer l'exportation de la base de données pour ouvrir le gestionnaire DSV"
  tSet["tool."..sTool..".reload_use.2"     ] = tSet["tool."..sTool..".reload_use.1"]
  tSet["tool."..sTool..".reload_use.3"     ] = tSet["tool."..sTool..".reload_use.1"]
  tSet["tool."..sTool..".reload_use.4"     ] = tSet["tool."..sTool..".reload_use.1"]
  tSet["tool."..sTool..".desc"             ] = "Assemble une piste auquel les véhicules peuvent rouler dessus"
  tSet["tool."..sTool..".name"             ] = "Assembleur à piste"
  tSet["tool."..sTool..".phytype"          ] = "Sélectionnez une des propriétés physiques dans la liste"
  tSet["tool."..sTool..".phytype_con"      ] = "Type de matériau:"
  tSet["tool."..sTool..".phytype_def"      ] = "<Sélectionner un TYPE de matériau de surface>"
  tSet["tool."..sTool..".phyname"          ] = "Sélectionnez une des noms de propriétés physiques à utiliser lorsque qu'une piste sera créée. Ceci va affecter la friction de la surface"
  tSet["tool."..sTool..".phyname_con"      ] = "Nom de matériau de surface:"
  tSet["tool."..sTool..".phyname_def"      ] = "<Sélectionner un NOM de matériau de surface>"
  tSet["tool."..sTool..".bgskids"          ] = "Cette ensemble de code est delimité par une virgule pour chaque Groupes de corps/ID Apparence"
  tSet["tool."..sTool..".bgskids_con"      ] = "Groupes de corps/Apparence:"
  tSet["tool."..sTool..".bgskids_def"      ] = "Écrivez le code de sélection ici. Par exemple 1,0,0,2,1/3"
  tSet["tool."..sTool..".mass"             ] = "À quel point la pièce créée sera lourd"
  tSet["tool."..sTool..".mass_con"         ] = "Masse de la pièce:"
  tSet["tool."..sTool..".model"            ] = "Sélectionnez une pièce pour commencer/continuer votre piste avec en étendant un type et en cliquant sur un nœud"
  tSet["tool."..sTool..".model_con"        ] = "Modèle de la pièce:"
  tSet["tool."..sTool..".activrad"         ] = "Distance minimum nécessaire pour sélectionner un point actif"
  tSet["tool."..sTool..".activrad_con"     ] = "Rayon actif:"
  tSet["tool."..sTool..".stackcnt"         ] = "Nombre maximum de pièces à créer pendant l'empilement"
  tSet["tool."..sTool..".stackcnt_con"     ] = "Nombre de pièces:"
  tSet["tool."..sTool..".angsnap"          ] = "Aligner la première pièce créée sur ce degré"
  tSet["tool."..sTool..".angsnap_con"      ] = "Alignement angulaire:"
  tSet["tool."..sTool..".resetvars"        ] = "Cliquez pour réinitialiser les valeurs supplémentaires"
  tSet["tool."..sTool..".resetvars_con"    ] = "V Réinitialiser les variables V"
  tSet["tool."..sTool..".nextpic"          ] = "Décalage angulaire supplémentaire sur la position initial du tangage"
  tSet["tool."..sTool..".nextpic_con"      ] = "Angle du tangage:"
  tSet["tool."..sTool..".nextyaw"          ] = "Décalage angulaire supplémentaire sur la position initial du lacet"
  tSet["tool."..sTool..".nextyaw_con"      ] = "Angle du lacet:"
  tSet["tool."..sTool..".nextrol"          ] = "Décalage angulaire supplementaire sur la position initial du roulis"
  tSet["tool."..sTool..".nextrol_con"      ] = "Angle du roulis:"
  tSet["tool."..sTool..".nextx"            ] = "Décalage linéaire supplémentaire sur la position initial de X"
  tSet["tool."..sTool..".nextx_con"        ] = "Décalage en X:"
  tSet["tool."..sTool..".nexty"            ] = "Décalage linéaire supplémentaire sur la position initial de Y"
  tSet["tool."..sTool..".nexty_con"        ] = "Décalage en Y:"
  tSet["tool."..sTool..".nextz"            ] = "Décalage linéaire supplémentaire sur la position initial de Z"
  tSet["tool."..sTool..".nextz_con"        ] = "Décalage en Z:"
  tSet["tool."..sTool..".gravity"          ] = "Contrôle la gravité sur la pièce créée"
  tSet["tool."..sTool..".gravity_con"      ] = "Appliquer la gravité sur la pièce"
  tSet["tool."..sTool..".weld"             ] = "Créer une soudure entre les pièces/ancres"
  tSet["tool."..sTool..".weld_con"         ] = "Souder"
  tSet["tool."..sTool..".forcelim"         ] = "Force nécessaire pour casser la soudure"
  tSet["tool."..sTool..".forcelim_con"     ] = "Limite de force:"
  tSet["tool."..sTool..".ignphysgn"        ] = "Ignore la saisie du pistolet physiques sur la pièce créée/alignée/empilé"
  tSet["tool."..sTool..".ignphysgn_con"    ] = "Ignorer le pistolet physiques"
  tSet["tool."..sTool..".nocollide"        ] = "Faire en sorte que les pièces/ancres ne puissent jamais entrer en collision"
  tSet["tool."..sTool..".nocollide_con"    ] = "Pas de collisions"
  tSet["tool."..sTool..".nocollidew"       ] = "Faire en sorte que les pièces/monde ne puisse jamais entrer en collision"
  tSet["tool."..sTool..".nocollidew_con"   ] = "Pas de collisions avec le monde"
  tSet["tool."..sTool..".freeze"           ] = "La pièce qui sera créée sera dans un état gelé"
  tSet["tool."..sTool..".freeze_con"       ] = "Geler la pièce"
  tSet["tool."..sTool..".igntype"          ] = "Faire ignorer à l'outil les différents types de pièce dès l'alignement/empilement"
  tSet["tool."..sTool..".igntype_con"      ] = "Ignorer le type de piste"
  tSet["tool."..sTool..".spnflat"          ] = "La prochaine pièce sera créée/alignée/empilé horizontalement"
  tSet["tool."..sTool..".spnflat_con"      ] = "Créer horizontalement"
  tSet["tool."..sTool..".spawncn"          ] = "Créer la pièce vers le centre, sinon, la créer relativement vers le point active choisi"
  tSet["tool."..sTool..".spawncn_con"      ] = "Partir du centre"
  tSet["tool."..sTool..".surfsnap"         ] = "Aligne la pièce vers la surface auquel le joueur vise actuellement"
  tSet["tool."..sTool..".surfsnap_con"     ] = "Aligner vers la surface tracé"
  tSet["tool."..sTool..".appangfst"        ] = "Appliquer les décalages angulaires seulement sur la première pièce"
  tSet["tool."..sTool..".appangfst_con"    ] = "Appliquer angulaire en premier"
  tSet["tool."..sTool..".applinfst"        ] = "Appliquer les décalages linéaires seulement sur la première pièce"
  tSet["tool."..sTool..".applinfst_con"    ] = "Appliquer linéaire en premier"
  tSet["tool."..sTool..".adviser"          ] = "Montrer le conseiller de position/angle de l'outil"
  tSet["tool."..sTool..".adviser_con"      ] = "Montrer le conseiller"
  tSet["tool."..sTool..".pntasist"         ] = "Montrer l'assistant d'alignement de l'outil"
  tSet["tool."..sTool..".pntasist_con"     ] = "Montrer l'assistant"
  tSet["tool."..sTool..".ghostcnt"         ] = "Montrer un aperçu de la pièces compter active"
  tSet["tool."..sTool..".ghostcnt_con"     ] = "Activer compter l'aperçu de l'outil"
  tSet["tool."..sTool..".engunsnap"        ] = "Contrôle l'alignement quand la pièce est tombée par le pistolet physique d'un joueur"
  tSet["tool."..sTool..".engunsnap_con"    ] = "Activer l'alignement par pistolet physique"
  tSet["tool."..sTool..".type"             ] = "Sélectionnez le type de piste à utiliser en développant le dossier"
  tSet["tool."..sTool..".type_con"         ] = "Type de piste:"
  tSet["tool."..sTool..".subfolder"        ] = "Sélectionnez la catégorie de piste à utiliser en développant le dossier"
  tSet["tool."..sTool..".subfolder_con"    ] = "Catégorie de piste:"
  tSet["tool."..sTool..".workmode"         ] = "Modifiez cette option pour utiliser différents modes de travail"
  tSet["tool."..sTool..".workmode_con"     ] = "Mode de travail:"
  tSet["tool."..sTool..".pn_export"        ] = "Cliquer pour exporter la base de données client dans un fichier"
  tSet["tool."..sTool..".pn_export_lb"     ] = "Exporter BD"
  tSet["tool."..sTool..".pn_routine"       ] = "La liste de vos pièces de pistes utilisées fréquemment"
  tSet["tool."..sTool..".pn_routine_hd"    ] = "Pièces fréquents par:"
  tSet["tool."..sTool..".pn_externdb"      ] = "Les base de données disponibles pour:"
  tSet["tool."..sTool..".pn_externdb_hd"   ] = "Base de données de:"
  tSet["tool."..sTool..".pn_externdb_lb"   ] = "Clic droit pour les options:"
  tSet["tool."..sTool..".pn_externdb_1"    ] = "Copier préfixe unique"
  tSet["tool."..sTool..".pn_externdb_2"    ] = "Copier chemin dossier DSV"
  tSet["tool."..sTool..".pn_externdb_3"    ] = "Copier le nom de la table"
  tSet["tool."..sTool..".pn_externdb_4"    ] = "Copier le chemin de la table"
  tSet["tool."..sTool..".pn_externdb_5"    ] = "Copier l'heure de la table"
  tSet["tool."..sTool..".pn_externdb_6"    ] = "Copier la taille de la table"
  tSet["tool."..sTool..".pn_externdb_7"    ] = "Modifier le contenu de la table (Luapad)"
  tSet["tool."..sTool..".pn_externdb_8"    ] = "Supprimer l'entrée de la base de donnée"
  tSet["tool."..sTool..".pn_ext_dsv_lb"    ] = "Liste DSV externe"
  tSet["tool."..sTool..".pn_ext_dsv_hd"    ] = "La liste des base de données DSV sont affichées ici"
  tSet["tool."..sTool..".pn_ext_dsv_1"     ] = "Préfixe unique de la base de donnée"
  tSet["tool."..sTool..".pn_ext_dsv_2"     ] = "Active"
  tSet["tool."..sTool..".pn_display"       ] = "Le modèle de votre pièce de piste est affiché ici"
  tSet["tool."..sTool..".pn_pattern"       ] = "Écrire un modèle ici et appuyer sur ENTRÉE pour effectuer une recherche"
  tSet["tool."..sTool..".pn_srchcol"       ] = "Choisir la liste de colonne auquel vous voulez effectuer une recherche sur"
  tSet["tool."..sTool..".pn_srchcol_lb"    ] = "<Recherche>"
  tSet["tool."..sTool..".pn_srchcol_lb1"   ] = "Modèle"
  tSet["tool."..sTool..".pn_srchcol_lb2"   ] = "Type"
  tSet["tool."..sTool..".pn_srchcol_lb3"   ] = "Nom"
  tSet["tool."..sTool..".pn_srchcol_lb4"   ] = "Fin"
  tSet["tool."..sTool..".pn_routine_lb"    ] = "Articles de routine"
  tSet["tool."..sTool..".pn_routine_lb1"   ] = "Utilisé"
  tSet["tool."..sTool..".pn_routine_lb2"   ] = "Fin"
  tSet["tool."..sTool..".pn_routine_lb3"   ] = "Type"
  tSet["tool."..sTool..".pn_routine_lb4"   ] = "Nom"
  tSet["tool."..sTool..".pn_display_lb"    ] = "Affichage pièce"
  tSet["tool."..sTool..".pn_pattern_lb"    ] = "Écrire modèle"
  tSet["tool."..sTool..".sizeucs"          ] = "Calibration de l'échelle pour le système de coordonnées affiché"
  tSet["tool."..sTool..".sizeucs_con"      ] = "Échelle UCS:"
  tSet["tool."..sTool..".maxstatts"        ] = "Défini combien de tentatives d'empilement le script va essayer avant d'échouer"
  tSet["tool."..sTool..".maxstatts_con"    ] = "Tentatives d'empilement:"
  tSet["tool."..sTool..".incsnpang"        ] = "Défini le pas d'incrémentation angulaire"
  tSet["tool."..sTool..".incsnpang_con"    ] = "Pas angulaire:"
  tSet["tool."..sTool..".incsnplin"        ] = "Défini le pas d'incrémentation linéaire"
  tSet["tool."..sTool..".incsnplin_con"    ] = "Pas linéaire:"
  tSet["tool."..sTool..".enradmenu"        ] = "Permet l'utilisation du menu radial du mode de travail"
  tSet["tool."..sTool..".enradmenu_con"    ] = "Activer le menu radial"
  tSet["tool."..sTool..".enpntmscr"        ] = "Permet de basculer entre les points actifs par défilement de la molette"
  tSet["tool."..sTool..".enpntmscr_con"    ] = "Activer le défilement de points"
  tSet["tool."..sTool..".exportdb"         ] = "Active l'exportation de la base de données en un grand fichier"
  tSet["tool."..sTool..".exportdb_con"     ] = "Activer l'exportation de la base de données"
  tSet["tool."..sTool..".modedb"           ] = "Changer ceci pour utiliser un mode de stockage différent pour la base de données (BD)"
  tSet["tool."..sTool..".modedb_con"       ] = "Mode de la BD:"
  tSet["tool."..sTool..".devmode"          ] = "Active le traçage et débogage"
  tSet["tool."..sTool..".devmode_con"      ] = "Activer le mode développeur"
  tSet["tool."..sTool..".maxtrmarg"        ] = "Changer ceci pour ajuster le temps entre les tracées de l'outil"
  tSet["tool."..sTool..".maxtrmarg_con"    ] = "Marge de la tracée:"
  tSet["tool."..sTool..".maxmenupr"        ] = "Changer ceci pour ajuster le nombre de chiffres après la virgule dans le menu"
  tSet["tool."..sTool..".maxmenupr_con"    ] = "Séparateur décimal:"
  tSet["tool."..sTool..".maxmass"          ] = "Changer ceci pour ajuster la masse maximale pouvant être appliquée sur une pièce"
  tSet["tool."..sTool..".maxmass_con"      ] = "Limite de la masse:"
  tSet["tool."..sTool..".maxlinear"        ] = "Changer ceci pour ajuster le décalage linéaire maximal sur une pièce"
  tSet["tool."..sTool..".maxlinear_con"    ] = "Limite du décalage:"
  tSet["tool."..sTool..".maxforce"         ] = "Changer ceci pour ajuster la limite maximale de la force lors des soudures"
  tSet["tool."..sTool..".maxforce_con"     ] = "Limite de force:"
  tSet["tool."..sTool..".maxactrad"        ] = "Changer ceci pour ajuster le rayon actif maximal pour obtenir l'ID d'un point"
  tSet["tool."..sTool..".maxactrad_con"    ] = "Limite du rayon:"
  tSet["tool."..sTool..".maxstcnt"         ] = "Changer ceci pour ajuster le maximum de pièces pouvant être créées en mode empilement"
  tSet["tool."..sTool..".maxstcnt_con"     ] = "Limite d'empilement:"
  tSet["tool."..sTool..".enwiremod"        ] = "Active l'extension pour la puce d'expression Wiremod"
  tSet["tool."..sTool..".enwiremod_con"    ] = "Activer wire expression"
  tSet["tool."..sTool..".enctxmenu"        ] = "Active le menu contextuel de l'outil dédiée pour les pièces"
  tSet["tool."..sTool..".enctxmenu_con"    ] = "Activer le menu contextuel"
  tSet["tool."..sTool..".enctxmall"        ] = "Active le menu contextuel de l'outil dédiée pour tous les objets"
  tSet["tool."..sTool..".enctxmall_con"    ] = "Activer le menu contextuel pour tous les objets"
  tSet["tool."..sTool..".endsvlock"        ] = "Active le verrouillage du fichier de la base de données DSV externe"
  tSet["tool."..sTool..".endsvlock_con"    ] = "Activer le verrou de la base de données DSV"
  tSet["tool."..sTool..".curvefact"        ] = "Changer ceci pour ajuster le facteur courbe du coefficient tangent"
  tSet["tool."..sTool..".curvefact_con"    ] = "Facteur courbe:"
  tSet["tool."..sTool..".curvsmple"        ] = "Changer ceci pour ajuster les échantillons pour la courbe d'interpolation"
  tSet["tool."..sTool..".curvsmple_con"    ] = "Échantillons courbe:"
  tSet["tool."..sTool..".crvturnlm"        ] = "Changer ceci pour ajuster la finesse de la courbure en virage pour le segment"
  tSet["tool."..sTool..".crvturnlm_con"    ] = "Courbure en virage:"
  tSet["tool."..sTool..".crvleanlm"        ] = "Changer ceci pour ajuster la finesse de la courbure en inclinaison pour le segment"
  tSet["tool."..sTool..".crvleanlm_con"    ] = "Courbure en inclinaison:"
  tSet["tool."..sTool..".spawnrate"        ] = "Changer ceci pour ajuster la quantité de segments de pistes créés par cycle de serveur"
  tSet["tool."..sTool..".spawnrate_con"    ] = "Quantité création:"
  tSet["tool."..sTool..".bnderrmod"        ] = "Changer ceci pour définir le comportement quand les clients créent des pièces en dehors des limites de la carte"
  -- For the convenience of French people, we'll use cardinal brackets [NUMBER] so they can see clearly which one of the following bounding mode is set from the Spawn Menu.
  tSet["tool."..sTool..".bnderrmod_off"    ] = "[1] Autoriser l'empilement/création sans restriction"
  tSet["tool."..sTool..".bnderrmod_log"    ] = "[2] Refuser l'empilement/création l'erreur est enregistré"
  tSet["tool."..sTool..".bnderrmod_hint"   ] = "[3] Refuser l'empilement/création message d'astuce est affiché"
  tSet["tool."..sTool..".bnderrmod_generic"] = "[4] Refuser l'empilement/création message générique est affiché"
  tSet["tool."..sTool..".bnderrmod_error"  ] = "[5] Refuser l'empilement/création message d'erreur est affiché"
  tSet["tool."..sTool..".bnderrmod_con"    ] = "Sécurité frontière:"
  tSet["tool."..sTool..".maxfruse"         ] = "Changer ceci pour ajuster combien de pièces peuvent apparaître dans la fenêtre des pièces fréquentes"
  tSet["tool."..sTool..".maxfruse_con"     ] = "Pièces fréquentes:"
  tSet["tool."..sTool..".timermode_ap"     ] = "Cliquer ici pour appliquer vos changements au gestionnaire de mémoire SQL"
  tSet["tool."..sTool..".timermode_ap_con" ] = "Appliquer les paramètres de la mémoire"
  tSet["tool."..sTool..".timermode_md"     ] = "Changer ceci pour ajuster l'algorithme de la minuterie du gestionnaire de mémoire SQL"
  tSet["tool."..sTool..".timermode_lf"     ] = "Changer ceci pour ajuster pendant combien de temps une entrée reste dans le cache"
  tSet["tool."..sTool..".timermode_lf_con" ] = "Durée de vie:"
  tSet["tool."..sTool..".timermode_rd"     ] = "Efface les entrées du cache en forçant une valeur nulle"
  tSet["tool."..sTool..".timermode_rd_con" ] = "Activer la suppression des entrées"
  tSet["tool."..sTool..".timermode_ct"     ] = "Force l'exécution du recyclage de la mémoire lorsqu'une entrée est supprimée"
  tSet["tool."..sTool..".timermode_ct_con" ] = "Activer le ramasse-miettes"
  tSet["tool."..sTool..".timermode_mem"    ] = "Gestionnaire de mémoire de la table SQL:"
  tSet["tool."..sTool..".timermode_cqt"    ] = "Mettre en cache la minuterie de la requête via l'enregistrement de la requête"
  tSet["tool."..sTool..".timermode_obj"    ] = "Minuterie objet attachée à l'enregistrement du cache"
  tSet["tool."..sTool..".logfile"          ] = "Commence la diffusion du journal dans un fichier dédié"
  tSet["tool."..sTool..".logfile_con"      ] = "Activer le journal"
  tSet["tool."..sTool..".logsmax"          ] = "Changer ceci pour ajuster le flux maximum des lignes écrites par le journal"
  tSet["tool."..sTool..".logsmax_con"      ] = "Lignes maximum:"
  tSet["sbox_max"..sLimit                  ] = "Changer ceci pour ajuster les choses créées par l'outil assembleur à piste sur le serveur"
  tSet["sbox_max"..sLimit.."_con"          ] = "Quantité de rails:"
  tSet["Cleanup_"..sLimit                  ] = "Pièces de piste assemblées"
  tSet["Cleaned_"..sLimit                  ] = "Pistes nettoyées"
  tSet["SBoxLimit_"..sLimit                ] = "Vous avez atteint la limite des pistes créées!"
return tSet end
