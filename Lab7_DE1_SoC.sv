module Lab8_DE1_SoC (
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0]  LEDR,
    input  logic [3:0]  KEY,
    input  logic [9:0]  SW,
    output logic [35:0] GPIO_1,
    input logic CLOCK_50
);

    logic [31:0] clk;
    logic SYSTEM_CLOCK;
    logic car_enable, trigger_enable;
    logic [24:0] car_counter;
    logic [22:0] trigger_counter;
    
    clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
    
    assign SYSTEM_CLOCK = clk[14]; // 1526 Hz clock signal

    // Generate enable signals for slower operations
    always_ff @(posedge SYSTEM_CLOCK) begin
        car_counter <= car_counter + 1;
        if (car_counter == 25'd0)
            car_enable <= 1;
        else
            car_enable <= 0;

        trigger_counter <= trigger_counter + 1;
        if (trigger_counter == 23'd0)
            trigger_enable <= 1;
        else
            trigger_enable <= 0;
    end

    /* Set up LED board driver
       ================================================================== */
    logic [15:0][15:0] RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0] GrnPixels; // 16 x 16 array representing green LEDs
    logic hardReset;
    assign hardReset = SW[9];

    /* Standard LED Driver instantiation - set once and 'forget it'. 
       See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
    LEDDriver driver (.CLK(SYSTEM_CLOCK), .RST(playfieldReset), .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);

    /* Logic for user input and game state */
    logic L, R, U, D, lost, won;
    int col;
    logic [15:0] row;
    
    userInput_left_right lr1 (.clk(SYSTEM_CLOCK), .playfieldReset, .hardReset, .KEY0(KEY[0]), .KEY3(KEY[3]), .L, .R);
    userInput_up_down ud1 (.clk(SYSTEM_CLOCK), .playfieldReset, .hardReset, .KEY1(KEY[1]), .KEY2(KEY[2]), .U, .D);
    gameState state1 (.L, .R, .U, .D, .GrnPixels, .col, .row, .playfieldReset, .hardReset, .clk(SYSTEM_CLOCK));

    // Car output controlled by car_enable signal
    car_output co1 (.clk(SYSTEM_CLOCK), .enable(car_enable), .hardReset, .SW(SW[5:0]), .RedPixels);

    // Winner logic controlled by car_enable signal
    winner w1 (.col, .row, .GrnPixels, .RedPixels, .lost, .won, .clk(SYSTEM_CLOCK), .enable(car_enable));

    // Score logic controlled by car_enable signal
    score s1 (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .win(won), .lose(lost), .reset(hardReset), .clk(SYSTEM_CLOCK), .enable(car_enable));

    assign playfieldReset = won || lost;
endmodule

module Lab8_DE1_SoC_testbench();
    logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0]  LEDR;
    logic [3:0]  KEY;
    logic [9:0]  SW;
    logic [35:0] GPIO_1;
    logic CLOCK_50;
    
    Lab8_DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .SW, .LEDR, .GPIO_1, .CLOCK_50);
    
    // Set up the clock
    parameter CLOCK_PERIOD = 100;
    initial begin
        CLOCK_50 <= 0;
        forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
    end
    
    // Set up the inputs to the design. Each line is a clock cycle. 
    initial begin
        SW[9] <= 1; SW[8:6] <= 0; SW[5:0] <= 1; KEY[3:0] <= 0;
        @(posedge CLOCK_50); SW[9] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50); 
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50); KEY[3] <= 1;
        @(posedge CLOCK_50); KEY[3] <= 0;
        @(posedge CLOCK_50); KEY[3] <= 1;
        @(posedge CLOCK_50); KEY[3] <= 0;
        @(posedge CLOCK_50); KEY[0] <= 1;
        @(posedge CLOCK_50); KEY[0] <= 0;
        @(posedge CLOCK_50); KEY[0] <= 1;
        @(posedge CLOCK_50); KEY[0] <= 0;
        @(posedge CLOCK_50); KEY[0] <= 1;
        @(posedge CLOCK_50); KEY[0] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[2] <= 1;
        @(posedge CLOCK_50); KEY[2] <= 0;
        @(posedge CLOCK_50); KEY[2] <= 1;
        @(posedge CLOCK_50); KEY[2] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50); KEY[1] <= 1;
        @(posedge CLOCK_50); KEY[1] <= 0;
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);

        $stop; // End the simulation
    end
endmodule
