# Custom costume headgears in item_db2 overlay

DELETE FROM `item_db2`
WHERE `id` IN (19543,20088,31062);

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`,`location_costume_head_top`,`armor_level`,`view`)
VALUES
(19543,'Oliver_Wolf_Hood','Oliver Wolf Hood','Armor',true,1,849);

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`,`location_costume_head_top`,`armor_level`,`equip_level_min`,`view`,`trade_nodrop`,`trade_notrade`,`trade_nocart`,`trade_noguildstorage`,`trade_nomail`,`trade_noauction`)
VALUES
(20088,'C_DragonCintamani_Hat3','Costume Dragon Cintamani Hat','Armor',true,1,1,1247,true,true,true,true,true,true);

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`,`location_costume_head_top`,`armor_level`,`equip_level_min`,`view`)
VALUES
(31062,'C_Eleanor_Wig','Costume Eleanor Wig','Armor',true,1,1,1502);
