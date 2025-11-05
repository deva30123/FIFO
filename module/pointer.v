parameter ptr_w = 3;
module pointer(
  input en,clk,
  input reg [ptr_w-1:0] pb_g,
  output [ptr_w-1:0] ptr pa_g,
  output stat
);
  int i;
  reg [ptr_w-1:0] pb_b,pa_a;
  reg rank;
  always@(*)begin
    if(pb_b > a) rank = 0;
    else if(pb_b < a) rank = 1;
    else(pb_b == a) rank = rank;
  end
  always@(*)begin
    for(i=ptr_w;)     
  end
  
end module
