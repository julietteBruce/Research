loadPackage "VirtualResolutions"
load "test_output.txt"
load "VirRes-test.txt"

restart
load "NTV-test.txt"

R = QQ[a..d];

desiredTypes = {Ideal,MonomialIdeal,GradedModule,Module,Ring,EngineRing,PolynomialRing,QuotientRing}
typesToGet = {Ideal, MonomialIdeal}

ExampleDatabase = new MutableHashTable
userSymbols Ideal
examplesNumbers = {E0,E1,E2,E3,E4,E5}
apply(exampleNumbers, i->(
	ExampleDa
	))

isOfDesiredType = method();
isOfDesiredType(Thing,List) := (t,L) -> (
    member((class t),L)
    )

desiredTypes = {Ideal,MonomialIdeal,GradedModule,Module,Ring,EngineRing,PolynomialRing,QuotientRing}
ringTypes = {Ring,EngineRing,PolynomialRing,QuotientRing}
S = QQ[x]
I = ideal(x^2)
isOfDesiredType(I,desiredTypes)

buildDatabaseEntryForExample = method();
buildDatabaseEntryForExample(Thing,String) := (t,packageName) -> (
    if isOfDesiredType(t,ringTypes) == true then (
	H = hashTable {
	    "type" => (class t)
	    "object" => toExternalString t
	    };
	)
    else (
	H = hashTable {
	    "type" => (class t)
	    "ring" => toExternalString (ring I)
	    "object" => toExternalString t
	    };
	)
    )

makeBettiTally = method();
makeBettiTally HashTable := H ->(
    new BettiTally from apply(keys H, h-> (h_0,{h_0+h_1},h_0+h_1)=> H#h)
    )



I = monomialIdeal(a*b*c,b*c*d,a^2*d,b^3*c)
class I === Ideal
