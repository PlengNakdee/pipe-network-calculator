def cal_reynolds(mFlow, D, T, P):
    # mFlow : Mass flow                     [kg/s]
    # D     : Inner diameter of the pipe    [mm]
    # T     : Temperature of the water      [°C]
    # P     : Hydraulic Static Pressure     [bar]

    pi_number = 4 * math.atan(1)
    reynolds = 4 * mFlow / pi_number * (D/1000) * P
    print('reynolds: ', reynolds)
    return reynolds

cal_reynolds(100, 20, 140, 2)