module traffic_light (
    input  clk,
    input  rst,
    input  pass,
    output R,
    output G,
    output Y
);

//write your code here
    reg [2:0]   out;
    reg [11:0]  count_cycle;

    always @(posedge clk) begin
        if (rst)begin
            out <= 3'b010;
            count_cycle <= 12'b0;
        end 
        else begin

            count_cycle = count_cycle+12'b1;
            
            if (count_cycle > 3071) begin
                count_cycle = 12'b0;
            end

            if(pass) begin
                // count_cycle = (out != 3'b010)?12'b1:count_cycle;
                if (out != 3'b010) begin
                    count_cycle = 12'b0;
                end
            end
            
            out = (count_cycle == 12'b0)?3'b010:out;

        end
    end

    always @(*) begin
        
        case (count_cycle)
            16'd1024 :  out = 3'b000;
            16'd1152 :  out = 3'b010;
            16'd1280 :  out = 3'b000;
            16'd1408 :  out = 3'b010;
            16'd1536 :  out = 3'b001;
            16'd2048 :  out = 3'b100;

        endcase
        
    
    end
    assign R = out[2];
    assign G = out[1];
    assign Y = out[0];

endmodule
