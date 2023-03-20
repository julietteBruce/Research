loadPackage "VirtualResolutions"
load "test_output.txt"
load "VirRes-test.txt"

restart
load "NTV-test.txt"



compareTypeToList = method();
compareTypeToList(Thing,List) := (t,L) -> (
    member((class t),L)
    )

parentRing = method();
parentRing(Thing) := (t) -> (
    if compareTypeToList(t,{PolynomialRing,QuotientRing}) then (
	ambient t
	)
    else (
	ring t
	)
    )

isAmbientOK = method();
isAmbientOK(Thing) := (t) -> (
    toInclude := {PolynomialRing,QuotientRing};
    compareTypeToList(parentRing(t),toInclude)
    )

isOfDesiredType = method();
isOfDesiredType(Thing,List) := (t,L) -> (
    compareTypeToList(t,L) and isAmbientOK(t)
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
	    t
	    )
	)
    else (
	S = newRing(ring t);
	sub(t,S)
	)
    )

buildDatabaseEntryForExample = method();
buildDatabaseEntryForExample(Thing,String) := (t,packageName) -> (
    hashTable {
	    "objectType" => (class t),
	    "objectRing" => toExternalString parentRing(t),
	    "object" => toExternalString uniformizeRing(t),
	    "objectSource" => packageName
	    }
    )
	
buildPackageDatabase = method();
buildPackageDatabase(String,String,String,List) := (filePath,packageNumber,packageName,desiredTypes) -> (
    load filePath;
    L1 := apply(exampleIDS, exID->(
	    t := (value exID);
	    if isOfDesiredType(t,desiredTypes) then (
		print exID;
		entry := toExternalString buildDatabaseEntryForExample(t,packageName);
		packageNumber|exID => entry
		)
	    ));
    hashTable delete(,L1)
    )

buildExampleFromEntry = method();
buildExampleFromEntry(HashTable) := (H) -> (
    S = value H#"objectRing";
    value H#"object"
    )

desiredTypes = {Ideal,MonomialIdeal,GradedModule,Module,PolynomialRing,QuotientRing}
ringTypes = {PolynomialRing,QuotientRing}
filePath = "VirRes-test.txt"
packageName = "VirtualResolutions"
packageNumber = "P2"
buildPackageDatabase(filePath,packageNumber,packageName,desiredTypes)



filePath = "NTV-test.txt"
packageName = "NormalToricVarieties"
packageNumber = "P18"
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


R = ZZ
H = buildDatabaseEntryForExample(R,"Test")
