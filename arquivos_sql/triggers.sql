-------------------------------------------->Função de curar personagem<-----------------------------------------------------------------
CREATE OR REPLACE FUNCTION Cura_Personagem (nome_personagem VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    estus_disponivel INT;
BEGIN
    SELECT estus_atual INTO estus_disponivel
    FROM estado_personagem
    WHERE estado_personagem.nome_personagem = cura_personagem.nome_personagem;
    
    IF estus_disponivel > 0 THEN
        UPDATE estado_personagem 
        SET hp_atual = hp_atual + 300,
            estus_atual = estus_atual - 1
        WHERE estado_personagem.nome_personagem = cura_personagem.nome_personagem;
        
        RETURN 'Personagem curado.';
    ELSE
        RETURN 'Você não tem estus suficiente para curar-se.';
    END IF;
END;
$$ LANGUAGE plpgsql;

-------------------------------------------->Trigger que não permite hp atual ultrapassar hp_maximo<-------------------------------------
CREATE OR REPLACE FUNCTION HP_Check()
RETURNS TRIGGER AS $$
DECLARE
    hp_max INT;
BEGIN
    SELECT hp INTO hp_max
    FROM personagens
    WHERE nome = NEW.nome_personagem;
    
    IF NEW.hp_atual > hp_max THEN
        UPDATE estado_personagem
        SET hp_atual = hp_max
        WHERE nome_personagem = NEW.nome_personagem;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trava_HP
AFTER UPDATE ON estado_personagem
FOR EACH ROW
EXECUTE FUNCTION HP_Check();

-------------------------------------------->Trigger que insere dados do save do personagem para status atual<---------------------------
CREATE OR REPLACE FUNCTION Novo_Personagem()
RETURNS TRIGGER AS $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM estado_personagem WHERE nome_personagem = NEW.nome) THEN
		INSERT INTO estado_personagem (nome_personagem, hp_atual, almas_atual, hum_atual, estus_atual)
		VALUES (NEW.nome, NEW.hp, NEW.almas, NEW.hum, 0);
    ELSE
        UPDATE estado_personagem
        SET hp_atual = (SELECT hp FROM personagens WHERE nome = NEW.nome),
        	almas_atual = (SELECT almas FROM personagens WHERE nome = NEW.nome),
            hum_atual = (SELECT hum FROM personagens WHERE nome = NEW.nome)
        WHERE nome_personagem = NEW.nome;    	
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER Update_Estado_Personagem
AFTER INSERT OR UPDATE ON personagens
FOR EACH ROW
EXECUTE FUNCTION Novo_Personagem();

-------------------------------------------->Trigger que ajusta a quantidade de estus atual do personagem<-------------------------------
CREATE OR REPLACE FUNCTION Calc_Estus()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE estado_personagem
	SET estus_atual = (SELECT nivel_bonefire FROM respawn WHERE nome_personagem = NEW.nome_personagem) * 5
	WHERE nome_personagem = NEW.nome_personagem;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Estus_UPDT
AFTER INSERT ON respawn
FOR EACH ROW
EXECUTE FUNCTION Calc_Estus();



