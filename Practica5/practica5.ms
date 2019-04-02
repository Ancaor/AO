
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
		at time 0
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




rollout Salto "Salto" width:300(
	
	label EActor "Actor:" 
	pickbutton UI_SelectorActor "Selecciona Actor"
	label EP1 "P1:" 
	pickbutton UI_SelectorP1 "Selecciona P1"
	label EP2 "P2:" 
	pickbutton UI_SelectorP2 "Selecciona P2"
	
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
	on UI_SelectorP1 picked obj do
	(
		global P1 = obj
		UI_SelectorP1.text = obj.name
	)
	on UI_SelectorP2 picked obj do
	(
		global P2 = obj
		UI_SelectorP2.text = obj.name
	)
	
	on UI_CrearSalto pressed do
	(
		
		CP_Array = $Cylinder* as array -- creamos el array de puntos de control
		
		
		  if Traveler!= undefined   do -- and CP_Array .count >= 2 do
		  (
			  deletekeys Traveler
			  Traveler.dir = [0,0,1]
			  Cuadratica Traveler P1.pos  P2.pos UI_AlturaSalto.value UI_StartTime.value (UI_StartTime.value+UI_JumpDuration.value)  

   	          --TODO Saltar (...)  
			  Traveler.showtrajectory = on
		  )
    )
)

createdialog Salto