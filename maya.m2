-- Date: March 3, 2023
-- Dicsussion with Maya about find the defining ideals of weighted rational curves
-- P^1--->P(1^a,2^2) by embeddding P(1^a,2^2) into P^N via O(2) or something like that, 
-- and then pulling back the rational normal curve of given degree.


-------------------------------------------
-------------------------------------------
--- P^1 embedded into P(1,1,2,2) embededed into P4
-------------------------------------------
-------------------------------------------

--P1
S = QQ[s,t]

--P4
T = QQ[z_0..z_4]

--P(1,1,2,2)
W = QQ[x_0,x_1,y_0,y_1,Degrees=>{1,1,2,2}]

-- RNC of degree 4 in P^4 (P^1--->P^4)
RNC = ker map(S,T,matrix{{s^4,s^3*t,s^2*t^2,s*t^3,t^4}})

-- Weighted Ratonal curve degree "2" in P(1,1,2,2) (P^1--->P(1,1,2,2)
WRC = ker map(S,W,matrix{{s^2,s*t,s*t^3,t^4}})

-- Emebedding? of P(1,1,2,2) into P^4 by O(2)
f = map(W,T,matrix{{x_0^2,x_0*x_1,x_1^2,y_0,y_1}})

-- Pull back of RNC in P^4 allong the map f*:P(1,1,2,2)--->P^4
I = f(RNC)

I1 = (primaryDecomposition(I))#0 --- defines curve
I2 = (primaryDecomposition(I))#1 --- extra stuff
radical(I2)

-------------------------------------------
-------------------------------------------
--- P^1 embedded into P(1,1,1,2,2)
-------------------------------------------
-------------------------------------------

-- P^1
S = QQ[s,t]

-- P^7
T = QQ[z_0..z_7]

-- P(1,1,1,2,2)
W = QQ[x_0,x_1,x_2,y_0,y_1,Degrees=>{1,1,1,2,2}]

-- RC (not normal) of degree 6 in P^7 (P^1--->P^7) notice the non-standard ordering of variales
RC = ker map(S,T,matrix{{s^2*t^4,s^3*t^3,s^4*t^2,s^4*t^2,s^5*t,s^6,s*t^5,t^6}})

-- Weighted Ratonal curve degree "3" in P(1,1,1,2,2) (P^1--->P(1,1,1,2,2)
WRC = ker map(S,W,matrix{{s*t^2,s^2*t,s^3,s*t^5,t^6}})

-- Emebedding? of P(1,1,1,2,2) into P^7 by O(2)
f = map(W,T,matrix{{x_0^2,x_0*x_1,x_0*x_2,x_1^2,x_1*x_2,x_2^2,y_0,y_1}})

-- Pull back of RC in P^7 allong the map f*:P(1,1,1,2,2)--->P^7
I = f(RC)

I1 = (primaryDecomposition(I))#0
I2 = (primaryDecomposition(I))#1
radical(I2)

-- Maya's matrix
M = matrix {{x_2,x_0*x_1,x_0^2},{x_1,x_0^2,y_0},{x_0,y_0,y_1}}
J = minors(2,M)

J1 = (primaryDecomposition(J))#0 --- extra stuff
J2 = (primaryDecomposition(J))#1 --- defines curve
radical(J2)

-- Comparing Maya's ideal to the one I got
J2 == I1
