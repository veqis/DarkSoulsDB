from bs4 import BeautifulSoup
import requests
import re

site = requests.get("https://darksouls.fandom.com/wiki/Dagger")
soup = BeautifulSoup(site.text, "html.parser")


def gravar(a):
    f = open("tst.txt", "a")
    f.writelines("('{}'),\n".format(
        a))
    f.close()
    
nome = soup.find(id="firstHeading")

gravar(nome.text.strip())
