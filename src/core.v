module cpu(input clk);
    reg [7:0] PC;
    reg [7:0] A, B;
    
    reg [7:0] RAM [0:63];
    reg [7:0] ROM [0:255];

    reg [7:0] sqrt_table [0:255];
    reg [7:0] pow_table [0:255];  

    wire [3:0] opcode = ROM[PC][7:4];

    initial begin
        PC = 0;
        A = 0;
        B = 0;
    end

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            ROM[i] = 8'h00;
    end

    initial begin
    integer j;
        for (j = 0; j < 256; j = j + 1)
            sqrt_table[j] = integer'($floor($sqrt(j)));
    end

    initial begin
    integer a, b;
    for (a = 0; a < 16; a = a + 1)
        for (b = 0; b < 16; b = b + 1)
            pow_table[{a[3:0], b[3:0]}] = a ** b;
    end

    always @(posedge clk) begin
        if (opcode == 4'b1101) begin
            PC <= ROM[PC + 1];

        end else if (opcode == 4'b1010) begin
            A <= RAM[ ROM[PC+1] ];
            PC <= PC + 2;

        end else if (opcode == 4'b1011) begin
            RAM[ ROM[PC+1] ] <= A;
            PC <= PC + 2;

        end else begin
            case (opcode)
                4'b0000: A <= A;
                4'b0001: A <= A + B;
                4'b0010: A <= A - B;
                4'b0011: A <= A + 1;
                4'b0100: A <= ROM[PC+1];   
                4'b0101: A <= A & B;
                4'b0110: A <= A ^ B;
                4'b0111: {A,B} <= {B,A};
                4'b1000: A <= sqrt_table[A];
                4'b1001: A <= pow_table[{A[3:0], B[3:0]}];
            endcase

            PC <= PC + 1;
        end
    end
endmodule