from bs4 import BeautifulSoup
import requests
import re

while True:
    entrada = input()
    if entrada == 'exit':
        break
       
    site = requests.get(entrada)
    soup = BeautifulSoup(site.text, "html.parser")

    def gravar(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23):
        i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15, i16, i17, i18, i19, i20, i21, i22, i23 = map(clean, [i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15, i16, i17, i18, i19, i20, i21, i22, i23])
        f = open("iten-data.txt", "a")
        f.writelines("('{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}'),\n".format(
            i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23))
        f.close()

        
    def clean(text):
        cleaned = text.replace("'", "''").replace("(Dark Souls)", "").replace("[1]", "")
        return cleaned

                           
    for i in soup.find_all('a', attrs={"class": "category-page__member-link"}):
        link = i.get('href')
        if not link:
            continue
        if link == '/wiki/User:Mostafa_Reda':
            continue

        endereco = "https://darksouls.fandom.com" + link
        
        site2 = requests.get(endereco)
        soup2 = BeautifulSoup(site2.text, "html.parser")
        
        desc = soup2.find('div',attrs={"class":"mainbg"})
        if desc is None:
            continue
        
        nome = soup2.find(id="firstHeading").text.strip()
        
        infos = soup2.find('aside', attrs={"class": "portable-infobox pi-background pi-border-color pi-theme-DS1 pi-layout-default"})
        if infos != None:
            tipo = infos.find(string='Weapon Type')
            tipo = tipo.find_next().text
            if tipo != 'None':
                   tipo_atq = infos.find(string='Attack Type')
                   tipo_atq = tipo_atq.find_next().text
                   
                   tipo_arm = infos.find(string='Weapon Type')
                   tipo_arm = tipo_arm.find_next().text
                   
                   durab = infos.find(string='Durability')
                   durab = durab.find_next().text

                   wei = infos.find(string='Weight')
                   wei = wei.find_next().text
                   
                   tabelas = infos.find_all('table', attrs={'class': 'pi-horizontal-group'})
                   counter1 = 0
                   counter2 = 0
                   for tabela in tabelas:
                       try:
                           dados = tabela.find_all('td')
                           debug = dados[4]
                           if counter1 == 0:
                               d_fis = dados[0].text
                               d_mag = dados[1].text
                               d_fog = dados[2].text
                               d_ele = dados[3].text
                               d_crt = dados[4].text
                           elif counter1 == 1:
                              r_fis = dados[0].text
                              r_mag = dados[1].text
                              r_fog = dados[2].text
                              r_ele = dados[3].text
                              stabil = dados[4].text
                           counter1 +=1
                       except:
                           dados = tabela.find_all('td')
                           if counter2 == 0:
                                b_str = dados[0].text
                                b_dex = dados[1].text
                                b_int = dados[2].text
                                b_fht = dados[3].text
                           elif counter2 == 1:
                                r_str = dados[0].text
                                r_dex = dados[1].text
                                r_int = dados[2].text
                                r_fht = dados[3].text
                           counter2 +=1
                           pass    
                       
                   gravar(nome,tipo_arm,tipo_atq,d_fis,d_mag,d_fog,d_ele,d_crt,r_fis,r_mag,r_fog,r_ele,stabil,durab,wei,b_str,b_dex,b_int,b_fht,r_str,r_dex,r_int,r_fht)     
                
                #INSERT INTO equipamentos (nome_equipamento,categoria,tipo_ataque,fis,magi,fire,eletro,crit,fis_res,magi_res,fire_res,eletro_res,stabilidade,durabilidade,peso,str_bonus,dex_bonus,int_bonus,fht_bonus,str_req,dex_req,int_req,fht_req) 
                #VALUES
