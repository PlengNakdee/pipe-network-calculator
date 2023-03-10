import math
import json

epsi = 0.000001

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
        # print('file-contents', file_contents)
        return file_contents

def load_file(file_name):
    with open(file_name) as f:
        file_contents = json.load(f)
        # print('file-contents', file_contents)
        return file_contents

def cal_bolier():
    boiler_data = load_file('./dummy/boiler.json')
    
    for key, value in boiler_data.items():
        print('value name', value['name'])

def cal_reynolds(mFlow, D, T, P):
    # mFlow : Mass flow                     [kg/s]
    # D     : Inner diameter of the pipe    [mm]
    # T     : Temperature of the water      [°C]
    # P     : Hydraulic Static Pressure     [bar]

    pi_number = 4 * math.atan(1)
    reynolds = 4 * mFlow / pi_number * (D/1000) * P
    print('reynolds: ', reynolds)
    return reynolds

# cal_decf(9)
# read_file('./dummy/liquid.json')
# cal_bolier()
cal_reynolds(100, 20, 140, 2)