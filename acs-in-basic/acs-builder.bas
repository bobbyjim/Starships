5 CL$ = "                                        "
10 CL$ = CL$ + "                                   "
15 V% = 200 : REM TONS
20 VN% = V% / 100
25 Z$ = "A" : REM MISSION
30 H$ = "B" : REM SIZE
35 G$ = "S" : REM CFG
40 M$ = "1" : REM MN 
45 J$ = "1" : REM JN
50 CR = 0 : REM MCR
55 VLOAD "PETFONT.BIN",8,1,0
60 POKE $9F36, 128
65 SC%(0) = 100 :REM DEFAULT
70 SC%(2) = 200 :REM EARLY
75 SC%(3) = 100 :REM STANDARD
80 SC%(6) = 100 :REM IMPROVED
85 SC%(8) = 100 :REM MODIFIED
90 SC%(9) = 200 :REM ADVANCED
95 SE%(0) = 100 :REM DEFAULT
100 SE%(2) = 110 :REM EARLY
105 SE%(3) = 100 :REM STANDARD
110 SE%(6) = 90  :REM IMPROVED
115 SE%(8) = 90  :REM MODIFIED
120 SE%(9) = 80  :REM ADVANCED
125 ST%(0) = 100 :REM DEFAULT
130 ST%(2) = 100 :REM EARLY
135 ST%(3) = 100 :REM STANDARD
140 ST%(6) = 100 :REM IMPROVED
145 ST%(8) = 50  :REM MODIFIED
150 ST%(9) = 33  :REM ADVANCED
155 COLOR 6,0
160 CLS
165 ?"     ";
170 ?"               AAA                  CCCCCCCCCCCCC   SSSSSSSSSSSSSSS 
175 ?"     ";
180 ?"              A:::A              CCC::::::::::::C SS:::::::::::::::S
185 ?"     ";
190 ?"             A:::::A           CC:::::::::::::::CS:::::SSSSSS::::::S
195 ?"     ";
200 ?"            A:::::::A         C:::::CCCCCCCC::::CS:::::S     SSSSSSS
205 ?"     ";
210 ?"           A:::::::::A       C:::::C       CCCCCCS:::::S            
215 ?"     ";
220 ?"          A:::::A:::::A     C:::::C              S:::::S            
225 ?"     ";
230 ?"         A:::::A A:::::A    C:::::C               S::::SSSS         
235 ?"     ";
240 ?"        A:::::A   A:::::A   C:::::C                SS::::::SSSSS    
245 ?"     ";
250 ?"       A:::::A     A:::::A  C:::::C                  SSS::::::::SS  
255 ?"     ";
260 ?"      A:::::AAAAAAAAA:::::A C:::::C                     SSSSSS::::S 
265 ?"     ";
270 ?"     A:::::::::::::::::::::AC:::::C                          S:::::S
275 ?"     ";
280 ?"    A:::::AAAAAAAAAAAAA:::::AC:::::C       CCCCCC            S:::::S
285 ?"     ";
290 ?"   A:::::A             A:::::AC:::::CCCCCCCC::::CSSSSSSS     S:::::S
295 ?"     ";
300 ?"  A:::::A               A:::::ACC:::::::::::::::CS::::::SSSSSS:::::S
305 ?"     ";
310 ?" A:::::A                 A:::::A CCC::::::::::::CS:::::::::::::::SS 
315 ?"     ";
320 ?"AAAAAAA                   AAAAAAA   CCCCCCCCCCCCC SSSSSSSSSSSSSSS   
325 ?""
330 ?""
335 ?"     ";
340 ?":::::::::  :::   ::: ::::::: :::      :::::::::  :::::::: ::::::::: 
345 ?"     ";
350 ?":+:    :+: :+:   :+:   :+:   :+:      :+:    :+: :+:      :+:    :+:
355 ?"     ";
360 ?"+:+    +:+ +:+   +:+   +:+   +:+      +:+    +:+ +:+      +:+    +:+
365 ?"     ";
370 ?"+#++:++#+  +#+   +:+   +#+   +#+      +#+    +:+ +#+:+#   +#++:++#: 
375 ?"     ";
380 ?"+#+    +#+ +#+   +#+   +#+   +#+      +#+    +#+ +#+      +#+    +#+
385 ?"     ";
390 ?"#+#    #+# #+#   #+#   #+#   #+#      #+#    #+# #+#      #+#    #+#
395 ?"     ";
400 ?"#########   #######  ####### ######## #########  ######## ###    ###
405    COLOR 2
410    ?:FOR X = 1 TO 80 :?CHR$(195); :NEXT
415    COLOR 5
420    ?:? SPC(32); "MENU"
425    ? CL$
430    ? "   A - ARMOR                C - COMPUTER" :REM D - DEFENSES
435    ? CL$
440    ? "   F - FUEL                 G - HULL CONFIG          H - HULL VOLUME
445    ? CL$
450    ? "   J - JUMP                 L - LIFE SUPPORT         M - MANEUVER
455    ? CL$
460    ? "   Z - MISSION              P - POWER                Q - QSP
465    ? CL$
470    ? CL$
475    ?
480    GET KK$ :IF KK$ = "" GOTO 480
485    LOCATE 30
490    FOR X = 1 TO 27 :?CL$ :NEXT X
495    LOCATE 31
500    IF KK$ = "A" THEN GOSUB 1245
505    IF KK$ = "C" THEN GOSUB 950
510    IF KK$ = "D" THEN GOSUB 920
515    IF KK$ = "F" THEN GOSUB 1125
520    IF KK$ = "G" THEN GOSUB 1270
525    IF KK$ = "H" THEN GOSUB 1295
530    IF KK$ = "J" THEN GOSUB 1010
535    IF KK$ = "L" THEN GOSUB 1350
540    IF KK$ = "M" THEN GOSUB 1065
545    IF KK$ = "Z" THEN GOSUB 1330
550    IF KK$ = "P" THEN GOSUB 1080
555    IF KK$ = "Q" THEN GOSUB 1210
560    IF KK$ = "S" THEN GOSUB 925
565    IF KK$ = "T" THEN GOSUB 1380
570    IF KK$ = "V" THEN GOSUB 1395
575    IF KK$ = "W" THEN GOSUB 930
580    GOSUB 595
585    GOSUB 770
590 GOTO 405
595 HR% = 1
600 H1% = 0
605 IF G$ = "C" THEN HR% = 2 
610 IF G$ = "B" THEN HR% = 3 
615 IF G$ = "U" THEN HR% = 3  : H1% = 2
620 IF G$ = "S" THEN HR% = 6  : H1% = 2
625 IF G$ = "A" THEN HR% = 7  : H1% = 2
630 IF G$ = "L" THEN HR% = 12 : H1% = 4
635 HC% = VN% * HR% + H1%
640 JN% = VAL(J$)
645 JV% =  5 + JN% * V%/40
650 IF JV% < 10 THEN JV% = 10
655 IF JN% = 0 THEN JV% = 0
660 JV% = JV% * ST%(JS%)/100
665 JC% = JV% * SC%(JS%)/100
670 MN% = VAL(M$)
675 MV% = -1 + MN% * V%/50
680 IF MV% < 2 THEN MV% = 2
685 IF MN% = 0 THEN MV% = 0
690 MC% = MV% * 2
695 PN% = JN%
700 IF MN% > PN% THEN PN% = MN%
705 PV% = 1 + PN% * VN% * 3/2 
710 IF PN% = 0 THEN PV% = 0
715 PV% = PV% * ST%(PS%)/100
720 PC% = PV% * SC%(PS%)/100
725 CR = HC% + JC% + MC% + PC%
730 CR = CR + E% + I% + B% + CC
735 FV% = JN% * VN% * 10  * SE%(JS%)/100
740 FV% = FV% + PN% * VN% * SE%(PS%)/100
745 BC% = 2 * (2 + (JV% + MV% + PV%)/35)
750 CH% = V% - PV% - MV% - JV% - FV%
755 CH% = CH% - E% - I% - B% - AV% - CT%
760 CH% = CH% - BC%
765 RETURN
770 ? CHR$(19);
775 FOR X = 1 TO 27 :?CL$ :NEXT X
780 ? CHR$(19);
785 COLOR 8
790 ? SPC(32); "ACS BUILDER" 
795 ?
800 ? "   ", Z$; "-"; H$; G$; M$; J$; "     MCR: "; CR
805 ? "   "
810 ? "   COMPUTER: MODEL/"; C$;C1$
815 ? "   ARMOR   : "; A$
820 ? "   FUEL    : "; FV%; "  SCOOPS: "; E$; "/"; I$; "/"; B$; " RFN: "; FR$
825 ? "   CARGO   : "; CH%
830 ? "   BRIDGE  : "; BC%; " TONS"
835 ? "   LIFE SUPPORT: "; L$
840 ? "   "
845 ? "   "
850 ? "   "
855 ? "   "
860 ? "   "
865 ? "   "
870 ? "   "
875 ? "   "
880 ? "   "
885 ? "   "
890 ? "   "
895 ? "   "
900 ? "   "
905 ? "   "
910 ? "   "
915 RETURN
920 RETURN
925 RETURN
930    ? "KEY IN WEAPON TYPE:"
935    GOSUB 1460
940    GET W$ :IF W$="" GOTO 940
945 RETURN
950    ? "KEY IN COMPUTER MODEL [0-9]: "
955    GET C$ :IF C$<"0" OR C$>"9" GOTO 955
960    ? "KEY IN BIS, FIB, OR NEITHER? [BFN]: "
965    GET C1$ 
970       IF C1$="B" THEN C1$="BIS" :GOTO 985
975       IF C1$="F" THEN C1$="FIB" :GOTO 985
980       IF C1$<>"N" GOTO 965
985    IF C1$="" THEN C1$=""
990    C% = VAL(C$)
995    CT% = C%
1000    CC  = C% + (C%+0.5)
1005 RETURN
1010    ? "KEY JUMP RATING [0-9]: ";
1015    GET J$ :IF J$ < "0" OR J$ > "9" GOTO 1015
1020    ?:?:? "KEY STAGE (A)DV (M)OD (I)MPV (S)TD (E)ARLY: ";
1025    GET JS$ 
1030       IF JS$="A" THEN JS% = 9 :RETURN
1035       IF JS$="M" THEN JS% = 8 :RETURN
1040       IF JS$="I" THEN JS% = 6 :RETURN
1045       IF JS$="S" THEN JS% = 3 :RETURN
1050       IF JS$="E" THEN JS% = 2 :RETURN
1055       GOTO 1025
1060 RETURN
1065    ? "KEY MANEUVER RATING [0-9]: ";
1070    GET M$ : IF M$ < "0" OR M$ > "9" GOTO 1070
1075 RETURN
1080    ?:?:? "KEY POWERPLANT STAGE (A)DV (M)OD (I)MPV (S)TD (E)ARLY: ";
1085    GET PS$ 
1090       IF PS$="A" THEN PS% = 9 :RETURN
1095       IF PS$="M" THEN PS% = 8 :RETURN
1100       IF PS$="I" THEN PS% = 6 :RETURN
1105       IF PS$="S" THEN PS% = 3 :RETURN
1110       IF PS$="E" THEN PS% = 2 :RETURN
1115       GOTO 1085
1120 RETURN
1125    ? "KEY IN NUMBER OF BINS   : [0-9]: ";
1130    GET B$ :IF B$<"0" OR B$>"9" GOTO 1130
1135    ?:?:? "KEY IN NUMBER OF INTAKES: [0-9]: ";
1140    GET I$ :IF I$<"0" OR I$>"9" GOTO 1140
1145    ?:?:? "KEY IN NUMBER OF SCOOPS : [0-9]: ";
1150    GET E$ :IF E$<"0" OR E$>"9" GOTO 1150
1155    ?:?:? "ADD REFINERIES? [YN] ";
1160    GET FR$ :IF FR$<>"N" AND FR$<>"Y" GOTO 1160
1165    E%  = VAL(E$)
1170    I%  = VAL(I$)
1175    B%  = VAL(B$)   
1180    IF FR$="N" THEN RETURN
1185    REM ADD REFINERY COST
1190    E% = E% * 2
1195    I% = I% * 2
1200    B% = B% * 2
1205 RETURN
1210 ? "CURRENT QSP: " Z$; "-"; H$; G$; M$; J$ 
1215 ?:GOSUB 1330 :?
1220 ?:GOSUB 1295  :?
1225 ?:GOSUB 1270 :?
1230 ?:GOSUB 1065 :?
1235 ?:GOSUB 1010 :?
1240 RETURN
1245    ? "KEY ARMOR LAYERS [1-9]: ";
1250    GET A$ :IF A$<"1" OR A$>"9" GOTO 1250
1255    A% = VAL(A$)
1260    AV% = (A%-1) * 4 * VN%
1265 RETURN
1270    ? "KEY HULL CONFIG [CBPUSAL]: ";
1275    GET G$
1280    IF G$>="A" AND G$<="C" THEN RETURN
1285    IF G$="P" OR G$="U" OR G$="S" OR G$="L" THEN RETURN
1290    GOTO 1275
1295    INPUT "INPUT HULL TONS (100-2400)"; V%
1300    IF V% < 100 OR V% > 2400 GOTO 1295
1305    VN% = V% / 100
1310    H$ = CHR$(64 + VN%)
1315    IF VN% > 8  THEN H$ = CHR$(64 + VN% +1) :REM I
1320    IF VN% > 14 THEN H$ = CHR$(64 + VN% +2) :REM O
1325 RETURN
1330    ? "KEY MISSION CODE [A-Z]: ";
1335    GET Z$
1340    IF Z$ < "A" OR Z$ > "Z" GOTO 1335
1345 RETURN
1350    ? "KEY IN (S)TD OR (L)ONG TERM: ";
1355    GET L$
1360       IF L$="S" THEN LS% = 21 :LT%=1 :RETURN
1365 	  IF L$="L" THEN LS% = 84 :LT%=2 :RETURN
1370 	  GOTO 1355
1375 RETURN
1380    INPUT "INPUT # OF STATEROOMS"; S%
1385    INPUT "INPUT # OF LOW BERTHS"; LB%
1390 RETURN
1395 RETURN
1400 READ D1
1405 FOR Y = 1 TO D1
1410    FOR X = 1 TO 7 :READ D2$ :NEXT X
1415 NEXT Y
1420 RETURN
1425 READ D1
1430 FOR Y = 1 TO D1
1435    READ D2$ :PRINT D2$; " - ";
1440    READ D2$ :PRINT D2$
1445    FOR X = 1 TO 5 :READ D2$ :NEXT X
1450 NEXT Y
1455 RETURN
1460    RESTORE
1465    GOSUB 1400
1470    GOSUB 1425
1475 RETURN
1480 DATA 1
1485 DATA  ST,  STANDARD,  0,  0, 100, 0, 1
1490 DATA 6
1495 DATA A, PARTICLE ACCELERATOR, 11, 0,1,0, 2.5
1500 DATA G, MESON GUN,            13, 0,1,0, 5
1505 DATA M, MISSILE,               8, 0,1,0, 0.2
1510 DATA J, MINING LASER,          8, 0,0,0, 0.5
1515 DATA K, PULSE LASER,           9, 0,0,0, 0.3
1520 DATA L, BEAM LASER,           10, 0,0,0, 0.5
