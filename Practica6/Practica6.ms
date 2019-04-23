traveller_ = $Sphere001
toFollow_ = $Box001
plane_ = $Plane001

tStart_ = 0
tEnd_ = 300

animationRange = interval tStart_ tEnd_

Function getCollision t = 
(
	return IntersectRay plane_ (ray (at time t toFollow_.pos) [0,0,-1])
)

animate on
(
	for t in tStart_ to tEnd_ by 1 do(
		
		collision_ = getCollision t
		newTravellerPos_ = collision_.pos + (collision_.dir * traveller_.radius)
		
		at time t traveller_.pos = newTravellerPos_
		
	)
)