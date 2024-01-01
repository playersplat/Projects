Didn't write that many comments on the class function so I'm putting it here
-- the main function would be commented out though --
class BoundBox - It simply holds multiple lists of what method 1 and method 2 had detected ie.
	fullist - the fullbody \ upperlist - upperbody \ lowerlist - lowerbody \ peoplelist - the combined lists of the previous three after it has been passed through combineList

	clearBox(self): - clears the lists (fullList\upperList\lowerList\peopleList)

	checkBound(self): - two different approaches to check if the boxes either collide with each other or are a certain distant apart
		- the first if statement basically checks the sides of the boxes and sees if are in each other
		- the elif statement is simply the distance formula between the middle points of the boxes
		**changes i[4] if it passes an if statement... meaning the color of the boxes would change according to if the boxes collided or are nearby each other

	drawBody(self, image): - draws the rectangle surrounding the moving person, i[4] holds the color parameter 
		- it then appends the middle point of the box to a particleList that would be used later on
	
	drawSD(self, image): - draws the three letters on the top right. uses i[4] as a counter to see if people are following SD\violating it\ or possibly violating it

	drawParticle(self, image): - draws the a dot particle onto the image as it loops through the list
		
	addFull/addUpper/addLower/ - appends to the correct list

	removeMask(self, x, image): - simply blacks out a certain portion of the image to (0, 0, 0) so that the next call of a haarcascade would ignore that portion of the boundedboxes as it has already detected a person there

	combineList(self): - It combines the lists of fullList\upperList\lowerList\ into peopleList
		-it also checks to see if there are any duplicate boxes that are inside another bounded box and removes it


Approach: The way I combined method 1 and method 2 was that method 1 would run first. It then draws a mask (white boxes on a black background) on where the people would be. I then bitwise the original image onto that mask so that the only thing on the combined image would be the people. Method 2 then checks out those area as the rest is simply a black background. As Method 2 checks the combined image, it then 'de-masks' the areas it check meaning it draws a black rectangle onto the area it check so that the second call for the upperbody or lowerbody would skip that portion. Same thing happens again for the second call, it 'de-masks' the area to even simplify the search.

For counting people, I basically combined it with the distance check so that it would check to see if the boxes are close to each other at a certain distance or are touching. Then, my drawSD function would count the amount of people and assign them to the correct parameter ie (following SD\violating SD, etc)

For the tracking portion, everytime drawBody() gets called, it appends the middle coordinates of the box into a list. The list then gets used in drawParticle() to draw the dots. Along with that, the list has two extra spots x[3] and x[4]. x[3] is the radius of the circle and x[4] is a counter. Everytime drawParticle() gets called, the counter rises and once it reaches a certain number, the radius of the circle gets small and the counter resets.