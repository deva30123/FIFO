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
//fifo----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module mem (
  input w_clk,r_clk,rst  
  input [16:0] data_in, 
  output [16:0] data_out
  output full ,empty
);
  reg [16:0] mem [8:0] ;
  reg [16:0] out;
  wire [ptr_w-1:0] w_ptr, r_ptr, r_g, w_g;
  reg [ptr_w-1:0] fr1,fr2,fw2,fw1;
  
  
  ptr w_ptr(
    .rst(rst),
    .en(w_en),
    .clk(w_clk),
    .pb_g(fr2),
    .pa(w_ptr),
    .pa_g(w_g),
    .stat(full)
  );
  ptr r_ptr(
    .rst(rst),
    .en(r_en),
    .clk(r_clk),
    .pb_g,
    .pa(r_ptr),
    .pa_g(r_g),
    .stat(empty)
  );
  
  
  
  always@(posedge w_clk) begin
    if(~rst)begin
      mem[w_ptr] <= data_in;
      fr1 <= r_g;
      fr2 <= fr1;
    end
    else begin
      mem[w_ptr] <= data_in;
      fr1 <= 0;
      fr2 <= 0;
    end
  end
  
  always@(posedge r_clk) begin
    if(~rst)begin
      out <= mem[r_ptr];
      fw1 <= w_g;
      fw2 <= fw1;
    end
    else begin
      out <= 0;
      fw1 <= 0;
      fw2 <= 0;
    end
  end
  assign data_out = out;
endmodule
  
  
