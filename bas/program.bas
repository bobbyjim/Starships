5 CL$ = "                                        "
10 CL$ = CL$ + "                                   "
15 V% = 200 : REM TONS
20 Z$ = "A" : REM MISSION
25 H$ = "B" : REM SIZE
30 G$ = "S" : REM CFG
35 M$ = "1" : REM MN 
40 J$ = "1" : REM JN
45 CR = 0 : REM MCR
50 VLOAD "PETFONT.BIN",8,1,0
55 POKE $9F36, 128
60 COLOR 6,0
65 CLS
70 ?"     ";
75 ?"               AAA                  CCCCCCCCCCCCC   SSSSSSSSSSSSSSS 
80 ?"     ";
85 ?"              A:::A              CCC::::::::::::C SS:::::::::::::::S
90 ?"     ";
95 ?"             A:::::A           CC:::::::::::::::CS:::::SSSSSS::::::S
100 ?"     ";
105 ?"            A:::::::A         C:::::CCCCCCCC::::CS:::::S     SSSSSSS
110 ?"     ";
115 ?"           A:::::::::A       C:::::C       CCCCCCS:::::S            
120 ?"     ";
125 ?"          A:::::A:::::A     C:::::C              S:::::S            
130 ?"     ";
135 ?"         A:::::A A:::::A    C:::::C               S::::SSSS         
140 ?"     ";
145 ?"        A:::::A   A:::::A   C:::::C                SS::::::SSSSS    
150 ?"     ";
155 ?"       A:::::A     A:::::A  C:::::C                  SSS::::::::SS  
160 ?"     ";
165 ?"      A:::::AAAAAAAAA:::::A C:::::C                     SSSSSS::::S 
170 ?"     ";
175 ?"     A:::::::::::::::::::::AC:::::C                          S:::::S
180 ?"     ";
185 ?"    A:::::AAAAAAAAAAAAA:::::AC:::::C       CCCCCC            S:::::S
190 ?"     ";
195 ?"   A:::::A             A:::::AC:::::CCCCCCCC::::CSSSSSSS     S:::::S
200 ?"     ";
205 ?"  A:::::A               A:::::ACC:::::::::::::::CS::::::SSSSSS:::::S
210 ?"     ";
215 ?" A:::::A                 A:::::A CCC::::::::::::CS:::::::::::::::SS 
220 ?"     ";
225 ?"AAAAAAA                   AAAAAAA   CCCCCCCCCCCCC SSSSSSSSSSSSSSS   
230 ?""
235 ?""
240 ?"     ";
245 ?":::::::::  :::   ::: ::::::: :::      :::::::::  :::::::: ::::::::: 
250 ?"     ";
255 ?":+:    :+: :+:   :+:   :+:   :+:      :+:    :+: :+:      :+:    :+:
260 ?"     ";
265 ?"+:+    +:+ +:+   +:+   +:+   +:+      +:+    +:+ +:+      +:+    +:+
270 ?"     ";
275 ?"+#++:++#+  +#+   +:+   +#+   +#+      +#+    +:+ +#+:+#   +#++:++#: 
280 ?"     ";
285 ?"+#+    +#+ +#+   +#+   +#+   +#+      +#+    +#+ +#+      +#+    +#+
290 ?"     ";
295 ?"#+#    #+# #+#   #+#   #+#   #+#      #+#    #+# #+#      #+#    #+#
300 ?"     ";
305 ?"#########   #######  ####### ######## #########  ######## ###    ###
310    COLOR 2
315    ?:FOR X = 1 TO 80 :?CHR$(195); :NEXT
320    COLOR 5
325    ?:? SPC(32); "MENU"
330    ? CL$
335    ? "   A - ARMOR                C - COMPUTER             D - DEFENSES
340    ? CL$
345    ? "   F - FUEL                 B - FUEL BINS            I - FUEL INTAKES
350    ? CL$
355    ? "   E - FUEL SCOOPS          G - HULL CONFIG          H - HULL VOLUME
360    ? CL$
365    ? "   J - JUMP                 L - LIFE SUPPORT         M - MANEUVER
370    ? CL$
375    ? "   Z - MISSION              P - POWER                Q - QSP
380    ? CL$
385    ? "   S - SENSORS              T - STATEROOMS           V - VEHICLES
390    ? CL$
395    ? "   W - WEAPONS
400    ? CL$
405    ?
410    GET KK$ :IF KK$ = "" GOTO 410
415    LOCATE 30
420    FOR X = 1 TO 27 :?CL$ :NEXT X
425    LOCATE 31
430    IF KK$ = "A" THEN GOSUB 985
435    IF KK$ = "C" THEN GOSUB 850
440    IF KK$ = "D" THEN GOSUB 820
445    IF KK$ = "F" THEN GOSUB 930
450    IF KK$ = "B" THEN GOSUB 935
455    IF KK$ = "I" THEN GOSUB 940
460    IF KK$ = "E" THEN GOSUB 945
465    IF KK$ = "G" THEN GOSUB 990
470    IF KK$ = "H" THEN GOSUB 1015
475    IF KK$ = "J" THEN GOSUB 895
480    IF KK$ = "L" THEN GOSUB 1070
485    IF KK$ = "M" THEN GOSUB 910
490    IF KK$ = "Z" THEN GOSUB 1050
495    IF KK$ = "P" THEN GOSUB 925
500    IF KK$ = "Q" THEN GOSUB 950
505    IF KK$ = "S" THEN GOSUB 825
510    IF KK$ = "T" THEN GOSUB 1075
515    IF KK$ = "V" THEN GOSUB 1080
520    IF KK$ = "W" THEN GOSUB 830
525    GOSUB 540
530    GOSUB 670
535 GOTO 310
540 HR% = 1
545 H1% = 0
550 IF G$ = "C" THEN HR% = 2 
555 IF G$ = "B" THEN HR% = 3 
560 IF G$ = "U" THEN HR% = 3  : H1% = 2
565 IF G$ = "S" THEN HR% = 6  : H1% = 2
570 IF G$ = "A" THEN HR% = 7  : H1% = 2
575 IF G$ = "L" THEN HR% = 12 : H1% = 4
580 HC% = VN% * HR% + H1%
585 JN% = VAL(J$)
590 JV% =  5 + JN% * V%/40
595 IF JV% < 10 THEN JV% = 10
600 IF JN% = 0 THEN JV% = 0
605 JC% = JV%
610 MN% = VAL(M$)
615 MV% = -1 + MN% * V%/50
620 IF MV% < 2 THEN MV% = 2
625 IF MN% = 0 THEN MV% = 0
630 MC% = MV% * 2
635 PN% = JN%
640 IF MN% > PN% THEN PN% = MN%
645 PV% = 1 + PN% * VN% * 3/2 
650 IF PN% = 0 THEN PV% = 0
655 PC% = PV%
660 CR = HC% + JC% + MC% + PC%
665 RETURN
670 ? CHR$(19);
675 FOR X = 1 TO 27 :?CL$ :NEXT X
680 ? CHR$(19);
685 COLOR 8
690 ? SPC(32); "ACS BUILDER" 
695 ?
700 ? "1   ", Z$; "-"; H$; G$; M$; J$; "     MCR: "; CR
705 ? "2   "
710 ? "3   COMPUTER: MODEL/"; C$;C1$
715 ? "4   "
720 ? "5   "
725 ? "6   "
730 ? "7   "
735 ? "8   "
740 ? "9   "
745 ? "0   "
750 ? "1   "
755 ? "2   "
760 ? "3   "
765 ? "4   "
770 ? "5   "
775 ? "6   "
780 ? "7   "
785 ? "8   "
790 ? "9   "
795 ? "0   "
800 ? "1   "
805 ? "2   "
810 ? "3   "
815 RETURN
820 RETURN
825 RETURN
830    ? "KEY IN WEAPON TYPE:"
835    GOSUB 1145
840    GET W$ :IF W$="" GOTO 840
845 RETURN
850    ? "KEY IN COMPUTER MODEL [0-9]: "
855    GET C$ :IF C$<"0" OR C$>"9" GOTO 855
860    ? "KEY IN BIS, FIB, OR NEITHER? [BFN]: "
865    GET C1$ 
870       IF C1$="B" THEN C1$="BIS" :RETURN
875       IF C1$="F" THEN C1$="FIB" :RETURN
880       IF C1$<>"N" GOTO 865
885    C1$=""
890 RETURN
895    ? "KEY JUMP RATING (0-9): ";
900    GET J$ : IF J$ < "0" OR J$ > "9" GOTO 900
905 RETURN
910    ? "KEY MANEUVER RATING (0-9): ";
915    GET M$ : IF M$ < "0" OR M$ > "9" GOTO 915
920 RETURN
925 RETURN
930 RETURN
935 RETURN
940 RETURN
945 RETURN
950 ? "CURRENT QSP: " Z$; "-"; H$; G$; M$; J$ 
955 ?:GOSUB 1050 :?
960 ?:GOSUB 1015  :?
965 ?:GOSUB 990 :?
970 ?:GOSUB 910 :?
975 ?:GOSUB 895 :?
980 RETURN
985 RETURN
990    ? "KEY HULL CONFIG [CBPUSAL]: ";
995    GET G$
1000    IF G$>="A" AND G$<="C" THEN RETURN
1005    IF G$="P" OR G$="U" OR G$="S" OR G$="L" THEN RETURN
1010    GOTO 995
1015    INPUT "INPUT HULL TONS (100-2400)"; V%
1020    IF V% < 100 OR V% > 2400 GOTO 1015
1025    VN% = V% / 100
1030    IF VN% > 14 THEN VN% = VN% + 1 :REM O
1035    IF VN% > 8  THEN VN% = VN% + 1 :REM I
1040    H$ = CHR$(64 + VN%)
1045 RETURN
1050    ? "KEY MISSION CODE [A-Z]: ";
1055    GET Z$
1060    IF Z$ < "A" OR Z$ > "Z" GOTO 1055
1065 RETURN
1070 RETURN
1075 RETURN
1080 RETURN
1085 READ D1
1090 FOR Y = 1 TO D1
1095    FOR X = 1 TO 7 :READ D2$ :NEXT X
1100 NEXT Y
1105 RETURN
1110 READ D1
1115 FOR Y = 1 TO D1
1120    READ D2$ :PRINT D2$; " - ";
1125    READ D2$ :PRINT D2$
1130    FOR X = 1 TO 5 :READ D2$ :NEXT X
1135 NEXT Y
1140 RETURN
1145    RESTORE
1150    GOSUB 1085
1155    GOSUB 1110
1160 RETURN
1165 DATA 1
1170 DATA  ST,  STANDARD,  0,  0, 100, 0, 1
1175 DATA 6
1180 DATA A, PARTICLE ACCELERATOR, 11, 0,1,0, 2.5
1185 DATA G, MESON GUN,            13, 0,1,0, 5
1190 DATA M, MISSILE,               8, 0,1,0, 0.2
1195 DATA J, MINING LASER,          8, 0,0,0, 0.5
1200 DATA K, PULSE LASER,           9, 0,0,0, 0.3
1205 DATA L, BEAM LASER,           10, 0,0,0, 0.5
