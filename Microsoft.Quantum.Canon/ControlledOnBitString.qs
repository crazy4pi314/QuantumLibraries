// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace Microsoft.Quantum.Canon {
	open Microsoft.Quantum.Primitive;

	/// <summary>
	/// Applies a unitary operator on the target register if the control register state corresponds to a specified bit mask.
	/// </summary>
	/// <param name = "bits"> Boolean array </param>
	/// <param name = "oracle"> Unitary operator </param>
	/// <param name = "targetRegister"> Quantum register acted on by "oracle" </param>
	/// <param name = "controlRegister"> Quantum register that controls application of "oracle" </param>
	/// <remarks> 
	/// The length of bits and targetRegister must be equal.
	/// For example, bits = [0,1,0,0,1] means that "oracle" is applied if and only if "controlRegister" is in the state |0>|1>|0>|0>|1>.
	/// </remarks>
	//FIXME Make this generic in the oracle A, C, AC
	operation ControlledOnBitStringImpl(bits : Bool[] , oracle: (Qubit[] => (): Adjoint, Controlled), controlRegister : Qubit[], targetRegister: Qubit[]) : ()
	{
		body{
			WithCA(ApplyPauliFromBitString(PauliX, false, bits, _), (Controlled oracle)(_, targetRegister), controlRegister);
		}

		adjoint auto
		controlled auto
		adjoint controlled auto
	}
	function ControlledOnBitString(bits : Bool[] , oracle: (Qubit[] => (): Adjoint, Controlled)) : ((Qubit[],Qubit[]) => (): Adjoint, Controlled)
	{
		return ControlledOnBitStringImpl(bits, oracle, _, _);
	}

	/// <summary>
	/// Applies a unitary operator on the target register if the control register state corresponds to a specified positive integer.
	/// </summary>
	/// <param name = "numberState"> Positive integer </param>
	/// <param name = "oracle"> Unitary operator </param>
	/// <param name = "targetRegister"> Quantum register acted on by "oracle" </param>
	/// <param name = "controlRegister"> Quantum register that controls application of "oracle" </param>
	/// <remarks> 
	/// "numberState" msut be at most 2^Length(targetRegister) - 1.
	/// For example, numberState = 537 means that "oracle" is applied if and only if "targetRegister" is in the state |537>.
	/// </remarks>
	//FIXME Make this generic in the oracle A, C, AC
	operation ControlledOnIntImpl(numberState : Int , oracle: (Qubit[] => (): Adjoint, Controlled), controlRegister : Qubit[], targetRegister: Qubit[]) : ()
	{
		body {

			let bits = BoolArrFromPositiveInt(numberState, Length(controlRegister));

			(ControlledOnBitString(bits, oracle))(controlRegister, targetRegister);

		}

		adjoint auto
		controlled auto
		adjoint controlled auto
	}
	function ControlledOnInt(numberState : Int , oracle: (Qubit[] => (): Adjoint, Controlled)) : ((Qubit[],Qubit[]) => (): Adjoint, Controlled)
	{
		return ControlledOnIntImpl(numberState, oracle, _, _);
	}

}