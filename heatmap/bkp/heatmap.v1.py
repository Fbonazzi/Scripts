import Image
from subprocess import call
import math
from numpy import empty

height=10
width=5
#matrice=[[0 for i in xrange(0,height)] for j in xrange(0,width)] 
matrice = empty([height,width])

for i in xrange(0,height):
	for j in xrange(0,width):
		matrice[i][j] = call("/home/filippo/Documenti/script/signal_level.sh -q", shell=True)

#matrice = [[call("/home/filippo/Documenti/script/signal_level.sh -q", shell=True) for j in range(width)] for i in range(height)]

immagine=Image.new("RGBA",(100*height,100*width),(255,255,255,0))

#for i in range(height):
#	for j in range(width):
#		temp=matrice[i][j]
#	        matrice[i][j] = math.floor((temp/80)*pow(255,3))
#		b=int(math.fmod(matrice[i][j],255))
#		g=int(math.fmod(((matrice[i][j]-b)/1000),255))
#		r=int(math.fmod(((matrice[i][j]-g)/1000),255))
#		immagine.putpixel((i,j), (r,g,b,128)) 
pixel = immagine.load()

for i in xrange(0,height):
	for j in xrange(0,width):
		temp=100-matrice[i][j]
		print temp
		matrice[i][j] = math.floor((temp/100)*16777215)
		print matrice[i][j]
		b=int(math.fmod(matrice[i][j],255))
		g=int(math.fmod(((matrice[i][j]-b)/1000),255))
		r=int(math.fmod(((matrice[i][j]-g-b)/1000000),255))
		for k in xrange(0,100):
			for l in xrange(0,100):
				pixel[100*i+k, 100*j+l]=(r,g,b,128)

immagine.save("immagine.png")
