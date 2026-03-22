# Reusable consumables with per-item cooldown in import table
# Requested behavior:
# - 1 second cooldown
# - item is never consumed on use
# - SQL runtime uses item_db2 overlay

DELETE FROM `item_db2`
WHERE `id` IN (40001,40002,40003,41000,41001,41002,41003,41004,41005,41006,41010);

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`,`weight`,`flag_noconsume`,`delay_duration`,`script`)
VALUES
(40001,'Infinite_Red_Potion','Infinite Red Potion','Healing',10,true,3000,'specialeffect2 EF_HEAL;\nitemheal rand(45,65),0;');

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`,`weight`,`flag_noconsume`,`delay_duration`,`script`)
VALUES
(40002,'Infinite_Blue_Potion','Infinite Blue Potion','Healing',15,true,3000,'specialeffect2 EF_HEALSP;\nitemheal 0,rand(40,60);');

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`,`weight`,`flag_noconsume`,`delay_duration`,`script`)
VALUES
(40003,'Infinite_Fly_Wing','Infinite Fly Wing','Delayconsume',50,true,1000,'specialeffect2 EF_TELEPORTATION;\nitemskill "AL_TELEPORT",1;');

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`)
VALUES
(41000,'Death_Essence','Death Essence','Etc');

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`)
VALUES
(41001,'Flame_Essence','Flame Essence','Etc');

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`)
VALUES
(41002,'Water_Essence','Water Essence','Etc');

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`)
VALUES
(41003,'Earth_Essence','Earth Essence','Etc');

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`)
VALUES
(41004,'Soul_Essence','Soul Essence','Etc');

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`)
VALUES
(41005,'Holy_Essence','Holy Essence','Etc');

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`)
VALUES
(41006,'Venom_Essence','Venom Essence','Etc');

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`)
VALUES
(41010,'Magic_Bottle','Magic Bottle','Etc');
