module fizzbuzz_tb();
  reg [7:0] number;
  wire      fizz;
  wire      buzz;

  fizzbuzz fb(
              .number(number),
              .fizz(fizz),
              .buzz(buzz));

  logic expected_fizz;
  logic expected_buzz;

  integer i;

  always
  begin
    for (i = 0; i < 256; i = i + 1)
    begin
      number = i;
      expected_fizz = ((number % 3) == 0);
      expected_buzz = ((number % 5) == 0);
      #1;

      if (fizz != expected_fizz)
      begin
        $display("Error: got fizz=%0b, expected %0b!", fizz, expected_fizz);
        $finish();
      end

      if (buzz != expected_buzz)
      begin
        $display("Error: got buzz=%0b, expected %0b!", buzz, expected_buzz);
      end
    end

    $display("All tests passed!");
    $finish();
  end
endmodule
