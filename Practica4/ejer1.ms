

function movimiento Traveler PosIni Xmax Tstart Tend= 
(
	animate on for t in Tstart to Tend by 5 do
	at time t 
		(
			porcentaje = (Float)(t - Tstart)/(Tend - Tstart)
			Traveler.pos = PosIni + porcentaje*[Xmax,0,0]
			Traveler.radius = 10 + 4 * sin (720 * porcentaje )
		)
)



ball = sphere radius:10 wireColor:blue
ball2 = sphere radius:10 wireColor:red
ball3 = sphere radius:10 wireColor:green
ball4 = sphere radius:10 wireColor:green
ball5 = sphere radius:10 wireColor:green
ball6 = sphere radius:10 wireColor:green
ball7 = sphere radius:10 wireColor:green

Xmax = 100.0

ball.pos=[0,-30,0]
ball2.pos = [0,0,0]
ball3.pos=[0,30,0]
ball4.pos=[0,60,0]
ball5.pos=[0,90,0]
ball6.pos=[0,120,0]
ball7.pos=[0,150,0]

deletekeys ball 
deletekeys ball2 
deletekeys ball3 

movimiento ball ball.pos Xmax 0 60
movimiento ball2 ball2.pos Xmax 20.0 80.0
movimiento ball3 ball3.pos Xmax 40.0 100.0
movimiento ball4 ball4.pos Xmax 60.0 120.0
movimiento ball5 ball5.pos Xmax 80.0 140.0
movimiento ball6 ball6.pos Xmax 100.0 160.0
movimiento ball7 ball7.pos Xmax 120.0 180.0
        