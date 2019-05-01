traveller_ = $Sphere001
toFollow_ = $Box001
plane_ = $Plane001
path_ = $Line001

tStart_ = 0
tEnd_ = 1000

animationRange = interval tStart_ tEnd_

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
	print "dasdsadsdadsdssjsjsjsjsjssjjjjjjjjjjjjjjjjjjjjjj"
	pc = Path_Constraint()
	toFollow_.pos.controller = pc
	pc.path = path_
	pc.follow = true
)

animate on
(
	deleteKeys traveller_
	animationRange = interval tStart_ tEnd_
	
	
	AssignFollowerToPath()
	
	
	for t in tStart_ to tEnd_ by 1 do(
		
		collision_ = getCollision t
		TravellerPos_ = collision_.pos + (collision_.dir * traveller_.radius)
		
		at time t traveller_.pos = TravellerPos_
			
		if t > tStart_ do (
			
			if t < tEnd_ then (
				nextCollision_ = getCollision (t+1)
				nextTravellerPos_ = nextCollision_.pos + (nextCollision_.dir * traveller_.radius)
			) else (
				nextCollision_ = getCollision tStart_
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
)