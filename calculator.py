import math
import json

# Epsi
epsilon = 0.000001

# PROCEDURE CtrlList; input from set file 'control points'
control_codes = ['H', 'DH', 'Q', 'DQ', 'T', 'DT', 'W', 'DW']

# PROCEDURE EqList; input from con file
equipment_types = ['Q', 'GP', 'T', 'DH', 'DT', 'NO', 'CV', 'AV', 'RV', 'VA', 'PU', 'BO', 'ST', 'GC']

# FUNCTION DecF
def cal_decf(value):
    if abs(value) > epsilon:
        dec = (2-round(math.log(abs(value)/math.log(10)), 6))
    else:
        dec = 1
    
    if dec < 0:
        dec = 0
    elif dec > 6:
        dec = 6
    
    decf = dec
    return decf

# maxClose = 10;
# SelPipe,ExPipe : array[1..maxClose] of integer;

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

# cal_decf(9)
# read_file('./dummy/liquid.json')
# cal_bolier()