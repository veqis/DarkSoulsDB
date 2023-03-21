from bs4 import BeautifulSoup
import requests
import re

site = requests.get("https://darksouls.wiki.fextralife.com/Ammunition")
soup = BeautifulSoup(site.text, "html.parser")

tabelaammo = soup.find("table", attrs={"class":"wiki_table"})

corpo = soup.tbody

def gravar(nome, fis, magi, fire, eletro, crit):
    f = open("ammo.txt", "a")
    f.writelines('{}, {}, {}, {}, {}, {}\n'.format(
        nome, fis, magi, fire, eletro, crit))
    f.close()
    
corpo = corpo.findAll("tr")

for i in range(1, len(corpo)):
    titulo = corpo[i].find("strong")
    print(titulo.text)
    tds = corpo[i].find_all("td")
    dano_fisico = tds[1].text
    print(dano_fisico)
    
  
                       
    
