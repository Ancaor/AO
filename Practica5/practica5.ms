
fn GetVectorsAngle v1 v2 =
(
theAngle =	(atan2 v2.y v2.x) - (atan2 v1.y v1.x)
return theAngle
)


fn CreatePlatformsFromLine Path_= 
(
	for s = 1 to (numsplines Path_) do
	(
		for k = 1 to (numknots Path_ s) do (
			VertexPos = (getKnotPoint Path_ s k)
			plataforma = Plane length:10 width:10 pos:[0,0,0]
			plataforma.pos = VertexPos
			plataforma.name = uniquename("plataforma")
				
		)
	)
)


fn SquashAndStretch Traveler T T_ini T_fin SquashStretch =
(
	Squash_val = SquashStretch 
	Stretch_val = SquashStretch 
	
	Squash_max = 1 + Squash_val
	Squash_min = 1 - Squash_val
	Stretch_max = 1 + Stretch_val
	Stretch_min = 1 - Stretch_val
	
	animate on 
	(
		at time (T_ini)
		(
			Traveler.scale = [Squash_max, Squash_max, Squash_min] --aplasta
		)
		at time (T_ini + (T / 8))
		(
			Traveler.scale = [1, 1, 1] --pos. original
		)
		at time (T_ini + (T / 4))
		(
			Traveler.scale = [Stretch_min, Stretch_min, Stretch_max] --estira
		)
		at time (T_ini + (T / 2))
		(
			Traveler.scale = [1, 1, 1] --pos. original
		)
		at time (T_fin - (T / 8))
		(
			Traveler.scale = [1, 1, 1] --pos. original
		)
	)
)




Function Lineal Traveler CP1  CP2 Inicio Fin   =
(
	VectorSalto =CP2-CP1
	
	animate on
	(
		at time 0
		(
			Traveler.pos=CP1
		)
		
		for t in Inicio to Fin by 1 do
		(
			at time t
			(
				Traveler.pos = CP1 + ((normalize VectorSalto)*(((length VectorSalto)/(Fin-Inicio))*(t-Inicio)))
			)
		)
		
	)
)

Function Cuadratica Traveler CP1 CP2 Altura Inicio Fin = 
(
	Interpolacion_1 = Point wirecolor:red
	Interpolacion_2 = Point wirecolor:red
	CP_ALTURA = Point wirecolor:red pos:[(CP1.x + CP2.x)/2,(CP1.y + CP2.y)/2,(CP1.z + CP2.z)/2 + Altura]
	Lineal Interpolacion_1 CP1 CP_ALTURA.pos Inicio Fin
	Lineal Interpolacion_2 CP_ALTURA.pos CP2 Inicio Fin
	
	
	
	animate on
	(
		at time Inicio
		(
			Traveler.pos=CP1
		)
		
		for t in Inicio to Fin by 1 do
		(
			at time t
			(
				VectorInterpolacion = Interpolacion_2.pos - Interpolacion_1.pos
				Traveler.pos = Interpolacion_1.pos + ((normalize VectorInterpolacion)*(((length VectorInterpolacion)/(Fin-Inicio))*(t-Inicio)))
			)
		)
		
	)
	delete Interpolacion_1
	delete Interpolacion_2
	delete CP_ALTURA

	
)

Function FinAnimacion Traveler T_ini T T_fin SquashStretch =
(
	Squash_val = SquashStretch 
	Stretch_val = SquashStretch 
	
	Squash_max = 1 + Squash_val
	Squash_min = 1 - Squash_val
	Stretch_max = 1 + Stretch_val
	Stretch_min = 1 - Stretch_val
	
	alturaSalto = 15
	
	animate on 
	(
		at time (T_ini)
		(
			Traveler.scale = [Squash_max, Squash_max, Squash_min] --aplasta
			rot_traveler = eulerangles 0 0 0
			rotate Traveler rot_traveler
		)
		at time (T_ini + (T / 8))
		(
			Traveler.scale = [1, 1, 1] --pos. original
		)
		at time (T_ini + (T / 4))
		(
			Traveler.scale = [Stretch_min, Stretch_min, Stretch_max] --estira
		)
		at time (T_ini + (T / 2))
		(
			Traveler.scale = [1, 1, 1] --pos. original
			Traveler.pos = [Traveler.pos.x, Traveler.pos.y,alturaSalto]
			rot_traveler = eulerangles 0 0 180
			rotate Traveler rot_traveler
		)
		at time (T_fin - (T / 7))
		(
		Traveler.scale = [1,1, 1] --pos. original

		)
		at time (T_fin - (T / 8))
		(
			Traveler.scale = [Squash_max, Squash_max, Squash_min] --squash
			Traveler.pos = [Traveler.pos.x, Traveler.pos.y,0]
			rot_traveler = eulerangles 0 0 180
			rotate Traveler rot_traveler
		)
		
		at time T_fin
		(
			Traveler.scale = [1,1, 1] --pos. original
			)
	)
	
)

