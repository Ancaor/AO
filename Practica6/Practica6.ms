traveller_ = $Sphere001


fn GetVectorsAngle Va Vb =
(
	angle_ = acos(dot (normalize Va) (normalize Vb) )

	sign =  -1 * Va.x
	print sign
	
	if (sign < 0) then (
	  angle_ = -angle_;
)
		
	return angle_
)

Function getCollision t = 
(
	planoPro_ = normalize (plane_.pos - path_.pos)
	return IntersectRay plane_ (ray (at time t toFollow_.pos) planoPro_)
)

fn AssignFollowerToPath = (
	pc = Path_Constraint()
	toFollow_.pos.controller = pc
	pc.path = path_
	pc.follow = true
)

rollout Practica6 "Practica 6" (
	
	label EPlane "Plano:" 
	pickbutton UI_SelectorPlane "Selecciona Plano"
	label EPath "Camino:"
	pickbutton UI_SelectorPath "Selecciona Camino"
	spinner tStart_ "Comienzo" range:[0,1000,0] type:#Integer
	spinner tEnd_ "Final" range:[0,1000,1000] type:#Integer
	button UI_CrearAnimacion "Crear Animacion"
	
	on UI_SelectorPlane picked obj do
	(
		global plane_ = obj
		UI_SelectorPlane.text = obj.name
	)
	
	on UI_SelectorPath picked obj do
	(
		global path_ = obj
		UI_SelectorPath.text = obj.name
	)
	
	on UI_CrearAnimacion pressed do
	(
		
		if plane_ != undefined and path_ != undefined do(
			animate on
			(
				deleteKeys traveller_
				animationRange = interval tStart_.value tEnd_.value
				
				global toFollow_ = box length:20 width:20 height:20

				
				AssignFollowerToPath()
				
				
				for t in tStart_.value to tEnd_.value by 1 do(
					
					collision_ = getCollision t
					TravellerPos_ = collision_.pos + (collision_.dir * traveller_.radius)
					
					at time t traveller_.pos = TravellerPos_
						
					if t > tStart_.value do (
						
						if t < tEnd_.value then (
							nextCollision_ = getCollision (t+1)
							nextTravellerPos_ = nextCollision_.pos + (nextCollision_.dir * traveller_.radius)
						) else (
							nextCollision_ = getCollision tStart_.value
							nextTravellerPos_ = nextCollision_.pos + (nextCollision_.dir * traveller_.radius)
						)
						
						vect_ = nextTravellerPos_ - TravellerPos_
						vectDistance_ = Length vect_
						vecNormalized_ = vect_ / vectDistance_
						
						rotAxis_ = cross vecNormalized_ collision_.dir
						rotAngle_ = 360 * vectDistance_ / (traveller_.radius * 2 * pi)
						
						quaternion_ = quat rotAngle_ rotAxis_
						
						rotEuler_ = QuatToEuler quaternion_
						at time t rotate traveller_ rotEuler_
						
					)			
					
				)
				delete toFollow_
			)
			
		)
		
		
	)
	
)
createdialog Practica6
