#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 10 14:30:57 2020

@author: esteban
"""

m=160
n=120
i=0
archivo = open("/home/esteban/UNAL/GitHub/proyecto/proyecto.srcs/sources_1/imports/sources/circulo.men", "w")
 
for i in range(1,n+1):
    for j in range(1,m+1):
        if((i-n/2)**2+(j-m/2)**2<=(n/2-1)**2):
            archivo.write("f00\n")
        else: archivo.write("000\n")

archivo.close()