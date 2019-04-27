#!/usr/bin/python
# -*- coding: utf-8 -*-

fd = open('/sys/class/thermal/thermal_zone0/temp', 'r')
t = (float)(fd.readline())/1000
print("{:.2f}°C".format(t))
fd.close()
