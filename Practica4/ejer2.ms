

cubo_1 = box wireColor: red width:7 length:7 height: 7
cubo_2 = box wireColor: red width:7 length:7 height: 7

ball = sphere radius:5 wireColor:blue

cubo_1.pos = [-40,0,0]
cubo_2.pos = [40,0,0]

animate on
(
	for t in 0 to 100 by 5 do
	(
		at time t
		(
			cubo_1.pos = cubo_1.pos + random [-7,-7,0] [7,7,0]
			cubo_2.pos = cubo_2.pos + random [-7,-7,0] [7,7,0]
			V1 = cubo_2.pos - cubo_1.pos
			longitud = length V1
			ball.pos = cubo_1.pos + ((normalize V1)*(longitud/2))
		)
		
	)
)


