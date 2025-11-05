parameter ptr_w = 3;
module ptr(
  input en,clk,
  input reg [ptr_w-1:0] pb_g,
  output [ptr_w-1:0] pa, pa_g,
  output stat
);
  int i;
  reg [ptr_w-1:0] pb_b,pa_b,pa_nxt;
  reg low;
  always@(*)begin
    if(pb_b > a) low <= 1'b0;
    else if(pb_b < a) low <= 1'b1;
    else(pb_b == a) low <= low;
  end
  always@(*)begin//gray to binary
    for(i=ptr_w;i>0;i=i-1)begin
      pb_b[i] = pb_g[i]^pb_b[i+1];
    end
  end
  assign stat = (pa_b==pb_b)&low;
  always@(posedge clk)begin
    pa_b <= pa_nxt;
    pa_nxt <= pa_b + (en & !stat);    
  end
  assign pa_g = pa_b^(pa_b>>1};
  assign pa = pa_b;
end module
