

m = 2
remainderLists = toList apply({0,0,0,0}..{m-1,m-1,m-1,m-1},i->i)

listToMatrix = L->(
    matrix{{L#0,L#1},{L#2,L#3}}
    )

remainderMatrices = m->(
    remainderLists = toList apply({0,0,0,0}..{m-1,m-1,m-1,m-1},i->i);
    apply(remainderLists,i->listToMatrix(i))
    )

S = QQ[a_1..a_4]


R 

determinantCondition = (m,R)->(
    quotientMatrix = m*matrix{{a_1,a_2},{a_3,a_4}};
    det(quotientMatrix+R)
    )

N = 5
searchRegion = N->(
    apply({-N,-N,-N,-N}..{N,N,N,N},i->matrix{i})
    ) 

isInGLZ = (L,f)->(
    val = sub(f,L);
    if val == 1 or val == -1 then return true
    else return false 
    )

checkMatrix = (search,f)->(
    i = 0;
    t = false;
    while i < #search and t == false do (
	t = isInGLZ(L,f);
	i = i+1;
	);
    t
    )


search = (m,N)->(
    matrices = remainderMatrices(m);
    search = searchRegion(N);
    delete(,apply(matrices,R->(
	   f = determinantCondition(m,R);
	   if checkMatrix(search,f) == true then R
	   )))
    )

-----------------
-----------------

matricesModM = (m,g)->(
    oneMatrixAsList = apply(g,i->(apply(g,j->1)));
    matricesAsLists = toList((0*oneMatrixAsList)..((m-1)*oneMatrixAsList));
    apply(matricesAsLists,L->matrix L)
    )

determinantPlusMinusOneModM = (m,M)->(
    det(M) % ideal(m) == 1 or det(M) % ideal(m) == -1
    )

imageOfReductionModM = (m,g)->(
    delete(,apply(matricesModM(m,g), M->(
		if determinantPlusMinusOneModM(m,M) == true then M
		)
	))
    )

sizeOfReductionImage = (m,g)->(
    #(unique imageOfReductionModM(m,g))
    )

matroidOrbitsModM = (m,M)->(
    g = numgens target M;
    L1 = apply(imageOfReductionModM(m,g),h->(
	    (h*M) % ideal(m)
	    ));
    unique L1
    )

H = new MutableHashTable
apply({2},g->(
	apply({2,3,4,5,6,7,8,9,10},m->(
		H#{g,m} = sizeOfReductionImage(m,g);
		print({g,m});
		))
	))
apply({3},g->(
	apply({2,3,4,5},m->(
		H#{g,m} = sizeOfReductionImage(m,g);
		print({g,m});
		))
	))
apply({4},g->(
	apply({3},m->(
		H#{g,m} = sizeOfReductionImage(m,g);
		print({g,m});
		))
	))

sizeOfMatroidOrbitsModM = (m,M)->(
    g = numgens target M;
    L1 = apply(imageOfReductionModM(m,g),h->(
	    (h*M) % ideal(m)
	    ));
    #(unique L1)
    )



-- cycle on 4 vertices
M1 = matrix {{1,0,0,-1},{-1,1,0,0},{0,-1,1,0}}

-- triangle with one tail
M2 = matrix {{1,0,-1,0},{-1,1,0,1},{0,-1,1,0}}


sizeOfMatroidOrbitsModM(4,M1)
sizeOfMatroidOrbitsModM(4,M2)
o11 = MutableHashTable{{2, 2} => 6     }
                       {2, 3} => 48
                       {2, 4} => 96
                       {2, 5} => 240
                       {2, 6} => 288
                       {2, 7} => 672
                       {2, 8} => 768
                       {2, 9} => 1296
                       {2, 10} => 1440
                       {3, 2} => 168
                       {3, 3} => 11232
                       {3, 4} => 86016
                       {3, 5} => 744000
                       {4, 2} => 20160
