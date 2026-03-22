# Life Skill v1 custom items in item_db2 overlay

DELETE FROM `item_db2`
WHERE `id` IN (
	50000,50001,50002,50003,50004,50005,50006,50007,50008,50009,50010,
	50011,50012,50013,50014,50015,50016,50017,50018,50019,50020
);

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`,`price_buy`,`weight`,`trade_nodrop`,`trade_notrade`,`trade_nosell`,`trade_nocart`,`trade_nostorage`,`trade_noguildstorage`,`trade_nomail`,`trade_noauction`)
VALUES
(50000,'Forager_Sickle','Forager''s Sickle','Etc',100,50,true,true,true,true,true,true,true,true),
(50001,'Miner_Pickaxe','Miner''s Pickaxe','Etc',100,70,true,true,true,true,true,true,true,true),
(50015,'Steam_Tongue_Notes','Steam Tongue Notes','Etc',10,5,true,true,true,true,true,true,true,true),
(50016,'Scorpion_Steam_Notes','Scorpion Steam Notes','Etc',10,5,true,true,true,true,true,true,true,true),
(50017,'Immortal_Stew_Notes','Immortal Stew Notes','Etc',10,5,true,true,true,true,true,true,true,true),
(50018,'Dragon_Cocktail_Notes','Dragon Cocktail Notes','Etc',10,5,true,true,true,true,true,true,true,true),
(50019,'Hwergelmir_Tonic_Notes','Hwergelmir Tonic Notes','Etc',10,5,true,true,true,true,true,true,true,true),
(50020,'Nine_Tail_Notes','Nine Tail Notes','Etc',10,5,true,true,true,true,true,true,true,true);

REPLACE INTO `item_db2`
(`id`,`name_aegis`,`name_english`,`type`,`price_buy`,`price_sell`,`weight`)
VALUES
(50002,'Verdant_Leaf','Verdant Leaf','Etc',200,100,10),
(50003,'Aromatic_Herb','Aromatic Herb','Etc',240,120,10),
(50004,'Bitter_Root','Bitter Root','Etc',280,140,10),
(50005,'Golden_Corn','Golden Corn','Etc',260,130,10),
(50006,'Swift_Thyme','Swift Thyme','Etc',260,130,10),
(50007,'Sunblossom','Sunblossom','Etc',320,160,10),
(50008,'Dewy_Stem','Dewy Stem','Etc',220,110,10),
(50009,'Moon_Blossom','Moon Blossom','Etc',360,180,10),
(50010,'Wild_Vine','Wild Vine','Etc',280,140,10),
(50011,'Copper_Ore_Chunk','Copper Ore Chunk','Etc',250,125,20),
(50012,'Iron_Ore_Cluster','Iron Ore Cluster','Etc',320,160,20),
(50013,'Glittering_Crystal','Glittering Crystal','Etc',420,210,20),
(50014,'Hard_Granite','Hard Granite','Etc',300,150,20);
