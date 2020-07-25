module top(input logic A0, A1, A2, A3, A4, A5, A6, A7,
           output logic B0, B1);

  logic [7:0] number;
  logic       fizz, buzz;

  assign {A7, A6, A5, A4, A3, A2, A1, A0} = number;
  assign {B1, B0} = {fizz, buzz};

  fizzbuzz fb(
    .number(number),
    .fizz(fizz),
    .buzz(buzz));
endmodule
