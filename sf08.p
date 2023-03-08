Program PFCSF  ( input, output );
uses GPC;

LABEL 1; 
CONST Prog = 'Program pfcsf'; Ed = '18-01-01'; Init ='sf.ini';
{     Pumps = '/users/fludex/bag/bin/bagpumps.dat';   }
      Pumps = '/home/bag/bin/bagpumps.dat';
{     Pumps = '/home/soal/bin/bagpumps.dat'; }
{     Pumps = '/export/home/bag/pfc/bag/bagpumps.dat';  }
      utfil='/tmp/date.txt';
      utfil1='/tmp/dateplot.txt';
      yearlimit=2023;
      manlimit=1;
      Pro = 'Pipe Flow Calculations  -  Steady Flow '; 
      Mmenu='Files   Read   Display   Set   Init   Calcu   Tables   Graphs    Update    Exit';
      Dash ='-------------------------------------------------------------------------------';
      Epsi = 1E-06; Pii = 3.1416; g = 9.81; Etrmin = 0.05; Emomin = 0.05; 
      maxAp = 88; dAp = 0.0713998; LaStart = 0.02; Qinit = 0.0; 
      maxIter = 100000; maxZon = 676;
      maxPi = 12000; maxId = 67699; maxSid = 6769; maxN = 1; 
      maxCn = 200; maxJn = 4000; maxCs = 4000; maxEq = 14;
      maxBoil = 50; maxVa = 500; maxIo = 25; maxLio = 5;
      maxRVperf = 20; maxPipePerf = 150;
      maxVperf = 60; maxPu = 130; maxDr = 130; maxPperf = 150;
      maxAc = 30; maxSu = 200; maxBor = 25; maxLjn = 40;
      maxLcn = 40; maxLcs = 10; maxLi = 99; maxAlarm = 100;
      maxEx = 25; maxLex = 5; maxHexPerf = 20; maxTab = 10; maxVi = 11;
      maxF = 9; maxCh1 = 16; maxCheck = 3; maxClose = 10;
      maxIdstr = 10; maxIdch = 40; maxLiq = 11; maxCom = 12; 
      maxCase = 20; maxCaseTyp = 6; maxCaseCom = 40;
      maxVaCtrl = 200; maxDrCtrl = 200; maxCtrlTyp = 8;
      maxXvar = 3; maxXF = 11; maxFxPost = 50;  {funktioner}
      maxFxstr = 5; maxXstr = 2; maxFstr = 3; max20 = 20;maxword = 9;
TYPE  Str1 = packed array[1..maxCh1] of char; 
   xString = packed array[1..max20] of char;
     StrId = packed array[1..maxIdch] of char; 
   Comment = packed array[1..maxCom] of char; 
        S2 = packed array[1..2] of char; 
        S3 = packed array[1..3] of char;       
       S12 = packed array[1..12] of char;
       S10 = packed array[1..10] of char;
 CaseIdTyp = packed array[1..maxCaseTyp] of char; 
CaseComTyp = packed array[1..maxCaseCom] of char; 
     EqStr = packed array[1..2] of char;
   CtrlTyp = packed array[1..2] of char;
    Vecfil = array[1..maxF] of Str1; 
     MatPi = array[1..maxPi,0..maxN] of real; 
   PostLiq = record  Temp,Dens,Spec,Pvap,Visc,Emodul : real; end; 
  PostPipe = record  Id: integer; 
                     L,D,Ks,Zeta,Kval,Eth,Fprel,dp : real; 
                     Xp,Yp,Zp : array[0..maxN] of real;
                     Com : Comment; end; 
 PostCheck = record  Id,W : integer; 
                     BE : char; end; 
 PostAlarm = record  Id : integer; 
                     Zpi,bar : real; 
                     BE,HL : char;
                     Lab : packed array[1..2] of char; end;
   PostBor = record  Id,Pi,Li : integer;
                     xkoord,ykoord,elev : real;
                     Com : Comment;  end; 
   PostLcn = record  Id,Lto,Ecod,Enr,Lfr : integer; 
                     Elev,Value,Hconn : real; 
                     Com : Comment; end; 
   PostLjn = record  Id,ValveSum : integer; 
                     Li,Vnr : array[1..4] of integer; 
                     Hljn,Tljn,Elev : real; 
                     Com : Comment; end; 
   PostLcs = record  Id,Vnr : integer; 
                     Cat : char;
                     Li : array[1..8] of integer; 
                     Hf,Hr,Avmax,Ql,Qcs,Pnom,Fsum,Pload,dTr,Tf,Tr,Elev,RaCsp : real; 
                     Com : Comment; end; 
PostBoiler = record  Id : integer; 
                     MF : char; 
                     Avboil,Tboil,Tpipe,Wmax,Avbp,Tb,Tp,Avres,Qbt,RaCsp : real; 
                     Com : Comment; end; 
    PostCn = record  Id,Pto,Ecod,Enr,Pfr : integer; 
                     xkoord,ykoord,Elev,Value,Hconn : real; 
                     Com : Comment; end; 
    PostCs = record  Id,Vnr : integer; 
                     Cat : char;
                     p : array [1..8] of integer; 
                     Hf,Hr,Avmax,Ql,Qcs,Pnom,Fsum,Pload,dTr,Tf,Tr,Elev,RaCsp: real;
                     xkoord,ykoord: real;
		     Com : Comment; end; 
     PostJn = record  Id,ValveSum : integer; 
                     p,Vnr : array [1..4] of integer; 
                     xkoord,ykoord,Hjn,Tjn,Elev : real; 
                     Com : Comment; end; 
  PostPref = record  Id,Pref,DrId : integer; 
                     Zp,Np,Avbv,DIx : real; 
                     YN : char; 
                     Com : Comment; end; 
 PostDrive = record  Id : integer; 
                     Pmot,Emot,Nmot,Evar,Nmax,Ndr : real; 
                     Vartyp : char; 
                     Com : Comment; end; 
   NomPump = record  Pref,Ptyp : integer; 
                     Nnom,Hpqo,RaNom,NyNom,Pmek, 
                     Qnom,Hnom,Pnom,Mnom,NHnom : real; end; 
  PostVref = record  Id,Vref : integer; 
                     S,Fi,Fl,Zv,Hch : real; 
                     Com : Comment; end;
 PerfValve = record  Vref,Vtyp : integer; 
                     Avp,Avm,Smin,Smax : real; end; 
    CtrlVa = record  Dir,PiLi : char; 
                     dSetold,Setvalue,Fctrl : real; 
                     VaId,Code,p1,p2,i1,i2,PoRef : integer; end; 
    CtrlDr = record  Dir,PiLi : char; 
                     dSetOld,Setvalue,Fctrl : real;
                     DrId,Code,p1,p2,i1,i2,PoRef : integer; end; 
    PostAc = record  Id : integer; 
                     Atyp : char;
                     Avp,Avm,Da,Za,Gvol,Npol : real; 
                     Com : S12; end; 
    PostIo = record  BE,QP : char;
                     Pi : integer;
                     xkoord,ykoord,Elev,Temp,Value,Hbound : real; 
                     Com : Comment; end;
   PostLio = record  BE,QP : char;
                     Li : integer;
                     Elev,Temp,Value,Hbound : real; 
                     Com : Comment; end;
   PostLex = record  su,eNr,Href,pTo,pFr,sTo,sFr : integer;
                     Elev,pAv,Qpo,Tpm,kAo,Qso,Tsm,sAv : real; 
                     Com : Comment; end; 
   PostEx  = record  Id,Href,pTo,pFr,sTo,sFr : integer;
                     Elev,pAv,Qpo,Tpm,KAo,Qso,Tsm,sAv : real; 
                     Com : Comment; end; 
   PerfHex = record  Href : integer;
                     Vexp,TL,AdTm,Aps : real; end;
    PostFx = record  Fstr : packed array[1..maxFstr] of char;
                     fx : array[1..maxXF] of real; end;
    PostRv = record  A,B,C : real; end;
 MmenuChar = Set of 'A'..'Z';
         word      = packed array [1..maxword]     of char;


VAR   Fxstr : packed array[1..maxFxstr] of char;
      Str : S12;
      x1String,x2String,x3String : xString;
      xf : array[1..maxXvar,1..maxXF] of real;
      FxPost : array[1..maxXvar,1..maxFxPost] of PostFx;
      Fxmax : array[1..maxXvar] of integer;
      PipePost : array[1..maxPi] of PostPipe; 
      Liquid : array[1..maxLiq] of PostLiq; 
      CheckPost : array[1..maxCheck] of PostCheck; 
      AlarmPost : array[1..maxAlarm] of PostAlarm; 
      CnPost : array [1..maxCn] of PostCn; 
      Eqtyp : array[1..maxEq] of EqStr;
      CtrlStr : array[1..maxCtrlTyp] of CtrlTyp;
      CsPost : array [1..maxCs] of PostCs; 
      JnPost : array [1..maxJn] of PostJn; 
      IoPost : array[1..maxIo] of PostIo;
      BorPost : array[1..maxSu,1..maxBor] of PostBor; 
      LcnPost : array[1..maxSu,1..maxLcn] of PostLcn; 
      LjnPost : array[1..maxSu,1..maxLjn] of PostLjn; 
      LcsPost : array[1..maxSu,1..maxLcs] of PostLcs; 
      LioPost : array[1..maxSu,1..maxLio] of PostLio; 
      Boiler : array[1..maxBoil] of PostBoiler; 
      PrefPost : array[1..maxPu] of PostPref; 
      DrivePost : array[1..maxDr] of PostDrive; 
      PumpNom : array[1..maxPperf] of NomPump; 
      FH, FM, FN : array[1..maxPperf,0..maxAp] of real; 
      RvPost : array[1..maxRvPerf] of PostRv;
      VrefPost : array[1..maxVa] of PostVref;
      ValvePerf : array[1..maxVperf] of PerfValve;
      TabNr,Vimax : array[1..maxTab] of integer;
      Vsl,Vfi,Vfl : array[1..maxTab,1..maxVi] of real;
      SelPipe,ExPipe : array[1..maxClose] of integer;
      SetCase : CaseIdTyp;
      VaCtrl : array[1..maxVaCtrl] of CtrlVa; 
      DrCtrl : array[1..maxDrCtrl] of CtrlDr; 
      AcPost : array[1..maxAc] of PostAc; 
      ExPost : array[1..maxEx] of PostEx;
      LexPost : array[1..maxSu,1..maxLex] of PostLex; 
      HexPerf : array[1..maxHexPerf] of PerfHex;
      SubId : array[1..maxSu] of integer; 
      Supek : array[1..maxSid] of integer; 
      Lipek : array[1..maxSu,1..maxLi] of integer; 
      Limax,Brmax,Lcnmax,Ljnmax,Lcsmax,Liomax,
      Lexmax : array[1..maxSu] of integer; 
      Fil : VecFil; 
      ZonPek,ZonId : array[1..maxZon] of integer;
      Pipek,Vapek,Pupek,Drpek : array[1..maxId] of integer; 
      PuNomPek,VaPerfPek,RvPerfPek,RvNr,HexPerfpek,
      TabPek : array[1..99] of integer;
      Qvt,H1vt,H2vt,Tvt : array[1..maxVa] of real; 
      Qpt,H1pt,Tpt : array[1..maxPu] of real; 
      Cp,Cm,Cr,Api,Rdt,dTt : array[1..maxPi] of real; 
      dQS,dHS : array[1..maxPi] of integer; 
      Ht,Htdt,Qt,Qtdt,Tt : MatPi; 
      Idstr :  array[1..maxIdstr] of StrId; 
      CaseCom : array[1..maxCase] of CaseComTyp; 
      Cpl,Cml,Tli : array[1..maxSu,1..99] of real; 
      Tinit,Hinit,Aaset,AaResp,Htol,Qtol,Ftol,dQtol,dHtol, 
      Crl,Ny,Ra,Csp,Patm,Hatm,Hvap,Emod,Tsur,Aastart,Kfac,
      Kkorr,Aload,Bload,Cload,Dload,Eload,Gload,
      Aret,Bret,Cret,Dret,Eret,Fret,
      FaddA,FaddB,FaddC,FaddD,FaddE,FaddF,
      TaddA,TaddB,TaddC,TaddD,TaddE,TaddF,x1,x2,x3 : real;
      i,M,Dummy,Pimax,Cnmax,Jnmax,Csmax,Boilmax,LoadCsmax,LoadLcsmax, 
      Vamax,Vperfmax,Pumax,Drmax,Pperfmax,Acmax,Itermax,Step,Sumax,Remin, 
      Alarmmax, Idstrmax,Liqmax,Casemax,VaCtrlmax,DrCtrlmax,CloseMax,
      Mtol,Mctrl,Mmin,ManVaCtrl,ManDrCtrl,Iomax,Exmax,HexPerfmax,
      ContLines,Tabmax,Len,RvPerfmax,Zonmax,Radantal,PipePerfmax,Fmax,
      Felkod : integer;
      ConFlag,ConvFlag,TolFlag,ReadError,NewCaseFlag,Pflag,
      RedFlag,SetFlag,AlarmFlag : Boolean; 
      Choice,OldChoice,ch,FlYN : char;
      MenuSet : MmenuChar;
      f : text; 
      Res: Integer;
      year,man,datumlim,datum: real; 
            datestr : s10;


   PROCEDURE Gerror;
     BEGIN
      GOTO 1;
     END;
  
   PROCEDURE Red;
    BEGIN
     If RedFlag then begin 
        Radantal := Radantal+1;
        write(chr(27),'7');                 {Save Cursor}
        write(chr(27):1,'[23;60H');         {Cursor till 23/60}
        write('Line:':5,Radantal:3,' ':1); 
        write(chr(27),'8');                 {Restore Cursor} 
        end; 
    END;

   PROCEDURE Stop;
     VAR ch : char;
     BEGIN  
       writeln; write('Hit Return : ':31); 
       If eoln(input) then read(ch)
                      else begin read(ch); readln; end;
       writeln; writeln;
     END; { Stop }

  PROCEDURE Paus;
    CONST Col = 80;
    VAR i : integer;
        ch : char;
        Str: packed array[1..4] of char;
    BEGIN
     i := Col-5; Str :='[  C';
     Str[2] := chr((i div 10)+48); Str[3] := chr((i mod 10)+48);
     write(chr(27),'[1A',chr(27),Str,'cont');
     {read(ch);} readln(ch);
    END;
 
  FUNCTION DecF (Value : real) : integer;
    CONST Epsi = 1E-6;
    VAR Dec : integer;
    BEGIN
      If abs(Value)>Epsi then Dec := (2-trunc(ln(abs(Value))/ln(10)))
                         else Dec := 1;
      If Dec<0 then Dec := 0;
      If Dec>6 then Dec := 6;
      DecF := Dec;
    END;

   FUNCTION ReadIr {(VAR ReadError:boolean;)} : integer;
     CONST maxch = 16;
     VAR Str : packed array[1..maxCh] of char;
       i,k,Sign,Htal : integer;
       Letter : set of '0'..'9';
   BEGIN
    Letter := ['0'..'9']; Sign := 1;
    For i := 1 to maxCh do Str[i] := '0';
    k := 0; ReadError := false;
    WHILE not eoln do begin k := k+1;
          For i := 1 to maxCh-1 do Str[i] := Str[i+1];
          read(Str[maxCh]); end; readln;
    If k=0 then ReadError := true;
    i := 0; 
    REPEAT i := i+1; UNTIL (Str[i]<>'0') or (i=maxCh);
    If (i=maxCh) and (Str[i] in ['+','-']) then ReadError := true;
    If Str[i]='+' then begin Sign := +1; Str[i] := '0'; end;
    If Str[i]='-' then begin Sign := -1; Str[i] := '0'; end;
    For i := 1 to maxCh do
        If not (Str[i] in Letter) then ReadError := true;
    Htal := 0; 
    If not ReadError then begin 
       For i := 1 to maxCh do Htal := Htal*10+ord(Str[i])-ord('0'); end;
    ReadIr := Sign*Htal; 
   END; {ReadIr}

  FUNCTION ReadRl {(VAR ReadError:boolean;)} : real;
   CONST maxch = 16;
   VAR Str : packed array[1..maxCh] of char;
       i,k,Imax,Sign : integer;
       Htal,Dtal : real;
       Letter : set of '.'..'9';
   BEGIN
    Letter := ['.','0'..'9']; Sign := 1;
    For i := 1 to maxCh do Str[i] := '0';
    k := 0; ReadError := false;
    WHILE not eoln do begin  k := k+1;
       For i := 1 to maxCh-1 do Str[i] := Str[i+1];
           read(Str[maxCh]); end; readln;
    If k=0 then ReadError := true;
    k := 0; 
    REPEAT  k := k+1; UNTIL (Str[k]<>'0') or (k=maxCh);
    If (k=maxCh) and (Str[k] in ['.','+','-']) then ReadError := true;
    If Str[k]='+' then begin Sign := +1; Str[k] := '0'; end;
    If Str[k]='-' then begin Sign := -1; Str[k] := '0'; end;
    For i := 1 to maxCh do
        If not (Str[i] in Letter) then ReadError := true;
    Htal := 0; Dtal := 0;
    If not ReadError then begin i := 0;
       REPEAT i := i+1; UNTIL ((Str[i]='.') or (i=maxCh));
       If i=maxCh then Imax := maxCh else Imax := i-1;
       If Str[maxCh]='.' then Imax := i-1;
       For k := 1 to Imax do Htal := Htal*10+ord(Str[k])-ord('0');
       For k := Imax+2 to maxCh do 
           Dtal := Dtal+(ord(Str[k])-ord('0'))/exp((k-Imax-1)*ln(10)); end;
    readRl := Sign*(Htal+Dtal); 
  END; {ReadRl}

  FUNCTION LineNr(Max:integer) : integer;
    CONST maxCh = 3;
    VAR i,j,jmax,mnr : integer;
        NN,NX : array[1..maxCh] of char;
        Flag : Boolean;
    BEGIN
     REPEAT
       For i := 1 to maxCh do begin NN[i] := ' '; NX[i] := ' '; end;
       write('Line : ':7); i := 1; Flag := true; 
       WHILE (i<=maxCh) and (not eoln) do begin
         read(NN[i]); i := i+1; end;
       readln; j := 0; mnr := 0;
       For i := 1 to maxCh do 
           If NN[i]<>' ' then begin j := j+1; NX[j] := NN[i]; end;
       jmax := j;
       For i := 1 to jmax do
           If not (NX[i] in ['0'..'9']) then Flag := false;
       For j := 1 to Jmax do
           mnr := mnr+round(exp((Jmax-j)*ln(10))*(ord(NX[j])-48));
     UNTIL (Flag) and (mnr<=Max); 
     LineNr := mnr;
    END; {LineNr}

   PROCEDURE NotImpl; 
      BEGIN { Notimpl } 
        writeln; writeln('Not implemented!':32); Stop; 
      END;  { Notimpl } 
 
  FUNCTION Uchar(ch:char) : char; 
     BEGIN 
       If ((ord(ch)>96) and (ord(ch)<123)) then ch := chr(ord(ch)-32) 
                                           else ch := ch; 
       Uchar := ch; 
      END; 
 
   FUNCTION OK (Flag:Boolean) : Boolean;
     BEGIN
      If Flag then OK := true
      else begin writeln('Sorry! No Data to Process!':44);
                 Choice := OldChoice; OK := false; end;
     END;   {OK}

   PROCEDURE Aclear; 
     BEGIN 
       writeln; write(chr(27),'[2J',chr(27),'[1;1H'); writeln;
     END; 

   PROCEDURE Connect(VAR f:text;Fname:Str1;RW:char);
    VAR i,Bl,Tecken : integer;
        F5 : packed array[1..5] of char;
        F6 : packed array[1..6] of char;
        F7 : packed array[1..7] of char;
        F8 : packed array[1..8] of char;
        F9 : packed array[1..9] of char;
        F10 : packed array[1..10] of char;
        F11 : packed array[1..11] of char;
        F12 : packed array[1..12] of char;
        F13 : packed array[1..13] of char;
        F14 : packed array[1..14] of char;
        F15 : packed array[1..15] of char;
        F16 : packed array[1..16] of char;
    BEGIN
     Bl := 0;
     For i := 1 to maxCh1 do
         If (Fname[i]=' ') then Bl := Bl+1;
     Tecken := maxCh1-Bl;
{$I-}     
     CASE Tecken OF
     5: begin For i := 1 to Tecken do F5[i] := Fname[i];
              If RW='R' then reset(f,F5) else rewrite(f,F5); end;
     6: begin For i := 1 to Tecken do F6[i] := Fname[i];
              If RW='R' then reset(f,F6) else rewrite(f,F6); end;
     7: begin For i := 1 to Tecken do F7[i] := Fname[i];
              If RW='R' then reset(f,F7) else rewrite(f,F7); end;
     8: begin For i := 1 to Tecken do F8[i] := Fname[i];
              If RW='R' then reset(f,F8) else rewrite(f,F8); end;
     9: begin For i := 1 to Tecken do F9[i] := Fname[i];
              If RW='R' then reset(f,F9) else rewrite(f,F9); end;
    10: begin For i := 1 to Tecken do F10[i] := Fname[i];
              If RW='R' then reset(f,F10) else rewrite(f,F10); end;
    11: begin For i := 1 to Tecken do F11[i] := Fname[i];
              If RW='R' then reset(f,F11) else rewrite(f,F11); end;
    12: begin For i := 1 to Tecken do F12[i] := Fname[i];
              If RW='R' then reset(f,F12) else rewrite(f,F12); end;
    13: begin For i := 1 to Tecken do F13[i] := Fname[i];
              If RW='R' then reset(f,F13) else rewrite(f,F13); end;
    14: begin For i := 1 to Tecken do F14[i] := Fname[i];
              If RW='R' then reset(f,F14) else rewrite(f,F14); end;
    15: begin For i := 1 to Tecken do F15[i] := Fname[i];
              If RW='R' then reset(f,F15) else rewrite(f,F15); end;
    16: begin For i := 1 to Tecken do F16[i] := Fname[i];
              If RW='R' then reset(f,F16) else rewrite(f,F16); end;
     END;
     Felkod := IOresult;
{$I+}     
    END; {Connect}

  PROCEDURE SeCom(Com,Str12:S12; l:integer);
   VAR i,p,y : integer;
       Flag : Boolean;
       Str : S12;
   BEGIN
    Flag := false; p := 0; 
    If Str12[1]='+' then begin l := l-1;
       For i := 1 to l do Str[i] := Str12[i+1]; end
    else Str := Str12;
    REPEAT y := 0;
      For i := (p+1) to p+l do 
          If (Com[i]=Str[i-p]) or (Str[i-p]='*') then y := y+1; 
      If (y=l) and (l>0) then Flag := true;
      p := p+1;
    UNTIL ((Flag) or (p=(13-l)));
    Pflag := Flag;
   END; {SeCom}

  PROCEDURE SeZon(Z2:S2; Str:S12; l:integer);
   VAR Zon : S2;
       i,y :integer;
   BEGIN
    For i := 1 to 2 do Zon[i] := Str[i];
    If l=0 then Zon :='**';
    If l=1 then Zon[2] := '*';
    y := 0;
    For i := 1 to 2 do 
        If (Zon[i]=Z2[i]) or (Zon[i]='*') then y := y+1;
    If y=2 then Pflag := true else Pflag := false;
   END; {SeZon}

  PROCEDURE Zstr;
    VAR ch : char;
        i : integer;
    BEGIN
      Str := '           '; Len := 0; write('Zon : ':10);
      WHILE (not eoln) and (Len<12) do begin
        Len := Len+1; read(Str[Len]); end; readln;
      If Str[1]<>'+' then begin
         For i := 1 to 2 do begin
             ch := Str[i]; ch := Uchar(ch); Str[i] := ch; end;
         For i := 3 to 12 do Str[i] := ' '; end;
    END; {Zstr}

 PROCEDURE CtrlList;
  BEGIN
   CtrlStr[1]  := 'H '; CtrlStr[2]  := 'DH'; CtrlStr[3]  := 'Q ';
   CtrlStr[4]  := 'DQ'; CtrlStr[5]  := 'T '; CtrlStr[6]  := 'DT';
   CtrlStr[7]  := 'W '; CtrlStr[8]  := 'DW'; 
  END;

 PROCEDURE EqList;
  BEGIN
   Eqtyp[1]  := 'Q '; Eqtyp[2]  := 'GP'; Eqtyp[3]  := 'T ';
   Eqtyp[4]  := 'DH'; Eqtyp[5]  := 'DT'; Eqtyp[6]  := 'NO';
   Eqtyp[7]  := 'CV'; Eqtyp[8]  := 'AV'; Eqtyp[9]  := 'RV';
   Eqtyp[10] := 'VA'; Eqtyp[11] := 'PU'; Eqtyp[12] := 'BO';
   Eqtyp[13] := 'ST'; Eqtyp[14] := 'GC';
  END;

 FUNCTION EqtypToCode (Str : EqStr) : integer;
  VAR i,s,t : integer;
  BEGIN
    s := 0; t := 0;
    For i := 1 to maxEq do
        If (Eqtyp[i]=Str) then begin
           s := i; t := t+1; end;
    If t<>1 then begin writeln;
       writeln('Equipment Type Error!!':28,'Etyp = ': 10,Str:2); Gerror; end;
    EqtypToCode := s;
  END; 

 FUNCTION ReadId (VAR f:text) : integer;
  VAR ch : char;
      Sign,i,Nr : integer;
      Z2 : S2;
  BEGIN
   REPEAT read(f,ch); UNTIL (ch<>' ');
   If ch='-' then begin Sign := -1; read(f,Z2[1]); end
             else begin Sign := +1; Z2[1] := ch; end;    
   read(f,Z2[2]);
   For i := 1 to 2 do begin ch := Z2[i]; ch := Uchar(ch); 
       If not (ch in ['A'..'Z']) then begin writeln;
          writeln('Zon Error! Illegal character!':40); Gerror; end; 
       Z2[i] := ch; end;
   read(f,Nr);    
   ReadId := Sign*(100*((ord(Z2[1])-65)*26+ord(Z2[2])-64)+Nr);  
  END;
 
 FUNCTION ReadSid : integer;
  VAR ch : char;
      i,Nr : integer;
      Z2 :S2;
  BEGIN
   REPEAT read(f,ch); UNTIL (ch<>' ');
   Z2[1] := ch; read(f,Z2[2],Nr);
   For i := 1 to 2 do begin ch := Z2[i]; ch := Uchar(ch);
       If not (ch in ['A'..'Z']) then begin writeln;
          writeln('Sub Error! Illegal character':40); Gerror; end;    
       Z2[i] := ch; end;
   ReadSid := 10*((ord(Z2[1])-65)*26+ord(Z2[2])-64)+Nr;      
  END;

 FUNCTION ReadZ2 (VAR f:text) : integer;
  VAR ch : char;
      i : integer;
      Z2 :S2;
  BEGIN
   REPEAT read(f,ch); UNTIL (ch<>' ');
   Z2[1] := ch; read(f,Z2[2]);
   For i := 1 to 2 do begin ch := Z2[i]; ch := Uchar(ch);
       If not (ch in ['A'..'Z']) then begin writeln;
          writeln('Zon Error! Illegal character':40); Gerror; end;    
       Z2[i] := ch; end;
   ReadZ2 := (ord(Z2[1])-65)*26+ord(Z2[2])-64;      
  END;

 FUNCTION IdS2(Znr :integer) : S2;
  VAR Z2 : S2;
      a : integer;
  BEGIN
   a := (Znr-1) div 26;
   Z2[1] := chr(a+65);
   Z2[2] := chr((Znr-a*26)+64);
   IdS2 := Z2;
  END;
     
 FUNCTION NrS3 (Nr:integer) : S3;
  VAR Str3 : S3;
  BEGIN
   If Nr<0 then Str3[1] := '-' else Str3[1] := ' '; Nr := abs(Nr);
   Str3[3] := chr(Nr mod 10+48);
   If Nr<10 then Str3[2] := '0' else Str3[2] := chr(Nr div 10 +48);
   NrS3 := Str3;   
 END;

 FUNCTION NrS2(Nr:integer) : S2;
  VAR Str2 : S2;
  BEGIN
   Nr := abs(Nr);
   Str2[2] := chr(Nr mod 10+48);
   If Nr<10 then Str2[1] := '0' else Str2[1] := chr(Nr div 10+48);
   NrS2 := Str2;
  END;
   
PROCEDURE ClosePipes;
 VAR i,e,s,b,c,j,Znr : integer;
 BEGIN
  For i := 1 to Closemax do begin
      Znr := PipePost[SelPipe[i]].Id div 100;
      e := Pimax+i; ExPipe[i] := e;
      PipePost[e] := PipePost[SelPipe[i]];
      Api[e] := Api[SelPipe[i]];
      Cr[e] := Cr[SelPipe[i]];
      Rdt[e] := Rdt[SelPipe[i]];
      Ht[e,0] := Hinit; Ht[e,1] := Hinit;
      Qt[e,0] := Qinit; Qt[e,1] := Qinit;  
      Tt[e,0] := Tinit; Tt[e,1] := Tinit;
      For s := 1 to Sumax do 
          For b := 1 to Brmax[s] do With BorPost[s,b] do
              If (Pi>0) and (Pi=SelPipe[i]) then Pi := ExPipe[i];
      For c := 1 to Cnmax do
          If (CnPost[c].Pto=SelPipe[i]) then CnPost[c].Pto := ExPipe[i];
      For c := 1 to Jnmax do With JnPost[c] do
          For j := 1 to 4 do
              If (p[j]>0) and (p[j]=SelPipe[i]) then p[j] := ExPipe[i];
      For c := 1 to Csmax do With CsPost[c] do
          For j := 1 to 8 do 
              If (p[j]>0) and (p[j]=SelPipe[i]) then p[j] := ExPipe[i];
  end;
 END; {ClosePipes}
 
PROCEDURE UnClosePipe(Un:integer);
 VAR i,c,j,e,s,b : integer;
     Zn : char;
 BEGIN
  For c := 1 to Cnmax do
      If (CnPost[c].Pto=ExPipe[Un]) then CnPost[c].Pto := SelPipe[Un];
  For c := 1 to Jnmax do With JnPost[c] do
      For j := 1 to 4 do
          If (p[j]>0) and (p[j]=ExPipe[Un]) then p[j] := SelPipe[Un];
  For c := 1 to Csmax do With CsPost[c] do
      For j := 1 to 8 do 
          If (p[j]>0) and (p[j]=ExPipe[Un]) then p[j] := SelPipe[Un];
  Zn := chr(PipePost[SelPipe[Un]].Id div 100+65); 
  For s := 1 to Sumax do 
      If (chr(SubId[s] div 10+65)=Zn) then
         For b := 1 to Brmax[s] do With BorPost[s,b] do
             If (Pi>0) and (Pi=ExPipe[Un]) then Pi := SelPipe[Un];
  For i := Un to Closemax-1 do begin
      SelPipe[i] := SelPipe[i+1];
      Expipe[i] := ExPipe[i+1]; e := ExPipe[i];
      PipePost[e] := PipePost[SelPipe[i]];
      Api[e] := Api[SelPipe[i]];
      Cr[e] := Cr[SelPipe[i]];
      Rdt[e] := Rdt[SelPipe[i]];
      Ht[e,0] := Hinit; Ht[e,1] := Hinit;
      Qt[e,0] := Qinit; Qt[e,1] := Qinit;  
      Tt[e,0] := Tinit; Tt[e,1] := Tinit; end;
  CloseMax := CloseMax-1;
  ConvFlag := false; 
 END; {UnClosePipe}
 
   PROCEDURE InitFiles;
    VAR ch : char;
        m,n : integer;
        Z2 : S2;  
    BEGIN
     For m := 1 to maxF do
         For n := 1 to maxCh1 do Fil[m,n] := ' ';
     reset(f,Init); readln(f); read(f,ch); m := 0;
     WHILE not (ch=' ') do begin readln(f); read(f,ch); end;
     WHILE ch=' ' do begin m := m+1; n := 1;
       REPEAT read(f,Fil[m,n]); UNTIL Fil[m,n]<>' ';
       REPEAT n := n+1; read(f,Fil[m,n]); UNTIL Fil[m,n]=' ';
       readln(f); read(f,ch); end; Fmax := m;
     WHILE not (ch=' ') do begin readln(f); read(f,ch); end;
     readln(f,ContLines);
     REPEAT read(f,ch); UNTIL ch<>' ';
     Z2[1] := Uchar(ch); read(f,ch); Z2[2] := Uchar(ch);
     If Z2='ON' then RedFlag := true else RedFlag := false;
     Close(f);
    END;    {InitFiles}
 
   PROCEDURE IOfiles;
      TYPE Str4 = packed array[1..4] of char;
      VAR i,y,p,Imax : integer;
         ch : char;
         Ext4,Dum4 : Str4;
      PROCEDURE FileMenu;
        VAR j : integer;
        BEGIN
         Aclear; writeln(Mmenu); writeln(Dash);
         For j := 1 to 2 do writeln;
         writeln(' ':14,'Designate Input/Output Files');
         writeln(' ':14,'----------------------------');
         writeln;
         writeln(' ':14,'1 - Pipe System Configuration File :  ',Fil[1]);
         writeln(' ':14,'2 - Set Points for Steady Flow     :  ',Fil[2]);
         writeln(' ':14,'3 - Paths and Scales for Graphs    :  ',Fil[3]);
         writeln(' ':14,'4 - Dump File for Steady Flow      :  ',Fil[4]);
         writeln(' ':14,'5 - Printfile for Tables           :  ',Fil[5]);
         writeln(' ':14,'6 - Plotfile for Graphs            :  ',Fil[6]);
         writeln(' ':14,'7 - Preparation for Transient Flow :  ',Fil[7]);
         writeln(' ':14,'8 - File for detected Alarms       :  ',Fil[8]);
         writeln(' ':14,'9 - File for Selected Output       :  ',Fil[9]); 
         writeln(' ':14,'0 - Return to Main Menu'); writeln;
         REPEAT
           write('Choice : ':14); read(ch); readln; ch := Uchar(ch);
         UNTIL (ord(ch)>47) and (ord(ch)<58) or (ch in MenuSet);
         If ord(ch)=48 then Choice := 'X' else OldChoice := 'F';
         If (ch in MenuSet) then begin Choice := ch; y := 0; end
             else y := ord(ch)-48;
       END;

      BEGIN  {IOfiles}
       Ext4 := '    '; Dum4 := '    ';
       REPEAT FileMenu;
         If (y>=1) and (y<=9) then begin writeln;
           writeln('     Old File Name : ':49,Fil[y]:maxCh1);
           For i := 1 to maxCh1 do If Fil[y,i]='.' then p := i;
           For i := 1 to 4 do Ext4[i] := Fil[y,p+i-1];
           For i := 1 to maxCh1 do Fil[y,i] := ' ';
           write('Type New File Name : ':49); i := 1; 
           WHILE not eoln and (i<=12) do
               begin  read(Fil[y,i]); i := i+1; end; readln;
           Imax := i-1;
           If Imax>4 then For i := 1 to 4 do Dum4[i] := Fil[y,Imax-4+i];
           If Dum4=Ext4 then Imax := Imax-4;
           For i := 1 to 4 do Fil[y,Imax+i] := Ext4[i]; end; {If y}
       UNTIL (y=0) or (ch in MenuSet);
      END;   { IOfiles }

  PROCEDURE TempInit(Tinit:real); 
    VAR i,p : integer; 
    BEGIN 
      p := 1; 
      For i := 1 to Liqmax do With Liquid[i] do 
          If (Temp<Tinit) then p := i; 
      If p>Liqmax-1 then p := Liqmax-1; 
      With Liquid[p] do begin 
      Ra := (Liquid[p+1].Dens-Dens)/(Liquid[p+1].Temp-Temp); 
      Ra := Dens+Ra*(Tinit-Temp); Hatm := Patm*1E05/Ra/g; 
      Ny := (Liquid[p+1].Visc-Visc)/(Liquid[p+1].Temp-Temp); 
      Ny := Visc+Ny*(Tinit-Temp); Ny := Ny*1E-06; 
      Hvap := (Liquid[p+1].Pvap-Pvap)/(Liquid[p+1].Temp-Temp); 
      Hvap := Pvap+Hvap*(Tinit-Temp); Hvap := Hvap*1E05/Ra/g; 
      Csp := (Liquid[p+1].Spec-Spec)/(Liquid[p+1].Temp-Temp); 
      Csp := Spec+Csp*(Tinit-Temp); 
      Emod := (Liquid[p+1].Emodul-Emodul)/(Liquid[p+1].Temp-Temp); 
      Emod := Emodul+Emod*(Tinit-Temp); end; 
    END;   {TempInit} 
 
  FUNCTION Viscosity(Tpipe:real) : real; 
    VAR i,p : integer; 
        Nyt : real; 
    BEGIN 
      p := 1; 
      For i := 1 to Liqmax do With Liquid[i] do 
          If (Temp<Tpipe) then p := i; 
      If p>Liqmax-1 then p := Liqmax-1; 
      With Liquid[p] do begin 
      Nyt := (Liquid[p+1].Visc-Visc)/(Liquid[p+1].Temp-Temp); 
      Nyt := Visc+Nyt*(Tpipe-Temp); 
      Viscosity := Nyt*1E-06; end; 
    END;   {Viscosity} 

  FUNCTION Density(Tpipe:real) : real; 
    VAR i,p : integer; 
        Rat : real; 
    BEGIN 
      p := 1; 
      For i := 1 to Liqmax do With Liquid[i] do 
          If (Temp<Tpipe) then p := i; 
      If p>Liqmax-1 then p := Liqmax-1; 
      With Liquid[p] do begin 
      Rat := (Liquid[p+1].Dens-Dens)/(Liquid[p+1].Temp-Temp); 
      Density := Dens+Rat*(Tpipe-Temp); end;
    END;   {Density} 
 
  FUNCTION Hvapor(Tpipe:real) : real; 
    VAR i,p : integer; 
        Hvat : real; 
    BEGIN 
      p := 1; 
      For i := 1 to Liqmax do With Liquid[i] do 
          If (Temp<Tpipe) then p := i; 
      If p>Liqmax-1 then p := Liqmax-1; 
      With Liquid[p] do begin 
      Hvat := (Liquid[p+1].Pvap-Pvap)/(Liquid[p+1].Temp-Temp); 
      Hvat := Pvap+Hvat*(Tpipe-Temp);
      Hvapor := Hvat*1E05/Density(Tpipe)/g; end;
    END;   {Hvapor} 
 
  FUNCTION SpecHeat(Tpipe:real) : real; 
    VAR i,p : integer; 
        Cspt : real; 
    BEGIN 
      p := 1; 
      For i := 1 to Liqmax do With Liquid[i] do 
          If (Temp<Tpipe) then p := i; 
      If p>Liqmax-1 then p := Liqmax-1; 
      With Liquid[p] do begin 
      Cspt := (Liquid[p+1].Spec-Spec)/(Liquid[p+1].Temp-Temp); 
      SpecHeat := Spec+Cspt*(Tpipe-Temp); end;
    END;   {SpecHeat} 
 
   PROCEDURE PumpH1pt; 
     VAR Cn,s,c,Pu : integer; 
     BEGIN 
       For Cn := 1 to Cnmax do begin  With CnPost[Cn] do begin 
           If (Ecod=11) then begin Pu := Pupek[Enr];  
              H1pt[Pu] := Ht[Pto,1]; Tpt[Pu] := Tt[Pto,1]; end;
           end; end; 
       For s := 1 to Sumax do begin 
           For c := 1 to Lcnmax[s] do begin With LcnPost[s,c] do begin 
               If (Ecod=11) then begin  Pu := Pupek[Enr];
                  H1pt[Pu] := Crl*(Cpl[s,Lto]-Cml[s,Lto])/2; 
                  Tpt[Pu] := Tli[s,Lto]; end;
           end; end; end;  
     END; { PumpH1pt } 
 
   FUNCTION PumpHp (Pnr : integer; N,Q : real) : real; 
     CONST maxK = 1; 
     VAR Pu,Pr,i,k : integer; 
         Nx,Qx,Qo,Ho,D2x,Ap : real; 
         Qp,Hp : array[0..maxK] of real; 
     BEGIN 
       Pu := Pupek[Pnr]; Pr := PrefPost[Pu].Pref;
       Pr := PuNomPek[Pr]; D2x := PrefPost[Pu].DIx;   
       If abs(N)<1 then N := 1; 
       With PumpNom[Pr] do begin Nx := N/Nnom; 
       Qo := sqr(D2x)*Qnom; Ho := sqr(D2x)*Hnom;  end;
       Qx := Q/Qo; Ap := arctan(Qx/Nx); 
       If Nx<0 then Ap := Pii+arctan(Qx/Nx); 
       If (Qx<0) and (Nx>0) then Ap := 2*Pii+Ap; 
       i := trunc(Ap/dAp); 
       If i=maxAp then i := maxAp-1; 
       For k := 0 to maxK do begin 
           Qp[k] := Nx*(sin((i+k)*dAp)/cos((i+k)*dAp))*Qo; 
           Hp[k] := FH[Pr,i+k]*(sqr(Nx)+sqr(Qx))*Ho; end; 
       PumpHp := Hp[0]+(Hp[1]-Hp[0])/(Qp[1]-Qp[0])*(Q-Qp[0]);
     END;  { PumpHp } 
 
   FUNCTION PumpMp (Pnr : integer; N,Q : real) : real; 
     VAR Pu,Pr,i,k : integer; 
         Nx,Qx,Mpu,Mo,Qo,D2x,Ap : real; 
         Qp,Mp : array[0..1] of real; 
     BEGIN 
       Pu := Pupek[Pnr]; Pr := PrefPost[Pu].Pref;
       Pr := PuNomPek[Pr]; D2x := PrefPost[Pu].DIx;   
       If abs(N)<1 then N := 1; 
       With PumpNom[Pr] do begin Nx := N/Nnom;
       Qo := sqr(D2x)*Qnom; Mo := sqr(D2x)*sqr(D2x)*Mnom;  end;
       Qx := Q/Qo; Ap := arctan(Qx/Nx); 
       If Nx<0 then Ap := Pii+arctan(Qx/Nx); 
       If (Qx<0) and (Nx>0) then Ap := 2*Pii+Ap; 
       i := trunc(Ap/dAp); 
       If i=maxAp then i := maxAp-1; 
       For k := 0 to 1 do begin 
           Qp[k] := Nx*(sin((i+k)*dAp)/cos((i+k)*dAp))*Qo; 
           Mp[k] := FM[Pr,i+k]*(sqr(Nx)+sqr(Qx))*Mo; end; 
       Mpu := Mp[0]+(Mp[1]-Mp[0])/(Qp[1]-Qp[0])*(Q-Qp[0]); 
       PumpMp := Ra/PumpNom[Pr].RaNom*Mpu; 
     END; { PumpMp } 
 
   FUNCTION PumpNh (Pnr : integer; N,Q : real) : real; 
     CONST maxK = 1; 
     VAR Pu,Pr,i,k : integer; 
         Nx,Qx,Ap : real; 
         Qp,Nh : array[0..maxK] of real; 
     BEGIN 
       Pu := Pupek[Pnr]; Pr := PrefPost[Pu].Pref;    
       Pr := PuNomPek[Pr];
       With PumpNom[Pr] do begin 
       If abs(N)<1 then N := 1; 
       Nx := N/Nnom; Qx := Q/Qnom; Ap := arctan(Qx/Nx); 
       If Nx<0 then Ap := Pii+arctan(Qx/Nx); 
       If (Qx<0) and (Nx>0) then Ap := 2*Pii+Ap; 
       i := trunc(Ap/dAp); 
       If i=maxAp then i := maxAp-1; 
       For k := 0 to maxK do begin 
           Qp[k] := Nx*(sin((i+k)*dAp)/cos((i+k)*dAp))*Qnom; 
           Nh[k] := FN[Pr,i+k]*(sqr(Nx)+sqr(Qx))*NHnom; end; 
       PumpNh := Nh[0]+(Nh[1]-Nh[0])/(Qp[1]-Qp[0])*(Q-Qp[0]); end; 
     END; { PumpNh } 
 
    FUNCTION Emotor( Px:real;Dr:integer):real; 
     VAR Em : real; 
     BEGIN 
       Px := abs(Px); 
       Em := 1.1*Px/(Px+0.06+0.04*sqr(Px))*DrivePost[Dr].Emot; 
       If Px>1 then Em := DrivePost[Dr].Emot; 
       If Em<Emomin then Em := Emomin; 
       Emotor := Em; 
     END;  {Emotor} 
 
    FUNCTION Etrans(Nx:real; Dr:integer) : real; 
     VAR Etr,Fmek,Eva,Sli : real; 
         Typ : char; 
     BEGIN 
      Nx := abs(Nx); Typ := DrivePost[Dr].Vartyp; 
      Eva := DrivePost[Dr].Evar; Sli := DrivePost[Dr].Nmax; 
      CASE Typ OF 
      'F': begin If Nx>=1 then Etr := Eva 
                          else Etr := (1-exp(3*ln(1-Nx)))*Eva; end; 
      'H': begin If Sli>Eva then Fmek := Sli-Eva 
                            else Fmek := 0; 
                 If Nx>Sli then Etr := Eva 
                           else Etr := Nx-Fmek*2/(1+Nx/Sli); end; 
      'N': begin Etr := 1; end; 
      END; { Case } 
      If Etr<Etrmin then Etrans := Etrmin else Etrans := Etr; 
     END;  {Etrans} 
 
   PROCEDURE ValveProp; 
      VAR Va,Cn,Cs,Jn,j,s,c,l : integer; 
          Q1,Q2,H1,H2,Qc : real; 
      BEGIN 
        For Cn := 1 to Cnmax do begin  With CnPost[Cn] do begin 
            If (Ecod=10) then begin 
               Qc := (Qt[Pfr,0]+Qt[Pto,1])/2; 
               H1 := Ht[Pto,1]; H2 := Ht[Pfr,0]; 
               Va := Vapek[Enr]; Qvt[Va] := Qc;
               H1vt[Va] := H1; H2vt[Va] := H2; end;
            end; end; 
        For Cs := 1 to Csmax do begin With CsPost[Cs] do begin 
            If Vnr>0 then begin Va := Vapek[Vnr]; 
               Qvt[Va] := Qcs; H1vt[Va] := Hf; H2vt[Va] := Hr; end; 
            end; end; 
        For Jn := 1 to Jnmax do begin With JnPost[Jn] do begin 
            For j := 1 to 4 do begin 
                If p[j]>0 then begin 
                   If Vnr[j]>0 then begin Va := Vapek[Vnr[j]]; 
                      Qvt[Va] := Qtdt[p[j],1]; H1vt[Va] := Htdt[p[j],1]; 
                      H2vt[Va] := Hjn; end; end; 
                If p[j]<0 then begin 
                   If Vnr[j]>0 then begin Va := Vapek[Vnr[j]]; 
                      Qvt[Va] := Qtdt[-p[j],0]; H1vt[Va] := Hjn; 
                      H2vt[Va] := Htdt[-p[j],0]; end; end; 
            end; end; end; 
        For s := 1 to Sumax do begin 
            For c := 1 to Lcnmax[s] do begin With LcnPost[s,c] do begin 
                If (Ecod=10) then begin 
                   Q1 := (Cpl[s,Lto]+Cml[s,Lto])/2; 
                   Q2 := (Cpl[s,Lfr]+Cml[s,Lfr])/2; Qc := (Q1+Q2)/2; 
                   H1 := Crl*(Cpl[s,Lto]-Cml[s,Lto])/2; 
                   H2 := Crl*(Cpl[s,Lfr]-Cml[s,Lfr])/2; 
                   Va := Vapek[Enr]; Qvt[Va] := Qc;
                   H1vt[Va] := H1; H2vt[Va] := H2; end;
                end; end; 
            For c := 1 to Ljnmax[s] do begin With LjnPost[s,c] do begin 
                For j := 1 to 4 do begin l := Li[j]; 
                    If l>0 then begin 
                       If Vnr[j]>0 then begin Va := Vapek[Vnr[j]]; 
                          Qvt[Va] := (Cpl[s,l]+Cml[s,l])/2; 
                          H1vt[Va] := Crl*(Cpl[s,l]-Cml[s,l])/2; 
                          H2vt[Va] := Hljn; end; end; 
                    If l<0 then begin 
                       If Vnr[j]>0 then begin Va := Vapek[Vnr[j]]; 
                          Qvt[Va] := (Cpl[s,-l]+Cml[s,-l])/2; 
                          H2vt[Va] := Crl*(Cpl[s,-l]-Cml[s,-l])/2; 
                          H1vt[Va] := Hljn; end; end; 
               end; end; end; 
            For c := 1 to Lcsmax[s] do begin With LcsPost[s,c] do begin 
                If Vnr>0 then begin Va := Vapek[Vnr]; 
                   Qvt[Va] := Qcs; H1vt[Va] := HF; H2vt[Va] := HR; end; 
            end; end; end; {For s} 
      END; { ValveProp } 
 
   PROCEDURE NewRespons(Oldset,AaSet : real); 
     VAR p,s,l : integer; 
         CpDum,CmDum,Qr,Qs : real; 
     BEGIN 
       Crl := Crl*Aaset/Oldset; 
       For p := 1 to Pimax do begin 
           Cr[p] := Cr[p]*Aaset/Oldset; 
           Rdt[p] := Rdt[p]*Oldset/Aaset;  
           Qr := Qt[p,0]; Qs := Qt[p,1]; 
           Cp[p] := Qr+Ht[p,0]/Cr[p]-RdT[p]*abs(Qr)*Qr; 
           Cm[p] := Qs-Ht[p,1]/Cr[p]-RdT[p]*abs(Qs)*Qs; end; 
       For s := 1 to Sumax do 
           For l := 1 to maxLi do begin 
               CpDum := Cpl[s,l]; CmDum := Cml[s,l]; 
               Cpl[s,l] := (CpDum+CmDum)/2+(CpDum-CmDum)*Oldset/Aaset/2; 
               Cml[s,l] := -Cpl[s,l]+CpDum+CmDum; end; 
     END;  { NewRespons } 
 
 PROCEDURE Zpump;
   VAR i,s : integer;
   BEGIN
    For i := 1 to Pumax do PrefPost[i].Zp := 0.0;
    For i := 1 to Cnmax do With CnPost[i] do
        If Ecod=11 then PrefPost[Pupek[Enr]].Zp := Elev;
    For s := 1 to Sumax do
        For i := 1 to Lcnmax[s] do With LcnPost[s,i] do
            If Ecod=11 then PrefPost[Pupek[Enr]].Zp := Elev;
   END; {Zpump}

   FUNCTION Fiavs (Va:integer; S:real) : real;
     VAR  x,F : real;
          Vr,p,i :integer;
     BEGIN
      Vr := VrefPost[Va].Vref; Vr := VaPerfPek[Vr];
      If S>1 then S := 1;
      If S<0 then S := 0;
      CASE ValvePerf[Vr].Vtyp OF 
      1: begin If S>0.218 then begin x := (S-0.218)/0.782; {PRG}
                  F := 0.024+0.2*x+0.776*exp(5*Ln(x)); end 
               else begin x := S/0.218; 
                    If (x<=0) then F := 0 else 
                       F := 0.015*x+0.009*exp(5*Ln(x)); end; end; 
      2: begin If S>0.24 then begin x := (S-0.24)/0.76;    {BAL}
                  F := 0.027+0.22*x+0.753*exp(5*Ln(x)); end 
               else begin x := S/0.24; 
                  If (x<=0) then F := 0 else 
                     F := 0.029*x-0.005*x*x+0.003*exp(6*Ln(x)); end; end; 
      3: begin F := 0.3278*S+1.8398*sqr(S)-7.9754*S*sqr(S); {BUT}
               F := F+13.9911*sqr(S)*sqr(S)-7.1838*S*sqr(S)*sqr(s); end; 
      4: begin If S>0.24 then begin x := (S-0.24)/0.76;    {GAT}
                  F := 0.24+0.96*x-0.20*sqr(x); end
               else begin x := S/0.24; F := 0.14*x+0.10*sqr(x); end; end; {GAT}
      5: begin F := S; end;     {LIN}
      6: begin Vr := VrefPost[Va].Vref; Vr := TabPek[Vr]; p := 1;
               For i := 1 to Vimax[Vr] do                  {TAB}
                   If Vsl[Vr,i]<S then p := i;
               If p>(Vimax[Vr]-1) then p := Vimax[Vr]-1;
               F := (S-Vsl[Vr,p])/(Vsl[Vr,p+1]-Vsl[Vr,p]);
               F := Vfi[Vr,p]+F*(Vfi[Vr,p+1]-Vfi[Vr,p]); end;
      END; { Case Vtyp }
      If abs(S-1)<Epsi then F := 1.000;
      If F>1 then F := 1;
      If F<0 then F := 0;
      Fiavs := F;
     END;   {Fiavs}

   FUNCTION Flf (Va:integer; S:real) : real; 
     VAR  F : real; 
          Vr,p,i : integer; 
     BEGIN 
      Vr := VrefPost[Va].Vref; Vr := VaPerfPek[Vr];
      If S>1 then S := 1;
      If S<0 then S := 0;
      CASE ValvePerf[Vr].Vtyp OF 
      1: begin F := 0.54+0.66/0.75*(1-S)-0.287*sqr((1-S)/0.75);
               If S<=0.125 then F := 0.92;
               If F>0.92 then F := 0.92;   end; {PRG}
      2: begin F := 0.54+0.66/0.75*(1-S)-0.3*sqr((1-S)/0.75);
               If S<=0.250 then F := 0.90; end; {BAL}
      3: begin F := 0.60+0.35/0.75*(1-S)-0.15*sqr((1-S)/0.75);
               If S<=0.250 then F := 0.80; end; {BUT}
      4: begin F := 0.60+0.20*(1-S)-0.10*sqr(1-S);
               If S<=0.00 then F := 0.70; end;  {GAT}
      5: begin F := 0.80;        end;           {LIN}
      6: begin Vr := VrefPost[Va].Vref; Vr := TabPek[Vr]; p := 1;
               For i := 1 to Vimax[Vr] do               {TAB}
                   If Vsl[Vr,i]<S then p := i;
               If p>(Vimax[Vr]-1) then p := Vimax[Vr]-1;
               F := (S-Vsl[Vr,p])/(Vsl[Vr,p+1]-Vsl[Vr,p]);
               F := Vfl[Vr,p]+F*(Vfl[Vr,p+1]-Vfl[Vr,p]); end;
      END; { Case Vtyp } 
      If F>1.00 then F := 1.00; 
      If F<0.54 then F := 0.54; 
      If FlYN='Y' then F := 1.00;
      Flf := F; 
     END;   {Flf} 
                      
  PROCEDURE AutoValve; 
     CONST Fh = 2.7E-3; Fdh = 2.7E-3; Fq = 0.80; Fdq = 0.80; 
           Ft = 0.015; Fdt = 0.015; Fw = 8E-7; Fdw = 8E-7; 
           Fhm = 2.7E-3;
      VAR  Vr,Va,Ve,DirVa,Man : integer; 
           Calc,dSet,Old,Sx,Sxmin,Sxmax,Csx,Qli : real; 
    BEGIN 
      For Vr := 1 to VaCtrlmax do begin With VaCtrl[Vr] do begin
          Va := Vapek[VaId]; Ve := VaPerfPek[VrefPost[Va].Vref];
          Sxmin := ValvePerf[Ve].Smin;
          Sxmax := ValvePerf[Ve].Smax;
        If PiLi='P' then 
          CASE Code OF 
           1: begin Calc := Ht[p1,i1]; Csx := Fh; end;             {H } 
           2: begin Calc := Ht[p1,i1]-Ht[p2,i2]; Csx := Fdh; end;  {DH} 
           3: begin Calc := Qt[p1,i1]; Csx := Fq; end;             {Q } 
           4: begin Calc := Qt[p1,i1]-Qt[p2,i2]; Csx := Fdq; end;  {DQ} 
           5: begin Calc := Tt[p1,i1]; Csx := Ft; end;             {T } 
           6: begin Calc := Tt[p1,i1]-Tt[p2,i2]; Csx := Fdt; end;  {DQ} 
           7: begin TempInit(Tt[p1,i1]);                           {W } 
                    Calc := Ra*Csp*abs(Qt[p1,i1]*Tt[p1,i1]);
                    TempInit(Tinit); Csx := Fw; end; 
           8: begin TempInit((Tt[p1,i1]+Tt[p2,i2])/2);             {DW} 
                   {Calc := abs(Qt[p1,i1]*Tt[p1,i1]);}
                    Calc := Qt[p1,i1]*Tt[p1,i1];
                   {Calc := Ra*Csp*(Calc-abs(Qt[p2,i2]*Tt[p2,i2]));}
                    Calc := Ra*Csp*(Calc-(Qt[p2,i2]*Tt[p2,i2]));
                    TempInit(Tinit); Csx := Fdw; end; 
           9: begin Calc := (Ht[p1,i1]+Ht[p2,i2])/2;               {HM}
                    Csx := Fhm; end;
          END; {case code} 
       If PiLi='L' then 
          CASE Code OF
           1: begin Calc := Crl*(Cpl[p1,i1]-Cml[p1,i1])/2;         {H}
                    Csx := Fh; end;
           2: begin Calc := Crl*(Cpl[p1,i1]-Cml[p1,i1])/2;         {dH}
                    Calc := Calc-Crl*(Cpl[p2,i2]-Cml[p2,i2])/2;
                    Csx := Fdh; end;           
           3: begin Calc := (Cpl[p1,i1]+Cml[p1,i1])/2;             {Q}
                    Csx := Fq; end;
           4: begin Calc := (Cpl[p1,i1]+Cml[p1,i1])/2;             {dQ}
                    Calc := Calc-(Cpl[p2,i2]+Cml[p2,i2])/2;           
                    Csx := Fdq; end;                 
           5: begin Calc := Tli[p1,i1]; Csx := Ft; end;            {T} 
           6: begin Calc := Tli[p1,i1]-Tli[p2,i2];                 {dT}
                    Csx := Fdt; end; {DT} 
           7: begin Qli := (Cpl[p1,i1]+Cml[p1,i1])/2;              {W}
                    TempInit(Tli[p1,i1]);
                    Calc := Ra*Csp*abs(Qli*Tli[p1,i1]); 
                    TempInit(Tinit); Csx := Fw; end; 
           8: begin Qli := (Cpl[p1,i1]+Cml[p1,i1])/2;              {DW} 
                    TempInit((Tli[p1,i1]+Tli[p2,i2])/2);
                    Calc := Qli*Tli[p1,i1]; 
                    {Calc := abs(Qli*Tli[p1,i1]);} 
                    Qli := (Cpl[p2,i2]+Cml[p2,i2])/2; 
                    Calc := Ra*Csp*(Calc-(Qli*Tli[p2,i2])); 
                    {Calc := Ra*Csp*(Calc-abs(Qli*Tli[p2,i2]));} 
                    TempInit(Tinit); Csx := Fdw; end; 
           9: begin Calc := Crl*(Cpl[p1,i1]-Cml[p1,i1])/2;         {HM}
                    Calc := (Calc+Crl*(Cpl[p2,i2]-Cml[p2,i2])/2)/2;
                    Csx := Fhm; end;  
          END; {case code} 
          dSet := Setvalue-Calc; Csx := Fctrl* Csx;
          If ((dSet*dSetold)<0) then dSet := 2*dSet/3; 
          dSetold := dSet; 
          CASE Dir OF 
          'I': begin Man := +1; end; 
          'D': begin Man := -1; end; 
          END; 
          If dSet>0 then DirVa := Man else DirVa := -Man; 
          dSet := abs(dSet); 
          Old := VrefPost[Va].S;  
          If M>100 then Csx := (1000-M)/1000*Csx; 
          Sx := Old+DirVa*dSet*Csx; 
          If Sx<Sxmin then Sx := Sxmin; 
          If Sx>Sxmax then Sx := Sxmax; 
          VrefPost[Va].Fi := FiavS(Va,Sx); VrefPost[Va].Fl := Flf(Va,Sx);
          VrefPost[Va].S := Sx;
{writeln('M= ':4,M:1,'dSet= ':8,(Setvalue-Calc):8:3,'Fi= ':8,VrefPost[Va].Fi:4:3,Alf:6:2);} 
        end; end;
    END;   { AutoValve} 
 
PROCEDURE AutoDrive; 
   CONST Fh = 1.5; Fdh = 1.5; Fq = 500; Fdq = 500;
         Ft = 8; Fdt = 8; Fw = 0.0010; Fdw = 0.0010; 
         Fhm = 1.5; 
    VAR  Dr,De,DirDr,Man,i,Did : integer; 
         Calc,dSet,Old,Ndx,Ndrmin,Ndrmax,Cndr,Qli : real; 
   BEGIN  
      For Dr := 1 to DrCtrlmax do begin With DrCtrl[Dr] do begin
          De := Drpek[DrId]; Ndrmin := 10.0;
          Ndrmax := DrivePost[De].Nmot*DrivePost[De].Nmax;  
        If PiLi='P' then
           CASE Code OF 
           1: begin Calc := Ht[p1,i1]; Cndr := Fh; end;            {H } 
           2: begin Calc := Ht[p1,i1]-Ht[p2,i2]; Cndr := Fdh; end; {DH} 
           3: begin Calc := Qt[p1,i1]; Cndr := Fq; end;            {Q } 
           4: begin Calc := Qt[p1,i1]-Qt[p2,i2]; Cndr := Fdq; end; {DQ} 
           5: begin Calc := Tt[p1,i1]; Cndr := Ft; end;            {T } 
           6: begin Calc := Tt[p1,i1]-Tt[p2,i2]; Cndr := Fdt; end; {DT} 
           7: begin TempInit(Tt[p1,i1]);                           {W } 
                    Calc := Ra*Csp*abs(Qt[p1,i1]*Tt[p1,i1]); 
                    TempInit(Tinit); Cndr := Fw; end; 
           8: begin TempInit((Tt[p1,i1]+Tt[p2,i2])/2);             {DW} 
                    {Calc := abs(Qt[p1,i1]*Tt[p1,i1]);}
                    Calc := Qt[p1,i1]*Tt[p1,i1];
                    {Calc := Ra*Csp*(Calc-abs(Qt[p2,i2]*Tt[p2,i2]));}
                    Calc := Ra*Csp*(Calc-(Qt[p2,i2]*Tt[p2,i2]));
                    TempInit(Tinit); Cndr := Fdw; end; 
           9: begin Calc := (Ht[p1,i1]+Ht[p2,i2])/2;               {HM}
                    Cndr := Fhm; end;  
           END; {case code}
       If PiLi='L' then   {s1-p1,l1-i1,s2-p2,l2-i2}
          CASE Code OF
           1: begin Calc := Crl*(Cpl[p1,i1]-Cml[p1,i1])/2;         {H}
                    Cndr := Fh; end;
           2: begin Calc := Crl*(Cpl[p1,i1]-Cml[p1,i1])/2;         {dH}
                    Calc := Calc-Crl*(Cpl[p2,i2]-Cml[p2,i2])/2;
                    Cndr := Fdh; end;           
           3: begin Calc := (Cpl[p1,i1]+Cml[p1,i1])/2;             {Q}
                    Cndr := Fq; end;
           4: begin Calc := (Cpl[p1,i1]+Cml[p1,i1])/2;             {dQ}
                    Calc := Calc-(Cpl[p2,i2]+Cml[p2,i2])/2;           
                    Cndr := Fdq; end;                 
           5: begin Calc := Tli[p1,i1]; Cndr := Ft; end;           {T} 
           6: begin Calc := Tli[p1,i1]-Tli[p2,i2];                 {dT}
                    Cndr := Fdt; end; {DT} 
           7: begin Qli := (Cpl[p1,i1]+Cml[p1,i1])/2;              {W}
                    TempInit(Tli[p1,i1]);
                    Calc := Ra*Csp*abs(Qli*Tli[p1,i1]); 
                    TempInit(Tinit); Cndr := Fw; end; 
           8: begin Qli := (Cpl[p1,i1]+Cml[p1,i1])/2;              {DW} 
                    TempInit((Tli[p1,i1]+Tli[p2,i2])/2);
                    {Calc := abs(Qli*Tli[p1,i1]);} 
                    Calc := Qli*Tli[p1,i1]; 
                    Qli := (Cpl[p2,i2]+Cml[p2,i2])/2; 
                    {Calc := Ra*Csp*(Calc-abs(Qli*Tli[p2,i2]));} 
                    Calc := Ra*Csp*(Calc-(Qli*Tli[p2,i2])); 
                    TempInit(Tinit); Cndr := Fdw; end; 
           9: begin Calc := Crl*(Cpl[p1,i1]-Cml[p1,i1])/2;         {HM}
                    Calc := (Calc+Crl*(Cpl[p2,i2]-Cml[p2,i2])/2)/2;
                    Cndr := Fhm; end;       
          END; {case code} 
          dSet := Setvalue-Calc; Cndr := Fctrl*Cndr;
          If ((dSet*dSetold)<0) then dSet := 2*dSet/3; 
          dSetold := dSet; 
          CASE Dir OF 
          'I': begin Man := +1; end; 
          'D': begin Man := -1; end; 
          END; 
          If dSet>0 then DirDr := Man else DirDr := -Man; 
          dSet := abs(dSet); 
          Old := DrivePost[De].Ndr;  
          If M>100 then Cndr := (1000-M)/1000*Cndr; 
          Ndx := Old+DirDr*dSet*Cndr; 
          If Ndx<Ndrmin then Ndx := Ndrmin; 
          If Ndx>Ndrmax then Ndx := Ndrmax; 
          DrivePost[De].Ndr := Ndx; 
{writeln('M= ':4,M:1,'Calc= ':8,Calc:10:3,'Ndr= ':8,Ndx:5:1);}
       end; end; 
       For i := 1 to Pumax do begin  
           Did := PrefPost[i].DrId; 
           PrefPost[i].Np := DrivePost[Drpek[Did]].Ndr; end; 
   END;  {AutoDrive} 
 
    FUNCTION Lamda (V,Ny,D,Ks:real) : real;
      VAR  X1,Re {Xo,k1,k2} : real;
      BEGIN
        Re := abs(V)*D/Ny; If Re<Remin  then Re := Remin;
        If Re<2300 then Lamda := 64/Re
           else begin X1 := -1.8*ln(6.9/Re+exp(1.11*ln(Ks/D/3.7)))/ln(10);

     {                k1 := 2.51/Re; k2 := Ks/D/3.71;
                      X1 := 7; Xo := 0;
           REPEAT  Iter := Iter+1;
             Xo := X1; X1 := Xo+2*ln(k1*Xo+k2)/ln(10);
             X1 := Xo-X1/(1+2*k1/ln(10)/(k1*Xo+k2));
           UNTIL (abs(X1-Xo)<0.00001);      }

           If Re<4000 then Lamda := 0.0278+(1/X1/X1-0.0278)*(Re-2300)/1700
                      else Lamda := 1/X1/X1; end;
      END;   { Lamda }

  PROCEDURE Initiate(Qinit,Hinit,Tinit,AaStart,LaStart : real);
   VAR  i,s,l : integer;
   BEGIN
        TempInit(Tinit); AaSet := AaStart; Crl := AaSet;  
        ManVaCtrl := Mctrl; ManDrCtrl := Mctrl;
        For i := 1 to Pimax do begin With PipePost[i] do begin 
            Cr[i] := Aaset/g/Api[i]; 
            Rdt[i] := (LaStart*L/D+Zeta)/Api[i]/Aaset/2; 
            Ht[i,0] := Hinit; Ht[i,1] := Hinit;  
            Qt[i,0] := Qinit; Qt[i,1] := Qinit;  
            Tt[i,0] := Tinit; Tt[i,1] := Tinit; end; end; 
        For i := 1 to Iomax do With IoPost[i] do 
            If QP='P' then Hbound := Value*1E05/Density(Temp)/g+Elev
                      else Hbound := 0;
        For i := 1 to Cnmax do With CnPost[i] do
            If Ecod=2 then Hconn := Value*1E05/Ra/g+Elev
                      else Hconn := 0;
        For i := 1 to Jnmax do begin 
            JnPost[i].Hjn := Hinit; JnPost[i].Tjn := Tinit; end; 
        For i := 1 to Csmax do begin With CsPost[i] do begin
            Hf := Hinit; Hr := Hinit; Qcs := Qinit;
            Tf := Tinit; Tr := Tinit; RaCsp := Ra*Csp; end; end;
        For i := 1 to Pumax do begin Tpt[i] := Tinit;
            H1pt[i] := Hinit; Qpt[i] := Qinit; end;
        For i := 1 to Vamax do begin
            VrefPost[i].Fi := Fiavs(i,VrefPost[i].S); 
            VrefPost[i].Fl := Flf(i,VrefPost[i].S);
            H1vt[i] := Hinit; H2vt[i] := Hinit; Qvt[i] := Qinit; Tvt[i] := Tinit;
            VrefPost[i].Hch := 0.96*Hvap-Hatm+VrefPost[i].Zv; end;
        For i := 1 to Boilmax do begin With Boiler[i] do begin
            Qbt := Qinit; RaCsp := Ra*Csp; Avres := Avboil+Avbp;
            Tb := Tinit; Tp := Tinit; end; end;
        For s := 1 to Sumax do begin 
            For i := 1 to Liomax[s] do With LioPost[s,i] do
                If QP='P' then Hbound := Value*1E05/Density(Temp)/g+Elev
                          else Hbound := 0;
            For i := 1 to Lcnmax[s] do With LcnPost[s,i] do
                If Ecod=2 then Hconn := Value*1E05/Ra/g+Elev
                            else Hconn := 0;
            For i := 1 to Ljnmax[s] do begin 
                LjnPost[s,i].Hljn := Hinit; LjnPost[s,i].Tljn := Tinit; end; 
            For i := 1 to Lcsmax[s] do begin With LcsPost[s,i] do begin
                Hf := Hinit; Hr := Hinit; Qcs := Qinit;
                Tf := Tinit; Tr := Tinit; RaCsp := Ra*Csp; end; end;
            For i := 1 to Limax[s] do begin l := Lipek[s,i]; 
                Cpl[s,l] := Hinit/Crl; Cml[s,l] := -Hinit/Crl; 
                Tli[s,l] := Tinit; end; end; 
        ConvFlag := false;
    END; {Initiate}

    PROCEDURE CheckSystem;
       VAR i,j,Nr,Pi,Pid,s,b,Bid,c,L,Pbe,Vsum,Psum,Bsum,
           CsLosum,LcsLosum,Asum,Vr,Pr,Pu,V,Io,Lio,Znr,z : integer;
           SetCheck : array[1..99] of integer;
           Picheck,Pbeg,Pend : array[1..maxPi] of integer;
           Lbeg,Lend : array[1..99] of integer;
           Vacheck : array[1..maxVa] of integer;
           Pucheck : array[1..maxPu] of integer;
           Bocheck : array[1..maxBoil] of integer;
           ErrorFlag,EnrFlag,AvFlag : Boolean;
       BEGIN
        ErrorFlag := false; Pbe := 0; Vsum := 0; Psum := 0;
        Bsum := 0; CsLosum := 0; LcsLosum := 0; Asum := 0;
        For i := 1 to Vamax do Vacheck[i] := 0;
        For i := 1 to Pumax do Pucheck[i] := 0;
        For i := 1 to Boilmax do Bocheck[i] := 0;
        For i := 1 to Pimax do Picheck[i] := 0;
        For i := 1 to Pimax do begin
            Pid := PipePost[i].Id; Pi := Pipek[Pid]; 
            If Picheck[Pi]>0 then begin write('Pipe':11);
               write(IdS2(Pid div 100):4,NrS2(Pid mod 100):2);
               writeln('Identification Error!':27); ErrorFlag := true; end
            else Picheck[Pi] := 1; end;    
        For i := 1 to Pimax do begin
            Pbeg[i] := 0; Pend[i] := 0; end;
        For Io := 1 to Iomax do begin With IoPost[Io] do begin
            If ((BE='I') or (BE='T')) then begin
                 Pbeg[Pi] := Pbeg[Pi]+1; Pbe := Pbe+1; end;
            If ((BE='O') or (BE='F')) then begin
                 Pend[Pi] := Pend[Pi]+1; Pbe := Pbe+1; end;
            end; end;
        For i := 1 to Exmax do begin With ExPost[i] do begin
            Pend[pTo] := Pend[pTo]+1; Pbe := Pbe+1;
            Pbeg[pFr] := Pbeg[pFr]+1; Pbe := Pbe+1;
            Pend[sTo] := Pend[sTo]+1; Pbe := Pbe+1;
            Pbeg[sFr] := Pbeg[sFr]+1; Pbe := Pbe+1; end; end;
        For i := 1 to Cnmax do begin With CnPost[i] do begin
            Pend[Pto] := Pend[Pto]+1; Pbe := Pbe+1;
            Pbeg[Pfr] := Pbeg[Pfr]+1; Pbe := Pbe+1; end; end;
        For i := 1 to Jnmax do begin With JnPost[i] do begin
            For j := 1 to 4 do begin Pi := P[j];
                If Pi>0 then begin
                        Pend[Pi] := Pend[Pi]+1; Pbe := Pbe+1; end;
                If Pi<0 then begin
                        Pbeg[-Pi] := Pbeg[-Pi]+1; Pbe := Pbe+1; end;
                If Vnr[j]>0 then begin Vsum := Vsum+1;
                   If (Vapek[Vnr[j]]=0) or (P[j]=0) then begin
                      ErrorFlag := true; write('Valve':11);
                      write(IdS2(Vnr[j] div 100):4,NrS2(Vnr[j] mod 100):2);
                      writeln('Identification Error':27);  end
                   else Vacheck[Vapek[Vnr[j]]] := Vacheck[Vapek[Vnr[j]]]+1; end;
            end; end; end;
        For i := 1 to Csmax do begin With CsPost[i] do begin
            If Vnr>0 then begin Vsum := Vsum+1;
               If Vapek[Vnr]=0 then begin ErrorFlag := true;
                  Znr := Vnr div 100; Nr := Vnr mod 100;
                  write('Valve':11,IdS2(Znr):4,NrS2(Nr):2);
                      writeln('Identification Error':30);  end
               else Vacheck[Vapek[Vnr]] := Vacheck[Vapek[Vnr]]+1; end;
            For j := 1 to 8 do begin Pi := p[j];
                 If Pi>0 then begin
                         Pend[Pi] := Pend[Pi]+1; Pbe := Pbe+1; end;
                 If Pi<0 then begin
                         Pbeg[-Pi] := Pbeg[-Pi]+1; Pbe := Pbe+1; end;
            end; end; end;
        For i := 1 to Sumax do begin
            For j := 1 to Brmax[i] do begin Pi := BorPost[i,j].Pi;
                If Pi>0 then begin
                        Pend[Pi] := Pend[Pi]+1; Pbe := Pbe+1; end;
                If Pi<0 then begin
                        Pbeg[-Pi] := Pbeg[-Pi]+1; Pbe := Pbe+1; end;
            end; end;
        For i := 1 to CloseMax do Pend[SelPipe[i]] := 1;
        For i := 1 to Pimax do begin
            If (Pbeg[i]<>1) or (Pend[i]<>1) then begin
               With PipePost[i] do begin
               write('Pipe':11,IdS2(Id div 100):4,NrS2(Id mod 100):2);
               writeln('Joint Error!':19);
               ErrorFlag := true;  end; end; end;
        If (Pbe<>2*Pimax) then begin writeln;
           writeln('Pipe Summary Error!':25);  end;
        For z := 1 to Zonmax do begin Znr := ZonId[z];
            For i := 1 to 99 do SetCheck[i] := 0;
            For i := 1 to Cnmax do begin
                If ((CnPost[i].Id div 100)=Znr) then begin 
                   Nr := CnPost[i].Id mod 100;
                   If (SetCheck[Nr]>0) then begin
                      write('Conn ':10,IdS2(Znr):4,NrS2(Nr):3);
                      writeln('Identification Error!':25);
                      ErrorFlag := true;  end
                   else SetCheck[Nr] := 1; end;
        end; end;
        For z := 1 to Zonmax  do begin Znr := ZonId[z];
            For i := 1 to 99 do SetCheck[i] := 0;
            For i := 1 to Jnmax do begin
                If ((JnPost[i].Id div 100)=Znr) then begin 
		   Nr := JnPost[i].Id mod 100;
                   If (SetCheck[Nr]>0) then begin
                      write('Junc ':10,IdS2(Znr):4,NrS2(Nr):3);
                      writeln('Identification Error!':25);
                      ErrorFlag := true;  end
                   else SetCheck[Nr] := 1; end;
        end; end;
        For z := 1 to Zonmax do begin Znr := ZonId[z]; 
            For i := 1 to 99 do SetCheck[i] := 0;
            For i := 1 to Csmax do begin
                If ((CsPost[i].Id div 100)=Znr) then begin 
                   Nr := CsPost[i].Id mod 100;
                   If (SetCheck[Nr]>0) then begin
                      write('Cross':10,IdS2(Znr):4,NrS2(Nr):3);
                      writeln('Identification Error!':25);
                      ErrorFlag := true;  end
                   else SetCheck[Nr] := 1; end;
        end; end;
        For z := 1 to Zonmax do begin Znr := ZonId[z];
            For i := 1 to 99 do SetCheck[i] := 0;
            For i := 1 to Exmax do begin
                If ((ExPost[i].Id div 100)=Znr) then begin
                   Nr := ExPost[i].Id mod 100;
                   If (SetCheck[Nr]>0) then begin
                      write('HeatEx':10,IdS2(Znr):4,NrS2(Nr):3);
                      writeln('Identification Error!':25);
                      ErrorFlag := true;  end
                   else SetCheck[Nr] := 1; end;
        end; end;
        For s := 1 to Sumax do begin
            For i := 1 to 99 do SetCheck[i] := 0;
            For i := 1 to Lcnmax[s] do begin
                If (SetCheck[LcnPost[s,i].Id]>0) then begin
                   Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                   write('Lconn':12,IdS2(Znr):4,Nr:1,NrS2(LcnPost[s,i].Id):3);
                   writeln('Identification Error!':25);
                   ErrorFlag := true;  end
                else SetCheck[LcnPost[s,i].Id] := 1; end; end;
        For s := 1 to Sumax do begin
            For i := 1 to 99 do SetCheck[i] := 0;
            For i := 1 to Ljnmax[s] do begin
                If (SetCheck[LjnPost[s,i].Id]>0) then begin
                   Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                   write('Ljunc':12,IdS2(Znr):4,Nr:1,NrS2(LjnPost[s,i].Id):3);
                   writeln('Identification Error!':25);
                   ErrorFlag := true;  end
                else SetCheck[LjnPost[s,i].Id] := 1; end; end;
        For s := 1 to Sumax do begin
            For i := 1 to 99 do SetCheck[i] := 0;
            For i := 1 to Lcsmax[s] do begin
                If (SetCheck[LcsPost[s,i].Id]>0) then begin
                   Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                   write('Lcross':12,IdS2(Znr):4,Nr:1,NrS2(LcsPost[s,i].Id):3);
                   writeln('Identification Error!':25);
                   ErrorFlag := true;  end
                else SetCheck[LcsPost[s,i].Id] := 1; end; end;
        For s := 1 to Sumax do begin
            For i := 1 to 99 do SetCheck[i] := 0;
            For i := 1 to Lexmax[s] do begin
                If (SetCheck[LexPost[s,i].eNr]>0) then begin
                   Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                   write('Lheatex ':12,IdS2(Znr):4,Nr:1,NrS2(LexPost[s,i].eNr):3);
                   writeln('Identification Error!':25);
                   ErrorFlag := true;  end
                else SetCheck[LexPost[s,i].eNr] := 1; end; end;
        For i := 1 to maxCheck do
            If (CheckPost[i].W=0) then begin
               Znr := CheckPost[i].Id div 100;
               Nr := CheckPost[i].Id mod 100;
               write('Pipe':12,IdS2(Znr):4,NrS2(Nr):2);
               writeln('Screen Output Identifikation Error!':38);
               ErrorFlag := true;  end;
        For z := 1 to Zonmax do begin Znr := ZonId[z];
            For i := 1 to 99 do SetCheck[i] := 0;
            For i := 1 to Boilmax do begin
                If ((Boiler[i].Id div 100)=Znr) then begin 
                   Nr := Boiler[i].Id mod 100;
                   If (SetCheck[Nr]>0) then begin
                      write('Boiler':10,IdS2(Znr):4,NrS2(Nr):2);
                      writeln('Identification Error!':25);
                      ErrorFlag := true;  end
                   else SetCheck[Nr] := 1; end;
        end; end;
        For i := 1 to AlarmMax do begin Pid := AlarmPost[i].Id;
            If (Pipek[Pid]=0) then begin
               Znr := Pid div 100; Nr := Pid mod 100;
               write('Pipe':12,IdS2(Znr):4,NrS2(Nr):2);
               writeln('Alarm Identification Error!':30);
               ErrorFlag := true;  end; end;
        For s := 1 to Sumax do
            For b := 1 to Brmax[s] do
            If (BorPost[s,b].Pi=0) then begin
               Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
               Bid := BorPost[s,b].Id mod 100;
               write('Border':12,IdS2(Znr):4,Nr:1,NrS2(Bid):3);
               writeln('Pipe Identification Error!':30);
               ErrorFlag := true;  end;
        For s := 1 to Sumax do begin
            For i := 1 to Limax[s] do begin
                L := Lipek[s,i]; Lbeg[L] := 0; Lend[L] := 0; end;
            For Lio := 1 to Liomax[s] do begin
                With Liopost[s,Lio] do begin
                If ((BE='I') or (BE='T')) then Lbeg[Li] := Lbeg[Li]+1;
                If ((BE='O') or (BE='F')) then Lend[Li] := Lend[Li]+1;
                end; end;
            For i := 1 to Lexmax[s] do begin
                With LexPost[s,i] do begin
                If pTo>0 then Lend[pTo] := Lend[pTo]+1;
                If pFr>0 then Lbeg[pFr] := Lbeg[pFr]+1;
                If sTo>0 then Lend[sTo] := Lend[sTo]+1;
                If sFr>0 then Lbeg[sFr] := Lbeg[sFr]+1; end; end;
            For b := 1 to Brmax[s] do begin L := BorPost[s,b].Li;
                If L>0 then Lend[L] := Lend[L]+1;
                If L<0 then Lbeg[-L] := Lbeg[-L]+1; end;
            For c := 1 to Lcnmax[s] do begin
                With LcnPost[s,c] do begin
                If Lto>0 then Lend[Lto] := Lend[Lto]+1;
                If Lfr>0 then Lbeg[Lfr] := Lbeg[Lfr]+1; end; end;
            For j := 1 to Ljnmax[s] do begin
                With LjnPost[s,j] do begin
                For i := 1 to 4 do begin L := Li[i];
                    If L>0 then Lend[L] := Lend[L]+1;
                    If L<0 then Lbeg[-L] := Lbeg[-L]+1; end; end; end;
            For c := 1 to Lcsmax[s] do begin
                With LcsPost[s,c] do begin
                For i := 1 to 8 do begin L := Li[i];
                    If L>0 then Lend[L] := Lend[L]+1;
                    If L<0 then Lbeg[-L] := Lbeg[-L]+1; end; end; end;
            For i := 1 to Limax[s] do begin L := Lipek[s,i];
                   If (Lbeg[L]<>1) or (Lend[L]<>1) then begin
                       Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                       write('Subnet':10,IdS2(Znr):4,Nr:1,'Link':6,NrS2(L):3);
                       writeln('Joint Error!':25);
                       ErrorFlag := true;  end; end;
        end;
        For z := 1 to Zonmax do begin Znr := ZonId[z];
            For i := 1 to 99 do SetCheck[i] := 0;
            For i := 1 to Vamax do begin
                If ((VrefPost[i].Id div 100)=Znr) then begin 
                   Nr := VrefPost[i].Id mod 100;
                   If (SetCheck[Nr]>0) then begin
                      write('Valve ':10,IdS2(Znr):4,NrS2(Nr):2);
                      writeln('Identification Error!':25);
                      ErrorFlag := true;  end
                   else SetCheck[Nr] := 1; end;
        end; end;
        For z := 1 to Zonmax do begin Znr := ZonId[Znr];
            For i := 1 to 99 do SetCheck[i] := 0;
            For i := 1 to Pumax do begin
                If ((PrefPost[i].Id div 100)=Znr) then begin 
                   Nr := PrefPost[i].Id mod 100;
                   If (SetCheck[Nr]>0) then begin
                      write('Pump ':10,IdS2(Znr):4,NrS2(Nr):2);
                      writeln('Identification Error!':25);
                      ErrorFlag := true;  end
                   else SetCheck[Nr] := 1; end;
        end; end;
        For i := 1 to Cnmax do begin With CnPost[i] do begin
            Znr := Id div 100; Nr := Id mod 100;
            EnrFlag := false; AvFlag := false;
            CASE Ecod OF
  1,2,3,6,7,8 : begin end;
        4,5,9 : begin end;
           10 : If Enr>0 then begin Vsum := Vsum+1;
                   If Vapek[Enr]=0 then EnrFlag := true else
                      Vacheck[Vapek[Enr]] := Vacheck[Vapek[Enr]]+1; end;
           11 : If Enr>0 then begin Psum := Psum+1;
                   If Pupek[Enr]=0 then EnrFlag := true
                      else begin Pu := Pupek[Enr];
                           Pucheck[Pu] := Pucheck[Pu]+1; end; end;
           12 : If Enr>0 then begin Bsum := Bsum+1;
                   Bocheck[Enr] := Bocheck[Enr]+1; end;
           13,14 : If Enr>0 then Asum := Asum+1;
            END;
            CASE Ecod OF
              1,2,3,4,5,6,7,8 : If (Enr<>0) then EnrFlag := true;
            9,10,11,12,13,14  : If (Enr<=0) then EnrFlag := true;
            END;
            If EnrFlag then begin
                   write('Conn ':10,IdS2(Znr):4,NrS2(Nr):4);
                   writeln('Equipment Nr, Error!':25);
                   ErrorFlag := true;  end;
            CASE Ecod OF
             1,2,3,4,5,6,9,10,11,12,13,14 : begin end;
             7,8 : If (Value<0) then AvFlag := true;
            END;
            If AvFlag then begin
                   write('Conn ':10,IdS2(Znr):4,NrS2(Nr):4);
                   writeln('Av-value, Error!':25);
                   ErrorFlag := true;  end; end; end;
        For s := 1 to Sumax do begin
            For i := 1 to Lcnmax[s] do begin
                Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                With LcnPost[s,i] do begin
                If (Lto<1) or (Lfr<1) then begin
                   write('Subnet':10,IdS2(Znr):4,Nr:1,'Lconn ':8,NrS2(Id):3);
                   writeln('Link Error!':15);  end;
                EnrFlag := false; AvFlag := false;
                CASE Ecod OF
1,2,3,4,5,6,7,8,9 : begin end;
               10 : If Enr>0 then begin Vsum := Vsum+1;
                       If Vapek[Enr]=0 then EnrFlag := true else
                          Vacheck[Vapek[Enr]] := Vacheck[Vapek[Enr]]+1; end;
               11 : If Enr>0 then begin Psum := Psum+1;
                       If Pupek[Enr]=0 then EnrFlag := true
                          else begin Pu := Pupek[Enr];
                               Pucheck[Pu] := Pucheck[Pu]+1; end; end;
               12 : If Enr>0 then begin Bsum := Bsum+1;
                       Bocheck[Enr] := Bocheck[Enr]+1; end;
         13,14 : If Enr>0 then Asum := Asum+1;
                END;
                CASE Ecod OF
  1,2,3,4,5,6,7,8 : If (Enr<>0) then EnrFlag := true;
 9,10,11,12,13,14 : If (Enr<=0) then EnrFlag := true;
                END;
                If EnrFlag then begin
                       write('Subnet':10,IdS2(Znr):4,Nr:1,'Lconn':6,NrS2(Id):3);
                       writeln('Equipment Nr, Error!':25);
                       ErrorFlag := true;  end;
                CASE Ecod OF
1,2,3,4,5,6,9,10,11,12,13,14 : begin end;
                         7,8 : If (Value<0) then AvFlag := true;
                END;
                If AvFlag then begin
                       write('Subnet':10,IdS2(Znr):4,Nr:1,'Lconn':6,NrS2(Id):3);
                       writeln('Av-value, Error!':25);
                       ErrorFlag := true;  end; end; end; end;
        For s := 1 to Sumax do begin
            For i := 1 to Lcsmax[s] do begin EnrFlag := false;
                Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                With LcsPost[s,i] do begin
                If Vnr=0 then LcsLosum := LcsLosum+1;
                If Vnr>0 then begin Vsum := Vsum+1;
                   If Vapek[Vnr]=0 then EnrFlag := true else
                      Vacheck[Vapek[Vnr]] := Vacheck[Vapek[Vnr]]+1; end;
                If EnrFlag then begin
                   write('Subnet':10,IdS2(Znr):4,Nr:1,'Lcross':7,NrS2(Id):3);
                   writeln('Valve Nr, Error!':21);
                   ErrorFlag := true;  end;
                If ((Vnr=0) and (Pload<0)) or ((Vnr>0) and (Pload>0))
                   then begin
                        write('Subnet':10,IdS2(Znr):4,Nr:1,'Lcross':7,NrS2(Id):3);
                        writeln('Pload, Error!':20);
                        ErrorFlag := true;  end;
            end; end; end;
        For s := 1 to Sumax do begin
            For i := 1 to Ljnmax[s] do begin EnrFlag := false;
                Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                With LjnPost[s,i] do begin
                For j := 1 to 4 do begin V := Vnr[j];
                    If V>0 then begin Vsum := Vsum+1;
                       If (Vapek[V]=0) or (Li[j]=0) then EnrFlag := true
                       else Vacheck[Vapek[V]] := Vacheck[Vapek[V]]+1; end;
                end;
                If EnrFlag then begin
                   write('Subnet':10,IdS2(Znr):4,Nr:1,'Ljunc':6,NrS2(Id):3);
                   writeln('Valve Nr, Error!':21);
                   ErrorFlag := true;  end;
            end; end; end;
        For i := 1 to Csmax do begin With CsPost[i] do begin
            If Vnr=0 then CsLosum := CsLosum+1;
            If ((Vnr=0) and (Pload<0)) or ((Vnr>0) and (Pload>0))
               then begin
                    Znr := Id div 100; Nr := Id mod 100;
                    writeln; write('Cross':10,IdS2(Znr):4,NrS2(Nr):3);
                    writeln('Pload, Error!':20); ErrorFlag := true;
                     end; end; end;
        For i := 1 to Vamax do
            If Vacheck[i]<>1 then begin
               Vr := VrefPost[i].Id; Znr := Vr div 100;
               Nr := Vr mod 100; write('Valve':11,IdS2(Znr):4);
               writeln(NrS2(Nr):2,'Identification Error!':28);
               ErrorFlag := true;  end;
        For i := 1 to Vperfmax do begin With ValvePerf[i] do begin
            If (Avp<=0) or (Avm<=0) then begin
               writeln('Valve Ref':14,NrS2(Vref):3,'Performance Error!':23);
               ErrorFlag := true;  end; end; end;
        For i := 1 to Pumax do
            If Pucheck[i]<>1 then begin
               Pr := PrefPost[i].Id; Znr := Pr div 100;
               Nr := Pr mod 100;
               writeln('Pump ':11,IdS2(Znr):4,NrS2(Nr):2,'Identification Error!':30);
               ErrorFlag := true;  end;
        For i := 1 to Pumax do
            If Drpek[PrefPost[i].DrId]=0 then begin
               Pr := PrefPost[i].Id; Znr := Pr div 100;
               Nr := Pr mod 100; writeln;
               writeln('Pump ':11,IdS2(Znr):4,NrS2(Nr):2,'Drive Reference Error!':31);
               ErrorFlag := true;  end;
        For i := 1 to Boilmax do begin With Boiler[i] do begin
            Znr := Id div 100; Nr := Id mod 100;
            If Bocheck[i]<>1 then begin
               writeln('Boiler':10,IdS2(Znr):4,NrS2(Nr):2,'Identification Error!':30);
               ErrorFlag := true;  end;
            If (Wmax*(Tboil-Tpipe))<0 then begin
               writeln('Boiler':10,IdS2(Znr):4,NrS2(Nr):2,'Unrealistic Data!':30);
               ErrorFlag := true;  end; end; end;
        If Vsum<>Vamax then begin
           writeln('Valve Summary, File Error!':32);
           ErrorFlag := true;  end;
        If Psum<>Pumax then begin
           writeln('Pump Summary, File Error!':31);
           ErrorFlag := true;  end;
        If Bsum<>Boilmax then begin
           writeln('Boiler Summary, File Error!':32);
           ErrorFlag := true;  end;
        If CsLosum<>LoadCsmax then begin
           writeln('Pipe Cross Load Summary, File Error!':41);
           ErrorFlag := true;  end;
        If LcsLosum<>LoadLcsmax then begin
           writeln('Link Cross Load Summary, File Error!':41);
           ErrorFlag := true;  end;
        If Asum<> Acmax then begin
           writeln('Accumulator Summary, File Error!':37);
           ErrorFlag := true;  end;
        If ErrorFlag then Gerror;
        Stop;
       END;  { CheckSystem }

   PROCEDURE Config; 
     VAR  i,s,l,Znr : integer;
          ch : char;
          Subcheck : array[1..maxSid] of integer;
          Cspek : array[1..maxId] of integer; 
          LcsPek : array[1..maxSu,1..99] of integer; 
          ErrorFlag : boolean; 
 
     PROCEDURE Idstrings; 
       VAR i,j,k : integer; 
       BEGIN 
        For i := 1 to maxIdstr do 
            For k := 1 to maxIdch do IdStr[i,k] := ' ';
        readln(f); Red; read(f,ch); i := 0; 
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
        WHILE ch=' ' do begin j := 1; i := i+1; 
          REPEAT read(f,Idstr[i,j]); UNTIL (Idstr[i,j]<>' '); 
          WHILE ((not eoln(f)) and (j<maxIdch)) do begin 
                j := j+1; read(f,Idstr[i,j]); end; 
          readln(f); Red; read(f,ch); end; 
        Idstrmax := i; 
       END;    {Idstrings} 
 
     PROCEDURE Miscdata; 
       BEGIN 
        readln(f); Red; read(f,ch); 
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
        WHILE ch=' ' do begin  
          readln(f,Patm,Hinit,Tinit,Tsur,Kfac); Red;
          read(f,ch) end;
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
        WHILE ch=' ' do begin  
          readln(f,Htol,Qtol,Ftol,Itermax,Step,AaStart,Aaresp,Remin); Red; 
          read(f,ch); end; 
       END; {Miscdata} 
 
     PROCEDURE Liqdata; 
       VAR i : integer; 
       BEGIN 
        readln(f); Red; read(f,ch); i := 0; 
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
        WHILE ch=' ' do begin i := i+1; 
          With Liquid[i] do begin 
          readln(f,Temp,Dens,Spec,Pvap,Visc,Emodul); Red; 
          end; read(f,ch); end; 
        Liqmax := i; 
       END; {Liqdata} 
 
PROCEDURE Pipedata; 
  TYPE PerfPipe = record Di,Ro,Kv,Em,Th,Wh,dp : real; 
                         Ref : packed array[1..5] of char; end; 
  VAR  PipePerf : array[1..maxPipePerf] of PerfPipe; 
       Perfmax : integer; 
       Ppost : array[1..maxPi] of PostPipe; 
       
     PROCEDURE PipePerfdata; 
       VAR i,j : integer; 
           ch,Dum : char; 
       BEGIN 
        readln(f); Red; read(f,ch); i := 0; 
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
        WHILE ch=' ' do begin i := i+1; j := 1; 
          REPEAT read(f,Dum); UNTIL (Dum<>' ');  
          With PipePerf[i] do begin 
          Ref := '     '; Ref[j] := Dum; 
          REPEAT j := j+1; read(f,Ref[j]); UNTIL ((Ref[j]=' ') or (j=5)); 
          readln(f,Di,Ro,Kv,Em,Th,Wh,dp); Red; read(f,ch); 
          Di := Di/1000; Ro := Ro/1000; end; {With} 
        end; {While} Perfmax := i; PipePerfmax := Perfmax;
       END; { PipePerfdata } 
 
     PROCEDURE PipeRefdata; 
       VAR i,Nr,j,Rid : integer; 
           Pstr : packed array[1..5] of char; 
           ch : char;
           Prel : real;
       BEGIN 
        For i := 1 to maxId do Pipek[i] := 0; 
        readln(f); Red; read(f,ch); i := 0; 
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
        WHILE ch=' ' do begin  
          Rid := ReadId(f); Nr := Rid mod 100; 
          If (Nr>0) then begin i := i+1;  
             With Ppost[i] do begin
             Id := Rid; {Pipek[Id] := i; }
             read(f,L,Zeta); Pstr := '     '; j := 1; 
             REPEAT read(f,Pstr[j]); UNTIL (Pstr[j]<>' '); 
             REPEAT j := j+1; read(f,Pstr[j]); UNTIL ((Pstr[j]=' ') or (j=5)); 
             j := 0; 
             REPEAT j := j+1; UNTIL ((PipePerf[j].Ref=Pstr) or (j=Perfmax)); 
             If ((j=Perfmax) and (PipePerf[j].Ref<>Pstr)) then begin 
                write('Pipe':5,IdS2(Rid div 100):3,NrS2(Nr):2);
                writeln('Pipe Performance Error!':28); 
                ErrorFlag := true; end; 
             D := PipePerf[j].Di; Ks := PipePerf[j].Ro; 
             Kval := PipePerf[j].Kv;
             dp := PipePerf[j].dp;
             Eth := PipePerf[j].Em*PipePerf[j].Th*1E06; 
             Prel := PipePerf[j].Wh*4*PipePerf[j].Th/PipePerf[j].Di/1E03;
             Fprel := Prel*(1+PipePerf[j].Th/PipePerf[j].Di/1E03);
             For j := 1 to maxCom do Com[j] := ' '; j := 1; 
             REPEAT read(f,Com[j]); UNTIL (Com[j]<>' '); 
             WHILE ((not eoln(f)) and (j<maxCom)) do 
                   begin j := j+1; read(f,Com[j]); end; end; end; 
           readln(f); Red; read(f,ch); end;  
        Pimax := i; 
       END; { PipeRefdata } 
      
      PROCEDURE PipeSort;
       VAR Rad : array[1..99] of integer;
           i,z,Tmp,Znr,k,Kmax,Kmaxsum : integer;     
	   Klar : Boolean;
       BEGIN
        For i := 1 to maxZon do ZonPek[i] := 0;
        z := 0; Zonmax := 0;
        For i := 1 to Pimax do begin
            Znr := Ppost[i].Id div 100;
            If ZonPek[Znr]=0 then begin z := z+1; 
               ZonPek[Znr] := z; ZonId[z] := Znr; end; end;
        Zonmax := z;
        If Zonmax>1 then begin
           REPEAT z := 0; Klar := true;   
            REPEAT z := z+1; 
             If ZonId[z]>ZonId[z+1] then begin Klar := false;
                Tmp := ZonId[z]; ZonId[z] := ZonId[z+1]; 
                ZonId[z+1] := Tmp; end;
            UNTIL (z=(Zonmax-1));
          UNTIL Klar; end; {If Zonmax}      
        Kmaxsum := 0;
        For z := 1 to Zonmax do begin Znr := ZonId[z];
            ZonPek[Znr] := z; end;
        For z := 1 to Zonmax do begin Znr := ZonId[z];
            k := 0; Kmax := 0; 
            For i := 1 to Pimax do 
                If (Ppost[i].Id div 100)=Znr then begin 
                   k := k+1; Rad[k] := i; end;  
            Kmax := k;
            If Kmax>1 then begin 
               REPEAT k := 0; Klar := true;   
                REPEAT k := k+1; 
                 If (Ppost[Rad[k]].Id mod 100)>(Ppost[Rad[k+1]].Id mod 100) 
                    then begin Klar := false; Tmp := Rad[k];
                         Rad[k] := Rad[k+1]; Rad[k+1] := Tmp; end;
                UNTIL (k=(Kmax-1));
               UNTIL Klar; end; {If Kmax}      
            For k := 1 to Kmax do begin i := Kmaxsum+k;
                PipePost[i] := Ppost[Rad[k]]; 
                Pipek[PipePost[i].Id] := i; end;
            Kmaxsum := Kmaxsum+Kmax; end; {For z}
       END; {Pipesort}
        
      BEGIN {Pipedata} 
       PipePerfdata; PipeRefdata; Pipesort;
      END;  {Pipedata} 
 
      PROCEDURE Conndata; 
        VAR  i,Nr,j,Rid,PtoId,PfrId : integer; 
             Typ : EqStr;
             Dum : char;
        BEGIN  
          readln(f); Red; read(f,ch); i := 1; 
          WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
          WHILE (ch=' ') do begin   
            Rid := ReadId(f); Nr := Rid mod 100; 
            If (Nr=0) then begin readln(f); Red; read(f,ch); end 
            else begin  With CnPost[i] do begin 
                 Id := Rid; read(f,xkoord,ykoord,Elev); PtoId := ReadId(f); 
                 Pto := PtoId mod 100; Typ := '  ';
                 REPEAT read(f,Typ[1]); UNTIL (Typ[1]<>' '); 
                 read(f,Typ[2],Enr); Ecod := EqtypToCode(Typ);
                 If Ecod in [1,2,3,4,5,7,8] then read(f,Value)
                    else For j := 1 to 8 do read(f,Dum);
                 PfrId := ReadId(f); Pfr := PfrId mod 100;
                 For j := 1 to maxCom do Com[j] := ' '; j := 1; 
                 REPEAT read(f,Com[j]); UNTIL (Com[j]<>' '); 
                 WHILE ((not eoln(f)) and (j<maxCom)) do 
                       begin j := j+1; read(f,Com[j]); end; 
                 If Pto>0 then Pto := Pipek[PtoId]; 
                 If Pfr>0 then Pfr := Pipek[PfrId];  
                 If (Pto<1) or (Pfr<1) then begin ErrorFlag := true; 
                    write('Conn':5,IdS2(Rid div 100):3,NrS2(Nr):3); 
                    writeln('Pipe Declaration Error!':28); end; 
                If (Enr>0) and (Ecod<>9) then Enr := Enr+100*(Rid div 100);
                 i := i+1; readln(f); Red; read(f,ch); end; end; end; {While} 
          Cnmax := i-1; 
        END;  {Conndata} 
 
      PROCEDURE Juncdata; 
        VAR  i,j,Nr,Pi,V,Rid,Pid : integer; 
        BEGIN   
          readln(f); Red; read(f,ch); i := 0;  
          WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
          WHILE (ch=' ') do begin  
            Rid := ReadId(f); Nr := Rid mod 100; 
            If (Nr>0) then begin i := i+1; With JnPost[i] do begin 
               Id := Rid; read(f,xkoord,ykoord,Elev); ValveSum := 0; 
               For j := 1 to 4 do begin Pid := ReadId(f); 
                   If Pid<0 then Pi := -abs(Pid) mod 100 
                            else Pi := Pid mod 100;
                   read(f,V);
                   If (Pi>0) then begin p[j] := Pipek[Pid];  
                      If p[j]<1 then begin ErrorFlag := true; 
                         write('Junc':5,IdS2(Rid div 100):3,NrS2(Nr):3); 
                         writeln('Pipe Declaration Error!':28); end; end; 
                   If (Pi=0) then p[j] := 0; 
                   If (Pi<0) then begin p[j] := -Pipek[abs(Pid)];  
                      If abs(p[j])<1 then begin ErrorFlag := true; 
                         write('Junc':5,IdS2(Rid div 100):3,NrS2(Nr):3); 
                         writeln('Pipe Declaration Error!':28); end; end; 
                   If (V>0) then begin Vnr[j] := V+100*(Rid div 100); 
                                       ValveSum := ValveSum+1; end; 
                   If (V=0) then Vnr[j] := 0; end; {For} 
               For j := 1 to maxCom do Com[j] := ' '; j := 1; 
               REPEAT read(f,Com[j]); UNTIL (Com[j]<>' '); 
               WHILE ((not eoln(f)) and (j<maxCom)) do begin 
                     j := j+1; read(f,Com[j]); end; end; {With} end; {If} 
             readln(f); Red; read(f,ch); end; {While} 
          Jnmax := i; 
        END;   { Juncdata } 
 
      PROCEDURE Crossdata; 
        VAR i,j,Nr,Znr,k,Rid,Pid,Pj : integer; 
        BEGIN 
          For i := 1 to maxId do CsPek[i] := 0;	
          readln(f); Red; read(f,ch); i := 0; 
          WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
          WHILE (ch=' ') do begin  
            Rid := ReadId(f); Nr := Rid mod 100; 
            If (Nr>0) then begin i := i+1; 
               With CsPost[i] do begin 
               Znr := 100*(Rid div 100); Id := Rid; 
               read(f,xkoord,ykoord,Elev,Vnr); Cspek[Id]  := i;
               If (Vnr>0) then Vnr := Vnr+Znr; 
               For j := 1 to 4 do begin 
                   Pid := ReadId(f); Pj := Pid mod 100;
                   If (Pid<0) then p[j] := -Pipek[abs(Pid)]
                              else p[j] := Pipek[Pid];
                      If (Pj<>0) and (p[j]=0) then begin ErrorFlag := true;
                         write('Cros':5,IdS2(Rid div 100):3,NrS2(Nr):3);
                         writeln('Pipe Declaration Error!':28); end; end;       
               For k := 1 to maxCom do Com[k] := ' '; k := 1; 
               REPEAT read(f,Com[k]); UNTIL (Com[k]<>' '); 
               WHILE ((not eoln(f)) and (k<maxCom)) do 
                 begin k := k+1; read(f,Com[k]); end; 
               readln(f); Red;
               For j := 5 to 8 do begin 
                   Pid := ReadId(f); Pj := Pid mod 100;
                   If (Pid<0) then p[j] := -Pipek[abs(Pid)]
                              else p[j] := Pipek[Pid];
                      If (Pj<>0) and (p[j]=0) then begin ErrorFlag := true;
                         write('Cros':5,IdS2(Rid div 100):3,NrS2(Nr):3);
                         writeln('Pipe Declaration Error!':28); end; end;      
               readln(f); Red; read(f,ch); end; end; 
            If (Nr=0) then begin readln(f); Red; 
               readln(f); Red; read(f,ch); end;
            end; {While}
          Csmax := i;
        END;   {Crossdata} 
 
    PROCEDURE Bordata; 
      VAR  s,Sid,Bid,Pid,Nr,b,l,j,Znr,z,Tmp : integer; 
           Klar : Boolean;
	   xkoor,ykoor,ele : real;
	   BrCheck : array[1..99] of integer; 
      BEGIN 
       For s := 1 to maxSid do Supek[s] := 0;  
       For s := 1 to maxSid do SubCheck[s] := 0; 
       readln(f); Red; read(f,ch); s := 0;
       WHILE not (ch= ' ') do begin readln(f); Red; read(f,ch); end; 
       WHILE ch=' ' do begin 
         Sid := ReadSid; Nr := Sid mod 10; 
         If (Nr=0) then begin readln(f); Red; read(f,ch); end  
         else begin read(f,Bid,xkoor,ykoor,ele); Pid := ReadId(f); read(f,l); 
              If (Pid*l)>=0 then begin ErrorFlag := true; 
                 write('Border':7,IdS2(Sid div 10):3,Nr:1,NrS2(Bid):3); 
                 writeln('Pipe/Link,  Sign Error!':28); end; 
              If SubCheck[Sid]=0 then begin 
                 SubCheck[Sid] := 1; s := s+1; Brmax[s] := 1;
                 b := 1; Supek[Sid] := s; SubId[s] := Sid; end 
              else begin Brmax[s] := Brmax[s]+1; b := b+1; end; 
              With BorPost[s,b] do begin 
              For j := 1 to maxCom do Com[j] := ' '; j := 1;
              REPEAT read(f,Com[j]); UNTIL Com[j]<>' ';
              WHILE ((j<12) and (not eoln(f))) do begin
                j := j+1; read(f,Com[j]); end; end;
              If Pid>0 then BorPost[s,b].Pi := Pipek[Pid] 
                       else BorPost[s,b].Pi := -Pipek[abs(Pid)]; 
              If Pipek[abs(Pid)]=0 then begin ErrorFlag := true; 
                 write('Border':7,IdS2(Sid div 10):3,Nr:1,NrS2(Bid):3); 
                 writeln('Pipe Declaration Error!':28); end;  
              BorPost[s,b].Id := Bid; BorPost[s,b].Li := l; 
              BorPost[s,b].xkoord := xkoor; BorPost[s,b].ykoord := ykoor; 
              BorPost[s,b].elev := ele; 
              readln(f); Red; read(f,ch); end; end; 
       Sumax := s; 
       For s := 1 to Sumax do begin
           For j := 1 to 99 do BrCheck[j] := 0;
           For b := 1 to Brmax[s] do begin j := BorPost[s,b].Id;
               If BrCheck[j]=0 then BrCheck[j] := 1
                  else begin ErrorFlag := true; 
                  Sid := SubId[s]; Nr := Sid mod 10;
                  write('Border':7,IdS2(Sid div 10):3,Nr:1,NrS2(j):3); 
                  writeln('Ambigous Border Nr!':28); end;  
           end; end;
       For s := 1 to Sumax do begin
           Znr := SubId[s] div 10; 
           If ZonPek[Znr]=0 then begin Zonmax := Zonmax+1;
              Zonpek[Znr] := Zonmax; ZonId[Zonmax] := Znr; end; end; 
       If Zonmax>1 then begin
          REPEAT z := 0; Klar := true;   
           REPEAT z := z+1; 
            If ZonId[z]>ZonId[z+1] then begin Klar := false;
               Tmp := ZonId[z]; ZonId[z] := ZonId[z+1]; 
               ZonId[z+1] := Tmp; end;
           UNTIL (z=(Zonmax-1));
          UNTIL Klar; end; {If Zonmax}      
       For z := 1 to Zonmax do begin Znr := ZonId[z];
           ZonPek[Znr] := z; end;
      END;  {Bordata} 

    PROCEDURE Lcndata; 
      VAR  Nr,Sid,s,c,j : integer; 
           Lc : array[1..maxSu] of integer; 
           Typ : EqStr;
           Dum : char;
      BEGIN 
       For s := 1 to Sumax do begin Lcnmax[s] := 0; Lc[s] := 0; end; 
       readln(f); Red; read(f,ch); 
       WHILE not (ch= ' ') do begin readln(f); Red; read(f,ch); end; 
       WHILE ch=' ' do begin   
         Sid := ReadSid; Nr := Sid mod 10; 
         If (Nr>0) then begin read(f,c);  
            If SubCheck[Sid]=0 then begin ErrorFlag := true;
               write('Lcon':5,IdS2(Sid div 10):2,Nr:1,c:2); 
               writeln('Subnet,     Decl Error!':28); Gerror; end;
            s := Supek[Sid]; Lc[s] := Lc[s]+1; Typ := '  ';
            With LcnPost[s,Lc[s]] do begin read(f,Elev,Lto); 
            REPEAT read(f,Typ[1]); UNTIL (Typ[1]<>' '); 
            read(f,Typ[2],Enr); Id := c; Ecod := EqtypToCode(Typ);
            If Ecod in [1,2,3,4,5,7,8] then read(f,Value)
               else For j := 1 to 8 do read(f,Dum);
            read(f,Lfr);
            For j := 1 to maxCom do Com[j] := ' '; j := 1; 
            REPEAT read(f,Com[j]); UNTIL (Com[j]<>' '); 
            WHILE ((not eoln(f)) and (j<maxCom)) do 
                 begin j := j+1; read(f,Com[j]); end; 
            If (Enr>0) and (Ecod<>9) then Enr := Enr+100*(Sid div 10);
            end; end;
         readln(f); Red; read(f,ch); end;{While} 
       For s:= 1 to Sumax do Lcnmax[s] := Lc[s]; 
      END;  {Lcndata} 
 
    PROCEDURE Ljndata; 
      VAR  s,Nr,j,Sid,k,m,V : integer; 
           Lj : array[1..maxSu] of integer; 
      BEGIN 
        For s := 1 to Sumax do begin Ljnmax[s] := 0; Lj[s] := 0; end; 
        readln(f); Red; read(f,ch); 
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
        WHILE (ch=' ') do begin  
         Sid := ReadSid; Nr := Sid mod 10; 
         If (Nr>0) then begin read(f,j); 
            If SubCheck[Sid]=0 then begin ErrorFlag := true;
               write('Ljun':5,IdS2(Sid div 10):2,Nr:1,j:2); 
               writeln('Subnet,     Decl Error!':28); Gerror; end;
            s := Supek[Sid]; Lj[s] := Lj[s]+1; 
            With LjnPost[s,Lj[s]] do begin
            read(f,Elev); ValveSum := 0; 
            For k := 1 to 4 do begin read(f,Li[k],V); 
                If (V>0) then begin Vnr[k] := V+100*(Sid div 10); 
                                    ValveSum := ValveSum+1; end; 
                If (V=0) then Vnr[k] := 0; end; 
            Id := j; For m := 1 to maxCom do Com[m] := ' '; m := 1; 
            REPEAT read(f,Com[m]); UNTIL (Com[m]<>' '); 
            WHILE ((not eoln(f)) and (m<maxCom)) do 
                  begin m := m+1; read(f,Com[m]); end; end; end; 
        readln(f); Red; read(f,ch); end; 
        For s:= 1 to Sumax do Ljnmax[s] := Lj[s]; 
      END; {Ljndata} 
 
    PROCEDURE Lcsdata; 
      VAR  s,Nr,j,Sid,k,m : integer; 
           Lc : array[1..maxSu] of integer; 
      BEGIN 
        For s := 1 to Sumax do begin Lcsmax[s] := 0; Lc[s] := 0; end; 
        readln(f); Red; read(f,ch); 
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
        WHILE (ch=' ') do begin  
         Sid := ReadSid; Nr := Sid mod 10;
         If (Nr>0) then begin read(f,j);  
            If SubCheck[Sid]=0 then begin ErrorFlag := true;
               write('Lcro':5,IdS2(Sid div 10):2,Nr:1,j:2); 
               writeln('Subnet,     Decl Error!':28); Gerror; end;
            s := Supek[Sid]; Lc[s] := Lc[s]+1; 
            With LcsPost[s,Lc[s]] do begin 
            read(f,Elev,Vnr);
            If (Vnr>0) then Vnr := Vnr+100*(Sid div 10);             
            For k := 1 to 4 do read(f,Li[k]); 
            Id := j; Lcspek[s,Id] := Lc[s]; 
            For m := 1 to maxCom do Com[m] := ' '; m := 1; 
            REPEAT read(f,Com[m]); UNTIL (Com[m]<>' '); 
            WHILE ((not eoln(f)) and (m<maxCom)) do 
                  begin m := m+1; read(f,Com[m]); end; 
            readln(f); Red;              
            For k := 5 to 8 do read(f,Li[k]);  
            readln(f); Red; read(f,ch); end; end;
         If (Nr=0) then begin
            readln(f); Red; readln(f); Red; read(f,ch); end; 
        end; {While} 
        For s:= 1 to Sumax do Lcsmax[s] := Lc[s]; 
      END; {Lcsdata} 

     PROCEDURE Bounddata;
       VAR Io,Nr,s,j,Znr,Sid,Pid : integer;
           PLdum,ch : char;
           Dum : real;
           Lio : array[1..maxSu] of integer;
       BEGIN
        For s := 1 to Sumax do begin Liomax[s] := 0; Lio[s] := 0; end;
        Iomax := 0; Io := 0;
        readln(f); Red; read(f,ch);
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
        WHILE (ch=' ') do begin
          Znr := ReadZ2(f); read(f,PLdum);
          If PLdum in ['1'..'9'] then begin
             Sid := 10*Znr+ord(PLdum)-48; s := Supek[Sid];
             If (s<1) or (s>Sumax) then begin writeln;
                writeln('Boundary cond,   Subnet Error!':33); Gerror; end;
             read(f,Nr);
             If Nr>0 then begin Lio[s] := Lio[s]+1;
                With LioPost[s,Lio[s]] do begin Li := Nr;
                REPEAT read(f,BE); UNTIL BE<>' ';
                If not (BE in ['I','T','O','F']) then begin writeln;
                   writeln('Boundary Cond,   I/O Error!':30); Gerror; end;
		                    read(f,Dum,Dum,Elev,Temp);
                REPEAT read(f,QP); UNTIL QP<>' ';
                If not (QP in ['Q','P']) then begin writeln;
                   writeln('Boundary cond,   Q/P Error!':30); Gerror; end;
                read(f,Value);
                For j := 1 to maxCom do Com[j] := ' '; j := 1;
                REPEAT read(f,Com[j]); UNTIL (Com[j]<>' ');
                WHILE ((not eoln(f)) and (j<maxCom)) do
                  begin j := j+1; read(f,Com[j]); end;
             end; {with} end; {If Nr} end; {If Pldum}
          If Pldum=' ' then begin read(f,Nr);
             If Nr>0 then begin Io := Io+1;
                With IoPost[Io] do begin
                Pid := 100*Znr+Nr; Pi := Pipek[Pid];
                REPEAT read(f,BE); UNTIL BE<>' ';
                If not (BE in ['I','T','O','F']) then begin writeln;
                writeln('Boundary Cond,   I/O Error!':30); Gerror; end;
                read(f,xkoord,ykoord,Elev,Temp);
                REPEAT read(f,QP); UNTIL QP<>' ';
                If not (QP in ['Q','P']) then begin writeln;
                   writeln('Boundary cond,   Q/P Error!':30); Gerror; end;
                read(f,Value);
                For j := 1 to maxCom do Com[j] := ' '; j := 1;
                REPEAT read(f,Com[j]); UNTIL (Com[j]<>' ');
                WHILE ((not eoln(f)) and (j<maxCom)) do
                      begin j := j+1; read(f,Com[j]); end;
             end; {with} end; {I Nr} end; {If Pldum}
        readln(f); Red; read(f,ch); end; {while}
        Iomax := Io;
        For s := 1 to Sumax do Liomax[s] := Lio[s];
       END; {Bounddata}

   PROCEDURE HeatExdata;
     VAR Ep,s,i : integer;
         O1,O2,Om : real;
         Wex : array[1..maxEx] of real;
         Wlex : array[1..maxSu,1..maxLex] of real;
         Tph,Tpl,Tsh,Tsl : array[1..maxHexPerf] of real;

     PROCEDURE Hexdata;
       VAR Ex,Nr,s,j,Znr,Sid,Pid : integer;
           PLdum : char;
           Lex : array[1..maxSu] of integer;
       BEGIN
        For s := 1 to Sumax do begin Lexmax[s] := 0; Lex[s] := 0; end;
        Exmax := 0; Ex := 0;
        readln(f); Red; read(f,ch);
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
        WHILE (ch=' ') do begin
          Znr := ReadZ2(f); read(f,PLdum);
          If PLdum in ['1'..'9'] then begin
             Sid := 10*Znr+ord(PLdum)-48; s := Supek[Sid];
             read(f,Nr);
             If Nr>0 then begin Lex[s] := Lex[s]+1;
                If (s<1) or (s>Sumax) then begin writeln;
                   writeln('Heat Exchanger   Subnet Error!':33); 
                Gerror; end;
                With LexPost[s,Lex[s]] do begin Su := s; eNr := Nr;
                read(f,Href,Elev,Wlex[s,Lex[s]],pTo,pAv,pFr); 
                For j := 1 to maxCom do Com[j] := ' '; j := 1;
                REPEAT read(f,Com[j]); UNTIL (Com[j]<>' ');
                WHILE ((not eoln(f)) and (j<maxCom)) do
                  begin j := j+1; read(f,Com[j]); end;
                readln(f); Red;  
                readln(f,sTo,sAv,sFr); Red; read(f,ch);
                If (pTo<=0) or (pFr<=0) or (sTo<=0) or (sFr<=0)
                   then begin write('Heat Exch':12,IdS2(Znr):2,Pldum:1,Nr:2);
                        write('Connection Error!':25); Gerror; end;
                end; {with} end; {If Nr} 
             If (Nr=0) then begin readln(f); Red; 
                       readln(f); Red; read(f,ch); end;
          end; {If Pldum}
          If (Pldum='0') then begin readln(f); Red; 
                         readln(f); Red; read(f,ch); end;
          If Pldum=' ' then begin read(f,Nr);
             If Nr>0 then begin Ex := Ex+1;
                With ExPost[Ex] do begin Id := 10*Znr+Nr;
                read(f,Href,Elev,Wex[Ex]); 
                Pid := ReadId(f); pTo := Pipek[Pid]; read(f,pAv);
                Pid := ReadId(f); pFr := Pipek[Pid];   
                For j := 1 to maxCom do Com[j] := ' '; j := 1;
                REPEAT read(f,Com[j]); UNTIL (Com[j]<>' ');
                WHILE ((not eoln(f)) and (j<maxCom)) do
                  begin j := j+1; read(f,Com[j]); end;
                readln(f); Red;
                Pid := ReadId(f); sTo := Pipek[Pid]; read(f,sAv);
                Pid := ReadId(f); sFr := Pipek[Pid];
                readln(f); Red;
                If (pTo<=0) or (pFr<=0) or (sTo<=0) or (sFr<=0)
                   then begin write('Heat Exch':12,IdS2(Znr):2,Pldum:1,Nr:2);
                        write('Connection Error!':25); Gerror; end;
             end; {with} end; {If Nr} 
             If (Nr=0) then begin readln(f); Red; 
                            readln(f); Red; read(f,ch) end;
          end; {If Pldum} end; {While}
        Exmax := Ex;
        For s := 1 to Sumax do Lexmax[s] := Lex[s];
       END; {Hexdata}

   PROCEDURE HexPerfdata;
    VAR   i,Nr,Ep,s : integer;
          RefAll : array[1..99] of integer;
    BEGIN
     For i := 1 to 99 do HexPerfpek[i] := 0;
     For i := 1 to 99 do RefAll[i] := 0; Ep := 0;
     readln(f); Red; read(f,ch);
     WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
     WHILE (ch=' ') do begin
      read(f,Nr);
      If Nr=0 then begin readln(f); Red; read(f,ch) end
      else begin Ep := Ep+1; HexPerfpek[Nr] := Ep;
           If ((maxHexPerf-Ep)<1) then begin write('Number of Heat Ex Perf ':25);
               writeln('must not exceed : ':18,maxHexPerf:2); Gerror; end;
           If (RefAll[Nr]>0) then begin
               writeln('Heat Ex Perf':13,Nr:3,'Ambigous directive!':22);
               Gerror; end
               else RefAll[Nr] := 1;
           With HexPerf[Ep] do begin Href := Nr;
           readln(f,Tph[Ep],Tpl[Ep],Vexp,TL,AdTm,Aps,Tsh[Ep],Tsl[Ep]); Red;
           If ((Tph[Ep]<=Tpl[Ep]) or (Tsh[Ep]<=Tsl[Ep])
              or (Tph[Ep]<=Tsh[Ep]) or (Tpl[Ep]<=Tsl[Ep])
              or (Vexp<0.01) or (Vexp>0.99)
              or (TL<=0.005) or (TL>0.995) or (Aps<0.01)) then begin
              writeln('Heat Ex Perf':13,Nr:3,'Unrealistic Data!':20);
              ErrorFlag := true; end;
           end; {With} read(f,ch); end; {else}
     end; {while} HexPerfmax := Ep;
     For i := 1 to Exmax do With ExPost[i] do
         If RefAll[Href]<1 then begin
            write('Exch':5,IdS2(Id div 100):3,Id mod 100:3);
	    writeln('Performance Error!':22); Gerror; end;
     For s := 1 to Sumax do For i := 1 to Lexmax[s] do
         With LexPost[s,i] do
         If RefAll[Href]<1  then begin
            write('Exch':5,IdS2(SubId[s] div 10):3,SubId[s] mod 10:1);
            writeln(eNr:2,'Performance Error!':22); Gerror; end;
    END; {HexPerfdata}

 BEGIN {HeatExdata}
  Hexdata; HexPerfdata;
  For i := 1 to Exmax do begin With ExPost[i] do begin
      Ep := HexPerfpek[Href];
      Tpm := (Tph[Ep]+Tpl[Ep])/2; Tsm := (Tsh[Ep]+Tsl[Ep])/2;
      O1 := Tph[Ep]-Tsh[Ep]; O2 := Tpl[Ep]-Tsl[Ep];
      If abs(O1/O2-1)<0.02 then Om := (O1+O2)/2
                           else Om := (O1-O2)/ln(O1/O2);
      kAo := Wex[i]/Om; Tempinit(Tpm);
      Qpo := Wex[i]/(Tph[Ep]-Tpl[Ep])/Ra/Csp;
      Tempinit(Tsm);
      Qso := Wex[i]/(Tsh[Ep]-Tsl[Ep])/Ra/Csp;
      end; {With} end; {For i}
  For s := 1 to Sumax do begin For i := 1 to Lexmax[s] do begin
      With LexPost[s,i] do begin
      Ep := HexPerfpek[Href];
      Tpm := (Tph[Ep]+Tpl[Ep])/2; Tsm := (Tsh[Ep]+Tsl[Ep])/2;
      O1 := Tph[Ep]-Tsh[Ep]; O2 := Tpl[Ep]-Tsl[Ep];
      If abs(O1/O2-1)<0.02 then Om := (O1+O2)/2
                           else Om := (O1-O2)/ln(O1/O2);
      kAo := Wlex[s,i]/Om; Tempinit(Tpm);
      Qpo := Wlex[s,i]/(Tph[Ep]-Tpl[Ep])/Ra/Csp;
      Tempinit(Tsm);
      Qso := Wlex[s,i]/(Tsh[Ep]-Tsl[Ep])/Ra/Csp;
      Tempinit(Tinit);
      end; {With} end; {For i} end; {For s}
 END;  {HeatExdata}

    PROCEDURE Boilerdata;
      VAR Bpost : array[1..maxBoil] of PostBoiler;
       
       PROCEDURE ReadBoiler;
        VAR i,Nr,j,Rid,Znr : integer;
            Dum : char;
        BEGIN
         readln(f); Red; read(f,ch); i := 1; Boilmax := 0;
         WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
         WHILE (ch=' ') do begin
           Rid := ReadId(f); Znr := Rid div 100; Nr := Rid mod 100;
           If (Nr>0) then begin With Bpost[i] do begin
              Id := Rid; read(f,Avboil);
              REPEAT read(f,MF); UNTIL (MF<>' ');
              If not (MF in ['M','F','S']) then begin ErrorFlag := true;
                 writeln('Boiler':16,IdS2(Znr):3,NrS2(Nr):2,'Max/Fix/Sta Error!':21); end;
              read(f,Dum); read(f,Dum);
              read(f,Wmax,Tboil,Avbp,Tpipe);
              For j := 1 to maxCom do Com[j] := ' '; j := 1;
              REPEAT read(f,Com[1]); UNTIL Com[1]<>' ';
              WHILE ((not eoln(f)) and (j<maxCom)) do begin
                    j := j+1; read(f,Com[j]); end;
              i := i+1; Qbt := 0; end; end;
           readln(f); Red; read(f,ch); end;
         Boilmax := i-1;
        END;   {ReadBoiler}
       
       PROCEDURE BoilerSort;
        VAR i,z,Znr,Tmp,k,Kmax,Kmaxsum : integer;
            Rad : array[1..99] of integer;
            Klar : Boolean;
        BEGIN
         Kmaxsum := 0;
         For z := 1 to Zonmax do begin Znr := ZonId[z];
             k := 0; Kmax := 0;
             For i := 1 to Boilmax do
                 If (BPost[i].Id div 100)=Znr then begin
                    k := k+1; Rad[k] := i; end;         
             Kmax := k;
             If Kmax>1 then begin 
                REPEAT k := 0; Klar := true;   
                 REPEAT k := k+1; 
                  If (Bpost[Rad[k]].Id>Bpost[Rad[k+1]].Id) 
                    then begin Klar := false; Tmp := Rad[k];
                         Rad[k] := Rad[k+1]; Rad[k+1] := Tmp; end;
                 UNTIL (k=(Kmax-1));
                UNTIL Klar; end; {If Kmax}
             For k := 1 to Kmax do begin i := Kmaxsum+k;
                 Boiler[i] := Bpost[Rad[k]]; end; 
             Kmaxsum := Kmaxsum+Kmax; end; {For z}
       END; {BoilerSort}
       
     BEGIN
      ReadBoiler; BoilerSort;
     END; {Boilerdata}
      
     PROCEDURE Loaddata;
        VAR Nr,Id,Snr,Cs,Sid,s,Lcs,Znr : integer;
            Fload,Tret,dTnom,dHnom : real;
            PL : char;
            Error : Boolean;
        BEGIN
         For Cs := 1 to Csmax do CsPost[Cs].Pload := 0;
         For s := 1 to Sumax do
             For Lcs := 1 to Lcsmax[s] do LcsPost[s,Lcs].Pload := 0;
         LoadCsmax := 0; LoadLcsmax := 0;
         readln(f); Red; read(f,ch);
         WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
         readln(f,Fload,Tret); Red; read(f,ch);
         If abs(Fload)<0.01 then begin ErrorFlag := true;
            writeln('abs(Fload) must be >=0.01 !!':30); end;
         Aload := Fload; Bload := 0; Cload := 0;
         Aret := Tret; Bret := 0; Cret := 0;
         WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
         WHILE (ch=' ') do begin
           Znr := ReadZ2(f); read(f,PL);
           If PL=' ' then begin read(f,Nr); Error := false;
              If Nr>0 then begin  LoadCsmax := LoadCsmax+1;
                 Id := Nr+100*Znr;
                 If (Id<1) or (Id>maxId) then Error := true
                                         else Cs := Cspek[Id];
                 If (Cs<1) or (Cs>Csmax) then Error := true
                    else begin With CsPost[Cs] do
                         If (Pload<>0) or (Vnr>0) then Error := true; end;
                 With CsPost[Cs] do begin
                 REPEAT read(f,Cat); UNTIL Cat<>' ';
                 If not (Cat in ['A','B','C','D','E','F']) then Error := true;
                 If Error then begin write('Pcs ':5,IdS2(Znr):2,Nr:3);
                    writeln('Load Declaration Error!':28); Gerror; end;
                 read(f,Pnom,Fsum,dTr,dTnom,dHnom);
                 CASE Cat OF
                 'A': Pload := Aload*Fsum*Pnom;
                 'B': Pload := Bload*Fsum*Pnom;
                 'C': Pload := Cload*Fsum*Pnom;
                 'D': Pload := Dload*Fsum*Pnom;
                 'E': Pload := Eload*Fsum*Pnom;
                 'F': Pload := Gload*Fsum*Pnom;
                 END;
                 If Pnom<Epsi then Pnom := Epsi;
                 Avmax := Pnom/Ra/Csp/dTnom/sqrt(g*dHnom);
                 IF Avmax<(Epsi*1E-3) then Avmax := (Epsi*1E-3); end; end; end;
           If PL in ['1'..'9'] then begin Error := false;
              Snr := ord(PL)-48; read(f,Nr);
              If (Nr>0) then begin LoadLcsmax := LoadLcsmax+1;
                 Sid := Snr+10*Znr;
		 If (Sid<1) or (Sid>maxSid) then Error := true
                                            else s := Supek[Sid];
                 If (s<1) or (s>Sumax) then Error := true
                                       else Lcs := LcsPek[s,Nr];
                 If (Lcs<1) or (Lcs>Lcsmax[s]) then Error := true
                 else begin With LcsPost[s,Lcs] do
                      If (Pload<>0) or (Vnr>0) then Error := true; end;
                 With LcsPost[s,Lcs] do begin
                 REPEAT read(f,Cat); UNTIL Cat<>' ';
                 If not (Cat in ['A','B','C','D','E','F']) then Error := true;
                 If Error then begin write('Lcs ':5,IdS2(Znr):2,Snr:1,Nr:2);
                    writeln('Load Declaration Error!':28); Gerror; end;
                 read(f,Pnom,Fsum,dTr,dTnom,dHnom);
                 CASE Cat OF
                 'A': Pload := Aload*Fsum*Pnom;
                 'B': Pload := Bload*Fsum*Pnom;
                 'C': Pload := Cload*Fsum*Pnom;
                 'E': Pload := Dload*Fsum*Pnom;
                 'D': Pload := Eload*Fsum*Pnom;
                 'F': Pload := Gload*Fsum*Pnom;
                 END;
                 If Pnom<Epsi then Pnom := Epsi;
                 Avmax := Pnom/Ra/Csp/dTnom/sqrt(g*dHnom);
                 IF Avmax<(Epsi*1E-3) then Avmax := Epsi*1E-3; end; end; end;
           readln(f); Red; read(f,ch); end; {while}
        END;   {Loaddata}

        PROCEDURE RVdata;
         VAR i,Rv,Nr : integer;
             RefAll : array[1..99]of integer;
         BEGIN
          For i := 1 to 99 do RvPerfpek[i] := 0;
          For i := 1 to 99 do RefAll[i] := 0;
          readln(f); Red; read(f,ch); Rv := 0;
          WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
          WHILE (ch=' ') do begin
            read(f,Nr);
            If (Nr=0) then begin readln(f); Red; read(f,ch); end
            else begin Rv := Rv+1; RvPerfPek[Nr] := Rv; RvNr[Rv] := Nr;
                 If (RefAll[Nr]>0) then begin ErrorFlag := true;
                    writeln('Relief Valve Performance, Ambigous directive!':46); end
                 else RefAll[Nr] := 1;
                 With RvPost[Rv] do
                 readln(f,A,B,C); Red; read(f,ch); end; {else}
          end; {While}  RvPerfmax := Rv;
         END; {RVdata}

       PROCEDURE Vrefdata;
        VAR Vpost : array[1..maxVa] of PostVref;
 
         PROCEDURE ReadVref;
         VAR  Nr,i,Par,Dum2,j,Rid : integer;
              Dum1 : real;
              Dum : char;
         
          BEGIN
           For i := 1 to maxId do Vapek[i] := 0;
           readln(f); Red; read(f,ch); i := 1; Vamax := 0;
           WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
           WHILE (ch=' ') do begin Par := 0;
             REPEAT
               Rid := ReadId(f); Nr := Rid mod 100;
               Par := Par+1; j := 1;
               If (Nr=0) then begin read(f,Dum1,Dum2);
                  REPEAT read(f,Dum); UNTIL Dum<>' ';
                  WHILE ((j<12) and (not eoln(f))) do begin
                     j := j+1; read(f,Dum); end; end
               else begin With Vpost[i] do begin Id := Rid;
                    read(f,S,Vref);
                    For j := 1 to 12 do Com[j] := ' '; j := 1;
                    REPEAT read(f,Com[1]); UNTIL Com[1]<>' ';
                    WHILE ((j<12) and (not eoln(f))) do begin
                     j := j+1; read(f,Com[j]); end;
                    Vamax := Vamax+1;
                    If Vamax=maxVa then begin write('Number of Valves must':25);
                       writeln(' not exceed : ':14,maxVa:3); Gerror; end;
                    i := i+1; end; end;
             UNTIL (Par=2); readln(f); Red; read(f,ch); end; {While}
         END;   { ReadVref }

      PROCEDURE VrefSort;
       VAR i,z,Znr,Tmp,k,Kmax,Kmaxsum : integer;
           Rad : array[1..99] of integer;
           Klar : Boolean;
       BEGIN
        Kmaxsum := 0;
        For z := 1 to Zonmax do begin Znr := ZonId[z];
            k := 0; Kmax := 0;
            For i := 1 to Vamax do
            If (VPost[i].Id  div 100)=Znr then begin
                k := k+1; Rad[k] := i; end;         
            Kmax := k;
            If Kmax>1 then begin 
               REPEAT k := 0; Klar := true;   
                REPEAT k := k+1; 
                 If (Vpost[Rad[k]].Id>Vpost[Rad[k+1]].Id) 
                    then begin Klar := false; Tmp := Rad[k];
                         Rad[k] := Rad[k+1]; Rad[k+1] := Tmp; end;
                UNTIL (k=(Kmax-1));
               UNTIL Klar; end; {If Kmax}      
            For k := 1 to Kmax do begin i := Kmaxsum+k;
                VrefPost[i] := Vpost[Rad[k]]; 
                Vapek[VrefPost[i].Id] := i; end;
            Kmaxsum := Kmaxsum+Kmax; end; {For z}
       END; {ValveSort}

       BEGIN
        ReadVref; VrefSort;
       END; {Vrefdata}
              
      PROCEDURE Valvedata;
        VAR  Va,Nr,i,Ref : integer;
             Typ : packed array[1..3] of char;
             Zn : char;
             Vflag : Boolean;
             RefAll : array[1..99] of integer;

       PROCEDURE Tabvalve;
        VAR i,t,Nr,Tab : integer;
            Dum : char;
            TabAll : array[1..99] of integer;
        BEGIN
          For i := 1 to 99 do Tabpek[i] := 0;
          For i := 1 to maxTab do begin TabNr[i] := 0; Vimax[i] := 0; end;
          Tab := 0;
          WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
          WHILE (ch=' ') do begin t := 0;
            REPEAT read(f,Dum); t := t+1; UNTIL (f^<>' ');
            If (t<10) then begin read(f,Nr); i := 0;
               If Nr>0 then begin Tab := Tab+1;
                  TabPek[Nr] := Tab; TabNr[Tab] := Nr; end; end;
            If Nr=0 then begin readln(f); Red; read(f,ch); end
            else begin i := i+1; Vimax[Tab] := i;
                 readln(f,Vsl[Tab,i],Vfi[Tab,i],Vfl[Tab,i]); Red;
                 read(f,ch); end;
          end; {while} Tabmax := Tab;
         For i := 1 to 99 do TabAll[i] := 0;
         For i := 1 to Tabmax do
             If TabAll[TabNr[i]]>0 then begin ErrorFlag := true;
                 writeln('Tabulated Valve Performance Error!':34); end
              else TabAll[TabNr[i]] := 1;
        END; {Tabvalve}

        BEGIN {Valvedata}
          For i := 1 to 99 do VaPerfPek[i] := 0;
          For i := 1 to 99 do RefAll[i] := 0;
          readln(f); Red; read(f,ch); Va := 0;
          WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
          WHILE (ch=' ') do begin
            Vflag := false; read(f,Nr);
            If (Nr=0) then begin readln(f); Red; read(f,ch); end
            else begin Va := Va+1; VaPerfPek[Nr] := Va;
                 If (RefAll[Nr]>0) then begin ErrorFlag := true;
                    writeln('Valve Performance, Ambigous directive!':38); end
                 else RefAll[Nr] := 1;
                 With ValvePerf[Va] do begin
                 REPEAT read(f,Typ[1]); UNTIL (Typ[1]<>' ');
                 read(f,Typ[2],Typ[3]);
                 If Typ='PRG' then begin Vtyp := 1; Vflag := true; end;
                 If Typ='BAL' then begin Vtyp := 2; Vflag := true; end;
                 If Typ='BUT' then begin Vtyp := 3; Vflag := true; end;
                 If Typ='GAT' then begin Vtyp := 4; Vflag := true; end;
                 If Typ='LIN' then begin Vtyp := 5; Vflag := true; end;
                 If Typ='TAB' then begin Vtyp := 6; Vflag := true; end;
                 If not Vflag then begin write('Perf':5,Nr:3,' ':2);
                    writeln('Valve Type, Perf Error!':28); Gerror; end;
                 readln(f,Avp,Avm,Smin,Smax); Red; read(f,ch); Vref := Nr;
            end; {With} end; {else}
          end; {While} Vperfmax := Va;
          TabValve;
          For i := 1 to Vamax do
              If not (RefAll[VrefPost[i].Vref]>0) then begin
                 Zn := chr(VrefPost[i].Id div 100+65);
                 Nr := VrefPost[i].Id mod 100;
                 ErrorFlag := true; write('Valv':5,Zn:2,Nr:3);
                 writeln('Valve Ref,  Perf Error!':28); end;
          For i := 1 to Vamax do begin With VrefPost[i] do begin
              If (S<ValvePerf[VaPerfPek[Vref]].Smin) or
                 (S>ValvePerf[VaPerfPek[Vref]].Smax) then begin
                 Zn := chr(Id div 100+65); Nr := Id mod 100;
                 ErrorFlag := true; write('Valv':5,Zn:2,Nr:3);
                 writeln('Valve Ref,  S<Smin or S>Smax!':34);
              end; end; end;
          For i := 1 to Vamax do begin Ref := VrefPost[i].Vref;
              If (ValvePerf[VaPerfPek[Ref]].Vtyp=6) and (TabPek[Ref]=0)
                 then begin ErrorFlag := true;
                 writeln('Tabulated Valve Performance Error!':34); end; end;
         END;   { Valvedata }

      PROCEDURE Prefdata;
        VAR Ppost : array[1..maxPu] of PostPref;

        PROCEDURE ReadPref; 
         VAR  Nr,i,j,Rid : integer;
         BEGIN
           For i := 1 to maxId do Pupek[i] := 0;
           readln(f); Red; read(f,ch); i := 1; Pumax := 0;
           WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
           WHILE (ch=' ') do begin
             Rid := ReadId(f); Nr := Rid mod 100;
             If (Nr>0) then begin With Ppost[i] do begin
                Id := Rid; read(f,Pref,DIx);
                REPEAT read(f,YN); UNTIL (YN<>' ');
                If (YN<>'Y') and (YN<>'N') then begin ErrorFlag := true;
                   write('Pump':5,IdS2(Rid div 100):4,NrS2(Nr):2);
                   writeln('Checkvalve, Y/N  Error!':28); end;
                read(f,Avbv);
                If (YN='N') then Avbv := 1E05;
                DrId := ReadId(f); Nr := DrId mod 100;
                For j := 1 to maxCom do Com[j] := ' '; j := 1;
                REPEAT read(f,Com[1]); UNTIL Com[1]<>' ';
                WHILE ((not eoln(f)) and (j<maxCom)) do begin
                      j := j+1; read(f,Com[j]); end;
                Pumax := Pumax+1; i := i+1; end; end;
             readln(f); Red; read(f,ch); end; {While}
         END;   {ReadPref }
        
        PROCEDURE PrefSort;
         VAR i,z,Znr,Tmp,k,Kmax,Kmaxsum : integer;
             Rad : array[1..99] of integer;
             Klar : Boolean;
         BEGIN
          Kmaxsum := 0;
          For z := 1 to Zonmax do begin Znr := ZonId[z];
              k := 0; Kmax := 0;
              For i := 1 to Pumax do
              If (Ppost[i].Id  div 100)=Znr then begin
                  k := k+1; Rad[k] := i; end;         
              Kmax := k;
              If Kmax>1 then begin 
                 REPEAT k := 0; Klar := true;   
                  REPEAT k := k+1; 
                   If (Ppost[Rad[k]].Id>Ppost[Rad[k+1]].Id) 
                      then begin Klar := false; Tmp := Rad[k];
                         Rad[k] := Rad[k+1]; Rad[k+1] := Tmp; end;
                  UNTIL (k=(Kmax-1));
                 UNTIL Klar; end; {If Kmax}      
              For k := 1 to Kmax do begin i := Kmaxsum+k;
                  PrefPost[i] := Ppost[Rad[k]]; 
                  Pupek[PrefPost[i].Id] := i; end;
              Kmaxsum := Kmaxsum+Kmax; end; {For z}
         END; {PrefSort}
      
        BEGIN 
         ReadPref; PrefSort;
        END; {Prefdata}

     PROCEDURE Drivedata;
       VAR Dpost : array[1..maxDr] of PostDrive;
         
       PROCEDURE ReadDrive;  
         VAR  Nr,i,j,Rid : integer;
              Nx : real;
              Dum : char;
         BEGIN
           For i := 1 to maxId do Drpek[i] := 0;
           readln(f); Red; read(f,ch); i := 1; Drmax := 0;
           WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
           WHILE (ch=' ') do begin
               Rid := ReadId(f); Nr := Rid mod 100;
               If (Nr>0) then begin With Dpost[i] do begin
                  Id := Rid; read(f,Pmot,Emot,Nmot);
                  REPEAT read(f,Vartyp); UNTIL (Vartyp<>' ');
                  read(f,Dum,Dum);
                  If not (Vartyp in ['F','H','N']) then begin
                     ErrorFlag := true; write('Drive':6,IdS2(Rid div 100):2,Nr:3);
                     writeln('Variator Type Error!':28); end;
                  read(f,Evar,Nmax,Nx);
                  If Nx>Nmax then Nx := Nmax;   Ndr := Nx*Nmot;
                  If ((Vartyp='N') and (Ndr<>Nmot)) then begin
                     ErrorFlag := true; write('Drive':6,IdS2(Rid div 100):2,Nr:3);
                     writeln('Drive Speed Error!':28); end;
                  For j := 1 to maxCom do Com[j] := ' '; j := 1;
                  REPEAT read(f,Com[1]); UNTIL Com[1]<>' ';
                  WHILE ((not eoln(f)) and (j<maxCom)) do begin
                        j := j+1; read(f,Com[j]); end;
                  Drmax := Drmax+1; i := i+1; end; end;
               readln(f); Red; read(f,ch); end; {While}
           For i := 1 to Drmax do begin Nr := 0;
               For j := 1 to Pumax do
                   If PrefPost[j].DrId=Dpost[i].Id then Nr := 1;   
               If (Nr<>1) then begin writeln;
                  write('Drive':6,IdS2(Dpost[i].Id div 100):4);
                  write(NrS2(Dpost[i].Id mod 100):2);
                  writeln('Pumpless Drive!':20); Gerror; end; end;
         END;   {ReadDrive}
 
        PROCEDURE DriveSort;
         VAR i,z,Znr,Tmp,k,Kmax,Kmaxsum : integer;
             Rad : array[1..99] of integer;
             Klar : Boolean;
         BEGIN
          Kmaxsum := 0;
          For z := 1 to Zonmax do begin Znr := ZonId[z];
              k := 0; Kmax := 0;
              For i := 1 to Drmax do
              If (Dpost[i].Id  div 100)=Znr then begin
                  k := k+1; Rad[k] := i; end;         
              Kmax := k;
              If Kmax>1 then begin 
                 REPEAT k := 0; Klar := true;   
                  REPEAT k := k+1; 
                   If (Dpost[Rad[k]].Id>Dpost[Rad[k+1]].Id) 
                      then begin Klar := false; Tmp := Rad[k];
                         Rad[k] := Rad[k+1]; Rad[k+1] := Tmp; end;
                  UNTIL (k=(Kmax-1));
                 UNTIL Klar; end; {If Kmax}      
              For k := 1 to Kmax do begin i := Kmaxsum+k;
                  DrivePost[i] := Dpost[Rad[k]]; 
                  Drpek[DrivePost[i].Id] := i; end;
              Kmaxsum := Kmaxsum+Kmax; end; {For z}
         END; {DriveSort}
   
      BEGIN
       ReadDrive; DriveSort; 
      END; {Drivedata}  

   PROCEDURE Pumpdata;
     CONST  maxI = 20;
     VAR    Pu,Ref,i,Nr,t,Pty : integer;
            Nno,Pme: real;
            QoFlag : Boolean;
            RefAll : array[1..99] of integer;
            Imax : array[1..maxPperf] of integer;
            PrefPek : array[1..maxPperf] of integer;
            Qp,Hp,Pp,Nh : array[1..maxPperf,1..maxI] of real;
            Dum : char;

     PROCEDURE PumpCurves;
       VAR i,j,Pr,Ib,Ie,Ikb,Ike : integer;
           Eta,Emax,Q,dQ,Qemax,Qe,Qx,Nx,Ap,dFHb,dFHe,dFMb,dFMe,
           Qmax,Qmin,dWW,dW,Qtol : real;
           WH,WM : array[1..9,0..maxAp] of real;
           f1 : text;

       FUNCTION PumpHp (Pr : integer; Q : real) : real;
         VAR p,i : integer;
             Hpu : real;
         BEGIN
           For i := 1 to Imax[Pr] do
               If (Q>=Qp[Pr,i]) then p := i;
           If (p=Imax[Pr]) then p := Imax[Pr]-1;
           Hpu := (Hp[Pr,p+1]-Hp[Pr,p])/(Qp[Pr,p+1]-Qp[Pr,p]);
           PumpHp := Hp[Pr,p]+Hpu*(Q-Qp[Pr,p]);
         END; { PumpHp }

       FUNCTION PumpPp (Pr:integer; Q : real) : real;
         VAR p,i : integer;
             Ppu : real;
         BEGIN
           For i := 1 to Imax[Pr] do
               If (Q>=Qp[Pr,i]) then p := i;
           If (p=Imax[Pr]) then p := Imax[Pr]-1;
           Ppu := (Pp[Pr,p+1]-Pp[Pr,p])/(Qp[Pr,p+1]-Qp[Pr,p]);
           PumpPp := Pp[Pr,p]+Ppu*(Q-Qp[Pr,p]);
         END; { PumpPp }

       FUNCTION PumpNh (Pr:integer; Q : real) : real;
         VAR p,i : integer;
             Nhu : real;
         BEGIN
           For i := 1 to Imax[Pr] do
               If (Q>=Qp[Pr,i]) then p := i;
           If (p=Imax[Pr]) then p := Imax[Pr]-1;
           Nhu := (Nh[Pr,p+1]-Nh[Pr,p])/(Qp[Pr,p+1]-Qp[Pr,p]);
           PumpNh := Nh[Pr,p]+Nhu*(Q-Qp[Pr,p]);
         END; { PumpNh }

   FUNCTION FHex (Pr,Iex : integer; Nx : real) : real;
     VAR Qe,Qex,He,Hex : real;
     BEGIN
       With PumpNom[Pr] do begin
         Qe  := Nx*(sin((Iex-1)*dAp)/cos((Iex-1)*dAp))*Qnom;
         Qex := Nx*(sin(Iex*dAp)/cos(Iex*dAp))*Qnom;
         He  := FH[Pr,Iex-1]*(sqr(Nx)+sqr(Qe/Qnom))*Hnom;
         Hex := He+(Hp[Pr,Imax[Pr]]-He)/(Qp[Pr,Imax[Pr]]-Qe)*(Qex-Qe);
         FHex := (Hex/Hnom)/(sqr(Nx)+sqr(Qex/Qnom));
       end; {With}
     END;  { FHex }

   FUNCTION FMex (Pr,Iex : integer; Nx : real) : real;
     VAR Qe,Qex,Me,Mex,MImax : real;
     BEGIN
       With PumpNom[Pr] do begin
         Qe    := Nx*(sin((Iex-1)*dAp)/cos((Iex-1)*dAp))*Qnom;
         Qex   := Nx*(sin(Iex*dAp)/cos(Iex*dAp))*Qnom;
         Me    := FM[Pr,Iex-1]*(sqr(Nx)+sqr(Qe/Qnom))*Mnom;
         MImax := Pp[Pr,Imax[Pr]]*30*1000/Pii/Nnom;
         Mex   := Me+(MImax-Me)/(Qp[Pr,Imax[Pr]]-Qe)*(Qex-Qe);
         FMex  := (Mex/Mnom)/(sqr(Nx)+sqr(Qex/Qnom));
       end; {With}
     END;  { FMex }

       BEGIN  { PumpCurves }
         reset(f1,Pumps); readln(f1);
         For i := 0 to maxAp do begin
             For j := 1 to 9 do read(f1,WH[j,i],WM[j,i]);
                 readln(f1); end;
         Close(f1);
         For Pr := 1 to Pperfmax do begin With PumpNom[Pr] do begin
             Qmax := Qp[Pr,Imax[Pr]]; Qmin := 0; Emax := 0;
             Qtol := Qmax/200;
             REPEAT dQ := (Qmax-Qmin)/10; Q := Qmin;
               REPEAT Q := Q+dQ;
                      Eta := RaNom*Q*PumpHp(Pr,Q)/PumpPp(Pr,Q);
                      If Eta>Emax then begin Emax := Eta; Qemax := Q; end;
               UNTIL  ( Q>=Qmax);
               Qmin := Qemax-dQ; Qmax := Qemax+dQ;
             UNTIL (abs(dQ)<Qtol);
             Qnom := Qemax; Hnom := PumpHp(Pr,Qnom);
             Pnom := PumpPp(Pr,Qnom); Mnom := Pnom*1000/Pii/Nnom*30;
             NHnom := PumpNh(Pr,Qnom);
{writeln('Perf=':5,PrefPek[Pr]:3,'Qnom=':7,Qnom:6:4,'dQ=':5,dQ:6:4,'Qmax=':7,Qp[Pr,Imax[Pr]]:6:4,'Imax=':6,Imax[Pr]:1);}
             If (Qp[Pr,Imax[Pr]]-Qnom)<(10*dQ) then begin writeln;
                write('Perf':5,PrefPek[Pr]:3);
                writeln('Pump Perf, Qmax  Error!':28); Gerror; end;
             For i := 0 to maxAp do begin FH[Pr,i] := WH[Ptyp,i];
                 FM[Pr,i] := WM[Ptyp,i]; FN[Pr,i] := 1; end;
             Ib := 0; Nx := 1; Qe := Qp[Pr,Imax[Pr]];
             Qx := Qe/Qnom; Ap := arctan(Qx/Nx); Ie := trunc(Ap/dAp);
             For i := Ib to Ie do begin
                 Q := Nx*(sin(i*dAp)/cos(i*dAp))*Qnom; Qx := Q/Qnom;
                 FH[Pr,i] := PumpHp(Pr,Q)/Hnom/(sqr(Nx)+sqr(Qx));
                 FM[Pr,i] := PumpPp(Pr,Q)/Pnom/(sqr(Nx)+sqr(Qx));
                 FN[Pr,i] := PumpNh(Pr,Q)/NHnom/(sqr(Nx)+sqr(Qx)); end;
             Ikb := maxAp-12; Ike := Ie+Ie div 2;
             If Ike>22 then Ike := 22;
             dFHb := FH[Pr,Ib]-WH[Ptyp,Ib];
             dFMb := FM[Pr,Ib]-WM[Ptyp,Ib];
             If abs(dFHb)>0.10 then begin writeln;
                write('Pump Performance Curve Nr ':31,PrefPek[Pr]:2);
                writeln('is inconsistent with ':22);
                write('selected Pump Type!  (Q=0)':31);
                writeln('Warning only!':24); end;
             For i := Ikb to maxAp do begin
                 FH[Pr,i] := WH[Ptyp,i]+dFHb*(i-Ikb)/(maxAp-Ikb);
                 FM[Pr,i] := WM[Ptyp,i]+dFMb*(i-Ikb)/(maxAp-Ikb); end;
             FH[Pr,Ie+1] := FHex(Pr,Ie+1,Nx); FM[Pr,Ie+1]:=FMex(Pr,Ie+1,Nx);
             dFHe := FH[Pr,Ie+1]-WH[Ptyp,Ie+1];
             dFMe := FM[Pr,Ie+1]-WH[Ptyp,Ie+1];
             If dFHe<0 then dWW := WH[Ptyp,Ie+1]-WH[Ptyp,Ie+2]
                       else dWW := WH[Ptyp,Ie]-WH[Ptyp,Ie+1];
             dW := abs(dFHe)*dAp/sqrt(sqr(dAp)+sqr(dWW));
             If abs(dW)>0.06 then begin writeln;
                write('Pump Performance Curve Nr ':31,PrefPek[Pr]:2);
                writeln('is inconsistent with ':22);
                write('selected Pump Type! (Qmax)':31);
                writeln('Warning only!':24); end;
             For i := Ie+2 to Ike do begin
                 FH[Pr,i] := WH[Ptyp,i]+dFHe*(Ike-i)/(Ike-(Ie+1));
                 FM[Pr,i] := WM[Ptyp,i]+dFMe*(Ike-i)/(Ike-(Ie+1)); end;
         end; { With } end; { Pperfmax }
       END;    { PumpCurves }

     BEGIN  { Pumpdata }
      For i := 1 to maxPperf do PumpNom[i].Pref := 0;
      For i := 1 to 99 do PuNomPek[i] := 0;
      For i := 1 to 99 do RefAll[i] := 0;
      readln(f); Red; read(f,ch); Pu := 0;
      WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
      WHILE (ch=' ') do begin  t := 0;
        REPEAT read(f,Dum); t := t+1; UNTIL (f^<>' ');
{}      If (t<12) then begin read(f,Nr); i := 0;
{}         If Nr>0 then begin read(f,Nno,Pty,Pme); Pu := Pu+1; end; end;
        If (Nr=0) then begin readln(f); Red; read(f,ch); end
        else begin i := i+1; PuNomPek[Nr] := Pu; PrefPek[Pu] := Nr;
             With PumpNom[Pu] do begin
             Nnom := Nno; Ptyp := Pty; Pmek := Pme; Imax[Pu] := i;
             RaNom := 1000; NyNom := 1E-06; Pref := Nr;
             readln(f,Qp[Pu,i],Hp[Pu,i],Pp[Pu,i],Nh[Pu,i]); Red;
             read(f,ch); RefAll[Nr] := 1; end; end;
      end; {While}  Pperfmax := Pu;
      For Pu := 1 to Pumax do begin Ref := PrefPost[Pu].Pref;
          If not (RefAll[Ref]>0) then begin ErrorFlag := true;
             Znr := PrefPost[Pu].Id div 100;
             Nr := PrefPost[Pu].Id mod 100;
             write('Pump':5,IdS2(Znr):4,NrS2(Nr):2);
             writeln('Pump Ref,   Perf Error!':28); Gerror; end; end;
      For i := 1 to Pperfmax do begin
          With PumpNom[i] do begin QoFlag := false;
          If (Qp[i,1]=0) then begin Hpqo := Hp[i,1];
                              QoFlag := true; end; end;
          If not QoFlag then begin write('Perf':5,i:3,' ':2);
             writeln('Pump Perf, Qpump Error!':28); Gerror; end;
          end;
      PumpCurves;
     END;  { Pumpdata }

       PROCEDURE Accdata;
         VAR  Nr,i,Rid : integer;
              Dum : char;
              Typ : S2; 
         BEGIN
          readln(f); Red; read(f,ch); i := 1;
          WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
          WHILE (ch=' ') do begin
           Rid := ReadId(f); Nr := Rid mod 100;
           If (Nr=0) then begin readln(f); Red; read(f,ch); end
           else begin With AcPost[i] do begin
                read(f,Avp,Avm,Da);
                REPEAT read(f,Dum); UNTIL Dum<>' ';
                Dum := Uchar(Dum); Typ[1] := Dum;
                read(f,Dum); Dum := Uchar(Dum); Typ[2] := Dum;
                If Typ='ST' then begin Atyp := 'S';
                   Za := 0; Gvol := 0; Npol:= 0;
                   readln(f); Red; Read(f,ch); end;
                If Typ='GC' then begin Atyp := 'G';
                   readln(f,Za,Gvol,Npol); Red; read(f,ch); end;
                Com := 'No Comment  ';   
                Id := Rid; i := i+1; end; end;
           end; Acmax := i-1;
         END;   { Accdata }

      PROCEDURE Checkdata;
         VAR Nr,i,Rid : integer;
         BEGIN
           WHILE not(ch=' ') do begin readln(f); Red; read(f,ch); end;
           While (ch=' ') do begin
              For i := 1 to maxCheck do begin
                  Rid := ReadId(f); Nr := Rid mod 100;
                  With CheckPost[i] do begin
                  Id := Rid; W := Pipek[Id];
                  REPEAT read(f,BE); UNTIL not (BE=' ');
                  If (BE<>'B') and (BE<>'E') then begin writeln;
                     writeln('Check Points, File Error!':30); Gerror; end;
                  end; end;
              readln(f); Red; read(f,ch); end;
         END;   { Checkdata }

        PROCEDURE Alarmdata;
         VAR Nr,i,Rid : integer;
         BEGIN
           i := 0;
           WHILE not(ch=' ') do begin readln(f); Red; read(f,ch); end;
           While (ch=' ') do begin
               Rid := ReadId(f); Nr := Rid mod 100;
               If Nr>0 then begin i := i+1; With AlarmPost[i] do begin
                  REPEAT read(f,BE); UNTIL(BE<>' ');
                  Id := Rid; 
                  If (Pipek[Id]=0) then begin ErrorFlag := true;
                     write('Pipe':5,IdS2(Rid div 100):3,NrS2(Nr):3);
                     writeln('Alarm,      Decl Error!':28); end;
                  read(f,Zpi,bar);
                  REPEAT read(f,HL); UNTIL (HL<>' ');
                  If ((HL<>'H') and (HL<>'L')) or
                     ((BE<>'B') and (BE<>'E')) then begin ErrorFlag := true;
                     write('Pipe':5,IdS2(Rid div 100):2,NrS2(Nr):3);
                     writeln('Alarm  B/E, H/L, Error!':28); end;
                  REPEAT read(f,Lab[1]); UNTIL (Lab[1]<>' ');
                  read(f,Lab[2]);
                  end; end;
              readln(f); Red; read(f,ch); end;
           Alarmmax := i;
         END;   { Alarmdata }

     PROCEDURE ConnEnr;
      VAR Cn,i,Err : integer;
      BEGIN
       For Cn := 1 to Cnmax do begin With CnPost[Cn] do begin
           Err := 0;
           CASE Ecod OF
         1..8: begin Err := 1; end;
            9: begin If RvPerfPek[Enr]>0 then begin
                        Enr := RvPerfPek[Enr]; Err := 1; end; end;
        10,11: begin Err := 1; end;
           12: begin For i := 1 to Boilmax do
                         If Boiler[i].Id=Enr then begin
                            Enr := i; Err := Err+1; end; end; 
           13: begin For i := 1 to Acmax do With AcPost[i] do
                     If (Id=Enr) and (Atyp='S') then begin
                        Enr := i; Err := Err+1; end; end;
           14: begin For i := 1 to Acmax do With AcPost[i] do
                     If (Id=Enr) and (Atyp='G') then begin
                        Enr := i; Err := Err+1; end; end;
           END; {Case Ecod}
           If Err<>1 then begin write('Conn':5,IdS2(Id div 100):4);
              writeln(NrS2(Id mod 100):3,'Equipment Error!':20); 
              Gerror; end;
       end; {with} end; {For}
      END; {ConnEnr}

     PROCEDURE LcnEnr;
      VAR s,c,i,Err : integer;
      BEGIN
       For s := 1 to Sumax do
           For c := 1 to Lcnmax[s] do begin With LcnPost[s,c] do begin
               Err := 0;
               CASE Ecod OF
            1..8: begin Err := 1; end;
               9: begin If RvPerfPek[Enr]>0 then begin
                           Enr := RvPerfPek[Enr]; Err := 1; end; end;
           10,11: begin Err := 1; end;
              12: begin For i := 1 to Boilmax do
                            If Boiler[i].Id=Enr then begin
                               Enr := i; Err := Err+1; end; end;
              13: begin For i := 1 to Acmax do With AcPost[i] do
                            If (Id=Enr) and (Atyp='S') then begin
                               Enr := i; Err := Err+1; end; end;
              14: begin For i := 1 to Acmax do With AcPost[i] do
                            If (Id=Enr) and (Atyp='G') then begin
                               Enr := i; Err := Err+1; end; end;
             END; {Case Ecod}
           If Err<>1 then begin write('Lcon':5,IdS2(SubId[s] div 10):4);
              writeln(SubId[s] mod 10:1,NrS2(Id):3,'Equipment Error!':20);
              Gerror; end;
           end; {For c} end; {with}
      END; {LcnEnr}

   PROCEDURE Linksum (s : integer);
     VAR b,c,j,i,Link,l : integer;
         LinkCheck : array[1..99] of integer;
     BEGIN
        For i := 1 to 99 do LinkCheck[i] := 0;
        Limax[s] := 0; l := 0;
        For b := 1 to Brmax[s] do begin Link := abs(BorPost[s,b].Li);
            If not (LinkCheck[Link]>0) then begin
               l := l+1; LinkCheck[Link] := 1;
               Lipek[s,l] := Link; end; end;
        For i := 1 to Liomax[s] do begin Link := LioPost[s,i].Li;
            If not (LinkCheck[Link]>0) then begin
               l := l+1; LinkCheck[Link] := 1;
               Lipek[s,l] := Link; end; end;
        For c := 1 to Lcnmax[s] do begin With LcnPost[s,c] do begin
            If (Lto>0) and (LinkCheck[Lto]<1) then begin
               l := l+1; LinkCheck[Lto] := 1;
               Lipek[s,l] := Lto; end;
            If (Lfr>0) and (LinkCheck[Lfr]<1) then begin
               l := l+1; LinkCheck[Lfr] := 1;
               Lipek[s,l] := Lfr; end;
            end; end;
        For j := 1 to Ljnmax[s] do begin With LjnPost[s,j] do begin
            For i := 1 to 4 do begin Link := abs(Li[i]);
                If (Link>0) and (LinkCheck[Link]<1) then begin
                   l := l+1; LinkCheck[Link] := 1;
                   Lipek[s,l] := Link; end;
            end; end; end;
        For c := 1 to Lcsmax[s] do begin With LcsPost[s,c] do begin
            For i := 1 to 8 do begin Link := abs(Li[i]);
                If (Link>0) and (LinkCheck[Link]<1) then begin
                   l := l+1; LinkCheck[Link] := 1;
                   Lipek[s,l] := Link; end;
            end; end; end;
        For c := 1 to Lexmax[s] do begin With LexPost[s,c] do begin
            Link := pTo;
            If (LinkCheck[Link]<1) then begin l := l+1;
               LinkCheck[Link] := 1; Lipek[s,l] := Link; end;
            Link := pFr;
            If (LinkCheck[Link]<1) then begin l := l+1;
               LinkCheck[Link] := 1; Lipek[s,l] := Link; end;
            Link := sTo;
            If (LinkCheck[Link]<1) then begin l := l+1;
               LinkCheck[Link] := 1; Lipek[s,l] := Link; end;
            Link := sFr;
            If (LinkCheck[Link]<1) then begin l := l+1;
               LinkCheck[Link] := 1; Lipek[s,l] := Link; end;
            end; end;
        Limax[s] := l;
     END; {Linksum}

 PROCEDURE Zpipe;
   VAR i,j,s : integer;
   BEGIN
    For i := 1 to Pimax do PipePost[i].Zp[0] := 0.0;
    For i := 1 to Pimax do PipePost[i].Zp[1] := 0.0;
    For i := 1 to Pimax do PipePost[i].Xp[0] := 0.0;
    For i := 1 to Pimax do PipePost[i].Xp[1] := 0.0;
    For i := 1 to Pimax do PipePost[i].Yp[0] := 0.0;
    For i := 1 to Pimax do PipePost[i].Yp[1] := 0.0;
    For i := 1 to Cnmax do With CnPost[i] do begin
        PipePost[Pto].Zp[1] := Elev;
        PipePost[Pfr].Zp[0] := Elev;
        PipePost[Pto].Xp[1] := Xkoord;
        PipePost[Pfr].Xp[0] := Xkoord;
        PipePost[Pto].Yp[1] := Ykoord;
        PipePost[Pfr].Yp[0] := Ykoord;
    end;	
   For i := 1 to Jnmax do  With JnPost[i] do
           For j := 1 to 4 do begin
               If p[j]<0 then PipePost[-p[j]].Zp[0] := Elev;
               If p[j]>0 then PipePost[p[j]].Zp[1] := Elev;
               If p[j]<0 then PipePost[-p[j]].Xp[0] := Xkoord;
               If p[j]>0 then PipePost[p[j]].Xp[1] := Xkoord;
               If p[j]<0 then PipePost[-p[j]].Yp[0] := Ykoord;
               If p[j]>0 then PipePost[p[j]].Yp[1] := Ykoord;
           end;
   For i := 1 to Csmax do  With CsPost[i] do
           For j := 1 to 8 do begin
               If p[j]<0 then PipePost[-p[j]].Zp[0] := Elev;
               If p[j]>0 then PipePost[p[j]].Zp[1] := Elev;
               If p[j]<0 then PipePost[-p[j]].Xp[0] := Xkoord;
               If p[j]>0 then PipePost[p[j]].Xp[1] := Xkoord;
               If p[j]<0 then PipePost[-p[j]].Yp[0] := Ykoord;
               If p[j]>0 then PipePost[p[j]].Yp[1] := Ykoord;
           end;       
   For j := 1 to Sumax do 
      For i := 1 to Brmax[j]  do  With BorPost[j,i] do begin
               If pi<0 then PipePost[-pi].Zp[0] := Elev;
               If pi>0 then PipePost[pi].Zp[1] := Elev;
               If pi<0 then PipePost[-pi].Xp[0] := Xkoord;
               If pi>0 then PipePost[pi].Xp[1] := Xkoord;
               If pi<0 then PipePost[-pi].Yp[0] := Ykoord;
               If pi>0 then PipePost[pi].Yp[1] := Ykoord;
      end;
    For i := 1 to Iomax do With IoPost[i] do begin
               If (BE = 'I') or (BE = 'T') then PipePost[pi].Zp[0] := Elev;
               If (BE = 'O') or (BE = 'F') then PipePost[pi].Zp[1] := Elev;
               If (BE = 'I') or (BE = 'T') then PipePost[pi].Xp[0] := Xkoord;
               If (BE = 'O') or (BE = 'F') then PipePost[pi].Xp[1] := Xkoord;
               If (BE = 'I') or (BE = 'T') then PipePost[pi].Yp[0] := Ykoord;
               If (BE = 'O') or (BE = 'F') then PipePost[pi].Yp[1] := Ykoord;
    end;	
   END; {Zpipe} 


    PROCEDURE Zvalve;
      VAR i,j,s : integer;
      BEGIN
       For i := 1 to Vamax do VrefPost[i].Zv := 0.0;
       For i := 1 to Cnmax do With CnPost[i] do
           If Ecod=10 then VrefPost[Vapek[Enr]].Zv := Elev;
       For s := 1 to Sumax do
           For i := 1 to Lcnmax[s] do With LcnPost[s,i] do
               If Ecod=10 then VrefPost[Vapek[Enr]].Zv := Elev;
       For i := 1 to Jnmax do  With JnPost[i] do
           For j := 1 to 4 do
               If Vnr[j]>0 then VrefPost[Vapek[Vnr[j]]].Zv := Elev;
       For s := 1 to Sumax do
           For i := 1 to Ljnmax[s] do With LjnPost[s,i] do
               For j := 1 to 4 do
                   If Vnr[j]>0 then VrefPost[Vapek[Vnr[j]]].Zv := Elev;
       For i := 1 to Csmax do  With CsPost[i] do
           If Vnr>0 then VrefPost[Vapek[Vnr]].Zv := Elev;
       For s := 1 to Sumax do
           For i := 1 to Lcsmax[s] do With LcsPost[s,i] do
               If Vnr>0 then VrefPost[Vapek[Vnr]].Zv := Elev;
      END; {Zvalve}

    PROCEDURE Zpump;
      VAR i,s : integer;
      BEGIN
       For i := 1 to Pumax do PrefPost[i].Zp := 0.0;
       For i := 1 to Cnmax do With CnPost[i] do
           If Ecod=11 then PrefPost[Pupek[Enr]].Zp := Elev;
       For s := 1 to Sumax do
           For i := 1 to Lcnmax[s] do With LcnPost[s,i] do
               If Ecod=11 then PrefPost[Pupek[Enr]].Zp := Elev;
      END; {Zpump}

      BEGIN  { Config }
        Connect(f,Fil[1],'R'); Radantal := 1;
        If Felkod<>0 then begin writeln;
           writeln('File not found:':33,Fil[1]:17); Gerror; end;  
        ErrorFlag := false; FlYN := 'N'; ConFlag := false;
        Idstrings; Miscdata; Liqdata; TempInit(Tinit); Pipedata;
        Conndata; Juncdata; Crossdata; Bordata; Lcndata;
        Ljndata; Lcsdata; Bounddata; HeatExdata; Boilerdata;
        Loaddata; RVdata; Vrefdata; Valvedata; Prefdata; Drivedata;
        Pumpdata; Accdata; Checkdata; Alarmdata;
        Close(f); x1 := 0; x2 := 0; x3 := 0;
        ConnEnr; LcnEnr;
        For i := 1 to Pumax do begin s := PrefPost[i].DrId;
            If (s=0) then begin writeln; ErrorFlag := true;
               Znr := PrefPost[i].Id div 100;
               l := PrefPost[i].Id mod 100;
               writeln('Pump':5,IdS2(Znr):4,NrS2(l):2,'Pump Drive Error!'); end
            else PrefPost[i].Np := DrivePost[Drpek[s]].Ndr; end;
        If ErrorFlag then Gerror;
        writeln('Data read from : ':32,Fil[1]:maxCh1);
        For s := 1 to Sumax do Linksum(s);
        Zvalve; Zpump;zpipe;
        VaCtrlmax := 0; DrCtrlmax := 0;
        dHtol := Ftol*Htol; dQtol := Ftol*Qtol;
        VaCtrlmax := 0; DrCtrlmax := 0;
        dHtol := Ftol*Htol; dQtol := Ftol*Qtol;
        For i := 1 to Pimax do Api[i] := Pii*sqr(PipePost[i].D)/4;
        Initiate(Qinit,Hinit,Tinit,AaStart,LaStart);
        If CloseMax>0 then ClosePipes;
        If not NewCaseFlag then Checksystem; 
        ConFlag := true; SetFlag := false; ConvFlag := false;
        END; { Config }
 
   PROCEDURE EchoPrint;
     VAR i,Alt,Num : integer;
         EchoFlag : Boolean;
  
     PROCEDURE EchoPipes;
       VAR i,Nr,k,Sel,j,Un,Znr,p : integer;
           Dx : real;
           LinePek : array[1..maxPi] of integer;
           YN : char;
           CloseFlag : Boolean;

       PROCEDURE HeadLine;
        BEGIN
          write('Line':10,'ZnNr':8,'L m':7,'D m':8,'Ks mm':7,'Zeta':6);
          writeln('K W/m,C':9,'Comments':10); writeln;
        END; {Headline}

       BEGIN
         For i := 1 to maxPi do LinePek[i] := 0;
         write('PIPE DATA':30); Zstr; writeln; Num := 0;
         For i := 1 to Pimax do begin With PipePost[i] do begin
             If Str[1]='+' then SeCom(Com,Str,Len)
                           else SeZon(IdS2(Id div 100),Str,Len);
             If Pflag then begin
                Num := Num+1; LinePek[Num] := i; 
             end; end; end;
         If Num=0 then begin
            writeln('No Pipes to display !':36); Stop; end;
         If (Num>0) then begin 
            REPEAT Aclear; Headline; k := 1;
            For i := 1 to Num do begin p := LinePek[i];
                With PipePost[p] do begin
                Znr := Id div 100; Nr := Id mod 100; 
                CloseFlag := false;
                For j := 1 to CloseMax do
                    If (SelPipe[j]=p) then CloseFlag := true;
                If CloseFlag then write(i:9,'Clo':4)
                             else write(i:9,'   ':4);
                write(IdS2(Znr):3,NrS2(Nr):2);
                write(L:9:1,D:7:3,Ks*1000:6:2,Zeta:6:1,Kval:8:2);
                writeln(Com:15); k := k+1;  
                If ((k mod ContLines)=0) then begin
                        Paus; Headline; k := 1; end;
            end; end;  
            writeln; writeln('Select Line, 0 for exit':40);
            Sel := LineNr(Num);
            If Sel>0 then begin p := LinePek[Sel];
               With PipePost[p] do begin
               Znr := Id div 100; Nr := Id mod 100; end;
               write('Pipe':20,IdS2(Znr):3,NrS2(Nr):2);
               write('Close  Y/N    Set Diam  D : ':35); read(YN);
               readln; YN := Uchar(YN);
               If ((YN<>'Y') and (YN<>'N') and (YN<>'D')) then YN := 'X';
               CASE YN OF
               'Y': begin CloseFlag := false;
                    For i := 1 to CloseMax do
                       If (SelPipe[i]=p) then CloseFlag := true;
                    If not CloseFlag then begin CloseMax := CloseMax+1;
                       SelPipe[CloseMax] := p;
                       ClosePipes; ConvFlag := false; end; end;
               'N': begin Un := CloseMax+1;
                    For i := 1 to CloseMax do
                        If (SelPipe[i]=p) then Un := i;
                    If Un<=CloseMax then UnClosePipe(Un); end;
               'D': begin With PipePost[p] do begin 
                    REPEAT write('New D : ':60); Dx := ReadRl;
                    UNTIL not ReadError;
                    D := Dx; Api[p] := Pii*sqr(Dx)/4; end; end;
               'X': begin end;
               END; {case YN}
               Initiate(Qinit,Hinit,Tinit,AaStart,LaStart);
            end; {If Sel}
            UNTIL (Sel=0); end; {If Num>0}
       END; { EchoPipes }

     PROCEDURE Echoconns;
      CONST Dum = ' -----'; maxPek = maxSu*maxLcn; 
      VAR i,Nr,Pt,Er,Pf,s,c,k,Num,Znr,Ptnr,Pfnr,z,Zon,b, 
          Comax,Lcomax : integer;
          NodPek : array[1..maxCn] of integer;
          Snet : array[1..maxSu] of integer;
          Cpek : array[1..maxPek] of integer;
    
      PROCEDURE HeadLine;
       BEGIN
        write('Zon Nr':13,'Elev':6,'P to':6,'Etyp':5,'Enr':4);
        writeln('Value':7,'P fr':6,'Comments':10); writeln;
       END; {Headline}

      BEGIN
       Num := 0;
       write('PIPE/LINK CONNECTIONS':35); Zstr; writeln;
       For i := 1 to Cnmax do begin With CnPost[i] do begin
           Znr := Id div 100; Nr := Id mod 100;
           If Str[1]='+' then SeCom(Com,Str,Len)
                         else SeZon(IdS2(Znr),Str,Len);
           If Pflag then begin Num := Num+1;
              NodPek[Num] := i; end; end; end;      
       Comax := Num; Num := 0;
       For s := 1 to Sumax do begin
           Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
           For c := 1 to Lcnmax[s] do begin
               With LcnPost[s,c] do begin
               If Str[1]='+' then SeCom(Com,Str,Len)
                             else SeZon(IdS2(Znr),Str,Len);
               If Pflag then begin Num := Num+1;
                  Snet[Num] := s; Cpek[Num] := c; end; 
       end; end; end;        
       Lcomax := Num;
       If (Comax+Lcomax)>0 then begin Headline; k := 1; end;
       For z := 1 to Zonmax do begin Zon := ZonId[z];   
           For c := 1 to Comax do begin i := NodPek[c];
           With CnPost[i] do begin
           Znr := Id div 100; Nr := Id mod 100;
           If (Zon=Znr) then begin               
              Pt := PipePost[Pto].Id mod 100;
              Ptnr := PipePost[Pto].Id div 100;
              Pf := PipePost[Pfr].Id mod 100;
              Pfnr := PipePost[Pfr].Id div 100;
              If Enr>0 then Er := Enr mod 100 else Er := 0;
              If Ecod=9 then Er := RvNr[Enr];
              If Ecod=12 then 
                 For b := 1 to Boilmax do 
                     If b=Enr then Er := Boiler[b].Id mod 100;      
              If ((k mod ContLines)=0) then begin
                   Paus; Headline; k := 1; end;
              write(IdS2(Znr):9,NrS2(Nr):4,Elev:6:1);
              write(IdS2(Ptnr):4,NrS2(Pt):2,Eqtyp[Ecod]:5,NrS2(Er):3);
              CASE Ecod OF
              1,7,8 : write(Value:8:4);
                  2 : write(Value:8:2);
              3,4,5 : write(Value:8:1);
 6,9,10,11,12,13,14 : write(Dum:8);
              END;
              writeln(IdS2(Pfnr):4,NrS2(Pf):2,Com:15); 
              k := k+1; end; end; end; {For c}
           For i := 1 to Lcomax do begin s := Snet[i];
               Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
               If (Zon=Znr) then begin c := Cpek[i];         
                  With LcnPost[s,c] do begin
                  If Enr>0 then Er := Enr mod 100 else Er := 0;
                  If Ecod=9 then Er := RvNr[Enr];                 
                  If Ecod=12 then 
                     For b := 1 to Boilmax do 
                         If b=Enr then Er := Boiler[b].Id mod 100;      
                  If ((k mod ContLines)=0) then begin
                       Paus; Headline; k := 1; end;
                  write(IdS2(Znr):9,Nr:1,NrS2(Id):3);
                  write(Elev:6:1,NrS2(Lto):6,Eqtyp[Ecod]:5,NrS2(Er):3);
                  CASE Ecod OF
              1,7,8 : write(Value:8:4);
                  2 : write(Value:8:2);
              3,4,5 : write(Value:8:1);
 6,9,10,11,12,13,14 : write(Dum:8);
                  END;
                  writeln(NrS2(Lfr):6,Com:15);
                  k := k+1; end; end; end; {For i}
       end; {For z}        
       If (Comax+Lcomax)=0 then writeln('No Connections to display !':41);
       Stop;
      END;  { EchoConns }

     PROCEDURE EchoJuncs;
      CONST maxPek = maxSu*maxLjn;
      VAR i,j,Nr,Pi,s,c,k,Znr,Pnr,Num,Zon,z,Jumax,Ljumax : integer;
          NodPek : array[1..maxJn] of integer;
          Snet : array[1..maxSu] of integer;
          Jpek : array[1..maxPek] of integer;
       
      PROCEDURE HeadLine;
       BEGIN
         write('Zon Nr':14,'Elev':6,'P..1':7,'V1':3,'P..2':7,'V2':3);
         writeln('P..3':7,'V3':3,'P..4':7,'V4':3,'Comments':10); writeln;
       END; {Headline}

      BEGIN
       Num := 0;
       write('PIPE/LINK JUNCTIONS':35); Zstr; writeln;
       For i := 1 to Jnmax do begin With JnPost[i] do begin
           Znr := Id div 100; Nr := Id mod 100; 
           If Str[1]='+' then SeCom(Com,Str,Len)
                         else SeZon(IdS2(Znr),Str,Len);
           If Pflag then begin Num := Num+1;
              Nodpek[Num] := i; end;
           end; end;
       Jumax := Num; Num := 0;
       For s := 1 to Sumax do begin
           Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
           For c := 1 to Ljnmax[s] do begin With LjnPost[s,c] do begin
               If Str[1]='+' then SeCom(Com,Str,Len)
                             else SeZon(IdS2(Znr),Str,Len);
               If Pflag then begin Num := Num+1;
                  Snet[Num] := s; Jpek[Num] := c; end; 
           end; end; end;
        Ljumax := Num;   
        If (Jumax+Ljumax)>0 then begin Headline; k := 1; end;
        For z := 1 to Zonmax do begin Zon := ZonId[z];   
            For c := 1 to Jumax do begin i := NodPek[c];
            With JnPost[i] do begin
            Znr := Id div 100; Nr := Id mod 100;
            If (Zon=Znr) then begin               
               If ((k mod ContLines)=0) then begin
                    Paus; Headline; k := 1; end;
               write(IdS2(Znr):10,NrS2(Nr):4,Elev:6:1);
               For j := 1 to 4 do begin Pi := p[j];
                   If abs(Pi)>0 then Pnr := PipePost[abs(Pi)].Id div 100;
                   If Pi>0 then begin Pi := PipePost[Pi].Id mod 100; 
                      write(' ':3,IdS2(Pnr):2,NrS2(Pi):2); end;
                   If Pi=0 then write(' ':3,'0000':4);
                   If Pi<0 then begin Pi := -(PipePost[abs(Pi)].Id mod 100);
                      write('-':3,IdS2(Pnr):2,NrS2(Pi):2); end;            
                   write(NrS2(Vnr[j] mod 100):3); end;
                   writeln(Com:14); k := k+1; end; end; end;
            For i := 1 to Ljumax do begin s := Snet[i];
                Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                c := Jpek[i]; With LjnPost[s,c] do begin
                If (Zon=Znr) then begin
                   If ((k mod ContLines)=0) then begin
                        Paus; Headline; k := 1; end;
                   write(IdS2(Znr):10,Nr:1,NrS2(Id):3,Elev:6:1);
                   For j := 1 to 4 do 
                       write(NrS3(Li[j]):7,NrS2(Vnr[j] mod 100):3);
                   writeln(Com:14); k := k+1; end; end; end; {For i} 
         end; {For z} 
         If (Jumax+Ljumax)=0 then writeln('No Junctions to display !':41);
         Stop;
       END; { EchoJuncs }

     PROCEDURE EchoCross;
      CONST maxPek = maxSu*maxLcs;       
      VAR i,j,Nr,Pi,Pnr,s,c,k,Znr,Num,Zon,z,Crmax,Lcrmax : integer;
          NodPek : array[1..maxCs] of integer;
          Snet : array[1..maxSu] of integer;
          Cpek : array[1..maxPek] of integer;
 
       PROCEDURE HeadLine;
        BEGIN
          write('Zon Nr':7,'Elev':6,'Va':4,'Pi.1':6,'Pi.2':6);
	  write('Pi.3':6,'Pi.4':6,'Pi.5':6,'Pi.6':6,'Pi.7':6,'Pi.8':6);
          writeln('Comments':11); writeln;
        END; {Headline}

       BEGIN
        Num := 0;
        write('PIPE/LINK CROSS CONNECTIONS':41); Zstr; writeln;
        For i := 1 to Csmax do begin With CsPost[i] do begin
            Znr := Id div 100; Nr := Id mod 100;
            If Str[1]='+' then SeCom(Com,Str,Len)
                          else SeZon(IdS2(Znr),Str,Len);
            If Pflag then begin Num := Num+1;
               NodPek[Num] := i; end;
            end; end;
        Crmax := Num; Num := 0;             
        For s := 1 to Sumax do begin
            Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
            For c := 1 to Lcsmax[s] do begin With LcsPost[s,c] do begin
                If Str[1]='+' then SeCom(Com,Str,Len)
                              else SeZon(IdS2(Znr),Str,Len);
                If Pflag then begin Num := Num+1;
                   Snet[Num] := s; Cpek[Num] := c; end;
            end; end; end;
        Lcrmax := Num;     
        If (Crmax+Lcrmax)>0 then begin HeadLine; k := 1; end;
        For z := 1 to Zonmax do begin Zon := ZonId[z];   
            For c := 1 to Crmax do begin i := NodPek[c];
            With CsPost[i] do begin
            Znr := Id div 100; Nr := Id mod 100;
            If (Zon=Znr) then begin               
               If ((k mod ContLines)=0) then begin
                    Paus; Headline; k := 1; end;
               write(IdS2(Znr):3,NrS2(Nr):4,Elev:6:1);
               write(NrS2(Vnr mod 100):4);
               For j := 1 to 8 do begin Pi := p[j];
                   If abs(Pi)>0 then Pnr := PipePost[abs(Pi)].Id div 100;
                   If Pi>0 then begin Pi := PipePost[Pi].Id mod 100; 
                      write(' ':2,IdS2(Pnr):2,NrS2(Pi):2); end;
                   If Pi=0 then write(' ':2,'0000':4);
                   If Pi<0 then begin Pi := -(PipePost[abs(Pi)].Id mod 100);
                      write('-':2,IdS2(Pnr):2,NrS2(Pi):2); end; end;           
                   writeln(Com:15); k := k+1; end; end; 
            end; {For c}
            For i := 1 to Lcrmax do begin s := Snet[i];
                Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                If (Zon=Znr) then begin
                   c := Cpek[i]; With LcsPost[s,c] do begin 
                   If ((k mod ContLines)=0) then begin
                        Paus; Headline; k := 1; end;
                   write(IdS2(Znr):3,Nr:1,NrS2(Id):3,Elev:6:1);
                   write(NrS2(Vnr mod 100):4);                   
                   For j := 1 to 8 do begin Pi := Li[j]; 
                       If (Pi<>0) then write(' ':2,NrS3(Pi):4);
                       If (Pi=0)  then write(' ':2,'00':4); end;
                   writeln(Com:15); k := k+1; end; end; 
            end; {For i}
        end; {For z}
        If (Crmax+Lcrmax)=0 then writeln('No Cross Connections to display !':47);
        Stop;
       END; { EchoCross }

    PROCEDURE EchoBoBos;
     
     PROCEDURE EchoBounds;
      VAR i,k,Znr,Nr,Num,s : integer;
      
      PROCEDURE HeadLine;
       BEGIN
        write('Pi/Li':13,'I/O':6,'Elev':6,'Temp':7,'Q/P':5,'Value':8);
        writeln('Comment':11); writeln;
       END; {HeadLine}
      
      BEGIN
       Num := 0; k := 0;
       write('PIPE/LINK BOUNDARIES':35); Zstr; writeln; 
       For i := 1 to Iomax do begin With IoPost[i] do begin
           Znr := PipePost[Pi].Id div 100;
           Nr := PipePost[i].Id mod 100;
           If Str[1]='+' then SeCom(Com,Str,Len)
                         else SeZon(IdS2(Znr),Str,Len); 
           If Pflag then begin Num := Num+1;
              If (k=0) and (Num>0) then begin HeadLine; k := 1; end; 
              write(IdS2(Znr):10,NrS2(Nr):2,BE:6,Elev:7:1);
              writeln(Temp:7:1,QP:4,Value:9:4,Com:16); k := k+1;
              If (k mod ContLines)=0 then begin Paus;
                 HeadLine; k := 1; end; end; end; end;
       For s := 1 to Sumax do begin
           Znr := SubId[s] div 10; Nr := SubId[s] mod 10; 
           For i := 1 to Liomax[s] do begin With LioPost[s,i] do begin
               If Str[1]='+' then SeCom(Com,Str,Len)
                             else SeZon(IdS2(Znr),Str,Len);
               If Pflag then begin Num := Num+1;
                  If (k=0) and (Num>0) then begin Headline; k := 1; end;
                  write(IdS2(Znr):10,Nr:1,NrS2(Li):3,BE:4,Elev:7:1);
                  writeln(Temp:7:1,QP:4,Value:9:4,Com:16); k := k+1;
                  If (k  mod ContLines)=0 then begin Paus;  
                     HeadLine; k := 1; end;  
       end; end; end; end; 
       If (Num=0) then writeln('No Pipe/Link Boundaries to display':45);
       Stop;
      END;
      
     PROCEDURE EchoBorders;
       VAR s,b,Bid,Nr,k,Znr,Pznr,Pnr,p : integer;

       PROCEDURE HeadLine;
        BEGIN
          writeln('Sub':13,'Bor':6,'Pipe':7,'Link':7,'Comments':11); writeln;
        END; {Headline}

       BEGIN
         EchoFlag := false; k := 1; Num := 0;
         write('PIPE/LINK BORDERS':35); Zstr; writeln;
         For s := 1 to Sumax do begin
             Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
             For b := 1 to Brmax[s] do begin With BorPost[s,b] do begin
                 If Str[1]='+' then SeCom(Com,Str,Len)
                               else SeZon(IdS2(Znr),Str,Len);
                 If Pflag then begin Num := Num+1;
                    If not EchoFlag then begin HeadLine; EchoFlag := true; end;
                    If ((k mod ContLines)=0) then begin
                        Paus; Headline; k := 1; end;
                    Bid := Id; p := BorPost[s,b].Pi;
                    Pznr := PipePost[abs(p)].Id div 100;
		    Pnr := PipePost[abs(p)].Id mod 100;
                    write(IdS2(Znr):12,Nr:1,NrS2(Bid):5);
                    If p>0 then write(' ':4,IdS2(Pznr):2,NrS2(Pnr):2);
                    If p<0 then write('-':4,IdS2(Pznr):2,NrS2(Pnr):2);
                    writeln(NrS3(Li):6,Com:16);
                    k := k+1; end; end; end; end;
         If Num=0 then writeln('No Pipe/Link Borders to display !':51);
         Stop;
       END;   { EchoBorders }
     
     PROCEDURE BoBomenu;
      BEGIN
       writeln('DISPLAY BOUNDARIES AND BORDERS':43); writeln;
       writeln('1:  Pipe/Link Boundaries      ':43);
       writeln('2:  Pipe/Link Borders         ':43);
       writeln; writeln('Select Line, 0 for exit':40);
       Alt := LineNr(2);
      END; {BoBomenu}
      
     BEGIN {EchoBoBos}
      REPEAT  BoBomenu; Dummy := 1;
       CASE Alt OF
        0: begin Aclear; Dummy := 0; end;
        1: begin Aclear; EchoBounds; Aclear; end;
        2: begin Aclear; EchoBorders; Aclear; end;
       END; {Case Alt}
      UNTIL (Dummy=0);
       
     END; {EchoBoBos}
       
    PROCEDURE EchoHexBoilAccs;
     
     PROCEDURE EchoHex;
      VAR Summa,s,i,Znr,Nr,k : integer;
      
      PROCEDURE HeadLine;
       BEGIN
        write('HeatEx':12); writeln;
        writeln; 
       END; 
       
      BEGIN
       writeln('HEAT EXCHANGER TABLE':35); writeln;
       Summa := 0;
       For s := 1 to Sumax do Summa := Summa+Lexmax[s];
       Summa := Summa+Exmax;
       If Summa>0 then begin HeadLine; k := 1;
          For i := 1 to Exmax do begin With ExPost[i] do begin
              Znr := Id div 100; Nr := Id mod 100;
              If ((k mod ContLines)=0) then begin
                   Paus; Headline; k := 1; end;
              write(IdS2(Znr):8,NrS2(Nr):4);
              writeln;       
          end; end;
          For s := 1 to Sumax do begin
              Znr := SubId[s] div 10; Nr := SubId[s] mod 10;  
              For i := 1 to Lexmax[s] do begin
                  With LexPost[s,i] do begin     
                  write(IdS2(Znr):8,Nr:1,NrS3(eNr):3);
                  writeln;   
              end; end; end;
  end
       else writeln('No Heat Exchanger to display!':44);   
       Stop;      
      END; {EchoHex}
     
     PROCEDURE EchoBoils;
      VAR k,i,Znr,Nr : integer;
      
      PROCEDURE HeadLine;
       BEGIN
        write('Boiler':13); writeln;
        writeln;
       END; {HeadLine}
       
      BEGIN
       writeln('BOILER/HEATER/COOLER TABLE':40); writeln;
       If Boilmax>0 then begin HeadLine; k := 1; 
          For i := 1 to Boilmax do begin With Boiler[i] do begin  
              Znr := Id div 100; Nr := Id mod 100;
              If ((k mod ContLines)=0) then begin
                   Paus; Headline; k := 1; end;
              write(IdS2(Znr):10,NrS2(Nr):2);
              writeln;       
          end; end;
  end
       else writeln('No Boiler/Heater/Cooler to display!':48);   
       Stop;      
      END; {EchoBoils}
          
     PROCEDURE EchoAccs;
       VAR i,Nr,k,Znr : integer;

       PROCEDURE HeadLine;
        BEGIN
         write('Accu':12,'Avp':7,'Avm':7,'Dacc':8,'Type':6);
         writeln('Zacc':7,'Gvol':6,'Npol':6); writeln;
        END; {Headline}

       BEGIN
        writeln('ACCUMULATOR TABLE':35); writeln;
        If Acmax>0 then begin
           HeadLine; k := 1;
           For i := 1 to Acmax do begin With AcPost[i] do begin
               Znr := Id div 100; Nr := Id mod 100;
               If ((k mod ContLines)=0) then begin
                   Paus; Headline; k := 1; end;
               write(IdS2(Znr):10,NrS2(Nr):2,Avp:8:4,Avm:8:4,Da:7:3);
               If Atyp='S' then writeln('ST':4,'----':8,'----':6,'----':6);             
               If Atyp='G' then writeln('GC':4,Za:8:1,Gvol:6:1,Npol:6:2);
               k := k+1; end; end; end
        else writeln('No Accumulator to display!':44);
        Stop;
       END; { EchoAccs }
    
     PROCEDURE HbaMenu;
      BEGIN
       writeln('DISPLAY HEAT EXCHANGERS, BOILERS AND ACCUMULATORS':60); 
       writeln;
       writeln('1:  Heat Exchangers                 ':49);
       writeln('2:  Boiler/Heater/Cooler            ':49);
       writeln('3:  Accumulators                    ':49);
       writeln; writeln('Select Line, 0 for exit':40);
       Alt := LineNr(3);
      END; {HbaMenu}

     BEGIN {EchoHexBoilAccs}
      REPEAT HbaMenu; Dummy := 1;
       CASE Alt OF
        0: begin Aclear; Dummy := 0; end;
        1: begin Aclear; EchoHex; Aclear; end;
        2: begin Aclear; EchoBoils; Aclear; end;
        3: begin Aclear; EchoAccs; Aclear; end;
       END; {Case Alt}
      UNTIL (Dummy=0);
     END; {EchoHexBoilAccs}
     
    PROCEDURE Echopumps;
     VAR p,k,Pmax,Tmp,Sel,b,Znr,Nr : integer;
         Nx : real;
	 Rad : array[1..maxPu] of integer;
         Klar : Boolean;

     PROCEDURE HeadLine;
       BEGIN
       write('Line':9,'Pump':8,'Elev':6,'Pperf':7,'D2x':6,'Nx':6);
       writeln('Comment':15); writeln;
       END;

     PROCEDURE Pdata(Sel:integer);
       VAR  Npu,D2x,Q,Hpu,Ppu,Fi,Eta,Nhu,Nx : real;
            Pnom,i,Pnr : integer;
       BEGIN
        With PrefPost[Sel] do begin Pnr := Id; Znr := Id div 100;
        Nr := Id mod 100; D2x := DIx; Pnom := PuNomPek[Pref]; 
        Npu := Np; Nx :=Npu/DrivePost[DrPek[DrId]].Nmot;
        write('Pump:':10,IdS2(Znr):3,NrS2(Nr):2,'Perf:':8,NrS2(Pref):3);
        writeln('D2x:':6,DIx:5:2,'Nx:':6,Nx:6:3,'Com:':6,Com:13); end;
        writeln; writeln; 
        writeln('Np':9,'Qp':11,'Hp':8,'Pp':6,'Eta':8,'NPSH':7,'Fi':6);
        writeln; 
        With PumpNom[Pnom] do begin
        If Npu<1 then Npu := 1;
        write(round(Npu):10); b := 12;
        For i := 1 to 14 do begin
            Q := (i-1)*Npu/Nnom*sqr(D2x)*Qnom/10;
            Hpu := PumpHp(Pnr,Npu,Q);
            Ppu := PumpMp(Pnr,Npu,Q)*Pii*Npu/30/1000;
            Eta := Ra*Q*g*Hpu/Ppu/1000;
            Nhu := PumpNh(Pnr,Npu,Q);
            Fi := Nnom/Npu*Q/Qnom/sqr(D2x);
            If Npu<10 then begin Q := 0;
               Hpu := 0; Ppu := 0; Eta := 0; Nhu := 0; Fi := 0; end;
            write(Q:b:4,Hpu:7:1,Ppu:7:1,Eta:7:2);
            writeln(Nhu:6:1,Fi:7:2); b := 22;
        end; end; Stop; 
       END; {Pdata}

     BEGIN
      write('PUMP PERFORMANCE DATA':35); Zstr; writeln; k := 0;
      For p := 1 to Pumax do begin With PrefPost[p] do begin
          Znr := Id div 100; Nr := Id mod 100;      
          If Str[1]='+' then SeCom(Com,Str,Len)
                        else SeZon(IdS2(Znr),Str,Len);
          If Pflag then begin k := k+1; Rad[k] := p; end; end; end;
      Pmax := k;
      If Pmax>1 then begin
         REPEAT k := 0; Klar := true;
          REPEAT k := k+1;
           If PrefPost[Rad[k]].Id>PrefPost[Rad[k+1]].Id then begin
              Klar := false;
              Tmp := Rad[k]; Rad[k] := Rad[k+1]; Rad[k+1] := Tmp; end;
          UNTIL (k=(Pmax-1));
         UNTIL Klar; end;  {If Pmax} 
      REPEAT Sel := 0; EchoFlag := false; k := 1;
       For i := 1 to Pmax do begin p := Rad[i];
           With PrefPost[p] do begin
           Znr := Id div 100; Nr := Id mod 100;   
           If not EchoFlag then begin HeadLine; EchoFlag := true; end;
           If ((k mod ContLines)=0) then begin Paus; Headline; k := 1; end;
           Nx := Np/DrivePost[DrPek[DrId]].Nmot;
           write(i:8,IdS2(Znr):7,NrS2(Nr):2,Zp:6:1,NrS2(Pref):5);
           writeln(DIx:8:2,Nx:8:3,Com:17);
       end; end;
       If Pmax=0 then begin writeln('No Pumps to display !':38);
                Stop; Sel := 0; end
       else begin writeln; writeln('Select Line, 0 for exit':40);
            Sel := LineNr(Pmax);
            If Sel>0 then begin Sel := Rad[Sel]; Aclear;
                     Pdata(Sel); Aclear; k := 1;
                     EchoFlag := false; end;
       end; {else}
      UNTIL Sel=0;
     END; {EchoPumps}

     PROCEDURE EchoData;
       VAR i,z,s,k,Znr : integer; 
           Len,Vol,Pre,Podr,Bos : real;
           Lpipe,Vpipe,Phen,Pdri,Bmax : array[1..maxZon] of real;
    
       PROCEDURE HeadLine;
        BEGIN
          writeln('Zon  Length  Volume   Nominal  Heat Load  Production':62);
          writeln(' -   Pipe m  Pipe m3  Drive kW  Pmax kW    Wmax kW  ':62);
          writeln;
        END; {Headline}

       BEGIN
         Len := 0; Vol := 0; Podr := 0; Pre := 0; Bos := 0;
         For z := 1 to Zonmax do begin Lpipe[z] := 0; 
             Vpipe[z] := 0; Pdri[z] := 0; Phen[z] := 0; Bmax[z] := 0; end;
         For i := 1 to Pimax do begin Znr := PipePost[i].Id div 100;
             z := ZonPek[Znr]; Lpipe[z] := Lpipe[z]+PipePost[i].L;
             Vpipe[z] := Vpipe[z]+PipePost[i].L*Api[i]; end;      
         For i := 1 to Drmax do begin Znr := DrivePost[i].Id div 100; 
             z := ZonPek[Znr]; Pdri[z] := Pdri[z]+DrivePost[i].Pmot; end;
         For i := 1 to Csmax do begin With CsPost[i] do begin
             Znr := Id div 100; z := ZonPek[Znr]; 
             If Vnr=0 then Phen[z] := Phen[z]+Pnom*Fsum; end; end;
         For i := 1 to Boilmax do begin With Boiler[i] do begin
             Znr := Id div 100; z := ZonPek[Znr];
             Bmax[z] := Bmax[z]+abs(Wmax); end; end;
         For s := 1 to Sumax do begin
             Znr := SubId[s] div 10; z := ZonPek[Znr]; 
             For i := 1 to Lcsmax[s] do begin
                 With LcsPost[s,i] do begin
                 If Vnr=0 then Phen[z] := Phen[z]+Pnom*Fsum;
                 end; end; end; 
         For z := 1 to Zonmax do begin
             Len := Len+Lpipe[z]; Vol := Vol+Vpipe[z];
             Podr := Podr+Pdri[z]; Pre := Pre+Phen[z]; 
             Bos := Bos+Bmax[z]; end;  
         writeln('Pipe System Overview, Overall Data':50);
         writeln('----------------------------------':50); writeln;
         HeadLine; k := 1;
         For z := 1 to Zonmax do begin 
             If ((k mod ContLines)=0) then begin
                Paus; Headline; k := 1; end;
             write(IdS2(ZonId[z]):13,round(Lpipe[z]):8,Vpipe[z]:9:1);
             write(Pdri[z]:9:1,round(Phen[z]):10);
                writeln(round(Bmax[z]):10); k := k+1; end;
         write('-':11); For i := 1 to 50 do write('-':1); writeln;
         write('Tot':13,round(Len):8,Vol:9:1,Podr:9:1,round(Pre):10);
         writeln(round(Bos):10); Stop;
       END;   {EchoData}

       
  PROCEDURE EchoNumbers; 
   VAR Alt : integer;
   
   PROCEDURE Echonodes;
    VAR i,z,Znr,k,j : integer;
        Pipe,Alarm,Conn,Junc,Cross,Bound,Hex,Sub,
        Close : array[1..maxZon] of integer;
    
    PROCEDURE HeadLine;
     BEGIN
      write('Zone':10,'Pipe':6,'Perf':5,'Alarm':6,'Close':6,'Conn':6);
      writeln('Junc':6,'Cross':7,'Bound':7,'H-Ex':5,'Subnet':8);
      writeln;
     END; {Headline}
    
    BEGIN
     For z := 1 to Zonmax do begin Pipe[z] := 0; 
         Alarm[z] := 0; Close[z] := 0; Conn[z] := 0; Junc[z] := 0; 
         Cross[z] := 0; Bound[z] := 0; Hex[z] := 0; Sub[z] := 0; end;
     For i := 1 to Pimax do begin Znr := PipePost[i].Id div 100;   
         z := ZonPek[Znr]; Pipe[z] := Pipe[z]+1; end; 
     For i := 1 to Alarmmax do begin Znr := AlarmPost[i].Id div 100;
         z := ZonPek[Znr]; Alarm[z] := Alarm[z]+1; end;
     For i := 1 to Closemax do begin j := SelPipe[i];
         Znr := PipePost[j].Id div 100; 
         z := ZonPek[Znr]; Close[z] := Close[z]+1; end;
     For i := 1 to Cnmax do begin Znr:= CnPost[i].Id div 100;
         z := ZonPek[Znr]; Conn[z] := Conn[z]+1; end;
     For i := 1 to Jnmax do begin Znr := JnPost[i].Id div 100;
         z := Zonpek[Znr]; Junc[z] := Junc[z]+1; end;
     For i := 1 to Csmax do begin Znr := CsPost[i].Id div 100;
         z := ZonPek[Znr]; Cross[z] := Cross[z]+1; end;
     For i := 1 to Iomax do begin j := IoPost[i].Pi;
         Znr := PipePost[j].Id div 100; z := ZonPek[Znr];
         Bound[z] := Bound[z]+1; end; 
     For i := 1 to Exmax do begin Znr := ExPost[i].Id div 100;
         z := ZonPek[Znr]; Hex[z] := Hex[z]+1; end;
     For i := 1 to Sumax do begin Znr := SubId[i] div 10;
         z := ZonPek[Znr]; Sub[z] := Sub[z]+1; end;
     HeadLine; k := 1;
     For z := 1 to Zonmax do begin  
         If ((k mod ContLines)=0) then begin
                 Paus; Headline; k := 1; end;
         write(IdS2(ZonId[z]):9,Pipe[z]:6,'-':5,Alarm[z]:5,Close[z]:6);
         write(Conn[z]:7,Junc[z]:6,Cross[z]:7,Bound[z]:6,Hex[z]:6);
         writeln(Sub[z]:7); k := k+1; end;
     For i := 1 to 75 do write('-'); writeln;
     write('Tot':4,Zonmax:5,Pimax:6,PipePerfmax:5,Alarmmax:5,Closemax:6);
     writeln(Cnmax:7,Jnmax:6,Csmax:7,Iomax:6,Exmax:6,Sumax:7); 
     write('Dim':4,maxZon:5,maxPi:6,maxPipePerf:5,maxAlarm:5,maxClose:6);
     writeln(maxCn:7,maxJn:6,maxCs:7,maxIo:6,maxEx:6,maxSu:7);Stop;
    END; {Echonodes}
   
   PROCEDURE EchoComps;
    VAR i,z,Znr,Su,k,Cvmax : integer;
        Valve,Pump,Drv,Chv,Boi,Acc : array[1..maxZon] of integer;  
    
    PROCEDURE HeadLine;
     BEGIN
      write('Zone  Valve Vperf Tab Pump Pperf Drive Boil  ChV  Accu':60);
      writeln('HexPerf':8,'RvPerf':7); writeln;
     END; {Headline}
    
    BEGIN
     Cvmax := 0;
     For z := 1 to Zonmax do begin Valve[z] := 0; Pump[z] := 0;
         Drv[z] := 0;Chv[z] := 0; Boi[z] := 0; Acc[z] := 0; end;
     For i := 1 to Vamax do begin Znr := VrefPost[i].Id div 100;
         z := ZonPek[Znr]; Valve[z] := Valve[z]+1; end;
     For i := 1 to Pumax do begin Znr := PrefPost[i].Id div 100;
         z := ZonPek[Znr]; Pump[z] := Pump[z]+1;
         If PrefPost[i].YN='Y' then Chv[z] := Chv[z]+1; end;
     For i := 1 to Drmax do begin Znr :=DrivePost[i].Id div 100;
         z := ZonPek[Znr]; Drv[z] := Drv[z]+1; end;
     For i := 1 to Boilmax do begin Znr := Boiler[i].Id div 100;
         z := ZonPek[Znr]; Boi[z] := Boi[z]+1; end;
     For i := 1 to Cnmax do begin Znr := CnPost[i].Id div 100;
         z := ZonPek[Znr];
         If (CnPost[i].Ecod=13) then Acc[z] := Acc[z]+1;
         If (CnPost[i].Ecod=14) then Acc[z] := Acc[z]+1;
         If (CnPost[i].Ecod=7)  then Chv[z] := Chv[z]+1; end;
     For Su := 1 to maxSu do For i := 1 to Lcnmax[Su] do begin
         Znr := SubId[Su] div 10; z := ZonPek[Znr];
         If (LcnPost[Su,i].Ecod=13) then Acc[z] := Acc[z]+1;
         If (LcnPost[Su,i].Ecod=14) then Acc[z] := Acc[z]+1;
         If (LcnPost[Su,i].Ecod=7) then Chv[z] := Chv[z]+1; end;
     HeadLine; k := 1;
     For z := 1 to Zonmax do begin Cvmax := Cvmax+Chv[z]; 
         If ((k mod ContLines)=0) then begin
                 Paus; Headline; k := 1; end;
         write(IdS2(ZonId[z]):9,Valve[z]:7,'-':6,'-':4,Pump[z]:6,'-':5);
         writeln(Drv[z]:6,Boi[z]:5,Chv[z]:6,Acc[z]:6,'-':6,'-':6); 
	 k := k+1; end; 
     For i := 1 to 75 do write('-'); writeln;
     write('Tot':4,Zonmax:5,Vamax:7,Vperfmax:6,Tabmax:4,Pumax:6,Pperfmax:5);
     write(Drmax:6,Boilmax:5,Cvmax:6,Acmax:6,HexPerfmax:6);
     writeln(RvPerfmax:6);
     write('Dim':4,maxZon:5,maxVa:7,maxVperf:6,maxTab:4,maxPu:6,maxPperf:5);
     write(maxDr:6,maxBoil:5,'  --':6,maxAc:6,maxHexPerf:6);
     writeln(maxRvPerf:6);Stop;
    END; {EchoComps}
   
   PROCEDURE EchoSubs;
    VAR s,k,Num,Znr,Nr : integer;    
        HeadFlag : Boolean;    
    
    PROCEDURE HeadLine;
     BEGIN
      write('Line':4,'Subnet':10,'Link':6,'Bor':5,'Lcn':5,'Ljn':5); 
      writeln('Lcs':5,'Lbo':5,'Lhex':5); writeln;
     END;
     
    BEGIN
     HeadFlag := true; k := 1; Num := 0;
     write('SUBNETS':20); Zstr; writeln;
     For s := 1 to Sumax do begin
         Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
         SeZon(IdS2(Znr),Str,Len);
         If Pflag then begin Num := Num+1;
            If HeadFlag then begin HeadLine; HeadFlag := false; end;
            If ((k mod ContLines)=0) then begin
                        Paus; Headline; k := 1; end;
            write(Num:3,IdS2(Znr):8,Nr:1,Limax[s]:7,Brmax[s]:5);
            write(Lcnmax[s]:5,Ljnmax[s]:5,Lcsmax[s]:5,Liomax[s]:5);
            writeln(Lexmax[s]:5); k := k+1; end; end;
     If Num>0 then begin
        writeln; write('Dim per Subnet':14);
        write(maxLi:5,maxBor:5,maxLcn:5,maxLjn:5,maxLcs:5,maxLio:5);
        writeln(maxLex:5); end;
     If Num=0 then writeln('No Subnets to display !':35);
     Stop;
    END; {EchoSubs}
         
   PROCEDURE Nrsmenu;
    BEGIN
     writeln('DISPLAY SYSTEM OVERVIEW - NUMBERS OF':45); writeln;
     writeln('1:  Pipes and Nodes                 ':49);
     writeln('2:  Components                      ':49);
     writeln('3:  Subnets                         ':49);
     writeln; writeln('Select Line, 0 for exit':40);
     Alt := LineNr(3);
    END; {Nrsmenu}
     
   BEGIN {Echonumbers}
    REPEAT  Nrsmenu; Dummy := 1;
     CASE Alt OF
      0: begin Aclear; Dummy := 0; end;
      1: begin Aclear; EchoNodes; Aclear; end;
      2: begin Aclear; EchoComps; Aclear; end;
      3: begin Aclear; EchoSubs; Aclear; end;
       END; {Case Alt}
      UNTIL (Dummy=0);
    END;  {Echonumbers}
       
      PROCEDURE EchoMenu;
       VAR ch : char;
       BEGIN
        Aclear; writeln(Mmenu); writeln(Dash);
        writeln; writeln;
        writeln(' ':14,'Display Pipe System Configuration');
        writeln(' ':14,'---------------------------------');
        writeln;
        writeln(' ':14,'1 - Display Pipes (Close/Diam)');
        writeln(' ':14,'2 - Display Pipe/Link Connections');
        writeln(' ':14,'3 - Display Pipe/Link Junctions');
        writeln(' ':14,'4 - Display Pipe/Link Cross Connections');
        writeln(' ':14,'5 - Display Boundaries and Borders');
        writeln(' ':14,'6 - Display HeatEx, Boilers and Accs');
        writeln(' ':14,'7 - Display Pump Performace Data');
        writeln(' ':14,'8 - Display Pipe System, Overall Data');
        writeln(' ':14,'9 - Display Pipe System, Numbers of');
        writeln(' ':14,'0 - Return to Main Menu'); writeln;
        REPEAT
          write('Choice : ':14); read(ch); readln; ch := Uchar(ch);
        UNTIL (ord(ch)>47) and (ord(ch)<58) or (ch in MenuSet);
        If (ch in Menuset) then begin Choice := ch; Alt := 10; end
                           else begin Alt := ord(ch)-48; end;
        OldChoice := 'D';
       END;    {EchoMenu}

     BEGIN { EchoPrint }
       REPEAT  EchoMenu; Dummy := 1;
        CASE Alt OF
         0: begin Choice := 'X'; Dummy := 0; end;
         1: begin Aclear; EchoPipes; end;
         2: begin Aclear; EchoConns; end;
         3: begin Aclear; EchoJuncs; end;
         4: begin Aclear; EchoCross; end;
         5: begin Aclear; EchoBoBos; end;
         6: begin Aclear; EchoHexBoilAccs; end;
         7: begin Aclear; EchoPumps; end;
         8: begin Aclear; EchoData;  end;
         9: begin Aclear; EchoNumbers; end;
        10: begin Dummy := 0; end;
        END; { Case Choice }
       UNTIL (Dummy=0);
     END;  { EchoPrint }

   PROCEDURE SetSyst;
     VAR Alt : integer;
         Nodpek : array[1..1200] of integer;

   PROCEDURE SetBounds;
    VAR  i,s,b1,b2,b,k,Pid,Nr,Num,Znr : integer;
         Snet : array[1..maxSu] of integer;

    PROCEDURE HeadLIne;
      BEGIN
      writeln('Line  Pi/Li  I/O  Elev   Temp  Q/P  Value     Comment':59);
      writeln;
     END;

    BEGIN
      b := 0; b1 := 0; b2 := 0; Num := 0; 
      write('BOUNDARY CONDITIONS':32); Zstr; writeln;
      For i := 1 to Iomax do begin With IoPost[i] do begin
          Pid := PipePost[Pi].Id;
          Znr := Pid div 100; Nr := Pid mod 100;
          If Str[1]='+' then SeCom(Com,Str,Len)
                        else SeZon(IdS2(Znr),Str,Len);
          If Pflag then begin Num := Num+1;
             b1 := b1+1; b := b1; NodPek[b1] := i;
          end; end; end;
      For s := 1 to Sumax do begin 
          Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
          For i := 1 to Liomax[s] do begin With LioPost[s,i] do begin
              If Str[1]='+' then SeCom(Com,Str,Len)
                            else SeZon(IdS2(Znr),Str,Len);
              If Pflag then begin Num := Num+1;
                 b2 := b2+1; b:= b1+b2; Snet[b] := s; NodPek[b] := i;
          end; end; end; end;
      If Num=0 then begin
         writeln('No Boundary Conditions to set!':42); Stop; end;
      If Num>0 then begin 
         REPEAT Aclear; Headline; k := 1;
         For i := 1 to b1 do begin With IoPost[NodPek[i]] do begin
             Pid := PipePost[Pi].Id; k := k+1;
             Znr := Pid div 100; Nr := Pid mod 100; 
             write(i:8,IdS2(Znr):5,NrS2(Nr):4,BE:4);
             writeln(Elev:7:1,Temp:7:1,QP:4,Value:9:4,Com:16); 
             If ((k mod ContLines)=0) then begin
                 Paus; HeadLine; k := 1; end; end; end; 
         For i := b1+1 to b do begin s := Snet[i];
             Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
             With LioPost[s,Nodpek[i]] do begin
             write(i:8,IdS2(Znr):5,Nr:1,NrS2(Li):3,BE:4,Elev:7:1);
             writeln(Temp:7:1,QP:4,Value:9:4,Com:16); k := k+1;
             If ((k mod ContLines)=0) then begin
                 Paus; HeadLine; k := 1; end; end; end; 
         writeln; writeln('Select Line, 0 for exit':40);
         i := LineNr(b);
         If i>0 then begin ConvFlag := false;
            write('Boundary':25);
            If i<=b1 then begin With IoPost[NodPek[i]] do begin
               Pid := PipePost[Pi].Id; Nr := 19;
               write(IdS2(Pid div 100):3,' ':1,NrS2(Pid mod 100):3);
               REPEAT write('New Temp : ':Nr); Temp := ReadRl;
               Nr := 52; UNTIL not ReadError;
               REPEAT write('New Value : ':Nr); Value := ReadRl;
               UNTIL not ReadError;
               If QP='P' then Hbound := Value*1E05/Density(Temp)/g+Elev;
               end; end;
            If i>b1 then begin s := Snet[i]; 
               With LioPost[s,NodPek[i]] do begin
               write(IdS2(SubId[s] div 10):4,SubId[s] mod 10:1,NrS2(Li):3);
               Nr := 19; 
               REPEAT write('New Temp : ':Nr); Temp := ReadRl;
               Nr := 52; UNTIL not ReadError;
               REPEAT write('New Value : ':Nr); Value := ReadRl;
               UNTIL not ReadError;
               If QP='P' then Hbound := Value*1E05/Density(Temp)/g+Elev;
               end; end;
         end; {If i>0}
         UNTIL (i=0);
      end; {if Num>0}
    END;  {SetBounds}

     PROCEDURE SetConns;
      VAR i,s,c,c1,c2,Nr,Dec,k,Num,Znr : integer;
          Snet : array[1..maxSu] of integer;

      PROCEDURE HeadLine;
        BEGIN
          writeln('Line':10,'Zon Nr':8,'Etyp':6,'Value':8,'Comment':12);
          writeln;
        END;

      BEGIN
        c := 0; c1 := 0; c2 := 0; Num := 0; 
        write('PIPE/LINK CONNECTIONS ':32); Zstr; writeln;
        For i := 1 to Cnmax do begin With CnPost[i] do begin
            Znr := Id div 100; Nr := Id mod 100; 
            If Str[1]='+' then SeCom(Com,Str,Len)
                          else SeZon(IdS2(Znr),Str,Len);
            If not (Ecod in [1,2,3,4,5,7,8]) then Pflag := false;
            If Pflag then begin Num := Num+1;
               c1 := c1+1; NodPek[c1] := i; c := c1; 
            end; end; end;
        For s := 1 to Sumax do begin
            Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
            For i := 1 to Lcnmax[s] do begin With LcnPost[s,i] do begin
                If Str[1]='+' then SeCom(Com,Str,Len)
                              else SeZon(IdS2(Znr),Str,Len);
                If not (Ecod in [1,2,3,4,5,7,8]) then Pflag := false;
                If Pflag then begin Num := Num+1; k := k+1;
                   c2 := c2+1; c := c1+c2;
                   Snet[c] := s; NodPek[c] := i; 
            end; end; end; end; 
        If Num=0 then begin
           writeln('No Pipe/Link Connections to set!':42); Stop; end;
        If (Num>0) then begin 
           REPEAT Aclear; Headline; k := 1;
           For i := 1 to c1 do begin With CnPost[NodPek[i]] do begin
               Znr := Id div 100; Nr := Id mod 100;  
               Dec := 4;
               If Ecod in [3,4,5] then Dec := 1;
               If Ecod=2 then Dec := 2;
               write(i:8,IdS2(Znr):6,NrS2(Nr):4); k := k+1;
               writeln(Eqtyp[Ecod]:5,Value:10:Dec,Com:16);
               If ((k mod ContLines)=0) then begin
                    Paus; HeadLine; k := 1; end;
               end; end;
           For i := c1+1 to c do begin s := Snet[i];
               Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
               With LcnPost[s,NodPek[i]] do begin  
               Dec := 4;
               If Ecod in [3,4,5]  then Dec := 1;
               If Ecod=2 then Dec := 2;
               write(1:8,IdS2(Znr):6,Nr:1,NrS2(Id):3);
               writeln(Eqtyp[Ecod]:5,Value:10:Dec,Com:16); 
               If ((k mod ContLines)=0) then begin
                    Paus; HeadLine; k := 1; end;
               end; end;
           writeln; writeln('Select Line, 0 for exit':40);
           i := LineNr(c);
           If (i>0) then begin ConvFlag := false; write('Connection':25);
              If i<=c1 then begin With CnPost[NodPek[i]] do begin
                 Dec := 4; If Ecod in [3,4,5]  then Dec := 1;
                 If Ecod=2 then Dec := 2; Nr := 20;
                 write(IdS2(Id div 100+65):3,' ':1,NrS2(Id mod 100+65):3);
                 REPEAT write('New Value : ':Nr); Value := ReadRl;
                 Nr := 52; UNTIL not ReadError;
                 If Ecod=2 then
                    Hconn := Value*1E05/Density(Tt[Pto,1])/g+Elev;
              end; end;
              If i>c1 then begin With LcnPost[Snet[i],NodPek[i]] do begin
                 s := Snet[i];
                 write(IdS2(SubId[s] div 10):3,SubId[s] mod 10:1);
                 Dec := 4; If Ecod in [3,4,5]  then Dec := 1;
                 If Ecod=2 then Dec := 2; Nr := 20;
                 REPEAT write('New Value : ':Nr); Value := ReadRl;
                 Nr := 52; UNTIL not ReadError;
                 If Ecod=2 then
                    Hconn := Value*1E05/Density(Tli[Snet[i],Lto])/g+Elev;
              end; end; end;
          UNTIL (i=0); end;
       END;  {SetConns}

     PROCEDURE SetPnom;
      VAR i,s,c,Nr,Line,LineMax,Comax,Lcomax,Ns,Znr,k,Num : integer;
          Snet,Lcs : array[1..99] of integer;
          Avtmp,Fload,fPnom,ddTr : real;

      PROCEDURE HeadLine;
       BEGIN
         write('Line':10,'Zon Nr':9,'Cat':4,'Pnom kW':8,'Fsum':6,'Fload':6);
         writeln('Pload kW':10,'dTr':5,'Comment':10); writeln;
       END;

       BEGIN
         Line := 0; Comax := 0; Lcomax := 0; Num := 0;
         write(' HEATLOADS ':30); Zstr; writeln;
         For i := 1 to Csmax do begin With CsPost[i] do begin
             Znr := Id div 100; Nr := Id mod 100;
             If Str[1]='+' then SeCom(Com,Str,Len)
                           else SeZon(IdS2(Znr),Str,Len);
             If Vnr<>0 then Pflag := false;
             If Pflag then begin Num := Num+1;
                Line := Line+1; Nodpek[Line] := i;
             end; end; end; Comax := Line;
         For s := 1 to Sumax do begin
            Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
            For c := 1 to Lcsmax[s] do begin
                With LcsPost[s,c] do begin Ns := Id;
                If Str[1]='+' then SeCom(Com,Str,Len)
                              else SeZon(IdS2(Znr),Str,Len);
                If Vnr<>0 then Pflag := false;
                If Pflag then begin Num := Num+1;
                   Line := Line+1; Snet[Line] := s; Lcs[Line] := c;
               end; end; end; end;
         Lcomax := Line-Comax; LineMax := Comax+Lcomax;
         If Num=0 then begin writeln('No Heat Loads to set!':38);
                             Stop; end;
         If (Num>0) then begin
           REPEAT Aclear; Headline; k := 1;
           For i := 1 to Comax do begin With CsPost[NodPek[i]] do begin
               Znr := Id div 100; Nr := Id mod 100;
               CASE Cat OF
               'A': Fload := Aload;
               'B': Fload := Bload;
               'C': Fload := Cload;
               'D': Fload := Dload;
               'E': Fload := Eload;
               'F': Fload := Gload;
               END; {Case}
               write(i:8,IdS2(Znr):7,NrS2(Nr):4);
               write(Cat:3,round(Pnom):8,Fsum:7:2,Fload:6:2);
               writeln(round(Pload):8,dTr:7:1,Com:15); k := k+1;
               If ((k mod ContLines)=0) then begin
                  Paus; HeadLine; k := 1; end;       
               end; end;     
           For i := Comax+1 to Linemax do begin s := Snet[i];
               Znr := SubId[s] div 10; Nr := SubId[s] mod 10; 
               With LcsPost[s,Lcs[i]] do begin
               CASE Cat OF
               'A': Fload := Aload;
               'B': Fload := Bload;
               'C': Fload := Cload;
               'D': Fload := Dload;
               'E': Fload := Eload;
               'F': Fload := Gload;
               END; {Case}
               write(i:8,IdS2(Znr):7,Nr:1,NrS2(Ns):3); k := k+1;
               write(Cat:3,round(Pnom):8,Fsum:7:2);
               writeln(Fload :6:2,round(Pload):8,dTr:7:1,Com:15);
               If ((k mod ContLines)=0) then begin
                   Paus; HeadLine; k := 1; end; 
               end; end;
           write(Linemax+1:8,'------':11);
           writeln('Set Pnom/dTr for all Heatloads listed above':49);
           writeln; writeln('Select Line,  0 for exit':40);
           Line := LineNr(Linemax+1);
           If (Line>0) then begin ConvFlag := false;
              If Line<=CoMax then begin i := NodPek[Line];
                 With CsPost[i] do begin write('Heat Load':22);
                 write(IdS2(Id div 100):4,NrS2(Id mod 100):3); Nr := 15;
                 If Pnom<Epsi then Pnom := Epsi; Avtmp := Avmax/Pnom;
                 REPEAT write('New Pnom : ':Nr); Pnom := ReadRl; 
                 Nr := 44; UNTIL not ReadError; 
                 REPEAT write('New  dTr : ':Nr); dTr := ReadRl; 
                 UNTIL not ReadError;
                 Case Cat OF
                 'A': Pload := Pnom*Fsum*Aload;
                 'B': Pload := Pnom*Fsum*Bload;
                 'C': Pload := Pnom*Fsum*Cload;
                 'D': Pload := Pnom*Fsum*Dload;
                 'E': Pload := Pnom*Fsum*Eload;
                 'F': Pload := Pnom*Fsum*Gload;
                 END;
                 Avmax := Avtmp*Pnom;
                 IF Avmax<(Epsi*1E-3) then Avmax := (Epsi*1E-3); end; end;
              If (Line>Comax) and (Line<=Linemax) then begin
                 s := Snet[Line]; c := Lcs[Line];
                 With LcsPost[s,c] do begin write('Heat Load':22);
                 write(IdS2(Id div 10):4,Id mod 10:1,NrS2(c):3); Nr := 15;
                 If Pnom<Epsi then Pnom := Epsi; Avtmp := Avmax/Pnom;
                 REPEAT write('New Pnom : ':Nr); Pnom := ReadRl; 
                 Nr := 44; UNTIL not ReadError; Nr := 44;
                 REPEAT write('New  dTr : ':Nr); dTr := ReadRl; 
                 UNTIL not ReadError;
                 Case Cat OF
                 'A': Pload := Pnom*Fsum*Aload;
                 'B': Pload := Pnom*Fsum*Bload;
                 'C': Pload := Pnom*Fsum*Cload;
                 'D': Pload := Pnom*Fsum*Dload;
                 'E': Pload := Pnom*Fsum*Eload;
                 'F': Pload := Pnom*Fsum*Gload;
                 END;
                 Avmax := Avtmp*Pnom;
                 IF Avmax<(Epsi*1E-3) then Avmax := (Epsi*1E-3); end; end; end;
              If Line=(Linemax+1) then begin
                 writeln('For all Heatloads listed above':40); 
                 REPEAT write('Multiply Pnom with : ':50); 
                 fPnom := ReadRl; UNTIL not ReadError;
                 REPEAT write('       Add to  dTr : ':50); 
                 ddTr := ReadRl; UNTIL not ReadError;
                 For i := 1 to Comax do begin c := NodPek[i];
                     With CsPost[c] do begin
                     If Pnom<Epsi then Pnom := Epsi; dTr := dTr+ddTr;
                     Avtmp := Avmax/Pnom; Pnom := Pnom*fPnom; 
                     If Pnom<Epsi then Pnom := Epsi;
                     Case Cat OF
                     'A': Pload := Pnom*Fsum*Aload;
                     'B': Pload := Pnom*Fsum*Bload;
                     'C': Pload := Pnom*Fsum*Cload;
                     'D': Pload := Pnom*Fsum*Dload;
                     'E': Pload := Pnom*Fsum*Eload;
                     'F': Pload := Pnom*Fsum*Gload;
                     END;
                     Avmax := Avtmp*Pnom;
                     IF Avmax<(Epsi*1E-3) then Avmax := (Epsi*1E-3); end; end;
                 For i := Comax+1 to Linemax do begin
                     s := Snet[i]; c := Lcs[i];
                     With LcsPost[s,c] do begin
                     If Pnom<Epsi then Pnom := Epsi; dTr := dTr+ddTr;
                     Avtmp := Avmax/Pnom; Pnom := Pnom*fPnom; 
                     If Pnom<Epsi then Pnom := Epsi;
                     Case Cat OF
                     'A': Pload := Pnom*Fsum*Aload;
                     'B': Pload := Pnom*Fsum*Bload;
                     'C': Pload := Pnom*Fsum*Cload;
                     'D': Pload := Pnom*Fsum*Dload;
                     'E': Pload := Pnom*Fsum*Eload;
                     'F': Pload := Pnom*Fsum*Gload;
                     END;
                     Avmax := Avtmp*Pnom;
                     IF Avmax<(Epsi*1E-3) then Avmax := (Epsi*1E-3); end; end;
                end; {Linemax+1}
          UNTIL (Line=0); end; {If Num>0}
         END;   { SetPnom }

      PROCEDURE SetBoiler;
        VAR  i,Nr,Line,Linemax,k,Num,Znr : integer;

        PROCEDURE HeadLine;
          BEGIN
           writeln('Line':9,'ZnNr':8,'Tboil':8,'Tpipe':8,'Comment':10);
           writeln;
          END;

        BEGIN
         Line := 0; Linemax := 0; Num := 0; 
         write('BOILER/HEATER/COOLER ':32); Zstr; writeln;
         For i := 1 to Boilmax do begin With Boiler[i] do begin
             Znr := Id div 100; Nr := Id mod 100;
             If Str[1]='+' then SeCom(Com,Str,Len)
                           else SeZon(IdS2(Znr),Str,Len);
             If Pflag then begin Num := Num+1;
                Line := Line+1; Nodpek[Line] := i; 
             end; end; end;
         Linemax := Line; writeln;
         If Num=0 then begin
            writeln('No Boiler/Heater/Cooler to set!':42); Stop; end;
         If (Num>0) then begin 
            REPEAT Aclear; Headline; k := 1;
            For Line := 1 to Linemax do begin i := NodPek[Line]; 
	        With Boiler[i] do begin
                Znr := Id div 100; Nr := Id mod 100;
                write(Line:8,IdS2(Znr):7,NrS2(Nr):2,Tboil:8:1);
                writeln(Tpipe:8:1,Com:15);
                If ((k mod ContLines)=0) then begin
                     Paus; HeadLine; k := 1; end;
            end; end;       
            writeln; writeln('Select Line, 0 for exit':40);
            Line := LineNr(Linemax);
            If (Line>0) then begin ConvFlag := false;
               i := NodPek[Line];
               With Boiler[i] do begin
               Znr := Id div 100; Nr := Id mod 100;
               write('Boiler':25,IdS2(Znr):3,NrS2(Nr):2); Nr := 21;
               REPEAT write('New Tboil : ':Nr); Tboil := ReadRl;
               Nr := 51; UNTIL not ReadError;
               REPEAT write('New Tpipe : ':Nr); Tpipe := ReadRl;
               UNTIL not ReadError; end; end;
           UNTIL (Line=0); end;
        END;   {SetBoiler}

      PROCEDURE SetHloads;
        VAR i,s,Line,Nr : integer;
        BEGIN
          REPEAT Aclear;
          writeln(' ':10,'Heat load      Pload = Fload * Fsum * Pnom');
          writeln(' ':10,'               Fload = Ftemp + Fadd'); writeln;
          writeln(' ':10,'Return temp       Tr = Tret + dTr');
          writeln(' ':10,'                Tret = Ttemp + Tadd');
          For i := 1 to 80 do write('-'); writeln;
          writeln;
          writeln('1      Fload   Category A      : ':40,Aload:7:3);
          writeln('2      Tret    Category A      : ':40,Aret :6:1);
          writeln('3      Fload   Category B      : ':40,Bload:7:3);
          writeln('4      Tret    Category B      : ':40,Bret :6:1);
          writeln('5      Fload   Category C      : ':40,Cload:7:3);
          writeln('6      Tret    Category C      : ':40,Cret :6:1);
          writeln('7      Fload   Category D      : ':40,Dload:7:3);
          writeln('8      Tret    Category D      : ':40,Dret :6:1);
          writeln('9      Fload   Category E      : ':40,Eload:7:3);
          writeln('10     Tret    Category E      : ':40,Eret :6:1);
          writeln('11     Fload   Category F      : ':40,Gload:7:3);
          writeln('12     Tret    Category F      : ':40,Fret :6:1);
          writeln; writeln('Select Line, 0 for exit':40);
          Line := LineNr(12); Nr := 9;
          If Line>0 then ConvFlag := false;
          CASE Line OF
           0: begin end;
           1: begin write('  Category  A   ':32);
                    REPEAT write('Fload : ':Nr); Aload := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
           2: begin write('  Category  A   ':32);
                    REPEAT write(' Tret : ':Nr); Aret := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
           3: begin write('  Category  B   ':32);
                    REPEAT write('Fload : ':Nr); Bload := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
           4: begin write('  Category  B   ':32);
                    REPEAT write(' Tret : ':Nr); Bret := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
           5: begin write('  Category  C   ':32);
                    REPEAT write('Fload : ':Nr); Cload := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
           6: begin write('  Category  C   ':32);
                    REPEAT write(' Tret : ':Nr); Cret := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
           7: begin write('  Category  D   ':32);
                    REPEAT write('Fload : ':Nr); Dload := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
           8: begin write('  Category  D   ':32);
                    REPEAT write(' Tret : ':Nr); Dret := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
           9: begin write('  Category  E   ':32);
                    REPEAT write('Fload : ':Nr); Eload := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
          10: begin write('  Category  E   ':32);
                    REPEAT write(' Tret : ':Nr); Eret := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
          11: begin write('  Category  F   ':32);
                    REPEAT write('Fload : ':Nr); Gload := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
          12: begin write('  Category  F   ':32);
                    REPEAT write(' Tret : ':Nr); Fret := ReadRl; Nr := 41;
                    UNTIL not ReadError; end;
          END;
      UNTIL (Line=0);
          For i := 1 to Csmax do begin With CsPost[i] do begin
              If Vnr=0 then begin
                 CASE Cat OF
                 'A': Pload := Pnom*Fsum*Aload;
                 'B': Pload := Pnom*Fsum*Bload;
                 'C': Pload := Pnom*Fsum*Cload;
                 'D': Pload := Pnom*Fsum*Dload;
                 'E': Pload := Pnom*Fsum*Eload;
                 'F': Pload := Pnom*Fsum*Gload;
                 END; {Case} end; {If} end; {With} end; {For}
          For s := 1 to Sumax do begin
              For i := 1 to Lcsmax[s] do begin With LcsPost[s,i] do begin
                  If Vnr=0 then begin
                     CASE Cat OF
                     'A': Pload := Pnom*Fsum*Aload;
                     'B': Pload := Pnom*Fsum*Bload;
                     'C': Pload := Pnom*Fsum*Cload;
                     'D': Pload := Pnom*Fsum*Dload;
                     'E': Pload := Pnom*Fsum*Eload;
                     'F': Pload := Pnom*Fsum*Gload;
                     END; {Case} end; {If} end; {With} end; {For i} end; {For s}
        END;   {SetHloads}

   PROCEDURE Valveset;
     VAR  i,Nr,Line,Linemax,Vr,k,v,dec,iVr,Pos,Vva,Num,Znr : integer;
          Sxmin,Sxmax,Value : real;
          Ctrl,Z2 : packed array[1..2] of char;
          Alt : array[1..maxVa] of char;
          Deci: array[1..maxVa] of integer;
          Pos1,Pos2 : packed array[1..8] of char;
          Alter,CM : char;

     PROCEDURE HeadLine;
      BEGIN
        write('Line':10,'ZnNr':6,'Ctrl':6,'Value':6,'..S..':7,'..Pos 1.':11);
        writeln('..Pos 2.':11,'Comments':11);
        writeln;
      END;

     BEGIN
       Line := 0; Linemax := 0; Num := 0;
       write('VALVE SETTINGS ':30); Zstr; writeln;
       For i := 1 to Vamax do begin With VrefPost[i] do begin
           Znr := Id div 100; Nr := Id mod 100;
           If Str[1]='+' then SeCom(Com,Str,Len)
                         else SeZon(IdS2(Znr),Str,Len);
           If Pflag then begin Num := Num+1;
              Line := Line+1; Nodpek[Line] := i;
              end; end; end;
           Linemax := Line;
       If Num=0 then begin writeln('No Valves to set!':32); Stop; end;
       If (Num>0) then begin 
          REPEAT Aclear; Headline; k := 1;
          For Line := 1 to Linemax do begin
              With VrefPost[Nodpek[Line]] do begin  
              Znr := Id div 100; Nr := Id mod 100;
              Ctrl := 'M '; Alt[Line] := 'M'; Dec := 3; Pos := 0;
              For v := 1 to VaCtrlmax do
                  If Id=VaCtrl[v].VaId then begin Vva := v;
                     Alt[Line] := 'C'; Value := VaCtrl[v].Setvalue;
                     CASE VaCtrl[v].Code OF
                     1: begin Ctrl := 'H '; Dec := 1; Pos := 1; end;
                     2: begin Ctrl := 'DH'; Dec := 1; Pos := 2; end;
                     3: begin Ctrl := 'Q '; Dec := 4; Pos := 1; end;
                     4: begin Ctrl := 'DQ'; Dec := 4; Pos := 2; end;
                     5: begin Ctrl := 'T '; Dec := 1; Pos := 1; end;
                     6: begin Ctrl := 'DT'; Dec := 1; Pos := 2; end;
                     7: begin Ctrl := 'W '; Dec := 0; Pos := 1; end;
                     8: begin Ctrl := 'DW'; Dec := 0; Pos := 2; end;
                     9: begin Ctrl := 'HM'; Dec := 1; Pos := 2; end;
                     END; {case code}
                   Deci[Line] := Dec; end;
              write(Line:9,IdS2(Znr):5,NrS2(Nr):2,Ctrl:5);
              If Ctrl='M ' then write('----':7) else write(Value:7:Dec);
              Pos1 := '--  -- -'; Pos2 := '--  -- -';
              If Pos>0 then begin With VaCtrl[Vva] do begin
                 If PiLi='P' then begin
                    Znr := PipePost[p1].Id div 100; Z2 := IdS2(Znr);
                    Pos1[1] := Z2[1]; Pos1[2] := Z2[2];     
                    Pos1[5] := chr((PipePost[p1].Id mod 100) div 10+48);
                    Pos1[6] := chr(PipePost[p1].Id mod 10+48);
                    If i1=0 then Pos1[8] := 'B' else Pos1[8] := 'E'; end
                   else begin
                    Znr := SubId[p1] div 10; Z2 := IdS2(Znr);
                    Pos1[1] := Z2[1]; Pos1[2] := Z2[2];    
                    Pos1[3] := chr(SubId[p1] mod 10+48);
                    Pos1[5] := chr(i1 div 10+48);
                    Pos1[6] := chr(i1 mod 10+48); end;
                 end; {With} end; {Pos>0}
              If Pos>1 then begin With VaCtrl[Vva] do begin
                 If PiLi='P' then begin
                    Znr := PipePost[p2].Id div 100; Z2 := IdS2(Znr);
                    Pos2[1] := Z2[1]; Pos2[2] := Z2[2];     
                    Pos2[5] := chr((PipePost[p2].Id mod 100) div 10+48);
                    Pos2[6] := chr(PipePost[p2].Id mod 10+48);
                    If i2=0 then Pos2[8] := 'B' else Pos2[8] := 'E'; end
                   else begin
                    Znr := SubId[p2] div 10; Z2 := IdS2(Znr);
                    Pos2[1] := Z2[1]; Pos2[2] := Z2[2];    
                    Pos2[3] := chr(SubId[p2] mod 10+48);
                    Pos2[5] := chr(i2 div 10+48);
                    Pos2[6] := chr(i2 mod 10+48); end;
                 end; {With} end; {Pos>1}
              writeln(S:7:3,Pos1:11,Pos2:11,Com:15); k := k+1;
              If ((k mod ContLines)=0) then begin
                  Paus; HeadLine; k := 1; end;
          end; end;      
          writeln; writeln('Select Line, 0 for exit':40);
          Line := LineNr(Linemax);
          If Line>0 then begin ConvFlag := false;
             i := NodPek[Line]; Alter := Alt[Line];
             With VrefPost[i] do begin
             Znr := Id div 100; Nr := Id mod 100;
             Vr := VaPerfPek[Vref];
             Sxmin := ValvePerf[Vr].Smin;
             Sxmax := ValvePerf[Vr].Smax;
             write('Valve ':18,IdS2(Znr):2,NrS2(Nr):2); end;
             CASE Alter OF
             'M': begin With VrefPost[i] do begin Nr := 26;
                  REPEAT write(' New  S : ':Nr); S := ReadRl;
                  Nr := 48; UNTIL not ReadError;
                  If S<Sxmin then S := Sxmin;
                  If S>Sxmax then S := Sxmax;
                  Fi := FiavS(i,S); Fl := Flf(i,S); end; end;
             'C': begin write('C-Current,   M-Manual : ':26);
                  read(CM); CM := Uchar(CM); readln;
                  If CM<>'M' then CM := 'C';
                  CASE CM OF
                  'C': begin With VrefPost[i] do
                       For v := 1 to VaCtrlmax do
                           If Id=VaCtrl[v].VaId then iVr := v;
                       With VaCtrl[iVr] do begin 
                       REPEAT write('New Setvalue : ':48); 
                       Setvalue := ReadRl; UNTIL not ReadError;
                       end; end;
                  'M': begin With VrefPost[i] do begin 
                       REPEAT write(' New  S : ':48); S := ReadRl;
                       UNTIL not ReadError;
                       If S<Sxmin then S := Sxmin;
                       If S>Sxmax then S := Sxmax;
                       Fi := FiavS(i,S); Fl := Flf(i,S);
                       For v := 1 to VaCtrlmax do
                           If Id=VaCtrl[v].VaId then iVr := v;
                       For v := iVr to VaCtrlmax-1 do
                           VaCtrl[v] := VaCtrl[v+1];
                       VaCtrlmax := VaCtrlmax-1; end; end;
                  END; {Case CM}
                  end;
               END; {Case Alter} end;
          UNTIL (Line=0); end; {If Num>0}
       END;   { Valveset }

 PROCEDURE Driveset;
   VAR  i,Nr,Line,Linemax,d,k,Dec,iDr,Pos,Dr,Num,Znr : integer;
        Value,Nx : real;
        Ctrl,Z2 : packed array[1..2] of char;
        Pos1,Pos2 : packed array[1..8] of char;
        Alt : array[1..maxDr] of char;
        Deci: array[1..maxDr] of integer;
        Alter,CM : char;

   PROCEDURE HeadLine;
    BEGIN
      write('Line':10,'ZnNr':6,'Ctrl':6,'Value':7,'..N..':9);
      writeln('..Pos 1.':11,'..Pos 2.':11,'Comments':12); writeln;
    END;

   BEGIN
     Line := 0; Linemax := 0; Num := 0; 
     write('PUMP DRIVE SETTINGS':35); Zstr; writeln;
     For i := 1 to Drmax do begin With DrivePost[i] do begin
         Znr := Id div 100; Nr := Id mod 100;
         If Str[1]='+' then SeCom(Com,Str,Len)
                       else SeZon(IdS2(Znr),Str,Len);
         If Pflag then begin Num := Num+1;
            Line := Line+1; Nodpek[Line] := i; 
            end; end; end;
            Linemax := Line;
     If Num=0 then begin writeln('No Pump Drives to set!':38); Stop; end;
     If (Num>0) then begin 
     REPEAT Aclear; HeadLine; k := 1;
     For Line := 1 to Linemax do begin
         With DrivePost[Nodpek[Line]] do begin     
         Ctrl := 'M '; Alt[Line] := 'M'; Value := Ndr; 
         Dec := 0; Pos := 0;
         For d := 1 to DrCtrlmax do
             If Id=DrCtrl[d].DrId then begin Dr := d;
                Alt[Line] := 'C'; Value := DrCtrl[d].Setvalue;
                CASE DrCtrl[d].Code OF
                 1: begin Ctrl := 'H '; Dec := 1; Pos := 1; end;
                 2: begin Ctrl := 'DH'; Dec := 1; Pos := 2; end;
                 3: begin Ctrl := 'Q '; Dec := 4; Pos := 1; end;
                 4: begin Ctrl := 'DQ'; Dec := 4; Pos := 2; end;
                 5: begin Ctrl := 'T '; Dec := 1; Pos := 1; end;
                 6: begin Ctrl := 'DT'; Dec := 1; Pos := 2; end;
                 7: begin Ctrl := 'W '; Dec := 0; Pos := 1; end;
                 8: begin Ctrl := 'DW'; Dec := 0; Pos := 2; end;
                 9: begin Ctrl := 'HM'; Dec := 1; Pos := 2; end; 
                END; {case code}
                Deci[Line] := Dec; end;
         write(Line:9,IdS2(Id div 100):5,NrS2(Id mod 100):2,Ctrl:5);
         If Ctrl='M ' then write('----':8) else write(Value:8:Dec);
         Pos1 := '--  -- -'; Pos2 := '--  -- -';
         If Pos>0 then begin With DrCtrl[Dr] do begin
            If PiLi='P' then begin
               Znr := PipePost[p1].Id div 100; Z2 := IdS2(Znr);
               Pos1[1] := Z2[1]; Pos1[2] := Z2[2];
               Pos1[5] := chr((PipePost[p1].Id mod 100) div 10+48);
               Pos1[6] := chr(PipePost[p1].Id mod 10+48);
               If i1=0 then Pos1[8] := 'B' else Pos1[8] := 'E'; end
             else begin
               Znr := SubId[p1] div 10; Z2 := IdS2(Znr);
               Pos1[1] := Z2[1]; Pos1[2] := Z2[2];
               Pos1[3] := chr(SubId[p1] mod 10+48);
               Pos1[5] := chr(i1 div 10+48);
               Pos1[6] := chr(i1 mod 10+48); end;
            end; {With} end; {Pos>0}
         If Pos>1 then begin With DrCtrl[Dr] do begin
            If PiLi='P' then begin
               Znr := PipePost[p2].Id div 100; Z2 := IdS2(Znr);
               Pos2[1] := Z2[1]; Pos2[2] := Z2[2];
               Pos2[5] := chr((PipePost[p2].Id mod 100) div 10+48);
               Pos2[6] := chr(PipePost[p2].Id mod 10+48);
               If i2=0 then Pos2[8] := 'B' else Pos2[8] := 'E'; end
             else begin
               Znr := SubId[p2] div 10; Z2 := IdS2(Znr);
               Pos2[1] := Z2[1]; Pos2[2] := Z2[2];
               Pos2[3] := chr(SubId[p2] mod 10+48);
               Pos2[5] := chr(i2 div 10+48);
               Pos2[6] := chr(i2 mod 10+48); end;
            end; {With} end; {Pos>1}
            writeln(Ndr/Nmot:9:3,Pos1:11,Pos2:11,Com:16); k := k+1;
            If ((k mod ContLines)=0) then begin 
                       Paus; HeadLine; k := 1; end;
     end; end; {For}
        writeln; writeln('Select Line, 0 for exit':40);
        Line := LineNr(Linemax);
        If Line>0 then begin ConvFlag := false;
           i := NodPek[Line]; Alter := Alt[Line];
           With DrivePost[i] do begin
           Znr := Id div 100; Nr := Id mod 100;
           write('Drive ':18,IdS2(Znr):4,NrS2(Nr):2); end;
           CASE Alter OF
           'M': begin With DrivePost[i] do begin Nr := 26;
                REPEAT write('New N : ':Nr); Nx := readRl;
                Nr := 50; UNTIL not ReadError;
                If Nx>Nmax then Nx := Nmax;
                Ndr := Nx*Nmot;  end; end;
           'C': begin write('C-Current,   M-Manual : ':26);
                read(CM); CM := Uchar(CM); readln;
                If CM<>'M' then CM := 'C';
                CASE CM OF
                'C': begin With DrivePost[i] do
                     For d := 1 to DrCtrlmax do
                         If Id=DrCtrl[d].DrId then iDr := d;
                     With DrCtrl[iDr] do begin 
                     REPEAT write('New Setvalue : ':50); 
                     Setvalue := readRl; UNTIL not ReadError; end; end;
                'M': begin With DrivePost[i] do begin 
                     REPEAT write('New  N : ':50); Nx := readRl;
                     UNTIL not ReadError;
                     If Nx>Nmax then Nx := Nmax;
                     Ndr := Nx*Nmot;
                     For d := 1 to DrCtrlmax do
                         If Id=DrCtrl[d].DrId then iDr := d;
                     For d := iDr to DrCtrlmax-1 do
                         DrCtrl[d] := DrCtrl[d+1];
                     DrCtrlmax := DrCtrlmax-1; end; end;
                END; {Case CM}
                end;
           END; {Case Alt} end;
       UNTIL (Line=0); end;
      For i := 1 to Pumax do begin Nr := PrefPost[i].DrId;
          PrefPost[i].Np := DrivePost[Drpek[Nr]].Ndr; end;
     END;   { Driveset }

  PROCEDURE SetPoints;
    VAR ch,LP,BE,Dum,PLdum,PiLi : char;
        i,k,Nr,IdNr,Bo,s,Sid,PcnI,LcnI,
        Line,CaseK,PiId,Code,Znr : integer;
        Tmp,X1var,X2var,X3var : real;
        Ambvec: array[1..maxId] of integer;
        AmbMat: array[1..maxSu,1..99] of integer;
        Xva1,Xva2,Xva3 : array[1..maxCase] of real;
        CaseId : array[1..maxCase] of CaseIdTyp;
        IdCase,Dum6 : CaseIdTyp;
        Dum40 : CaseComTyp;
        Typ : packed array[1..2] of char;
        BoundFlag,ErrorFlag : Boolean;
        f : text;

    PROCEDURE  TSVFdata;
     VAR i,j,Line : integer;
         Dum2 : packed array[1..maxXstr] of char;
         Dum3 : packed array[1..maxFstr] of char;
         Nr : array[1..maxXvar] of integer;
     BEGIN
      For i := 1 to maxXvar do Nr[i] := 0;
      readln(f); Red; read(f,ch); Line := 0;
      WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
      WHILE ch=' ' do begin j := 0; Line := Line+1;
        REPEAT read(f,Fxstr[1]); UNTIL Fxstr[1]<>' ';
        For i := 2 to maxFxstr do read(f,Fxstr[i]);
        For i := 1 to maxXstr do Dum2[i] := Fxstr[i];
        For i := maxXstr+1 to maxFxstr do Dum3[i-maxXstr] := Fxstr[i];
        If Dum2='x1' then j := 1;
        If Dum2='x2' then j := 2;
        If Dum2='x3' then j := 3;
        If j=0 then begin writeln; write('TSVF Error!':16,'Line: ':9,Line:2);
           writeln('Xvar<>x1,x2,x3':17); Gerror; end;
        If Dum3='   ' then begin
           For i := 1 to 6 do read(f,xf[j,i]); readln(f); Red;
           For i := 7 to maxXF do read(f,xf[j,i]);
           For i := 2 to maxXF do
               If (xf[j,i-1]>xf[j,i]) then begin write('x-values':10);
                  writeln('must be given in increasing order!':35);
                  Gerror; end; end
        else begin Nr[j] := Nr[j]+1; FxPost[j,Nr[j]].Fstr := Dum3;
             For i := 1 to 6 do read(f,FxPost[j,Nr[j]].fx[i]); readln(f); Red;
             For i := 7 to maxXF do read(f,FxPost[j,Nr[j]].fx[i]); end;
        readln(f); Red; read(f,ch); end; {While}
       For j := 1 to maxXvar do
           If Nr[j]>maxFxPost then begin write('TSVF Error!':13,'Max ':8);
              writeln(maxFxPost:2,' fx for x':9, j:1,'!':1); Gerror; end
              else Fxmax[j] := Nr[j];
      END; {TSVFdata}

    FUNCTION Rval(VAR f : text) : real;
     VAR i,j,d,p : integer;
         Dum1 : char;
         Dum2 : packed array[1..maxXstr] of char;
         Dum3 : packed array[1..maxFstr] of char;
         r,Xvar : real;
     BEGIN
      Dum1 := ' ';
      WHILE (f^=' ') do begin read(f,Dum1); end;
      If (f^='x') then begin j := 0;
         For i := 1 to maxFxstr do read(f,Fxstr[i]);
         For i := 1 to maxXstr do Dum2[i] := Fxstr[i];
         If Dum2='x1' then begin j := 1; Xvar := X1var; end;
         If Dum2='x2' then begin j := 2; Xvar := X2var; end;
         If Dum2='x3' then begin j := 3; Xvar := X3var; end;
         If j=0 then begin writeln;
            writeln('Xvar Error!':16,'Xvar<>x1,x2,x3':19); Gerror; end;
         For i := maxXstr+1 to maxFxstr do Dum3[i-maxXstr] := Fxstr[i];
         d := 0; p := 1;
         For i := 1 to Fxmax[j] do
             If (FxPost[j,i].Fstr=Dum3) then d := i;
         If d=0 then begin writeln;
            writeln(Fxstr:10,'Function Reference Error!':27); Gerror; end;
         For i := 1 to maxXF do
             If (Xvar>(xf[j,i]-Epsi)) then p := i;
If (Dum3[1]='S') or (Dum3[1]='s') then begin r := FxPost[j,d].fx[p]; end
   else begin
         If p=maxXF then p := maxXF-1;
         With FxPost[j,d] do begin
         If abs(xf[j,p+1]-xf[j,p])>Epsi
            then r := (fx[p+1]-fx[p])/(xf[j,p+1]-xf[j,p]) else r := 0;
         r := fx[p]+r*(Xvar-xf[j,p]); end; {With}
   end; {else}
      end {If f^}
      else begin read(f,r); end;
      Rval := r;
     END; {Rval}

   FUNCTION CaseFlag : Boolean;
    VAR Flag : Boolean;
        Dum6 : CaseIdTyp;
           i : integer;
    BEGIN
     Flag := true; i := 0;
     REPEAT read(f,Dum6[1]); i := i+1; UNTIL Dum6[1]<>' ';
     If i<25 then  For i := 2 to 6 do read(f,Dum6[i])
             else  Dum6 := 'NoCase';
     For i := 1 to 6 do
         If (Dum6[i]<>IdCase[i]) and (Dum6[i]<>'*') then Flag := false;
     If Flag then CaseFlag := true else CaseFlag := false;
    END;

PROCEDURE  Controls;
 CONST  maxCtrlPoint = 200;
 TYPE   PointCtrl = record PiLi,Dir : char;
                           Fctrl,Setvalue : real;
                           CpRef,Code,p1,p2,i1,i2 : integer; end;
 VAR    CtrlPoint : array[1..maxCtrlPoint] of PointCtrl;
        CpPek : array[1..maxCtrlPoint] of integer;
        Cp,i : integer;

FUNCTION Xtrue : Boolean;
 VAR  Xvar,Xcomp : real;
      j : integer;
      Dum : char;
 BEGIN
  REPEAT read(f,Dum); UNTIL Dum<>' '; read(f,j);
  If (Dum='x') and (j in [1..3]) then begin end
     else begin ErrorFlag := true;
     writeln('Control Directives, Xvar Error!':30); end;
  CASE j OF
  1: Xvar := X1var;
  2: Xvar := X2var;
  3: Xvar := X3var;
  END; {Case j}
  REPEAT read(f,Dum); UNTIL Dum<>' ';
  If Dum<>'<' then writeln('Control Directives, < Error!':30);
  Xcomp := Rval(f);
  If (Xvar<Xcomp) then begin Xtrue := true; end
                  else begin Xtrue := false; end;
 END; {Xtrue}

PROCEDURE CtrlDirectives;
 VAR  AmbVa : array[1..maxVa] of integer;
      AmbDr : array[1..maxDr] of integer;
      Nx,Sx : real;
      i,Nr,Dr,De,DrIdNr,Ref,Vr,VaIdNr,Va,Ve : integer;
      DV : char;
 BEGIN
  For i := 1 to (Drmax+10) do AmbDr[i] := 0;
  For i := 1 to Vamax do AmbVa[i] := 0;
  Dr := 0; Vr := 0;
  readln(f); Red; read(f,ch);
  WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
  WHILE ch=' ' do begin
    If CaseFlag then begin
       REPEAT read(f,DV) UNTIL DV<>' ';
       If not (DV in ['D','V']) then begin ErrorFlag := true;
          writeln('Control Directives, D/V Error!':40); end;
       CASE DV OF
      'D': begin DrIdNr := ReadId(f); 
           Znr := DrIdNr div 100; Nr := DrIdNr mod 100; 
           If (DrIdNr<1) or (DrIdNr>maxId) then begin
              write('Drive':12,IdS2(Znr):3,NrS2(Nr):3);
              writeln('Control Error!  ':20); Gerror; end;
           De := Drpek[DrIdNr];
           If De=0 then begin write('Drive':12,IdS2(Znr):3,NrS2(Nr):3);
                   writeln('Control Error!  ':20); Gerror; end;
           If AmbDr[De]=0 then AmbDr[De] := 1
              else begin write('Drive':12,IdS2(Znr):3,NrS2(Nr):2);
                   writeln('Ambigous directive!!':25);
                   ErrorFlag := true; end;
           If Xtrue then begin Nx := Rval(f); read(f,Ref); end
                    else begin Nx := Rval(f); read(f,Ref);
                               Nx := Rval(f); read(f,Ref); end;
           If Nx>DrivePost[De].Nmax then Nx := DrivePost[De].Nmax;
           DrivePost[De].Ndr := Nx*DrivePost[De].Nmot;
           If Ref>0 then begin Dr := Dr+1; DrCtrl[Dr].PoRef := Ref;
              DrCtrl[Dr].DrId := DrIdNr; end;
           end; {'D'}
      'V': begin VaIdNr := ReadId(f);
           Znr := VaIdNr div 100; Nr := VaIdNr mod 100;
           If (VaIdNr<1) or (VaIdNr>maxId) then begin
              write('Valve':12,IdS2(Znr):3,NrS2(Nr):2);
              writeln('Control Error!  ':20); Gerror; end;
           Va := Vapek[VaIdNr];
           If Va=0 then begin
              write('Valve':12,IdS2(Znr):3,NrS2(Nr):2);
              writeln('!Control Error!  ':20); Gerror; end;
           If AmbVa[Va]=0 then AmbVa[Va] := 1
              else begin write('Valve':12,IdS2(Znr):3,NrS2(Nr):2);
                   writeln('Ambigous directive!':25);
                   ErrorFlag := true; end;
           If Xtrue then begin Sx := Rval(f); read(f,Ref); end
                    else begin Sx := Rval(f); read(f,Ref);
                               Sx := Rval(f); read(f,Ref); end;
           Ve := VaPerfPek[VrefPost[Va].Vref];
           If Sx>ValvePerf[Ve].Smax then Sx := ValvePerf[Ve].Smax;
           If Sx<ValvePerf[Ve].Smin then Sx := ValvePerf[Ve].Smin;
           VrefPost[Va].S := Sx;
           If Ref>0 then begin Vr := Vr+1; VaCtrl[Vr].PoRef := Ref;
              VaCtrl[Vr].VaId := VaIdNr; end;
           end; {'V'}
       END; {Case DV}
    end; {CaseFlag}
    readln(f); Red; read(f,ch); end; {WHILE ch}
    DrCtrlmax := Dr; VaCtrlmax := Vr;
    If ((maxDrCtrl-DrCtrlmax)<1) then begin write('Number of');
        write(' Drive Control Directives must not exceed: ');
        writeln(maxDrCtrl:2,'    Warning only!'); end;
    If ((maxVaCtrl-VaCtrlmax)<1) then begin write('Number of');
       write(' Valve Control Directives must not exceed: ');
       writeln(maxVaCtrl:2,'    Warning only!'); end;
    For i := 1 to Pumax do begin Nr := PrefPost[i].DrId;
        PrefPost[i].Np := DrivePost[Drpek[Nr]].Ndr; end;
 END; {CtrlDirectives}

PROCEDURE CtrlPoints;
VAR    Ctrl : packed array[1..2] of char;
       SD,ch,PL1,PL2 : char;
       i,Nr,Cp,kod,Snr,IdNr,Cpmax : integer;
BEGIN
  For i := 1 to maxCtrlPoint do CpPek[i] := 0;
  Cp := 0; 
  readln(f); Red; read(f,ch);
  WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
  WHILE ch=' ' do begin
    read(f,Nr);
    If (Nr<0) or (Nr>maxCtrlPoint) then begin ErrorFlag := true;
       writeln('Ref',NrS2(Nr):3,'Control Point Error!':30); end;
    If Nr>0 then begin Cp := Cp+1;
       If CpPek[Nr]=0 then CpPek[Nr] := Cp
          else begin Errorflag := true; write('Ref':12,NrS2(Nr):3);
               writeln('Ambigous Control Point':30); end;
       REPEAT read(f,Ctrl[1]); UNTIL Ctrl[1]<>' ';
       read(f,Ctrl[2]); kod := 99;
       If Ctrl='H ' then begin kod := 1; SD := 'S'; end;
       If Ctrl='DH' then begin kod := 2; SD := 'D'; end;
       If Ctrl='Q ' then begin kod := 3; SD := 'S'; end;
       If Ctrl='DQ' then begin kod := 4; SD := 'D'; end;
       If Ctrl='T ' then begin kod := 5; SD := 'S'; end;
       If Ctrl='DT' then begin kod := 6; SD := 'D'; end;
       If Ctrl='W ' then begin kod := 7; SD := 'S'; end;
       If Ctrl='DW' then begin kod := 8; SD := 'D'; end;
       If Ctrl='HM' then begin kod := 9; SD := 'D'; end;
       If not (kod in [1,2,3,4,5,6,7,8,9]) then begin ErrorFlag := true;
          writeln('Ref':12,NrS2(Nr):3,'Ctrl Code Error!':30); end;
       With CtrlPoint[Cp] do begin
       CpRef := Nr; Code := kod; Setvalue := Rval(f); Fctrl := Rval(f);
       REPEAT read(f,Dir); UNTIL Dir<>' ';
       If not (Dir in ['I','D']) then begin ErrorFlag := true;
          writeln('Ref':12,NrS2(Nr):3,'Control Point, Dir Error!':30); end;
       CASE SD OF
       'S': begin Znr := ReadZ2(f); read(f,PLdum); PiLi := 'X';
            If PLdum in ['1'..'9'] then begin PiLi := 'L';
               Sid := ord(PLdum)-48+10*Znr; p1 := Supek[Sid];
               If (p1<1) or (p1>Sumax) then begin ErrorFlag := true;
                  writeln('Ref':12,NrS2(Nr):3,'Control Point, Subnet Error!':33); end;
               read(f,i1); p2 := 0; i2 := 0;
               REPEAT read(f,Dum); UNTIL Dum<>' '; end;
             If Pldum=' ' then begin PiLi := 'P';
                read(f,Snr); IdNr := Snr+100*Znr;
                p1 := Pipek[Idnr]; p2 := 0; i2 := 0;
                If (p1<1) or (p1>Pimax) then begin ErrorFlag := true;
                   writeln('Ref':12,NrS2(Nr):3,'Control Point, Pipe Error!':31); end;
                REPEAT read(f,BE); UNTIL BE<>' ';
                If not (BE in ['B','E']) then begin ErrorFlag := true;
                   writeln('Ref':12,NrS2(Nr):3,'Control Point, B/E Error!':30); end;
                If BE='B' then i1 := 0 else i1 := 1; end;
              If not (PiLi in ['P','L']) then begin
                 writeln('Ref':12,NrS2(Nr):3,'Control Point, P/L Error!':30); end;
            end; {'S'}
       'D': begin Znr := ReadZ2(f); read(f,PLdum); PiLi := 'X';
            If PLdum in ['1'..'9'] then begin PiLi := 'L';
               Sid := ord(PLdum)-48+10*Znr; p1 := Supek[Sid];
               If (p1<1) or (p1>Sumax) then begin ErrorFlag := true;
                  writeln('Ref':12,NrS2(Nr):3,'Control Point, Subnet Error!':33); end;
               read(f,i1);
               REPEAT read(f,Dum); UNTIL Dum<>' '; end;
            If Pldum=' ' then begin PiLi := 'P';
               read(f,Snr); IdNr := Snr+100*Znr;
               p1 := Pipek[IdNr];
               If (p1<1) or (p1>Pimax) then begin ErrorFlag := true;
                  writeln('Ref':12,NrS2(Nr):3,'Control Point, Pipe Error!':31); end;
               REPEAT read(f,BE); UNTIL BE<>' ';
               If not (BE in ['B','E']) then begin ErrorFlag := true;
                  writeln('Ref':12,NrS2(Nr):3,'Control Point, B/E Error!':30); end;
               If BE='B' then i1 := 0 else i1 := 1; end;
            If not (PiLi in ['P','L']) then begin ErrorFlag := true;
               writeln('Ref':12,NrS2(Nr):3,'Control Point, P/L Error!':30); end;
            PL1 := PiLi;            
            Znr := ReadZ2(f); read(f,PLdum); PiLi := 'X';
            If PLdum in ['1'..'9'] then begin PiLi := 'L';
               Sid := ord(PLdum)-48+10*Znr; p2 := Supek[Sid];
               If (p2<1) or (p2>Sumax) then begin ErrorFlag := true;
                  writeln('Ref':12,NrS2(Nr):3,'Control Point, Subnet Error!':33); end;
               read(f,i2); end;
            If Pldum=' ' then begin PiLi := 'P';
               read(f,Snr); IdNr := Snr+100*Znr;
               p2 := Pipek[IdNr];
               If (p2<1) or (p2>Pimax) then begin ErrorFlag := true;
                  writeln('Ref':12,NrS2(Nr):3,'Control Point, Pipe Error!':31); end;
               REPEAT read(f,BE); UNTIL BE<>' ';
               If not (BE in ['B','E']) then begin ErrorFlag := true;
                  writeln('Ref':12,NrS2(Nr):3,'Control Point, B/E Error!':30); end;
               If BE='B' then i2 := 0 else i2 := 1; end; 
            If not (PiLi in ['P','L']) then begin ErrorFlag := true;
               writeln('Ref':12,NrS2(Nr):3,'Control Point, P/L Error!':30); end;
            PL2 := PiLi; 
            If PL1<>PL2 then begin ErrorFlag := true;
               writeln('Ref':12,NrS2(Nr):3,'Control Point, P/L Error!':30); end;
            end; {'D'}
       END; {Case SD}
    end; {With} end; {If Nr}
    readln(f); Red; read(f,ch); end; {WHILE ch}
    Cpmax := Cp;
END; {CtrlPoints}

BEGIN {Controls}
 CtrlDirectives; CtrlPoints;
 For i := 1 to DrCtrlmax do begin With DrCtrl[i] do begin
     If PoRef>0 then begin Cp := CpPek[PoRef];
        Code := CtrlPoint[Cp].Code; Setvalue := CtrlPoint[Cp].Setvalue;
        Fctrl := CtrlPoint[Cp].Fctrl; Dir := CtrlPoint[Cp].Dir;
        PiLi := CtrlPoint[Cp].PiLi;
        p1 := CtrlPoint[Cp].p1; i1 := CtrlPoint[Cp].i1;
        p2 := CtrlPoint[Cp].p2; i2 := CtrlPoint[Cp].i2; end
      else begin Code := 0; end;
     end; {For} end; {With}
 For i := 1 to VaCtrlmax do begin With VaCtrl[i] do begin
     If PoRef>0 then begin Cp := CpPek[PoRef];
        Code := CtrlPoint[Cp].Code; Setvalue := CtrlPoint[Cp].Setvalue;
        Fctrl := CtrlPoint[Cp].Fctrl; Dir := CtrlPoint[Cp].Dir;
        PiLi := CtrlPoint[Cp].PiLi;
        p1 := CtrlPoint[Cp].p1; i1 := CtrlPoint[Cp].i1;
        p2 := CtrlPoint[Cp].p2; i2 := CtrlPoint[Cp].i2; end
      else begin Code := 0; end;
     end; {For} end; {With}
END;  {Controls}

    BEGIN {Setpoints}
     writeln; ErrorFlag := false;
     Connect(f,Fil[2],'R'); Radantal := 1;
     If Felkod<>0 then begin 
        writeln('File not found:':33,Fil[2]:17); Gerror; end;
     readln(f); Red; read(f,ch); k := 0;
     WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
{ -------------- Case Declarations  -------------------------- }
     WHILE ch=' ' do begin k := k+1;
       REPEAT read(f,Dum6[1]); UNTIL Dum6[1]<>' ';
       For i := 2 to 6 do read(f,Dum6[i]);
       CaseId[k] := Dum6;
       read(f,Xva1[k],Xva2[k],Xva3[k]);
       For i := 1 to maxCaseCom do Dum40[i] := ' '; i := 1;
       REPEAT read(f,Dum40[i]); UNTIL Dum40[i]<>' ';
       WHILE not eoln(f) and (i<maxCaseCom) do
         begin i := i+1; read(f,Dum40[i]); end;
       CaseCom[k] := Dum40; readln(f); Red; read(f,ch); end;
     CaseMax := k; Aclear; writeln;
     writeln('Case':5,'CaseId':8,'x1':7,'x2':7,'x3':7,'Comments':12); writeln;
     For k := 1 to CaseMax do begin write(k:4,CaseId[k]:9,Xva1[k]:8:2);
         writeln(Xva2[k]:7:2,Xva3[k]:7:2,CaseCom[k]:43); end;
     writeln; writeln('Select Line, 0 for exit':40);
     k := LineNr(CaseMax); CaseK := k;
If (CaseK=0) then begin end
else begin
{ -------------- Meaning of x1,x2 and x3 --------------------- }
     For i := 1 to 20 do begin x1string[i] := ' ';
         x2string[i] := ' '; x3string[i] := ' '; end;
     WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
     REPEAT read(f,x1string[1]); UNTIL x1string[1]<>' ';
     For i := 2 to 20 do read(f,x1string[i]);
     REPEAT read(f,x2string[1]); UNTIL x2string[1]<>' ';
     For i := 2 to 20 do read(f,x2string[i]);
     REPEAT read(f,x3string[1]); UNTIL x3string[1]<>' '; i := 2;
     WHILE not eoln(f) do begin read(f,x3string[i]); i := i+1; end;
     readln(f); Red; read(f,ch);
     TSVFdata; IdCase := CaseId[k];
     X1var := Xva1[k]; X2var := Xva2[k]; X3var := Xva3[k];
{ -------------- Variable X-data ----------------------------- }
     If IdCase[6]='X' then begin Aclear;
        writeln('Selected Case : ':35,IdCase:6); writeln;
        writeln('1    Current value of x1 : ':35,X1var:8:2,': ':8,x1String:20);
        writeln('2    Current value of x2 : ':35,X2var:8:2,': ':8,x2String:20);
        writeln('3    Current value of x3 : ':35,X3var:8:2,': ':8,x3String:20);
        writeln; writeln('Select Line, 0 for exit':40);
      REPEAT
          Line := LineNr(3);
          If Line>0 then ConvFlag := false;
          CASE Line OF
           0: begin end;
           1: begin REPEAT write('x1 : ':35); X1var := ReadRl;
                    UNTIL not ReadError; end;
           2: begin REPEAT write('x2 : ':35); X2var := ReadRl;
                    UNTIL not ReadError; end;
           3: begin REPEAT write('x3 : ':35); X3var := ReadRl;
                    UNTIL not ReadError; end;
          END;
      UNTIL (Line=0); end; {If 'X'}
{ -------------- Read *.con if new case ---------------------- }
     If (IdCase<>SetCase) and (Setcase<>'------') then NewCaseFlag := true;
     If NewCaseFlag then Config; NewCaseFlag := false;
{ -------------- Miscellaneous Data -------------------------- }
     WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
     WHILE ch=' ' do begin
       If CaseFlag then begin
          Tinit := Rval(f); Hinit := Rval(f);
          Tsur := Rval(f); AaResp := Rval(f);
          Tempinit(Tinit); end; {If CaseFlag}
       readln(f); Red; read(f,ch); end; {While}
     WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
{ --------------- Heat Load Data ----------------------------- }
     WHILE ch=' ' do begin
       If CaseFlag then begin
          Aload := Rval(f); Aret := Rval(f);
          Bload := Rval(f); Bret := Rval(f);
          Cload := Rval(f); Cret := Rval(f);
          Dload := Rval(f); Dret := Rval(f);
          Eload := Rval(f); Eret := Rval(f);
          Gload := Rval(f); Fret := Rval(f); readln(f); Red;
          FaddA := Rval(f); TaddA := Rval(f);
          FaddB := Rval(f); TaddB := Rval(f);
          FaddC := Rval(f); TaddC := Rval(f);
          FaddD := Rval(f); TaddD := Rval(f);
          FaddE := Rval(f); TaddE := Rval(f);
          FaddF := Rval(f); TaddF := Rval(f);
          Aload := Aload+FaddA; Aret := Aret+TaddA;
          Bload := Bload+FaddB; Bret := Bret+TaddB;
          Cload := Cload+FaddC; Cret := Cret+TaddC;
          Dload := Dload+FaddD; Dret := Dret+TaddD;
          Eload := Eload+FaddE; Eret := Eret+TaddE;
          Gload := Gload+FaddF; Fret := Fret+TaddF; end; {If CaseFlag}
          For i := 1 to Csmax do begin With CsPost[i] do begin
              If Vnr=0 then begin
                 CASE Cat OF
                 'A': Pload := Pnom*Fsum*Aload;
                 'B': Pload := Pnom*Fsum*Bload;
                 'C': Pload := Pnom*Fsum*Cload;
                 'D': Pload := Pnom*Fsum*Dload;
                 'E': Pload := Pnom*Fsum*Eload;
                 'F': Pload := Pnom*Fsum*Gload;
                 END; {Case Cat} end; {If} end; {With} end; {For}
          For s := 1 to Sumax do begin
              For i := 1 to Lcsmax[s] do begin With LcsPost[s,i] do begin
                  If Vnr=0 then begin
                     CASE Cat OF
                     'A': Pload := Pnom*Fsum*Aload;
                     'B': Pload := Pnom*Fsum*Bload;
                     'C': Pload := Pnom*Fsum*Cload;
                     'D': Pload := Pnom*Fsum*Dload;
                     'E': Pload := Pnom*Fsum*Eload;
                     'F': Pload := Pnom*Fsum*Gload;
                     END; {Case Cat} end; end; {If} {With} end; {For i} end; {For s}
       readln(f); Red; read(f,ch); end; {While}
     WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
{ -------------- Boiler Set Points  -------------------------- }
     For i := 1 to Boilmax do Ambvec[i] := 0;
     WHILE ch=' ' do begin
       If CaseFlag then begin IdNr := ReadId(f);
          Znr := IdNr div 100; Nr := IdNr mod 100;
          If Nr=0 then begin readln(f); Red; end else begin
             Bo := 0;
             For i := 1 to Boilmax do
                 If Boiler[i].Id=IdNr then begin Bo := i; end;
             If Bo=0 then begin
                write('Boiler':12,IdS2(Znr):3,NrS2(Nr):3);
                writeln('Set Point Error!':20); Gerror; end;
             With Boiler[Bo] do begin
              Avboil := Rval(f);
              REPEAT read(f,MF); UNTIL (MF<>' ');
              If not (MF in ['M','F','S']) then begin ErrorFlag := true;
                 write('Boiler':12,IdS2(Znr):3,NrS2(Nr):3);
                 writeln('Max/Fix/Sta Error!':21); end;
              read(f,Dum); read(f,Dum);
              Wmax := Rval(f); Tboil := Rval(f);
              Avbp := Rval(f); Tpipe := Rval(f); end;
              If Ambvec[Bo]=0 then Ambvec[Bo] := 1
                 else begin ErrorFlag := true; write('Boiler':12,IdS2(Znr):3);
                      writeln(NrS2(Nr):3,'Ambigous Directive!':25); end;
       end; end;
       readln(f); Red; read(f,ch); end;
     WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
{ -------------- Pipe System Boundary Settings  -------------- }
     For i := 1 to Iomax do Ambvec[i] := 0;
     For s := 1 to Sumax do 
         For i := 1 to Liomax[s] do AmbMat[s,i] := 0;
     Line := 0;
     WHILE ch=' ' do begin
       If CaseFlag then begin Znr := ReadZ2(f);
          Line := Line+1; BoundFlag := false;
          read(f,PLdum); PiLi := 'X';
          If PLdum in ['1'..'9'] then begin PiLi := 'L';
             Sid := ord(PLdum)-48+10*Znr; s := Supek[Sid];
             If (s<1) or (s>Sumax) then begin
                writeln('Boundary condition Error!':30,'Cond':10,Line:3);
                Gerror; end;
             read(f,Nr);
             For i := 1 to Liomax[s] do With LioPost[s,i] do
                 If (Li=Nr) then begin BoundFlag := true;
                    REPEAT read(f,BE); UNTIL BE<>' ';
                    If not (BE in ['I','T','O','F']) then BoundFlag := false;
                    Elev := Rval(f); Temp := Rval(f);
                    REPEAT read(f,QP); UNTIL QP<>' ';
                    If not (QP in ['Q','P']) then BoundFlag := false;
                    Value := Rval(f);
                    If Ambmat[s,i]=0 then Ambmat[s,i] := 1
                       else begin ErrorFlag := true; write('Bound':12);
	                    write(IdS2(Znr):3,PlDum:1,NrS2(Li):3);
                            writeln('Ambigous directive!':25); end;
                    end; {if s} end; {if PLdum}
          If Pldum=' ' then begin PiLi := 'P';
             read(f,Nr); PiId := Nr+100*Znr; k := Pipek[PiId];
             For i :=1 to Iomax do With IoPost[i] do
                 If (k=Pi) then begin BoundFlag := true;
                    REPEAT read(f,BE); UNTIL BE<>' ';
                    If not (BE in ['I','T','O','F']) then BoundFlag := false;
                    Elev := Rval(f); Temp := Rval(f);
                    REPEAT read(f,QP); UNTIL QP<>' ';
                    If not (QP in ['Q','P']) then BoundFlag := false;
                    Value := Rval(f);
                    If Ambvec[i]=0 then Ambvec[i] := 1
                       else begin ErrorFlag := true; write('Bound':12);
                            write(IdS2(Znr):3,NrS2(Nr):3);
                            writeln('Ambigous Directive!':25); end;
                    end; {if k} end; {if PLdum}
          If not (PiLi in ['P','L']) then BoundFlag := false;
          If not BoundFlag then begin ErrorFlag := true;
             writeln('Boundary condition Error!':30,'+Cond':10,Line:3);
             Gerror; end;
          end; {if Dum6}
       readln(f); Red; read(f,ch); end; {while}
     WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
{ -------------- Pipe/Link Connection Settings  -------------- }
     For i := 1 to Cnmax do Ambvec[i] := 0;
     For s := 1 to Sumax do 
         For i := 1 to Lcnmax[s] do AmbMat[s,i] := 0;
     WHILE ch=' ' do begin
       If CaseFlag then begin
          Znr := ReadZ2(f); read(f,LP,Nr);
          If (LP in ['1'..'9']) then begin k := ord(LP)-48; LP := 'L'; end
                                else LP := 'P';
          CASE LP OF
          'P': begin IdNr := Nr+100*Znr;
               If (IdNr<1) or (IdNr>maxId) then begin
                  write('Pipe Conn':12,IdS2(IdNr):3,NrS2(Nr):3);
                  writeln('Set Point Error!':20); Gerror; end;
               For i := 1 to Cnmax do
                   If CnPost[i].Id=IdNr then begin PcnI := i;
                      If Ambvec[i]=0 then Ambvec[i] := 1
                         else begin ErrorFlag := true; write('Conn ':12);
                              write(IdS2(Znr):3,NrS2(Nr):3);
                              writeln('Ambigous Directive!':25); end;
               end; end;
          'L': begin Sid := k+10*Znr; s:= supek[Sid];
               If (s<1) or (s>maxSu) then begin
                  writeln('Subnet':12,IdS2(Znr):3,k:1,NrS2(Nr):3,'Set Point Error !':40);
                  Gerror; end;
               For i := 1 to Lcnmax[s] do
                   If LcnPost[s,i].Id=Nr then begin LcnI := i;
                      If Ambmat[s,i]=0 then Ambmat[s,i] := 1
                      else begin ErrorFlag := true; write('Conn ':12);
                           write(IdS2(Znr):3,k:1,Nr:3);
                           writeln('Ambigous directive!':25); end;
               end; end;
          END;
          REPEAT read(f,Typ[1]); UNTIL Typ[1]<>' ';
          read(f,Typ[2]); Code := EqtypToCode(Typ);  Tmp := 0;
          If not (Code in [1,2,3,4,5,6,7,8]) then begin
             writeln('Pipe/Link Conn, Etyp, Set Point Error!':40); Gerror; end;
          If Typ<>'N ' then Tmp := Rval(f);
          If LP='P' then begin CnPost[PcnI].Value := Tmp;
                    If CnPost[PcnI].Ecod<>Code then begin
                       writeln('Pipe/Link Conn, Etyp, Set Point Error!':40);
                       Gerror; end; end;
          If LP='L' then begin LcnPost[s,LcnI].Value := Tmp;
                    If LcnPost[s,LcnI].Ecod<>Code then begin
                       writeln('Pipe/Link Conn, Etyp, Set Point Error!':40);
                       Gerror; end; end;
          end; {If Dum6}
       readln(f); Red; read(f,ch); end;
{ -------------- Valve Set Points  --------------------------- }
{ -------------- Drive Set Points  ---------------------------- }
{--------------------Controls  --------------------------------}
     Controls;
     WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
{ -------------- Output Table  ------------------------------- }
     Ambvec[1] := 0;
     WHILE ch=' ' do begin
       If CaseFlag then begin
          If Ambvec[1]=0 then Ambvec[1] := 1
             else begin ErrorFlag := true;
                  writeln('Output Table, Ambigous directive!':35); end;
          For i := 1 to maxCheck do begin
              IdNr := ReadId(f); Nr := IdNr mod 100;
              If (IdNr<1) or (IdNr>maxId) then begin
                 writeln('Output Table, Pipe Error!':30); Gerror; end;
              If Pipek[IdNr]=0 then begin
                 writeln('Output Table, Pipe Error!':30); Gerror; end;
              With CheckPost[i] do begin
              Id := IdNr; W := Pipek[IdNr];
              REPEAT read(f,BE); UNTIL (BE<>' ');
              If (BE<>'B') and (BE<>'E') then begin ErrorFlag := true;
                 writeln('Output Table, Pipe B/E  Error!':30); end;
              end; end; end;
       readln(f); Red; read(f,ch); end; end;
      Close(f);
      If ErrorFlag then begin Gerror; end;
      x1 := X1var; x2 := X2var; x3 := X3var; writeln;
      If CaseK>0 then begin ConvFlag := false; SetCase := IdCase;
         Initiate(Qinit,Hinit,Tinit,AaStart,LaStart);
         writeln('Data read from : ':32,Fil[2]:maxCh1);
         writeln('Case : ':32,IdCase:6); Checksystem; 
         SetFlag := true; end;
    
    END; {SetPoints}

      PROCEDURE EchoSetNrs;
       BEGIN
        writeln('SET-FILE, NUMBERS OF':30); writeln;
	write('Case':11,'x1fx':6,'x2fx':6,'x3fx':6,'Vctrl':6);
        writeln('DrCtrl':7); writeln;
        write('Used':5,Casemax:5,fxmax[1]:6,fxmax[2]:6,fxmax[3]:6);
        writeln(VaCtrlmax:6,DrCtrlmax:6);
        write('Dim':5,maxCase:5,maxFxPost:6,maxFxPost:6,maxFxPost:6);
        writeln(maxVaCtrl:6,maxDrCtrl:6); 
        Stop;
       END;
       
      PROCEDURE SetMenu;
       VAR ch : char;
       BEGIN
        Aclear; writeln(Mmenu); writeln(Dash);
        writeln; writeln;
        writeln(' ':14,'Set System Control Parameters');
        writeln(' ':14,'-----------------------------');
        writeln;
        writeln(' ':14,'1 - Set Boundary Conditions');
        writeln(' ':14,'2 - Set Pipe/Link Connections');
        writeln(' ':14,'3 - Set Heat Loads (Pnom/dTr)');
        writeln(' ':14,'4 - Set All Heat Loads (Fload/Tret)');
        writeln(' ':14,'5 - Set Valves  (S and Ctrl)');
        writeln(' ':14,'6 - Set Pump Drives (N and Ctrl)');
        writeln(' ':14,'7 - Set Boiler/Heater/Cooler');
        writeln(' ':14,'8 - Set Predefined Case Set Points');
        writeln(' ':14,'9 - Show Set-related, Numbers of');
        writeln(' ':14,'0 - Return to Main Menu'); writeln;
        REPEAT
          write('Choice : ':14); read(ch); readln; ch := Uchar(ch);
        UNTIL (ord(ch)>47) and (ord(ch)<58) or (ch in MenuSet);
        If (ch in Menuset) then begin Choice := ch; Alt := 10; end
                           else begin Alt := ord(ch)-48; end;
        OldChoice := 'S';
       END;    {SetMenu}

     BEGIN  { SetSyst}
      REPEAT  SetMenu; Dummy := 1;
       CASE Alt OF
        0: begin Choice := 'X'; Dummy := 0; end;
        1: begin Aclear; SetBounds; end;
        2: begin Aclear; SetConns;  end;
        3: begin Aclear; SetPnom;   end;
        4: begin Aclear; SetHloads; end;
        5: begin Aclear; ValveSet;  end;
        6: begin Aclear; Driveset;  end;
        7: begin Aclear; SetBoiler; end;
        8: begin SetPoints; end;
        9: begin If OK(SetFlag) then begin Aclear; EchoSetNrs end
	                        else Stop; end;
       10: begin Dummy := 0; end;
       END;
      UNTIL (Dummy=0);
     END;   { SetSyst}

    PROCEDURE Runset;
      VAR Oldset : real;
          Alt,i,Nr : integer;

      PROCEDURE IterInit;
       VAR i : integer;
       BEGIN
        REPEAT Aclear; 
         writeln('1  Current value of Itermax : ':37,Itermax:4);
         writeln('2  Current Value of Step Nr : ':37,Step:3);
         writeln; writeln('Select Line, 0 for exit ':40);
         i := LineNr(2);
         If i>0 then
            CASE i OF
            1: REPEAT write('Itermax : ':37); Itermax := ReadIr;
               UNTIL not ReadError;
            2: REPEAT write('Step Nr : ':37); Step := ReadIr;
               UNTIL not ReadError;
            END;
        UNTIL i=0;
       END;

      PROCEDURE HTinit;
       VAR i : integer;
       BEGIN
        REPEAT Aclear;
         writeln('1  Initial Head         Hinit : ':39,Hinit:5:1);
         writeln('2  Initial Temperature  Tinit : ':39,Tinit:5:1); writeln;
         writeln('Corresponding Liquid properties are : ':46); writeln;
         writeln('Viscosity    cSt: ':30,Ny*1E06:5:1);
         writeln('Density    kg/m3: ':30,Ra:5:1);
         writeln('Sp Heat  kJ/kg,K: ':30,Csp:5:1);
         writeln('Vapor Pres   mvp: ':30,Hvap:5:1);
         writeln('Bulk E-mod GN/m2: ':30,Emod:5:1);
         writeln; writeln('Select Line, 0 for exit ':40);
         i := LineNr(2);
         If i>0 then begin
            CASE i OF
            1: REPEAT write('Hinit : ':39); Hinit := ReadRl;
               UNTIL not ReadError;
            2: REPEAT write('Tinit : ':39); Tinit := ReadRl;
               UNTIL not ReadError;
            END;
            Initiate(Qinit,Hinit,Tinit,AaStart,LaStart); end;
         UNTIL i=0;
       END; { HTinit}

      PROCEDURE Tolset;
       VAR i,Dec : integer;
       BEGIN
        REPEAT Aclear; 
         Dec := DecF(Htol);
         writeln('1  Head Tolerance   Htol : ':34,Htol:Dec+2:Dec);
         Dec := DecF(Qtol);
         writeln('2  Flow Tolerance   Qtol : ':34,Qtol:Dec+2:Dec);
         Dec := DecF(Ftol);
         writeln('3  Int Tol Factor   Ftol : ':34,Ftol:Dec+2:Dec);
         writeln; writeln('Select Line, 0 for exit ':40);
         i := LineNr(3);
         If i>0 then
            CASE i OF
            1: REPEAT write('Htol : ':34); Htol := ReadRl;
               UNTIL not ReadError;
            2: REPEAT write('Qtol : ':34); Qtol := ReadRl;
               UNTIL not ReadError;
            3: REPEAT write('Ftol : ':34); Ftol := ReadRl;
               UNTIL not ReadError;
            END;
         UNTIL i=0;
       END; {Tolset}

      PROCEDURE SetIncep;
       VAR i : integer;
        BEGIN
         REPEAT Aclear; 
          writeln('Line   Current Inception Values':36); 
	  writeln;
          writeln('1    Control Inception   Mctrl : ':40,Mctrl:2);
          writeln('2    Tolerance change     Mtol : ':40,Mtol:2);
	  writeln('3    First conv check     Mmin : ':40,Mmin:2);
          writeln; writeln('Select Line, 0 for exit':40);  
          i := LineNr(3);
          If i>0 then begin
             CASE i OF
             1: REPEAT write('Mctrl : ':40); Mctrl := ReadIr; 
                UNTIL not ReadError;
             2: REPEAT write('Mtol : ':40); Mtol := ReadIr;
                UNTIL not ReadError;      
             3: REPEAT write('Mmin : ':40); Mmin := ReadIr;
                UNTIL not ReadError;
             END; end;
         UNTIL (i=0);      
        END; {SetIncep}

      PROCEDURE Ppos;
        VAR  i,Znr,Nr : integer;
        BEGIN  { Ppos }
         REPEAT Aclear;
          writeln('Show Head and Flow for following Pipes:':45); writeln;
          writeln('Line':10,'ZnNr':7,'B/E':6); writeln;
          For i := 1 to maxCheck do begin write(i:8);
              With CheckPost[i] do begin
              Znr := Id div 100; Nr := Id mod 100;
              writeln(IdS2(Znr):7,NrS2(Nr):2,BE:5); end; end;
          writeln; writeln('Select Line, 0 for exit':40);
          i := LineNr(maxCheck);
          If i>0 then begin With CheckPost[i] do begin
             REPEAT write('Pipe ZnNr: ':40); Id := readId(input); readln; 
             UNTIL Pipek[Id]>0;
             REPEAT write('B/E: ':40); read(BE); readln; BE := Uchar(BE);
             UNTIL (BE='B') or (BE='E');
             W := Pipek[Id];
             end; end;
         UNTIL (i=0);
        END;   { Ppos }

      PROCEDURE SetFctrl;
        VAR i,j,Znr,Nr,Line,Pos : integer;
       BEGIN
        REPEAT Aclear;
         writeln('Current values of Fctrl are :':36); writeln;
         writeln('Line':11,'   Valve/Drive   Fctrl'); writeln; 
         Line := 0;
         For i := 1 to VaCtrlmax do begin With VaCtrl[i] do begin
             Znr := VaId div 100; Nr := VaId mod 100;
             Line := Line+1;
             writeln(Line:9,'Valve':10, IdS2(Znr):4,NrS2(Nr):2,Fctrl:8:2);
             end; end;
         For j := 1 to DrCtrlmax do begin With DrCtrl[j] do begin
             Znr := DrId div 100; Nr := DrId mod 100;
             Line := Line+1;
             writeln(Line:9,'Drive':10,IdS2(Znr):4,NrS2(Nr):2,Fctrl:8:2);
             end; end;
         writeln; writeln('Select Line, 0 for exit ':40);
         Line := LineNr(VaCtrlmax+DrCtrlmax); Pos := 10;
         If ((Line>0) and (Line<=VaCtrlmax)) then begin
            With VaCtrl[Line] do begin
	    Znr := VaId div 100; Nr := VaId mod 100;
            write('Valve':19,IdS2(Znr):4,NrS2(Nr):2);
            REPEAT write('Fctrl : ':Pos); Fctrl := ReadRl; Pos := 35;
            UNTIL not ReadError; end; end;
         If ((Line>0) and (Line>VaCtrlmax)) then begin
            With DrCtrl[Line-VaCtrlmax] do begin
	    Znr := DrId div 100; Nr := DrId mod 100;
            write('Drive':19,IdS2(Znr):4,NrS2(Nr):2);
            REPEAT write('Fctrl : ':Pos); Fctrl := ReadRl; Pos := 35;
            UNTIL not ReadError; end; end;
        UNTIL (Line=0);
       END;    {SetFctrl}

      PROCEDURE InitMenu;
       VAR ch : char;
       BEGIN
        Aclear; writeln(Mmenu); writeln(Dash);
        writeln; writeln;
        writeln(' ':14,'Change Initial Miscellaneous Data');
        writeln(' ':14,'--------------------------------');
        writeln;
        writeln(' ':14,'1 - Change Number of Iterations');
        writeln(' ':14,'2 - Change all Fl-values to 1.00');
        writeln(' ':14,'3 - Change Initial Head and Temp');
        writeln(' ':14,'4 - Change Head/Flow Tolerance');
        writeln(' ':14,'5 - Change Inception values');
        writeln(' ':14,'6 - Change Pipe Heat Loss Factor');
        writeln(' ':14,'7 - Change Head/Flow Response');
        writeln(' ':14,'8 - Change Pipe Checkpoints');
        writeln(' ':14,'9 - Change Auto Control Factor (Fctrl)');
        writeln(' ':14,'0 - Return to Main Menu'); writeln;
        REPEAT
          write('Choice : ':14); read(ch); readln; ch := Uchar(ch);
        UNTIL (ord(ch)>47) and (ord(ch)<58) or (ch in MenuSet);
        If (ch in Menuset) then begin Choice := ch; Alt := 10; end
                           else begin Alt := ord(ch)-48; end;
        OldChoice := 'I';
       END;    {InitMenu}

      BEGIN  { Runset }
       REPEAT  Initmenu; Dummy := 1;
        CASE Alt OF
         0: begin Choice := 'X'; Dummy := 0; end;
         1: begin Aclear; IterInit; end;
         2: begin Aclear; write('Change all Fl-values to 1.00':30); Nr := 12;
                  REPEAT write('Y/N : ':Nr); read(FlYN); readln; Nr := 42;
                   FlYN := Uchar(FlYN); UNTIL (FlYN in ['Y','N']);
                  If FlYN='Y' then
                     For i := 1 to Vamax do VrefPost[i].Fl := 1.00; end;
         3: begin Aclear; HTinit; end;
         4: begin Aclear; Tolset; end;
         5: begin Aclear; SetIncep; end;
         6: begin Aclear;
                  writeln('Heat transfer K = K-factor*K-value':40); writeln;
                  writeln('Current Pipe Heat Loss Factor is : ':40,Kfac:4:2);
                  REPEAT write('Set new K-factor : ':40); Kfac := ReadRl;
                  UNTIL not ReadError; end;
         7: begin Oldset := AaSet; Aclear;
                  writeln('Current Head/Flow Response : ':35,round(AaResp):4);
                  REPEAT write('Set new Head/Flow Response : ':35);
                  AaResp := ReadRl; UNTIL not ReadError;
                  AaSet := AaResp; NewRespons(Oldset,AaSet); end;
         8: begin Aclear; Ppos; end;
         9: begin Aclear; SetFctrl; end;
        10: begin Dummy := 0; end;
        END;  { Case }
       UNTIL ( Dummy = 0);
      END;   { Runset }

   PROCEDURE Calculate;
     VAR OldSet : real;
         Alt : integer;
         dTtFlag : Boolean;

     PROCEDURE SetdTt;
      VAR p,i0,i1 : integer;
          T,Q,dT : real;
      BEGIN
        i0 := 0; i1 := 1;
        For p := 1 to Pimax do begin With PipePost[p] do begin
            T := (Tt[p,i0]+Tt[p,i1])/2; Q := (Qt[p,i0]+Qt[p,i1])/2;
            dT := abs(Tt[p,i0]-Tt[p,i1]);
            If abs(Q)<Qtol then dTt[p] := 0.0
               else dTt[p] := L*(T-Tsur)*Kfac*Kval/1000/Ra/Csp/abs(Q);
            If dTt[p]>(dT+0.1) then dTt[p] := dT+0.1;
            If dTt[p]<(dT-0.1) then dTt[p] := dT-0.1;
            If  Q>0 then Tt[p,i1] := Tt[p,i0]-dTt[p]
                   else Tt[p,i0] := Tt[p,i1]-dTt[p];
        end; end;
      END;  {SetdTt}

     PROCEDURE Warning;
       VAR i,s,Nr,Pi,ip,Pu,Dr,Idp,Bo,Dec,Va,Znr : integer;
           Pr,dPl,Ppipe,Etr,Paxel,Pmotor,Emo,Nhr,Nha,dHcav,
           Avmax,Avtot,dTdum,Qdum,Cltol,Deg,Rpm,Calc : real;
           Pkw : array[1..maxBoil] of integer;
           Kod : packed array[1..2] of char;
           Dum : packed array[1..4] of char;
           Aflag,BoilFlag,DrivFlag : Boolean;
           f8 : text;

     PROCEDURE Encode(Code:integer);
      CONST Ttol = 0.05;
      BEGIN
        CASE Code OF
        1,2,9: begin ClTol := 10*Htol; Kod := 'dH'; Dec := 1; end; {H,dH}
        3,4: begin ClTol := 10*Qtol; Kod := 'dQ'; Dec := 4; end; {Q,dQ}
        5,6: begin ClTol := 10*Ttol; Kod := 'dT'; Dec := 1; end; {T,dT}
        7,8: begin ClTol := Ra*Csp*100*Qtol;                     {W,dW}
                                     Kod := 'dW'; Dec := 0; end;
        END; {case code}
        If odd(Code) then begin
           Kod[1] := Kod[2]; Kod[2] := ' '; end;
      END; {Encode}

       BEGIN {Warning}
         Aflag := false;  BoilFlag := false; DrivFlag := false;
         writeln;
         Connect(f8,Fil[8],'W');
         If not ConvFlag then begin
            writeln(f8,'M = Itermax !!!!!!       WARNING ONLY!':46);
            writeln(f8); end;
         write(f8,'UNSATISFIED HEAT LOADS :':24);
         dPl := 0;
         For i := 1 to Csmax do begin With CsPost[i] do begin
             If (Vnr=0) and ((Qcs-Ql)<(-10*Epsi)) then begin {(-2*Qtol)}
                If not Aflag then begin writeln(f8); writeln(f8);
                   writeln(f8,'Node type   Zon Nr   Preal   Pload    Comments':45);
                   writeln(f8); end;
                Aflag := true; Znr := Id div 100; Nr := Id mod 100;
                Pr := RaCsp*Qcs*abs(Tf-Tr); dPl := dPl+Pload-Pr;
                write(f8,'Pipe Cross':10,IdS2(Znr):4,NrS2(Nr):4,round(Pr):8);
                writeln(f8,round(Pload):8,Com:16); end; end; end;
         For s := 1 to Sumax do begin
             For i := 1 to Lcsmax[s] do begin With LcsPost[s,i] do begin
                 If (Vnr=0) and ((Qcs-Ql)<(-10*Epsi)) then begin  {(-2*Qtol)}
                    If not Aflag then begin writeln(f8); writeln(f8);
                       writeln(f8,'Node type   Zon Nr   Preal   Pload    Comments':45);
                       writeln(f8); end;
                    Aflag := true; Znr := SubId[s] div 10; 
                    Nr := SubId[s] mod 10; 
                    Pr := RaCsp*Qcs*abs(Tf-Tr); dPl := dPl+Pload-Pr;
                    write(f8,'Link Cross':10,IdS2(Znr):4,Nr:1,NrS2(Id):3);
                    writeln(f8,round(Pr):8,round(Pload):8,Com:16); end;
         end; end; end;
         If Aflag then begin writeln(f8);
            write(f8,'Total Heat Load Shortage : ':27);
            writeln(f8,round(dPl):6,'kW':3);
            writeln('Unsatisfied Heat Load!      Warning only!':52); end
         else begin writeln(f8,'No Alarms to report!':28); end;
         writeln(f8); Aflag := false;
         write(f8,'PIPE PRESSURE ALARMS :':22);
         For i := 1 to Alarmmax do begin With AlarmPost[i] do begin
             Znr := Id div 100; Nr := Id mod 100;
             Pi := Pipek[Id];
             If BE='B' then begin ip := 0; Dum := ' Beg'; end
                       else begin ip := 1; Dum := ' End'; end;
             Ppipe := Density(Tt[Pi,ip])*g*(Ht[Pi,ip]-Zpi)/1E05;
             If (HL='H') and (Ppipe>bar) then begin
                If not Aflag then begin writeln(f8); writeln(f8);
                   writeln(f8,'Pipe  B/E   H/L   Real bar Alarm  Comments':42);
                   writeln(f8); end; Aflag := true;
                write(f8,IdS2(Znr):2,NrS2(Nr):2,Dum:5,'High':7,Ppipe:7:2);
                writeln(f8,bar:8:1,PipePost[Pi].Com:15); end;
             If (HL='L') and (Ppipe<bar) then begin
                If not Aflag then begin writeln(f8); writeln(f8);
                   writeln(f8,'Pipe  B/E   H/L   Real bar Alarm  Comments':42);
                   writeln(f8); end; Aflag := true;
                write(f8,IdS2(Znr):2,NrS2(Nr):2,Dum:5,'Low ':7,Ppipe:7:2);
                writeln(f8,bar:8:1,PipePost[Pi].Com:15); end;
             end; {For i} end; {with}
         If Aflag then writeln('Pipe Pressure Alarm!        Warning only!':52)
                  else begin writeln(f8,'No Alarms to report!':30); end;
         writeln(f8); Aflag := false;

         write(f8,'ATMOSPHERIC PRESSURE ALARMS :':29);
         For i := 1 to Pimax do begin with pipepost[i] do begin
          Znr := Id div 100; Nr := Id mod 100;
          If Ht[i,0]<Zp[0] then begin
                If not Aflag then begin writeln(f8); writeln(f8);
                   writeln(f8,'Pipe  B/E  Hpipe [m Lc]  Zpipe [m]  Comments':44);
                   writeln(f8); end; Aflag := true;
                write(f8,IdS2(Znr):2,NrS2(Nr):2,' Beg ':6,Ht[i,0]:6:1,Zp[0]:14:1);
                writeln(f8,Com:18);
          end;
          If Ht[i,1]<Zp[1] then begin
                If not Aflag then begin writeln(f8); writeln(f8);
                   writeln(f8,'Pipe  B/E  Hpipe [m Lc]  Zpipe [m]  Comments':44);
                   writeln(f8); end; Aflag := true;
                write(f8,IdS2(Znr):2,NrS2(Nr):2,' End ':6,Ht[i,1]:6:1,Zp[1]:14:1);
                writeln(f8,Com:18);
          end;
         end;end;
         If Aflag then writeln('Atmospheric Pressure Alarm!         Warning only!':52)
                  else begin writeln(f8,'No Alarms to report!':23); end;
         writeln(f8); Aflag := false;

         
         write(f8,'DESIGN PRESSURE ALARMS :':24);
         For i := 1 to Pimax do begin with pipepost[i] do begin
          Znr := Id div 100; Nr := Id mod 100;
          Ppipe := Density(Tt[i,0])*g*(Ht[i,0]-Zp[0])/1E05;
          If Ppipe>dp then begin
                If not Aflag then begin writeln(f8); writeln(f8);
                   writeln(f8,'Pipe  B/E  Ppipe [bar]  Pdesign [bar]  Comments':44);
                   writeln(f8); end; Aflag := true;
                write(f8,IdS2(Znr):2,NrS2(Nr):2,' Beg ':6,Ppipe:6:1,dp:14:1);
                writeln(f8,Com:18);
          end;
          Ppipe := Density(Tt[i,1])*g*(Ht[i,1]-Zp[1])/1E05;
          If Ppipe>dp then begin
                If not Aflag then begin writeln(f8); writeln(f8);
                   writeln(f8,'Pipe  B/E  Ppipe [bar]  Pdesign [bar]  Comments':44);
                   writeln(f8); end; Aflag := true;
                write(f8,IdS2(Znr):2,NrS2(Nr):2,' End ':6,Ppipe:6:1,dp:14:1);
                writeln(f8,Com:18);
          end;
         end;end;
         If Aflag then writeln('Design Pressure Alarm!         Warning only!':52)
                  else begin writeln(f8,'No Alarms to report!':28); end;
         writeln(f8); Aflag := false;
         
                  
         write(f8,'BOILER/HEATER/COOLER ALARMS :':29);
         For i := 1 to maxBoil do Pkw[i] := 0;
         For i := 1 to Cnmax do begin  With CnPost[i] do begin
             If (Ecod=12) then begin Bo := Enr;
                dTdum := Tt[Pfr,0]-Tt[Pto,1];
                Qdum := (Qt[Pto,1]+Qt[Pfr,0])/2;
                Pkw[Bo] := round(Boiler[Bo].RaCsp*Qdum*dTdum); end; end; end;
         For s := 1 to Sumax do begin
             For i := 1 to Lcnmax[s] do begin With LcnPost[s,i] do begin
                 If (Ecod=12) then begin Bo := Enr;
                    dTdum := Tli[s,Lfr]-Tli[s,Lto];
                    Qdum := (Cpl[s,Lfr]+Cml[s,Lfr]+Cpl[s,Lto]+Cml[s,Lto])/4;
                    Pkw[Bo] := round(Boiler[Bo].RaCsp*Qdum*dTdum);
             end; end; end; end;
         For i := 1 to Boilmax do begin With Boiler[i] do begin
             BoilFlag := false;
             CASE MF OF
             'M': If abs(Wmax)>=Epsi then begin
                     If abs(Tb-Tboil)>0.01 then BoilFlag := true;
                     If abs(Tp-Tpipe)>0.01 then BoilFlag := true; end;
             'F': If (abs((Wmax-Pkw[i])/Wmax)>0.005) then BoilFlag := true;
             'S': If Qbt>10*Epsi then begin
                     If abs(Tb-Tboil)>0.01 then BoilFlag := true;
                     If abs(Tp-Tpipe)>0.01 then BoilFlag := true; end;
             END;
             If BoilFlag then begin
                Znr := Id div 100; Nr := Id mod 100;
                Avmax := Avboil+Avbp;
                If (abs(Wmax)>Epsi) and (abs(Qbt)<Epsi)
                   then Avtot := 0 else Avtot := Avres;
                If not Aflag then begin writeln(f8); writeln(f8);
                   write(f8,'ZnNr   P kw   Qboil   Tb C  Tboil  Tp C  ':41);
                   writeln(f8,'Tpipe   Av  m2  Avmax  Comments':31);
                   writeln(f8); end; Aflag := true;
                write(f8,IdS2(Znr):2,NrS2(Nr):2,Pkw[i]:8,Qbt:8:4,Tb:7:1,Tboil:6:1);
                writeln(f8,Tp:7:1,Tpipe:6:1,Avtot:9:4,Avmax:7:4,Com:14); end;
           end; end;
         If Aflag then writeln('Boiler/Heater/Cooler Alarm! Warning only!':52)
                   else begin writeln(f8,'No Alarms to report!':23); end;
         writeln(f8); Aflag := false;

         write(f8,'PUMP CAVITATION ALARMS :':24);
         For Pu := 1 to Pumax do begin With PrefPost[Pu] do begin
             Nhr := PumpNh(Id,Np,Qpt[Pu]); TempInit(Tpt[Pu]);
             Nha := H1pt[Pu]+Hatm-Zp-Hvap; TempInit(Tinit);
             If Nha<Nhr then begin
                If not Aflag then begin writeln(f8); writeln(f8);
                   writeln(f8,'Pump   NPSHava  NPSHreq  dHcav  Comments':40);
                   writeln(f8); end; Aflag := true;
                Znr := Id div 100; Nr := Id mod 100;
                dHcav := Nha-Nhr;
                write(f8,IdS2(Znr):2,NrS2(Nr):2,Nha:8:1,Nhr:9:1);
                writeln(f8,dHcav:8:1,Com:15); end;
         end; end;
         If Aflag then writeln('Pump Cavitation!            Warning only!':52)
                   else begin writeln(f8,'No Alarms to report!':28); end;
         writeln(f8); Aflag := false;

         write(f8,'PUMP DRIVE ALARMS :':19);
         For i := 1 to Drmax do begin With DrivePost[i] do begin
             Paxel := 0; DrivFlag := false;
             For Pu := 1 to Pumax do begin
                 Dr := Drpek[PrefPost[Pu].DrId];
                 If (Dr=i) then begin Idp := PrefPost[Pu].Id;
                    Paxel := Paxel+ PumpMp(Idp,Ndr,Qpt[Pu])*Pii*Ndr/30/1000;
             end; end;
             Etr := Etrans(Ndr/Nmot,i);
             If (abs(Paxel)>Epsi) then Pmotor := Paxel/Etr
                                  else Pmotor := 0;
             Emo := Emotor(Pmotor/Pmot,i);
             If ((Ndr/Nmot)>Nmax) then DrivFlag := true;
             If (Ndr<0) then DrivFlag := true;
             If (Etr<Etrmin) then DrivFlag := true;
             If (Emo<Emomin) then DrivFlag := true;
             If (Pmot<Pmotor) then DrivFlag := true;
             If DrivFlag then begin
                If not Aflag then begin writeln(f8); writeln(f8);
                   write(f8,'Drive Pnom Pmotor Emotor  Evar  Nmax   -N- ':43);
                   writeln(f8,'Comments':11); writeln(f8); end; Aflag := true;
                Znr := Id div 100; Nr := Id mod 100;
                write(f8,IdS2(Znr):2,NrS2(Nr):2,round(Pmot):6,round(Pmotor):6);
                writeln(f8,Emo:7:2,Etr:7:2,Nmax:6:2,Ndr/Nmot:7:3,Com:15); end;
             end; end;
         If Aflag then writeln('Pump Drive Alarm!           Warning only!':52)
                   else begin writeln(f8,'No Alarms to report!':33); end;
         writeln(f8); Aflag := false;

         write(f8,'VALVE INLET VAPOUR ALARMS :':27);
         For Va := 1 to Vamax do begin With VrefPost[Va] do begin
             If Qvt[Va]>0 then dHcav := H1vt[Va]-Hch
                          else dHcav := H2vt[Va]-Hch;
             If dHcav<0 then begin
                If not Aflag then begin writeln(f8); writeln(f8);
                   writeln(f8,'Valve  Hinlet Hvapour  Comments':31);
                   writeln(f8); end; Aflag := true;
                Znr := Id div 100; Nr := Id mod 100;
                write(f8,IdS2(Znr):2,NrS2(Nr):2,(dHcav+Hch):8:1);
                writeln(f8,Hch:8:1,Com:15); end;
         end; end;
         If Aflag then writeln('Valve Inlet Vapour!         Warning only!':52)
                   else begin writeln(f8,'No Alarms to report!':25); end;
         writeln(f8); Aflag := false;

         write(f8,'AUTO CONTROL ALARMS :':21);
         For i := 1 to VaCtrlmax do begin With VaCtrl[i] do begin
             Encode(Code);
             If abs(setvalue)>1000 then Cltol := 0.01*abs(Setvalue);
             If abs(dSetOld)>ClTol then begin
                If not Aflag then begin writeln(f8); writeln(f8);
                   write(f8,'Ctrl ':5,'ZnNr':6,'Set-value':11,'Calc value':12);
                   writeln(f8,'  S/N  ':9); writeln(f8); end; Aflag := true;
                Znr := VaId div 100; Nr := VaId mod 100;
                Va := Vapek[VaId]; Deg := VrefPost[Va].S;
                Calc := Setvalue-dSetOld;
                write(f8,'Valve':5,IdS2(Znr):4,NrS2(Nr):2,Kod:4);
                writeln(f8,Setvalue:7:Dec,Calc:10:Dec,Deg:10:3); end;
         end; end;
         For i := 1 to DrCtrlmax do begin With DrCtrl[i] do begin
             Encode(Code);
             If abs(setvalue)>1000 then Cltol := 0.01*abs(Setvalue);
             If abs(dSetOld)>ClTol then begin
                If not Aflag then begin writeln(f8); writeln(f8);
                   write(f8,'Ctrl ':5,'ZnNr':6,'Set-value':11,'Calc value':12);
                   writeln(f8,'  S/N  ':9); writeln(f8); end; Aflag := true;
                Znr := DrId div 100; Nr := DrId mod 100;
                Dr := DrPek[DrId]; Rpm := DrivePost[Dr].Ndr/DrivePost[Dr].Nmot;
                Calc := Setvalue-dSetOld;
                write(f8,'Drive':5,IdS2(Znr):4,NrS2(Nr):2,Kod:4);
                writeln(f8,Setvalue:7:Dec,Calc:10:Dec,Rpm:10:3); end;
         end; end;
         If Aflag then writeln('Auto Control Alarm!         Warning only!':52)
                   else begin writeln(f8,'No Alarms to report!':31); end;
         Close(f8); AlarmFlag := true; 
       END;  {Warning}

   PROCEDURE ListAlarms;
    CONST maxCh = 80;
    VAR   i,j : integer;
          Rad : packed array[1..maxCh] of char;
          f8 : text;
    BEGIN
     Connect(f8,Fil[8],'R'); j := 0;
     WHILE not eof(f8) do begin
       For i := 1 to maxCh do Rad[i] := ' ';
       i := 1; j := j+1;
       WHILE not eoln(f8) do begin read(f8,Rad[i]); i := i+1; end;
       readln(f8); writeln(Rad);
       If (j mod ContLines)=0 then Paus;
     end; {while eof}
     Close(f8);
    END;    {ListAlarms}

   FUNCTION Qcheck(Kr,Kc,Av:real) : real;
      VAR   Qc,Kp,X : real;
      BEGIN
       If (Kc<=0) or (Av=0) then Qc := 0
       else begin Kp := 1/g/sqr(Av); X := 4*Kp*Kc/sqr(Kr);
                  Qc := Kr/Kp/2*(-1+Sqrt(1+X)); end;
       Qcheck := Qc;
      END;   { Qcheck }

   FUNCTION Qrv(Kr,Kc:real; Rv:integer) : real;
      VAR   Qc,Kq,Ko : real;
      BEGIN
       With Rvpost[Rv] do begin
       If ((Kc-A)<=0) then Qc := 0
       else begin Kq := (Kr+B)/C; Ko := (Kc-A)/C;
                  Qc := -Kq/2+sqrt(sqr(Kq/2)+Ko); end;
       end; {With} Qrv := Qc;
      END;   { Qrv }

   FUNCTION Qav(Kr,Kc,Av : real) : real;
     VAR   Ka,X,Qa : real;
           Sign : integer;
     BEGIN
      If Kc<=0 then Sign := +1 else Sign := -1;
      If Av=0 then Qa := 0
      else begin Ka := g*sqr(Av);
                 X := 4*abs(Kc)/sqr(Kr)/Ka;
                 Qa := Sign*Kr*Ka/2*(-1+Sqrt(1+X)); end;
      Qav := Qa;
     END; { Qav }

   FUNCTION Qstr(Kr,Kc,Ap,Am:real) : real;
     VAR   Ka,X,Qa : real;
           Sign : integer;
     BEGIN
      If Kc<=0 then begin Sign := +1; Ka := g*sqr(Ap); end
               else begin Sign := -1; Ka := g*sqr(Am); end;
      If Ka=0 then Qa := 0
      else begin X := 4*abs(Kc)/sqr(Kr)/Ka;
                 Qa := Sign*Kr*Ka/2*(-1+Sqrt(1+X)); end;
      Qstr := Qa;
     END; { Qstr }

{   FUNCTION Qstr(Kr,Kc,Ap,Am:real) : real;
     VAR   Kp,X : real;
           Sign : integer;
     BEGIN
      If Kc<=0 then begin Sign := +1; Kp := 1/g/sqr(Ap); end
               else begin Sign := -1; Kp := 1/g/sqr(Am); end;
      X := 4*Kp*abs(Kc)/sqr(Kr);
      Qstr := Sign*Kr/Kp/2*(-1+Sqrt(1+X));
     END;} { Qstr }

   FUNCTION Qjunc(Kr,Kc,Kcc : real; Vnr : integer) : real;
     VAR  Q,Kp,X,Qch,Ava : real;
          Vr,Va,Sign : integer;
     BEGIN       {Obs! Kkorr global variabel}
       Va := Vapek[Vnr];
       If (VrefPost[Va].Fi<Epsi) then begin Q := 0; Kkorr := 0; end
       else begin
            Vr := VrefPost[Va].Vref; Vr := VaPerfPek[Vr];
            If Kc>=0 then begin Kp := 1/g/sqr(VrefPost[Va].Fi*ValvePerf[Vr].Avp);
                                Sign := +1; end
                     else begin Kp := 1/g/sqr(VrefPost[Va].Fi*ValvePerf[Vr].Avm);
                                Sign := -1; end;
            X := 4*Kp*abs(Kc)/sqr(Kr);
            Q := Sign*Kr/Kp/2*(-1+Sqrt(1+X));
            Kkorr := 1/(2*Kp*abs(Q)+Kr);
            If Kc>0 then begin Ava := VrefPost[Va].Fi*ValvePerf[Vr].Avp;
                    If Kcc<=0 then Qch := 1E05
                             else Qch := VrefPost[Va].Fl*Ava*sqrt(g*Kcc); end
               else begin Ava := VrefPost[Va].Fi*ValvePerf[Vr].Avm;
                    If Kcc<=0 then Qch := 1E05
                             else Qch := -VrefPost[Va].Fl*Ava*sqrt(g*Kcc); end;
            If abs(Q)>abs(Qch) then begin
               Q := Qch; Kkorr := abs(Q)/(2*Kcc); end; end;
       Qjunc := Q;
     END;   {Qjunc}

   FUNCTION Svalve(Kr,Kc,Krc,Kcc:real; Vnr:integer) : real;
      VAR   Qv,Qc,Kp,Kpc,X,Fiv,Flv : real;
            Vr,Va,Sign : integer;
      BEGIN       {Obs! Kkorr global variabel}
        Va := Vapek[Vnr]; Fiv := VrefPost[Va].Fi; Flv := VrefPost[Va].Fl;
        If (Fiv=0) or (Kc=0) then begin Qv := 0; Kkorr := 0; end
        else begin  Vr := VrefPost[Va].Vref; Vr := VaPerfPek[Vr];
             If Kc>=0 then begin Kp := 1/g/sqr(Fiv*ValvePerf[Vr].Avp);
                                 Sign := +1; end
                      else begin Kp := 1/g/sqr(Fiv*ValvePerf[Vr].Avm);
                                 Sign := -1; end;
             X := 4*Kp*abs(Kc)/sqr(Kr); Kpc := Kp/sqr(Flv);
             Qv := Sign*Kr/Kp/2*(-1+Sqrt(1+X));
             Kkorr := 1/(2*Kp*abs(Qv)+Kr);
             X := 4*Kpc*abs(Kcc)/sqr(Krc);
             Qc := Sign*Krc/Kpc/2*(-1+Sqrt(1+X)); end;
        If abs(Qv)>abs(Qc) then begin Svalve := Qc;
                                      Kkorr := abs(Qc)/(2*Kcc); end
                           else Svalve := Qv;
      END;   { Svalve }

   FUNCTION Qboil(Kr,Kc,T1:real; Bo:integer) : real;
     VAR Alt,Sign : integer;
         Kp,Qx,X,Avmax : real;
     BEGIN
      With Boiler[Bo] do begin
      If (abs(Wmax)>Epsi) and (Kc>0) then Alt := 1;
      If (abs(Wmax)<=Epsi) or (Kc<=0) then Alt := 2;
      If (abs(Wmax)<Epsi) and (Avbp<Epsi) then Alt := 3;
      CASE Alt OF
      1: begin Avmax := Avboil+Avbp;
         If Qbt<Epsi then Tb := Tboil
                     else Tb := T1+Wmax/RaCsp/Qbt;
         If Wmax>Epsi then begin
            If Tb>Tboil then Tb := Tboil;
            If Tb<Tpipe then Tp := Tb else Tp := Tpipe; end
         else begin
            If Tb<Tboil then Tb := Tboil;
            If Tb>Tpipe then Tp := Tb else Tp := Tpipe; end;
         If abs(Tp-T1)>Epsi then Avres := (Tb-T1)/(Tp-T1)*Avboil
                            else Avres := 1E05;
         If Avres>Avmax then begin
            Avres := Avmax; Tp := T1+Avboil*(Tb-T1)/Avres; end;
         Kp := 1/g/sqr(Avres); X := 4*Kp*abs(Kc)/sqr(Kr);
         Qx := Kr/Kp/2*(-1+Sqrt(1+X));
         If abs(Tb-T1)>Epsi then Qbt := (Tp-T1)/(Tb-T1)*Qx else Qbt := Qx;
         end; {Alt 1}
      2: begin Qbt := 0; Avres := Avbp;
         If Avbp<Epsi then Qx := 0
            else begin Kp := 1/g/sqr(Avbp); X := 4*Kp*abs(Kc)/sqr(Kr);
                 If Kc>0 then begin Sign := +1; Tp := T1; Tb := T1; end
                    else begin Sign := -1; Tp := Tinit; Tb := Tinit; end;
                                          {Tp=T2,Tb=T2 s{tts i P/Lconns}
                 Qx := Sign*Kr/Kp/2*(-1+Sqrt(1+X)); end;
         end; {Alt 1}
      3: begin
         Qbt := 0; Qx := 0; Tb := Tinit; Tp := Tinit; Avres := 0;
         end; {Alt 3}
      END; {Case Alt}  end; {With}
      Qboil := Qx;
     END;  {Qboil}

   FUNCTION Qpump(Kr,Kc:real; Enr:integer ) : real;
      VAR   Nx,Qx,Qpu,Kcheck,Kp,X,Hpa,Hpb,Npu,Avb,D2x,Qo,Ho,Ap : real;
            Pr,Pu,i,k : integer;
            Qp,Hp : array[0..1] of real;
            FlowFlag : Boolean;
      BEGIN
        Pu := Pupek[Enr]; Pr := PrefPost[Pu].Pref; Pr := PuNomPek[Pr];
        D2x := PrefPost[Pu].DIx; Npu := PrefPost[Pu].Np;
        Avb := PrefPost[Pu].Avbv; FlowFlag := true;
        If abs(Npu)<1 then Npu := 1;
        With PumpNom[Pr] do begin Nx := Npu/Nnom;
        Qo := sqr(D2x)*Qnom; Ho := sqr(D2x)*Hnom;
        Kcheck := Kc+sqr(Nx)*sqr(D2x)*Hpqo; end; {With}
        If Avb<Epsi then FlowFlag := false;
        If (Kcheck<=0) and (PrefPost[Pu].YN='Y') then FlowFlag := false;
        If (abs(Kcheck)<(Ftol*Htol)) then  FlowFlag := false;
        If FlowFlag then begin
           Qx := Qpt[Pu]/Qo; Ap := arctan(Qx/Nx);
           If Nx<0 then Ap := Pii+arctan(Qx/Nx);
           If (Qx<0) and (Nx>0) then Ap := 2*Pii+Ap;
           i := trunc(Ap/dAp);
           If i=maxAp then i := maxAp-1;
           For k := 0 to 1 do begin
               Qp[k] := Nx*(sin((i+k)*dAp)/cos((i+k)*dAp))*Qo;
               Hp[k] := FH[Pr,i+k]*(sqr(Nx)+sqr(Qx))*Ho; end;
           Hpb := -(Hp[1]-Hp[0])/(Qp[1]-Qp[0]);
           Hpa := Hp[0]+Hpb*Qp[0];
           Kc := Kc+Hpa; Kr := Kr+Hpb;
           If (PrefPost[Pu].YN='Y') then begin
              Kp := 1/g/sqr(Avb); X := 4*Kp*Kc/sqr(Kr);
              If X<=0 then Qpu := 0              
                      else Qpu := Kr/Kp/2*(-1+Sqrt(1+X)); end
            else Qpu := Kc/Kr; end
        else Qpu := 0;
        Qpt[Pu] := Qpu; Qpump := Qpu;
      END;   { Qpump }

    PROCEDURE PrintDpl;
      CONST Mrad = 18;
      VAR  i,p,Nr,Znr : integer;
      BEGIN
       If (M mod (Mrad*Step) = 0) then begin write('M ':5);
          For i := 1 to maxCheck do begin With CheckPost[i] do begin
              Znr := Id div 100; Nr := Id mod 100;
              write('Pipe....':11,IdS2(Znr):2,NrS2(Nr):2);
              If BE='B' then write('....Beg':8)
                        else write('....End':8); end; end;
          writeln; write('- ':5);
          For i := 1 to 3 do write('Q m3/s  H mLc  T Cel':23);
          writeln; writeln; end;
       write(M:5);
       For i := 1 to maxCheck do begin With CheckPost[i] do begin
           If (BE='B') then p := 0 else p := 1;
           write(Qt[W,p]:9:4,Ht[W,p]:7:1,Tt[W,p]:7:1); end; end;
       writeln;
      END;   { PrintDpl }

   PROCEDURE Bounds;
      VAR  Qs,Qr : real;
           Io,i,p : integer;
      BEGIN
        For Io := 1 to Iomax do begin With IoPost[Io] do begin
        p := Pi;
        If ((BE='I') or (BE='T')) then i := 0 else i := 1;
        CASE BE OF
    'T','I': begin CASE QP OF                          {Inlets}
                 'Q': begin Qtdt[p,i] := Value;
                            Htdt[p,i] := (Qtdt[p,i]-Cm[p])*Cr[p]; end;
                 'P': begin Htdt[p,i] := Hbound;
                            Qtdt[p,i] := Cm[p]+Htdt[p,i]/Cr[p]; end;
                 END;  {Case QP}
                 Qr := Qtdt[p,i];
                 Cp[p] := Qr+Htdt[p,i]/Cr[p]-RdT[p]*abs(Qr)*Qr;
                 If Qr>0 then begin Tt[p,i] := Temp;
                                    Tt[p,1] := Tt[p,i]-dTt[p]; end
                    else Tt[p,i] := Tt[p,1]-dTt[p]; end;
    'F','O': begin CASE QP OF                          {Outlets}
                 'Q': begin Qtdt[p,i] := Value;
                            Htdt[p,i] := (Cp[p]-Qtdt[p,i])*Cr[p]; end;
                 'P': begin Htdt[p,i] := Hbound;
                            Qtdt[p,i] := Cp[p]-Htdt[p,i]/Cr[p]; end;
                 END;  {Case QP}
                 Qs := Qtdt[p,i];
                 Cm[p] := Qs-Htdt[p,i]/Cr[p]-Rdt[p]*abs(Qs)*Qs;
                 If Qs>0 then Tt[p,i] := Tt[p,0]-dTt[p]
                    else begin Tt[p,i] := Temp;
                               Tt[p,0] := Tt[p,i]-dTt[p]; end; end;
        END; {case BE}
        end; {With} end; {For}
      END;   {Bounds}

   PROCEDURE Connections;
      VAR   Cn,p1,p2,i1,i0 : integer;
            Kr,Kc,Krc,Kcc,Qs,Qr : real;

       PROCEDURE Internals (p1,i1,p2,i0 : integer );
         BEGIN
          With CnPost[Cn] do begin
           CASE Ecod OF
{Q}        1 : begin Htdt[p1,i1] := (Cp[p1]-Value)*Cr[p1];
                     Htdt[p2,i0] := (Value-Cm[p2])*Cr[p2];
                     Qtdt[p1,i1] := Value; Qtdt[p2,i0] := Value; end;
{GP}       2 : begin Qr := Cm[p2]+Hconn/Cr[p2];
                     Htdt[p2,i0] := Hconn;
                     Htdt[p1,i1] := (Cp[p1]-Qr)*Cr[p1];
                     If Qr<0 then begin Qr := Cp[p1]-Hconn/Cr[p1];
                        If Qr>0 then writeln('Error!! Pcn-GP  Error!!');
                        Htdt[p1,i1] := Hconn;
                        Htdt[p2,i0] := (Qr-Cm[p2])*Cr[p2]; end;
                     Qtdt[p1,i1] := Qr; Qtdt[p2,i0] := Qr; end;
 3,5,6,13,14 : begin Htdt[p1,i1] := (Cp[p1]-Cm[p2])/(1/Cr[p1]+1/Cr[p2]);
{T,DT,N,S,E}         Htdt[p2,i0] := Htdt[p1,i1];
                     Qtdt[p1,i1] := Cp[p1]-Htdt[p1,i1]/Cr[p1];
                     Qtdt[p2,i0] := Qtdt[p1,i1]; end;
{DH}       4 : begin Kr := Cr[p1]+Cr[p2];
                     Kc := Cr[p1]*Cp[p1]+Cr[p2]*Cm[p2]+Value;
                     Qtdt[p1,i1] := Kc/Kr;
                     Qtdt[p2,i0] := Qtdt[p1,i1];
                     Htdt[p1,i1] := (Cp[p1]-Qtdt[p1,i1])*Cr[p1];
                     Htdt[p2,i0] := (Qtdt[p2,i0]-Cm[p2])*Cr[p2]; end;
{CV}       7 : begin Kr := Cr[p1]+Cr[p2];
                     Kc := Cr[p1]*Cp[p1]+Cr[p2]*Cm[p2];
                     Qtdt[p1,i1] := Qcheck(Kr,Kc,Value);
                     Qtdt[p2,i0] := Qtdt[p1,i1];
                     Htdt[p1,i1] := (Cp[p1]-Qtdt[p1,i1])*Cr[p1];
                     Htdt[p2,i0] := (Qtdt[p2,i0]-Cm[p2])*Cr[p2]; end;
{AV}       8 : begin Kr := Cr[p1]+Cr[p2];
                     Kc := -Cp[p1]*Cr[p1]-Cm[p2]*Cr[p2];
                     Qtdt[p1,i1] := Qav(Kr,Kc,Value);
                     Htdt[p1,i1] := (Cp[p1]-Qtdt[p1,i1])*Cr[p1];
                     Qtdt[p2,i0] := Qtdt[p1,i1];
                     Htdt[p2,i0] := (Qtdt[p2,i0]-Cm[p2])*Cr[p2]; end;
{RV}       9 : begin Kr := Cr[p1]+Cr[p2];
                     Kc := Cr[p1]*Cp[p1]+Cr[p2]*Cm[p2];
                     Qtdt[p1,i1] := Qrv(Kr,Kc,Enr);
                     Qtdt[p2,i0] := Qtdt[p1,i1];
                     Htdt[p1,i1] := (Cp[p1]-Qtdt[p1,i1])*Cr[p1];
                     Htdt[p2,i0] := (Qtdt[p2,i0]-Cm[p2])*Cr[p2]; end;
{VA}      10 : begin Kr := Cr[p1]+Cr[p2]; Tvt[Vapek[Enr]] := Tt[p1,i1];
                     Kc := Cr[p1]*Cp[p1]+Cr[p2]*Cm[p2];
                     If Kc>0 then begin Krc := Cr[p1];
                             Kcc := Krc*Cp[p1]-VrefPost[Vapek[Enr]].Hch; end
                        else begin Krc := Cr[p2];
                             Kcc := Krc*Cm[p2]+VrefPost[Vapek[Enr]].Hch; end;
                     Qtdt[p1,i1] := Svalve(Kr,Kc,Krc,Kcc,Enr);
                     Qtdt[p2,i0] := Qtdt[p1,i1];
                     Htdt[p1,i1] := (Cp[p1]-Qtdt[p1,i1])*Cr[p1];
                     Htdt[p2,i0] := (Qtdt[p2,i0]-Cm[p2])*Cr[p2]; end;
{PU}      11 : begin Kr := Cr[p1]+Cr[p2];
                     Kc := Cr[p1]*Cp[p1]+Cr[p2]*Cm[p2];
                     Qtdt[p1,i1] := Qpump(Kr,Kc,Enr);
                     Qtdt[p2,i0] := Qtdt[p1,i1];
                     Htdt[p1,i1] := Cr[p1]*(Cp[p1]-Qtdt[p1,i1]);
                     Htdt[p2,i0] := Cr[p2]*(Qtdt[p2,i0]-Cm[p2]); end;
{BO}      12 : begin Kr := Cr[p1]+Cr[p2];
                     Kc := Cr[p1]*Cp[p1]+Cr[p2]*Cm[p2];
                     Qtdt[p1,i1] := Qboil(Kr,Kc,Tt[p1,i1],Enr);
                     Qtdt[p2,i0] := Qtdt[p1,i1];
                     Htdt[p1,i1] := Cr[p1]*(Cp[p1]-Qtdt[p1,i1]);
                     Htdt[p2,i0] := Cr[p2]*(Qtdt[p2,i0]-Cm[p2]); end;
           END;  { Case Ecod }  end; {With}
         END;  { Internals }

      BEGIN  { Connections }
         For Cn := 1 to Cnmax do begin  With CnPost[Cn] do begin
             p1 := Pto; i1 := 1; p2 := Pfr; i0 := 0;
             Internals(p1,i1,p2,i0);
             Qr := Qtdt[p2,i0]; Qs := Qtdt[p1,i1];
             Cp[p2] := Qr+Htdt[p2,i0]/Cr[p2]-RdT[p2]*abs(Qr)*Qr;
             Cm[p1] := Qs-Htdt[p1,i1]/Cr[p1]-Rdt[p1]*abs(Qs)*Qs;
             If Qr>0 then begin Tt[p2,i0] := Tt[p1,i1];
                If Ecod=3 then Tt[p2,i0] := Value;
                If Ecod=5 then Tt[p2,i0] := Tt[p1,i1]+Value;
                If Ecod=12 then Tt[p2,i0] := Boiler[Enr].Tp;
                Tt[p1,i0] := Tt[p1,i1]+dTt[p1];
                Tt[p2,i1] := Tt[p2,i0]-dTt[p2]; end;
             If Qr<0 then begin Tt[p1,i1] := Tt[p2,i0];
                If Ecod=3 then Tt[p1,i1] := Value;
                If Ecod=5 then Tt[p1,i1] := Tt[p2,i0]-Value;
                If Ecod=12 then begin Boiler[Enr].Tp := Tt[p2,i0];
                                      Boiler[Enr].Tb := Tt[p2,i0]; end;
                Tt[p1,i0] := Tt[p1,i1]-dTt[p1];
                Tt[p2,i1] := Tt[p2,i0]+dTt[p2]; end;
         end; {With} end; {For Cn}
      END;   { Connections }

   PROCEDURE Junctions;
      VAR  Qsum,Wsum : real;
           Jn,i,i1,i2 : integer;
           Q : array [1..4] of real;

     PROCEDURE NoValveJn (Jn:integer) ;
       VAR i,p1,p2,i1,i2 : integer;
           Cpm,CrInv : real;
       BEGIN
        Cpm := 0; CrInv := 0; i1 := 1; i2 := 0;
        With JnPost[Jn] do begin
        For i := 1 to 4 do begin
            If p[i]>0 then begin p1 := p[i];
               Cpm := Cpm+Cp[p1]; CrInv := CrInv+1/Cr[p1]; end;
            If p[i]<0 then begin p2 := -p[i];
               Cpm := Cpm-Cm[p2]; CrInv := CrInv+1/Cr[p2]; end; end;
        Hjn := Cpm/CrInv;
        For i := 1 to 4 do begin
            If p[i]>0 then begin p1 := p[i]; Htdt[p1,i1] := Hjn;
               Q[i] := Cp[p1]-Hjn/Cr[p1]; Qtdt[p1,i1] := Q[i];
               Cm[p1] := Q[i]-Hjn/Cr[p1]-Rdt[p1]*abs(Q[i])*Q[i]; end;
            If p[i]<0 then begin p2 := -p[i]; Htdt[p2,i2] := Hjn;
               Q[i] := Cm[p2]+Hjn/Cr[p2]; Qtdt[p2,i2] := Q[i];
               Cp[p2] := Q[i]+Hjn/Cr[p2]-RdT[p2]*abs(Q[i])*Q[i]; end;
        end; end;
       END; {NoValveJn}

    PROCEDURE ValveJn(Jn:integer);
      VAR  i,i1,i2,Iter,p1,p2 : integer;
           dH0,Kr,Kc,dQ,dH,dK,Krc,Kcc : real;
      BEGIN  {OBS! Kkorr global variabel}
        i1 := 1; i2 := 0; Iter := 0; dH0 := 0;
        With JnPost[Jn] do begin
        REPEAT  dQ := 0; dK := 0; Iter := Iter+1;
         If Iter>maxIter then begin writeln;
            write('Sorry! Iteration failed!  Junction':40);
            writeln(IdS2(Id div 100):4,NrS2(Id mod 100):3); Gerror; end;
         For i := 1 to 4 do begin  Q[i] := 0;
             If p[i]>0 then begin p1 := p[i];
                Kr := Cr[p1]; Kc := Kr*Cp[p1]-Hjn;
                If Vnr[i]=0 then begin Q[i] := Kc/Kr; Kkorr := 1/Kr; end
                else begin Krc := Kr;
                     If Kc>=0 then Kcc := Krc*Cp[p1]-VrefPost[Vapek[Vnr[i]]].Hch
                              else Kcc := Hjn-VrefPost[Vapek[Vnr[i]]].Hch;
                     If Kc>=0 then Q[i] := Svalve(Kr,Kc,Krc,Kcc,Vnr[i])
                              else Q[i] := Qjunc(Kr,Kc,Kcc,Vnr[i]); end;
                dK := dK+Kkorr; dQ := dQ+Q[i]; end;
             If p[i]<0 then begin p2 := -p[i];
                Kr := Cr[p2]; Kc := Hjn+Kr*Cm[p2];
                If Vnr[i]=0 then begin Q[i] := Kc/Kr; Kkorr := 1/Kr; end
                else begin Krc := Kr;
                     If Kc>=0 then Kcc := Hjn-VrefPost[Vapek[Vnr[i]]].Hch
                              else Kcc := Krc*Cm[p2]+VrefPost[Vapek[Vnr[i]]].Hch;
                     If Kc>=0 then Q[i] := Qjunc(Kr,Kc,Kcc,Vnr[i])
                              else Q[i] := Svalve(Kr,Kc,Krc,Kcc,Vnr[i]); end;
                dK:= dK+Kkorr; dQ := dQ-Q[i]; end; end;
         dH := dQ/dK;
         If (dH0*dH<0) then dH := dH/3;
         Hjn := Hjn+dH; dH0 := dH;
        UNTIL ( (abs(dH)<dHtol) and (abs(dQ)<dQtol) );
        For i := 1 to 4 do begin
            If p[i]>0 then begin p1 := p[i]; Qtdt[p1,i1] := Q[i];
               Htdt[p1,i1] := Cr[p1]*(Cp[p1]-Q[i]);
               Cm[p1] := Q[i]-Htdt[p1,i1]/Cr[p1]-Rdt[p1]*abs(Q[i])*Q[i]; end;
            If p[i]<0 then begin p2 := -p[i]; Qtdt[p2,i2] := Q[i];
               Htdt[p2,i2] := Cr[p2]*(Q[i]-Cm[p2]);
               Cp[p2] := Q[i]+Htdt[p2,i2]/Cr[p2]-RdT[p2]*abs(Q[i])*Q[i]; end;
        end; {For i} end; {With}
      END; {ValveJn}

    BEGIN   { Junctions }
     i1 := 1; i2 := 0;
     For Jn := 1 to Jnmax do begin With JnPost[Jn] do begin
       If Valvesum=0 then NoValveJn(Jn)
                     else ValveJn(Jn);
        Qsum := 0; Wsum := 0;
        For i := 1 to 4 do begin
            If ((p[i]>0) and (Q[i]>0)) then begin
               Qsum := Qsum+Q[i]; Wsum := Wsum+Q[i]*Tt[p[i],i1]; end;
            If ((p[i]<0) and (Q[i]<0)) then begin
               Qsum := Qsum-Q[i]; Wsum := Wsum-Q[i]*Tt[-p[i],i2]; end; end;
        If Qsum>0 then Tjn := Wsum/Qsum else Tjn := Tinit;
        For i := 1 to 4 do begin
            If ((p[i]>0) and (Q[i]<0)) then begin
               Tt[p[i],i1] := Tjn; Tt[p[i],i2] := Tjn-dTt[p[i]]; end;
            If ((p[i]<0) and (Q[i]>0)) then begin
               Tt[-p[i],i2] := Tjn; Tt[-p[i],i1] := Tjn-dTt[-p[i]]; end; end;
        For i := 1 to 4 do begin
            If (p[i]>0) and (Vnr[i]>0) then Tvt[Vapek[Vnr[i]]] := Tt[p[i],i1];
            If (p[i]<0) and (Vnr[i]>0) then Tvt[Vapek[Vnr[i]]] := Tt[-p[i],i2]; end;
        end; {With} end; {For Jn}
      END;    { Junctions }

PROCEDURE Crossconns;
  VAR CrF,CrR,CpmF,CpmR,Qr,Qs,Kr,Kc,Qmax,Qsum,Wsum,dTdum,Tcs : real;
      Cs,i,i1,i2,p1,p2 : integer;

  PROCEDURE CrossValve(Cs : integer);
    VAR Krc,Kcc : real;
        i : integer;
    BEGIN
      WITH CsPost[Cs] do begin
        For i := 1 to 4 do begin
            If p[i]>0 then begin p1 := p[i];
               CpmF := CpmF+Cp[p1]; CrF := CrF+1/Cr[p1]; end;
            If p[i]<0 then begin p2 := -p[i];
               CpmF := CpmF-Cm[p2]; CrF := CrF+1/Cr[p2]; end; end;
        For i := 5 to 8 do begin
            If p[i]>0 then begin p1 := p[i]; CpmR := CpmR+Cp[p1];
                                 CrR := CrR+1/Cr[p1]; end;
            If p[i]<0 then begin p2 := -p[i]; CpmR := CpmR-Cm[p2];
                                 CrR := CrR+1/Cr[p2]; end; end;
        Kr := 1/CrF+1/CrR; Kc := -CpmR/CrR+CpmF/CrF;
        If Kc>0 then begin Krc := 1/CrF;
                Kcc := Krc*CpmF-VrefPost[Vapek[Vnr]].Hch; end
           else begin Krc := 1/CrR;
                Kcc := - Krc*CpmR+VrefPost[Vapek[Vnr]].Hch; end;
        Qcs := Svalve(Kr,Kc,Krc,Kcc,Vnr);
        HF := (CpmF-Qcs)/CrF; HR := (CpmR+Qcs)/CrR;
        For i := 1 to 4 do begin
            If p[i]>0 then begin p1 := p[i]; Htdt[p1,i1] := HF;
                      Qtdt[p1,i1] := Cp[p1]-HF/Cr[p1]; Qs := Qtdt[p1,i1];
                      Cm[p1] := Qs-HF/Cr[p1]-Rdt[p1]*abs(Qs)*Qs; end;
            If p[i]<0 then begin p2 := -p[i]; Htdt[p2,i2] := HF;
                      Qtdt[p2,i2] := Cm[p2]+HF/Cr[p2]; Qr := Qtdt[p2,i2];
                      Cp[p2] := Qr+HF/Cr[p2]-RdT[p2]*abs(Qr)*Qr; end; end;
        For i := 5 to 8 do begin
            If p[i]>0 then begin p1 := p[i]; Htdt[p1,i1] := HR;
                      Qtdt[p1,i1] := Cp[p1]-HR/Cr[p1]; Qs := Qtdt[p1,i1];
                      Cm[p1] := Qs-HR/Cr[p1]-Rdt[p1]*abs(Qs)*Qs; end;
            If p[i]<0 then begin p2 := -p[i]; Htdt[p2,i2] := HR;
                      Qtdt[p2,i2] := Cm[p2]+HR/Cr[p2]; Qr := Qtdt[p2,i2];
                      Cp[p2] := Qr+HR/Cr[p2]-RdT[p2]*abs(Qr)*Qr; end; end;
        If Qcs>0 then begin Qsum := 0; Wsum := 0;
           For i := 1 to 4 do begin
               If p[i]>0 then begin p1 := p[i]; Qs := Qtdt[p1,i1];
                  If Qs>0 then begin Qsum := Qsum+Qs;
                                     Wsum := Wsum+Qs*Tt[p1,i1]; end; end;
               If p[i]<0 then begin p2 := -p[i]; Qr := Qtdt[p2,i2];
                  If Qr<0 then begin Qsum := Qsum-Qr;
                                     Wsum := Wsum-Qr*Tt[p2,i2]; end; end; end;
           If Qsum>0 then Tf := Wsum/Qsum else Tf := Tf;
           Tvt[Vapek[Vnr]] := Tf;
           For i := 1 to 4 do begin
               If p[i]>0 then begin p1 := p[i]; Qs := Qtdt[p1,i1];
                  If Qs<0 then begin Tt[p1,i1] := Tf;
                                     Tt[p1,i2] := Tf-dTt[p1]; end; end;
               If p[i]<0 then begin p2 := -p[i]; Qr := Qtdt[p2,i2];
                  If Qr>0 then begin Tt[p2,i2] := Tf;
                                     Tt[p2,i1] := Tf-dTt[p2]; end; end; end;
           Qsum := Qcs; Wsum := Qcs*Tf;
           For i := 5 to 8 do begin
               If p[i]>0 then begin p1 := p[i]; Qs := Qtdt[p1,i1];
                  If Qs>0 then begin Qsum := Qsum+Qs;
                                     Wsum := Wsum+Qs*Tt[p1,i1]; end; end;
               If p[i]<0 then begin p2 := -p[i]; Qr := Qtdt[p2,i2];
                  If Qr<0 then begin Qsum := Qsum-Qr;
                                     Wsum := Wsum-Qr*Tt[p2,i2]; end; end; end;
           If Qsum>0 then Tr := Wsum/Qsum else Tr := Tr;
           For i := 5 to 8 do begin
               If p[i]>0 then begin p1 := p[i]; Qs := Qtdt[p1,i1];
                  If Qs<0 then begin Tt[p1,i1] := Tr;
                                     Tt[p1,i2] := Tr-dTt[p1]; end; end;
               If p[i]<0 then begin p2 := -p[i]; Qr := Qtdt[p2,i2];
                  If Qr>0 then begin Tt[p2,i2] := Tr;
                                     Tt[p2,i1] := Tr-dTt[p2]; end; end; end; end
        else begin  Qsum := 0; Wsum := 0;
           For i := 5 to 8 do begin
               If p[i]>0 then begin p1 := p[i]; Qs := Qtdt[p1,i1];
                  If Qs>0 then begin Qsum := Qsum+Qs;
                                     Wsum := Wsum+Qs*Tt[p1,i1]; end; end;
               If p[i]<0 then begin p2 := -p[i]; Qr := Qtdt[p2,i2];
                  If Qr<0 then begin Qsum := Qsum-Qr;
                                     Wsum := Wsum-Qr*Tt[p2,i2]; end; end; end;
           If Qsum>0 then Tr := Wsum/Qsum else Tr := Tr;
           Tvt[Vapek[Vnr]] := Tr;
           For i := 5 to 8 do begin
               If p[i]>0 then begin p1 := p[i]; Qs := Qtdt[p1,i1];
                  If Qs<0 then begin Tt[p1,i1] := Tr;
                                     Tt[p1,i2] := Tr-dTt[p1]; end; end;
               If p[i]<0 then begin p2 := -p[i]; Qr := Qtdt[p2,i2];
                  If Qr>0 then begin Tt[p2,i2] := Tr;
                                     Tt[p2,i1] := Tr-dTt[p2]; end; end; end;
           Qsum := -Qcs; Wsum := -Qcs*Tr;
           For i := 1 to 4 do begin
               If p[i]>0 then begin p1 := p[i]; Qs := Qtdt[p1,i1];
                  If Qs>0 then begin Qsum := Qsum+Qs;
                                     Wsum := Wsum+Qs*Tt[p1,i1]; end; end;
               If p[i]<0 then begin p2 := -p[i]; Qr := Qtdt[p2,i2];
                  If Qr<0 then begin Qsum := Qsum-Qr;
                                     Wsum := Wsum-Qr*Tt[p2,i2]; end; end; end;
           If Qsum>0 then Tf := Wsum/Qsum else Tf := Tf;
           For i := 1 to 4 do begin
               If p[i]>0 then begin p1 := p[i]; Qs := Qtdt[p1,i1];
                  If Qs<0 then begin Tt[p1,i1] := Tf;
                                     Tt[p1,i2] := Tf-dTt[p1]; end; end;
               If p[i]<0 then begin p2 := -p[i]; Qr := Qtdt[p2,i2];
                  If Qr>0 then begin Tt[p2,i2] := Tf;
                                     Tt[p2,i1] := Tf-dTt[p2]; end; end; end;
          end; end; {With}
    END; {CrossValve}

  BEGIN  {CrossConns}
    i1 := 1; i2 := 0; dTdum := 0.01;
    For Cs := 1 to Csmax do begin
      CrF := 0; CrR := 0; CpmF := 0; CpmR := 0; Qsum := 0; Wsum := 0;
If CsPost[Cs].Vnr>0 then CrossValve(Cs) else begin
      WITH CsPost[Cs] do begin
        For i := 1 to 4 do begin
            If p[i]>0 then begin p1 := p[i];
               CpmF := CpmF+Cp[p1]; CrF := CrF+1/Cr[p1];
               If Qt[p1,i1]>0 then begin Qsum := Qsum+Qt[p1,i1];
                  Wsum := Wsum+Qt[p1,i1]*Tt[p1,i1]; end; end;
            If p[i]<0 then begin p2 := -p[i];
               CpmF := CpmF-Cm[p2]; CrF := CrF+1/Cr[p2];
               If Qt[p2,i2]<0 then begin Qsum := Qsum-Qt[p2,i2];
                  Wsum := Wsum-Qt[p2,i2]*Tt[p2,i2];  end; end; end;
        If Qsum>Epsi then Tf := Wsum/Qsum else Tf := Tr+dTdum;
         CASE Cat OF
         'A': Tr := Aret+dTr;
         'B': Tr := Bret+dTr;
         'C': Tr := Cret+dTr;
         'D': Tr := Dret+dTr;
         'E': Tr := Eret+dTr;
         'F': Tr := Fret+dTr;
         END; {Case}
        If abs(Tf-Tr)>Epsi then Ql := Pload/RaCsp/abs(Tf-Tr)
                           else Ql := Pload/RaCsp/dTdum;
        For i := 5 to 8 do begin
            If p[i]>0 then begin p1 := p[i]; CpmR := CpmR+Cp[p1];
                                 CrR := CrR+1/Cr[p1]; end;
            If p[i]<0 then begin p2 := -p[i]; CpmR := CpmR-Cm[p2];
                                 CrR := CrR+1/Cr[p2]; end; end;
      Kr := 1/CrF+1/CrR; Kc := CpmR/CrR-CpmF/CrF;
      Qmax := Qstr(Kr,Kc,Avmax,Avmax);
      If Qmax<Ql then Qcs := Qmax else Qcs := Ql;
      HF := (CpmF-Qcs)/CrF; HR := (CpmR+Qcs)/CrR;
      For i := 1 to 4 do begin
          If p[i]>0 then begin p1 := p[i]; Htdt[p1,i1] := HF;
                    Qtdt[p1,i1] := Cp[p1]-HF/Cr[p1]; Qs := Qtdt[p1,i1];
                    Cm[p1] := Qs-HF/Cr[p1]-Rdt[p1]*abs(Qs)*Qs;
                    If Qs<0 then begin Tt[p1,i1] := Tf;
                                       Tt[p1,i2] := Tf-dTt[p1]; end; end;
          If p[i]<0 then begin p2 := -p[i]; Htdt[p2,i2] := HF;
                    Qtdt[p2,i2] := Cm[p2]+HF/Cr[p2]; Qr := Qtdt[p2,i2];
                    Cp[p2] := Qr+HF/Cr[p2]-RdT[p2]*abs(Qr)*Qr;
                    If Qr>0 then begin Tt[p2,i2] := Tf;
                                       Tt[p2,i1] := Tf-dTt[p2]; end; end;
          end;
      Qsum := Qcs; Wsum := Qcs*Tr;
      For i := 5 to 8 do begin
          If p[i]>0 then begin p1 := p[i]; Htdt[p1,i1] := HR;
                    Qtdt[p1,i1] := Cp[p1]-HR/Cr[p1]; Qs := Qtdt[p1,i1];
                    If Qs>0 then begin Qsum := Qsum+Qs;
                            Wsum := Wsum+Qs*Tt[p1,i1]; end;
                    Cm[p1] := Qs-HR/Cr[p1]-Rdt[p1]*abs(Qs)*Qs; end;
          If p[i]<0 then begin p2 := -p[i]; Htdt[p2,i2] := HR;
                    Qtdt[p2,i2] := Cm[p2]+HR/Cr[p2]; Qr := Qtdt[p2,i2];
                    If Qr<0 then begin Qsum := Qsum-Qr;
                            Wsum := Wsum-Qr*Tt[p2,i2]; end;
                    Cp[p2] := Qr+HR/Cr[p2]-RdT[p2]*abs(Qr)*Qr; end; end;
      If Qsum>Epsi then Tcs := Wsum/Qsum else Tcs := Tr;
      If Qcs<Epsi then Tr := Tcs;
      For i := 5 to 8 do begin
          If p[i]>0 then begin p1 := p[i]; Qs := Qtdt[p1,i1];
             If Qs<0 then begin Tt[p1,i1] := Tcs;
                                Tt[p1,i2] := Tcs-dTt[p1]; end; end;
          If p[i]<0 then begin p2 := -p[i]; Qr := Qtdt[p2,i2];
             If Qr>0 then begin Tt[p2,i2] := Tcs;
                                Tt[p2,i1] := Tcs-dTt[p2]; end; end;
          end;
      end; {With} end; {else} end; {For Cs}
  END;   {Crossconns}

PROCEDURE HeatEx;
 CONST i1 = 1; i0 = 0;
 VAR Ex,Ep,Sign : integer;
     Kr,Kc,Qp,Qs,RaCspp,RaCsps,x,B,Efm,Efp,Efs,Axp,Axs,kA : real;
 BEGIN
  For Ex := 1 to Exmax do begin With Expost[Ex] do begin
      Kr := Cr[pTo]+Cr[pFr];
      Kc := -Cp[pTo]*Cr[pTo]-Cm[pFr]*Cr[pFr];
      Qp := Qav(Kr,Kc,pAv);
      Htdt[pTo,i1] := (Cp[pTo]-Qp)*Cr[pTo];
      Qtdt[pTo,i1] := Qp; Qtdt[pFr,i0] := Qp;
      Htdt[pFr,i0] := (Qp-Cm[pFr])*Cr[pFr];
      Kr := Cr[sTo]+Cr[sFr];
      Kc := -Cp[sTo]*Cr[sTo]-Cm[sFr]*Cr[sFr];
      Qs := Qav(Kr,Kc,sAv);
      Htdt[sTo,i1] := (Cp[sTo]-Qs)*Cr[sTo];
      Qtdt[sTo,i1] := Qs; Qtdt[sFr,i0] := Qs;
      Htdt[sFr,i0] := (Qs-Cm[sFr])*Cr[sFr];
      Cp[pFr] := Qp+Htdt[pFr,i0]/Cr[pFr]-RdT[pFr]*abs(Qp)*Qp;
      Cm[pTo] := Qp-Htdt[pTo,i1]/Cr[pTo]-Rdt[pTo]*abs(Qp)*Qp;
      Cp[sFr] := Qs+Htdt[sFr,i0]/Cr[sFr]-RdT[sFr]*abs(Qs)*Qs;
      Cm[sTo] := Qs-Htdt[sTo,i1]/Cr[sTo]-Rdt[sTo]*abs(Qs)*Qs;
      If Qp<0 then Sign := -1 else Sign := +1;
      If abs(Qp)<Epsi then Qp := Sign*Epsi;
      If Qs<0 then Sign := -1 else Sign := +1;
      If abs(Qs)<Epsi then Qs := Sign*Epsi;
      Ep := HexPerfpek[Href];
      Axp := 1+HexPerf[Ep].AdTm*((Tt[pTo,i1]+Tt[pFr,i0])/2-Tpm);
      Axp := 1/Axp/exp(HexPerf[Ep].Vexp*ln(abs(Qp/Qpo)));
      Axs := 1+HexPerf[Ep].AdTm*((Tt[sTo,i1]+Tt[sFr,i0])/2-Tsm);
      Axs := 1/Axs/exp(HexPerf[Ep].Vexp*ln(abs(Qs/Qso)));
      kA := (Axp+HexPerf[Ep].Aps*Axs)/(HexPerf[Ep].Aps+1);
      kA := kAo/(HexPerf[Ep].TL+(1-HexPerf[Ep].TL)*kA);
      If kA<(0.1*kAo) then kA := 0.1*kAo;
      TempInit((Tt[pTo,i1]+Tt[pFr,i0])/2); RaCspp := Ra*Csp;
      TempInit((Tt[sTo,i1]+Tt[sFr,i0])/2); RaCsps := Ra*Csp;
      TempInit(Tinit);
      x := RaCsps*Qs/RaCspp/Qp;
      If x>0 then begin B := (1-x)/x*kA/RaCspp/abs(Qp);
         If B>60 then B := 60;
         If B<-60 then B := -60;
         If abs(x-1)<Epsi then Efm := 1/(1+RaCspp*abs(Qp)/kA)
                          else Efm := (1+x)/2*(1-exp(B))/(x-exp(B));
         Efp := 2*x/(1+x)*Efm; Efs := 2/(1+x)*Efm;
         If Qp>0 then begin Tt[pFr,i0] := Tt[pTo,i1]-Efp*(Tt[pTo,i1]-Tt[sTo,i1]);
                      Tt[sFr,i0] := Tt[sTo,i1]+Efs*(Tt[pTo,i1]-Tt[sTo,i1]);
                      Tt[pFr,i1] := Tt[pFr,i0]-dTt[pFr];
                      Tt[sFr,i1] := Tt[sFr,i0]-dTt[sFr]; end
                 else begin Tt[pTo,i1] := Tt[pFr,i0]-Efp*(Tt[pFr,i0]-Tt[sFr,i0]);
                      Tt[sTo,i1] := Tt[sFr,i0]+Efs*(Tt[pFr,i0]-Tt[sFr,i0]);
                      Tt[pTo,i0] := Tt[pTo,i1]-dTt[pTo];
                      Tt[sTo,i0] := Tt[sTo,i1]-dTt[sTo]; end;
      end; {x>0}
      If x<0 then begin x := abs(x);
         B := (1+x)/x*kA/RaCspp/abs(Qp);
         If B>60 then B := 60;
         If B<-60 then B := -60;
         Efm := 1/2*(1-exp(-B));
         Efp := 2*x/(1+x)*Efm; Efs := 2/(1+x)*Efm;
         If Qp>0 then begin Tt[pFr,i0] := Tt[pTo,i1]-Efp*(Tt[pTo,i1]-Tt[sFr,i0]);
                      Tt[sTo,i1] := Tt[sFr,i0]+Efs*(Tt[pTo,i1]-Tt[sFr,i0]);
                      Tt[pFr,i1] := Tt[pFr,i0]-dTt[pFr];
                      Tt[sTo,i1] := Tt[sTo,i0]-dTt[sTo]; end
                 else begin Tt[pTo,i1] := Tt[pFr,i0]-Efp*(Tt[pFr,i0]-Tt[sTo,i1]);
                      Tt[sFr,i0] := Tt[sTo,i1]+Efs*(Tt[pFr,i0]-Tt[sTo,i1]);
                      Tt[pTo,i0] := Tt[pTo,i1]-dTt[pTo];
                      Tt[sTo,i1] := Tt[sTo,i1]-dTt[sTo]; end;
      end; {x<0}
  end; {with} end; {For Ex}
 END; {HeatEx}

PROCEDURE Locals;
  VAR s,b,Pi,Iter,i,l : integer;
      Qe,dQ,dH  : real;
      dQS,dHS : array[1..maxLi] of integer;
      Cpl0,Cml0 : array[1..maxLi] of real;
      Qbor : array[1..maxBor] of real;

  PROCEDURE Lbounds(s:integer);
    VAR Qe,He : real;
        Lio : integer;

    BEGIN  {Lbounds}
      For Lio := 1 to Liomax[s] do begin
          With LioPost[s,Lio] do begin
          CASE BE OF
      'T','I': begin CASE QP OF
                   'Q': begin Cpl[s,Li] := 2*Value-Cml[s,Li]; end;
                   'P': begin He := Hbound;
                              Cpl[s,Li] := Cml[s,Li]+2*He/Crl; end;
                   END; {Case}
                   Qe := (Cpl[s,Li]+Cml[s,Li])/2;
                   If Qe>0 then Tli[s,Li] := Temp; end;
      'F','O': begin CASE QP OF
                   'Q': begin Cml[s,Li] := 2*Value-Cpl[s,Li]; end;
                   'P': begin He := Hbound;
                              Cml[s,Li] := Cpl[s,Li]-2*He/Crl; end;
                   END; {Case}
                   Qe := (Cpl[s,Li]+Cml[s,Li])/2;
                   If Qe<0 then Tli[s,Li] := Temp; end;
          END {case BE}
      end; {With} end; {For}
    END;   {Lbounds}

  PROCEDURE Lconns(s:integer);
    VAR Qe,Kr,Kc,Krc,Kcc : real;
        c : integer;

    BEGIN  { Lconns }
      For c := 1 to Lcnmax[s] do begin
      With LcnPost[s,c] do begin
      CASE Ecod OF
{Q}   1 : begin Cml[s,Lto] := 2*Value-Cpl[s,Lto];
                Cpl[s,Lfr] := 2*Value-Cml[s,Lfr]; end;
{GP}  2 : begin Qe := Cml[s,Lfr]+Hconn/Crl;
                If Qe<0 then begin Qe := Cpl[s,Lto]-Hconn/Crl;
                   If Qe>0 then begin
                      writeln('Error!!  Lcn GP-Error Error!!'); end;
                end;
                Cpl[s,Lfr] := 2*Qe-Cml[s,Lfr];
{T,DT,NO,ST,GC}    Cml[s,Lto] := 2*Qe-Cpl[s,Lto]; end;
3,5,6,13,14 : begin Cml[s,Lto] := Cml[s,Lfr]; Cpl[s,Lfr] := Cpl[s,Lto]; end;
{DH}  4 : begin Kr := 2*Crl; Kc := Crl*(Cpl[s,Lto]+Cml[s,Lfr])+Value;
                Qe := Kc/Kr; Cml[s,Lto] := 2*Qe-Cpl[s,Lto];
                Cpl[s,Lfr] := 2*Qe-Cml[s,Lfr]; end;
{CV}  7 : begin Kr := 2*Crl; Kc := Crl*(Cpl[s,Lto]+Cml[s,Lfr]);
                Qe := Qcheck(Kr,Kc,Value); Cml[s,Lto] := 2*Qe-Cpl[s,Lto];
                Cpl[s,Lfr] := 2*Qe-Cml[s,Lfr]; end;
{AV}  8 : begin Kr := 2*Crl; Kc := -Crl*(Cpl[s,Lto]+Cml[s,Lfr]);
                Qe := Qav(Kr,Kc,Value);
                Cml[s,Lto] := 2*Qe-Cpl[s,Lto];
                Cpl[s,Lfr] := 2*Qe-Cml[s,Lfr]; end;
{RV}  9 : begin Kr := 2*Crl; Kc := Crl*(Cpl[s,Lto]+Cml[s,Lfr]);
                Qe := Qrv(Kr,Kc,Enr);
                Cml[s,Lto] := 2*Qe-Cpl[s,Lto];
                Cpl[s,Lfr] := 2*Qe-Cml[s,Lfr]; end;
{VA} 10 : begin Kr := 2*Crl; Krc := Crl; Tvt[Vapek[Enr]] := Tli[s,Lto];
                Kc := Crl*(Cpl[s,Lto]+Cml[s,Lfr]);
                If Kc>0 then Kcc := Krc*Cpl[s,Lto]-VrefPost[Vapek[Enr]].Hch
                        else Kcc := Krc*Cml[s,Lfr]+VrefPost[Vapek[Enr]].Hch;
                Qe := Svalve(Kr,Kc,Krc,Kcc,Enr);
                Cml[s,Lto] := 2*Qe-Cpl[s,Lto];
                Cpl[s,Lfr] := 2*Qe-Cml[s,Lfr]; end;
{PU} 11 : begin Kr := 2*Crl; Kc := Crl*(Cpl[s,Lto]+Cml[s,Lfr]);
                Qe := Qpump(Kr,Kc,Enr); Cml[s,Lto] := 2*Qe-Cpl[s,Lto];
                Cpl[s,Lfr] := 2*Qe-Cml[s,Lfr]; end;
{BO} 12 : begin Kr := 2*Crl; Kc := Crl*(Cpl[s,Lto]+Cml[s,Lfr]);
                Qe := Qboil(Kr,Kc,Tli[s,Lto],Enr);
                Cml[s,Lto] := 2*Qe-Cpl[s,Lto];
                Cpl[s,Lfr] := 2*Qe-Cml[s,Lfr]; end;
      END; {Case Ecod}
      Qe := (Cpl[s,Lto]+Cml[s,Lto]+Cpl[s,Lfr]+Cml[s,Lfr])/4;
      If Qe>0 then begin Tli[s,Lfr] := Tli[s,Lto];
         If Ecod=3 then Tli[s,Lfr] := Value;
         If Ecod=5 then Tli[s,Lfr] := Tli[s,Lto]+Value;
         If Ecod=12 then Tli[s,Lfr] := Boiler[Enr].Tp; end;
      If Qe<0 then begin Tli[s,Lto] := Tli[s,Lfr];
         If Ecod=3 then Tli[s,Lto] := Value;
         If Ecod=5 then Tli[s,Lto] := Tli[s,Lfr]-Value;
         If Ecod=12 then begin Boiler[Enr].Tp := Tli[s,Lfr];
                               Boiler[Enr].Tb := Tli[s,Lfr]; end; end;
      end; {With} end; {For c}
    END;    {Lconns}

 PROCEDURE Ljuncs(s:integer);
    VAR  Qsum,Wsum : real;
         c,i : integer;
         Q : array [1..4] of real;

   PROCEDURE NoValveLjn(s,j:integer);
     VAR  i,Links,l : integer;
          Cpm : real;
     BEGIN
       Cpm := 0; Links := 0;
       With LjnPost[s,j] do begin
       For i := 1 to 4 do begin l := Li[i]; Q[i] := 0;
           If l>0 then begin Cpm := Cpm+Cpl[s,l];
                             Links := Links+1; end;
           If l<0 then begin Cpm := Cpm-Cml[s,-l];
                             Links := Links+1; end; end;
       Hljn := Crl*Cpm/Links;
       For i := 1 to 4 do begin l := Li[i];
           If l>0 then begin Cml[s,l] := Cpl[s,l]-2*Cpm/Links;
              Q[i] := (Cpl[s,l]+Cml[s,l])/2; end;
           If l<0 then begin Cpl[s,-l] := Cml[s,-l]+2*Cpm/Links;
              Q[i] := (Cpl[s,-l]+Cml[s,-l])/2; end; end;
       end; {With}
     END;   {NoValveLjn}

     PROCEDURE ValveLjn(s,j:integer);
       VAR i,Iter,l : integer;
           dH0,dQ,dK,Kr,Kc,dH,Krc,Kcc : real;
       BEGIN
         dH0 := 0; Iter := 0;
         With LjnPost[s,j] do begin
         REPEAT
          dQ := 0; dK := 0; Iter := Iter+1;
          If Iter>maxIter then begin writeln;
             write('Sorry! Iteration failed!  Subnet':40);
             write(IdS2(SubId[s] div 10):4,SubId[s] mod 10:1);
             writeln('Ljunc ':8,NrS2(Id):3); Gerror; end;
          For i := 1 to 4 do begin  Q[i] := 0;
              If Li[i]>0 then begin l := Li[i];
                 Kr := Crl; Kc := Kr*Cpl[s,l]-Hljn;
                 If Vnr[i]=0 then begin Q[i] := Kc/Kr; Kkorr := 1/Kr; end
                 else begin Krc := Kr;
                      If Kc>0 then Kcc := Krc*Cpl[s,l]-VrefPost[Vapek[Vnr[i]]].Hch
                              else Kcc := Hljn-VrefPost[Vapek[Vnr[i]]].Hch;
                      If Kc>0 then Q[i] := Svalve(Kr,Kc,Krc,Kcc,Vnr[i])
                              else Q[i] := Qjunc(Kr,Kc,Kcc,Vnr[i]); end;
                 dK := dK+Kkorr; dQ := dQ+Q[i]; end;
              If Li[i]<0 then begin l := -Li[i];
                 Kr := Crl; Kc := Hljn+Kr*Cml[s,l];
                 If Vnr[i]=0 then begin Q[i] := Kc/Kr; Kkorr := 1/Kr; end
                 else begin Krc := Kr;
                      If Kc>0 then Kcc := Hljn-VrefPost[Vapek[Vnr[i]]].Hch
                              else Kcc := Krc*Cml[s,l]+VrefPost[Vapek[Vnr[i]]].Hch;
                      If Kc>0 then Q[i] := Qjunc(Kr,Kc,Kcc,Vnr[i])
                              else Q[i] := Svalve(Kr,Kc,Krc,Kcc,Vnr[i]); end;
                 dK:= dK+Kkorr; dQ := dQ-Q[i]; end; end;
          dH := dQ/dK;
          If (dH0*dH<0) then dH := dH/3;
          Hljn := Hljn+dH; dH0 := dH;
        UNTIL ( (abs(dH)<dHtol) and (abs(dQ)<dQtol) );
{writeln('s=':4,s:3,'Lj=':6,c:3,'Iter=':8,Iter:4);      }
        For i := 1 to 4 do begin  l := Li[i];
            If l>0 then Cml[s,l] := 2*Q[i]-Cpl[s,l];
            If l<0 then Cpl[s,-l] := 2*Q[i]-Cml[s,-l]; end;
         end; {With}
       END;   {ValveLjn}

    BEGIN   { Ljuncs }
      For c := 1 to Ljnmax[s] do begin With LjnPost[s,c] do begin
          If ValveSum=0 then NoValveLjn(s,c)
                        else ValveLjn(s,c);
          Wsum := 0; Qsum := 0;
          For i := 1 to 4 do
              If (Li[i]*Q[i]>0) then begin Qsum := Qsum+abs(Q[i]);
                 Wsum := Wsum+abs(Q[i])*Tli[s,abs(Li[i])]; end;
          If Qsum>0 then Tljn := Wsum/Qsum;
          For i := 1 to 4 do begin
              If (Li[i]*Q[i]<0) then Tli[s,abs(Li[i])] := Tljn;
              If Vnr[i]>0 then Tvt[Vapek[Vnr[i]]] := Tli[s,abs(Li[i])]; end;
      end; {With} end; {For c}
    END;    { Ljuncs }

  PROCEDURE Lcross(s:integer);
    VAR c,i,l : integer;
        CrF,CrR,CpmF,CpmR,Kr,Kc,Qmax,Qi,Qsum,Wsum,dTdum,Tcs : real;

  PROCEDURE CrossValve(s,c:integer);
    VAR Qi,Qsum,Wsum,Kr,Kc,CrF,CrR,CpmF,CpmR,Krc,Kcc : real;
        i,l : integer;
    BEGIN
        CrF := 0; CrR := 0; CpmF := 0; CpmR := 0;
        With LcsPost[s,c] do begin
         For i := 1 to 4 do begin  l := Li[i];
            If l>0 then begin
               CpmF := CpmF+Cpl[s,l]; CrF := CrF+1/Crl; end;
            If l<0 then begin
               CpmF := CpmF-Cml[s,-l]; CrF := CrF+1/Crl; end; end;
         For i := 5 to 8 do begin  l := Li[i];
            If l>0 then begin  CpmR := CpmR+Cpl[s,l];
                               CrR := CrR+1/Crl; end;
            If l<0 then begin  CpmR := CpmR-Cml[s,-l];
                               CrR := CrR+1/Crl; end; end;
         Kr := 1/CrF+1/CrR; Kc := -CpmR/CrR+CpmF/CrF;
         If Kc>0 then begin Krc := 1/CrF;
                 Kcc := Krc*CpmF-VrefPost[Vapek[Vnr]].Hch; end
            else begin Krc := 1/CrR;
                 Kcc := -Krc*CpmR+VrefPost[Vapek[Vnr]].Hch; end;
         Qcs := Svalve(Kr,Kc,Krc,Kcc,Vnr);
         HF := (CpmF-Qcs)/CrF; HR := (CpmR+Qcs)/CrR;
         For i := 1 to 4 do begin  l := Li[i];
             If l>0 then Cml[s,l] := Cpl[s,l]-2*HF/Crl;
             If l<0 then Cpl[s,-l] := Cml[s,-l]+2*HF/Crl; end;
         For i := 5 to 8 do begin  l := Li[i];
             If l>0 then Cml[s,l] := Cpl[s,l]-2*HR/Crl;
             If l<0 then Cpl[s,-l] := Cml[s,-l]+2*HR/Crl; end;
        If Qcs>0 then begin Qsum := 0; Wsum := 0;
           For i := 1 to 4 do begin  l := Li[i];
               If l>0 then begin Qi := (Cpl[s,l]+Cml[s,l])/2;
                  If Qi>0 then begin Qsum := Qsum+Qi;
                     Wsum := Wsum+Qi*Tli[s,l]; end; end;
               If l<0 then begin Qi := (Cpl[s,-l]+Cml[s,-l])/2;
                  If Qi<0 then begin Qsum := Qsum-Qi;
                     Wsum := Wsum-Qi*Tli[s,-l]; end; end; end;
           If Qsum>0 then Tf := Wsum/Qsum else Tf := Tf;
              Tvt[Vapek[Vnr]] := Tf;
           For i := 1 to 4 do begin l := Li[i];
               If l>0 then begin Qi := (Cpl[s,l]+Cml[s,l])/2;
                  If Qi<0 then Tli[s,l] := Tf; end;
               If l<0 then begin Qi := (Cpl[s,-l]+Cml[s,-l])/2;
                  If Qi>0 then Tli[s,-l] := Tf; end; end;
           Qsum := Qcs; Wsum := Qcs*Tf;
           For i := 5 to 8 do begin  l := Li[i];
               If l>0 then begin Qi := (Cpl[s,l]+Cml[s,l])/2;
                  If Qi>0 then begin Qsum := Qsum+Qi;
                     Wsum := Wsum+Qi*Tli[s,l]; end; end;
               If l<0 then begin Qi := (Cpl[s,-l]+Cml[s,-l])/2;
                  If Qi<0 then begin Qsum := Qsum-Qi;
                     Wsum := Wsum-Qi*Tli[s,-l]; end; end; end;
           If Qsum>0 then Tr := Wsum/Qsum else Tr :=Tr;
           For i := 5 to 8 do begin l := Li[i];
               If l>0 then begin Qi := (Cpl[s,l]+Cml[s,l])/2;
                  If Qi<0 then Tli[s,l] := Tr; end;
               If l<0 then begin Qi := (Cpl[s,-l]+Cml[s,-l])/2;
                  If Qi>0 then Tli[s,-l] := Tr; end; end; end
        else begin Qsum := 0; Wsum := 0;
           For i := 5 to 8 do begin  l := Li[i];
               If l>0 then begin Qi := (Cpl[s,l]+Cml[s,l])/2;
                  If Qi>0 then begin Qsum := Qsum+Qi;
                     Wsum := Wsum+Qi*Tli[s,l]; end; end;
               If l<0 then begin Qi := (Cpl[s,-l]+Cml[s,-l])/2;
                  If Qi<0 then begin Qsum := Qsum-Qi;
                     Wsum := Wsum-Qi*Tli[s,-l]; end; end; end;
           If Qsum>0 then Tr := Wsum/Qsum else Tr :=Tr;
              Tvt[Vapek[Vnr]] := Tr;
           For i := 5 to 8 do begin l := Li[i];
               If l>0 then begin Qi := (Cpl[s,l]+Cml[s,l])/2;
                  If Qi<0 then Tli[s,l] := Tr; end;
               If l<0 then begin Qi := (Cpl[s,-l]+Cml[s,-l])/2;
                  If Qi>0 then Tli[s,-l] := Tr; end; end;
           Qsum := -Qcs; Wsum :=-Qcs*Tr;
           For i := 1 to 4 do begin  l := Li[i];
               If l>0 then begin Qi := (Cpl[s,l]+Cml[s,l])/2;
                  If Qi>0 then begin Qsum := Qsum+Qi;
                     Wsum := Wsum+Qi*Tli[s,l]; end; end;
               If l<0 then begin Qi := (Cpl[s,-l]+Cml[s,-l])/2;
                  If Qi<0 then begin Qsum := Qsum-Qi;
                     Wsum := Wsum-Qi*Tli[s,-l]; end; end; end;
           If Qsum>0 then Tf := Wsum/Qsum else Tf := Tf;
           For i := 1 to 4 do begin l := Li[i];
               If l>0 then begin Qi := (Cpl[s,l]+Cml[s,l])/2;
                  If Qi<0 then Tli[s,l] := Tf; end;
               If l<0 then begin Qi := (Cpl[s,-l]+Cml[s,-l])/2;
               If Qi>0 then Tli[s,-l] := Tf; end; end; end;
        end; {With}
    END;  {CrossValve}

    BEGIN  {Lcross}
     dTdum := 0.01;
     For c := 1 to Lcsmax[s] do begin
         CrF := 0; CrR := 0; CpmF := 0; CpmR := 0; Qsum := 0; Wsum := 0;
If LcsPost[s,c].Vnr>0 then CrossValve(s,c) else begin
         With LcsPost[s,c] do begin
         For i := 1 to 4 do begin  l := Li[i];
            If l>0 then begin
               CpmF := CpmF+Cpl[s,l]; CrF := CrF+1/Crl;
               Qi := (Cpl[s,l]+Cml[s,l])/2;
               If Qi>0 then begin Qsum := Qsum+Qi;
                  Wsum := Wsum+Qi*Tli[s,l]; end; end;
            If l<0 then begin
               CpmF := CpmF-Cml[s,-l]; CrF := CrF+1/Crl;
               Qi := (Cpl[s,-l]+Cml[s,-l])/2;
               If Qi<0 then begin Qsum := Qsum-Qi;
                  Wsum := Wsum-Qi*Tli[s,-l]; end; end; end;
         If Qsum>Epsi then Tf := Wsum/Qsum else Tf := Tr+dTdum;
         CASE Cat OF
         'A': Tr := Aret+dTr;
         'B': Tr := Bret+dTr;
         'C': Tr := Cret+dTr;
         'D': Tr := Dret+dTr;
         'E': Tr := Eret+dTr;
         'F': Tr := Fret+dTr;
         END; {Case}
         If abs(Tf-Tr)>Epsi then Ql := Pload/RaCsp/abs(Tf-Tr)
                            else Ql := Pload/RaCsp/dTdum;
         For i := 5 to 8 do begin  l := Li[i];
            If l>0 then begin  CpmR := CpmR+Cpl[s,l];
                               CrR := CrR+1/Crl; end;
            If l<0 then begin  CpmR := CpmR-Cml[s,-l];
                               CrR := CrR+1/Crl; end; end;
         Kr := 1/CrF+1/CrR; Kc := CpmR/CrR-CpmF/CrF;
         Qmax := Qstr(Kr,Kc,Avmax,Avmax);
         If Qmax<Ql then Qcs := Qmax else Qcs := Ql;
         HF := (CpmF-Qcs)/CrF; HR := (CpmR+Qcs)/CrR;
         For i := 1 to 4 do begin  l := Li[i];
             If l>0 then begin Cml[s,l] := Cpl[s,l]-2*Hf/Crl;
                Qi := (Cpl[s,l]+Cml[s,l])/2;
                If Qi<0 then Tli[s,l] := Tf; end;
             If l<0 then begin Cpl[s,-l] := Cml[s,-l]+2*Hf/Crl;
                Qi := (Cpl[s,-l]+Cml[s,-l])/2;
                If Qi>0 then Tli[s,-l] := Tf; end; end;
         Qsum := Qcs; Wsum := Qcs*Tr;
         For i := 5 to 8 do begin  l := Li[i];
             If l>0 then begin Cml[s,l] := Cpl[s,l]-2*Hr/Crl;
                Qi := (Cpl[s,l]+Cml[s,l])/2;
                If Qi>0 then begin Qsum := Qsum+Qi;
                   Wsum := Wsum+Qi*Tli[s,l]; end; end;
             If l<0 then begin Cpl[s,-l] := Cml[s,-l]+2*Hr/Crl;
                Qi := (Cpl[s,-l]+Cml[s,-l])/2;
                If Qi<0 then begin Qsum := Qsum-Qi;
                   Wsum := Wsum-Qi*Tli[s,-l]; end; end; end;
         If Qsum>Epsi then Tcs := Wsum/Qsum else Tcs := Tr;
         If Qcs<Epsi then Tr := Tcs;
         For i := 5 to 8 do begin l := Li[i];
             If l>0 then begin
                Qi := (Cpl[s,l]+Cml[s,l])/2;
                If Qi<0 then Tli[s,l] := Tcs; end;
             If l<0 then begin
                Qi := (Cpl[s,-l]+Cml[s,-l])/2;
                If Qi>0 then Tli[s,-l] := Tcs; end; end;
     end; {With} end; {else} end; {For c}
    END;    {Lcross}

 PROCEDURE HeatLex(s:integer);
  VAR Lex,Ep,Sign : integer;
      Kr,Kc,Qp,Qs,RaCspp,RaCsps,x,B,Efm,Efp,Efs,Axp,Axs,kA : real;
  BEGIN
   For Lex := 1 to Lexmax[s] do begin With LexPost[s,Lex] do begin
       Kr := 2*Crl; Kc := -Crl*(Cpl[s,pTo]+Cml[s,pFr]);
       Qp := Qav(Kr,Kc,pAv);
       Cml[s,pTo] := 2*Qp-Cpl[s,pTo];
       Cpl[s,pFr] := 2*Qp-Cml[s,pFr];
       Kr := 2*Crl; Kc := -Crl*(Cpl[s,sTo]+Cml[s,sFr]);
       Qs := Qav(Kr,Kc,sAv);
       Cml[s,sTo] := 2*Qs-Cpl[s,sTo];
       Cpl[s,sFr] := 2*Qs-Cml[s,sFr];
       If Qp<0 then Sign := -1 else Sign := +1;
       If abs(Qp)<Epsi then Qp := Sign*Epsi;
       If Qs<0 then Sign := -1 else Sign := +1;
       If abs(Qs)<Epsi then Qs := Sign*Epsi;
       Ep := HexPerfpek[Href];
       Axp := 1+HexPerf[Ep].AdTm*((Tli[s,pTo]+Tli[s,pFr])/2-Tpm);
       Axp := 1/Axp/exp(HexPerf[Ep].Vexp*ln(abs(Qp/Qpo)));
       Axs := 1+HexPerf[Ep].AdTm*((Tli[s,sTo]+Tli[s,sFr])/2-Tsm);
       Axs := 1/Axs/exp(HexPerf[Ep].Vexp*ln(abs(Qs/Qso)));
       kA := (Axp+HexPerf[Ep].Aps*Axs)/(HexPerf[Ep].Aps+1);
       kA := kAo/(HexPerf[Ep].TL+(1-HexPerf[Ep].TL)*kA);
       If kA<(0.1*kAo) then kA := 0.1*kAo;
       TempInit((Tli[s,pTo]+Tli[s,pFr])/2); RaCspp := Ra*Csp;
       TempInit((Tli[s,sTo]+Tli[s,sFr])/2); RaCsps := Ra*Csp;
       TempInit(Tinit);
       x := RaCsps*Qs/RaCspp/Qp;
       If x>0 then begin B := (1-x)/x*kA/RaCspp/abs(Qp);
          If B>60 then B := 60;
          If B<-60 then B := -60;
          If abs(x-1)<Epsi then Efm := 1/(1+RaCspp*abs(Qp)/kA)
                           else Efm := (1+x)/2*(1-exp(B))/(x-exp(B));
          Efp := 2*x/(1+x)*Efm; Efs := 2/(1+x)*Efm;
          If Qp>0 then begin Tli[s,pFr] := Tli[s,pTo]-Efp*(Tli[s,pTo]-Tli[s,sTo]);
                       Tli[s,sFr] := Tli[s,sTo]+Efs*(Tli[s,pTo]-Tli[s,sTo]); end
                  else begin Tli[s,pTo] := Tli[s,pFr]-Efp*(Tli[s,pFr]-Tli[s,sFr]);
                       Tli[s,sTo] := Tli[s,sFr]+Efs*(Tli[s,pFr]-Tli[s,sFr]); end;
       end; {x>0}
       If x<0 then begin x := abs(x); B := (1+x)/x*kA/RaCspp/abs(Qp);
          If B>60 then B := 60;
          If B<-60 then B := -60;
          Efm := 1/2*(1-exp(-B));
          Efp := 2*x/(1+x)*Efm; Efs := 2/(1+x)*Efm;

          If Qp>0 then begin Tli[s,pFr] := Tli[s,pTo]-Efp*(Tli[s,pTo]-Tli[s,sFr]);
                       Tli[s,sTo] := Tli[s,sFr]+Efs*(Tli[s,pTo]-Tli[s,sFr]); end
                  else begin Tli[s,pTo] := Tli[s,pFr]-Efp*(Tli[s,pFr]-Tli[s,sTo]);
                       Tli[s,sFr] := Tli[s,sTo]+Efs*(Tli[s,pFr]-Tli[s,sTo]); end;
      end; {x<0}
   end; {with} end; {For Lex}
  END;  {HeatLex}

  PROCEDURE Borders (s : integer);
    VAR Qe : real;
        b,Li,Pi : integer;
    BEGIN
      For b := 1 to Brmax[s] do begin
          Li := BorPost[s,b].Li; Pi := BorPost[s,b].Pi;
          If (Li<0) then begin Li := -Li;
              Qe := (Cr[Pi]*Cp[Pi]+Crl*Cml[s,Li])/(Cr[Pi]+Crl);
              Cpl[s,Li] := 2*Qe-Cml[s,Li];
              If Qe>0 then Tli[s,Li] := Tt[Pi,1]
                      else begin Tt[Pi,1] := Tli[s,Li];
                                 Tt[Pi,0] := Tt[Pi,1]-dTt[Pi]; end; end
          else begin Pi := -Pi;
              Qe := (Crl*Cpl[s,Li]+Cr[Pi]*Cm[Pi])/(Crl+Cr[Pi]);
              Cml[s,Li] := 2*Qe-Cpl[s,Li];
              If Qe>0 then begin Tt[Pi,0] := Tli[s,Li];
                                 Tt[Pi,1] := Tli[s,Li]-dTt[Pi]; end
                      else Tli[s,Li] := Tt[Pi,0]; end;
          Qbor[b] := Qe; end;
    END;   {Borders}

  BEGIN {Locals}
    For  s := 1 to Sumax do begin
         Iter := 0; Borders(s);
         For i := 1 to Limax[s] do begin dQS[i] := 0; dHS[i] := 0; end;
     REPEAT Iter := Iter+1;
       If (Iter>maxIter) then begin writeln;
          write('Sorry! Iteration failed!  Subnet :':35);
          writeln(IdS2(SubId[s] div 10):3,SubId[s] mod 10:1);
          Gerror; end;
       For i := 1 to Limax[s] do begin l := Lipek[s,i];
           Cpl0[i] := Cpl[s,l]; Cml0[i] := Cml[s,l]; end;
       If Liomax[s]>0 then Lbounds(s);
       If Lcnmax[s]>0 then Lconns(s);
       If Ljnmax[s]>0 then Ljuncs(s);
       If Lcsmax[s]>0 then Lcross(s);
       If Lexmax[s]>0 then HeatLex(s);
       Borders(s); TolFlag := True;
       For i := 1 to Limax[s] do begin l := Lipek[s,i];
           dQ := (Cpl[s,l]+Cml[s,l]-Cpl0[i]-Cml0[i])/2;
           dH := (Cpl[s,l]-Cml[s,l]-Cpl0[i]+Cml0[i])*Crl/2;
{If s=2 then writeln('s=2':4,'Iter=':7,Iter:3,'l=':5,l:2,'dQ=':5,dQ:6:4,'dH=':5,dH:6:4);}
           If (abs(dQ)>dQtol) then TolFlag := false;
           If (abs(dH)>dHtol) then TolFlag := false;
           If ((dQ*dQS[i])<0) or ((dH*dHS[i])<0) then begin
              Cpl[s,l] := Cpl0[i]+(Cpl[s,l]-Cpl0[i])*2/3;
              Cml[s,l] := Cml0[i]+(Cml[s,l]-Cml0[i])*2/3; end;
           If (dQ>0) then dQS[i] := 1 else dQS[i] := -1;
           If (dH>0) then dHS[i] := 1 else dHS[i] := -1; end;
    UNTIL (TolFlag);
{  writeln('s=':4,s:2,'Iter=':8,Iter:3);        }
    For b := 1 to Brmax[s] do begin Pi := BorPost[s,b].Pi; Qe := Qbor[b];
        If (Pi>0) then begin Qtdt[Pi,1] := Qe;
            Htdt[Pi,1] := (Cp[Pi]-Qe)*Cr[Pi];
            Cm[Pi] := Qe-Htdt[Pi,1]/Cr[Pi]-Rdt[Pi]*abs(Qe)*Qe;end
        else begin Pi := -Pi; Qtdt[Pi,0] := Qe;
            Htdt[Pi,0] := (Qe-Cm[Pi])*Cr[Pi];
            Cp[Pi] := Qe+Htdt[Pi,0]/Cr[Pi]-Rdt[Pi]*abs(Qe)*Qe; end;
    end; {For b} end; {For s}
  END; {Locals}

   PROCEDURE Update;
      VAR  p,i,s : integer;
           dH,dQ,V,La,Qs,Qr,Cp0,Cm0,dCp,dCm,Nyt : real;
           TempFlag : Boolean;
      BEGIN
         TempFlag := true;
         For p := 1 to (Pimax+CloseMax) do begin
             If M>Mtol then begin With PipePost[p] do begin
                V := Qtdt[p,0]/Api[p];
                Nyt := Viscosity((Tt[p,0]+Tt[p,1])/2);
                La := Lamda(V,Nyt,D,Ks);
                Rdt[p] := (La*L/D+Zeta)/Api[p]/Aaset/2; end; end;
             Qs := Qt[p,0]; Qr := Qt[p,1];
             Cp0 := Qs+Ht[p,0]/Cr[p]-Rdt[p]*abs(Qs)*Qs;
             Cm0 := Qr-Ht[p,1]/Cr[p]-Rdt[p]*abs(Qr)*Qr;
             dCp := Cp[p]-Cp0; dCm := Cm[p]-Cm0;
             dQ := Cp[p]+Cm[p]-Cp0-Cm0;
             dH := Cp[p]-Cm[p]-Cp0+Cm0;
             If ((dQ*dQS[p])<0) or ((dH*dHS[p])<0) then begin
                Cp[p] := Cp0+2*dCp/3; Cm[p] := Cm0+2*dCm/3; end;
             If dQ>0 then dQS[p] := 1 else dQS[p] := -1;
             If dH>0 then dHS[p] := 1 else dHS[p] := -1;
            For i := 0 to 1 do begin
               dH := abs(Htdt[p,i]-Ht[p,i]); dQ := abs(Qtdt[p,i]-Qt[p,i]);
               If (dH>Htol) or (dQ>Qtol) or (M<Mmin) then TempFlag := false;
               Ht[p,i] := Htdt[p,i]; Qt[p,i] := Qtdt[p,i]; end;
         end;
         If (M>Mtol) then begin
            For i := 1 to Iomax do With IoPost[i] do
                If QP='P' then
                   If ((BE='I') or (BE='T'))
                             then Hbound := Value*1E05/Density(Tt[Pi,0])/g+Elev
                             else Hbound := Value*1E05/Density(Tt[Pi,1])/g+Elev;
            For i := 1 to Cnmax do begin With CnPost[i] do begin
                If Ecod=2 then Hconn := Value*1E05/Density(Tt[Pto,1])/g+Elev;
                If Ecod=12 then begin TempInit((Tt[Pto,1]+Tt[Pfr,0])/2);
                   Boiler[Enr].RaCsp := Ra*Csp; end; end; end;
            For i := 1 to Csmax do begin With CsPost[i] do begin
                TempInit((Tf+Tr)/2); RaCsp := Ra*Csp; end; end;
            For s := 1 to Sumax do begin
                For i := 1 to Liomax[s] do With LioPost[s,i] do
                    If QP='P' then Hbound := Value*1E05/Density(Tli[s,Li])/g+Elev;
                For i := 1 to Lcnmax[s] do begin With LcnPost[s,i] do begin
                    If Ecod=2 then Hconn := Value*1E05/Density(Tli[s,Lto])/g+Elev;
                    If Ecod=12 then begin TempInit((Tli[s,Lto]+Tli[s,Lfr])/2);
                       Boiler[Enr].RaCsp := Ra*Csp; end; end; end;
                For i := 1 to Lcsmax[s] do begin With LcsPost[s,i] do begin
                    TempInit((Tf+Tr)/2); RaCsp := Ra*Csp; end; end; end;
            For i := 1 to Vamax do begin TempInit(Tvt[i]);
                VrefPost[i].Hch := 0.96*Hvap-Hatm+VrefPost[i].Zv; end;
            TempInit(Tinit); end;
        If TempFlag then ConvFlag := true;
      END;   { Update }

     PROCEDURE CloseConns;
       VAR i,s,e : integer;
       BEGIN
        For i := 1 to CloseMax do begin
            s := SelPipe[i]; e := ExPipe[i];
            Qtdt[s,1] := 0; Qtdt[e,0] := 0;
            Htdt[s,1] := Cp[s]*Cr[s]; Cm[s] := -Cp[s];
            Htdt[e,0] := -Cm[e]*Cr[e]; Cp[e] := -Cm[e];
            Qt[s,0] := 0; Qt[e,1] := 0; end;
       END; {CloseConns}

     PROCEDURE Compute;
       VAR i : integer;
       BEGIN
         If not ConvFlag then begin
            dHtol := Htol; dQtol := Qtol;
            OldSet := AaSet; AaSet := AaStart;
            NewRespons(OldSet,AaSet); end;
         For i := 1 to (Pimax+Closemax) do begin dQS[i] := 0; dHS[i] := 0; end;
         M := 0; ConvFlag := false;
         For i := 1 to maxVaCtrl do VaCtrl[i].dSetold := 0;
         For i := 1 to maxDrCtrl do DrCtrl[i].dSetold := 0;
         WHILE not ConvFlag and (M<Itermax) do begin
           If M=Mtol then begin
              dHtol := Ftol*Htol; dQtol := Ftol*Qtol;
              Oldset := AaSet; Aaset := AaResp;
              NewRespons(OldSet,AaSet); end;
           If (M mod Step = 0) then PrintDpl;
           M := M+1;
           If dTtFlag then SetdTt;
           If (M>ManVaCtrl) and (VaCtrlmax>0) then AutoValve;
           If (M>ManDrCtrl) and (DrCtrlmax>0) then AutoDrive;
           If CloseMax>0 then CloseConns;
           If Iomax>0 then Bounds;
           If Cnmax>0 then Connections;
           If Jnmax>0 then Junctions;
           If Csmax>0 then Crossconns;
           If Exmax>0 then HeatEx;
           If Sumax>0 then Locals;
           Update; end;
         Dummy := Step; Step := M; PrintDpl;
         If (Step=Itermax) then begin writeln;
            writeln('Iteration stopped!  M = IterMax!':43); end;
         Step := Dummy; Dummy := 1; PumpH1pt; ValveProp;
       END; {Compute}

  PROCEDURE ListMaxMin;
   CONST maxRad = 16;
   VAR   Rvalue : array[1..maxPi] of real;
         Upek : array[1..maxPi] of integer;
         i,u,u1,u2,Line,Radmax,Ucmax,Znr,Nr : integer;
         Extrem : array[1..2,1..maxRad] of real;
         Rad : array[1..2,1..maxRad] of integer;
         HeadL1,HeadL2 : packed array[1..6] of char;

    PROCEDURE MaxMin(Pmax:integer);
      VAR   i,p,j : integer;
            Value : real;

     FUNCTION ExFlag(Value:real; i:integer) : Boolean;
      BEGIN
       CASE j OF             {j=1:Max, J=2:Min}
        1: If (Value>Extrem[j,i]) then ExFlag := true else ExFlag := false;
        2: If (Value<Extrem[j,i]) then ExFlag := true else ExFlag := false;
       END;
      END; {ExFlag}

     PROCEDURE Sort(Value:real);
      VAR i,n,r : integer;
      BEGIN
       i := 1;
       REPEAT  If ExFlag(Value,i) then begin r := i;
                  For n := Radmax downto r+1 do Extrem[j,n] := Extrem[j,n-1];
                  For n := Radmax downto r+1 do Rad[j,n] := Rad[j,n-1];
                  Extrem[j,i] := Value; Rad[j,i] := p; i := Radmax+1; end
                else i := i+1;
        UNTIL (i=Radmax+1);
      END; {Sort}

    BEGIN {MaxMin}
     If Radmax>Pmax then Radmax := Pmax;  {j=1:Max,  j=2:Min}
     For i := 1 to Radmax do Extrem[1,i] := 1E-06; {Max}
     For i := 1 to Radmax do Extrem[2,i] := 1E+06; {Min}
     For j := 1 to 2 do
         For p := 1 to Pmax do begin Value := Rvalue[p];
             If ExFlag(Value,Radmax) then Sort(Value); end;
  END; {MaxMin}

  PROCEDURE HeadLine;
   BEGIN
   writeln('1:  Set new search area            ':43);
   writeln('2:  Max/Min Pipe Cross Differential Head':48);
   writeln('3:  Max/Min Pipe Flow Velocity     ':43);
   writeln('4:  Max/Min Pipe Head Loss  dH/dL  ':43);
   writeln; writeln('Select Line, 0 for exit':40);
   END;

 BEGIN {ListMaxMin}
   For i := 1 to 12 do Str := ' ';
   Str[1] := '*'; Str[2] := '*'; Len := 2;
   REPEAT Aclear;
     writeln('SEARCH AREA IS     Zon : ':40,Str:12); writeln;
     HeadLine; Radmax := maxRad;
     Line := LineNr(4);
     CASE Line OF
      0: begin end;
      1: begin writeln('Old search area   ':30,'Zon : ':10, Str:12);
                 write('New search area   ':30); Zstr; end;
      2: begin Aclear; u := 0;
         For i := 1 to Csmax do begin  With CsPost[i] do begin
             Znr := Id div 100;
             If Str[1]='+' then SeCom(Com,Str,Len)
                           else SeZon(IdS2(Znr),Str,Len);
             If Pflag then begin u := u+1; Upek[u] := i;
                Rvalue[u] := Hf-Hr; end; end; end;
         Ucmax := u; MaxMin(Ucmax);
         If ConvFlag then writeln('MAX:':19,'MIN:':33) 
            else writeln('MAX:':19,'M = Itermax!!':19,'MIN:':14,'WARNING ONLY!':19);
         writeln; 
         writeln('Cross    dH     Comment           Cross    dH     Comment':63);
         writeln('Zon Nr   mLc     -----            Zon Nr   mLc     ----- ':63);
         writeln;
         For i := 1 to Radmax do begin write(i:2);
             u1 := Upek[Rad[1,i]]; u2 := Upek[Rad[2,i]];
             Znr := CsPost[u1].Id div 100; Nr := CsPost[u1].Id mod 100;
             write(IdS2(Znr):6,NrS2(Nr):4);
             write(Extrem[1,i]:7:1,CsPost[u1].Com:15);
             Znr := CsPost[u2].Id div 100; Nr := CsPost[u2].Id mod 100;
             write(IdS2(Znr):8,NrS2(Nr):4);
             write(Extrem[2,i]:7:1,CsPost[u2].Com:15);
             writeln; end;
         Stop; end;
    3,4: begin Aclear; u := 0;
         For i := 1 to Pimax do begin With PipePost[i] do begin
             Znr := Id div 100;
             If Str[1]='+' then SeCom(Com,Str,Len)
                           else SeZon(IdS2(Znr),Str,Len);
             If Pflag then begin u := u+1; Upek[u] := i;
             CASE Line OF
             3: begin Rvalue[u] := abs((Qt[i,0]+Qt[i,1])/2/Pii/sqr(D)*4);
                HeadL1 := ' |V|  '; HeadL2 := ' m/s  '; end;
             4: begin Rvalue[u] := 1000*abs((Ht[i,0]-Ht[i,1])/L);
                HeadL1 := 'dH/dL '; HeadL2 := 'mLc/km'; end;
             END; end; {If} end; {With} end; {For}
         Ucmax := u; MaxMin(Ucmax);
         If ConvFlag then writeln('MAX:':19,'MIN:':33) 
            else writeln('MAX:':19,'M = Itermax!!':19,'MIN:':14,'WARNING ONLY!':19);
         writeln; 
         writeln('Pipe':11,HeadL1:9,'Comment':9,'Pipe':15,HeadL1:9,'Comment':9);
         writeln('ZnNr':11,HeadL2:9,' ----- ':9,'ZnNr':15,HeadL2:9,' ----- ':9);
         writeln;
         For i := 1 to Radmax do begin write(i:2);
             u1 := Upek[Rad[1,i]]; u2 := Upek[Rad[2,i]];
             Znr := PipePost[u1].Id div 100; 
             Nr := PipePost[u1].Id mod 100;
             write(IdS2(Znr):7,NrS2(Nr):2); 
             write(Extrem[1,i]:7:1,PipePost[u1].Com:15);
             Znr := PipePost[u2].Id div 100;
             Nr := PipePost[u2].Id mod 100;
             write(IdS2(Znr):9,NrS2(Nr):2);
             write(Extrem[2,i]:7:1,PipePost[u2].Com:16);
             writeln; end;
         Stop; end;
     END; {Case Line}
   UNTIL (Line=0);
  END; {ListMaxMin}

     PROCEDURE ReadDump;
       VAR p,Jn,s,c,l,i1,i2,Va,Pu,Dr,ConvDum,i,Bo,Did,Pipemax,Connmax,
           Crossmax,Juncmax,Valvmax,Pumpmax,Drivmax,Submax,maxLink,
           Boilermax: integer;
           Lconnmax,Ljuncmax,Lcrossmax : array[1..maxSu] of integer;
           Oldset,RtDum,Ndum,Vdum : real;
           DiffFlag : Boolean;

       BEGIN
         i1 := 0; i2 := 1; RtDum := 0.1; DiffFlag := false;
         Connect(f,Fil[4],'R'); 
         If Felkod<>0 then begin writeln;
            writeln('File not found:':33,Fil[4]:17); end;
         If Felkod=0 then begin     
            read(f,Oldset,Crl,ConvDum,Pipemax,Connmax,Juncmax,Crossmax);
            readln(f,Submax,Valvmax,Pumpmax,Drivmax,Boilermax);
            If ConvDum=1 then ConvFlag := true else ConvFlag := false;
            For p := 1 to Pipemax do begin
                read(f,Qt[p,i1],Qt[p,i2],Ht[p,i1],Ht[p,i2],Rdt[p],Cr[p]);
                readln(f,Tt[p,i1],Tt[p,i2]);
                dTt[p] := Tt[p,i1]-Tt[p,i2]; end;
            For Jn := 1 to Juncmax do readln(f,JnPost[Jn].Hjn);
            For i := 1 to Crossmax do With CsPost[i] do readln(f,Tf,RaCsp);
            For s := 1 to Submax do begin
                readln(f,Lconnmax[s],Ljuncmax[s],Lcrossmax[s]);
                For c := 1 to Ljuncmax[s] do readln(f,LjnPost[s,c].Hljn);
                For c := 1 to Lcrossmax[s] do With LcsPost[s,c] do
                    readln(f,Tf,RaCsp); end;
            For s := 1 to Submax do begin readln(f,maxLink);
                If (maxLink<>Limax[s]) then DiffFlag := true;
                For i := 1 to maxLink do begin l := Lipek[s,i]; 
                    readln(f,Cpl[s,l],Cml[s,l],Tli[s,l]); end; end;
            For Va := 1 to Valvmax do begin readln(f,Vdum,Tvt[Va]);
                TempInit(Tvt[Va]);
                VrefPost[Va].Hch := 0.96*Hvap-Hatm+VrefPost[Va].Zv;
                For i := 1 to VaCtrlmax do
                    If VrefPost[Va].Id=VaCtrl[i].VaId
                       then begin VrefPost[Va].S := Vdum;
                            VrefPost[Va].Fi := FiavS(Va,Vdum);
                            VrefPost[Va].Fl := Flf(Va,S); end; end;
            For Pu := 1 to Pumpmax do readln(f,Qpt[Pu]);
            For Dr := 1 to Drivmax do begin readln(f,Ndum);
                For i := 1 to DrCtrlmax do
                    If DrCtrl[i].DrId=DrivePost[Dr].Id
                       then DrivePost[Dr].Ndr := Ndum; end;
            For Pu := 1 to Pumax do begin
                Did := PrefPost[Pu].DrId;
                PrefPost[Pu].Np := DrivePost[Drpek[Did]].Ndr; end;
            For Bo := 1 to Boilermax do 
                readln(f,Boiler[Bo].Qbt,Boiler[Bo].RaCsp);
            Close(f);
            For i := 1 to Iomax do With IoPost[i] do
                If QP='P' then
                   If ((BE='I') or (BE='T'))
                      then Hbound := Value*1E05/Density(Tt[Pi,0])/g+Elev
                      else Hbound := Value*1E05/Density(Tt[Pi,1])/g+Elev;
            For i := 1 to Cnmax do With CnPost[i] do
                If Ecod=2 then 
                   Hconn := Value*1E05/Density(Tt[Pto,1])/g+Elev;
            For s := 1 to Sumax do begin
                For i := 1 to Liomax[s] do With LioPost[s,i] do
                    If QP='P' then 
                       Hbound := Value*1E05/Density(Tli[s,Li])/g+Elev;
                For i := 1 to Lcnmax[s] do With LcnPost[s,i] do
                    If Ecod=2 then 
                    Hconn := Value*1E05/Density(Tli[s,Lto])/g+Elev; end;
            If (Pipemax<>Pimax) then DiffFlag := true;
            If (Connmax<>Cnmax) then DiffFlag := true;
            If (Juncmax<>Jnmax) then DiffFlag := true;
            If (Crossmax<>Csmax) then DiffFlag := true;
            If (Submax<>Sumax)  then DiffFlag := true;
            If (Valvmax<>Vamax) then DiffFlag := true;
            If (Pumpmax<>Pumax) then DiffFlag := true;
            If (Drivmax<>Drmax) then DiffFlag := true;
            If Boilermax<>Boilmax then DiffFlag := true;
            For s := 1 to Sumax do begin
                If Lconnmax[s]<>Lcnmax[s] then DiffFlag := true;
                If Ljuncmax[s]<>Ljnmax[s] then DiffFlag := true;
                If Lcrossmax[s]<>Lcsmax[s] then DiffFlag := true; end;
            If DiffFlag then begin writeln;
               writeln('Differencies observed!   Warning only!':53);
               writeln; ConvFlag := false; end;
            If ConvFlag then AaSet := AaResp else AaSet := AaStart;
            NewRespons(Oldset,Aaset); 
            writeln('Data read from ':30,Fil[4]:maxCh1);
         end; {If Felkod=0)}     
       END; { ReadDump }

     PROCEDURE WriteDump;
       VAR p,Jn,s,c,l,i1,i2,Pu,Dr,ConvDum,i,Bo : integer;

       BEGIN
         i1 := 0; i2 := 1;
         If ConvFlag then ConvDum := 1 else ConvDum := 0;
         Connect(f,Fil[4],'W');
         write(f,Aaset:10:2,Crl:10:2,ConvDum:2,Pimax:6,Cnmax:6,Jnmax:6);
         writeln(f,Csmax:6,Sumax:6,Vamax:6,Pumax:6,Drmax:6,Boilmax:6);
         For p := 1 to Pimax do begin
             write(f,Qt[p,i1]:10:5,Qt[p,i2]:10:5,Ht[p,i1]:10:3);
             write(f,Ht[p,i2]:10:3,Rdt[p]:12:5,Cr[p]:11:3);
             writeln(f,Tt[p,i1]:10:2,Tt[p,i2]:10:2); end;
         For Jn := 1 to Jnmax do writeln(f,Jnpost[Jn].Hjn:9:3);
         For i := 1 to Csmax do With CsPost[i] do writeln(f,Tf,RaCsp);
         For s := 1 to Sumax do begin
             writeln(f,Lcnmax[s]:4,Ljnmax[s]:4,Lcsmax[s]:4);
             For c := 1 to Ljnmax[s] do writeln(f,LjnPost[s,c].Hljn:9:3);
             For c := 1 to Lcsmax[s] do With LcsPost[s,c] do
                 writeln(f,Tf,RaCsp); end;
         For s := 1 to Sumax do begin writeln(f,Limax[s]:4);
             For i := 1 to Limax[s] do begin l := Lipek[s,i];
                 writeln(f,Cpl[s,l]:9:5,Cml[s,l]:9:5,Tli[s,l]); end; end;
         For i := 1 to Vamax do writeln(f,VrefPost[i].S,Tvt[i]);
         For Pu := 1 to Pumax do writeln(f,Qpt[Pu]:9:5);
         For Dr := 1 to Drmax do writeln(f,DrivePost[Dr].Ndr);
         For Bo := 1 to Boilmax do writeln(f,Boiler[Bo].Qbt,Boiler[Bo].RaCsp);
         Close(f); writeln('Data written to ':30,Fil[4]:maxCh1);
       END; { WriteDump }

      PROCEDURE Xvalues;
       VAR  Dec : integer;
       BEGIN
        Aclear;
        writeln('Selected Case : ':35,SetCase:6); writeln;
        writeln('Current X-values are : ':35); writeln;
        Dec := DecF(x1); writeln('x1 = ':20,x1:8:Dec,': ':8,x1string:20);
        Dec := DecF(x2); writeln('x2 = ':20,x2:8:Dec,': ':8,x2string:20);
        Dec := DecF(x3); writeln('x3 = ':20,x3:8:Dec,': ':8,x3string:20);
       END;    {Xvalues}

   PROCEDURE Seloutput;
    TYPE S30 = packed array[1..30] of char;
         PostOut = record PL : char; 
                          Cnr,p1,p2,i1,i2 : integer; 
                          Com : S30;   end;
    VAR OutPost : array[1..20] of PostOut;
        Outmax : integer;
        SeldataFlag : Boolean;
     
    PROCEDURE Seldata;
     VAR i,Kod,Snr,IdNr,Sid,Znr,j : integer;
         ch,c,SD,PLdum,BE,Dum : char;
         Code : packed array[1..2] of char; 
         f : text; 
     BEGIN
      Connect(f,Fil[9],'R'); Radantal := 1;
      If Felkod<>0 then begin writeln;
         writeln('File not found:':33,Fil[9]:17); end;
      If Felkod=0 then begin 
         readln(f); Red; read(f,ch); i := 0; 
         WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end; 
         WHILE ch=' ' do begin i := i+1; 
         REPEAT read(f,c); UNTIL (c<>' '); 
         c := Uchar(c); Code[1] := c; read(f,c); 
         c := Uchar(c); Code[2] := c; Kod := 99;
         If Code='H ' then begin kod := 1; SD := 'S'; end;
         If Code='DH' then begin kod := 2; SD := 'D'; end;
         If Code='Q ' then begin kod := 3; SD := 'S'; end;
         If Code='DQ' then begin kod := 4; SD := 'D'; end;
         If Code='T ' then begin kod := 5; SD := 'S'; end;
         If Code='DT' then begin kod := 6; SD := 'D'; end;
         If Code='W ' then begin kod := 7; SD := 'S'; end;
         If Code='DW' then begin kod := 8; SD := 'D'; end;
         If Code='HM' then begin kod := 9; SD := 'D'; end;
         If not (kod in [1,2,3,4,5,6,7,8,9]) then begin 
            writeln('Selected Output, Code Error!':30); Gerror; end;
         With OutPost[i] do begin Cnr := Kod;
         CASE SD OF
         'S': begin Znr := ReadZ2(f); read(f,PLdum); PL := 'X';
              If PLdum in ['1'..'9'] then begin PL := 'L';
                 Sid := ord(PLdum)-48+10*Znr; p1 := Supek[Sid];
                 If (p1<1) or (p1>Sumax) then begin 
                    writeln('Selected output, Pos 1, Subnet Error!':37);
                    Gerror; end;
                 read(f,i1); p2 := 0; i2 := 0;
                 REPEAT read(f,Dum); UNTIL Dum<>' '; 
                 For j := 1 to 17 do read(f,Dum); end;     
               If Pldum=' ' then begin PL := 'P';
                  read(f,Snr); IdNr := Snr+100*Znr;
                  p1 := Pipek[Idnr]; p2 := 0; i2 := 0;
                  If (p1<1) or (p1>Pimax) then begin 
                     writeln('Selected output,Pos 1, Pipe Error!':36);
                     Gerror; end;
                  REPEAT read(f,BE); UNTIL BE<>' ';
                  If not (BE in ['B','E']) then begin 
                     writeln('Selected output, Pos1, B/E Error!':35);
                     Gerror; end;
                  If BE='B' then i1 := 0 else i1 := 1; 
                  For j := 1 to 14 do read(f,Dum); end; 
                If not (PL in ['P','L']) then begin
                   writeln('Selected output,Pos 1, P/L Error!':35); end;
              end; {'S'}
         'D': begin Znr := ReadZ2(f); read(f,PLdum); PL := 'X';
              If PLdum in ['1'..'9'] then begin PL := 'L';
                 Sid := ord(PLdum)-48+10*Znr; p1 := Supek[Sid];
                 If (p1<1) or (p1>Sumax) then begin 
                 writeln('Selected output, Pos 1, Subnet Error!':37); 
	         Gerror; end;
                 read(f,i1);
                 REPEAT read(f,Dum); UNTIL Dum<>' '; end;
              If Pldum=' ' then begin PL := 'P';
                 read(f,Snr); IdNr := Snr+100*Znr;
                 p1 := Pipek[IdNr];
                 If (p1<1) or (p1>Pimax) then begin 
                    writeln('Selected output, Pos 1, Pipe Error!':36); 
                    Gerror; end;
                 REPEAT read(f,BE); UNTIL BE<>' ';
                 If not (BE in ['B','E']) then begin 
                    writeln('Selected output, Pos 1, B/E Error!':35);
                    Gerror; end;
                 If BE='B' then i1 := 0 else i1 := 1; end;
              If not (PL in ['P','L']) then begin
                 writeln('Pos 1, P/L Error!':30); Gerror; end;
              Znr := ReadZ2(f); read(f,PLdum); PL := 'X';
              If PLdum in ['1'..'9'] then begin PL := 'L';
                 Sid := ord(PLdum)-48+10*Znr; p2 := Supek[Sid];
                 If (p2<1) or (p2>Sumax) then begin 
                    writeln('Selected output, Pos 2, Subnet Error!':37); 
                    Gerror; end;
                 read(f,i2); 
                 REPEAT read(f,Dum); UNTIL Dum<>' '; end;           
              If Pldum=' ' then begin PL := 'P';
                 read(f,Snr); IdNr := Snr+100*Znr;
                 p2 := Pipek[IdNr];
                 If (p2<1) or (p2>Pimax) then begin 
                    writeln('Selected output, Pos 2, Pipe Error!':36); 
                    Gerror; end;
                 REPEAT read(f,BE); UNTIL BE<>' ';
                 If not (BE in ['B','E']) then begin 
                    writeln('Selected output, Pos 2, B/E Error!':35); 
                    Gerror; end;
                 If BE='B' then i2 := 0 else i2 := 1; end;
              If not (PL in ['P','L']) then begin
                 writeln('Selected output, Pos 2, P/L Error!':35); 
                 Gerror; end;
              end; {'D'}
         END; {Case SD}
         For j := 1 to 30 do Com[j] := ' '; j := 1;
         REPEAT read(f,Com[j]); UNTIL Com[j]<>' '; 
         WHILE ((not eoln(f)) and (j<30)) do begin
          j := j+1; read(f,Com[j]); end;
         end; {With} readln(f); Red; read(f,ch); end; {WHILE ch}
        Outmax := i; close(f); SeldataFlag := true;
      end;      
     END; {Seldata}
     
    PROCEDURE Selout;
     VAR i,Dec : integer;
         Calc,Qli : real;
         Cunit : packed array[1..4] of char;  
     BEGIN
      Aclear; write('SELECTED OUTPUT DATA':32); 
      If not ConvFlag then write('M = Itermax!!!    WARNING ONLY!':40);
      writeln; writeln;
      For i := 1 to Outmax do begin With OutPost[i] do begin
          If PL='P' then
             CASE Cnr OF
              1:begin Calc := Ht[p1,i1]; Dec := 1;                  {H}
                      Cunit := 'mLc '; end; 
              2:begin Calc := Ht[p1,i1]-Ht[p2,i2]; Dec := 1;        {DH}
                      Cunit := 'mLc '; end;   
              3:begin Calc := Qt[p1,i1]; Dec := 4;                  {Q}
                      Cunit := 'm3/s'; end;
              4:begin Calc := Qt[p1,i1]-Qt[p2,i2]; Dec := 4;        {DQ}
                      Cunit := 'm3/s'; end;   
              5:begin Calc := Tt[p1,i1]; Dec := 1;                  {T}
                      Cunit := 'oC  '; end;
              6:begin Calc := Tt[p1,i1]-Tt[p2,i2]; Dec := 1;        {DT}
                      Cunit := 'oC  '; end; 
              7:begin TempInit(Tt[p1,i1]); Dec := 0;                         {W } 
                      Calc := Ra*Csp*abs(Qt[p1,i1]*Tt[p1,i1]);
                      TempInit(Tinit); Cunit := 'kW  '; end;
              8:begin TempInit((Tt[p1,i1]+Tt[p2,i2])/2);            {DW} 
                      {Calc := abs(Qt[p1,i1]*Tt[p1,i1]);}
                      Calc := Qt[p1,i1]*Tt[p1,i1];
                      {Calc := Ra*Csp*(Calc-abs(Qt[p2,i2]*Tt[p2,i2]));}
                      Calc := Ra*Csp*(Calc-(Qt[p2,i2]*Tt[p2,i2]));
                      TempInit(Tinit); Dec := 0; Cunit := 'kW  '; end; 
            END; {Case Cnr}
          If PL='L' then
             CASE Cnr OF
              1:begin Calc := Crl*(Cpl[p1,i1]-Cml[p1,i1])/2;        {H}
                       Dec := 1; Cunit := 'mLc '; end;
              2:begin Calc := Crl*(Cpl[p1,i1]-Cml[p1,i1])/2;        {dH}
                      Calc := Calc-Crl*(Cpl[p2,i2]-Cml[p2,i2])/2;
                      Dec := 1; Cunit := 'mLc '; end;           
              3:begin Calc := (Cpl[p1,i1]+Cml[p1,i1])/2;            {Q}
                      Dec := 4; Cunit := 'm3/s'; end;
              4:begin Calc := (Cpl[p1,i1]+Cml[p1,i1])/2;            {dQ}
                      Calc := Calc-(Cpl[p2,i2]+Cml[p2,i2])/2;           
                      Dec := 4; Cunit := 'm3/s'; end;                 
              5:begin Calc := Tli[p1,i1]; Dec := 1;                 {T}
                      Cunit := 'oC  '; end;
              6:begin Calc := Tli[p1,i1]-Tli[p2,i2]; Dec := 1;      {DT}
                      Cunit := 'oC  '; end; 
              7:begin Qli := (Cpl[p1,i1]+Cml[p1,i1])/2;             {W}
                      TempInit(Tli[p1,i1]); Dec := 0;
                      Calc := Ra*Csp*abs(Qli*Tli[p1,i1]); 
                      TempInit(Tinit); Cunit := 'kW  '; end; 
              8:begin Qli := (Cpl[p1,i1]+Cml[p1,i1])/2;             {DW} 
                      TempInit((Tli[p1,i1]+Tli[p2,i2])/2);
                      {Calc := abs(Qli*Tli[p1,i1]);} 
                      Calc := Qli*Tli[p1,i1]; 
                      Qli := (Cpl[p2,i2]+Cml[p2,i2])/2; 
                      {Calc := Ra*Csp*(Calc-abs(Qli*Tli[p2,i2]));} 
                      Calc := Ra*Csp*(Calc-(Qli*Tli[p2,i2])); 
                      TempInit(Tinit); Dec := 0; Cunit := 'kW  '; end; 
              END; {Case Cnr}         
          writeln(i:3,Calc:12:Dec,Cunit:6,Com:35); 
       end; {With} end; {For} 
     END; {Selout}
     
     BEGIN {Seloutput}
      If Fmax=9 then begin Seldata;  
         If SeldataFlag then Selout; end
      else begin writeln; 
           writeln('The file *.sel is not declared in sf.ini!':50); end; 
     END; 
      
      PROCEDURE CalcuMenu;
       VAR ch : char;
       BEGIN
        Aclear; writeln(Mmenu); writeln(Dash);
        writeln; writeln;
        writeln(' ':14,'Calculate Steady Flow Distribution');
        writeln(' ':14,'----------------------------------');
        writeln;
        writeln(' ':14,'1 - Calculate Steady Flow Conditions');
        writeln(' ':14,'2 - Display Report of soft Alarms');
        writeln(' ':14,'3 - Examine Report of Max/Min-values ');
        writeln(' ':14,'4 - Read   *.dum, Steady Flow Dump File');
        writeln(' ':14,'5 - Update *.dum, Steady Flow Dump File');
        writeln(' ':14,'6 - Show current values of x1,x2,x3');
        writeln(' ':14,'7 - Show selected output data'); 
        writeln(' ':14,'0 - Return to Main Menu'); writeln;
        REPEAT
          write('Choice : ':14); read(ch); readln; ch := Uchar(ch);
        UNTIL (ord(ch)>47) and (ord(ch)<56) or (ch in MenuSet);
        If (ch in Menuset) then begin Choice := ch; Alt := 10; end
                           else begin Alt := ord(ch)-48; end;
        OldChoice := 'C';
       END;    {CalcuMenu}

     BEGIN  {Calculate}
       REPEAT  CalcuMenu; Dummy := 1; dTtFlag := false;
        CASE Alt OF
          0: begin Choice := 'X'; Dummy := 0; end;
          1: begin If OK(ConFlag) then begin Aclear; dTtFlag := true;
                      If ConvFlag then begin ManVaCtrl := 1; ManDrCtrl := 1; end;
                      Compute; Warning; end;
                   Stop; end;
          2: begin If OK(AlarmFlag) then begin Aclear; ListAlarms; end;
                   Stop; end;
          3: begin If OK(ConFlag) then begin Aclear; ListMaxMin; end;
                   end;
          4: begin If OK(ConFlag) then ReadDump;
                   Stop; end;
          5: begin If OK(ConFlag) then WriteDump;
                   Stop; end;
          6: begin If OK(SetFlag) then Xvalues; Stop; end;
          7: begin Seloutput; Stop; end; 
         10: begin Dummy := 0; end;
        END; {Case}
       UNTIL (Dummy=0);
     END; {Calculate}

  PROCEDURE PrintResults;
     VAR RwFlag,ZonFlag,AllFlag,NoFlag,PrFlag : Boolean;
         Alt : integer;
         f5 : text;

     PROCEDURE Header;
        VAR i : integer;
        BEGIN
          writeln(f5,Prog:24,'Edition':17,Ed:9); writeln(f5,Pro:50);
          writeln(f5,'=======================================':50);
          writeln(f5);
          For i := 1 to Idstrmax do writeln(f5,Idstr[i]:51); writeln(f5);
          writeln(f5,'Data: ':17,'Files':5,' ':maxCh1-5,'Case: ':10,SetCase:8);
          writeln(f5,'     ':17,Fil[1]:maxCh1,'x1 = ':10,x1:8:DecF(x1));
          writeln(f5,'     ':17,Fil[2]:maxCh1,'x2 = ':10,x2:8:DecF(x2));
          writeln(f5,'     ':17,'    ':maxCh1,'x3 = ':10,x3:8:DecF(x3));
          writeln(f5);
        END;   {Header}

     FUNCTION PrintFlag : Boolean;
        VAR ch : char;
        BEGIN
          writeln; write('Append results to : ':30,Fil[5]:maxCh1,'Y/N ':10);
          read(ch); readln; ch := Uchar(ch);
          If (ch='Y') then begin PrFlag := true; ZonFlag := false; end
             else PrFlag := false;
          If (not RwFlag) and PrFlag then begin
             Connect(f5,Fil[5],'W'); RwFlag := true; Header; end;
          PrintFlag := PrFlag;
        END; {PrintFlag}

     PROCEDURE PrintPipes (VAR f:text );
      VAR  p,k,Znr,Nr : integer;
           dH,La,dHdL,Nyt,Q,Tm : real;

      PROCEDURE HeadLine(VAR f:text);
       BEGIN
        write(f,'Pipe':11,' Flow':7,'   Hbeg':8,'  Hend ':7,' Temp ':7);
        writeln(f,' Vel':5,'dH/dL':6,'Lamda':7,'Comments':10);
        write(f,'ZnNr':11,' m3/s':7,'   m Lc':8,'  m Lc ':7,'  C   ':7);
        writeln(f,'m/s':5,'mLc/km':7,' -- ':6,' (text) ':10); writeln(f);
       END;
      BEGIN
       If not ZonFlag then begin writeln(f); writeln(f); end;         
       NoFlag := true; 
       write(f,'PIPES, STEADY FLOW CONDITIONS':40);
       If ZonFlag then Zstr else writeln(f);
       writeln(f); k := 1;
       For p := 1 to Pimax do begin  With PipePost[p] do begin
           Znr := Id div 100; Nr := Id mod 100;
           If AllFlag then Pflag := true else begin
              If Str[1]='+' then SeCom(Com,Str,Len)
                            else SeZon(IdS2(Znr),Str,Len); end;
           If Pflag then begin
              If NoFlag then begin HeadLine(f); NoFlag := false; end;
              dH := abs(Ht[p,0]-Ht[p,1]); dHdL := 1000*dH/L;
              Tm := (Tt[p,0]+Tt[p,1])/2; Nyt := Viscosity(Tm);
              Q := (Qt[p,0]+Qt[p,1])/2;
              La := Lamda(Q/Api[p],Nyt,D,Ks);
              write(f,IdS2(Znr):9,NrS2(Nr):2);
              write(f,Q:8:4,Ht[p,0]:7:1,Ht[p,1]:7:1);
              writeln(f,Tm:6:1,Q/Api[p]:6:1,dHdL:6:1,La:7:3,Com:14);
              k := k+1;
              If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                 then begin Paus; HeadLine(f); k := 1; end;
              end; end; end;
       If NoFlag then writeln(f,'No Results to Print!':36);
       flush(f);
      END;   { PrintPipes }

     PROCEDURE PrintConns (VAR f:text);
      CONST maxPek = maxSu*maxLcn;
      VAR Cn,Nr,s,c,Va,Vr,k,Znr,Num,z,Zon,Comax,Lcomax,i : integer;
          H1,H2,dH,Qc,Avcn,Q1,Q2,Avlc,Fiv,Pkw : real;
          NodPek : array[1..maxCn] of integer;
          Snet : array[1..maxSu] of integer;
          Cpek : array[1..maxPek] of integer;
   
     PROCEDURE HeadLine(VAR f:text);
      BEGIN
       write(f,'Conn    Qconn   H to  H fr   dH      Av':46);
       writeln(f,'Heat':9,'Comments':11);
       write(f,'Zn Nr   m3/s    m Lc  m Lc   mLc     m2':46);
       writeln(f,' kW ':9,' (text) ':11); writeln(f);
      END;
       
      BEGIN
       If not ZonFlag then begin writeln(f); writeln(f); end;
       write(f,'PIPE/LINK CONNECTIONS, STEADY FLOW':45);
       If ZonFlag then Zstr else writeln(f);
       writeln(f); Num := 0;
       For Cn := 1 to Cnmax do begin With CnPost[Cn] do begin
           Znr := Id div 100; Nr := Id mod 100;
           If AllFlag then Pflag := true else begin
              If Str[1]='+' then SeCom(Com,Str,Len)
                            else SeZon(IdS2(Znr),Str,Len); end;
              If Pflag then begin Num := Num+1;
                 NodPek[Num] := Cn; end;  
           end; end;
       Comax := Num; Num := 0;
       For s := 1 to Sumax do begin
           Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
           For c := 1 to Lcnmax[s] do begin
               With LcnPost[s,c] do begin
               If Allflag then Pflag := true else begin
	          If Str[1]='+' then SeCom(Com,Str,Len)
                                else SeZon(IdS2(Znr),Str,Len); end;
               If Pflag then begin Num := Num+1;
                  Snet[Num] := s; Cpek[Num] := c; end; 
           end; end; end;        
       Lcomax := Num;
       If (Comax+Lcomax)>0 then begin Headline(f); k := 1; end;
       For z := 1 to Zonmax do begin Zon := ZonId[z];   
           For c := 1 to Comax do begin i := NodPek[c];
           With CnPost[i] do begin
           Znr := Id div 100; Nr := Id mod 100;
           If (Zon=Znr) then begin               
              Qc := (Qt[Pfr,0]+Qt[Pto,1])/2;
              H1 := Ht[Pto,1]; H2 := Ht[Pfr,0];
              dH := H1-H2; Pkw := 0;
              TempInit((Tt[Pto,1]+Tt[Pfr,0])/2);
              CASE Ecod OF
  1,2,4,6,13,14 : begin If (abs(dH)<Epsi) then Avcn := 9.99999
                           else Avcn := abs(Qc)/sqrt(g*abs(dH)); end;
             11 : begin If (abs(dH)<Epsi) then Avcn := 9.99999
                        else Avcn := dH/abs(dH)*abs(Qc)/sqrt(g*abs(dH)); end;
             10 : begin Va := Vapek[Enr]; Vr := VrefPost[Va].Vref;
                        Vr := VaPerfPek[Vr]; Fiv := VrefPost[Va].Fi;
                        If Qc>0 then Avcn := Fiv*ValvePerf[Vr].Avp
                                else Avcn := Fiv*ValvePerf[Vr].Avm; end;
              7 : begin If (dH<Epsi) then Avcn := 0
                                     else Avcn := Value; end;
              8 : begin Avcn := Value; end;
              9 : begin If (dH<Epsi) then Avcn := 0
                                     else Avcn := Qc/sqrt(g*dH); end;
            3,5 : begin If (abs(dH)<Epsi) then Avcn := 9.99999
                              else Avcn := abs(Qc)/sqrt(g*abs(dH));
                           Pkw := Qc*Ra*Csp*(Tt[Pfr,0]-Tt[Pto,1]); end;
             12 : begin If abs(Qc)<Epsi then Avcn := 0
                           else Avcn := Boiler[Enr].Avres;
                        Pkw := Qc*abs(Tt[Pfr,0]-Tt[Pto,1]);
                        Pkw := Boiler[Enr].RaCsp*Pkw; end;
              END;
              write(f,IdS2(Znr):8,NrS2(Nr):4,Qc:8:4,H1:7:1,H2:7:1,dH:6:1);
              writeln(f,Avcn:9:5,round(Pkw):8,Com:14); k := k+1;
              If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                  then begin Paus; HeadLine(f); k := 1; end;
              end; end; end; {For c}
           For i := 1 to Lcomax do begin s := Snet[i];
               Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
               If (Zon=Znr) then begin c := Cpek[i];         
                  With LcnPost[s,c] do begin
                  Q1 := (Cpl[s,Lto]+Cml[s,Lto])/2;
                  Q2 := (Cpl[s,Lfr]+Cml[s,Lfr])/2; Qc := (Q1+Q2)/2;
                  H1 := Crl*(Cpl[s,Lto]-Cml[s,Lto])/2;
                  H2 := Crl*(Cpl[s,Lfr]-Cml[s,Lfr])/2;
                  dH := H1-H2; Pkw := 0;
                  TempInit((Tli[s,Lto]+Tli[s,Lfr])/2);
                  CASE Ecod OF
      1,2,4,6,13,14 : begin If abs(dH)<Epsi then Avlc := 9.99999
                            else Avlc := abs(Qc)/sqrt(g*abs(dH)); end;
                  9 : begin If (dH<Epsi) then Avlc := 0
                                         else Avlc := Qc/sqrt(g*dH); end;
                 11 : begin If abs(dH)<Epsi then Avlc := 9.99999
                            else Avlc := dH/abs(dH)*abs(Qc)/sqrt(g*abs(dH)); end;
                 10 : begin Va := Vapek[Enr]; Vr := VrefPost[Va].Vref;
                            Vr := VaPerfPek[Vr]; Fiv := VrefPost[Va].Fi;
                            If Qc>0 then Avlc := Fiv*ValvePerf[Vr].Avp
                                    else Avlc := Fiv*ValvePerf[Vr].Avm; end;
                  7 : begin If (dH<Epsi) then Avlc := 0
                                         else Avlc := Value; end;	
                  8 : begin Avlc := Value; end;
                3,5 : begin If abs(dH)<Epsi then Avlc := 9.99999
                              else Avlc := abs(Qc)/sqrt(g*abs(dH));
                            Pkw := Qc*Ra*Csp*(Tli[s,Lfr]-Tli[s,Lto]); end;
                 12 : begin If abs(Qc)<Epsi then Avlc := 0
                               else Avlc := Boiler[Enr].Avres;
                            Pkw := Qc*abs(Tli[s,Lfr]-Tli[s,Lto]);
                            Pkw := Boiler[Enr].RaCsp*Pkw; end;
                  END;
                  write(f,IdS2(Znr):8,Nr:1,NrS2(Id):3,Qc:8:4,H1:7:1,H2:7:1);
                  writeln(f,dH:6:1,Avlc:9:5,round(Pkw):8,Com:14); k := k+1;
                  If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                     then begin Paus; HeadLine(f); k := 1; end;
              end; end; end; {For i} end; {For z}
         TempInit(Tinit);
         If (Comax+Lcomax)=0 then writeln(f,'No Results to Print!':36);
         flush(f);  
       END;  { PrintConns }

     PROCEDURE PrintCross (VAR f:text);
      CONST maxPek = maxSu*maxLcs;             
      VAR i,Nr,s,c,Va,Vr,Pkw,k,Znr,Num,Zon,z,Crmax,Lcrmax : integer;
          Avcross : real;
          NodPek : array[1..maxCs] of integer;
          Snet : array[1..maxSu] of integer;
          Cpek : array[1..maxPek] of integer;
         
      PROCEDURE HeadLine(VAR f:text);
       BEGIN
        write(f,'Cross  Qcross   Tfor   dT    Hfor   dH  Av/Avmax':55);
        writeln(f,'Heat':6,'Comments':10);
        write(f,'Zn Nr   m3/s    Cels  Cels   m Lc  m Lc   ----  ':55);
        writeln(f,' kW ':6,' (text) ':10); writeln(f);
       END;
      
      BEGIN
       If not ZonFlag then begin writeln(f); writeln(f); end;
       write(f,'PIPE/LINK CROSS CONNECTIONS, STEADY FLOW':51);
       If ZonFlag then Zstr else writeln(f);
       writeln(f); Num := 0;
       For c := 1 to Csmax do begin With CsPost[c] do begin
           Znr := Id div 100; Nr := Id mod 100;
           If Allflag then Pflag := true else begin
              If Str[1]='+' then SeCom(Com,Str,Len)
                            else SeZon(IdS2(Znr),Str,Len); end;
           If Pflag then begin Num := Num+1;
              NodPek[Num] := c; end;
       end; end;             
       Crmax := Num; Num := 0;
       For s := 1 to Sumax do
           For c := 1 to Lcsmax[s] do begin With LcsPost[s,c] do begin
               If AllFlag then Pflag := true else begin
                  If Str[1]='+' then SeCom(Com,Str,Len)
                                else SeZon(IdS2(Znr),Str,Len); end; 
               If Pflag then begin Num := Num+1;
                  Snet[Num] := s; Cpek[Num] := c; end;
           end; end;
        Lcrmax := Num;   
        If (Crmax+Lcrmax)>0 then begin HeadLine(f); k := 1; end;
        For z := 1 to Zonmax do begin Zon := ZonId[z];   
            For i := 1 to Crmax do begin c := NodPek[i];
            With CsPost[c] do begin
            Znr := Id div 100; Nr := Id mod 100;
            If (Zon=Znr) then begin               
               If (Vnr=0) and (Qcs>0) then Pkw := round(RaCsp*Qcs*abs(Tf-Tr))
                                      else Pkw := 0;
               If (Vnr=0) and (Qcs<Ql) then Avcross := Avmax
                  else If abs(Hf-Hr)>Epsi then Avcross := Qcs/sqrt(g*abs(Hf-Hr))
                                          else Avcross := 0;
               If Vnr>0 then begin Va := Vapek[Vnr]; Vr := VrefPost[Va].Vref;
                  Vr := VaPerfPek[Vr]; Avmax := ValvePerf[Vr].Avp; end;
               write(f,IdS2(Znr):8,NrS2(Nr):4,Qcs:8:4,Tf:7:1,abs(Tf-Tr):6:1,Hf:7:1);
               writeln(f,(Hf-Hr):6:1,Avcross/Avmax:7:2,PkW:8,Com:14);
               k := k+1;
               If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                   then begin Paus; HeadLine(f); k := 1; end;
             end; end; end;
            For i := 1 to Lcrmax do begin s := Snet[i];
                Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                If (Zon=Znr) then begin
                   c := Cpek[i]; With LcsPost[s,c] do begin 
                   If Vnr=0 then Pkw := round(RaCsp*Qcs*abs(Tf-Tr))
                            else Pkw := 0;
                   If (Vnr=0) and (Qcs<Ql) then Avcross := Avmax
                      else If abs(Hf-Hr)>Epsi then Avcross := Qcs/sqrt(g*abs(Hf-Hr))
                                              else Avcross := 0;
                   If Vnr>0 then begin Va := Vapek[Vnr]; Vr := VrefPost[Va].Vref;
                      Vr := VaPerfPek[Vr]; Avmax := ValvePerf[Vr].Avp; end;
                   write(f,IdS2(Znr):8,Nr:1,NrS2(Id):3,Qcs:8:4,Tf:7:1,abs(Tf-Tr):6:1);
                   writeln(f,Hf:7:1,(Hf-Hr):6:1,Avcross/Avmax:7:2,Pkw:8,Com:14);
                   k := k+1;
                   If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                      then begin Paus; HeadLine(f); k := 1; end;
            end; end; end; {For i}
        end; {For z}
        If (Crmax+Lcrmax)=0 then writeln(f,'No Results to Print!':36);
        flush(f);  
       END;  { PrintCross }

     PROCEDURE PrintLinks (VAR f:text);
      VAR  Qli,Hli : real;
           s,l,Nr,i,k,Lx,Znr,Num,Linemax : integer;
           Comm : packed array[1..12] of char;
           Spek : array[1..maxSu] of integer;
    
      PROCEDURE HeadLine(VAR f:text);
       BEGIN
        writeln(f,'Sub':10,'Link':5,'Head':8,'Flow':8,'Temp':9,'Comments':12);
        writeln(f,' Nr':10,' Nr ':5,'m Lc':8,'m3/s':8,' C  ':9,' (text) ':12);
        writeln(f);
       END;
      
      BEGIN
       If not ZonFlag then begin writeln(f); writeln(f); end;
       If ZonFlag then begin 
          write(f,'LINKS, STEADY FLOW CONDITIONS':40);
          Zstr; Num := 0; Linemax := 0; writeln(f);      
          For s :=1 to Sumax do begin 
              Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
              SeZon(IdS2(Znr),Str,Len);
              If Pflag then begin Num := Num+1; Spek[Num] := s;
                 writeln(f,Num:8,':':1,'Subnet':9,IdS2(Znr):3,Nr:1); end; 
              end; LineMax := Num;
          If Linemax=0 then begin Aclear; 
             writeln(f,'LINKS, STEADY FLOW CONDITIONS':40); writeln(f);
             writeln(f,'No Links to print!':30); Alt := 0; end;
          If Linemax>0 then begin Alt := 0; writeln(f);
             writeln(f,'Select Line, 0 for Exit':37);     
             Alt := LineNr(Linemax); end;
          If Alt>0 then Alt := Spek[Alt] else Alt := 0; end;
       If (Alt>0) and (not AllFlag) then begin Aclear; 
          writeln(f,'LINKS, !STEADY FLOW CONDITIONS':40);
          writeln(f); HeadLine(f); k := 1; s := Alt;
          For Lx := 1 to Limax[s] do begin l := Lipek[s,Lx];
              For i := 1 to 12 do Comm[i] := '.';
              For i := 1 to Brmax[s] do
                  If l=abs(BorPost[s,i].Li) then Comm := BorPost[s,i].Com;
              For i := 1 to Liomax[s] do
                  If l=LioPost[s,i].Li then Comm := LioPost[s,i].Com;
              Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
              Hli := Crl*(Cpl[s,l]-Cml[s,l])/2;
              Qli := (Cpl[s,l]+Cml[s,l])/2;
              write(f,IdS2(Znr):9,Nr:1,NrS2(l):4,Hli:9:1,Qli:9:4);
              writeln(f,Tli[s,l]:8:1,Comm:15); k := k+1;
              If ((k mod ContLines)=0) then begin
                   Paus; HeadLine(f); k := 1; end;
          end; end;  
       If AllFlag then begin NoFlag := true; 
          writeln(f,'LINKS, STEADY FLOW CONDITIONS':40); writeln(f); 
          For s := 1 to Sumax do begin
              For Lx := 1 to Limax[s] do begin l := Lipek[s,Lx];
                  For i := 1 to 12 do Comm[i] := '.';
                  For i := 1 to Brmax[s] do
                      If l=abs(BorPost[s,i].Li) then Comm := BorPost[s,i].Com;
                  For i := 1 to Liomax[s] do
                      If l=LioPost[s,i].Li then Comm := LioPost[s,i].Com;
                  Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
                  If NoFlag then begin HeadLine(f); NoFlag := false; end;
                  Hli := Crl*(Cpl[s,l]-Cml[s,l])/2;
                  Qli := (Cpl[s,l]+Cml[s,l])/2;
                  write(f,IdS2(Znr):9,Nr:1,NrS2(l):4,Hli:9:1,Qli:9:4);
                  writeln(f,Tli[s,l]:8:1,Comm:15);
              end; end; 
          If NoFlag then writeln(f,'No Results to Print!':36); end;
         flush(f);  
       END;  { PrintLinks }

     PROCEDURE PrintValves (VAR f:text);
      VAR  Ava,dH,Qch,dHcav : real;
           i,Nr,Vr,k,Znr : integer;
      PROCEDURE HeadLine(VAR f:text);
       BEGIN
        write(f,'Valve  -S-    Fi     Av     Flow    dH    Fl   Q/Qch':59);
        writeln(f,'Comments':10);
        write(f,'ZnNr   ---    --     m2     m3/s   m Lq   --    --- ':59);
        writeln(f,' (text) ':10); writeln(f);
       END;
      BEGIN
       If not ZonFlag then begin writeln(f); writeln(f); end;       
       NoFlag := true; 
       write(f,'VALVES, STEADY FLOW CONDITIONS':41);
       If ZonFlag then Zstr else writeln(f);
       writeln(f); k := 1;
       For i := 1 to Vamax do begin With VrefPost[i] do begin
           Znr := Id div 100; Nr := Id mod 100;
           If AllFlag then Pflag := true else begin
              If Str[1]='+' then SeCom(Com,Str,Len)
                            else SeZon(IdS2(Znr),Str,Len); end;
           If Pflag then begin
              If NoFlag then begin HeadLine(f); NoFlag := false; end;
              Vr := VaPerfPek[Vref];
              If Qvt[i]>0 then begin Ava := Fi*ValvePerf[Vr].Avp;
                 dHcav := H1vt[i]-Hch;
                 Qch := Fl*Ava*sqrt(g*abs(dHcav)); end
              else begin Ava := Fi*ValvePerf[Vr].Avm;
                   dHcav := H2vt[i]-Hch;
                   Qch := Fl*Ava*sqrt(g*abs(dHcav)); end;
              If abs(Qch)>Epsi then Qch := abs(Qvt[i]/Qch)
                               else Qch := 0;
              If dHcav<0 then Qch := 1;
              dH := abs(H1vt[i]-H2vt[i]);
              write(f,IdS2(Znr):9,NrS2(Nr):2,S:7:3,Fi:6:2,Ava:8:4,Qvt[i]:8:4);
              writeln(f,dH:6:1,Fl:6:2,Qch:6:2,Com:15);
              k := k+1;
              If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                 then begin Paus; HeadLine(f); k := 1; end;
       end; end; end;
       If NoFlag then writeln(f,'No Results to Print!':36);
       flush(f);  
       END;   {PrintValves}

     PROCEDURE PrintPumps (VAR f:text);
      VAR Pu,Pnr,i,Dr,Idp,k,Pr,Znr : integer;
          Hpt,Ppt,Nht,dHcav,Npu,Eta,Paxel,Pmotor,Pel,Etr,Emo,Edr,Fi,D2x : real;

      PROCEDURE HeadLine1(VAR f:text);
       BEGIN
        write(f,'Pump  Npump  Flow  Hpump  Ppump  Eta   Hinl  dHcav':57);
        writeln(f,'  Fi ','Comments':10);
        write(f,'ZnNr   rpm   m3/s   m Lc    kW   ---   m Lc  m Lc ':57);
        writeln(f,'  -- ',' (text) ':10); writeln(f);
       END;

      PROCEDURE HeadLine2(VAR f:text);
       BEGIN
        write(f,'Drive  Pel  Emotor Evar Edrive Pshaft  Nmot   -N- ':57);
        writeln(f,'Comments':10);
        write(f,'ZnNr   kW    ---    --   ---     kW     rpm   --- ':57);
        writeln(f,' (text) ':10); writeln(f);
       END;

      BEGIN
       If not ZonFlag then begin writeln(f); writeln(f); end;
       NoFlag := true; 
       write(f,'PUMPS, STEADY FLOW CONDITIONS':40);
       If ZonFlag then Zstr else writeln(f);
       writeln(f); k := 1;
       For Pu := 1 to Pumax do begin 
           Pnr := PrefPost[Pu].Id; Znr := Pnr div 100;
           If AllFlag then Pflag := true else begin
              If Str[1]='+' then SeCom(PrefPost[Pu].Com,Str,Len)
                            else SeZon(IdS2(Znr),Str,Len); end; 
           If Pflag then begin
              If NoFlag then begin HeadLine1(f); NoFlag := false; end;
              Npu := PrefPost[Pu].Np;
              Hpt := PumpHp(Pnr,Npu,Qpt[Pu]);
              Ppt := PumpMp(Pnr,Npu,Qpt[Pu])*Pii*Npu/30/1000;
              Nht := PumpNh(Pnr,Npu,Qpt[Pu]);
              If abs(Ppt)<0.1 then Eta := 0.0
                 else Eta := Ra*Qpt[Pu]*g*Hpt/Ppt/1000;
              Tempinit(Tpt[Pu]);
              dHcav := H1pt[Pu]+Hatm-PrefPost[Pu].Zp-Hvap-Nht;
              Tempinit(Tinit);
              D2x := PrefPost[Pu].DIx;
              Pr := PrefPost[Pu].Pref; Pr := PuNomPek[Pr];
              If abs(Npu)>10 then
                 Fi := PumpNom[Pr].Nnom/Npu*Qpt[Pu]/PumpNom[Pr].Qnom/sqr(D2x)
               else Fi := 0.0;
              write(f,IdS2(Znr):9,NrS2(Pnr mod 100):2,round(PrefPost[Pu].Np):6);
              write(f,Qpt[Pu]:8:4,Hpt:6:1,Ppt:7:1);
              write(f,Eta:5:2,H1pt[Pu]:7:1,dHcav:7:1,Fi:6:2);
              writeln(f,PrefPost[Pu].Com:14);
              k := k+1;
              If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                 then begin Paus; HeadLine1(f); k := 1; end;
         end; end;
       If ((not PrFlag) and (not AllFlag) and (not NoFlag)) then
          begin writeln(f); Paus; end;
       NoFlag := true; k := 1;
       If PrFlag or AllFlag then writeln(f);
       For i := 1 to Drmax do begin With DrivePost[i] do begin
           Znr := Id div 100;
           If AllFlag then Pflag := true else begin
              If Str[1]='+' then SeCom(Com,Str,Len)
                            else SeZon(IdS2(Znr),Str,Len); end; 
           If Pflag then begin
              If NoFlag then begin HeadLine2(f); NoFlag := false; end;
              Paxel := 0;
              For Pu := 1 to Pumax do begin
                  Dr := Drpek[PrefPost[Pu].DrId];
                  If (Dr=i) then begin Idp := PrefPost[Pu].Id;
                     Paxel := Paxel+ PumpMp(Idp,Ndr,Qpt[Pu])*Pii*Ndr/30/1000;
                  end; end;
              Etr := Etrans(Ndr/Nmot,i);
              If (abs(Paxel)>Epsi) then Pmotor := Paxel/Etr
                                   else Pmotor := 0;
              Emo := Emotor(Pmotor/Pmot,i);
              Pel := Pmotor/Emo; Edr := Emo*Etr;
              write(f,IdS2(Znr):9,NrS2(Id mod 100):2,Pel:7:1,Emo:6:2,Etr:6:2,Edr:6:2);
              writeln(f,Paxel:8:1,round(Nmot):6,Ndr/Nmot:7:3,Com:14);
              k := k+1;
              If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                 then begin Paus; HeadLine2(f); k := 1; end;
          end; end; end;
       If NoFlag then writeln(f,'No Results to Print!':36);
       flush(f);  
       END;  { PrintPumps }
     
  PROCEDURE PrintHexBo; 

   PROCEDURE PrintBoils (VAR f:text);
     VAR  Bo,Bnr,Cn,s,c,k,Znr,Nr : integer;
          Podr,Qbo,Qbp,Avtot : real;
          dT,dH,Qb,T1,T2 : array[1..maxBoil] of real;
          NoFlag : Boolean;

     PROCEDURE HeadLine(VAR f:text);
      BEGIN
       write(f,'Boiler  Power  Tinl  Tout  Qboil    Qb-p    dH    Av':59);
       writeln(f,'Comments':13);
       write(f,' ZnNr    kW     C     C     m3/s    m3/s   m Lc   m2':59);
       writeln(f,' (text) ':13); writeln(f);
      END;

     BEGIN
      If not ZonFlag then begin writeln(f); writeln(f); end;        
      NoFlag := true; 
      write(f,'BOILER/HEATER/COOLER, STEADY FLOW':44);
      If ZonFlag then Zstr else writeln(f);
      writeln(f); k := 1;
      For Cn := 1 to Cnmax do begin  With CnPost[Cn] do begin
          If (Ecod=12) then begin Bo := Enr;
             T1[Bo] := Tt[Pto,1]; T2[Bo] := Tt[Pfr,0];
             dT[Bo] := Tt[Pfr,0]-Tt[Pto,1];
             Qb[Bo] := (Qt[Pto,1]+Qt[Pfr,0])/2;
             dH[Bo] := Ht[Pto,1]-Ht[Pfr,0]; end; end; end;
      For s := 1 to Sumax do begin
          For c := 1 to Lcnmax[s] do begin With LcnPost[s,c] do begin
              If (Ecod=12) then begin Bo := Enr;
                 T1[Bo] := Tli[s,Lto]; T2[Bo] := Tli[s,Lfr];
                 dT[Bo] := Tli[s,Lfr]-Tli[s,Lto];
                 Qb[Bo] := (Cpl[s,Lfr]+Cml[s,Lfr]+Cpl[s,Lto]+Cml[s,Lto])/4;
                 dH[Bo] := Cpl[s,Lto]-Cml[s,Lto]-Cpl[s,Lfr]+Cml[s,Lfr];
                 dH[Bo] := Crl*dH[Bo]/2; end; end; end; end;
      For Bo := 1 to Boilmax do begin Bnr := Boiler[Bo].Id;
          Znr := Bnr div 100; Nr := Bnr mod 100;
          If AllFlag then Pflag := true else begin
             If Str[1]='+' then SeCom(Boiler[Bo].Com,Str,Len)
                               else SeZon(IdS2(Znr),Str,Len); end;
          If Pflag then begin
             If NoFlag then begin HeadLine(f); NoFlag := false; end;
             Podr := Boiler[Bo].RaCsp*Qb[Bo]*dT[Bo];
             Qbo := Boiler[Bo].Qbt; Qbp := Qb[Bo]-Qbo;
             If abs(Qb[Bo])<Epsi then Avtot := 0
                                 else Avtot := Boiler[Bo].Avres;
             write(f,IdS2(Znr):10,NrS2(Nr):2,round(abs(Podr)):8,T1[Bo]:6:1);
             write(f,T2[Bo]:6:1,Qbo:8:4,Qbp:8:4,dH[Bo]:6:1);
             writeln(f,Avtot:8:4,Boiler[Bo].Com:14);
             k := k+1;
             If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                 then begin Paus; HeadLine(f); k := 1; end;
          end; end;
       If (NoFlag) then writeln(f,'No Results to Print!':36);
      flush(f); 
    END;   {PrintBoils}
       
    PROCEDURE PrintHex(VAR f:text);
     VAR e,Znr,Nr,k,s : integer;
         Podr,Qp,Qs : real;
         NoFlag : Boolean;
     
     PROCEDURE HeadLine(VAR f:text);
      BEGIN
       write(f,'HeatEx Power  Primary.....circuit  Secondary...circuit':61);
       writeln(f,'Comments':10);
       write(f,'Zn Nr   kW     Tto   Tfr    m3/s    Tto   Tfr    m3/s ':61);
       writeln(f,' (text) ':10); writeln(f);
      END;
      
     BEGIN {PrintHex}
      If not ZonFlag then begin writeln(f); writeln(f); end;             
      write(f,'HEAT EXCHANGERS, STEADY FLOW':39);
      If ZonFlag then Zstr else writeln(f);
      NoFlag := true; k := 1; writeln(f);
      For e := 1 to Exmax do begin With ExPost[e] do begin
          Znr := Id div 100; Nr := Id mod 100;
          If AllFlag then Pflag := true else begin
             If Str[1]='+' then SeCom(Com,Str,Len)
                           else SeZon(IdS2(Znr),Str,Len); end;
          If Pflag then begin
             If ((not PrFlag) and (not AllFlag) and (not NoFlag)
                and (not NoFlag)) then begin Paus; end;
             If NoFlag then begin writeln(f); HeadLine(f);
                        NoFlag := false; end;
             TempInit((Tt[pTo,1]+Tt[pFr,0])/2);
             Podr := Ra*Csp*(Tt[pTo,1]-Tt[pFr,0])*Qt[pTo,1];
             TempInit(Tinit);
             write(f,IdS2(Znr):8,NrS2(Id mod 100):4,round(Podr):7,Tt[pTo,1]:7:1);
             write(f,Tt[pFr,0]:6:1,Qt[pTo,1]:8:4,Tt[sTo,1]:7:1);
             writeln(f,Tt[sFr,0]:6:1,Qt[sTo,1]:8:4,Com:14);
             k := k+1;
             If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                 then begin Paus; HeadLine(f); k := 1; end;
      end; end; end; {For e}
      For s := 1 to Sumax do
          For e := 1 to Lexmax[s] do begin With LexPost[s,e] do begin
              Znr := SubId[s] div 10; Nr := SubId[s] mod 10;
              If AllFlag then Pflag := true else begin
                 If Str[1]='+' then SeCom(Com,Str,Len)
                               else SeZon(IdS2(Znr),Str,Len); end;
              If Pflag then begin
                 If ((not PrFlag) and (not AllFlag) and (not NoFlag)
                    and (NoFlag)) then Paus;
                 If NoFlag then begin writeln(f); HeadLine(f);
                            NoFlag := false; end;
                 Qp := (Cpl[s,pTo]+Cml[s,pTo]+Cpl[s,pFr]+Cml[s,pFr])/4;
                 Qs := (Cpl[s,sTo]+Cml[s,sTo]+Cpl[s,sFr]+Cml[s,sFr])/4;
                 TempInit((Tli[s,pTo]+Tli[s,pFr])/2);
                 Podr := Ra*Csp*(Tli[s,pTo]-Tli[s,pFr])*Qp;
                 TempInit(Tinit);
                 write(f,IdS2(Znr):8,Nr:1,NrS3(eNr):3,round(Podr):7);
                 write(f,Tli[s,pTo]:7:1,Tli[s,pFr]:6:1,Qp:8:4);
                 writeln(f,Tli[s,sTo]:7:1,Tli[s,sFr]:6:1,Qs:8:4,Com:14);
                 k := k+1;
                 If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                    then begin Paus; HeadLine(f); k := 1; end;
          end; end; end; {For e}
      If (NoFlag) then writeln(f,'No Results to Print!':36); 
      flush(f); 
     END; {PrintHex}
       
     PROCEDURE HexBomenu;
      BEGIN
       writeln('BOILERS and HEAT EXCHANGERS':38); writeln;
       writeln('1:  Boiler, Heater, Cooler     ':38);
       writeln('2:  Heat Exchanger             ':38);
       writeln; writeln('Select Line, 0 for exit':40);
       Alt := LineNr(2);
      END; {HexBomenu}

     BEGIN {PrintHexBo}
      If AllFlag then begin PrintBoils(f5); PrintHex(f5); end
      else REPEAT HexBomenu; Dummy := 1;
           CASE Alt OF
           0: begin Aclear; Dummy := 0; end;
           1: begin Aclear; PrintBoils(output); 
                    If PrintFlag then PrintBoils(f5); Aclear; end;
           2: begin Aclear; PrintHex(output); 
                    If PrintFlag then PrintHex(f5); Aclear; end;
          END; {Case Alt}
          UNTIL (Dummy=0);
     END; {PrintHexBo} 
     
    PROCEDURE PrintOverall; 
     
     PROCEDURE HeadBalance (VAR f:text);
      VAR i,z,s,p,Bo,Dr,Pu,Idp,k,Znr : integer;
          Ppipe,Pcross,Pmiscm,Pmiscp,Phyd,Ppump,Paxel,Etr,Emo,Pel,
          dH,Hp,Q,Q1,Q2,H1,H2,Hbal,H : real;
          Ppi,Pcs,Pmim,Pmip,Phy,Ppu,Pe : array[1..maxZon] of real;
  
       PROCEDURE HeadLine(VAR f:text);
         BEGIN
           write(f,'Zon   Pipes   Cross   Misc    ..   Misc   Pumps ':55);
           writeln(f,'Pumps    Motor ':18);
           write(f,' -    Hyd kW  Hyd kW  Hyd kW  ..  Hyd kW  Hyd kW':55);
           writeln(f,'Shaft kW El kW ':18); writeln(f);
         END;
      
      BEGIN
         For z := 1 to Zonmax do begin 
             Ppi[z] := 0; Pcs[z] := 0; Pmip[z] := 0; Phy[z] := 0;
             Ppu[z] := 0; Pe[z] := 0; Pmim[z] := 0; end;
         Hbal := Hinit; 
         For i := 1 to Iomax do begin With IoPost[i] do begin
             Q := (Qt[Pi,0]+Qt[Pi,1])/2;
             CASE BE OF
             'I': H := Ht[Pi,0]; 
             'O': H := Ht[Pi,1];
             END; {Case BE}
             If (abs(Q)>10*Qtol) and (H<Hbal) then Hbal := H;
             end; end; 
         For s := 1 to Sumax do begin
             Znr := SubId[s] div 10; z := ZonPek[Znr];
             For i := 1 to Liomax[s] do begin With LioPost[s,i] do begin
                 Q := (Cpl[s,Li]+Cml[s,Li])/2;
                 H := Crl*(Cpl[s,Li]-Cml[s,Li])/2;
                 If (abs(Q)>10*Qtol) and (H<Hbal) then Hbal := H;
             end; end; end;
         For i := 1 to Iomax do begin With IoPost[i] do begin
             Znr := PipePost[Pi].Id div 100; z := ZonPek[Znr];
             CASE BE OF
             'I': begin Phyd := Ra*Qt[Pi,0]*g*(Ht[Pi,0]-Hbal)/1000; 
                  If (Phyd>0) then Pmip[z] := Pmip[z]+Phyd
                              else Pmim[z] := Pmim[z]+abs(Phyd); end;
             'O': begin Phyd := Ra*Qt[Pi,1]*g*(Ht[Pi,1]-Hbal)/1000; 
                  If (Phyd>0) then Pmim[z] := Pmim[z]+Phyd
                              else Pmip[z] := Pmip[z]+abs(Phyd); end;  
             END; {Case BE}
             end; end;
         For s := 1 to Sumax do begin
             Znr := SubId[s] div 10; z := ZonPek[Znr];
             For i := 1 to Liomax[s] do begin With LioPost[s,i] do begin
             CASE BE OF
             'I': begin Q := (Cpl[s,Li]+Cml[s,Li])/2;
                  H := Crl*(Cpl[s,Li]-Cml[s,Li])/2;
                  Phyd := Ra*Q*g*(H-Hbal)/1000;  
                  If (Phyd>0) then Pmip[z] := Pmip[z]+Phyd
                              else Pmim[z] := Pmim[z]+abs(Phyd); end;  
             'O': begin Q := (Cpl[s,Li]+Cml[s,Li])/2;
                  H := Crl*(Cpl[s,Li]-Cml[s,Li])/2;
                  Phyd := Ra*Q*g*(H-Hbal)/1000;  
                  If (Phyd>0) then Pmim[z] := Pmim[z]+Phyd
                              else Pmip[z] := Pmip[z]+abs(Phyd); end;  
             END; {Case BE}         
             end; end; end;
         For p := 1 to Pimax do begin
             Znr := PipePost[p].Id div 100; z := Zonpek[Znr]; 
             dH := abs(Ht[p,0]-Ht[p,1]); Q := abs(Qt[p,0]+Qt[p,1])/2;
             Ppi[z] := Ppi[z]+Ra*Q*g*dH/1000; end;
         For i := 1 to Vamax do begin
             Znr := VrefPost[i].Id div 100; z := ZonPek[Znr];
             Pmim[z] := Pmim[z]+Ra*abs(Qvt[i])*g*abs(H1vt[i]-H2vt[i])/1000;
             end;
         For i := 1 to Pumax do begin  With PrefPost[i] do begin
             Znr := Id div 100; z := ZonPek[Znr]; 
             Hp := PumpHp(Id,Np,Qpt[i]);
             Phy[z] := Phy[z]+Ra*Qpt[i]*g*Hp/1000;
             Ppu[z] := Ppu[z]+PumpMp(Id,Np,Qpt[i])*Pii*Np/30/1000;
             If YN='Y' then 
                Pmim[z] := Pmim[z]+Ra*Qpt[i]*sqr(Qpt[i]/Avbv)/1000;
             end; end;
         For i := 1 to Drmax do begin With DrivePost[i] do begin
             Znr := Id div 100; z := ZonPek[Znr]; Paxel := 0;
             For Pu := 1 to Pumax do begin
                 Dr := Drpek[PrefPost[Pu].DrId];
                 If (Dr=i) then begin Idp := PrefPost[Pu].Id;
                    Paxel := Paxel+PumpMp(Idp,Ndr,Qpt[Pu])*Pii*Ndr/30/1000;
                 end; end;
             Etr := Etrans(Ndr/Nmot,i);
             If (abs(Paxel)<Epsi) then Paxel := 0;
{!!}             Emo := Emotor(Paxel/Etr/Pmot,i);
             Pe[z] := Pe[z]+Paxel/Etr/Emo; end; end;
         For i := 1 to Csmax do begin With CsPost[i] do begin
             Znr := Id div 100; z := ZonPek[Znr]; 
             If Vnr=0 then Pcs[z] := Pcs[z]+Ra*Qcs*g*(Hf-Hr)/1000;
             end; end;
         For i := 1 to Exmax do begin With ExPost[i] do begin
             Znr := Id div 100; z := ZonPek[Znr];
             Q := (Qt[pTo,1]+Qt[pFr,0])/2;
             TempInit((Tt[pTo,1]+Tt[pFr,0])/2);  
             Phyd := Ra*Q*g*(Ht[pFr,0]-Ht[pTo,1])/1000;                
             Pmim[z] := Pmim[z]+abs(Phyd);
             Q := (Qt[sTo,1]+Qt[sFr,0])/2;
             TempInit((Tt[sTo,1]+Tt[sFr,0])/2);  
             Phyd := Ra*Q*g*(Ht[sFr,0]-Ht[sTo,1])/1000;                
             Pmim[z] := Pmim[z]+abs(Phyd);
             end; end;
         For s := 1 to Sumax do begin
             Znr := SubId[s] div 10; z := ZonPek[Znr];
             For i := 1 to Lcsmax[s] do begin With LcsPost[s,i] do begin
                 If Vnr=0 then Pcs[z] := Pcs[z]+Ra*Qcs*g*(Hf-Hr)/1000;
                 end; end; 
             For i := 1 to Lexmax[s] do begin With LexPost[s,i] do begin
                 Q1 := (Cpl[s,pTo]+Cml[s,pTo])/2;
                 Q2 := (Cpl[s,pFr]+Cml[s,pFr])/2;
                 Q := (Q1+Q2)/2;
                 TempInit((Tli[s,pTo]+Tli[s,pFr])/2);  
                 H1 := Crl*(Cpl[s,pTo]-Cml[s,pTo])/2;
                 H2 := Crl*(Cpl[s,pFr]-Cml[s,pFr])/2;
                 Phyd := Ra*Q*g*(H1-H2)/1000;                
                 Pmim[z] := Pmim[z]+abs(Phyd);
                 Q1 := (Cpl[s,sTo]+Cml[s,sTo])/2;
                 Q2 := (Cpl[s,sFr]+Cml[s,sFr])/2;
                 Q := (Q1+Q2)/2;
                 TempInit((Tli[s,sTo]+Tli[s,sFr])/2);  
                 H1 := Crl*(Cpl[s,sTo]-Cml[s,sTo])/2;
                 H2 := Crl*(Cpl[s,sFr]-Cml[s,sFr])/2;
                 Phyd := Ra*Q*g*(H1-H2)/1000;                
                 Pmim[z] := Pmim[z]+abs(Phyd); end; end;
             end; {For s}
         For i := 1 to Cnmax do begin  With CnPost[i] do begin
             Znr := Id div 100; z := ZonPek[Znr];
             Q := (Qt[Pto,1]+Qt[Pfr,0])/2;
             TempInit((Tt[Pto,1]+Tt[Pfr,0])/2);
             If (Ecod in [2,4]) then begin             {GP,DH}
                Phyd := Ra*Q*g*(Ht[Pfr,0]-Ht[Pto,1])/1000;
                If Phyd>0 then Pmip[z] := Pmip[z]+Phyd
                          else Pmim[z] := Pmim[z]+abs(Phyd); end;
             If (Ecod in [7,8]) then                   {CV,AV} 
                Pmim[z] := Pmim[z]+Ra*abs(Q)*sqr(Q/Value)/1000;
             If Ecod=12 then begin Bo := Enr;
                If Boiler[Bo].Avres>Epsi then
                   Pmim[z] := Pmim[z]+Ra*abs(Q)*sqr(Q/Boiler[Bo].Avres)/1000;
             end; end; end;
         For s := 1 to Sumax do begin
             Znr := SubId[s] div 10; z := ZonPek[Znr];
             For i := 1 to Lcnmax[s] do begin
                 With LcnPost[s,i] do begin
                 Q1 := (Cpl[s,Lto]+Cml[s,Lto])/2;
                 Q2 := (Cpl[s,Lfr]+Cml[s,Lfr])/2;
                 Q := (Q1+Q2)/2;
                 TempInit((Tli[s,Lto]+Tli[s,Lfr])/2);                 
                 H1 := Crl*(Cpl[s,Lto]-Cml[s,Lto])/2;
                 H2 := Crl*(Cpl[s,Lfr]-Cml[s,Lfr])/2;
                 If (Ecod in [2,4]) then begin        {GP,DH}
                    Phyd := Ra*Q*g*(H2-H1)/1000;
                    If Phyd>0 then Pmip[z] := Pmip[z]+Phyd
                              else Pmim[z] := Pmim[z]+abs(Phyd); end;
                 If (Ecod in [7,8]) then              {CV,AV}
                    Pmim[z] := Pmim[z]+Ra*abs(Q)*sqr(Q/Value)/1000;
                 If Ecod=12 then begin Bo := Enr;
                    If Boiler[Bo].Avres>Epsi then
                       Pmim[z] := Pmim[z]+Ra*abs(Q)*sqr(Q/Boiler[Bo].Avres)/1000;
                 end; {If Ecod} end; {With} end; {For i} end; {For s}
         TempInit(Tinit);
         Ppipe := 0; Pcross := 0; Phyd := 0; Ppump := 0;
         Pel := 0; Pmiscm := 0; Pmiscp := 0;
         For z := 1 to Zonmax do begin
             Ppipe := Ppipe+Ppi[z]; Pcross := Pcross+Pcs[z];
             Pmiscm := Pmiscm+Pmim[z]; Pmiscp := Pmiscp+Pmip[z];
             Phyd := Phyd+Phy[z];
             Ppump := Ppump+Ppu[z]; Pel := Pel+Pe[z]; end;
         writeln(f); 
         writeln(f,'PIPE SYSTEM - HEAD BALANCE':37);
         writeln(f); HeadLine(f); k := 1;
         For z := 1 to Zonmax do begin Znr := ZonId[z];
             write(f,IdS2(Znr):10,Ppi[z]:9:1,Pcs[z]:8:1,Pmim[z]:8:1);
             writeln(f,'..':4,Pmip[z]:8:1,Phy[z]:8:1,Ppu[z]:9:1,Pe[z]:8:1);
             k := k+1;
             If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
                then begin Paus; HeadLine(f); k := 1; end;
             end;
         write(f,'-':8); For i := 1 to 65 do write(f,'-':1); writeln(f);
         write(f,'Tot':10,Ppipe:9:1,Pcross:8:1,Pmiscm:8:1,'..':4,Pmiscp:8:1);
         writeln(f,Phyd:8:1,Ppump:9:1,Pel:8:1); flush(f); 
       END; {HeadBalance}

     PROCEDURE Heatbalance (VAR f:text);
      VAR z,Znr,i,k,s,Bo : integer;
          Ploss,Pload,Pboil,Phexm,Phexp,Pmiscm,Pmiscp,
          Tm,Q,W,Q1,Q2,Pheat,Qoutmax,Toutmax : real;
          Ppi,Pcs,Pbo,Pexm,Pexp,Pmim,Pmip : array[1..maxZon] of real;
       
      PROCEDURE HeadLine(VAR f:text);
       BEGIN
        write(f,'Zon  HeatLoads Losses HeatEx  Misc  ..  Misc':51);
        writeln(f,'HeatEx  Boilers':18);
        write(f,' -      kW       kW     kW     kW   ..   kW ':51);
        writeln(f,'  kW      kW   ':18); writeln(f); 
       END;
      
      BEGIN {Heatbalance}
       For z := 1 to Zonmax do begin 
           Ppi[z] := 0; Pcs[z] := 0; Pbo[z] := 0; Pmim[z] := 0; 
           Pmip[z] := 0; Pexm[z] := 0; Pexp[z] :=0; end;
       Qoutmax := 0.0; Toutmax := 1E9; 
       For i := 1 to Iomax do begin With IoPost[i] do begin
           Q := (Qt[Pi,0]+Qt[Pi,1])/2;
           If abs(Q)>Qoutmax then begin Qoutmax := abs(Q);    
              CASE BE OF
              'I': If (Tt[Pi,0]<Toutmax) then Toutmax := Tt[Pi,0];
              'O': If (Tt[Pi,1]<Toutmax) then Toutmax := Tt[Pi,1];
              END; {Case BE}
           end; end; end;
       For s := 1 to Sumax do begin
           Znr := SubId[s] div 10; z := ZonPek[Znr];
           For i := 1 to Liomax[s] do begin With LioPost[s,i] do begin
               Q := (Cpl[s,Li]+Cml[s,Li])/2;
               If (abs(Q)>Qoutmax) then begin Qoutmax := abs(Q); 
                  If (Tli[s,Li]<Toutmax) then Toutmax := Tli[s,Li];
           end; end; end; end;
        For i := 1 to Iomax do begin With IoPost[i] do begin
           Znr := PipePost[Pi].Id div 100; z := ZonPek[Znr];
           CASE BE OF
           'I': begin Tempinit((Tt[Pi,0]+Toutmax)/2); 
                W := Ra*Qt[Pi,0]*Csp*(Tt[Pi,0]-Toutmax); 
                If (W>0) then Pmip[z] := Pmip[z]+W
                         else Pmim[z] := Pmim[z]+abs(W); end;
           'O': begin Tempinit((Tt[Pi,1]+Toutmax)/2); 
                W := Ra*Qt[Pi,1]*Csp*(Tt[Pi,1]-Toutmax); 
                If (W>0) then  Pmim[z] := Pmim[z]+W
                         else  Pmip[z] := Pmip[z]+abs(W); end;  
           END; {Case BE}
           end; end;
        For s := 1 to Sumax do begin
           Znr := SubId[s] div 10; z := ZonPek[Znr];
           For i := 1 to Liomax[s] do begin With LioPost[s,i] do begin
           CASE BE OF
           'I': begin Tempinit((Tli[s,Li]+Toutmax)/2); 
                Q := (Cpl[s,Li]+Cml[s,Li])/2;
                W := Ra*Q*Csp*(Tli[s,Li]-Toutmax); 
                If (W>0) then Pmip[z] := Pmip[z]+W 
                         else Pmim[z] := pmim[z]+abs(W); end;
           'O': begin Tempinit((Tli[s,Li]+Toutmax)/2); 
                Q := (Cpl[s,Li]+Cml[s,Li])/2;
                W := Ra*Q*Csp*(Tli[s,Li]-Toutmax); 
                If (W>0) then Pmim[z] := Pmim[z]+W
                         else Pmip[z] := Pmip[z]+abs(W); end;
           END; {Case BE}         
           end; end; end;
       For i := 1 to Pimax do begin With PipePost[i] do begin
           Znr := Id div 100; z := Zonpek[Znr]; 
           Tm := (Tt[i,0]+Tt[i,1])/2;
           Ploss := L*(Tm-Tsur)*Kfac*Kval/1000;
           Ppi[z] := Ppi[z]+Ploss; end; end;
       For i := 1 to Csmax do begin With CsPost[i] do begin
           Znr := Id div 100; z := ZonPek[Znr]; 
           If Vnr=0 then Pcs[z] := Pcs[z]+RaCsp*Qcs*(Tf-Tr); end; end;
       For i := 1 to Exmax do begin With ExPost[i] do begin
           Q := (Qt[pTo,1]+Qt[pFr,0])/2;
           TempInit((Tt[pTo,1]+Tt[pFr,0])/2);  
           Pheat := Ra*Csp*Q*(Tt[pFr,0]-Tt[pTo,1]);                
           If Pheat>0 then Pexp[z] := Pexp[z]+Pheat
                      else Pexm[z] := Pexm[z]+abs(Pheat);
           Q := (Qt[sTo,1]+Qt[sFr,0])/2;
           TempInit((Tt[sTo,1]+Tt[sFr,0])/2);  
           Pheat := Ra*Csp*Q*(Tt[sFr,0]-Tt[sTo,1]);                
           If Pheat>0 then Pexp[z] := Pexp[z]+Pheat
                      else Pexm[z] := Pexm[z]+abs(Pheat);     
           end; end;
       For s := 1 to Sumax do begin
           Znr := SubId[s] div 10; z := ZonPek[Znr];
           For i := 1 to Lcsmax[s] do begin With LcsPost[s,i] do begin
               If Vnr=0 then Pcs[z] := Pcs[z]+RaCsp*Qcs*(Tf-Tr);
           end; end; 
           For i := 1 to Lexmax[s] do begin with LexPost[s,i] do begin
                 Q1 := (Cpl[s,pTo]+Cml[s,pTo])/2;
                 Q2 := (Cpl[s,pFr]+Cml[s,pFr])/2;
                 Q := (Q1+Q2)/2;
                 TempInit((Tli[s,pTo]+Tli[s,pFr])/2);  
                 Pheat := Ra*Csp*Q*(Tli[s,pFr]-Tli[s,pTo]);
                 If Pheat>0 then Pexp[z] := Pexp[z]+Pheat
                            else Pexm[z] := Pexm[z]+abs(Pheat);               
                 Q1 := (Cpl[s,sTo]+Cml[s,sTo])/2;
                 Q2 := (Cpl[s,sFr]+Cml[s,sFr])/2;
                 Q := (Q1+Q2)/2;
                 TempInit((Tli[s,sTo]+Tli[s,sFr])/2);  
                 Pheat := Ra*Csp*Q*(Tli[s,sFr]-Tli[s,sTo]);                
                 If Pheat>0 then Pexp[z] := Pexp[z]+Pheat
                            else Pexm[z] := Pexm[z]+abs(Pheat); 
                end; end;
           end; {For s} 
       For i := 1 to Cnmax do begin  With CnPost[i] do begin
           Znr := Id div 100; z := ZonPek[Znr];
           Q := abs(Qt[Pto,1]+Qt[Pfr,0])/2;
           TempInit((Tt[Pto,1]+Tt[Pfr,0])/2);
           If (Ecod in [3,5]) then begin       {T,DT}
              W := Ra*Q*Csp*(Tt[Pfr,0]-Tt[Pto,1]);
              If W>0 then Pmip[z] := Pmip[z]+W
                     else Pmim[z] := Pmim[z]+W; end;
           If Ecod=12 then begin Bo := Enr;
              Pbo[z] := Pbo[z]+Boiler[Bo].RaCsp*Q*(Tt[Pfr,0]-Tt[Pto,1]);
           end; end; end;
       For s := 1 to Sumax do begin
           Znr := SubId[s] div 10; z := ZonPek[Znr];
           For i := 1 to Lcnmax[s] do begin
               With LcnPost[s,i] do begin
               Q1 := (Cpl[s,Lto]+Cml[s,Lto])/2;
               Q2 := (Cpl[s,Lfr]+Cml[s,Lfr])/2;
               Q := abs(Q1+Q2)/2;
               TempInit((Tli[s,Lto]+Tli[s,Lfr])/2);
               If (Ecod in [3,5]) then begin     {T,DT}
                  W := Ra*Q*Csp*(Tli[s,Lfr]-Tli[s,Lto]);
                  If W>0 then Pmip[z] := Pmip[z]+W
                         else Pmim[z] := Pmim[z]+W; end;
               If Ecod=12 then begin Bo := Enr;
                  Pbo[z] := Pbo[z]+Boiler[Bo].RaCsp*Q*(Tli[s,Lfr]-Tli[s,Lto]);
               end; {If Ecod} end; {With} end; {For i} end; {For s}
         TempInit(Tinit);
       Pload := 0; Ploss := 0; Pboil := 0; Pmiscp := 0;
       Pmiscm := 0; Phexp :=0; Phexm := 0;
       For z := 1 to Zonmax do begin
           Pload := Pload+Pcs[z]; Ploss := Ploss+Ppi[z];
           Pboil := Pboil+Pbo[z]; 
           Pmiscm := Pmiscm+Pmim[z]; Pmiscp := Pmiscp+Pmip[z];
           Phexm := Phexm+Pexm[z]; Phexp := Phexp+Pexp[z];   
           end;
       writeln(f); writeln(f); 
       writeln(f,'PIPE SYSTEM - HEAT BALANCE      ':43);
       writeln(f); HeadLine(f); k := 1;
       For z := 1 to Zonmax do begin Znr := ZonId[z];
           write(f,IdS2(Znr):10,Pcs[z]:9:0,Ppi[z]:8:0,Pexm[z]:7:0);
           write(f,Pmim[z]:7:0,'..':4,Pmip[z]:7:0,Pexp[z]:7:0);
           writeln(f,Pbo[z]:10:0); k := k+1;
           If ((k mod ContLines)=0) and ((not PrFlag) and (not AllFlag))
              then begin Paus; HeadLine(f); k := 1; end; 
          end;
       write(f,'-':8); For i := 1 to 65 do write(f,'-':1); writeln(f);
       write(f,'Tot':10,Pload:9:0,Ploss:8:0,Phexm:7:0,Pmiscm:7:0,'..':4);
       writeln(f,Pmiscp:7:0,Phexp:7:0,Pboil:10:0); flush(f);
      END; {Heatbalance}
            
     PROCEDURE Overmenu;
      BEGIN
       writeln('PIPE SYSTEM - OVERALL PERFORMANCE':46); writeln;
       writeln('1:  Head balance                 ':46);
       writeln('2:  Heat balance                 ':46);
       writeln; writeln('Select Line, 0 for exit':40);
       Alt := LineNr(2);
      END; {Overmenu}
      
     BEGIN {printOverall}
      If AllFlag then begin Headbalance(f5); Heatbalance(f5); end
      else REPEAT  Overmenu; Dummy := 1;
           CASE Alt OF
           0: begin Aclear; Dummy := 0; end;
           1: begin Aclear; Headbalance(output); 
                    If PrintFlag then Headbalance(f5); Aclear; end;
           2: begin Aclear; Heatbalance(output); 
                    If PrintFlag then Heatbalance(f5); Aclear; end;
          END; {Case Alt}
          UNTIL (Dummy=0);
     END; {PrintOverall}

      PROCEDURE Printmenu;
       VAR ch : char;
       BEGIN
        Aclear; writeln(Mmenu); writeln(Dash);
        writeln; writeln;
        writeln(' ':14,'Tables of Steady Flow Results');
        writeln(' ':14,'-----------------------------');
        writeln;
        writeln(' ':14,'1 - Print Pipes, Steady Flow Results');
        writeln(' ':14,'2 - Print Pipe/Link Connections');
        writeln(' ':14,'3 - Print Pipe/Link Cross Connections');
        writeln(' ':14,'4 - Print Links,  Steady Flow Results');
        writeln(' ':14,'5 - Print Valves, Steady Flow Results');
        writeln(' ':14,'6 - Print Pumps,  Steady Flow Results');
        writeln(' ':14,'7 - Print Boilers and Heat Exchangers');
        writeln(' ':14,'8 - Print System, Overall Performance');
        writeln(' ':14,'9 - Print all results to Printfile');
        writeln(' ':14,'0 - Return to Main Menu'); writeln;
        REPEAT
          write('Choice : ':14); read(ch); readln; ch := Uchar(ch);
        UNTIL (ord(ch)>47) and (ord(ch)<58) or (ch in MenuSet);
        If (ch in Menuset) then begin Choice := ch; Alt := 10; end
                           else begin Alt := ord(ch)-48; end;
        OldChoice := 'T';
       END;    {Printmenu}

      BEGIN  { PrintResults } 
       RwFlag := false; AllFlag := false; PrFlag := false;
       REPEAT  Printmenu; Dummy := 1;
        CASE Alt OF
          0: begin Choice := 'X'; Dummy := 0; end;
          1: begin Aclear; ZonFlag := true; PrintPipes(output);
                   If PrintFlag then PrintPipes(f5); end;  
          2: begin Aclear; ZonFlag := true; PrintConns(output);
                   If PrintFlag then PrintConns(f5); end;
          3: begin Aclear; ZonFlag := true; PrintCross(output);
                   If PrintFlag then PrintCross(f5); end;
          4: begin Aclear; ZonFlag := true;
                   If Sumax>0 then begin PrintLinks(output);
                      If PrintFlag then PrintLinks(f5); end; end;
          5: begin Aclear; ZonFlag := true; PrintValves(output);
                   If PrintFlag then PrintValves(f5); end;
          6: begin Aclear; ZonFlag := true;
                   If Pumax>0 then begin PrintPumps(output);
                      If PrintFlag then PrintPumps(f5); end; end;
          7: begin Aclear; ZonFlag := true; PrintHexBo; end;
          8: begin Aclear; PrintOverall; end;
          9: begin Connect(f5,Fil[5],'W');
                   Header; ZonFlag := false; AllFlag := true;
                   PrintOverall; PrintPipes(f5); PrintConns(f5);
                   PrintCross(f5); PrintLinks(f5);
                   PrintValves(f5); PrintPumps(f5); PrintHexBo; 
                   writeln; writeln('Results printed to : ':39,Fil[5]:maxCh1);
                   Stop; AllFlag := false; end;
         10: begin Dummy := 0; end;
        END; {Case}
       UNTIL (Dummy=0);
       If RwFlag then Close(f5);
      END;   { PrintResults }

   PROCEDURE Plotresults;
     CONST maxK = 50; maxS = 300; maxRstr = 70;
           maxYstr = 20; maxFig = 79; maxMk = 12; maxMe = 6;
           maxYax = 10; maxXax = 50; maxPlt = 50; maxLrm = 50;
     TYPE     Rstr = packed array[1..maxRstr] of char;
            LabStr = packed array[1..2] of char;
            Marker = packed array[1..maxMk] of char;
           PostYax = record Yvar : char;
                            Ylow,Yincr,Yhigh : real;
                            Ystr : packed array[1..maxYstr] of char; end;
           PostXax = record Path,RL : char;
                            Mark : array[1..maxK] of Marker;
                            ThickH : array[1..maxK] of real;
                            ThickZ : array[1..maxK] of real;
                            ThickL : array[1..maxK] of real;
                            Rod : array[1..maxK] of real;
                            Green : array[1..maxK] of real;
                            Blue : array[1..maxK] of real;
                            Xtic : array[1..maxK] of real;
                            Kmax : integer; end;
            ScaleX = record Xhigh,dX,Xlow,Xmk : real;
                            Xnr : integer; end;
            ScaleY = record Ylow, Yhigh : real; end;
           PostPlt = record Path : char;
                            RL   : array[1..maxS] of char;
                            Mark : array[1..maxS] of Marker;
                            ThickH  : array[1..maxS] of real;  
                            ThickZ  : array[1..maxS] of real;  
                            ThickL  : array[1..maxS] of real;  
                            Rod : array[1..maxS] of real;
                            Green : array[1..maxS] of real;
                            Blue : array[1..maxS] of real;
                            Xbeg : array[1..maxS] of real;
                            Pipe,Sign : array[1..maxS,1..7] of integer;
                            Pmax : array[1..maxS] of integer;
                            Smax : integer;  end;
           LarmPlt = record Path : char;
                            Head,Xlarm : array[1..maxAlarm] of real;
                            HL : array[1..maxAlarm] of char;
                            Lab : array[1..maxAlarm] of LabStr;
                            LarmMax : integer; end;
            StrFig = packed array[1..maxFig] of char;
            DoWhat = (Mt,Lt,Wt);
            Driver = (Dpl,Hpgl,Pscript);
     VAR  f,Fp {,Fs} : text;
          YaxPost : array[1..maxYax] of PostYax;
          XaxPost : array[1..maxXax] of PostXax;
          PltPost : array[1..maxPlt] of PostPlt;
          PltLarm : array[1..maxLrm] of LarmPlt;
          FigStr: array[1..5] of StrFig;
          Xscale : ScaleX;
          Yscale : ScaleY;
          Hcom,Qcom,Ttcom : MatPi;
          Last,ReCo,Ygrid : char;
          Yaxmax,Xaxmax,Pltmax,Figmax,p,i1,i2,Alt : integer;
          ScreenTyp,PlotTyp : integer;
          DumT : Rstr;
          Device : Driver;

     PROCEDURE Plotdata;
       VAR  i,j,k,l,Nr,Id,m,n,s,p,Pi,Znr : integer;
            Sum,Dum,Lpi,Lp : real;
            Ch,Px : char;
            Xflag,Pflag : Boolean;
            Xstroke : array[1..maxPlt,1..maxS] of real;
            Dpl,Plo : packed array[1..8] of char;
            Perror : Boolean;
            color : word;
       BEGIN
        Connect(f,Fil[3],'R'); Radantal := 1; Perror := false;
        If Felkod<>0 then begin writeln;
           writeln('File not found:':33,Fil[3]:17); Gerror; end;   
    { ----------------  Device  ------------------------------ }
        For i := 1 to 8 do begin
            Dpl[i] := ' '; Plo[i] := ' '; end;
        readln(f); Red; read(f,ch); i := 1;
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
        REPEAT read(f,Dpl[i]); UNTIL Dpl[i]<>' ';
        REPEAT i := i+1; read(f,Dpl[i]); UNTIL Dpl[i]=' ';
        i := 1;
        REPEAT read(f,Plo[i]); UNTIL Plo[i]<>' ';
        REPEAT i := i+1; read(f,Plo[i]); UNTIL Plo[i]=' ';
        i := 1;
        REPEAT read(f,Ygrid); UNTIL Ygrid<>' ';
        ScreenTyp := 1; {Xterm} Plottyp := 1; {Ps} 
        If Dpl='Tek4010 ' then ScreenTyp := 2;
        If Plo='Hpgl    ' then Plottyp := 2;
    { ----------------  Y-axis  ------------------------------ }
        readln(f); Red; read(f,ch); i := 0;
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
        WHILE ch=' ' do begin i := i+1;
          With YaxPost[i] do begin
          For j := 1 to maxYstr do Ystr[j] := ' ';
          REPEAT read(f,Yvar); UNTIL (Yvar<>' ');
          If not (Yvar in ['H','Z','L','Q','V','S','T','P']) then begin 
             writeln('Bad Yvar':10,Yvar:3,'Illegal character!':20); Gerror; end;
          read(f,Ylow,Yincr,Yhigh); j := 1;
          REPEAT read(f,Ystr[j]); UNTIL (Ystr[j]<>' ');
          While ((not eoln(f)) and (j<maxYstr)) do begin
                j := j+1; read(f,Ystr[j]); end;
          readln(f); Red; read(f,ch); end; end;
        Yaxmax := i;
   {  --------------  X-axis  ------------------------------ }
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
        For i := 1 to maxXax do
            For k := 1 to maxK do XaxPost[i].Xtic[k] := 0;
        i := 0; k := 0;
        WHILE ch=' ' do begin i := i+1; k := k+1;
          REPEAT read(f,Px); UNTIL (Px<>' ');
          If (i>1) then begin
             If (Px=XaxPost[i-1].Path) then i := i-1 else k := 1; end;
          With XaxPost[i] do begin
          REPEAT read(f,RL); UNTIL (RL<>' ');
          If not (RL in ['R','L']) then begin write('X-axis':10);
             writeln('R/L-Error!':12); Gerror; end;
          Mark[k] := '            '; Path := Px; j := 1;
          REPEAT read(f,Mark[k,j]); UNTIL (Mark[k,j]<>' ');
          REPEAT j := j+1; read(f,Mark[k,j]);
    {                       UNTIL ((Mark[k,j] =' ') or (j=maxMk));}
                           UNTIL (j=maxMk);
          If i=1 then begin Xtic[1] := 0; XFlag := true; end;
          If i>1 then begin Xflag := false;
             If Mark[k]='Cont        ' then begin Xflag := true;
                XaxPost[i].Xtic[k+1] := XaxPost[i].Xtic[k]; end
             else begin
             For m := 1 to i-1 do
                 For n := 1 to XaxPost[m].Kmax do
                     If Mark[1]=XaxPost[m].Mark[n] then begin
                        Xtic[1] := XaxPost[m].Xtic[n];
                        Xflag := true; end; end; end;
          If not Xflag then begin Perror := true;
             writeln('X-axis Path Error!'); end;
          Sum := 0;
          For j := 1 to 7 do begin Id := ReadId(f);
              Nr := Id mod 100; 
              If Nr>0 then begin Znr := Id div 100;
                 If (Id<1) or (Id>maxId) or (Pipek[Id]=0) then begin
                    write('Pipe':10,IdS2(Znr):4,NrS2(Nr):2);
                    writeln('X-axis Error!':20); Gerror; end;
                 If (RL='L') then Sum := Sum-PipePost[Pipek[Id]].L
                     else Sum := Sum+PipePost[Pipek[Id]].L; end; end;
          Xtic[k+1] := Xtic[k]+Sum;
          Kmax := K; readln(f); Red; read(f,ch); end; end;
        Xaxmax := i;
   { -----------------  Plot Path  ----------------------- }
        i := 0; s := 0;
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
        WHILE ch=' ' do begin i := i+1; s := s+1; k := 1;
          REPEAT read(f,Px); UNTIL (Px<>' ');
          If (i>1) then begin
             If (Px=PltPost[i-1].Path) then i := i-1
             else begin k := 1; s := 1; end; end;
          With PltPost[i] do begin
          REPEAT read(f,RL[s]); UNTIL (RL[s]<>' ');
          Mark[s] := '            '; Path := Px; j := 1;
          REPEAT read(f,Mark[s,j]); UNTIL (Mark[s,j]<>' ');
          REPEAT j := j+1; read(f,Mark[s,j]);
  {                         UNTIL ((Mark[s,j] =' ') or (j=maxMk));}
                           UNTIL (j=maxMk);
          Xstroke[i,s] := 0;
          if mark[s]<>'Cont        ' then  begin 
             for l := 1 to maxword do color[l] := ' ';
             read(f,ch);
             while ch = ' ' do read(f,ch);
             l := 0;
             repeat
               l := l+1;
               color[l] := ch;
               read(f,ch);
             until ch = ' ';
             read(f,thickH[s],thickZ[s],thickL[s]); 
             if color[1..3] = 'Red' then begin
                 Rod[s] := 247/255; Green[s] := 59/255; Blue[s] := 59/255;
             end; 
             if color[1..3] = 'Win' then begin
                 Rod[s] := 208/255; Green[s] := 1/255; Blue[s] := 104/255;
             end; 
             if color[1..3] = 'Pin' then begin
                 Rod[s] := 255/255; Green[s] := 138/255; Blue[s] := 138/255;
             end; 
             if color[1..3] = 'Mag' then begin
                 Rod[s] := 204/255; Green[s] := 17/255; Blue[s] := 233/255;
             end; 
             if color[1..3] = 'Blu' then begin
                 Rod[s] := 9/255; Green[s] := 46/255; Blue[s] := 165/255;
             end; 
             if color[1..3] = 'Ice' then begin
                 Rod[s] := 195/255; Green[s] := 215/255; Blue[s] := 255/255;
             end; 
             if color[1..3] = 'Sky' then begin
                 Rod[s] := 122/255; Green[s] := 189/255; Blue[s] := 255/255;
             end; 
             if color[1..3] = 'Gre' then begin
                 Rod[s] := 60/255; Green[s] := 169/255; Blue[s] := 6/255;
             end; 
             if color[1..3] = 'Hyd' then begin
                 Rod[s] := 113/255; Green[s] := 186/255; Blue[s] := 150/255;
             end; 
             if color[1..3] = 'Pis' then begin
                 Rod[s] := 151/255; Green[s] := 255/255; Blue[s] := 182/255;
             end; 
             if color[1..3] = 'Yel' then begin
                 Rod[s] := 250/255; Green[s] := 226/255; Blue[s] := 10/255;
             end; 
             if color[1..3] = 'Ora' then begin
                 Rod[s] := 255/255; Green[s] := 158/255; Blue[s] := 60/255;
             end; 
             if color[1..3] = 'Bee' then begin
                 Rod[s] := 255/255; Green[s] := 214/255; Blue[s] := 131/255;
             end; 
             if color[1..3] = 'Bro' then begin
                 Rod[s] := 193/255; Green[s] := 117/255; Blue[s] := 2/255;
             end; 
             if color[1..3] = 'Gra' then begin
                 Rod[s] := 170/255; Green[s] := 170/255; Blue[s] := 170/255;
             end; 
             if color[1..3] = 'Bla' then begin
                 Rod[s] := 0; Green[s] := 0; Blue[s] := 0;
             end; 
          end;
          For j := 1 to 7 do begin Id := ReadId(f); Sign[s,k] := +1;
              If Id<0 then begin Id := abs(Id); Sign[s,k] := -1; end;
              Nr := Id mod 100;
              If Nr>0 then begin Znr := Id div 100; 
                 If (Id<1) or (Id>maxId) or (Pipek[Id]=0) then begin
                    write('Pipe':10,IdS2(Znr):4,NrS2(Nr):2);
                    writeln('Plot Path Error!':20); Gerror; end;
                 Lp := PipePost[Pipek[Id]].L;
                 If RL[s]='L' then Xstroke[i,s] := Xstroke[i,s]-Lp
                              else Xstroke[i,s] := Xstroke[i,s]+Lp;
                 Pipe[s,k] := Pipek[Id]; k := k+1; end; end;
          Smax := s; Pmax[s] := k-1; readln(f); Red; read(f,ch); end; end;
        Pltmax := i;
        For i := 1 to Pltmax do
            For s := 1 to PltPost[i].Smax do begin Pflag := false;
                If PltPost[i].Mark[s]='Cont        ' then begin Pflag := true;
                   PltPost[i].Xbeg[s] := PltPost[i].Xbeg[s-1]+Xstroke[i,s-1]; end
                else begin
                For m := 1 to Xaxmax do
                    For n := 1 to XaxPost[m].Kmax do
                        If (PltPost[i].Mark[s]=XaxPost[m].Mark[n]) then
                           begin PltPost[i].Xbeg[s] := XaxPost[m].Xtic[n];
                                 Pflag := true; end; end;
                If not Pflag then begin write(PltPost[i].Mark[s]:8,' ':3);
                   writeln('Plot Path Marker Error!'); Perror := true; end; 
            end; {For s}
       If Perror then Gerror;    
   {  ---------------  Text  --------------------------------  }
        i := 0;
        WHILE not (ch=' ') do begin readln(f); Red; read(f,ch); end;
        WHILE ch=' ' do begin i := i+1;
          For j := 1 to maxFig do FigStr[i,j] := ' ';
          REPEAT read(f,FigStr[i,1]); UNTIL (FigStr[i,1]<>' ') or (eoln(f));
          For j := 2 to maxFig do
              If not eoln(f) then read(f,FigStr[i,j]);
          readln(f); Red; read(f,ch); end;
        Figmax := i;
        Close(f);
   {  ---------------- Larm  ----------------------------------  }
        For i := 1 to Pltmax do With PltPost[i] do begin k := 0;
            For s := 1 to Smax do begin Lpi := PltPost[i].Xbeg[s];
                For p := 1 to Pmax[s] do begin
                    Lp := PipePost[Pipe[s,p]].L;
                    If RL[s]='L' then Lpi := Lpi-Lp else Lpi := Lpi+Lp;
                    For j := 1 to Alarmmax do begin
                        Pi := Pipek[AlarmPost[j].Id];
                        If Pipe[s,p]=Pi then begin k := k+1;
                           PltLarm[i].Path := PltPost[i].Path;
                           If AlarmPost[j].BE = 'B'
                              then Dum := 1E05/Density(Tt[Pi,0])/g
                              else Dum := 1E05/Density(Tt[Pi,1])/g;
                           Dum := AlarmPost[j].bar*Dum;
                           PltLarm[i].Head[k] := Dum+AlarmPost[j].Zpi;
                           If AlarmPost[j].HL='H' then PltLarm[i].HL[k] := 'H'
                                                  else PltLarm[i].HL[k] := 'L';
                           PltLarm[i].Lab[k] := AlarmPost[j].Lab;
                           CASE RL[s] OF
                           'R': If ((AlarmPost[j].BE='B') and (Sign[s,p]>0)) or
                                   ((AlarmPost[j].BE='E') and (Sign[s,p]<0)) then
                                     PltLarm[i].Xlarm[k] := Lpi-Lp
                                else PltLarm[i].Xlarm[k] := Lpi;
                           'L': If ((AlarmPost[j].BE='B') and (Sign[s,p]>0)) or
                                   ((AlarmPost[j].BE='E') and (Sign[s,p]<0)) then
                                     PltLarm[i].Xlarm[k] := Lpi+Lp
                                else PltLarm[i].Xlarm[k] := Lpi;
                           END; end;
           end; end; end; PltLarm[i].LarmMax := k; end;
      Res := Execute ('date +%F > /tmp/dateplot.txt');
      Res := Execute ('chmod -f ugo+w /tmp/dateplot.txt');
      reset(f,utfil1);
      for i := 1 to 10 do read(f,datestr[i]);
      close(f);
      Res := Execute ('rm -f /tmp/date.txt');
     END;   { Plotdata }

   PROCEDURE Ptd(Xp,Yp:real; What : DoWhat; VAR Tex:Rstr; Tl:integer);
     CONST Hcon = 32; LYcon = 96; LXcon = 64;
           Xoo = 130; Xxo = 850; Yoo = 114; Yyo = 568;
     VAR Xs,Ys,Xh,Xl,Yh,Yl,i : integer;
         ch : char;
     BEGIN
       CASE Device OF
         Dpl : begin
               Xs := Xoo+round(Xp*Xxo); Ys := Yoo+round(Yp*Yyo);
               If Xs<0 then Xs := 0; If Xs>1024 then Xs := 1024;
               If Ys<0 then Ys := 0; If Ys>767  then Ys := 767;
               Xh := Hcon+Xs div Hcon; Xl := LXcon+Xs mod Hcon;
               Yh := Hcon+Ys div Hcon; Yl := LYcon+Ys mod Hcon;
               CASE What OF
{Fs}           Mt: begin write(output,chr(29));
                         write(output,chr(Yh),chr(Yl),chr(Xh),chr(Xl)); end;
               Lt: begin write(output,chr(Yh),chr(Yl),chr(Xh),chr(Xl)); end;
               Wt: begin write(output,chr(29));
                         write(output,chr(Yh),chr(Yl),chr(Xh),chr(Xl));
                         For i := 1 to Tl do write(output,chr(31),Tex[i]:1); end;
               END; end;
         Hpgl: begin
               Xs := round(2000+Xp*7500);
               Ys := round(1500+Yp*5500);
               CASE What OF
               Mt: writeln(Fp,'PU;':3,'PA':3,Xs:5,',':1,Ys:5,';':1);
               Lt: begin writeln(Fp,'PD;':3,'PA':3,Xs:5,',':1,Ys:5,';':1); end;
               Wt: begin
                   writeln(Fp,'PU;':3,'PA':3,Xs:5,',':1,Ys:5,';':1);
                   write(Fp,'LB':2);
                   For i := 1 to Tl do write(Fp,Tex[i]:1);
                   writeln(Fp,chr(3),';':1); end;
               END; end;
       Pscript:begin
               CASE What OF
               Mt: begin writeln(Fp,Xp:7:3,Yp:7:3,'mt':3); end;
               Lt: begin writeln(Fp,Xp:7:3,Yp:7:3,'li':3); end;
               Wt: begin
                   write(Fp,Xp:7:3,Yp:7:3,'mt':3,'(':2);
                   For i := 1 to Tl do begin ch := Tex[i];
                       If (ch in ['}',']','{','[','|','\']) then
                       CASE ch OF
                       '}': write(Fp,'\362');
                       ']': write(Fp,'\342');
                       '{': write(Fp,'\331');
                       '[': write(Fp,'\311');
                       '|': write(Fp,'\334');
                       '\': write(Fp,'\333');
                       END {case ch}
                       else write(Fp,Tex[i]:1); end;
                   writeln(Fp,')':1,'show':5);
                   end;
              END; end;
       END;
     END;  { Ptd }

    PROCEDURE RealStr(VAR StrR:Rstr; x:real; Dec,S:integer);
      CONST Epsi = 1E-10;
      VAR  Dum,Xexp : real;
           i,i1,i2,k : integer;
      BEGIN
       If x>=0 then StrR[1] := ' ' else StrR[1] := '-';
       Dum := abs(x); k := 0;
       While (Dum>=10) do begin Dum := Dum/10; k := k+1; end;
       Dum := abs(x); i2 := k+1;
       For i := 1 to i2 do begin  Xexp := round(exp((i2-i)*ln(10)));
           k := trunc(Dum/Xexp); StrR[i+1] := chr(k+48);
           Dum := Dum-k*Xexp; end;
       i := i2+2; i1 := i+1;
       If (i<S) and (Dec>0) then StrR[i] := '.';
       If i<(S-Dec) then i2 := i+Dec else i2 := S;
       For i := i1 to i2 do begin k := trunc(10*Dum+Epsi);
           Dum := (10*Dum-k); StrR[i] := chr(k+48); end;
    END; { RealStr }

   PROCEDURE XLscale(Xax : integer);
     CONST dYtic = 0.02; Yline = 0.04; dXch = 0.01;
     VAR Max,Dum,Yp,Xdx,Xsc : real;
         Kexp,k,i,p : integer;
         Xmark : Packed array[1..4] of char;
         Tex,Xfig : Rstr;
     BEGIN
      If Device=Pscript then writeln(Fp,'newpath':9);
      With XaxPost[Xax] do  Max := abs(Xtic[Kmax]-Xtic[1]);
      Kexp := 0; Dum := Max;
      WHILE (Dum>=10) do begin
        Kexp := Kexp+1; Dum := Max/round(exp(Kexp*ln(10))); end;
      Xdx := 2.00;
      If Dum<7.0 then Xdx := 1.00;
      If Dum<3.5 then Xdx := 0.50;
      If Dum<1.4 then Xdx := 0.20;
      With Xscale do begin
      dX := Xdx*round(exp(Kexp*ln(10))); Xnr := trunc(Max/dX);
      Xmk := (trunc(Xnr/2)+0.4)*dX/Max; end;
      With Xscale do begin  Yp := -0.11;
      Ptd(0,Yp,Mt,DumT,1); Ptd(Xnr*dX/Max,Yp,Lt,DumT,1);
      For k := 0 to Xnr do begin Xsc := k*dX/Max;
          Ptd(Xsc,Yp,Mt,DumT,1); Ptd(Xsc,Yp+dYTic,Lt,DumT,1);
          Xsc := k*dX; If Kexp>=3 then Xsc := Xsc/1000;
          Xfig := DumT; RealStr(Xfig,Xsc,1,5); p := 0; Tex := DumT;
          For i := 1 to 5 do
              If Xfig[i]<>' ' then begin
                        p := p+1; Tex[p] := Xfig[i]; end;
          Ptd(k*dX/Max-dXch*p/2,Yp-Yline,Wt,Tex,p); end;
      If Kexp>=3 then Xmark := 'X km' else Xmark := 'X  m';
      Tex := DumT; For i := 1 to 4 do Tex[i] := Xmark[i];
      Ptd(Xmk,Yp-Yline,Wt,Tex,4);  end;
      If Device=Pscript then writeln(Fp,'stroke':7);
     END;  {XLscale}

   PROCEDURE Xaxis(Xax:integer);
     CONST Ytic = 0.02; Yline = 0.04; dXch = 0.01;
     VAR k,i,p : integer;
         Xaxi,Xl,Xp,Yp : real;
         Tex : Rstr;
     BEGIN
       If Device=Pscript then writeln(Fp,'newpath':9);
       If Last='C' then begin k := XaxPost[Xax].Kmax;
          If XaxPost[Xax].RL='L' then begin
             XScale.Xhigh := XaxPost[Xax].Xtic[1];
             Xscale.Xlow := XaxPost[Xax].Xtic[k]; end
             else begin XScale.Xhigh := XaxPost[Xax].Xtic[k];
                        Xscale.Xlow := XaxPost[Xax].Xtic[1]; end;
          Yp := -0.04; end
       else Yp := -0.04+0.08;
       Xl := Xscale.Xlow; Xaxi := Xscale.Xhigh-Xl;
       With XaxPost[Xax] do begin
       If Last='C' then begin
          Xp := (Xtic[1]-Xl)/Xaxi; Ptd(Xp,Yp,Mt,DumT,1);
          Xp := (Xtic[Kmax]-Xl)/Xaxi; Ptd(Xp,Yp,Lt,DumT,1);
          For k := 1 to Kmax do
              If Mark[k]<>'Cont        ' then begin Xp := (Xtic[k]-Xl)/Xaxi;
                 Ptd(Xp,Yp,Mt,DumT,1); Ptd(Xp,Yp+Ytic,Lt,DumT,1);
                 Tex := DumT; p := 0;
                 For i := 1 to maxMk do begin
                     If Mark[k,i]<>' ' then 
                        p := p+1; Tex[i] := Mark[k,i]; end;
                 Ptd(Xp-dXch*p/2,Yp-Yline,Wt,Tex,i); end;
          Yp := 1.04; Ptd(0,Yp,Mt,DumT,1); Ptd(1,Yp,Lt,DumT,1);
          For k := 1 to Kmax do begin
              If Mark[k]<>'Cont        ' then begin
                 Xp := (Xtic[k]-Xl)/Xaxi; Ptd(Xp,Yp,Mt,DumT,1);
                 Ptd(Xp,Yp-Ytic,Lt,DumT,1); end; end; end
       else begin
            Xp := (Xtic[1]-Xl)/Xaxi; Ptd(Xp,Yp,Mt,DumT,1);
            Xp := (Xtic[Kmax]-Xl)/Xaxi; Ptd(Xp,Yp,Lt,DumT,1);
            For k := 1 to Kmax do
                If Mark[k]<>'Cont        ' then begin Xp := (Xtic[k]-Xl)/Xaxi;
                   Ptd(Xp,Yp,Mt,DumT,1); Ptd(Xp,Yp+Ytic,Lt,DumT,1);
                   Tex := DumT; p := 0;
                   For i := 1 to maxMk do begin
                       If Mark[k,i]<>' ' then
                          p := p+1; Tex[i] := Mark[k,i]; end;
                   Ptd(Xp-dXch*p/2,Yp-Yline,Wt,Tex,i); end;
            end; end;
       If Device=Pscript then writeln(Fp,'stroke':7);
     END; {Xaxis}

   PROCEDURE Yaxis(Yax:integer);
     CONST dTic = 0.015;
     VAR i,k,Dec : integer;
         Tic,Yaxi,Xleft : real;
         Tex : Rstr;
     BEGIN
       If Device=Pscript then writeln(Fp,'newpath':9);
       If Last='C' then begin Yscale.Ylow  := YaxPost[Yax].Ylow;
                              Yscale.Yhigh := YaxPost[Yax].Yhigh; end;
       Yaxi := Yscale.Yhigh-Yscale.Ylow;
       Ptd(-0.04,0,Mt,DumT,1); Ptd(-0.04,1,Lt,DumT,1);
       Ptd(1.04,0,Mt,DumT,1);  Ptd(1.04,1,Lt,DumT,1);
       With YaxPost[Yax] do begin k := 0;
       If Yhigh<1000 then Dec := 0;
       If Yhigh<100 then Dec := 1;
       If Yhigh<10 then Dec := 2;
       If ScreenTyp=1 then Xleft := -0.13 else Xleft := -0.13;
       WHILE (Ylow+k*Yincr)<=(Yhigh+Epsi) do begin
         Tic := (k*Yincr)/Yaxi;
         Ptd(-0.04,Tic,Mt,DumT,1); Ptd(-0.04+dTic,Tic,Lt,DumT,1);
         Ptd(1.04,Tic,Mt,DumT,1); Ptd(1.04-dTic,Tic,Lt,DumT,1);
         Tex := DumT; RealStr(Tex,Yscale.Ylow+k*Yincr,Dec,5);
         If (Device=Pscript) or (Device=Hpgl) then Ptd(1.05,Tic,Wt,Tex,5);
         Ptd(Xleft,Tic,Wt,Tex,5);  k := k+1; end; end;
       k := 0;
       If (device=Dpl) and (Ygrid='Y') then begin
          write(output,chr(27),'b');
          With YaxPost[Yax] do begin
          WHILE (Ylow+k*Yincr)<=(Yhigh+Epsi-Yincr) do begin
           Tic := (k*Yincr)/Yaxi;
           Ptd(0.0,Tic,Mt,DumT,1); Ptd(1.0,Tic,Lt,DumT,1);
           k := k+1; end; {While} end; {With}
           write(output,chr(27),'h'); end;

       k := 0;
       If (device=Pscript) and (Ygrid='Y') then begin
          writeln(Fp,'stroke':7); writeln(Fp,'newpath');
          writeln(Fp,'0.4 setlinewidth [1 5] 0 setdash');
          With YaxPost[Yax] do begin
          WHILE (Ylow+k*Yincr)<=(Yhigh+Epsi-Yincr) do begin
           Tic := (k*Yincr)/Yaxi;
           Ptd(0.0,Tic,Mt,DumT,1); Ptd(1.0,Tic,Lt,DumT,1);
           k := k+1; end; {While} end; {With}
          writeln(Fp,'stroke':7);
          writeln(Fp,'0.8 setlinewidth [] 0 setdash'); end; {If}
       If (device=Hpgl) and (Ygrid='Y') then begin
          writeln(Fp,'LT4;':4);
          With YaxPost[Yax] do begin
          WHILE (Ylow+k*Yincr)<=(Yhigh+Epsi-Yincr) do begin
           Tic := (k*Yincr)/Yaxi;
           Ptd(0.0,Tic,Mt,DumT,1); Ptd(1.0,Tic,Lt,DumT,1);
           k := k+1; end; {While} end; {With}
          writeln(Fp,'LT7;':4); end; {if}
       Tex := DumT;
       For i := 1 to maxYstr do Tex[i] := YaxPost[Yax].Ystr[i];
       If Device=Pscript then
          writeln(Fp,'/Helvetica-iso findfont 15 scalefont setfont');
       Ptd(0.0,0.99,Wt,Tex,maxYstr);
       If Device=Pscript then begin
          writeln(Fp,'/Helvetica-iso findfont 10 scalefont setfont');
          writeln(Fp,'stroke':7); end;
     END;  {Yaxis}

   PROCEDURE PlotMenu(Xax,Yax,Pat:integer);
     CONST Tics = 10; Tic = 0.12; dTic = 0.01;
     TYPE  MenuStr = packed array[1..maxMe] of char;
     VAR   Menu: array[1..Tics] of menuStr;
           i,k : integer;
           Tex : Rstr;
     BEGIN
       Menu[1] := 'Path  '; Menu[1,maxMe] := PltPost[Pat].Path;
       Menu[2] := 'Xax   '; Menu[2,maxMe] := XaxPost[Xax].Path;
       Menu[3] := 'Yax   '; Menu[3,maxMe] := YaxPost[Yax].Yvar;
       Menu[4] := 'Alt   '; Menu[4,maxMe] := ReCo;
       Menu[5] := 'Draw  '; Menu[6] :=  '      ';
       Menu[7] := '      '; Menu[8] :=  'File  ';
       Menu[9] := 'Clear '; Menu[10] := 'Exit  ';
       Ptd(-0.15,1.15,Mt,DumT,1); Ptd(1.05,1.15,Lt,DumT,1);
       Ptd(-0.15,1.07,Mt,DumT,1); Ptd(1.05,1.07,Lt,DumT,1);
       For k := 0 to Tics do begin
           Ptd(-0.15+k*Tic,1.07,Mt,DumT,1);
           Ptd(-0.15+k*Tic,1.15,Lt,DumT,1); end;
       For k := 1 to Tics do begin Tex := DumT;
           For i := 1 to maxMe do Tex[i] := Menu[k,i];
           Ptd(-0.15+(k-1)*Tic+dTic,1.10,Wt,Tex,maxMe); end;
     END; { PlotMenu }

    PROCEDURE Figtext;
      CONST dY = 0.05;
      VAR  i,k,Dec : integer;
           Tex,Tx : Rstr;
           Tp1 : packed array[1..14] of char;
           Tp2 : packed array[1..8]  of char;
           Tpx : packed array[1..5] of char;
      BEGIN
        If Device=Pscript then begin
           writeln(Fp,'/Helvetica-iso findfont 10 scalefont setfont');
           Tex := DumT; Tp2 := 'Data:   ';
           For i := 1 to 6 do Tex[i] := Tp2[i]; Tp2 := 'Case:   ';
           For i := 7 to 22 do Tex[i] := Fil[1,i-6];
           For i := 23 to 38 do Tex[i] := Fil[2,i-22];
           For i := 39 to 44 do Tex[i] := Tp2[i-38];
           For i := 45 to 50 do Tex[i] := SetCase[i-44];
           Ptd(0.35,1.07,Wt,Tex,50);
           Tex := DumT; Tx := DumT;
           Tpx := 'x1 = '; Dec := DecF(x1); RealStr(Tx,x1,Dec,7);
           For i := 1 to 5 do Tex[i] := Tpx[i];
           For i := 6 to 12 do Tex[i] := Tx[i-5]; Tx := DumT;
           Tpx := 'x2 = '; Dec := DecF(x2); RealStr(Tx,x2,Dec,7);
           For i := 15 to 19 do Tex[i] := Tpx[i-14];
           For i := 20 to 26 do Tex[i] := Tx[i-19]; Tx := DumT;
           Tpx := 'x3 = '; Dec := DecF(x3); RealStr(Tx,x3,Dec,7);
           For i := 29 to 33 do Tex[i] := Tpx[i-28];
           For i := 34 to 40 do Tex[i] := Tx[i-33];
           Ptd(0.72,1.07,Wt,Tex,40); end; {If}
        Tp1 := Prog; Tp2 := Ed;
        Tex := DumT; For i := 1 to 14 do Tex[i] := Tp1[i];
        Ptd(0.72,0.99,Wt,Tex,14);
        Tex := DumT; Tex[1] := 'E'; Tex[2] := 'D'; Tex[3] := ':';
        For i := 4 to 11 do Tex[i] := Tp2[i-3];
        Ptd(0.88,0.99,Wt,Tex,11);
        If Device=Pscript then
           writeln(Fp,'/Helvetica-iso findfont 15 scalefont setfont');
        For k := 1 to Figmax do begin
            Tex := DumT;
            For i := 1 to maxFig do Tex[i] := Figstr[k,i];
            Ptd(0.0,-0.20-(k-1)*dY,Wt,Tex,maxFig); end;
      END; { Figtext }

   PROCEDURE Screen (Xax,Yax,Pat:integer);
     BEGIN
       Plotmenu(Xax,Yax,Pat); Xaxis(Xax); XLscale(Xax); Yaxis(Yax);
     END; {Screen}

   PROCEDURE PenScreen (Xax,Yax:integer);
     BEGIN
       Xaxis(Xax); XLscale(Xax); Yaxis(Yax);
     END; {PenScreen}

   PROCEDURE Curve(i:integer; Ypar:char);
     VAR  s,p,i1,i2 : integer;
          Yaxi,Xaxi,Xpb,Xpe,Ypb,Ype,Yep,Yl,Xl,Xbsp,Xesp,Ybsp,Yesp,
          Xbe,Dum,H1,H2,Z1,Z2,P1,P2,Q1,Q2,T1,T2,Pkw :real;
          FirstFlag : Boolean;
     BEGIN
      If Device=Pscript then writeln(Fp,'newpath':9);
      If ((ReCo='C') and (Device=Dpl)) then write(output,chr(27),'a');
      If ((ReCo='C') and (Device=Hpgl)) then write(Fp,'LT1,1;':5);
      If ((ReCo='C') and (Device=Pscript)) then begin
         writeln(Fp,'0.4 setlinewidth [2 2] 1 setdash'); end;
      Yaxi := Yscale.Yhigh-Yscale.Ylow;  Yl := Yscale.Ylow;
      Xaxi := Xscale.Xhigh-Xscale.Xlow;  Xl := Xscale.Xlow;
      With PltPost[i] do begin i1 := 0; i2 := 1; Yep := 0;
      For s := 1 to Smax do begin Xbe := Xbeg[s]; FirstFlag := true;
          If (Mark[s]='Cont        ') then FirstFlag := false;
          For p := 1 to Pmax[s] do begin
              Xbsp := Xbe;
              If RL[s]='L' then Xesp := Xbsp-PipePost[Pipe[s,p]].L
                           else Xesp := Xbsp+PipePost[Pipe[s,p]].L;
              Xbe := Xesp;
              If ReCo='C' then begin
                 H1 := Hcom[Pipe[s,p],i1]; H2 := Hcom[Pipe[s,p],i2];
                 Q1 := Qcom[Pipe[s,p],i1]; Q2 := Qcom[Pipe[s,p],i2];
                 T1 := Ttcom[Pipe[s,p],i1]; T2 := Ttcom[Pipe[s,p],i2];
                 Pkw := abs(Ra*(Q1+Q2)/2*Csp*(T1+T2)/2/1000); end
              else begin
                 H1 := Ht[Pipe[s,p],i1]; H2 := Ht[Pipe[s,p],i2];
                 Z1 := Pipepost[Pipe[s,p]].Zp[i1]; Z2 := Pipepost[Pipe[s,p]].Zp[i2];
                 Tempinit(Tt[Pipe[s,p],i1]);
                 P1 := Z1+Pipepost[Pipe[s,p]].dp*10**5/Ra/g;
                 Tempinit(Tt[Pipe[s,p],i2]);
                 P2 := Z2+Pipepost[Pipe[s,p]].dp*10**5/Ra/g;
                 Q1 := Qt[Pipe[s,p],i1]; Q2 := Qt[Pipe[s,p],i2];
                 T1 := Tt[Pipe[s,p],i1]; T2 := Tt[Pipe[s,p],i2];
                 Pkw := abs(Ra*(Q1+Q2)/2*Csp*(T1+T2)/2/1000); end;
              CASE Ypar OF
              'H': begin Ybsp := H1; Yesp := H2; end;
              'Z': begin Ybsp := Z1; Yesp := Z2; end;
              'L': begin Ybsp := P1; Yesp := P2; end;
              'Q': begin Ybsp := abs(Q1); Yesp := abs(Q2); end;
              'V': begin Ybsp := abs(Q1)/Api[Pipe[s,p]];
                         Yesp := abs(Q2)/Api[Pipe[s,p]]; end;
              'S': begin Ybsp := abs(H1-H2)/PipePost[Pipe[s,p]].L*1000;
                         Yesp := Ybsp; end;
              'T': begin Ybsp := T1; Yesp := T2; end;
              'P': begin Ybsp := Pkw; Yesp := Pkw; end;
              END;
              If Sign[s,p]<0 then begin
                 Dum := Ybsp; Ybsp := Yesp; Yesp := Dum; end;
              Xpb := (Xbsp-Xl)/Xaxi; Ypb := (Ybsp-Yl)/Yaxi;
              Xpe := (Xesp-Xl)/Xaxi; Ype := (Yesp-Yl)/Yaxi;
              If FirstFlag then begin 
                if Device=Pscript then begin
                  writeln(Fp,'stroke');                 
                  writeln(Fp,'newpath');                 
                  CASE Ypar OF
                    'H','Q','V','S','T','P': begin
                                               if (ThickH[s]>0) then  
                                                    writeln(Fp,ThickH[s]:7:3,' setlinewidth [] 0 setdash ',Rod[s]:7:3,Green[s]:7:3,Blue[s]:7:3,' setrgbcolor') 
                                               else 
                                                writeln(Fp,ThickH[s]:7:3,' setlinewidth [0 100] 0 setdash ',Rod[s]:7:3,Green[s]:7:3,Blue[s]:7:3,' setrgbcolor');
                                             end;          
                                        'Z': begin
                                               if (ThickZ[s]>0) then  
                                                    writeln(Fp,ThickZ[s]:7:3,' setlinewidth [5 5] 0 setdash ',Rod[s]:7:3,Green[s]:7:3,Blue[s]:7:3,' setrgbcolor')
                                               else 
                                                writeln(Fp,ThickZ[s]:7:3,' setlinewidth [0 100] 0 setdash ',Rod[s]:7:3,Green[s]:7:3,Blue[s]:7:3,' setrgbcolor');
                                             end;          
                                        'L': begin
                                               if (ThickL[s]>0) then  
                                                    writeln(Fp,ThickL[s]:7:3,' setlinewidth [5 5] 0 setdash ',Rod[s]:7:3,Green[s]:7:3,Blue[s]:7:3,' setrgbcolor')
                                               else 
                                                writeln(Fp,ThickL[s]:7:3,' setlinewidth [0 100] 0 setdash ',Rod[s]:7:3,Green[s]:7:3,Blue[s]:7:3,' setrgbcolor');
                                             end;          
                  END;
                end;
                Ptd(Xpb,Ypb,Mt,DumT,1);
              end;
{ Orig      If (abs(Ypb-Yep)>0.0001) then Ptd(Xpb,Ypb,Lt,DumT,1); }              
{ try       If (abs(Ypb-Yep)>Epsi) then Ptd(Xpb,Ypb,Lt,DumT,1);   }
{ Fix sf99. Back: Del next line. Del klammer }
              Ptd(Xpb,Ypb,Lt,DumT,1);
              FirstFlag := false;
              Ptd(Xpe,Ype,Lt,DumT,1); Yep := Ype;
            end; {For p} end; {For s} end; {With}
      If (Device=Dpl)  then write(output,chr(27),'`');
      If (Device=Hpgl) then writeln(Fp,'LT7;':4);
      If (Device=Pscript) then begin writeln(Fp,'stroke':7);
{}        writeln(Fp,'0.8 setlinewidth [] 0 setdash 0.0 0.0 0.0 setrgbcolor'); end;
     END; {Curve}

PROCEDURE Alarms(i:integer);
  VAR k : integer;
      Yaxi,Xaxi,Xp,Yp,Yl,Xl,dX,dY : real;
      Tex : Rstr;
  BEGIN
   If Device=Pscript then writeln(Fp,'newpath':9);
   Yaxi := Yscale.Yhigh-Yscale.Ylow; Yl := Yscale.Ylow;
   Xaxi := Xscale.Xhigh-Xscale.Xlow; Xl := Xscale.Xlow;
   dX := 0.010;
   With PltLarm[i] do
   For k := 1 to LarmMax do begin
       Xp := (Xlarm[k]-Xl)/Xaxi; Yp := (Head[k]-Yl)/Yaxi;
       Ptd(Xp-dX,Yp,Mt,DumT,1); Ptd(Xp+dX,Yp,Lt,DumT,1);
       If (HL[k]='H') then dY := 0.01 else dY := -0.035;
       Tex := DumT; Tex[1] := Lab[k,1]; Tex[2] := Lab[k,2];
       Ptd(Xp-dX,Yp+dY,Wt,Tex,2); Ptd(0,0,Mt,DumT,1); end;
       If (Device=Pscript) then begin writeln(Fp,'stroke':7); end;
  END;  {Alarms}

  PROCEDURE Gclear;
    BEGIN
      Write(output,chr(29):1,chr(27):1,chr(12):1);
    END;

 PROCEDURE InitScreen;
   BEGIN
    CASE ScreenTyp OF
     1: begin write(output,chr(27):1,'[?38h':5); end;     {Xterm}
     2: begin write(output,chr(27):1,')B':2);             {Tek4010}
              write(output,chr(27):1,'(G':2);        
              write(output,chr(29):1,chr(27):1,chr(12):1); end; 
   END;
 END;   {InitScreen}

 PROCEDURE InitPlotter;
  BEGIN
    CASE Plottyp OF
     1: begin writeln(Fp,'%!PS-Adobe-2.0');                 {Postscript}
              writeln(Fp,'%%BoundingBox: 58 73 567 772');
              writeln(Fp,'  1.00 1.00 scale  475 150 translate 90 rotate   % Format A4');
              writeln(Fp,'% 0.81 0.81 scale   50   0 translate  0 rotate   % WP,WORD..');
              writeln(Fp,'% 0.71 0.71 scale  200 150 translate  0 rotate   % Format A5');
              writeln(Fp,'% 0.50 0.50 scale  300 150 translate  0 rotate   % Format A6');
              writeln(Fp,'/reencdict 12 dict def /ReEncode { reencdict begin                              ');
              writeln(Fp,'/newcodesandnames exch def /newfontname exch def /basefontname exch def         ');
              writeln(Fp,'/basefontdict basefontname findfont def /newfont basefontdict maxlength dict def');
              writeln(Fp,'basefontdict { exch dup /FID ne { dup /Encoding eq                              ');
              writeln(Fp,'{ exch dup length array copy newfont 3 1 roll put }                             ');
              writeln(Fp,'{ exch newfont 3 1 roll put } ifelse } { pop pop } ifelse } forall              ');
              writeln(Fp,'newfont /FontName newfontname put newcodesandnames aload pop                    ');
              writeln(Fp,'128 1 255 { newfont /Encoding get exch /.notdef put } for                       ');
              writeln(Fp,'newcodesandnames length 2 idiv { newfont /Encoding get 3 1 roll put } repeat    ');
              writeln(Fp,'newfontname newfont definefont pop end } def                                    ');
              writeln(Fp,'/isovec [                                                                       ');
              writeln(Fp,'8#055 /minus 8#200 /grave 8#201 /acute 8#202 /circumflex 8#203 /tilde           ');
              writeln(Fp,'8#204 /macron 8#205 /breve 8#206 /dotaccent 8#207 /dieresis                     ');
              writeln(Fp,'8#210 /ring 8#211 /cedilla 8#212 /hungarumlaut 8#213 /ogonek 8#214 /caron       ');
              writeln(Fp,'8#220 /dotlessi 8#230 /oe 8#231 /OE                                             ');
              writeln(Fp,'8#240 /space 8#241 /exclamdown 8#242 /cent 8#243 /sterling                      ');
              writeln(Fp,'8#244 /currency 8#245 /yen 8#246 /brokenbar 8#247 /section 8#250 /dieresis      ');
              writeln(Fp,'8#251 /copyright 8#252 /ordfeminine 8#253 /guillemotleft 8#254 /logicalnot      ');
              writeln(Fp,'8#255 /hyphen 8#256 /registered 8#257 /macron 8#260 /degree 8#261 /plusminus    ');
              writeln(Fp,'8#262 /twosuperior 8#263 /threesuperior 8#264 /acute 8#265 /mu 8#266 /paragraph ');
              writeln(Fp,'8#267 /periodcentered 8#270 /cedilla 8#271 /onesuperior 8#272 /ordmasculine     ');
              writeln(Fp,'8#273 /guillemotright 8#274 /onequarter 8#275 /onehalf                          ');
              writeln(Fp,'8#276 /threequarters 8#277 /questiondown 8#300 /Agrave 8#301 /Aacute            ');
              writeln(Fp,'8#302 /Acircumflex 8#303 /Atilde 8#304 /Adieresis 8#305 /Aring                  ');
              writeln(Fp,'8#306 /AE 8#307 /Ccedilla 8#310 /Egrave 8#311 /Eacute                           ');
              writeln(Fp,'8#312 /Ecircumflex 8#313 /Edieresis 8#314 /Igrave 8#315 /Iacute                 ');
              writeln(Fp,'8#316 /Icircumflex 8#317 /Idieresis 8#320 /Eth 8#321 /Ntilde 8#322 /Ograve      ');
              writeln(Fp,'8#323 /Oacute 8#324 /Ocircumflex 8#325 /Otilde 8#326 /Odieresis 8#327 /multiply ');
              writeln(Fp,'8#330 /Oslash 8#331 /Ugrave 8#332 /Uacute 8#333 /Ucircumflex                    ');
              writeln(Fp,'8#334 /Udieresis 8#335 /Yacute 8#336 /Thorn 8#337 /germandbls 8#340 /agrave     ');
              writeln(Fp,'8#341 /aacute 8#342 /acircumflex 8#343 /atilde 8#344 /adieresis 8#345 /aring    ');
              writeln(Fp,'8#346 /ae 8#347 /ccedilla 8#350 /egrave 8#351 /eacute                           ');
              writeln(Fp,'8#352 /ecircumflex 8#353 /edieresis 8#354 /igrave 8#355 /iacute                 ');
              writeln(Fp,'8#356 /icircumflex 8#357 /idieresis 8#360 /eth 8#361 /ntilde 8#362 /ograve      ');
              writeln(Fp,'8#363 /oacute 8#364 /ocircumflex 8#365 /otilde 8#366 /odieresis 8#367 /divide   ');
              writeln(Fp,'8#370 /oslash 8#371 /ugrave 8#372 /uacute 8#373 /ucircumflex                    ');
              writeln(Fp,'8#374 /udieresis 8#375 /yacute 8#376 /thorn 8#377 /ydieresis] def               ');
              writeln(Fp,'/Helvetica /Helvetica-iso isovec ReEncode                                       ');
              writeln(Fp,'% End scandinavian character encoding     ');
              writeln(Fp,'/mt {380 mul exch 570 mul exch moveto} def');
              writeln(Fp,'/li {380 mul exch 570 mul exch lineto} def');
              writeln(Fp,'1.00 setlinewidth');
              writeln(Fp,'/Helvetica-iso findfont 12 scalefont setfont'); end;
     2: begin writeln(fp,'IN;':3,'PG;':3,'SP1;':4);      {Hpgl}
              writeln(Fp,'LT7;':4);
              writeln(Fp,'CS0;':4); end;
    END;
  END;    {InitPlotter}

  PROCEDURE ResetScreen;
   BEGIN
    CASE ScreenTyp OF
     1: begin 
       write(chr(27),']15;','black',chr(7)); 
     write(output,chr(27),chr(3)); end;            {Xterm}
     2: begin write(output,chr(24));                        {Tek4010}
              write(output,chr(27):1,chr(15)); end;
    END;
   END;   {ResetScreen}

  PROCEDURE ResetPlotter;
   BEGIN
    CASE Plottyp OF
     1: begin writeln(fp,'/Helvetica-iso findfont 10 scalefont setfont');
              writeln(fp,'0.000  1.070 mt (',datestr,') show');
              writeln(fp,'405 353 translate');            {PostScript}
              writeln(fp,'0.55 0.55 scale');
              writeln(fp,'(/home/hydroram/.xram08/logo04.eps) run');
              writeln(Fp,'%%Trailer');end;
     2: begin write(fp,'SP0;':4,'PG;':3); end;   {Hpgl}
    END;
   END;   {ResetPlotter}

   PROCEDURE PlotPaths;
     TYPE CuDraw = record Path,Xa : integer;
                          Yvar,ResComp : char; end;
     VAR DrawCu : array[1..maxPlt] of CuDraw;
         Com : char;
         Dummy,i,Xax,Yax,DcMax,Temp,k,PenX : integer;
         Menu : packed array[1..maxMe] of char;
         Dom : packed array[1..4] of char;
         Tex : Rstr;
         DxVec : array[1..maxXax] of integer;

     BEGIN
      writeln; Aclear;
      InitScreen; Device := Dpl; Dom := 'Do: ';
      For k := 1 to maxRstr do DumT[k] := ' ';
      For k := 1 to maxXax do DxVec[k] := 0;
      i := 1; Xax := 1; Yax := 1; DcMax := 0; Last := 'C'; ReCo := 'R';
      Screen(Xax,Yax,i); PenX := Xax; Last := 'P';
      {flush(output);}
      REPEAT
       Dummy := 1;
       REPEAT Tex := DumT; Ptd(0.4,0.99,Wt,Tex,6);
              For k := 1 to 4 do Tex[k] := Dom[k];
              Ptd(0.4,0.99,Wt,Tex,4);{ flush(output);} read(com);
              readln; com := Uchar(com);
       UNTIL (Com in ['P','X','Y','A','D','R','C','F','E']);
       CASE Com OF
       'P': begin Tex := DumT; Ptd(-0.14,1.10,Wt,Tex,MaxMe);
                  If i<Pltmax then i := i+1 else i := 1;
                  Menu := 'Path  '; Menu[maxMe] := PltPost[i].Path;
                  For k := 1 to maxMe do Tex[k] := Menu[k];
                  Ptd(-0.14,1.10,Wt,Tex,maxMe); Last := 'P'; end;
       'X': begin Tex := DumT; Ptd(-0.02,1.10,Wt,Tex,maxMe);
                  If Xax<Xaxmax then Xax := Xax+1 else Xax := 1;
                  Menu := 'Xax   '; Menu[maxMe] := XaxPost[Xax].Path;
                  For k := 1 to maxMe do Tex[k] := Menu[k];
                  Ptd(-0.02,1.10,Wt,Tex,maxMe); Last := 'X'; end;
       'Y': begin Tex := DumT; Ptd(0.10,1.10,Wt,Tex,MaxMe);
                  If Yax<Yaxmax then Yax := Yax+1 else Yax := 1;
                  Menu := 'Yax   '; Menu[maxMe] := YaxPost[Yax].Yvar;
                  For k := 1 to maxMe do Tex[k] := Menu[k];
                  Ptd(0.10,1.10,Wt,Tex,maxMe); Last := 'Y'; end;
       'A': begin Tex := DumT; Ptd(0.22,1.10,Wt,Tex,MaxMe);
                  If ReCo='R' then ReCo := 'C'else ReCo := 'R';
                  Menu := 'Alt   '; Menu[maxMe] := ReCo;
                  For k := 1 to maxMe do Tex[k] := Menu[k];
                  Ptd(0.22,1.10,Wt,Tex,maxMe); Last := 'A'; end;
       'D': begin CASE Last OF
              'A','P': begin Curve(i,YaxPost[Yax].Yvar);
                             If (Dcmax<(maxPlt-1)) then begin
                                Dcmax := Dcmax+1;
                                If (YaxPost[Yax].Yvar='H') then Alarms(i);
                                With DrawCu[Dcmax] do begin
                                Path := i; Xa := Xax; Yvar := YaxPost[Yax].Yvar;
                                ResComp := ReCo; end; end
                             else begin Gclear; Last := 'C';
                                Screen(Xax,Yax,i); PenX := Xax;
                                For k := 1 to maxXax do DxVec[k] := 0;
                                DcMax := 0; Last := 'P'; end; end;
                  'X': begin Xaxis(Xax); DxVec[Xax] := 1; end;
                  'Y': begin If (YaxPost[Yax].Yvar<>'Z') and (YaxPost[Yax].Yvar<>'L')
		         then begin Gclear; Last := 'C';
                             Screen(Xax,Yax,i);{end;} 
			      {else begin  Curve(i,YaxPost[Yax].Yvar);end;}
			      PenX := Xax;
                             For k := 1 to maxXax do DxVec[k] := 0;
                             DcMax := 0; Last := 'P'; end 
			     (*else begin
			      Curve(i,YaxPost[Yax].Yvar);PenX := Xax;
                             For k := 1 to maxXax do DxVec[k] := 0;
                             {DcMax := 0;} Last := 'P';*) 
                  else begin Curve(i,YaxPost[Yax].Yvar);
                             If (Dcmax<(maxPlt-1)) then begin
                                Dcmax := Dcmax+1;
                                If (YaxPost[Yax].Yvar='H') then Alarms(i);
                                With DrawCu[Dcmax] do begin
                                Path := i; Xa := Xax; Yvar := YaxPost[Yax].Yvar;
                                ResComp := ReCo; end; end
                             else begin Gclear; Last := 'C';
                                Screen(Xax,Yax,i); PenX := Xax;
                                For k := 1 to maxXax do DxVec[k] := 0;
                                DcMax := 0; Last := 'P'; end; end;
                  END; end;end;
       'R': begin write(output,chr(27):1,'x':1); Temp := 0;
                  CASE Last OF
              'A','P': begin If Dcmax>0 then begin
                                Curve(i,YaxPost[Yax].Yvar);
                                If(YaxPost[Yax].Yvar='H') then Alarms(i);
                                For k := 1 to Dcmax do begin
                                    With DrawCu[k] do
                                    If (Path=i) and (Yvar=YaxPost[Yax].Yvar)
                                       then begin Temp := k;
                                            DcMax := DcMax-1; end; end;
                                For k := Temp to DcMax do
                                    DrawCu[k] := DrawCu[k+1]; end; end;
              'x','X': begin If (DxVec[Xax]>0) then begin
                                Xaxis(Xax); DxVec[Xax] := 0; end; end;
                  'Y': begin Gclear; Last := 'C'; PenX := Xax;
                             Screen(Xax,Yax,i);
                             For k := 1 to maxXax do DxVec[k] := 0;
                             DcMax := 0; Last := 'P'; end;
                  END; write(output,chr(27):1,chr(96):1); end;
       'C': begin Gclear; Last := 'C'; Screen(Xax,Yax,i); PenX := Xax;
                  For k := 1 to maxXax do DxVec[k] := 0;
                  DcMax := 0; Last := 'P'; end;
{}     'F': begin {rewrite(Fp,Fil[6]);}
                  Connect(Fp,Fil[6],'W');
                  InitPlotter; Last := 'C';
                  If PlotTyp=1 then Device := Pscript;
                  If PlotTyp=2 then Device := Hpgl;
                  PenScreen(PenX,Yax); Last := 'P';
                  For k := 1 to DcMax do begin
                      With DrawCu[k] do begin ReCo := ResComp;
                      Curve(Path,Yvar);
                      If (Yvar='H') then Alarms(Path); end; end;
                  For k := 1 to maxXax do If DxVec[k]>0 then Xaxis(k);
                  FigText; ResetPlotter; Close(Fp);
                  Dummy := 0; end;
       'E': begin Dummy := 0;  end;
       END; {flush(output); }
       UNTIL (Dummy=0);
        Gclear; ResetScreen;{ flush(output);} {Close(Fs);} Aclear;
        If ((Device=Hpgl) or (Device=Pscript)) then begin writeln;
           writeln('Results printed to : ':30,Fil[6]:maxCh1); Stop; end;
     END;  {PlotPaths}

   PROCEDURE SetScales;
    VAR i : integer;
    BEGIN
     REPEAT Aclear;
      writeln('      Current Scale Setting for Yaxis are : '); writeln;
      writeln('      Line  Yvar   Ylow   Yincr   Yhigh'); writeln;
      For i := 1 to Yaxmax do begin  With YaxPost[i] do begin
          writeln(i:9,Yvar:6,Ylow:8:1,Yincr:8:2,Yhigh:8:1); end; end;
      writeln; writeln('Select Line, 0 for exit':40);
      i := LineNr(Yaxmax);
      If i>0 then begin With YaxPost[i] do begin
         REPEAT write(Yvar:18,' : ':3,'Ylow : ':8); Ylow := ReadRl;
         UNTIL not ReadError;
         REPEAT write('Yincr : ':29); Yincr := ReadRl;
         UNTIL not ReadError;
         REPEAT write('Yhigh : ':29); Yhigh := ReadRl;
         UNTIL not ReadError; end; end;
     UNTIL (i=0); 
    END;    {SetScales}

   PROCEDURE EditText(VAR f:text);
    VAR k,i : integer;
    BEGIN
     writeln(f,'Current Text is : '); writeln(f);
     For k := 1 to 2 do writeln(f,FigStr[k]); writeln;
     i := 1; write(f,i:1);
     For i := 2 to 70 do
         If (i mod 10)=0 then write(f,0:1) else write(f,'.':1);
     writeln(f);
     writeln(f,'Text can fill 2 lines with 70 characters per line incl blanks.');
     writeln(f,'Enter New Text by overwriting the Old. Return for Next Line.');
     writeln(f,chr(27),'[3;1H');
     For k := 1 to 2 do begin i := 0;
         WHILE ((i<70) and (not eoln(input))) do begin
               i := i+1; read(input,FigStr[k,i]); end;
         If k=1 then begin write(f,chr(27),'[5;1H');
                           readln(input); end; end;
     readln(input);
    END;    {EditText}

   PROCEDURE ReadComp;
    VAR  p,i1,i2,Pipemax,Connmax,Juncmax,Crossmax,Valvmax,Pumpmax,Submax,
         Drivmax,Boilermax,DumI : integer;
         DumR : real;
         DiffFlag : Boolean;
    BEGIN
         i1 := 0; i2 := 1; DiffFlag := false;
{         reset(f,Compfil);  }
         Connect(f,Fil[4],'R');
         read(f,DumR,DumR,DumI,Pipemax,Connmax,Juncmax,Crossmax);
         readln(f,Submax,Valvmax,Pumpmax,Drivmax,Boilermax);
         For p := 1 to Pipemax do begin
             read(f,Qcom[p,i1],Qcom[p,i2],Hcom[p,i1],Hcom[p,i2]);
             readln(f,DumR,DumR,Ttcom[p,i1],Ttcom[p,i2]); end;
         Close(f);
         If (Pipemax<>Pimax) then DiffFlag := true;
         If (Connmax<>Cnmax) then DiffFlag := true;
         If (Juncmax<>Jnmax) then DiffFlag := true;
         If (Crossmax<>Csmax) then DiffFlag := true;
         If (Submax<>Sumax)  then DiffFlag := true;
         If (Valvmax<>Vamax) then DiffFlag := true;
         If (Pumpmax<>Pumax) then DiffFlag := true;
         If (Drivmax<>Drmax) then DiffFlag := true;
         If (Boilermax<>Boilmax) then DiffFlag := true;
         If DiffFlag then begin writeln;
            writeln('Differencies observed!   Warning only!':53); end;
         writeln; writeln('Data read from ':30,Fil[4]:maxCh1); Stop;
    END;    {ReadComp}

    PROCEDURE EchoGraphNrs;
     VAR i,x,k : integer;
     BEGIN
      writeln('GRAPH-RELATED, NUMBERS OF':34); writeln;
      write('PlotPaths:':18,Pltmax:2,'(Dim:':6,maxPlt:2,')':1); 
      writeln('X-axis:':15,Xaxmax:2,'(Dim:':6,maxXax:2,')':1);
      writeln;
      writeln('Path':12,'Strokes':10,'Markers':10); writeln;
      For i := 1 to Pltmax do begin With PltPost[i] do begin 
          write(Path:10,Smax:10); k := 0;
          For x := 1 to Xaxmax do
             If Path=XaxPost[x].Path then k := XaxPost[x].Kmax;
          If k>0 then write(k:10) else write('-':10);  
      If i=1 then writeln('Strokes Dim:':20,maxS:4,'per PlotPath':13);
      If i=2 then writeln('Markers Dim:':20,maxK:4,'per X-axis':11);
      If i>2 then writeln;
      end; end;
      Stop;
     END; {Echographnumbers}
      
      PROCEDURE Graphmenu;
       VAR ch : char;
       BEGIN
        Aclear; writeln(Mmenu); writeln(Dash);
        writeln; writeln;
        writeln(' ':14,'Graphs of Steady Flow Results');
        writeln(' ':14,'-----------------------------');
        writeln;
        writeln(' ':14,'1 - Plot Results along defined Paths');
        writeln(' ':14,'2 - Set Scales for Y-axis');
        writeln(' ':14,'3 - Edit Text for Steady Flow Graph');
        writeln(' ':14,'4 - Read *.dum  for Alt Comparison');
        writeln(' ':14,'5 - Show Graph-related, Numbers of');
        writeln(' ':14,'0 - Return to Main Menu'); writeln;
        REPEAT
          write('Choice : ':14); read(ch); readln; ch := Uchar(ch);
        UNTIL (ord(ch)>47) and (ord(ch)<54) or (ch in MenuSet);
        If (ch in Menuset) then begin Choice := ch; Alt := 6; end
                           else begin Alt := ord(ch)-48; end;
        OldChoice := 'G';
       END;    {Graphmenu}

   BEGIN  { PlotResults }
       Plotdata; 
       i1 := 0; i2 := 1;
       For p := 1 to Pimax do begin
           Hcom[p,i1] := 0; Hcom[p,i2] := 0;
           Qcom[p,i1] := 0; Qcom[p,i2] := 0; end;
       REPEAT Graphmenu; Dummy := 1;
        CASE Alt OF
          0: begin Choice := 'X'; Dummy := 0; end;
          1: begin Aclear; PlotPaths;  end;
          2: begin Aclear; SetScales; end;
          3: begin Aclear; EditText(output);  end;
          4: begin ReadComp;  end;
          5: begin Aclear; EchoGraphNrs; end;
          6: begin Dummy := 0; end;
        END; {Case}
       UNTIL (Dummy=0);
      END; { Plotresults }

   PROCEDURE Prefile;
     VAR  i,j,k,s,l : integer;
     BEGIN
      If Closemax>0 then begin writeln;
         writeln('There are Closed Pipes in the Pipe System!'); Gerror; end;
      For i := 1 to Boilmax do With Boiler[i] do
          If ((Qbt=0) and (Avbp>0)) then begin writeln;
             write('Boiler':10,chr(Id div 100+65):3,Id mod 100:3);
             writeln('Checkvalve closed!  Warning only!':36); Stop; end;
      Connect(f,Fil[7],'W');
      writeln(f,Liqmax:6,Pimax:6,Exmax:6,HexPerfmax:6,Iomax:6,Cnmax:6);
      writeln(f,Csmax:6,Jnmax:6,Boilmax:6,RvPerfmax:6,Vamax:6,Vperfmax:6);
      writeln(f,Tabmax:6,Pumax:6,Pperfmax:6,Acmax:6,Sumax:6,AlarmMax:6);
      Aload := Aload-FaddA; Bload := Bload-FaddB; Cload := Cload-FaddC;
      Dload := Dload-FaddD; Eload := Eload-FaddE; Gload := Gload-FaddF;
      Aret := Aret-TaddA; Bret := Bret-TaddB; Cret := Cret-TaddC;
      Dret := Dret-TaddD; Eret := Eret-TaddE; Fret := Fret-TaddF;
      writeln(f,Patm,Crl,Tsur,Kfac,Ra,Ny,Hvap,Csp,Aload,Bload,Cload,Dload,Eload,Gload);
      writeln(f,Aret,Bret,Cret,Dret,Eret,Fret,FaddA,FaddB,FaddC,FaddD,FaddE,FaddF,TaddA,TaddB,TaddC,TaddD,TaddE,TaddF,x1,x2,x3);
      Aload := Aload+FaddA; Bload := Bload+FaddB; Cload := Cload+FaddC;
      Dload := Dload-FaddD; Eload := Eload-FaddE; Gload := Gload-FaddF;
      Aret := Aret+TaddA; Bret := Bret+TaddB; Cret := Cret+TaddC;
      Dret := Dret-TaddD; Eret := Eret-TaddE; Fret := Fret-TaddF;
      For j := 1 to maxXvar do begin
          For i := 1 to maxXF do write(f,xf[j,i]); writeln(f); end;
      For j := 1 to maxXvar do write(f,Fxmax[j]:6); writeln(f);
      For j := 1 to maxXvar do
          For i := 1 to FXmax[j] do begin write(f,FxPost[j,i].Fstr);
              For k := 1 to maxXF do write(f,FxPost[j,i].fx[k]);
              writeln(f); end;
      For i := 1 to Liqmax do With Liquid[i] do
          writeln(f,Temp,Dens,Spec,Pvap,Visc,Emodul);
      For i := 1 to Pimax do begin
          If abs(Ht[i,0])<1E-90 then Ht[i,0] := 0.0;
          writeln(f,Qt[i,0],Ht[i,0],Tt[i,0],Tt[i,1]); end;
      For i := 1 to Pimax do With PipePost[i] do begin
          writeln(f,Id:6,L,D,Ks,Zeta,Kval,Eth,Fprel,Zp[0],Zp[1],' ':1,dp,' ',Com); end;
      For i := 1 to Iomax do begin With IoPost[i] do begin
          writeln(f,BE,QP,Pi:6,Elev,Temp,Value); end; end;
      For i := 1 to Exmax do With ExPost[i] do
          writeln(f,Id:6,Href:4,Elev,pTo:6,pAv,Pfr:6,Qpo,Tpm,kAo,Qso,Tsm,sTo:5,sAv,sFr:5);
      For i := 1 to HexPerfmax do With HexPerf[i] do
          writeln(f,Href:4,Vexp,TL,AdTm,Aps);
      For i := 1 to Cnmax do  With CnPost[i] do
          writeln(f,Id:6,Elev,Pto:6,Ecod:6,Enr:6,Value,Pfr:6);
      For i := 1 to Jnmax do begin  With JnPost[i] do begin
          For j := 1 to 4 do write(f,p[j]:6,Vnr[j]:6); writeln(f);
          writeln(f,Id:6,Elev,Hjn,Tjn,ValveSum:4); end; end;
      For i := 1 to Csmax do begin  With CsPost[i] do begin
          For j := 1 to 8 do write(f,p[j]:6); writeln(f);
          write(f,Id:6,Vnr:6);
          If Vnr=0 then write(f,Cat,Fsum*Pnom);
          writeln(f,Hf,Hr,Qcs,Avmax,Tf,Tr,dTr); end; end;
      For s := 1 to Sumax do begin
          writeln(f,SubId[s]:6,Brmax[s]:5,Liomax[s]:5,Lexmax[s]:5,Lcnmax[s]:5,
                    Ljnmax[s]:5,Lcsmax[s]:5,Limax[s]:5);
          For i := 1 to Brmax[s] do With BorPost[s,i] do
              writeln(f,Id:6,Pi:6,Li:5);
          For i := 1 to Liomax[s] do begin With LioPost[s,i] do begin
              writeln(f,BE,QP,s:5,Li:5,Elev,Temp,Value); end; end;
          For i := 1 to Lexmax[s] do With LexPost[s,i] do
              writeln(f,su:5,eNr:5,Href:5,Elev,pTo:5,pAv,pFr:5,Qpo,Tpm,kAo,Qso,Tsm,sTo:5,sAv,sFr:5);
          For i := 1 to Lcnmax[s] do With LcnPost[s,i] do
              writeln(f,Id:5,Elev,Lto:5,Ecod:4,Enr:6,Value,Lfr:5);
          For i := 1 to Ljnmax[s] do begin With LjnPost[s,i] do begin
              For j := 1 to 4 do write(f,Li[j]:5,Vnr[j]:6); writeln(f);
              writeln(f,Id:5,Elev,Hljn,Tljn,ValveSum:4); end; end;
          For i := 1 to Lcsmax[s] do begin  With LcsPost[s,i] do begin
              For j := 1 to 8 do write(f,Li[j]:5); writeln(f);
              write(f,Id:6,Vnr:6);
              If Vnr=0 then write(f,Cat,Fsum*Pnom);
              writeln(f,Hf,Hr,Qcs,Avmax,Tf,Tr,dTr); end; end;
          For i := 1 to Limax[s] do begin  l := Lipek[s,i];
              If abs(Cpl[s,l])<1E-90 then Cpl[s,l] := 0.0;
              If abs(Cml[s,l])<1E-90 then Cml[s,l] := 0.0;
              writeln(f,l:5,Cpl[s,l],Cml[s,l],Tli[s,l]); end; end;
      For i := 1 to Boilmax do With Boiler[i] do begin 
          write(f,Id:6,Avboil,Tboil,MF,Wmax,Tpipe,Avbp,Tb,Qbt,RaCsp);
          writeln(f,Avres,' ',Com); end;
      For i := 1 to RvPerfmax do With RvPost[i] do
          writeln(f,A,B,C);
      For i := 1 to Vamax do begin With VrefPost[i] do begin
          If abs(H2vt[i])<1E-90 then H2vt[i] := 0;
          write(f,Id:6,S,Zv,Vref:5,Qvt[i],H1vt[i],H2vt[i],Tvt[i],' ');
          writeln(f,Com); end; end;
      For i := 1 to Vperfmax do With ValvePerf[i] do
          writeln(f,Vref:5,Vtyp:5,Avp,Avm,Smin,Smax);
      For i := 1 to Tabmax do begin writeln(f,TabNr[i]:5,Vimax[i]:5);
           For j := 1 to Vimax[i] do writeln(f,Vsl[i,j],Vfi[i,j],Vfl[i,j]); end;
      For i := 1 to Pumax do begin With PrefPost[i] do begin
          If abs(Qpt[i])<1E-90 then Qpt[i] := 0.0;
          If abs(H1pt[i])<1E-90 then H1pt[i] := 0.0;
          write(f,Id:6,Np,DrivePost[Drpek[DrId]].Nmot,DIx,Pref:5,YN,Avbv);
          write(f,DrivePost[Drpek[DrId]].Nmax,Qpt[i],H1pt[i],Tpt[i],' ');
          writeln(f,Com); end; end;
      For i := 1 to Pperfmax do begin With PumpNom[i] do begin
          writeln(f,Pref:5,Ptyp:5,Nnom,Hpqo,Pmek,Qnom,Hnom,Mnom,NHnom,RaNom);
          For j := 0 to maxAp do writeln(f,FH[i,j],FM[i,j],FN[i,j]);
          end; end;
      For i := 1 to Acmax do With AcPost[i] do
          writeln(f,Id:6,Atyp,Avp,Avm,Da,Za,Gvol,Npol,' ',Com);
      For i := 1 to AlarmMax do With AlarmPost[i] do
          writeln(f,Id:6,Zpi,bar,BE,HL,Lab); 
      writeln(f,VaCtrlmax:5,DrCtrlmax:5);
      For i := 1 to VaCtrlmax do With VaCtrl[i] do
          writeln(f,Dir,PiLi,SetValue,VaId:6,Code:3,p1:6,p2:6,i1:6,i2:6);
      For i := 1 to DrCtrlmax do With DrCtrl[i] do
          writeln(f,Dir,PiLi,SetValue,DrId:6,Code:3,p1:6,p2:6,i1:6,i2:6); 
      flush(f);  
      Close(f);
      writeln('Prepared Data written to : ':45,Fil[7]:maxCh1);
      Stop;
     END;   { Prefile }

   PROCEDURE MainMenu;
    BEGIN
     Aclear; writeln(Prog:27,'Edition ':17,Ed:8);
     writeln(Pro:53); writeln; write(' ':14,chr(67):1,chr(111):1);
     write(chr(109):1,chr(112):1,chr(105):1,chr(108):1,chr(101):1);
     write(chr(100):1,chr(32):1,chr(98):1,chr(121):1,chr(32):1);
{Compiled by }
     write(chr(72),chr(121),chr(100),chr(114),chr(111),chr(82));
     write(chr(97),chr(109),chr(32),chr(65),chr(66),chr(44));
{HydroRam AB,}     
     write(chr(32),chr(102),chr(111),chr(114),chr(32));
     write(chr(114),chr(101),chr(103));
     write(chr(105),chr(115),chr(116),chr(101),chr(114),chr(101));
     write(chr(100),chr(32),chr(117),chr(115),chr(101),chr(114));
     write(chr(115),chr(32),chr(111),chr(110),chr(108),chr(121));
{ for registered users only}
     write(chr(32),chr(32),chr(32),chr(32),chr(32),chr(32));
     write(chr(32),chr(32),chr(32),chr(32),chr(32),chr(32));
     write(chr(32),chr(32),chr(32),chr(32),chr(32),chr(32));
     writeln; writeln;
     writeln(' ':14,'Main Menu');
     writeln(' ':14,'---------');
     writeln;
     writeln(' ':14,'F - Files    : Designate Input/Output Files');
     writeln(' ':14,'R - Read     : Read Pipe System Configuration File');
     writeln(' ':14,'D - Display  : Display Pipe System Configuration');
     writeln(' ':14,'S - Set      : Set System Control Parameters');
     writeln(' ':14,'I - Init     : Change Initial Miscellaneous Data');
     writeln(' ':14,'C - Calcu    : Calculate Steady Flow Distribution');
     writeln(' ':14,'T - Tables   : Tables of Steady Flow Results');
     writeln(' ':14,'G - Graphs   : Graphs of Steady Flow Results');
     writeln(' ':14,'U - Update   : Update Prep File for Trans Flow');
     writeln(' ':14,'E - Exit     : Exit program');
     writeln;
     REPEAT
      write('Choice: ':14); read(Choice); readln; Choice := Uchar(Choice);
     UNTIL (Choice in MenuSet);
     OldChoice := 'X';
    END;    {MainMenu}

   BEGIN  { Program } 
      Res := Execute ('date +%Y > /tmp/date.txt');
      Res := Execute ('chmod -f ugo+w /tmp/date.txt');
      Res := Execute ('date +%Y > /tmp/date.txt');
      Res := Execute ('date +%m >> /tmp/date.txt');
      reset(f,utfil);
      readln(f,year);
      read(f,man);
      close(f);
      Res := Execute ('rm -f /tmp/date.txt');
      aclear;
      datum := year+man/12;
      datumlim := yearlimit+manlimit/12;
      if (datum > datumlim) then begin
       writeln(' ');
       writeln(' ');
       writeln(' ');
       writeln(' ');
       writeln('Giltighetstiden fr programmet har gtt ut.');
       writeln('Kontakta HydroRam AB');
       {Res := Execute ('rm -f /home/bag/bin/sf02.exe');
       Res := Execute ('echo "giltighetstden har gtt ut" >
       /home/bag/bin/sf02.exe');}
       Stop;   
       exit;
       end;
      if (datum > datumlim-1/12) then begin
       writeln(' ');
       writeln(' ');
       writeln(' ');
       writeln(' ');
       writeln('     Mindre n en mnad kvar p programmets giltighetstid');
       writeln('     Kontakta HydroRam AB');
       Stop;   
      end;
      InitFiles;  ConFlag := false; SetFlag := false; 
      ConvFlag := false; AlarmFlag := false; 
      Mtol := 20; Mctrl := 20; Mmin := 25;
      VaCtrlmax := 0; DrCtrlmax := 0; ManVaCtrl := 20;
      ManDrCtrl := 20; Dummy := 1; Choice := 'X'; SetCase := '------'; 
      NewCaseFlag := false; MenuSet := []; 
      MenuSet := ['X','E','F','R','D','S','I','C','T','G','U'];
      For i := 1 to maxClose do begin
          SelPipe[i] := 0; ExPipe[i] := 0; end;
      CloseMax := 0; EqList; CtrlList;
      REPEAT 
        CASE Choice OF
        'X': begin MainMenu; Dummy := 1; end;
        'F': begin IOfiles; Dummy := 1; end;
        'R': begin Config; Choice := OldChoice; Dummy := 1; end;
        'D': begin If OK(ConFlag) then begin Echoprint; end 
                                  else begin Stop; end; 
                   Dummy := 1; end; 
        'S': begin If OK(ConFlag) then begin Setsyst; end 
                                  else begin Stop; end; 
                   Dummy := 1; end; 
        'I': begin If OK(ConFlag) then begin Runset; end 
                                  else begin Stop; end; 
                   Dummy := 1; end; 
        'C': begin If OK(ConFlag) then begin Calculate; end 
                                  else begin Stop; end; 
                   Dummy := 1; end; 
        'T': begin If OK(ConFlag) then begin PrintResults; end
                                  else begin Stop; end;
                   Dummy := 1; end;
        'G': begin If OK(Conflag) then begin PlotResults; end
                                  else begin Stop; end;
                   Dummy := 1; end;
        'U': begin {If OK(CONVflag) then begin} Prefile;{ end 
                                   else begin Stop; end;} 
                 Choice := OldChoice; Dummy := 1; end; 
        'E': begin write('Do You really want to exit?  Y/N : ':53);
                   read(ch); readln; ch := Uchar(ch);
                   If ch='Y' then Dummy := 0
                      else begin Choice := OldChoice; Dummy := 1; end; end;
        END; { of Case } 
      UNTIL ( Dummy = 0 ); 
1: END.   { Program } 


