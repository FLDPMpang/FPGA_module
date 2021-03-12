module smg(
input  clk,
input  rst_n,

output reg sclk,
output reg rclk,
output reg dio
    );
	 
parameter s=32'd04154110;
wire [31:0] number_bcd;
		
reg [7:0] cnt_s;
reg [31:0]cnt;
reg [31:0]cnt0;
reg [2:0]cnt_n;

reg clk_f;
wire dio_n;
wire sclk_n;
wire rclk_n;

reg [7:0] addr;
reg [7:0] time_n;
reg [31:0]cnt1;
reg [7:0] cnt_s1;
reg [7:0] cnt_s2;
/*
clk_wiz_0 clk_wiz_0
     (
      // Clock out ports
     .clk_out1(clk_f),
      // Status and control signals
      .reset(rst_n),
     // Clock in ports
      .clk_in1(clk)
     );
*/
always  @(posedge clk) 
begin
	cnt0<=cnt0+1'b1;
	if(cnt0<=10)
    clk_f<=0;
	else if(cnt0==20)
    cnt0<=0;
	else 
    clk_f<=1;
end


always@(posedge clk_f or negedge rst_n) begin
if(rst_n)
    cnt <= 32'd0;
else begin
    if(cnt == 32'd36)
        cnt <= 32'd0;
    else
        cnt <= cnt +1'b1;
            end
				end
always@(posedge clk_f or negedge rst_n)
     if(rst_n)
         cnt_n <= 3'd0;
     else
         if(cnt == 32'd36)
             if(cnt_n == 3'd7)
                cnt_n <= 3'd0;
             else
                cnt_n <= cnt_n +1'b1;     
         else
             cnt_n <= cnt_n ;

always@(posedge clk_f or negedge rst_n)
                                if(rst_n)
                                    addr <= 8'd0;
                                else
                                    case(cnt_n)
                                    3'd0:addr<=8'h80;
                                    3'd1:addr<=8'h40;
                                    3'd2:addr<=8'h20;
                                    3'd3:addr<=8'h10;
                                    3'd4:addr<=8'h08;
                                    3'd5:addr<=8'h04;
                                    3'd6:addr<=8'h02;
                                    3'd7:addr<=8'h01;
                                    
                                    endcase

always@(posedge clk_f or negedge rst_n)
  if(rst_n)
      time_n <= 8'd0;
  else
      case(cnt_n)
      3'd7:time_n<=number_bcd[3:0];
      3'd0:time_n<=number_bcd[7:4];
      3'd1:time_n<=number_bcd[11:8];
      3'd2:time_n<=number_bcd[15:12];
      3'd3:time_n<=number_bcd[19:16];
      3'd4:time_n<=number_bcd[23:20];
      3'd5:time_n<=number_bcd[27:24];
      3'd6:time_n<=number_bcd[31:28];
      
      endcase

always@(posedge clk_f or negedge rst_n)
if(rst_n)
    cnt_s2 <= 8'd0;
else
    case(time_n)
    8'd0:cnt_s2<=8'hc0;
    8'd1:cnt_s2<=8'hf9;
    8'd2:cnt_s2<=8'ha4;
    8'd3:cnt_s2<=8'hb0;
    8'd4:cnt_s2<=8'h99;
    8'd5:cnt_s2<=8'h92;
    8'd6:cnt_s2<=8'h82;
    8'd7:cnt_s2<=8'hf8;
    8'd8:cnt_s2<=8'h80;
    8'd9:cnt_s2<=8'h90;
    8'd10:cnt_s2<=8'hff;
    endcase


always@(posedge clk_f or negedge rst_n)
if(rst_n)
    cnt_s <= 8'h00;
else
    if(cnt == 32'd1)
        cnt_s <=cnt_s2;   
    else if(cnt == 32'd18)
        cnt_s <= addr;
    else if(dio_n)
        cnt_s = cnt_s <<1;
     else
      cnt_s <=  cnt_s ;    





assign dio_n =  (cnt == 32'd2 || cnt == 32'd4 ||cnt == 32'd6 ||cnt == 32'd8 ||cnt == 32'd10 ||cnt == 32'd12 ||cnt == 32'd14 ||cnt == 32'd16 ||cnt == 32'd19 ||cnt == 32'd21 ||cnt == 32'd23 ||cnt == 32'd25 ||cnt == 32'd27 ||cnt == 32'd29 ||cnt == 32'd31 ||cnt == 32'd33)
                 ? 1'b1:1'b0;
assign sclk_n =  (cnt == 32'd3 || cnt == 32'd5 ||cnt == 32'd7 ||cnt == 32'd9 ||cnt == 32'd11 ||cnt == 32'd13 ||cnt == 32'd15 ||cnt == 32'd17 ||cnt == 32'd20 ||cnt == 32'd22 ||cnt == 32'd24 ||cnt == 32'd26 ||cnt == 32'd28 ||cnt == 32'd30 ||cnt == 32'd32 ||cnt == 32'd34)
                 ? 1'b1:1'b0;

always@(posedge clk_f or negedge rst_n)
if(rst_n)begin
    dio <= 1'b0;
end
else 
     if(dio_n)begin
        if(cnt_s[7])
          dio <= 1'b1;
       else
          dio <= 1'b0;         
    end    
    else
        dio <= 1'b0;  

always@(posedge clk_f or negedge rst_n)
if(rst_n)
    sclk <= 1'b0;
else if(sclk_n)
         sclk <= 1'b1;     
else
    sclk <= 1'b0;  

always@(posedge clk_f or negedge rst_n)
if(rst_n)
    rclk <= 1'b0;
else
    if(cnt == 32'd35)
        rclk <= 1'b1;
    else
        rclk <= 1'b0; 

	BCD_8421 u_bcd(
		 .clk(clk),
		 .rst(rst_n),
	    .number_data(s),
	    .number_bcd(number_bcd)
	);

endmodule
