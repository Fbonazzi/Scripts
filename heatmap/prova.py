import heatmap
import random

pts = []
for x in range(400):
	pts.append((random.random(), random.random() ))

print "Processing %d points..." % len(pts)

hm = heatmap.Heatmap()
img = hm.heatmap(pts)
img.save("classic.png")