-------------------------------------------->Função de criar personagem<-----------------------------------------------------------------
CREATE OR REPLACE FUNCTION Criar_Personagem(nome_personagem VARCHAR, classe VARCHAR)
RETURNS VARCHAR AS $$
BEGIN
    IF classe = 'Warrior' THEN
        INSERT INTO personagens (nome, classe, almas, hp, stamina, equip_load, item_discovery, attunment_slot, bleed_res, poison_res, curse_res, poise, nivel, vit, att, endu, str, dex, res, int, fth, hum)
        VALUES (nome_personagem, classe, 0, 400, 90, 50, 100, 0, 48, 36, 30, 0, 4, 11, 8, 12, 13, 13, 11, 9, 9, 0);
        
        INSERT INTO inventario (nome_item,nome_personagem,quantidade) 
		VALUES 
        ('Longsword', nome_personagem,'1'),
        ('Heater Shield', nome_personagem,'1'),
        ('Iron Helm', nome_personagem, '1'),
        ('Hard Leather Armor', nome_personagem, '1'),
        ('Hard Leather Gauntlets', nome_personagem, '1'),
        ('Hard Leather Boots', nome_personagem, '1');
        
        RETURN 'Personagem criado com sucesso.';
    ELSIF classe = 'Knight' THEN
        INSERT INTO personagens (nome, classe, almas, hp, stamina, equip_load, item_discovery, attunment_slot, bleed_res, poison_res, curse_res, poise, nivel, vit, att, endu, str, dex, res, int, fth, hum)
        VALUES (nome_personagem, classe, 0, 400, 90, 0, 100, 0, 40, 30, 30, 0, 5, 14, 10, 10, 11, 11, 10, 9, 11, 0);
        
        INSERT INTO inventario (nome_item,nome_personagem,quantidade) 
		VALUES 
        ('Broadsword', nome_personagem,'1'),
        ('Caduceus Kite Shield', nome_personagem,'1'),
        ('Knight Helm', nome_personagem, '1'),
        ('Knight Armor', nome_personagem, '1'),
        ('Knight Gauntlets', nome_personagem, '1'),
        ('Knight Leggings', nome_personagem, '1');        
        
        RETURN 'Personagem criado com sucesso.';
    ELSIF classe = 'Wanderer' THEN
        INSERT INTO personagens (nome, classe, almas, hp, stamina, equip_load, item_discovery, attunment_slot, bleed_res, poison_res, curse_res, poise, nivel, vit, att, endu, str, dex, res, int, fth, hum)
        VALUES (nome_personagem, classe, 0, 400, 90, 0, 100, 0, 40, 42, 30, 0, 3, 10, 11, 10, 10, 14, 12, 11, 8, 0);
        
        INSERT INTO inventario (nome_item,nome_personagem,quantidade) 
		VALUES 
        ('Scimitar', nome_personagem,'1'),
        ('Leather Shield', nome_personagem,'1'),
        ('Brigand Hood', nome_personagem, '1'),
        ('Brigand Armor', nome_personagem, '1'),
        ('Brigand Gauntlets', nome_personagem, '1'),
        ('Brigand Trousers', nome_personagem, '1');          
        
        RETURN 'Personagem criado com sucesso.';
    ELSIF classe = 'Thief' THEN
        INSERT INTO personagens (nome, classe, almas, hp, stamina, equip_load, item_discovery, attunment_slot, bleed_res, poison_res, curse_res, poise, nivel, vit, att, endu, str, dex, res, int, fth, hum)
        VALUES (nome_personagem, classe, 0, 400, 90, 0, 100, 0, 37, 30, 30, 0, 5, 9, 11, 9, 9, 15, 10, 12, 11, 0);
        
        INSERT INTO inventario (nome_item,nome_personagem,quantidade) 
		VALUES 
        ('Bandit''s Knife', nome_personagem,'1'),
        ('Iron Round Shield', nome_personagem,'1'),
        ('Dark Mask', nome_personagem, '1'),
        ('Black Leather Armor', nome_personagem, '1'),
        ('Black Leather Gloves', nome_personagem, '1'),
        ('Black Leather Boots', nome_personagem, '1');          
        
        RETURN 'Personagem criado com sucesso.';
    ELSIF classe = 'Bandit' THEN
        INSERT INTO personagens (nome, classe, almas, hp, stamina, equip_load, item_discovery, attunment_slot, bleed_res, poison_res, curse_res, poise, nivel, vit, att, endu, str, dex, res, int, fth, hum)
        VALUES (nome_personagem, classe, 0, 400, 90, 0, 100, 0, 56, 36, 36, 0, 4, 12, 8, 14, 14, 9, 11, 8, 10, 0);
        
        INSERT INTO inventario (nome_item,nome_personagem,quantidade) 
		VALUES 
        ('Battle Axe', nome_personagem,'1'),
        ('Spider Shield', nome_personagem,'1'),
        ('Brigand Hood', nome_personagem, '1'),
        ('Brigand Armor', nome_personagem, '1'),
        ('Brigand Gauntlets', nome_personagem, '1'),
        ('Brigand Trousers', nome_personagem, '1');          
        
        RETURN 'Personagem criado com sucesso.';
    ELSIF classe = 'Hunter' THEN
        INSERT INTO personagens (nome, classe, almas, hp, stamina, equip_load, item_discovery, attunment_slot, bleed_res, poison_res, curse_res, poise, nivel, vit, att, endu, str, dex, res, int, fth, hum)
        VALUES (nome_personagem, classe, 0, 400, 90, 0, 100, 0, 44, 36, 30, 0, 4, 11, 9, 11, 12, 14, 11, 9, 9, 0);
        
        INSERT INTO inventario (nome_item,nome_personagem,quantidade) 
		VALUES 
        ('Shortsword', nome_personagem,'1'),
        ('Short Bow', nome_personagem,'1'),
        ('Large Leather Shield', nome_personagem, '1'),
        ('Leather Armor', nome_personagem, '1'),
        ('Leather Gloves', nome_personagem, '1'),
        ('Leather Boots', nome_personagem, '1');         
        
        RETURN 'Personagem criado com sucesso.';
    ELSIF classe = 'Sorcerer' THEN
        INSERT INTO personagens (nome, classe, almas, hp, stamina, equip_load, item_discovery, attunment_slot, bleed_res, poison_res, curse_res, poise, nivel, vit, att, endu, str, dex, res, int, fth, hum)
        VALUES (nome_personagem, classe, 0, 400, 90, 0, 100, 0, 33, 26, 30, 0, 3, 8, 15, 8, 9, 11, 8, 15, 8, 0);
        
        INSERT INTO inventario (nome_item,nome_personagem,quantidade) 
		VALUES 
        ('Dagger', nome_personagem,'1'),
        ('Small Leather Shield', nome_personagem,'1'),
        ('Sorcerer''s Catalyst', nome_personagem, '1'),
        ('Black Sorcerer Hat', nome_personagem, '1'),
        ('Black Sorcerer Cloak', nome_personagem, '1'),
        ('Black Sorcerer Gauntlets', nome_personagem, '1'),
        ('Black Sorcerer Boots', nome_personagem, '1'),
        ('Soul Arrow', nome_personagem, '1');
        
        RETURN 'Personagem criado com sucesso.';
    ELSIF classe = 'Pyromancer' THEN
        INSERT INTO personagens (nome, classe, almas, hp, stamina, equip_load, item_discovery, attunment_slot, bleed_res, poison_res, curse_res, poise, nivel, vit, att, endu, str, dex, res, int, fth, hum)
        VALUES (nome_personagem, classe, 0, 400, 90, 0, 100, 0, 44, 42, 30, 0, 1, 10, 12, 11, 12, 9, 12, 10, 8, 0);
        
        INSERT INTO inventario (nome_item,nome_personagem,quantidade) 
		VALUES        
        ('Hand Axe', nome_personagem, '1'),
        ('Cracked Round Shield', nome_personagem, '1'),
        ('Pyromancy Flame', nome_personagem, '1'),
        ('Dingy Hood', nome_personagem, '1'),
        ('Dingy Robe', nome_personagem, '1'),
        ('Dingy Gloves', nome_personagem, '1'),
        ('Heavy Boots', nome_personagem, '1'),
        ('Fireball', nome_personagem, '1');

        RETURN 'Personagem criado com sucesso.';
    ELSIF classe = 'Cleric' THEN
        INSERT INTO personagens (nome, classe, almas, hp, stamina, equip_load, item_discovery, attunment_slot, bleed_res, poison_res, curse_res, poise, nivel, vit, att, endu, str, dex, res, int, fth, hum)
        VALUES (nome_personagem, classe, 0, 400, 90, 0, 100, 0, 37, 36, 30, 0, 2, 11, 11, 9, 12, 8, 11, 8, 14, 0);
        
        INSERT INTO inventario (nome_item,nome_personagem,quantidade) 
		VALUES        
        ('Mace', nome_personagem, '1'),
        ('East-West Shield', nome_personagem, '1'),
        ('Canvas Talisman', nome_personagem, '1'),
        ('Holy Robe', nome_personagem, '1'),
        ('Holy Trousers', nome_personagem, '1'),
        ('Heal', nome_personagem, '1'),
        ('Leather Gloves', nome_personagem, '1');        
        
        RETURN 'Personagem criado com sucesso.';
    ELSIF classe = 'Deprived' THEN
        INSERT INTO personagens (nome, classe, almas, hp, stamina, equip_load, item_discovery, attunment_slot, bleed_res, poison_res, curse_res, poise, nivel, vit, att, endu, str, dex, res, int, fth, hum)
        VALUES (nome_personagem, classe, 0, 400, 90, 0, 100, 0, 44, 36, 30, 0, 6, 11, 11, 11, 11, 11, 11, 11, 11, 0);
        
        INSERT INTO inventario (nome_item,nome_personagem,quantidade) 
		VALUES        
        ('Club', nome_personagem, '1'),
        ('Plank Shield', nome_personagem, '1');
        
        RETURN 'Personagem criado com sucesso.';
    ELSE
        RETURN 'Classe não suportada.';
    END IF;
