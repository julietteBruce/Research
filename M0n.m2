loadPackage "SchurFunctors"

basisVector = (i,n) ->(
    (id_(ZZ^n))_{i}
)

rootAVector = (i,j,n) ->(
    basisVector(i,n)-basisVector(j,n)
    )

rootSystemAMatrix = (n) ->(
    rootVecs := flatten apply(toList(0..n-3),i->(
	    apply(toList(i+1..n-3),j->(
		    rootAVector(i,j,n-2)
		    ))
	    ));
    matrix{rootVecs}
    )
	    

bMatrix = (n) -> (
    (id_(ZZ^(n-2)))|rootSystemAMatrix(n)
    )

--time apply(toList(5..100),n->time bMatrix(n)); --slowest about 7s but ran in 124.573s

bPMatrix = (n) -> (
    lastRow = matrix{apply(n-2,i->-1)|apply(binomial(n-2,2),i->0)};
    bMatrix(n)||lastRow
    )

bBPrimeCheck = (n) ->(
    ker(bMatrix(n)) == ker(bPMatrix(n))
    )

aMatrix = (n) -> (
    transpose gens ker(bMatrix(n))
    )

--time apply(toList(5..100),n->time aMatrix(n)); --slowest about 19s but ran in 545.429s

aPMatrix = (n) -> (
    transpose gens ker(bPMatrix(n))
    )

aIdealM0n = (n) -> (
    var = apply(binomial(n-1,2),i->x_i);
    S = ZZ[var];
    A  = aMatrix(n);
    gen = flatten entries (A*(transpose vars S));
    ideal(gen)
    )

ijPairs = (s,n) ->(
    sort flatten apply(toList(s..n-1),i->(
	    apply(toList(i+1..n-1),j->(
		    {i,j}
		    ))
	    ))
    )

ijBasisLabelHash = (n) ->(
    H := new MutableHashTable;
    L := ijPairs(1,n);
    apply(#L,i->H#(L#i) = i);
    new HashTable from pairs H
    )

zIJvec = (i,j,n) -> (
    H = ijBasisLabelHash(n);
    r = binomial(n-1,2);
    transpose (basisVector(H#{i,j},r)-basisVector(H#{1,j},r)+basisVector(H#{1,i},r))
    )

zMatrix = (n) -> (
    matrix apply(ijPairs(2,n),k->(
	    {zIJvec(k#0,k#1,n)}
	    ))
    )

--time apply(toList(5..100),n->time zMatrix(n)); --- dont try

azCheck = (n) ->(
    image(aMatrix(n)) == image(zPMatrix(n))
    )

zIdealM0n = (n) -> (
    var = apply(ijPairs(1,n),k->(
	    z_{k#0,k#1}
	    ));
    S = ZZ[var];
    Z = zMatrix(n);
    gen = flatten entries (Z*(transpose vars S));
    ideal(gen)
    )

degreeDZMonomialMatrix = (d,n) ->(
    var = apply(ijPairs(1,n),k->(
	    z_{k#0,k#1}
	    ));
    S = ZZ[var];
    transpose matrix apply(flatten entries basis(d,S),m->flatten exponents(m))
    )

dVeroneseZMatrixWRONG = (d,n) ->(
    D := degreeDZMonomialMatrix(d,n);
    Z := zMatrix(n);
    Z*D
    )

dVeroneseZMatrix = (d,n) ->(
    schur({d},zMatrix(n))
    )

