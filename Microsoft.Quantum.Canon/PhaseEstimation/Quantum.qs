// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace Microsoft.Quantum.Canon {
    open Microsoft.Quantum.Primitive;

    /// <summary>
    ///     Performs the quantum phase estimation algorithm for a given oracle U and eigenstate,
    ///     reading the phase into a big-endian quantum register.
    /// </summary>
    /// <param name="oracle">An operation implementing U^m for given integer powers m.</param>
    /// <param name="eigenstate">A quantum register representing an eigenstate |φ> of U, U|φ> =
    ///     e^{iφ} |φ> for φ ∈ [0, 2π) an unknown phase.</param>
    /// <param name="controlRegister">A big-endian representation integer register that can be used
    ///     to control the provided oracle, and that will contain the a representation of φ following
    ///     the application of this operation. The controlRegister is assumed to start in the initial
    ///     state |00.0>, where the length of the register indicates the desired precision.</param>
    operation QuantumPhaseEstimation( oracle : DiscreteOracle, eigenstate : Qubit[],  controlRegister : BigEndian)  : ()
    {
        body {
            // FIXME Solid #701: lengths of UDTs < T[] are not supported currently.
            // let nQubits = Length(controlRegister)
            let nQubits = 1;

            ApplyToEachAC(H, controlRegister);

            for (idxControlQubit in 0..(nQubits - 1)) {
                let control = controlRegister[idxControlQubit];
                let power = 2 ^ (nQubits - idxControlQubit - 1);
                (Controlled oracle)([control], (power, eigenstate));
            }

            QFT(controlRegister);
        }

        adjoint auto
        controlled auto
        controlled adjoint auto
    }

}