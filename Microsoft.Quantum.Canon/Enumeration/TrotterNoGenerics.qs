// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace Microsoft.Quantum.Canon {
    //FIXME temporary non-generic approach

    operation Trotter1ImplCA(evolutionGenerator : (Int, ((Int, Double, Qubit[]) => () : Adjoint, Controlled)), stepSize : Double, target : Qubit[]) : () {
        body {
            let (nSteps, op) = evolutionGenerator;
            for(idx in 0..nSteps-1){
                op(idx, stepSize, target);
            }
        }
        adjoint auto
        controlled auto
        controlled adjoint auto
    }

    operation Trotter2ImplCA(evolutionGenerator : (Int, ((Int, Double, Qubit[]) => () : Adjoint, Controlled)), stepSize : Double, target : Qubit[]) : () {
        body {
            let (nSteps, op) = evolutionGenerator;
            for(idx in 0..nSteps-1){
                op(idx, stepSize * 0.5, target);
            }
            for(idx in (nSteps-1)..(-1)..0){
                op(idx, stepSize * 0.5, target);
            }
        }
        adjoint auto
        controlled auto
        controlled adjoint auto
    }

    function DecomposeIntoTimeStepsCA(evolutionGenerator : (Int, ((Int, Double, Qubit[]) => () : Adjoint, Controlled)), order : Int) : ((Double, Qubit[]) => () : Adjoint, Controlled) {
        if (order == 1) {
            return Trotter1ImplCA(evolutionGenerator, _, _);
        } elif (order == 2) {
            return Trotter2ImplCA(evolutionGenerator, _, _);
        } else {
            fail "Order $order not yet supported.";
        }

        // FIXME: needed so we have a return value of the right type in all cases, but
        //        this line is unreachable and should be removed.
        return Trotter1ImplCA(evolutionGenerator, _, _);
    }
}