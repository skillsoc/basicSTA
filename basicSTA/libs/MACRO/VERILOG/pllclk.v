module pllclk(refclk, reset, ibias, vcop, vcom, clk1x, clk2x);
    input  refclk;
    output vcop;
    output vcom;
    output clk1x;
    output clk2x;
    input reset;
    input ibias;

assign clk1x = refclk;
assign clk2x = refclk;

endmodule

