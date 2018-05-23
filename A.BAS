DECLARE SUB DRAWABS (vx1!, vx2!, vy1!, vy2!, px!, py!, angle!)
DECLARE SUB DRAWTRANS (vx1!, vx2!, vy1!, vy2!, px!, py!, angle!)
SCREEN 7

vx1 = 70: vy1 = 20
vx2 = 70: vy2 = 79

px = 50
py = 50
angle = 0


DO
 ' Draw absolute map
DRAWABS(vx1,vx2,vy1,vy2,px,py,angle)

 ' Draw transformed Map


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


SUB DRAWABS (vx1, vx2, vy1, vy2, px, py, angle)
  VIEW (4, 40)-(103, 140), 0, 1
  LINE (vx1, vy1)-(vx2, vy2), 14

  LINE (px, py)-(COS(angle) * 5 + px, SIN(angle) * 5 + py), 8
  PSET (px, py), 15
END SUB

SUB DRAWTRANS (vx1, vx2, vy1, vy2, px, py, angle)
 
  VIEW (109, 40)-(208, 140), 0, 2
  'Transform vertices
  tx1 = vx1 - px : ty1 = vy1-py
  tz1 = tx1 * COS(ANGLE)

  LINE (vx1, vy1)-(vx2, vy2), 14

  LINE (px, py)-(COS(angle) * 5 + px, SIN(angle) * 5 + py), 8
  PSET (px, py), 15

END SUB
