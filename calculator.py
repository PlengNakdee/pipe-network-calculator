import math
import json

epsi = 0.000001
# writeln(Liqmax:6)
# writeln(Value : field_width)

def cal_decf(value):
    if abs(value) > epsi:
        dec = (2-round(math.log(abs(value)/math.log(10)), 6))
        print('cal', dec)
    else:
        dec = 1
    
    if dec < 0:
        dec = 0
    elif dec > 6:
        dec = 6
    
    decf = dec
    print(decf)
    return decf

def get_liquid(file_name):
    with open(file_name) as liquid_file:
        liquid_contents = liquid_file.read()
        print('liquid', liquid_contents)

cal_decf(99)
get_liquid('./dummy/liquid.json')