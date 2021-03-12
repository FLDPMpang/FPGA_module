module Keydebounced(
	input sys_clk,
	input sys_rst_n,
	input key_in,
	output reg key_out
);
reg key_1,key_2,key_val;
reg [19:0] count;
parameter TIME= 20'd999_999;//50Mhz 0.02us 20ms 10^6-1

always @(posedge sys_clk,negedge sys_rst_n) begin
	if(!sys_rst_n) begin 
		key_1<=1'd1;
		key_2<=1'd1;
	end
	else begin 
		key_1<=key_in;
		key_2<=key_1;
        key_val<=key_2&(~key_1);
	end
end



always @(posedge sys_clk , negedge sys_rst_n) begin
	if( (!sys_rst_n ) | key_val) 
		count<=0;
	else 
		count<=count+1'd1;
end

always @(posedge sys_clk, negedge sys_rst_n) begin
	if(!sys_rst_n) 
		key_out<=1;
	else if(count==TIME)
		key_out<=key_in;
end
endmodule
