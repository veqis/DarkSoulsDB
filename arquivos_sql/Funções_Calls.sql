---------------------------------------

SELECT Criar_Personagem('', '');

---1º nome_personagem
---2º classe

---------------------------------------

SELECT manipular_inventario ('','','','');
---1º ação (equipar/desequipar/descartar)
---2º nome_personagem
---3º item
---4º slot (opcional_para_descartar)

---------------------------------------

---formula de percentagem drop

P(Item)=(ID*p(Item))/(ID*sum_i(p(Item*i)) + 100*p(NoDrop) )