Function Anticipacion Traveler PosActual PosSiguiente Vdireccion_Anterior TInicio TFin = 
(
	Vdireccion_Siguiente  = PosSiguiente - PosActual
	
	Angulo = GetVectorsAngle Vdireccion_Anterior Vdireccion_Siguiente
	
	animate on
	(
		
		at time TInicio
		(
			rot_traveler = eulerangles 0 0 0
			rotate Traveler rot_traveler
			Traveler.pos=PosActual
		)
		
		at time TFin
		(
			rot_traveler = eulerangles 0 0 Angulo
			rotate Traveler rot_traveler
		)
	)
	
	return Vdireccion_Siguiente
	
)

Function Saltar Traveler Altura Inicio TiempoSalto SquashStretch = 
(
	free CP_Array
	CP_Array  = #()
	CP_Array = $plataforma* as array -- creamos el array de puntos de control
	print "puntos de control : "
	print CP_Array.count
	numSaltos  = CP_Array.count - 1
	TiempoAnticipacion = 8
	TiempoFinAnimacion =35
	tFin = (numSaltos * (TiempoSalto + TiempoAnticipacion))
	animationRange = interval 0 (tFin+10+ TiempoFinAnimacion) 
	tInicio = Inicio
	Vdireccion_Anterior = [1,0,0]
	
	
	
	for i = 1 to numSaltos do(
		Vdireccion_Anterior = Anticipacion Traveler CP_Array[i].pos CP_Array[i+1].pos Vdireccion_Anterior tInicio (tInicio + TiempoAnticipacion)
		Cuadratica Traveler CP_Array[i].pos CP_Array[i+1].pos Altura (tInicio + TiempoAnticipacion) (tInicio + TiempoAnticipacion + TiempoSalto)
		SquashAndStretch Traveler TiempoSalto (tInicio + TiempoAnticipacion) (tInicio + TiempoAnticipacion + TiempoSalto) SquashStretch
		tInicio = (tInicio+TiempoSalto + TiempoAnticipacion)
	)
	
	FinAnimacion Traveler tInicio TiempoFinAnimacion (tInicio + TiempoFinAnimacion) SquashStretch
	
	 
	
	
)

rollout Salto "Salto" width:350(
	
	label EActor "Actor:" 
	pickbutton UI_SelectorActor "Selecciona Actor"
	label EPath "Camino:"
	pickbutton UI_SelectorPath "Selecciona Camino"
	
	spinner UI_StartTime "Comienzo" range:[0,1000,0] type:#Integer
	spinner UI_JumpDuration "Duracion salto" range:[10,100,20] type:#Integer
	spinner UI_MaxSquash "Valor maximo de squash and Stretch" range:[0.01,1.00,0.50] type:#Float
	spinner UI_AlturaSalto "Valor maximo de altura salto" range:[1,100,5] type:#Integer	
	button UI_CrearSalto "Crear"
	
	on UI_SelectorActor picked obj do
	(
		global Traveler = obj
		UI_SelectorActor.text = obj.name
	)
	
	on UI_SelectorPath picked obj do
	(
		global Path_ = obj
		UI_SelectorPath.text = obj.name
	)
	
	on UI_CrearSalto pressed do
	(
		if $plataforma001 == undefined do(
		CreatePlatformsFromLine Path_		
		)
	
		  if Traveler!= undefined do
		  (
			  deletekeys Traveler
			  Traveler.dir = [0,0,1]
			  
			  
			  Saltar Traveler UI_AlturaSalto.value UI_StartTime.value UI_JumpDuration.value UI_MaxSquash.value

			  
			  
			  Traveler.showtrajectory = on
		  )
		  
    )
)

createdialog Salto