END;
$$ LANGUAGE plpgsql;

-------------------------------------------->Trigger que autocalcula status dos personagens<---------------------------------------------
CREATE OR REPLACE FUNCTION Calcular_Status()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE personagens
    SET hp = 300 + (vit * 50),
        stamina = 90 + (endu * 2),
        equip_load = 50 + endu,
        item_discovery = 100 + (10 * hum),
        attunment_slot = (att / 5),
        bleed_res = 30 + endu,
        poison_res = 30 + res,
        curse_res = 30 + hum
    WHERE nome = NEW.nome;

    IF ( (SELECT stamina FROM personagens WHERE nome = NEW.nome) > 160) THEN
        UPDATE personagens
        SET stamina = 160
        WHERE nome = NEW.nome;
    END IF;

    IF ( (SELECT item_discovery FROM personagens WHERE nome = NEW.nome) > 200) THEN
        UPDATE personagens
        SET item_discovery = 200
        WHERE nome = NEW.nome;
    END IF;

    IF ( (SELECT attunment_slot FROM personagens WHERE nome = NEW.nome) > 10) THEN
        UPDATE personagens
        SET attunment_slot = 10
        WHERE nome = NEW.nome;
    END IF;

    IF ( (SELECT bleed_res FROM personagens WHERE nome = NEW.nome) > 150) THEN
        UPDATE personagens
        SET bleed_res = 150
        WHERE nome = NEW.nome;
    END IF;

    IF ( (SELECT poison_res FROM personagens WHERE nome = NEW.nome) > 150) THEN
        UPDATE personagens
        SET poison_res = 150
        WHERE nome = NEW.nome;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER Edit_Status
