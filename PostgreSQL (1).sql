CREATE OR REPLACE FUNCTION cura_personagem (nome_personagem VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    estus_disponivel INT;
BEGIN
    SELECT estus_atual INTO estus_disponivel
    FROM estado_personagem
    WHERE estado_personagem.nome_personagem = cura_personagem.nome_personagem;
    
    IF estus_disponivel > 0 THEN
        UPDATE estado_personagem 
        SET hp_atual = hp_atual + 10,
            estus_atual = estus_atual - 1
        WHERE estado_personagem.nome_personagem = cura_personagem.nome_personagem;
        
        RETURN 'Personagem curado.';
    ELSE
        RETURN 'Você não tem estus suficiente para curar-se.';
    END IF;
END;
$$ LANGUAGE plpgsql;