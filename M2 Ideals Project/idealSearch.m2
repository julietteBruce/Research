loadPackage "VirtualResolutions"
load "test_output.txt"
load "VirRes-test.txt"

restart
load "NTV-test.txt"


isOfDesiredType = method();
isOfDesiredType(Thing,List) := (t,L) -> (
    member((class t),L)
    )

uniformizeRing = method();
uniformizeRing(Thing) := (t) -> (
    if isOfDesiredType(t,ringTypes) == true then (
	if class t === QuotientRing then (
	    S = newRing(ambient t);
	    K := image sub(presentation t,S);
	    S/K
	    )
	else (
	    S
	    )
	)
    else (
	S = newRing(ring t);
	sub(t,S)
	)
   -- S = value toExternalString ring t;
    )

buildDatabaseEntryForExample = method();
buildDatabaseEntryForExample(Thing,String) := (t,packageName) -> (
    if isOfDesiredType(t,ringTypes) == true then (
	H = hashTable {
	    "objectType" => (class t),
	    "objectRing" => toExternalString (ambient t),
	    "object" => toExternalString uniformizeRing(t),
	    "objectSource" => packageName
	    };
	)
    else (
	H = hashTable {
	    "objectType" => (class t),
	    "objectRing" => toExternalString (ring t),
	    "object" => toExternalString uniformizeRing(t),
	    "objectSource" => packageName
	    };
	);
    H
    )

buildExampleFromEntry = method();
buildExampleFromEntry(HashTable) := (H) -> (
    S = value H#"objectRing";
    value H#"object"
    )
	
buildPackageDatabase = method();
buildPackageDatabase(String,String,String,List) := (filePath,packageNumber,packageName,desiredTypes) -> (
    load filePath;
    L1 := apply(exampleIDS, exID->(
	    t = (value exID);
	    if isOfDesiredType(t,desiredTypes) == true then (
		entry = toExternalString buildDatabaseEntryForExample(t,packageName);
		packageNumber|exID => entry
		)
	    ));
    hashTable delete(,L1)
    )

desiredTypes = {Ideal,MonomialIdeal,GradedModule,Module,Ring,EngineRing,PolynomialRing,QuotientRing}
ringTypes = {Ring,EngineRing,PolynomialRing,QuotientRing}
filePath = "VirRes-test.txt"
packageName = "VirtualResolutions"
packageNumber = "P2"

buildPackageDatabase(filePath,packageNumber,packageName,desiredTypes)

R = QQ[x]
I = ideal(x^2)
M = module I
Q = R/I

H = buildDatabaseEntryForExample(I,"Test")
S = value H#"objectRing"
value H#"object"
buildExampleFromEntry(H)

H = buildDatabaseEntryForExample(M,"Test")
S = value H#"objectRing"
value H#"object"
buildExampleFromEntry(H)


H = buildDatabaseEntryForExample(Q,"Test")
S = value H#"objectRing"
value H#"object"
buildExampleFromEntry(H)

H = buildDatabaseEntryForExample(R,"Test")
S = value H#"objectRing"
value H#"object"
buildExampleFromEntry(H)

