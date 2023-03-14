           Program pfcsf          Edition 18-01-01
           Pipe Flow Calculations  -  Steady Flow 
           =======================================

           Name: Gunnar Larsson                    
           Date: 2018-01-01                        
           Job : Cripplecreek, sf08                

           Data: Files               Case:   .....X
                 08.con               x1 =    -20.0
                 08.set               x2 =      0.0
                                      x3 =     7.00


           PIPE SYSTEM - HEAD BALANCE

       Zon   Pipes   Cross   Misc    ..   Misc   Pumps    Pumps    Motor 
        -    Hyd kW  Hyd kW  Hyd kW  ..  Hyd kW  Hyd kW   Shaft kW El kW 

        SA      0.0     0.0     0.0  ..     0.0     0.0    581.7   653.7
        SB      0.0     0.0     0.0  ..     0.0     0.0      0.0     0.0
       ------------------------------------------------------------------
       Tot      0.0     0.0     0.0  ..     0.0     0.0    581.7   653.7


           PIPE SYSTEM - HEAT BALANCE      

       Zon  HeatLoads Losses HeatEx  Misc  ..  Misc   HeatEx  Boilers
        -      kW       kW     kW     kW   ..   kW      kW      kW   

        SA        0    2227      0      0  ..      0      0         0
        SB        0     593      0      0  ..      0      0         0
       ------------------------------------------------------------------
       Tot        0    2820      0      0  ..      0      0         0


           PIPES, STEADY FLOW CONDITIONS

       Pipe   Flow    Hbeg  Hend   Temp   Vel dH/dL  Lamda  Comments
       ZnNr   m3/s    m Lc  m Lc    C     m/s mLc/km   --    (text) 

       SA03  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  F SA1 -> SA3
       SA04  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  R SA3 -> SA1
       SA05  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  F SA3 -> SA5
       SA06  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  R SA5 -> SA3
       SA07  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  F SA5 -> SA7
       SA08  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  R SA7 -> SA5
       SA09  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  F SA7 -> SA9
       SA10  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  R SA9 -> SA7
       SA11  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  F SA9 ->SA11
       SA12  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  R SA11-> SA9
       SB01  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  F SA5 -> SB1
       SB02  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  R SB1 -> SA5
       SB03  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  F SB1 -> SB3
       SB04  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  R SB3 -> SB1
       SB05  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  F SB3 -> SB5
       SB06  0.0000 2960.0 2960.0  93.0   0.0   0.0  0.640  R SB5 -> SB3


           PIPE/LINK CONNECTIONS, STEADY FLOW

       Conn    Qconn   H to  H fr   dH      Av     Heat   Comments
       Zn Nr   m3/s    m Lc  m Lc   mLc     m2      kW     (text) 

      SA  08  0.0000 2960.0 2960.0   0.0  9.99999       0  R SA7       
      SA1 01  0.0000 2960.0 2960.0   0.0  9.99999       0  Pump SA11   
      SA1 02  0.0000 2960.0 2960.0   0.0  9.99999       0  Pump SA12   
      SA1 04  0.0000 2960.0 2960.0   0.0  0.00000       0  Boiler SA11 
      SA1 68  0.0000 2960.0 2960.0   0.0  0.04600       0  Valve TH    
      SA7 01  0.0000 2960.0 2960.0   0.0  9.99999       0  Pump A71    
      SA7 02  0.0000 2960.0 2960.0   0.0  0.00000       0  Checkvalve  
      SB  01  0.0000 2960.0 2960.0   0.0  9.99999       0  F SB1       
      SB  02  0.0000 2960.0 2960.0   0.0  9.99999       0  R SB1       


           PIPE/LINK CROSS CONNECTIONS, STEADY FLOW

       Cross  Qcross   Tfor   dT    Hfor   dH  Av/Avmax  Heat  Comments
       Zn Nr   m3/s    Cels  Cels   m Lc  m Lc   ----     kW    (text) 

      SA  03  0.0000   93.0   0.0 2960.0   0.0   0.00       0  SA3, Hload..
      SA  09  0.0000   93.0   0.0 2960.0   0.0   0.00       0  SA9, Hload  
      SA  11  0.0000   93.0   0.0 2960.0   0.0   0.00       0  SA11,Hload  
      SB  03  0.0000   93.0   0.0 2960.0   0.0   0.00       0  SB3, Hload  
      SB  05  0.0000   93.0   0.0 2960.0   0.0   0.00       0  SB5, Hload  


           LINKS, STEADY FLOW CONDITIONS

       Sub Link    Head    Flow     Temp    Comments
        Nr  Nr     m Lc    m3/s      C       (text) 

       SA1  08   2960.0   0.0000    93.0   F SA1, ps   
       SA1  01   2960.0   0.0000    93.0   R SA1, ss   
       SA1  66   2960.0   0.0000    93.0   R SA1 TH    
       SA1  67   2960.0   0.0000    93.0   R SA1 TH    
       SA1  04   2960.0   0.0000    93.0   ............
       SA1  06   2960.0   0.0000    93.0   ............
       SA1  03   2960.0   0.0000    93.0   ............
       SA1  05   2960.0   0.0000    93.0   ............
       SA1  07   2960.0   0.0000    93.0   ............
       SA1  68   2960.0   0.0000    93.0   ............
       SA1  69   2960.0   0.0000    93.0   ............
       SA7  01   2960.0   0.0000    93.0   F SA7, ss   
       SA7  06   2960.0   0.0000    93.0   F SA7, ps   
       SA7  03   2960.0   0.0000    93.0   ............
       SA7  05   2960.0   0.0000    93.0   ............
       SA7  02   2960.0   0.0000    93.0   ............
       SA7  04   2960.0   0.0000    93.0   ............


           VALVES, STEADY FLOW CONDITIONS

       Valve  -S-    Fi     Av     Flow    dH    Fl   Q/Qch  Comments
       ZnNr   ---    --     m2     m3/s   m Lq   --    ---    (text) 

       SA51  1.000  1.00  0.2200  0.0000   0.0  0.54  0.00   F SA5-SA    
       SA52  1.000  1.00  0.2200  0.0000   0.0  0.54  0.00   R SA5-SA    
       SA53  1.000  1.00  0.2200  0.0000   0.0  0.54  0.00   F SA5-SB    
       SA54  1.000  1.00  0.2200  0.0000   0.0  0.54  0.00   R SA5-SB    
       SA68  1.000  1.00  0.0460  0.0000   0.0  0.60  0.00   R SA1 TH    


           PUMPS, STEADY FLOW CONDITIONS

       Pump  Npump  Flow  Hpump  Ppump  Eta   Hinl  dHcav  Fi   Comments
       ZnNr   rpm   m3/s   m Lc    kW   ---   m Lc  m Lc   --    (text) 

       SA11  1323  0.0000  73.0  260.2 0.00 2960.0 2935.2  0.00  SA1 Main    
       SA12  1330  0.0000  73.8  264.6 0.00 2960.0 2935.1  0.00  SA1 Stand by
       SA71  1323  0.0000  24.6   56.9 0.00 2960.0 2937.5  0.00  SA7 Booster 

       Drive  Pel  Emotor Evar Edrive Pshaft  Nmot   -N-   Comments
       ZnNr   kW    ---    --   ---     kW     rpm   ---    (text) 

       SA11  292.6  0.93  0.96  0.89   260.2  1470  0.900  Pump SA11   
       SA12  297.0  0.93  0.96  0.89   264.6  1470  0.905  Pump SA12   
       SA71   64.0  0.93  0.96  0.89    56.9  1470  0.900  Pump SA71   


           BOILER/HEATER/COOLER, STEADY FLOW

       Boiler  Power  Tinl  Tout  Qboil    Qb-p    dH    Av     Comments
        ZnNr    kW     C     C     m3/s    m3/s   m Lc   m2      (text) 

        SA11       0  93.0  93.0  0.0000  0.0000   0.0  0.0000  Heater SA1  


           HEAT EXCHANGERS, STEADY FLOW

                No Results to Print!
