fn interpolacion Object_1 Interpol1 Interpol2 CP1 CP2 CP3= 
(



V1 = (CP2-CP1)
V2 = (CP3-CP2)

animate on
(
	for t in 0 to 100 by 1 do
	(
		at time t
		(
			Interpol1.pos = CP1 + ((normalize V1)*(((length V1)/100)*t))
			Interpol2.pos = CP2 + ((normalize V2)*(((length V2)/100)*t))
			V3 = (Interpol2.pos - Interpol1.pos)
			Object_1.pos = Interpol1.pos + ((normalize V3)*(((length V3)/100)*t))
		)
		
	)
)
)

point_1 = point wireColor:red position:[-60,0,0]
point_2 = point wireColor:red position:[0,50,20]
point_3 = point wireColor:red position:[60,0,0]

interpolacion_1 = point wireColor:red 
interpolacion_2 = point wireColor:red 

cubo = box wireColor: red width:7 length:7 height: 7




interpolacion cubo interpolacion_1 interpolacion_2 point_1.pos point_2.pos point_3.pos
