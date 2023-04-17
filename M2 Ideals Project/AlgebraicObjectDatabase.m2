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
  "buildExampleFromEntry", -- needs test & docs
  "buildPackageDatabaseNew" -- needs test & docs
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

buildPackageDatabaseNew = method();
buildPackageDatabaseNew(HashTable,List) := (packageInfoHashtable,desiredTypes) -> (
    packagePath := packageInfoHashtable#"packagePath";
    --fileIDPath := packageInfoHashtable#"fileIDPath";
    packageNumber := packageInfoHashtable#"packageNumber";
    packageName := packageInfoHashtable#"packageName";
    packageOutFiles := packageInfoHashtable#"packageOutFiles";
    L1 := apply(packageOutFiles, file -> (
	    print(toString(packagePath)|"/"|toString(file)|"-exID.txt");
	    exampleIDS := value get toString(toString(packagePath)|"/"|toString(file)|"-exID.txt");--hacky
	    filePath := packagePath|"/"|file|".txt";
	    neededUserSymbols := userSymbols();
	    load filePath;
	    loadedUserSymbols := toList((set userSymbols()) - (set neededUserSymbols));
	    L2 = apply(exampleIDS, exID->(
	    	    t := (value exID);
	    	    if isOfDesiredType(t,desiredTypes) then (
			print exID;
			entry := toExternalString buildDatabaseEntryForExample(t,packageName);
			packageNumber|exID => entry;
			)
	    	    ));
	    print(userSymbols());
	    apply(loadedUserSymbols, i-> erase i);
	    print(userSymbols());
	    L2
	    ));
    hashTable delete(,flatten(L1))
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

outFiles = {"_complement__Graph", "_is__Source", "_nonneighbors", "_index__Label__Graph", "_cover__Ideal", "_independence__Number", "_graph_lp__Digraph_rp", "_barycenter", "_complete__Multipartite__Graph", "_is__Rigid", "_cocktail__Party", "_barbell__Graph", "_radius", "_circular__Ladder", "_new__Digraph", "_diameter_lp__Graph_rp", "_is__C__M", "_vertex__Set", "_chromatic__Number", "_windmill__Graph", "_threshold__Graph", "_delete__Vertex", "_cartesian__Product", "_clique__Number", "_graph", "_sinks", "_line__Graph", "_edge__Ideal", "_closed__Neighborhood", "_spanning__Forest", "_is__Reachable", "_is__Bipartite", "_clustering__Coefficient", "_degree__Matrix", "_density", "_vertex__Cover__Number", "_minimal__Vertex__Cuts", "_vertex__Multiplication", "_nondescendants", "_independence__Complex", "___Sorted__Digraph", "_laplacian__Matrix", "_parents", "_eccentricity", "_lollipop__Graph", "_is__Simple", "_sources", "_bipartite__Coloring", "_critical__Edges", "_underlying__Graph", "_distance__Matrix", "_descendants", "_monomial__Graph", "_find__Paths", "_forefathers", "_digraph__Transpose", "_disjoint__Union", "_star__Graph", "_double__Star", "_adjacency__Matrix", "_induced__Subgraph", "_number__Of__Components", "_graph__Power", "_crown__Graph", "_distance", "_children", "_graph__Library", "_lowest__Common__Ancestors", "_add__Edge", "_is__Leaf", "_strong__Product", "_ladder__Graph", "_expansion", "_graph__Composition", "_spectrum", "_vertex__Cuts", "_edge__Connectivity", "_has__Odd__Hole", "_leaves", "_complete__Graph", "_vertex__Connectivity", "_edge__Cuts", "_has__Eulerian__Trail", "_direct__Product", "_delete__Edges", "_degree_lp__Digraph_cm__Thing_rp", "_is__Cyclic", "_is__Forest", "_connected__Components_lp__Graph_rp", "_friendship__Graph", "_wheel__Graph", "_neighbors", "_is__Connected", "_is__Sink", "_is__Eulerian", "_edges", "_degeneracy", "_vertex__Covers", "_kneser__Graph", "_breadth__First__Search", "_digraph", "_is__Regular", "_minimal__Degree", "_is__Cyclic_lp__Digraph_rp", "_incidence__Matrix", "_girth", "_path__Graph", "_number__Of__Triangles", "_floyd__Warshall", "_is__Strongly__Connected", "_clique__Complex", "_depth__First__Search", "_is__Weakly__Connected", "_add__Vertex", "_degree__Centrality", "_reindex__By", "_degree__Out", "_rattle__Graph", "_reverse__Breadth__First__Search", "_degree__In", "_generalized__Petersen__Graph", "_center", "_topological__Sort", "_cycle__Graph", "_is__Chordal", "_delete__Vertices", "_degree__Sequence", "_top__Sort", "_is__Perfect", "_is__Tree"};
packageInfoHashTable = new HashTable from {
		"packagePath" => "test_output/Graphs",
		"packageNumber" => toString(3),
		"packageName" => toString("Graphs"),
		"packageOutFiles" =>  outFiles
		};

buildPackageDatabaseNew(packageInfoHashTable,desiredTypes)
buildPackageDatabaseNew = method();
buildPackageDatabaseNew(HashTable,List) := (packageInfoHashtable,desiredTypes) -> (
    packagePath := packageInfoHashtable#"packagePath";
    --fileIDPath := packageInfoHashtable#"fileIDPath";
    packageNumber := packageInfoHashtable#"packageNumber";
    packageName := packageInfoHashtable#"packageName";
    packageOutFiles := packageInfoHashtable#"packageOutFiles";
    L1 = apply(packageOutFiles, file -> (
	    print(packagePath|"/"|file|"-exID.txt")
	    exampleIDS = value get toString(toString(packagePath)|"/"|toString(file)|"-exID.txt"); -- hacky 
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
    apply(keys overviewHash, packageName->(
	    packageData = overviewHash#packageName;
	    packageInfoHashTable = new HashTable from {
		"packagePath" => folderPath|"/"|toString(packageName),
		"packageNumber" => toString(packageData#0),
		"packageName" => toString(packageName),
		"packageOutFiles" =>  packageData#1
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

folderPath = "test_output"
overviewPath = "test_output/test_overview.txt"
outputPath = "test_output_M2"
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
