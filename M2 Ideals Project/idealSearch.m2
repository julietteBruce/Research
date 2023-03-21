
compareTypeToList = method();
compareTypeToList(Thing,List) := (t,L) -> (
    member((class t),L)
    )

parentRing = method();
parentRing(Thing) := (t) -> (
    if compareTypeToList(t,{PolynomialRing,QuotientRing}) then (
	ambient t
	)
    else if compareTypeToList(t,{Ideal,MonomialIdeal,GradedModule,Module}) then (
	ring t
	)
    else (
	t
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

uniformizePolyQuotThings = method();
uniformizePolyQuotThings(Thing) := (t) -> (
    S = newRing parentRing(t);
    if class t === QuotientRing then (
	presentationOfT := presentation t;
	K := image sub(presentationOfT, S);
	S/K
	)
    else if class t === PolynomialRing then (
	t
	)
    else (
	sub(t,S)
	)
    )

uniformizeThing = method();
uniformizeThing(Thing) := (t) -> (
    if isAmbientOK(t) then (
	uniformizePolyQuotThings(t)
	)
    else (
	t
	)
    )


buildDatabaseEntryForExample = method();
buildDatabaseEntryForExample(Thing,String) := (t,packageName) -> (
    hashTable {
	    "objectType" => (class t),
	    "objectRing" => toExternalString parentRing(t),
	    "object" => toExternalString uniformizeThing(t),
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

desiredTypes = {Ideal,MonomialIdeal,GradedModule,Module,PolynomialRing,QuotientRing,Ring,EngineRing}
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

H1 = buildDatabaseEntryForExample(I,"Test")
H2 = buildDatabaseEntryForExample(M,"Test")
H3 = buildDatabaseEntryForExample(Q,"Test")
H4 = buildDatabaseEntryForExample(R,"Test")

S = value H1#"objectRing"
value H1#"object"
buildExampleFromEntry(H1)

S = value H2#"objectRing"
value H2#"object"
buildExampleFromEntry(H2)

S = value H3#"objectRing"
value H3#"object"
buildExampleFromEntry(H3)

S = value H4#"objectRing"
value H4#"object"
buildExampleFromEntry(H4)


R = ZZ
I = ideal(11)
M = ZZ^2
Q = R/I

H1 = buildDatabaseEntryForExample(I,"Test")
H2 = buildDatabaseEntryForExample(M,"Test")
H3 = buildDatabaseEntryForExample(Q,"Test")
H4 = buildDatabaseEntryForExample(R,"Test")
buildExampleFromEntry(H1)
buildExampleFromEntry(H2)
buildExampleFromEntry(H3)
buildExampleFromEntry(H4)

R = QQ
M = QQ^11
H1 = buildDatabaseEntryForExample(M,"Test")
H2 = buildDatabaseEntryForExample(R,"Test")
buildExampleFromEntry(H1)
buildExampleFromEntry(H2)

F = GF(81,Variable=>a)
R = F[x,y,z]
H1 = buildDatabaseEntryForExample(F,"Test")
H2 = buildDatabaseEntryForExample(R,"Test")
buildExampleFromEntry(H1)
buildExampleFromEntry(H2)
