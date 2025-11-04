// Code your testbench here
// or browse Examples
module fifo_tb;
    // Parameters
    parameter WIDTH = 8;
    parameter DEPTH = 16;
    parameter CLK_PERIOD = 10;

    integer errcount, totcount;
    integer failed;
    integer i;

    // Signals
    logic                clk;
    logic                rst_n;
    logic                wr_en;
    logic [WIDTH-1:0]    wr_data;
    logic                full;
    logic                rd_en;
    logic [WIDTH-1:0]    rd_data;
    logic                empty;

    // Instantiate FIFO
    fifo #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .full(full),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .empty(empty)
    );

    // always @(*) begin : errcheck
    //     if (full && wr_en)
    //         $warning("Writing attempted when FIFO is full!");
    //     if (empty && rd_en)
    //         $warning("Reading attempted when FIFO is empty!");
    // end

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test stimulus
    initial begin
        errcount = 0;
        totcount = 0;

        // Initialize
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        wr_data = '0;

        // Wait 100ns and release reset
        #100 rst_n = 1;

        // Test 1: Write until full
        // $display("Test 1: Writing until FIFO is full");
        @(posedge clk);
        for (i = 0; i < 2*DEPTH; i++) begin
            if (!full) wr_en = 1;
            else begin 
                wr_en = 0;
                //$display("Full at %d", i);
            end
            wr_data = i;
            @(posedge clk);
            $display("Writing data: %0d, full status: %0b", i, full);
        end
        assert(full) else begin
            $error("Test 1: Expected full");
            errcount++;
        end
        totcount++;
        wr_en = 0;

        // Test 2: Read until empty
        // $display("Test 2: Reading until FIFO is empty");
        @(posedge clk);
        for (i = 0; i < 2*DEPTH; i++) begin
            if (!empty) rd_en = 1;
            else begin
                rd_en = 0;
                // $display("Empty at %d", i);
            end
            @(posedge clk);
            // $display("Read data: %0d, empty status: %0b", rd_data, empty);
        end
        assert(empty) else begin
            $error("Test 2: Expected empty");
            errcount++;
        end
        totcount++;
        rd_en = 0;

        // Test 3: Alternating read/write
        // $display("Test 3: Alternating read/write operations");
        failed = 0;
        for (int i = 0; i < 10; i++) begin
            // Write
            @(posedge clk);
            wr_en = 1;
            wr_data = i;
            @(posedge clk);
            wr_en = 0;

            // Read
            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            // $display("Alternating R/W - Written: %0d, Read: %0d", i, rd_data);
            if (rd_data !== i) begin
                $error("Mismatch: written %0d, read %0d", i, rd_data);
                failed++;
            end
        end
        assert(failed==0) else begin
            errcount++;
            $error("Test 3: Mismatch in %d locations", failed);
        end
        totcount++;

        // Test 4: Write when full
        // $display("Test 4: Testing write when full");
        // First fill the FIFO
        @(posedge clk);
        wr_en = 1;
        for (int i = 0; i < DEPTH; i++) begin
            wr_data = i;
            @(posedge clk);
        end
        // Try to write when full
        wr_data = 8'hFF;
        @(posedge clk);
        if (full !== 1) begin
            $error("Test 4: FIFO should be full!");
            errcount++;
        end
        totcount++;
        @(posedge clk);
        wr_en = 0;

        // Test 5: Read when empty
        // $display("Test 5: Testing read when empty");
        // First read everything out
        rd_en = 1;
        for (int i = 0; i < DEPTH; i++) begin
            @(posedge clk);
        end
        // Try to read when empty
        @(posedge clk);
        if (empty !== 1) begin
            $error("Test 5: FIFO should be empty!");
            errcount++;
        end
        totcount++;
        @(posedge clk);
        rd_en = 0;

        // End simulation
        #100;
        if (errcount == 0) begin
            $display("PASS");
        end else begin
            $error("Failed %d out of %d tests", errcount, totcount);
        end
        $finish(0);
    end

endmodule
