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
        f = open("tst.txt", "a")
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
