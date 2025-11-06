// Parameterized pointer module
module ptr #(
  parameter ptr_w = 3
)(
  input rst,
  input wire en,
  input wire clk,
  input wire [ptr_w-1:0] pb_g,
  output wire [ptr_w-1:0] pa,
  output wire [ptr_w-1:0] pa_g,
  output wire stat
);
  integer i;
  reg [ptr_w-1:0] pb_b, pa_b=0;
  reg low=0;
//   wire [ptr_w-1:0] pb_bw;
  
//   assign pb_bw = pb_g^(pb_bw>>1);// Gray to binary conversion
  always @(*) begin
    if(~rst)begin
      for(i=0;i<ptr_w;i++) begin
         pb_b[i] = ^(pb_g >> i);
      end 
    end
    else pb_b <= 3'b0;
  end

  
  always @(*) begin// Status flag logic
    if(~rst)begin
      if (pb_b > pa_b) low = 1'b1;
      else if (pb_b < pa_b) low = 1'b0;
      else low = low; // hold previous
    end
    else low = 0;
  end                           

  assign stat = (pa_b == pb_b) & low;

  
  always @(posedge clk,posedge rst) begin
    if(~rst)begin
    	pa_b <= pa_b + (en & !stat);//  Pointer increment logic
    end
    else pa_b = 3'b0;
  end                          


  assign pa_g = pa_b ^ (pa_b >> 1);  // Binary to Gray conversion
  assign pa = pa_b;

endmodule

