-- Takes given planar partition and produces a list 
-- of all possible planar partitions one step away.
levelUp = method()
levelUp(Matrix) := (M) ->(
    L = {};
    n := #entries M - 1;
    apply(n, j->(
	    if j == 0 then (
	    	N = mutableMatrix M;
    		N_(0,0) = M_(0,0)+1;
		L = join(L, {matrix N});
	    	for i from 1 to n when M_(i-1,j) != 0 do (
		    if M_(i,j) < M_(i-1,j) then (
		     	N = mutableMatrix M;
		     	N_(i,j)=M_(i,j)+1;		
    	    	     	L = join(L,{matrix N});
		     	));
		);
	    if j != 0 then (
		if M_(0,j) < M_(0,j-1) then (
		    N = mutableMatrix M;
		    N_(0,j)=M_(0,j)+1;		
    	    	    L = join(L,{matrix N});
		    );
		for i from 1 to n when (M_(i-1,j) != 0 or M_(i,j-1) != 0) do (
		     if M_(i,j) < M_(i,j-1) and M_(i,j) < M_(i-1,j) then (
		     	 N = mutableMatrix M;
		     	 N_(i,j)=M_(i,j)+1;		
    	    	     	 L = join(L,{matrix N});
		     	 ));
		);
		));
    L
)

planarPartitions = (n) -> (
    M := mutableMatrix apply(n+2,i->apply(n+2,j->0));
    M_(0,0)=1;
    L = {matrix M};
    T := new MutableHashTable;
    for i from 1 to (n-1) do (
	N = unique flatten apply(L,i->levelUp(i));
	T#(i) = N;
	L = N;
	);
    Y = new HashTable from pairs T;
    L
)

---------------------------------------------------------------------------------------------
------------------------------
----- Construct Monomial -----
----- and Borel Ideals   -----
------------------------------
-- Constructs monomial or   --
-- Borel ideals of given    --
-- length in Q[z,y,x]       --
------------------------------
---------------------------------------------------------------------------------------------
S = QQ[x,y,z]

constructIdeal = (M) ->(
    G := {};
    n := #entries M - 1;
    apply(n, j->(
	    for i from 1 to n when (M_(i,j) != 0 or M_(i-1,j) != 0) do (
		G = join(G,{x^j*y^i*z^(M_(i,j))});
	      ); 
	  ));
    apply(n, j->( G = join(G,{x^j*y^0*z^(M_(0,j))})));
    G = flatten G;
    I =  monomialIdeal(G) 
)	       

---------------------------------------------------------------------------------------------
-- Input: An integer
-- Output: A list of all monomial/Borel
-- ideals of the specified co-length.
monomialIdealsOfLength = (n) -> (
    L = planarPartitions(n);
    apply(L,i->constructIdeal(i))
    )


---------------------------------------------------------------------------------------------
-- Input: A module
-- Output: A list of the total betti numbers of the input module
totalBettiNumbers = (M) -> (
    resM = res M;
    bettiM = betti res M;
    apply(length resM,i->(
	    sum delete(,apply(keys bettiM,k->(
			if k#0 == i then bettiM#k
			)))
	    ))
    )

---------------------------------------------------------------------------------------------
-- Input: A integer n
-- Output: A list of pairs of planar partitions of n with maximal betti numbers
planarPartsBiggestBetti = (n) -> (
    planarParts = planarPartitions(n);
    monomialIdeals = apply(planarParts,i->{i,constructIdeal(i)});
    monomialsAndBetti = apply(monomialIdeals,I->{totalBettiNumbers(I#1),I#0});
    maxBetti = max(apply(monomialsAndBetti,i->i#0));
    delete(,apply(monomialsAndBetti,i->if i#0 == maxBetti then i))
    )

apply(monomialIdealsOfLength(6),i->(totalBettiNumbers(i)))
