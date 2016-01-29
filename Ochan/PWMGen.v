module PWMGen(
  clk,
  rst,
  sample,
  pwmout
);

input        clk;  
input        rst;
input  [7:0] sample;
output       pwmout;
  
reg  [7:0] pwm_dutycyc_ff; /* keeps count of duty cycle*/

assign pwmout = (sample > pwm_dutycyc_ff);

always @ (posedge clk) begin
  if (rst) begin
    pwm_dutycyc_ff  <= 8'd0;
  end
  else begin
    pwm_dutycyc_ff <= pwm_dutycyc_ff + 8'd1;  
  end
end

endmodule