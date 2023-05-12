namespace Final {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;


    operation Adder () : Result[]
    {
        let firstNumber = 26;
        let secondNumber = 21;
        let nBits = 6;

        use register1 = Qubit[nBits];
        let int1_bool = IntAsBoolArray(firstNumber, nBits);

        use register2 = Qubit[nBits+1];
        let int2_bool = IntAsBoolArray(secondNumber, nBits);

        use carry = Qubit[nBits];

        for i in 0 .. nBits - 1{
            if int1_bool[i] == true{
                X(register1[i]);
            }
            if int2_bool[i] == true{
                X(register2[i]);
            }
        }

        for i in 0 .. nBits - 1{
            if i < nBits - 1{
                Controlled X ([register1[i], register2[i]], carry[i+1]);
                Controlled X ([register1[i]], register2[i]);
                Controlled X ([carry[i], register2[i]], carry[i+1]);
            }
            else{
                Controlled X ([register1[i], register2[i]], register2[i+1]);
                Controlled X ([register1[i]], register2[i]);
                Controlled X ([carry[i], register2[i]], register2[i+1]);
            }
        }

        Controlled X ([carry[nBits - 1]], register2[nBits - 1]);

        for i in 0 .. nBits - 2{
            Controlled X ([carry[nBits - 2 - i], register2[nBits - 2 - i]], carry[nBits - 1 - i]);
            Controlled X ([register1[nBits - 2 - i]], register2[nBits - 2 - i]);
            Controlled X ([register1[nBits - 2 - i], register2[nBits - 2 - i]], carry[nBits - 1 - i]);

            Controlled X ([carry[nBits - 2 - i]], register2[nBits - 2 - i]);
            Controlled X ([register1[nBits - 2 - i]], register2[nBits - 2 - i]);
        }

        ResetAll(register1);
        ResetAll(carry);
        return ForEach(MResetZ, register2);

    }
}