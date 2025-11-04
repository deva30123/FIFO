module fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic                clk,
    input  logic                rst_n,
    // Write interface
    input  logic                wr_en,
    input  logic [WIDTH-1:0]    wr_data,
    output logic                full,
    // Read interface
    input  logic                rd_en,
    output logic [WIDTH-1:0]    rd_data,
    output logic                empty
);reg[WIDTH-1:0] i[DEPTH-1:0];
  reg[3:0] r,w;
  always@(posedge clk)begin      
    if(rst_n)begin
      if(wr_en&&(~full))begin
        i[w] <= wr_data;
        w <= ((w>15)?0:w+1);        
      end      
    end
    else w <=0 ;
  end
  always@(posedge clk)begin      
    if(rst_n)begin
      if(rd_en&&(~empty))begin
        rd_data <=i[r];        
        r <= ((r>15)?0:r+1);          
      end 
    end
    else r <=0 ;
  end
  assign full = ((w + 1) == r)||(w==4'd15&&r==4'd0);
  assign empty = w == r; 
endmodule
