import math
import json

epsi = 0.000001
# writeln(Liqmax:6)
# writeln(Value : field_width)

def cal_decf(value):
    if abs(value) > epsi:
        dec = (2-round(math.log(abs(value)/math.log(10)), 6))
    else:
        dec = 1
    
    if dec < 0:
        dec = 0
    elif dec > 6:
        dec = 6
    
    decf = dec
    return decf

def read_file(file_name):
    with open(file_name) as f:
        file_contents = f.read()
        print('file-contents', file_contents)
        return file_contents

def cal_punp_hp(pr, q):


# cal_decf(9)
# read_file('./dummy/liquid.json')