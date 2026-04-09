//sequence detector  seq: (1011)
module seq_detector(
    input wire clk,rst,
    input wire in,
    output reg out
    );
    parameter s1 = 2'b00,s2 = 2'b01,s3 = 2'b10,s4 = 2'b11;
    reg [1:0] state,next_state;
    
    //assigning default state as s1
    always @(posedge clk or posedge rst) begin 
        if(rst)
            state = s1;
        else 
            state = next_state;
    end
    
    //next state and output logic
    always @(posedge clk or posedge rst) begin 
        case(state)
            s1: begin out = 1'b0;
                if(in == 1)
                    next_state = s2;
                else 
                    next_state = s1;
            end
            s2: begin 
                out = 1'b0;
                if(in == 0)
                    next_state = s3;
                else
                    next_state = s2;
            end 
            s3: begin 
                out = 1'b0;
                if(in == 1)
                    next_state = s4;
                else 
                    next_state = s1;
            end
            s4: begin
                if(in == 1)
                    begin next_state = s2; out =1; end
                else
                    begin next_state = s1; out = 0;end  
            end  
        endcase    
    end
endmodule
