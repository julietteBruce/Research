doc ///
   Key 
      AlgebraicObjectDatabase
   Headline 
      A database of alegbraic objects found in Macaulay2
   Description
    Text
      A database of alegbraic objects found in Macaulay2   

///


doc ///
   Key 
    compareTypeToList
    (compareTypeToList,Thing,List)
   Headline
    converts a hash table representing a Betti table to a Betti tally
   Usage
    compareTypeToList(t,L)
   Inputs
    t: Thing
    L: List
   Outputs
    : Boolean
   Description
    Text
      Given a hash table $H$ whose keys are pairs of integers $(p,q)$ 
      this function presents the data in the Betti tally format.
      For instance, combining this with the function reproduces
      the standard Betti table.  By contrast, combining this with the
      numRepsBetti function produces a table where the entry in position
      $(p,q)$ is the number of Schur functors in the representation corresponding
      to that Betti table entry.
    Example
      compareTypeToList(ZZ,{Ring})

///