AFTER INSERT OR UPDATE ON personagens
FOR EACH ROW
WHEN (pg_trigger_depth() < 1)
EXECUTE FUNCTION Calcular_Status();

-------------------------------------------->Função de Level-UP<-------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION Level_UP(nome_personagem VARCHAR, atributo VARCHAR)
RETURNS VARCHAR AS $$
DECLARE 
    lv_atual INT;
    almas_atual INT;
BEGIN
    SELECT nivel, almas INTO lv_atual, almas_atual
    FROM personagens
    WHERE nome = nome_personagem;
    
    IF atributo = 'vit' OR atributo = 'att' OR atributo = 'endu' OR atributo = 'str' OR atributo = 'dex' OR atributo = 'res' OR atributo = 'int' OR atributo = 'fth' THEN
        IF almas_atual >= 673 + (17 * lv_atual) AND lv_atual < 12 THEN
            UPDATE personagens
            SET almas = almas_atual - (673 + (17 * lv_atual)),
                nivel = nivel + 1
            WHERE nome = nome_personagem;    

            IF atributo = 'vit' THEN
                UPDATE personagens
                SET "vit" = "vit" + 1
                WHERE nome = nome_personagem;        

            ELSIF atributo = 'att' THEN
                UPDATE personagens
                SET "att" = "att" + 1
                WHERE nome = nome_personagem;        

            ELSIF atributo = 'endu' THEN
                UPDATE personagens
                SET "endu" = "endu" + 1
                WHERE nome = nome_personagem;

            ELSIF atributo = 'str' THEN
                UPDATE personagens
                SET "str" = "str" + 1
                WHERE nome = nome_personagem;

            ELSIF atributo = 'dex' THEN
                UPDATE personagens
                SET "dex" = "dex" + 1
                WHERE nome = nome_personagem;

            ELSIF atributo = 'res' THEN
                UPDATE personagens
                SET "res" = "res" + 1
                WHERE nome = nome_personagem;

            ELSIF atributo = 'int' THEN
                UPDATE personagens
                SET "int" = "int" + 1
                WHERE nome = nome_personagem;

            ELSIF atributo = 'fth' THEN
                UPDATE personagens
                SET "fth" = "fth" + 1
                WHERE nome = nome_personagem;

            END IF;

            RETURN 'Subiu de nível.';
        ELSIF almas_atual >= POWER((0.02 * lv_atual), 3) + POWER((3.06 * lv_atual), 2) + 105.6 * lv_atual - 895 THEN
            UPDATE personagens
            SET almas = almas_atual - (POWER((0.02 * lv_atual), 3) + POWER((3.06 * lv_atual), 2) + 105.6 * lv_atual - 895),
                nivel = nivel + 1
            WHERE nome = nome_personagem;    

            IF atributo = 'vit' THEN
                UPDATE personagens
                SET "vit" = "vit" + 1
                WHERE nome = nome_personagem;        

            ELSIF atributo = 'att' THEN
                UPDATE personagens
                SET "att" = "att" + 1
                WHERE nome = nome_personagem;        

            ELSIF atributo = 'endu' THEN
                UPDATE personagens
                SET "endu" = "endu" + 1
                WHERE nome = nome_personagem;

            ELSIF atributo = 'str' THEN
                UPDATE personagens
                SET "str" = "str" + 1
                WHERE nome = nome_personagem;

            ELSIF atributo = 'dex' THEN
                UPDATE personagens
                SET "dex" = "dex" + 1
                WHERE nome = nome_personagem;

            ELSIF atributo = 'res' THEN
                UPDATE personagens
                SET "res" = "res" + 1
                WHERE nome = nome_personagem;

            ELSIF atributo = 'int' THEN
                UPDATE personagens
                SET "int" = "int" + 1
                WHERE nome = nome_personagem;

            ELSIF atributo = 'fth' THEN
                UPDATE personagens
                SET "fth" = "fth" + 1
                WHERE nome = nome_personagem;

            END IF;

            RETURN 'Subiu de nível.';
        ELSE
            RETURN 'Almas insuficientes para subir de nível.';
        END IF;
    ELSE
        RETURN 'Atributo inválido.';
    END IF;
