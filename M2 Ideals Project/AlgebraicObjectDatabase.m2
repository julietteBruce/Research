-- -*- coding: utf-8 -*-
--------------------------------------------------------------------------------
-- Copyright 2023  Juliette Bruce
--
-- This program is free software: you can redistribute it and/or modify it under
-- the terms of the GNU General Public License as published by the Free Software
-- Foundation, either version 3 of the License, or (at your option) any later
-- version.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
-- details.
--
-- You should have received a copy of the GNU General Public License along with
-- this program.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- PURPOSE : Database of algebraic objects in Macaualy2
--
--
-- PROGRAMMERS : Juliette Bruce
--
--
-- UPDATE HISTORY #0 - March 2023 - Juliette Bruce: Began creating package with
-- a primary focus on creating funcationality for turning the processed 
-- example-out files into a database.
--
--

-- TO DO LIST : 
--------------------------------------------------------------------------------



newPackage("AlgebraicObjectDatabase",
    Version => "1.0",
    Date => "21 March 2023",
    Headline => "A database of alegbraic objects found in Macaulay2",
    Authors => {
        {Name => "Juliette Bruce",           Email => "juliette_bruc1e@brown.edu",       HomePage => "https://www.juliettebruce.xyz"}
	},
  DebuggingMode => true,
  AuxiliaryFiles => true
  )

export {
  "compareTypeToList", -- needs test & docs
  "parentRing", -- needs test & docs
  "isAmbientOK", -- needs test & docs
  "isOfDesiredType", -- needs test & docs
  "uniformizePolyQuotThings", -- needs test & docs
  "uniformizeThing", -- needs test & docs
  "buildDatabaseEntryForExample", -- needs test & docs
  "buildPackageDatabase", -- needs test & docs
  "buildExampleFromEntry" -- needs test & docs
  }

--------------------------------------------------------------------
--------------------------------------------------------------------
----- CODE
--------------------------------------------------------------------
--------------------------------------------------------------------


--------------------------------------------------------------------
--------------------------------------------------------------------
----- INPUT: 
-----
----- OUPUT: 
-----
----- DESCRIPTION: 
--------------------------------------------------------------------
--------------------------------------------------------------------
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
buildPackageDatabase(HashTable,List) := (packageInfoHashtable,desiredTypes) -> (
    filePath := packageInfoHashtable#"filePath";
    fileIDPath := packageInfoHashtable#"fileIDPath";
    packageNumber := packageInfoHashtable#"packageNumber";
    packageName := packageInfoHashtable#"packageName";
    exampleIDS := value get fileIDPath; -- this is hacky....
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

--------------------------------------------------------------------
--------------------------------------------------------------------
----- Begining of the tests and the documentation
--------------------------------------------------------------------
--------------------------------------------------------------------

load ("./AlgebraicObjectDatabase/tests.m2")
beginDocumentation()
load ("./AlgebraicObjectDatabase/doc2.m2")

end

--------------------------------------------------------------------
--------------------------------------------------------------------
----- Begining of sandbox
--------------------------------------------------------------------
--------------------------------------------------------------------

---
---
restart
uninstallPackage "AlgebraicObjectDatabase"
restart
installPackage "AlgebraicObjectDatabase"
check "AlgebraicObjectDatabase"


clearAll

buildPackageDatabaseNew = method();
buildPackageDatabaseNew(HashTable,List) := (packageInfoHashtable,desiredTypes) -> (
    packagePath := packageInfoHashtable#"packagePath";
    --fileIDPath := packageInfoHashtable#"fileIDPath";
    packageNumber := packageInfoHashtable#"packageNumber";
    packageName := packageInfoHashtable#"packageName";
    packageOutFiles := packageInfoHashtable#"packageOutFiles";
    L1 = apply(packageOutFiles, file -> (
	    exampleIDS = value get packagePath|"/"|file|"-exID.txt";
	    filePath = packagePath|"/"|file|".txt";
	    load filePath;
	    apply(exampleIDS, exID->(
	    	    t := (value exID);
	    	    if isOfDesiredType(t,desiredTypes) then (
			print exID;
			entry := toExternalString buildDatabaseEntryForExample(t,packageName);
			packageNumber|exID => entry
			)
	    	    ))
	    ));
    hashTable delete(,flatten(L1))
    )

buildDatabaseFromFolder = method();
buildDatabaseFromFolder(String,String,String) := (folderPath,outputPath,overviewPath) -> (
    overviewHash = value get overviewPath;
    applyPairs(overviewHash, (packageName, packageData)->(
	    packageInfoHashtable = hashTable {
		"packagePath" => folderPath|"/"|toString(packageName),
		"packageNumber" => toString(packageData#0),
		"packageName" => packageName,
		"packageOutFiles" =>  packageDate#1
		};
	    print packageNumber;
	    databaseForPackage = buildPackageDatabaseNew(packageInfoHashTable,desiredTypes);
	    g = openOut (outputPath|"/"|toString(packageName)|".txt");
	    g << toExternalString databaseForPackage;
	    g << endl;
	    close g;
	    ))
    )

desiredTypes = {Ideal,MonomialIdeal,GradedModule,Module,PolynomialRing,QuotientRing,Ring,EngineRing}

folderPath = "outTest"
overviewPath = "outTest/overview.txt"
outputPath = "outM2"
buildDatabaseFromFolder(folderPath,outputPath,overviewPath)


filePath = "VirRes-test.txt"
packageName = "VirtualResolutions"
packageNumber = "P2"
fileIDPath = "VirRes-exIDS.txt"

packageInfoHashtable = hashTable {
    "filePath" =>"VirRes-test.txt",
    "fileIDPath" => "VirRes-exIDS.txt",
    "packageName" => "VirtualResolutions",
    "packageNumber" => "P2"
    }
buildPackageDatabase(packageInfoHashtable,desiredTypes)


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


curDir := currentFileDirectory;
getFileName := (B,D) ->(curDir|"P1P1Syzygies/bettiF0"|"_" | fileName(B,D) |".m2")
