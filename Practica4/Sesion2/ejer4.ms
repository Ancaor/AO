fn interpolacion Object_1 Interpol1 Interpol2 Interpol3 Interpol4 Interpol5 CP1 CP2 CP3 CP4= 
(



V1 = (CP2-CP1)
V2 = (CP3-CP2)
V3 = (CP4 - CP3)

animate on
(
	for t in 0 to 100 by 1 do
	(
		at time t
		(
			Interpol1.pos = CP1 + ((normalize V1)*(((length V1)/100)*t))
			Interpol2.pos = CP2 + ((normalize V2)*(((length V2)/100)*t))
			Interpol3.pos = CP3 + ((normalize V3)*(((length V3)/100)*t))
			V4 = (Interpol2.pos - Interpol1.pos)
			V5 = (Interpol3.pos - Interpol2.pos)
			Interpol4.pos = Interpol1.pos + ((normalize V4)*(((length V4)/100)*t))
			Interpol5.pos = Interpol2.pos + ((normalize V5)*(((length V5)/100)*t))
			V6 = (Interpol5.pos - Interpol4.pos)			
			Object_1.pos = Interpol4.pos + ((normalize V6)*(((length V6)/100)*t))
		)
		
	)
)
)

point_1 = point wireColor:red position:[-60,0,0]
point_2 = point wireColor:red position:[-20,100,40]
point_3 = point wireColor:red position:[30,-100,-40]
point_4 = point wireColor:red position:[60,0,0]


interpolacion_1 = point wireColor:blue 
interpolacion_2 = point wireColor:blue 
interpolacion_3 = point wireColor:blue 
interpolacion_4 = point wireColor:green 
interpolacion_5 = point wireColor:green 


cubo = box wireColor: red width:7 length:7 height: 7




interpolacion cubo interpolacion_1 interpolacion_2 interpolacion_3 interpolacion_4 interpolacion_5 point_1.pos point_2.pos point_3.pos point_4.pos 