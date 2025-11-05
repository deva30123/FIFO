parameter ptr_w = 3;
module pointer(
  input en,clk,
  input reg [ptr_w-1:0] pb_g,
  output [ptr_w-1:0] ptr, pa_g,
  output stat
);
  int i;
  reg [ptr_w-1:0] pb_b,pa_b;
  reg rank;
  always@(*)begin
    if(pb_b > a) rank <= 0;
    else if(pb_b < a) rank <= 1;
    else(pb_b == a) rank <= rank;
  end
  always@(*)begin//gray to binary
    for(i=ptr_w;i>0;i=i-1)begin
      pb_b[i] = pb_g[i]^pb_b[i+1];
    end
  end
  assign pa_g = pa_b^{0,pa_b[ptr_w-1:1]};
  
end module
