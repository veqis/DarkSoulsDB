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
        
        desc = soup2.find('div',attrs={"class":"mainbg"})
        if desc is None:
            continue
        else:
            texto = desc.find("i").text
            gravar(nome,texto)

            
"""
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Greatswords
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Bows
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Halberds
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Hammers
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Catalysts
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Crossbows
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Katanas
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Curved_Greatswords
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Curved_Swords
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Daggers
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Axes
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Shields
https://darksouls.fandom.com/wiki/Category:Dark_Souls:_Spears
"""
