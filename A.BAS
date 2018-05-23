DECLARE SUB DRAWABS (vx1!, vx2!, vy1!, vy2!, px!, py!, angle!)
DECLARE SUB DRAWTRANS (vx1!, vx2!, vy1!, vy2!, px!, py!, angle!)
DECLARE SUB FPS (vx1!, vx2!, vy1!, vy2!, px!, py!, angle!)
DECLARE SUB INTERSECT (x1!, y1!, x2!, y2!, x3!, y3!, x4!, y4!, x!, y!)
SCREEN 7

'Wall Position
vx1 = 70: vy1 = 20
vx2 = 70: vy2 = 79

'Player Position
px = 50
py = 50
angle = 0


DO
 ' Draw absolute map
  CALL DRAWABS(vx1, vx2, vy1, vy2, px, py, angle)

 ' Draw transformed Map
  CALL DRAWTRANS(vx1, vx2, vy1, vy2, px, py, angle)


  CALL FPS(vx1, vx2, vy1, vy2, px, py, angle)
  SCREEN , , page%, 1 - page%: page% = 1 - page%
  WAIT &H3DA, &H8, &H8: WAIT &H3DA, &H8
                                     

  SELECT CASE INKEY$
    CASE CHR$(0) + "H": px = px + COS(angle): py = py + SIN(angle)
    CASE CHR$(0) + "P": px = px - COS(angle): py = py + SIN(angle)
    CASE CHR$(0) + "K": angle = angle - .1
    CASE CHR$(0) + "M": angle = angle + .1
    CASE "a", "A": px = px + SIN(angle): py = py - COS(angle)
    CASE "d", "D": px = px - SIN(angle): py = py + COS(angle)
    CASE "q", "Q", CHR$(27): EXIT DO
  END SELECT
                                                                                                                                                                                                                                                      

LOOP

SCREEN 0, 1, 0, 0: WIDTH 80, 25

DEF FNVECCROSS (x1, y1, x2, y2) = x1 * y2 - y1 * x2

SUB DRAWABS (vx1, vx2, vy1, vy2, px, py, angle)
  VIEW (4, 40)-(103, 140), 0, 1
  LINE (vx1, vy1)-(vx2, vy2), 14

  LINE (px, py)-(COS(angle) * 5 + px, SIN(angle) * 5 + py), 8
  PSET (px, py), 15
END SUB

SUB DRAWTRANS (vx1, vx2, vy1, vy2, px, py, angle)
 
  VIEW (109, 40)-(208, 140), 0, 2
  
  'p is fixed, calculate vertices
  tx1 = vx1 - px: ty1 = vy1 - py
  tx2 = vx2 - px: ty2 = vy2 - py

  'calculate L
  tz1 = tx1 * COS(angle) + ty1 * SIN(angle)
  tz2 = tx2 * COS(angle) + ty2 * SIN(angle)

  ' END Pos
  tx1 = tx1 * SIN(angle) - ty1 * COS(angle)
  tx2 = tx2 * SIN(angle) - ty2 * COS(angle)

  ' 50 is middle, Start Pos, End Pos
  LINE (50 - tx1, 50 - tz1)-(50 - tx2, 50 - tz2), 14

  LINE (50, 50)-(50, 45), 8
  PSET (50, 50), 15

END SUB

'First Person View
SUB FPS (vx1, vx2, vy1, vy2, px, py, angle)
  VIEW (214, 40)-(315, 140), 0, 3
  'relative to player
  tx1 = vx1 - px: ty1 = vy1 - py
  tx2 = vx2 - px: ty2 = vy2 - py
  'calculate L
  tz1 = tx1 * COS(angle) + ty1 * SIN(angle)
  tz2 = tx2 * COS(angle) + ty2 * SIN(angle)
  ' END Pos
  tx1 = tx1 * SIN(angle) - ty1 * COS(angle)
  tx2 = tx2 * SIN(angle) - ty2 * COS(angle)


  IF tz1 > 0 OR tz2 > 0 THEN
    'If Line Cross, fix it
    CALL INTERSECT(tx1, tz1, tx2, tz2, -.0001, .0001, -20, 5, ix1, iz1)
    CALL INTERSECT(tx1, tz1, tx2, tz2, .0001, .0001, 20, 5, ix2, iz2)
    IF tz1 <= 0 THEN IF iz1 > 0 THEN tx1 = ix1: tz1 = iz1 ELSE tx1 = ix2: tz1 = iz2
    IF tz2 <= 0 THEN IF iz1 > 0 THEN tx2 = ix1: tz2 = iz1 ELSE tx2 = ix2: tz2 = iz2
    
    
    x1 = -tx1 * 16 / tz1: y1a = -50 / tz1: y1b = 50 / tz1
    x2 = -tx2 * 16 / tz2: y2a = -50 / tz2: y2b = 50 / tz2

    LINE (50 + x1, 50 + y1a)-(50 + x2, 50 + y2a), 14
    LINE (50 + x1, 50 + y1b)-(50 + x2, 50 + y2b), 14
    LINE (50 + x1, 50 + y1a)-(50 + x1, 50 + y1b), 6
    LINE (50 + x2, 50 + y2a)-(50 + x2, 50 + y2b), 6
  END IF
END SUB

SUB INTERSECT (x1, y1, x2, y2, x3, y3, x4, y4, x, y)
  x = FNVECCROSS(x1, y1, x2, y2)
  y = FNVECCROSS(x3, y3, x4, y4)

  det = FNVECCROSS(x1 - x2, y1 - y2, x3 - x4, y3 - y4)
  x = FNVECCROSS(x, x1 - x2, y, x3 - x4) / det
  y = FNVECCROSS(x, y1 - y2, y, y3 - y4)

END SUB

