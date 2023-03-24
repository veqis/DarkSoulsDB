from bs4 import BeautifulSoup
import requests
import re

site = requests.get("https://darksouls.wiki.fextralife.com/Ore")
soup = BeautifulSoup(site.text, "html.parser")

tabela = soup.find("table", attrs={"class":"wiki_table"})

corpo = soup.tbody

def gravar(nome, fis):
    f = open("texto.txt", "a")
    f.writelines("('{}', '{}'),\n".format(
        nome, fis))
    f.close()
    
corpo = corpo.findAll("tr")

for i in range(1, len(corpo)):
    tds = corpo[i].find_all("td")
    titulo = tds[0].text
    dano_fisico = tds[1].text

    gravar(titulo,dano_fisico)
