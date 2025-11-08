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
  reg [ptr_w-1:0] pb_b, pa_b=0, pa_prev=0;

  always @(*) begin
    if(~rst)begin
      for(i=0;i<ptr_w;i++) begin
         pb_b[i] = ^(pb_g >> i);
      end 
    end
    else pb_b <= 3'b0;
  end                       

  assign stat = (pa_prev == pb_b-1)|(pa_prev == 7)&(pb_b == 0) ;
  
  always @(posedge clk,posedge rst) begin
    if(~rst)begin
      pa_prev <= (stat)?pa_prev:pa_b;
    	pa_b <= pa_b + (en & !stat);
    end
    else begin
      pa_b = 3'b0;
      pa_prev = 3'b0;
    end
  end  //  Pointer increment logic
  
  assign pa_g = pa_b ^ (pa_b >> 1);  // Binary to Gray conversion
  assign pa = pa_b;
  
endmodule


//fifo----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module mem #(
  parameter ptr_w = 3
)(
  input w_clk,r_clk,rst,r_en,w_en,  
  input [15:0] data_in, 
  output [15:0] data_out,
  output full ,empty
);
  reg [15:0] mem [8:0] ;
  reg [15:0] out;
  wire [ptr_w-1:0] wptr, rptr, r_g, w_g;
  reg [ptr_w-1:0] fr1=0,fr2=0,fw2=0,fw1=0;
  
  
  ptr w_ptr(  
    .rst(rst),
    .en(w_en),
    .clk(w_clk),
    .pb_g(fr2),
    .pa(wptr),
    .pa_g(w_g),
    .stat(full)
  );
  ptr r_ptr(   
    .rst(rst),
    .en(r_en),
    .clk(r_clk),
    .pb_g(fw2),
    .pa(rptr),
    .pa_g(r_g),
    .stat(empty)
  );
  
  
  always@(posedge w_clk) begin
    if(~rst)begin
      mem[wptr] <= (w_en&full)?mem[wptr]:data_in;
      fr1 <= r_g;
      fr2 <= fr1;
    end
    else begin
      mem[wptr] <= 0;
      fr1 <= 0;
      fr2 <= 0;
    end
  end
  
  always@(posedge r_clk) begin
    if(~rst)begin
      out <= (empty&r_en)?0:mem[rptr];
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
  
  
