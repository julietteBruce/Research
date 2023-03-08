loadPackage "VirtualResolutions"
load "test_output.txt"
R = QQ[a..d];

typesToGet = {Ideal,MonomialIdeal,GradedModule,Module,Ring,EngineRing,PolynomialRing,QuotientRing}
typesToGet

ExampleDatabase = new MutableHashTable
userSymbols Ideal
examplesNumbers = {E0,E1,E2,E3,E4,E5}
apply(userSymbols Ideal, i->(
	ExampleDa
	))

I = monomialIdeal(a*b*c,b*c*d,a^2*d,b^3*c)
class I === Ideal
