module ImageScaler(
  clk,
  en,
  finish,
  round_scale,
  face_found,
  face_status,
  addr_request,
  addr_scale,
  endScale,
  x,
  y,
  wr_En
);
  input   clk;
  input   en;
  input   finish;
  input   [4:0]  round_scale;
  input   face_found;
  input   face_status;
  output  [18:0] addr_request;
  output  [18:0] addr_scale;
  output  endScale;
  output  [9:0 ]x;
  output  [8:0] y;
  output reg wr_En;
  
  wire  [12:0] scale_factor;
  wire  limit;
  wire  [18:0] limit_addr_request;
  wire  [13:0] L;
  wire  buffer_full;
  
  assign limit = (addr_request==limit_addr_request);
  assign endScale = limit;
  assign scale_factor = (round_scale==5'd0)?  13'd16:        //1.2^0
                        (round_scale==5'd1)?  13'd23:        //1.2^1
                        (round_scale==5'd2)?  13'd33:        //1.2^2
                        (round_scale==5'd3)?  13'd48:        //1.2^3
                        (round_scale==5'd4)?  13'd69:        //1.2^4
                        (round_scale==5'd5)?  13'd99:        //1.2^5
                        (round_scale==5'd6)?  13'd143:        //1.2^6
                        (round_scale==5'd7)?  13'd205:        //1.2^7
                        (round_scale==5'd8)?  13'd296:        //1.2^8
                        (round_scale==5'd9)?  13'd426:        //1.2^9
                        (round_scale==5'd10)? 13'd613:        //1.2^10
                        (round_scale==5'd11)? 13'd883:       //1.2^11
                        (round_scale==5'd12)? 13'd1272:       //1.2^12
                        (round_scale==5'd13)? 13'd1832:       //1.2^13
                        (round_scale==5'd14)? 13'd2638:       //1.2^14
                        (round_scale==5'd15)? 13'd3798:       //1.2^15
                        (round_scale==5'd16)? 13'd5469:       //1.2^16
                        (round_scale==5'd17)? 13'd7876:13'd16; //1.2^17
              

  assign limit_addr_request = (round_scale==5'd0)?  19'd307200:         //1.2^0
                              (round_scale==5'd1)?  19'd213704:         //1.2^1
                              (round_scale==5'd2)?  19'd148946:         //1.2^2
                              (round_scale==5'd3)?  19'd102400:         //1.2^3
                              (round_scale==5'd4)?  19'd71234:          //1.2^4
                              (round_scale==5'd5)?  19'd49648:          //1.2^5
                              (round_scale==5'd6)?  19'd34372:          //1.2^6
                              (round_scale==5'd7)?  19'd23976:          //1.2^7
                              (round_scale==5'd8)?  19'd16605:          //1.2^8
                              (round_scale==5'd9)? 19'd11538:           //1.2^9
                              (round_scale==5'd10)? 19'd8018:           //1.2^10
                              (round_scale==5'd11)? 19'd5566:           //1.2^11
                              (round_scale==5'd12)? 19'd3864:           //1.2^12
                              (round_scale==5'd13)? 19'd2682:           //1.2^13
                              (round_scale==5'd14)? 19'd1863:           //1.2^14
                              (round_scale==5'd15)? 19'd1294:           //1.2^15
                              (round_scale==5'd16)? 19'd898:            //1.2^16
                              (round_scale==5'd17)? 19'd624:19'd307200; //1.2^17
  
  assign L                  = (round_scale==5'd0)?  14'd12200:         //1.2^0
                              (round_scale==5'd1)?  14'd10167:         //1.2^1
                              (round_scale==5'd2)?  14'd8476:         //1.2^2
                              (round_scale==5'd3)?  14'd7070:         //1.2^3
                              (round_scale==5'd4)?  14'd5911:          //1.2^4
                              (round_scale==5'd5)?  14'd4923:          //1.2^5
                              (round_scale==5'd6)?  14'd4106:          //1.2^6
                              (round_scale==5'd7)?  14'd3441:          //1.2^7
                              (round_scale==5'd8)?  14'd2871:          //1.2^8
                              (round_scale==5'd9)?  14'd2396:           //1.2^9
                              (round_scale==5'd10)? 14'd1997:           //1.2^10
                              (round_scale==5'd11)? 14'd1674:           //1.2^11
                              (round_scale==5'd12)? 14'd1408:           //1.2^12
                              (round_scale==5'd13)? 14'd1180:           //1.2^13
                              (round_scale==5'd14)? 14'd990:           //1.2^14
                              (round_scale==5'd15)? 14'd838:           //1.2^15
                              (round_scale==5'd16)? 14'd705:            //1.2^16
                              (round_scale==5'd17)? 14'd591:10'd12200; //1.2^17
 

                  
  wire [27:0] temp_mult;
  wire [18:0] temp_addr_scale;
  
  reg [18:0] addr;
  reg [18:0] temp_addr;
  
  assign buffer_full = (addr >= L);
  assign temp_mult = addr*scale_factor;
  assign temp_addr_scale = temp_mult>>4;
  
  assign addr_request = en? addr : 19'd0;
  assign addr_scale = en? (temp_mult[3]? temp_addr_scale+19'd1:temp_addr_scale): 19'd0;
  
  assign x = addr_scale%10'd640;
  assign y = face_found? addr_scale/10'd640:9'd0;
  
  always@(posedge clk) begin
    if(!en) begin
      addr <= 0;
      wr_En <= 0;
    end
    else begin
      if(!limit) begin
        if(!buffer_full | (face_status & !finish)) begin
          addr <= addr + 19'd1;
          wr_En <= 1'd1;
        end
        else 
          wr_En <= 0;
      end
      else begin
        if (finish)
          wr_En <= 0;
      end
    end
  end
  
endmodule