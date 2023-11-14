extends Node2D

@export var texture:Texture2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	if(texture != null):
		print("Texture" + "\n\n")
		print(str(texture.get_size()) + "\n\n")
		var image:Image = texture.get_image()
		if(image != null):
			var array = [];
			print(str(image.get_size()) + "\n\n")
			for i in image.get_size().y:
				for j in  image.get_size().x:
					var color:Color = image.get_pixel(j, i)
					if(color.a != 0.0):
						array.append(Vector2(j, i))
			print("Total Points: " + str(array) + "\n\n")
			var outsidePointsArray = [];
			for i in array:
				if i.x == 0 || i.x == image.get_size().x - 1 || i.y == 0 || i.y == image.get_size().y - 1:
					outsidePointsArray.append(i)
				elif(_checkSurroundingPoints(array, i)):
					outsidePointsArray.append(i)
			print("Outline Points: " + str(outsidePointsArray) + "\n\n")
			var lazyStoreAllPoints = [];
			var largestSACount:int = 0;
			var curArraySize:int = 0;
			var largestSortedArray = [];
			var sortedPointArray = [];
			var junctBionPointsArray = [];
			var junctionAdded:int = 0;
			var begininingignigning:Vector2 = outsidePointsArray[0]
			var previousPoint:Vector2
			var i:int = 0
			while i < outsidePointsArray.size():
				if i == 0:
					sortedPointArray.append(outsidePointsArray[i])
				else:
					previousPoint = sortedPointArray[i + junctionAdded - 1]
					if(!_surroundPointsCheckAdd(previousPoint, sortedPointArray, junctBionPointsArray, outsidePointsArray)):
						#step 1 check if there are points in the junction point list that connect to the current point, if so we have a closed loop so we want to connect to that junction and check for points from there
						var previousJunctionSurround:bool = false;
						var possiblePreviousJunc = junctBionPointsArray.filter(func(junc):
							return true if junc[1] == previousPoint else false
							)
						if(possiblePreviousJunc != []):
							sortedPointArray.append(possiblePreviousJunc[0][0])
							previousPoint = possiblePreviousJunc[0][0]
						#step 2 we do a reverse search to look for a junction whos second point has been used, to make this the targt junction we revert too than move to the point, if we cant find one we revert to beginning and the next point is a new "loop"/"object"
						var targetJunction:Vector2 = Vector2(-1, - 1);
						var j:int = junctBionPointsArray.size() - 1
						while j > -1:
							if sortedPointArray.find(junctBionPointsArray[j][1]) == -1:
								targetJunction = junctBionPointsArray[j][0]
								j = -1
							j -= 1;
						if(targetJunction != Vector2(-1, -1)):#found target junction object continues
							while previousPoint != targetJunction:
								#first point from this array should be the point we go to next for the quickest return, it will also bridge one pixel gaps for us, which is why we are not just straight retracing our steps, but retracing with a surrounding points method
								var surroundingPoints = sortedPointArray.filter(func(point:Vector2):
									return _sortedPointFilter(point, previousPoint)
									)
								sortedPointArray.append(surroundingPoints[0])
								previousPoint = surroundingPoints[0]
								junctionAdded += 1
							#now we just redo the first part, surrounding points checker and adder 
							_surroundPointsCheckAdd(previousPoint, sortedPointArray, junctBionPointsArray, outsidePointsArray)
						else:#did not find target junction revert to beginning, next new point is a new "object"
							#return to begigingignigng of the one your own now
							while previousPoint != begininingignigning:
								var surroundingPoints = sortedPointArray.filter(func(point:Vector2):
									return _sortedPointFilter(point, previousPoint)
									)
								if(surroundingPoints[0] != begininingignigning):
									sortedPointArray.append(surroundingPoints[0])
								previousPoint = surroundingPoints[0]
								junctionAdded += 1
							var sACBuffer:int = max(largestSACount, i + 1 - largestSACount)
							if (sACBuffer != largestSACount):#latest buffer is bigger than the previous count, make the largest sort array equal to the new one
								largestSACount = sACBuffer
								largestSortedArray = sortedPointArray
							if(largestSACount > outsidePointsArray.size() - (i + 1)):#current largest count is greater than the rest of the points in the array, we have found the main pixels, quit
								i = outsidePointsArray.size()
							else:#there still could be a bigger array out there, search for it
								lazyStoreAllPoints.append(sortedPointArray)
								sortedPointArray = []
								junctionAdded = -i
								curArraySize = 0
								junctBionPointsArray = []
								#below filters array to find points that have not been used before, than it takes the first value from that array, could be done more efficiently im lazy
								var value = outsidePointsArray.filter(func(point):
									for lazyArray in lazyStoreAllPoints:
										if(lazyArray.find(point) == -1):
											return true
									return false
									)[0]
								#add first point of new blob to sortedpoint
								sortedPointArray.append(value)
								begininingignigning = value
						#remember to set beginingin to the new point in this else statement
				curArraySize += 1;
				i += 1;
			if(largestSortedArray == [] || curArraySize > largestSACount):
				largestSortedArray = sortedPointArray
			#tracing back to begingingin
			
			previousPoint = largestSortedArray[largestSortedArray.size() - 1]
			while previousPoint != begininingignigning:
				var surroundingPoints = largestSortedArray.filter(func(point:Vector2):
					return _sortedPointFilter(point, previousPoint)
					)
				if(surroundingPoints[0] != begininingignigning):
					largestSortedArray.append(surroundingPoints[0])
				previousPoint = surroundingPoints[0]
			print("Final Array: " + str(largestSortedArray))
			#remove points in a line, so that points with same vector are removed to reduce point amount
			var finalArray = largestSortedArray.filter(func(point):
				var pos:int = largestSortedArray.find(point)
				var firstVector:Vector2 = largestSortedArray[pos - 1 if pos - 1 != -1 else largestSortedArray.size() - 1] - point
				var secondVector:Vector2 = point - largestSortedArray[pos + 1 if pos + 1 != largestSortedArray.size() else largestSortedArray.size() - 1]
				if(secondVector == firstVector):
					return false
				return true
				)
			print("True Final: " + str(finalArray))
			
			var xDir:int = 0;
			var yDir = 0
			var adjustedForPixelArray = finalArray.map(func(point):
				var pos:int = finalArray.find(point)#current point position in array
				var possibleX:int = (point - finalArray[pos - 1 if pos - 1 != -1 else finalArray.size() - 1]).x
				if(possibleX > 0):
					xDir = 1
				elif(possibleX == 0):
					xDir = xDir
				elif(possibleX < 0):
					xDir = 0
				var possibleY:int = -(point - finalArray[pos - 1 if pos - 1 != -1 else finalArray.size() - 1]).y
				if(possibleY > 0):
					yDir = -1
				elif(possibleY == 0):
					yDir = yDir
				elif(possibleY < 0):
					yDir = 0
				var pointReturn:Vector2 = point
				pointReturn.x += xDir
				#pointReturn.y += yDir
				if(xDir == 1):
					print(pointReturn)
				return pointReturn
				)
				
			var realAdjustedForPixelProblem = Array()
			var previousNormal:Vector2 = Vector2(0,0)
			for index in finalArray.size():
				var ogPoint:Vector2 = finalArray[index]
				var currentX:int = (ogPoint - finalArray[index - 1 if index - 1 != -1 else finalArray.size() - 1]).x
				if(currentX != 0):
					currentX /= abs(currentX)
				var futureX:int = (finalArray[index + 1 if index + 1 != finalArray.size() else 0] - ogPoint).x
				if(futureX != 0):
					futureX /= abs(futureX)
				var currentY:int = (ogPoint - finalArray[index - 1 if index - 1 != -1 else finalArray.size() - 1]).y
				if(currentY != 0):
					currentY /= abs(currentY)
				var futureY:int = (finalArray[index + 1 if index + 1 != finalArray.size() else 0] - ogPoint).y
				if(futureY != 0):
					futureY /= abs(futureY)
				if(currentX > 0):
					if((futureY != previousNormal.y || currentY != previousNormal.y) && (futureY != 0)):
						xDir = 1
				elif(currentX == 0):
					xDir = xDir
				elif(currentX < 0):
					if((futureY != previousNormal.y || currentY != previousNormal.y) && futureY != 0):
						xDir = 0
					else:
						xDir = xDir
				if(currentY == 1 && index != 0 && futureX != previousNormal.x && futureX != 0):
					print("X = 0 in points: " + str(index) + " || OG POINT: " + str(ogPoint) + " || Future: " + str(futureY) + " || current: " + str(currentY) + " || previousNormal.y: " + str(previousNormal.y))
					yDir = 1
				
				#fix y a tiny bit, I dont know how, something with previous y and x youll figure it out, just notice right side slime descends in pixels too fast
				if(currentX != 0):
					previousNormal.x = currentX
				if(currentY != 0):
					previousNormal.y = currentY 
				ogPoint.x += xDir
				ogPoint.y += yDir
				realAdjustedForPixelProblem.append(ogPoint)
			
			print("Real Final" + str(realAdjustedForPixelProblem))
			
			var occluder:OccluderPolygon2D = OccluderPolygon2D.new()
			var packedVector:PackedVector2Array = PackedVector2Array(realAdjustedForPixelProblem)
			print(packedVector)
			occluder.polygon = packedVector
			occluder.resource_name = texture.resource_path.get_slice("/", texture.resource_path.get_slice_count("/") - 1).get_slice(".", 0)  + "_Occ"
			occluder.resource_path = "res://Assets/LightOccluder2d/" + occluder.resource_name + ".tres"
			print(occluder.resource_path)
			print(ResourceSaver.save(occluder, "res://Assets/LightOccluder2d/" + occluder.resource_name + ".tres"))
			
			
	elif(texture == null):
		print("Its null")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _checkSurroundingPoints(array, point:Vector2) -> bool: #returns true if there is a pixel next to the pixel that is open, which would mean it is on the outside of the object
	if(array.find(point - Vector2(1, 0)) == -1):
		return true
	elif(array.find(point - Vector2(-1, 0)) == -1):
		return true
	elif(array.find(point - Vector2(0, 1)) == -1):
		return true
	elif(array.find(point-Vector2(0, -1)) == -1):
		return true
	return false
	
