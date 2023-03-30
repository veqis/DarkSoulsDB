from bs4 import BeautifulSoup
import requests
import re


site = requests.get('https://darksouls.wiki.fextralife.com/Enemies')
soup = BeautifulSoup(site.text, "html.parser")

                                   
for i in soup.find_all('a', attrs={"class": "wiki_link wiki_tooltip"}):
        link = i.get('href')
        endereco = "https://darksouls.wiki.fextralife.com" + link
        
        site2 = requests.get(endereco)
        soup2 = BeautifulSoup(site2.text, "html.parser")
        for tabela in soup2.find_all('table',attrs={'class':'wiki_table'}):
            try:
                nome = tabela.find('h3').text
                print(nome)
            except:
                continue
