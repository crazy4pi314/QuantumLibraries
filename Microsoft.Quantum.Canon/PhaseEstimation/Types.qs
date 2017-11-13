// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace Microsoft.Quantum.Canon {

    /// <summary>
    ///     Represents a discrete-time oracle U^m for a fixed operation U
    ///     and a non-negative integer m.
    /// </summary>
    newtype DiscreteOracle = ((Int, Qubit[]) => ():Adjoint,Controlled);

    /// <summary>
    ///     Represents a continuous-time oracle U(dt) : |?(t)> ? |?(t + dt)> for all times t,
    ///     where U is a fixed operation, and where and dt is a non-negative real number.
    /// </summary>
    newtype ContinuousOracle = ((Double, Qubit[]) => ():Adjoint,Controlled);

    // FIXME: Need a better name for this.
    /// <summary>
    ///      Given an operation representing a "black-box" oracle, implements
    ///      a discrete-time oracle by repeating the given oracle multiple times.
    ///      For example, OracleToDiscrete(U)(3, target) is equivalent to U(target)
    ///      repeated three times.
    /// </summary>
    /// <param name="blackBoxOracle">"Black-box" oracle to perform powers of as
    ///     a discrete-time oracle.</param>
    operation OracleToDiscrete(blackBoxOracle : (Qubit[] => ():Adjoint,Controlled))  : DiscreteOracle
    {
        body {
            let oracle = DiscreteOracle(OperationPowImplAC(blackBoxOracle, _, _));
            return oracle;
        }
    }

}