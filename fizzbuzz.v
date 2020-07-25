module fizzbuzz
  (input wire [7:0] number,
   output wire fizz,
   output wire buzz);

  div_test #(.DIVIDEND_WIDTH(8),
             .FRACTIONAL_WIDTH(9),
             .RECIPROCAL(171))
  divisible_by_3(
    .dividend(number),
    .is_divisible(fizz));

  div_test #(.DIVIDEND_WIDTH(8),
             .FRACTIONAL_WIDTH(10),
             .RECIPROCAL(205))
  divisible_by_5(
    .dividend(number),
    .is_divisible(buzz));

`ifdef FORMAL
  always @(*)
  begin
    cover(number == 0);
    cover(number == 255);

    assert(fizz == ((number % 3) == 0));
    assert(buzz == ((number % 5) == 0));
  end
`endif
endmodule

module div_test
  #(parameter DIVIDEND_WIDTH = 1,
    parameter FRACTIONAL_WIDTH = 1,
    parameter RECIPROCAL = 1)
  (input logic [DIVIDEND_WIDTH-1:0] dividend,
   output logic is_divisible);

  localparam DIVIDEND_PADDING = {(FRACTIONAL_WIDTH - DIVIDEND_WIDTH){1'b0}};

  wire [FRACTIONAL_WIDTH-1:0] product;

  mul_const #(.WIDTH(FRACTIONAL_WIDTH), .CONST_FACTOR(RECIPROCAL))
  mul_reciprocal(
    .value({DIVIDEND_PADDING,dividend}),
    .product(product));

  always @(*)
  begin
    is_divisible = product[FRACTIONAL_WIDTH-1:0] < RECIPROCAL;
  end
endmodule

module mul_const
  #(parameter WIDTH = 8,
    parameter CONST_FACTOR = 0)
  (input logic [WIDTH-1:0] value,
   output logic [WIDTH-1:0] product);

  integer i;

  always @(value)
    begin
      product = 0;

      for (i = 0; i < WIDTH; i = i + 1)
        begin
          if ((CONST_FACTOR & (1 << i)) != 0)
            product = product + (value << i);
        end
    end
endmodule
