
S1 = QQ[a_0..a_14]
S2 = QQ[l_0,l_1,l_2]
S3 = QQ[p_0,p_1,p_2]
S4 = QQ[q_0,q_1,q_2]

S = tensor(S1,S2,S3,S4)
coeffsOfCurve = basis({1,0,0,0},S)
quarticP = basis({0,0,4,0},S)
quarticQ = basis({0,0,0,4},S)

curveAtP = (flatten entries (coeffsOfCurve*(transpose quarticP)))#0
curveAtQ = (flatten entries (coeffsOfCurve*(transpose quarticQ)))#0

coeffsOfLine = basis({0,1,0,0},S)
linearP = basis({0,0,1,0},S)
linearQ = basis({0,0,0,1},S)

lineAtP = (flatten entries (coeffsOfLine*(transpose linearP)))#0
lineAtQ = (flatten entries (coeffsOfLine*(transpose linearQ)))#0

tangentOfCurveAtP = apply({18,19,20}, i->(flatten entries jacobian(curveAtP))#i)
tangentOfCurveAtQ = apply({21,22,23}, i->(flatten entries jacobian(curveAtQ))#i)

tangentMatrix = matrix {tangentOfCurveAtP,tangentOfCurveAtQ}

I = ideal(curveAtP,curveAtQ,lineAtP,lineAtQ)+minors(2,tangentMatrix)+ideal(l_0*l_1*l_2)

curveVars = ideal flatten entries basis({1,0,0,0},S)
lineVars = ideal flatten entries basis({0,1,0,0},S)
pointPVars = ideal flatten entries basis({0,0,1,0},S)
pointQVars = ideal flatten entries basis({0,0,0,1},S)

J0 = saturate(I,curveVars);
J1 = saturate(J0,lineVars);
J2 = saturate(J1,pointPVars);
J3 = saturate(J2,pointQVars);

J = eliminate({p_0,p_1,p_2,q_0,q_1,q_2},J3)