func _checkSurroundFilter(point:Vector2, previousP:Vector2, checkPoint) -> bool:#for filter returns true if the point is next to previouspoint and not in sorted array
	var b:Vector2 = point - previousP
	if(((abs(b.x) == 1 && abs(b.y) == 1) || (abs(b.x) == 1 && b.y == 0) || (abs(b.y) == 1 && b.x == 0)) && checkPoint.find(point) == -1):
		return true
	else:
		return false
		
func _sortedPointFilter(point, previousPoint) -> bool:
	var b:Vector2 = point - previousPoint
	if((abs(b.x) == 1 && abs(b.y) == 1) || (abs(b.x) == 1 && abs(b.y) == 0) || (abs(b.x) == 0 && abs(b.y) == 1)):
		return true
	return false

func _surroundPointsCheckAdd(previousPoint:Vector2, pAddedArray, junctionPoints, nonSortedPoints) -> bool:
	var surroundingPoints = nonSortedPoints.filter(func(point:Vector2):
		return _checkSurroundFilter(point, previousPoint, pAddedArray)
		)
	if(surroundingPoints != []): 
		surroundingPoints.sort_custom(func(pointA, pointB): 
			var aDiffSquare:int = (int((pointA - previousPoint).y) + 1) * 3
			aDiffSquare +=  int((pointA - previousPoint).x) + 1 if aDiffSquare / 3 == 0 else -int((pointA - previousPoint).x) + 1
			var bDiffSquare:int = (int((pointB - previousPoint).y) + 1) * 3
			bDiffSquare += int((pointB - previousPoint).x) + 1 if bDiffSquare / 3 == 0 else -int((pointB - previousPoint).x) + 1
			if(aDiffSquare == 5):
				return false
			if(bDiffSquare == 5):
				return true
			return aDiffSquare < bDiffSquare
			)

		pAddedArray.append(surroundingPoints[0])
		for j in range(1, surroundingPoints.size()):
			var nonFound:bool = true
			if(junctionPoints != []):
				for c in junctionPoints.size():
					var curDifference = abs((previousPoint - surroundingPoints[j]).x) + abs((previousPoint - surroundingPoints[j]).y)
					if junctionPoints[c][1] == surroundingPoints[j]:
						var preDifference = abs((junctionPoints[c][0] - surroundingPoints[j]).x) + abs((junctionPoints[c][0] - surroundingPoints[j]).y)
						if(preDifference > curDifference):
							junctionPoints.remove_at(c)
							junctionPoints.insert(c, [previousPoint, surroundingPoints[j]])
						nonFound = false
			if(nonFound):
				junctionPoints.append([previousPoint, surroundingPoints[j]])
		return true
	else:
		return false
