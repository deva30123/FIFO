module pointer(
  input en,clk,
  output [2:0] nxp_g, ptr,
  output stat
);
  reg [2:0] p;
  always@(posedge clk)begin
    p <= p+1;
  end
end module