END;
$$ LANGUAGE plpgsql;
-------------------------------------------->Função de Personagem morreu<----------------------------------------------------------------
CREATE OR REPLACE FUNCTION Personagem_Morre(nome VARCHAR)
RETURNS VARCHAR AS $$
DECLARE 
    almas_curr INT;
    almas_max INT;
    hum_curr INT;
    hum_max INT;
BEGIN
    SELECT almas, hum INTO almas_max, hum_max
    FROM personagens
    WHERE personagens.nome = Personagem_Morre.nome;
    
    SELECT almas_atual, hum_atual INTO almas_curr, hum_curr
    FROM estado_personagem
    WHERE nome_personagem = Personagem_Morre.nome;
    
    IF almas_curr = almas_max AND hum_curr = hum_max THEN
        UPDATE estado_personagem
        SET almas_atual = 0,
            hum_atual = 0
        WHERE nome_personagem = Personagem_Morre.nome;
    
    ELSIF almas_curr != almas_max OR hum_curr != hum_max THEN
        UPDATE personagens
        SET almas = almas_curr,
            hum = hum_curr
        WHERE personagens.nome = Personagem_Morre.nome;
    END IF;
    
    RETURN 'Você morreu.';
END;
$$ LANGUAGE plpgsql;

-------------------------------------------->Função de Recuperar copo de personagem morto<-----------------------------------------------
CREATE OR REPLACE FUNCTION Recuperar_Corpo(nome VARCHAR)
RETURNS VARCHAR AS $$
DECLARE 
    almas_curr INT;
    almas_max INT;
    hum_curr INT;
    hum_max INT;
