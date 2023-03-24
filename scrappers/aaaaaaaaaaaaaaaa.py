from bs4 import BeautifulSoup
import requests
import re

while True:
    entrada = input()
    if entrada == 'exit':
        break
       
    site = requests.get(entrada)
    soup = BeautifulSoup(site.text, "html.parser")

    def gravar(a, b):
        f = open("itens+descrição.txt", "a")
        f.writelines("('{}', '{}'),\n".format(
            a, b))
        f.close()
                           
    for i in soup.find_all('a',attrs={"class":"category-page__member-link"}):
        link = i.get('href')
        endereco = "https://darksouls.fandom.com" + link
        
        site2 = requests.get(endereco)
        soup2 = BeautifulSoup(site2.text, "html.parser")
        
        nome = soup2.find(id="firstHeading").text.strip()
        
        infos = soup2.find('aside',attrs={"class":"portable-infobox pi-background pi-border-color pi-theme-DS1 pi-layout-default"})
        if infos != None:
            tipo = infos.find(text='Weapon Type')
            tipo = tipo.find_next().text
            if tipo != 'None':
                   tipo_atq = infos.find(text='Attack Type')
                   tipo_atq = tipo_atq.find_next().text
                   
                   corpo = soup2.find_all('table', attrs='pi-horizontal-group')
                   valores = corpo[0].text.strip()
                   print(nome,valores)
                                      

                   

            
                                      #print(nome,tipo,tipo_atq)
                                      #gravar(nome.replace("'","''").replace("(Dark Souls)",""),texto.replace("'","''").replace("[1]",""))
