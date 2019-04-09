
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

Function Saltar Traveler Altura Inicio TiempoSalto = 
(
	
	CP_Array = $plataforma* as array -- creamos el array de puntos de control
	print CP_Array.count
	numSaltos  = CP_Array.count - 1
	tFin = (numSaltos * TiempoSalto)
	animationRange = interval 0 tFin
	tInicio = Inicio
	
	for i = 1 to numSaltos do(
		Cuadratica Traveler CP_Array[i].pos CP_Array[i+1].pos Altura tInicio (tInicio+TiempoSalto)
		tInicio = (tInicio+TiempoSalto)
	)
	
	
)

rollout Salto "Salto" width:300(
	
	label EActor "Actor:" 
	pickbutton UI_SelectorActor "Selecciona Actor"
	label EPath "Camino:"
	pickbutton UI_SelectorPath "Selecciona Camino"
	
	spinner UI_StartTime "Comienzo" range:[0,1000,0] type:#Integer
	spinner UI_JumpDuration "Duracion salto" range:[10,100,20] type:#Integer
	spinner UI_MaxSquash "Valor maximo de squash" range:[1,100,5] type:#Integer
	spinner UI_MaxStretch "Valor maximo de stretch" range:[1,100,5] type:#Integer	
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
		
		CreatePlatformsFromLine Path_		
			
	
		  if Traveler!= undefined do
		  (
			  deletekeys Traveler
			  Traveler.dir = [0,0,1]
			  
			  Saltar Traveler UI_AlturaSalto.value UI_StartTime.value UI_JumpDuration.value
			 -- Cuadratica Traveler P1.pos  P2.pos UI_AlturaSalto.value UI_StartTime.value (UI_StartTime.value+UI_JumpDuration.value)  

   	          --TODO Saltar (...)  
			  Traveler.showtrajectory = on
		  )
		  
    )
)

createdialog Salto