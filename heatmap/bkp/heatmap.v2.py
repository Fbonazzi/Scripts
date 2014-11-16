import Image
from subprocess import call
import math
import string
from numpy import zeros

height=5
width=5
#matrice=[[0 for i in xrange(0,height)] for j in xrange(0,width)] 
matrice = zeros([height,width])

file_in = open ("filein","r")

for i in xrange(0,height):
	riga = file_in.readline()

	if len(riga) == 0:
		break

	riga = riga[:-1]

	#for j in xrange(0,width):
		#matrice[i][j] = call("/home/filippo/Documenti/script/signal_level.sh -q", shell=True)
	matrice[i] = string.split(riga," ")

file_in.close()

#matrice = [[call("/home/filippo/Documenti/script/signal_level.sh -q", shell=True) for j in range(width)] for i in range(height)]

immagine=Image.new("RGBA",(100*height,100*width),(255,255,255,0))

pixel = immagine.load()

for i in xrange(0,height):
	for j in xrange(0,width):
		temp=125-matrice[i][j]
		matrice[i][j] = math.floor((temp/100)*16777215)
		b=int(math.fmod(matrice[i][j],255))                   #Add 3 normal distribution vectors for R,G,B
		g=int(math.fmod(((matrice[i][j]-b)/1000),255))        #to scale output from blue to red
		r=int(math.fmod(((matrice[i][j]-g-b)/1000000),255))
		#print "r:", r, "g:", g, "b:", b
		for k in xrange(0,100):
			for l in xrange(0,100):
				pixel[100*i+k, 100*j+l]=(r,g,b,255)

immagine.save("immagine.png")
