
fundCycles = (B,M) ->(
    makeBColsIdentity = M*(submatrix(M,B)^(-1));
    m = numrows M;
    n = numcols M;
    compB = toList(set{0..n-1}-set B);
    scan(compB, k->(
	    delete(,scan(B,i->(
		    if makeBColsIdentity_(i,k) != 0 then 
		    )
	    )
    )
