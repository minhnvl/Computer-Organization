module traffic_light (
    input  clk,
    input  rst,
    input  pass,
    output R,
    output G,
    output Y
);
//write your code here
parameter STATE_INIT     = 3'b000,
          STATE_IDLE1    = 3'b001,
          STATE_IDLE2    = 3'b111,
          STATE_GREEN1   = 3'b010,
          STATE_GREEN2   = 3'b101,
          STATE_GREEN3   = 3'b110,
          STATE_RED      = 3'b011,
          STATE_YELLOW   = 3'b100;
reg [3:0] state;
reg [3:0] nxt_state;
reg [9:0] counter;
reg       restart;

assign G = (state == (STATE_GREEN1) | state == (STATE_GREEN2) | state == (STATE_GREEN3));
assign Y = (state == (STATE_YELLOW));
assign R = (state == (STATE_RED));
always@(posedge clk or posedge rst) begin
    if(rst)
        state <= STATE_GREEN1;
    else 
        state <= (pass) ? STATE_GREEN1:nxt_state;
end

always@(posedge clk or posedge rst) begin
    if(rst)
        counter <= 10'b0;
    else 
        counter <= (restart |(pass & nxt_state != STATE_GREEN1) ) ? 10'b0 : counter + 10'b1;
end

always@(*) begin
    nxt_state = state;
    restart = 1'b0;
    case(state)
        STATE_IDLE1: begin
            nxt_state = (counter == 10'd127) ? STATE_GREEN2 : STATE_IDLE1;
            restart = (counter == 10'd127);
        end
        STATE_IDLE2: begin
            nxt_state = (counter == 10'd127) ? STATE_GREEN3 : STATE_IDLE2;
            restart = (counter == 10'd127);
        end
        STATE_GREEN1: begin
           nxt_state = (counter == 10'd1023) ? STATE_IDLE1 : STATE_GREEN1;
           restart = (counter == 10'd1023);
        end
        STATE_GREEN2: begin
            nxt_state = (counter == 10'd127) ? STATE_IDLE2 : STATE_GREEN2;
            restart = (counter == 10'd127);
        end
        STATE_GREEN3: begin
            nxt_state = (counter == 10'd127) ? STATE_YELLOW : STATE_GREEN3;
            restart = counter == 10'd127;
        end
        STATE_RED: begin
            nxt_state = (counter == 10'd1023) ? STATE_GREEN1 : STATE_RED;
            restart = counter == 10'd1023;
        end
        STATE_YELLOW:begin
            nxt_state = (counter == 10'd511) ? STATE_RED : STATE_YELLOW;
            restart = counter == 10'd511;
        end
    endcase
end

endmodule