BEGIN
    SELECT almas, hum INTO almas_max, hum_max
    FROM personagens
    WHERE personagens.nome = Recuperar_Corpo.nome;
    
    SELECT almas_atual, hum_atual INTO almas_curr, hum_curr
    FROM estado_personagem
    WHERE nome_personagem = Recuperar_Corpo.nome;
    
    IF almas_curr != almas_max OR hum_curr != hum_max THEN
        UPDATE estado_personagem
        SET almas_atual = almas_max,
            hum_atual = hum_max
        WHERE nome_personagem = Recuperar_Corpo.nome;
    
    ELSIF almas_curr = almas_max OR hum_curr = hum_max THEN
        RETURN 'Não há corpo para recuperar';
    END IF;
    
    RETURN 'Corpo Recuperado.';
END;
$$ LANGUAGE plpgsql;

-------------------------------------------->Trigger autocalcular_poise perosnagem<------------------------------------------------------

-- Trigger para INSERT e UPDATE
CREATE OR REPLACE FUNCTION Att_Poise()
RETURNS TRIGGER AS $$
DECLARE
    soma_poise INT;
BEGIN
    SELECT SUM(a.poise) INTO soma_poise
    FROM armaduras a
    JOIN equipa e ON a.nome_armadura = e.nome_item
    WHERE e.nome_personagem = NEW.nome_personagem;

    UPDATE personagens
    SET poise = soma_poise
    WHERE nome = NEW.nome_personagem;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para DELETE
CREATE OR REPLACE FUNCTION Att_Poise_Delete()
RETURNS TRIGGER AS $$
DECLARE
    soma_poise INT;
BEGIN
    SELECT SUM(a.poise) INTO soma_poise
    FROM armaduras a
    JOIN equipa e ON a.nome_armadura = e.nome_item
    WHERE e.nome_personagem = OLD.nome_personagem;

    UPDATE personagens
    SET poise = soma_poise
    WHERE nome = OLD.nome_personagem;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Trigger para INSERT e UPDATE
CREATE TRIGGER Att_Poise
AFTER INSERT OR UPDATE ON equipa
FOR EACH ROW
EXECUTE FUNCTION Att_Poise();

-- Trigger para DELETE
CREATE TRIGGER Att_Poise_Delete
AFTER DELETE ON equipa
FOR EACH ROW
EXECUTE FUNCTION Att_Poise_Delete();

