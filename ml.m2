
loadPackage "VirtualResolutions"


--- paper: A proof of a conjecture by Monin and Rana on equations defining \overline{M}_{0,n}
--- authors: Maria Gillespie, Sean T. Griffin, Jake Levinson
--- arxiv: https://arxiv.org/abs/2209.06688

iteratedProduct = L->(
    X := toricProjectiveSpace(L#0);
    apply(drop(L,1),i->(
	    X = X**toricProjectiveSpace(i)
	    ));
    X
    )

--n = 3
--L = toList(1..n)
--X = iteratedProduct(L)
--S = ring X

dotProductList = (L1,L2)->(
    (flatten entries ((matrix {L1}) *transpose matrix {L2}))#0
    )

varsHashTable = (n,S) ->(
    H := new MutableHashTable;
    apply(flatten entries vars S, f->(
	    deg := dotProductList(degree f,toList(1..n));
	    if H#?deg == true then H#deg = H#deg|{f};
	    if H#?deg == false then H#deg = {f};
	    ));
    new HashTable from pairs(H)
    )

--varsHashTable(n,S)

matIJ = (i,j,n,S) ->(
    H := varsHashTable(n,S);
    topRow := apply(i+1, k->(
	    f := H#i#k;
	    f*(H#j#k-H#j#(i+1))
	    ));
    bottomRow := apply(i+1,k->(H#j#k));
    matrix {topRow,bottomRow}
    )

--i = 1
--j = 2
--matIJ(i,j,n,S)

distinctIndices = n -> (
    flatten apply(toList(1..n),j->apply(toList(1..(j-1)),i->({i,j})))
    )

matricesM0n = (n,S) ->(
    ind := distinctIndices(n);
    apply(ind,L->(
	    matIJ(L#0,L#1,n,S)
	    ))
    )

idealM0n = (n,S) ->(
    matrices := matricesM0n(n,S);
    sum(matrices, M -> minors(2,M))
    )

--idealM0n(n,S)

constructM0n = (n) ->(
    X = iteratedProduct(toList(1..n));
    S = ring X;
    idealM0n(n,S)
    )

ithBasis = (i,n) ->(
    flatten entries id_(ZZ^n)^{i-1}
    )

gglRing = (n) ->(
    if n == 3 then (
	var := {x_{b},x_{c},y_{b},y_{c},y_{1},z_{b},z_{c},z_{1},z_{2}};
	degs := toList(2:{1,0,0})|toList(3:{0,1,0})|toList(4:{0,0,1});
	);
    if n != 3 then (
	var = flatten apply(toList(1..n),i->(
		{y_{i,b},y_{i,c}}|apply(toList(1..i-1),j->y_{i,j})
		));
	degs = flatten apply(toList(1..n),i->(
		apply(toList(0..i),j->ithBasis(i,n))
		));
	);
    QQ[var,Degrees=>degs]
    )

--gglRing(3)
--gglRing(4)

toricToGGLMap = (n,S) ->(
    R := gglRing(n);
    L := flatten entries vars R;
    map(R,S,L)
    )


--I = constructM0n(4)
--f = toricToGGLMap(3,S)
--mat = matricesM0n(4,S)
--apply(mat,M->f(M))
--f(I)

resOfMatricesM0n = (n) ->(
    X = iteratedProduct(toList(1..n));
    S = ring X;
    ideals := apply(matricesM0n(n,S),M->minors(2,M));
    apply(ideals,J->res J)
    )

bettiOfMatricesM0n = (n) ->(
    apply(resOfMatricesM0n(n),C->betti C)
    )

bettiWithInd = (n) ->(
    X = iteratedProduct(toList(1..n));
    S = ring X;
    ind := distinctIndices(n);
    mat := apply(ind,L->(
	    {{L#0,L#1,n},matIJ(L#0,L#1,n,S)}
	    ));
    apply(mat,L->(
	    I := minors(2,L#1);
	    {L#0,betti res I}
	    ))
    )

I = constructM0n(2) -- P1 x P2
betti res I
multigradedRegularity(S,I)
--{{0, 1}}

-*
             0 1
o79 = total: 1 1
          0: 1 .
          1: . .
          2: . 1
	  
         0   1
o80 = 0: 1   .
      3: . ab2	 
*- 
	  
I = constructM0n(3) --P1 x P2 x P3
betti res I
multigradedRegularity(S,I)
--{{0, 1, 2}, {0, 2, 1}}
virtualOfPair(I,{{0,2,1}})
-*
virtualOfPair({0,1,2})
         0    1
o86 = 0: 1    .
      3: . 3bc2
virtualOfPair({0,2,1})     
    0
o88 = 0: 1    


S/I
            0 1  2  3  4 5 6
o73 = total: 1 5 14 20 15 6 1
          0: 1 .  .  .  . . .
          1: . .  .  .  . . .
          2: . 5  1  .  . . .
          3: . .  3  .  . . .
          4: . . 10 20 15 6 1
	  
          0            1                   2                        3                    4             5     6
o74 =  0: 1            .                   .                        .                    .             .     .
       3: . ab2+ac2+3bc2                   .                        .                    .             .     .
       4: .            .                 bc3                        .                    .             .     .
       5: .            .         2ab2c2+b2c3                        .                    .             .     .
       6: .            . 3ab3c2+4ab2c3+3abc4                        .                    .             .     .
       7: .            .                   . ab4c2+9ab3c3+9ab2c4+abc5                    .             .     .
       8: .            .                   .                        . 3ab4c3+9ab3c4+3ab2c5             .     .
       9: .            .                   .                        .                    . 3ab4c4+3ab3c5     .
      10: .            .                   .                        .                    .             . ab4c5
*-

-- GUESS: {{0,1,2,3}, {0,1,3,2} {0,2,1,3}, {0,3,1,2}. {0,2,3,1}, {0,3,2,1}}
I = constructM0n(4) --P1 x P2 x P3 x P4
multigradedRegularity(S,I)
y
M = S^1/I
isQuasiLinear({0,1,2,3},M)


bettiWithInd(5)

-*
1  1
1  3   2
1  6   8   3
1  10  20  15  4
1  15  40  45  24  5

1   binom(i+1,2)   2* binom(i+1,3)   3*binom(i+1,4)  

Guess: 

restoluion of Mat_{i,j,n} has len i+1 and the k-th total betti number is (k != 0)

k * binomial(i+1,k+1)

Graded Betti Numbers of Mat_{i,j,n}

b_{0,0} = 1
b_{1,3} = binom(i+1,2)

b_{i-t,q} = binomia(i+1,i-t+1) for 2+(i-t) <= q <= i-t+1+(i-t)
because (i-t)*b_{i-t,q} == (i-t)binomia(i+1,i-t+1)

b_{i-2,q} = .5*i*(i+1) for 2+(i-2) <= q <= i-1+(i-2)
b_{i-1,q} = i+1 for 2+(i-1) <= q <= i+(i-1)
b_{i,q} = 1 for 2+(i) <= q <= 1+i+(i)

*-

binom(i+1,i-2+1)=binomial(i+1,i-1