-------------------------------------------->Função de manipular inventário do personagem<-----------------------------------------------
CREATE OR REPLACE FUNCTION Manipular_Inventario(acao VARCHAR, nome VARCHAR, item VARCHAR, slot VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    qtd_item INT;
BEGIN
    IF acao = 'equipar' THEN
        INSERT INTO equipa (nome_item, nome_personagem, slot)
        VALUES (item, nome, slot);
        
        RETURN 'Item equipado com sucesso.';
    ELSIF acao = 'desequipar' THEN
        DELETE FROM equipa
        WHERE nome_personagem = nome AND nome_item = item AND equipa.slot = slot;
        
        RETURN 'Item desequipado com sucesso.';
    ELSIF acao = 'descartar' THEN
        SELECT quantidade INTO qtd_item
        FROM inventario
        WHERE nome_personagem = nome AND nome_item = item;
        
        IF qtd_item > 1 THEN
            UPDATE inventario
            SET quantidade = quantidade - 1
            WHERE nome_personagem = nome AND nome_item = item;
        ELSE
            DELETE FROM inventario
            WHERE nome_personagem = nome AND nome_item = item;
        END IF;
        
        RETURN 'Item removido do inventário.';
    ELSE
        RETURN 'Ação inválida.';
    END IF;
END;
$$ LANGUAGE plpgsql;

-------------------------------------------->Função calcular dano<-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION Calcular_Dano (personagem VARCHAR, slot_arma VARCHAR, alvo VARCHAR)
RETURNS TABLE(resultado_texto TEXT) AS $$
DECLARE
    dano_fis INT;
    dano_mag INT;
    dano_fog INT;
    dano_ele INT;
    r_fis_monstro INT;
    r_mag_monstro INT;
    r_fog_monstro INT;
    r_ele_monstro INT;
    dano1 INT;
    dano2 INT;
    dano3 INT;
    dano4 INT;
    total INT;
    media INT;
BEGIN
    SELECT fis, magi, fire, eletro INTO dano_fis, dano_mag, dano_fog, dano_ele
    FROM equipamentos a
    JOIN equipa e ON a.nome_equipamento = e.nome_item
    WHERE slot_arma = slot;
    
    SELECT r_fis, r_magic, r_fogo, r_electro INTO r_fis_monstro, r_mag_monstro, r_fog_monstro, r_ele_monstro
    FROM monstro
    WHERE nome_monstro = alvo;

    IF dano_fis > r_fis_monstro AND dano_fis != 0 THEN
        SELECT (dano_fis - 0.79 * r_fis_monstro * POWER(2.71828, (-0.27 * (r_fis_monstro / dano_fis)))) INTO dano1;
    ELSEIF dano_fis < r_fis_monstro AND dano_fis != 0 THEN
        SELECT (0.4 * (POWER(dano_fis, 3) / (POWER(r_fis_monstro, 2)) - 0.09 * (POWER(dano_fis, 2) / r_fis_monstro) + 0.1 * dano_fis)) INTO dano1;
    ELSE 
        SELECT 0 INTO dano1;
    END IF;
    
    IF dano_mag > r_mag_monstro AND dano_mag != 0 THEN
        SELECT (dano_mag - 0.79 * r_mag_monstro * POWER(2.71828, (-0.27 * (r_mag_monstro / dano_mag)))) INTO dano2;
    ELSEIF dano_mag < r_mag_monstro AND dano_mag != 0 THEN
        SELECT (0.4 * (POWER(dano_mag, 3) / (POWER(r_mag_monstro, 2)) - 0.09 * (POWER(dano_mag, 2) / r_mag_monstro) + 0.1 * dano_mag)) INTO dano2;
    ELSE 
        SELECT 0 INTO dano2;    
    END IF;

    IF dano_fog > r_fog_monstro AND dano_fog != 0 THEN
        SELECT (dano_fog - 0.79 * r_fog_monstro * POWER(2.71828, (-0.27 * (r_fog_monstro / dano_fog)))) INTO dano3;
    ELSEIF dano_fog < r_fog_monstro AND dano_fog != 0 THEN
        SELECT (0.4 * (POWER(dano_fog, 3) / (POWER(r_fog_monstro, 2)) - 0.09 * (POWER(dano_fog, 2) / r_fog_monstro) + 0.1 * dano_fog)) INTO dano3;
    ELSE 
        SELECT 0 INTO dano3;      
    END IF;

    IF dano_ele > r_ele_monstro AND dano_ele != 0 THEN
        SELECT (dano_ele - 0.79 * r_ele_monstro * POWER(2.71828, (-0.27 * (r_ele_monstro / dano_ele)))) INTO dano4;
    ELSEIF dano_ele < r_ele_monstro AND dano_ele != 0 THEN
        SELECT (0.4 * (POWER(dano_ele, 3) / (POWER(r_ele_monstro, 2)) - 0.09 * (POWER(dano_ele, 2) / r_ele_monstro) + 0.1 * dano_ele)) INTO dano4;
    ELSE 
        SELECT 0 INTO dano4;      
    END IF;

    SELECT dano1 + dano2 + dano3 + dano4 INTO total;
    
    SELECT hp_monstro / total INTO media
    FROM monstro
    WHERE nome_monstro = alvo;

    RETURN QUERY SELECT 'Dano por hit = ' || total::text;
    RETURN QUERY SELECT 'Média de ataques para derrotar = ' || media::text;
END;
$$ LANGUAGE plpgsql;

