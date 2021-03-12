module BCD_8421(
	input clk,rst,
	input  [31:0] number_data,
	output reg [31:0] number_bcd
);
	reg  state;
	reg [31:0] number_data_reg;
	reg [31:0] number_bcd_reg;
	
	reg [5:0]  cnt;
	
	always@(posedge clk or negedge rst) begin
		if(rst) begin
			state <= 1'b0;
			cnt <= 6'd31;
			number_data_reg <= 32'd0;
			number_bcd <= 32'd0;
			number_bcd_reg <= 32'd0;
		end
		else begin
			case(state)
				1'b0: begin
					if(cnt == 6'd0) begin
						cnt <= 6'd31;
						number_data_reg <= number_data;
						number_bcd <= {number_bcd_reg[30:0],number_data_reg[cnt]};
						number_bcd_reg <= 32'd0;
					end
					else begin
						cnt <= cnt - 1'b1;
						number_bcd_reg <= {number_bcd_reg[30:0],number_data_reg[cnt]};
					end
					state <= 1'b1;
				end
				1'b1: begin
					if(number_bcd_reg[3:0]>4'd4) 	number_bcd_reg[3:0] <= number_bcd_reg[3:0]+2'd3;
					if(number_bcd_reg[7:4]>4'd4) 	number_bcd_reg[7:4] <= number_bcd_reg[7:4]+2'd3;
					if(number_bcd_reg[11:8]>4'd4)  number_bcd_reg[11:8] <= number_bcd_reg[11:8]+2'd3;
					
					if(number_bcd_reg[15:12]>4'd4) number_bcd_reg[15:12] <= number_bcd_reg[15:12]+2'd3;
					if(number_bcd_reg[19:16]>4'd4) number_bcd_reg[19:16] <= number_bcd_reg[19:16]+2'd3;
					if(number_bcd_reg[23:20]>4'd4) number_bcd_reg[23:20] <= number_bcd_reg[23:20]+2'd3;
					
					if(number_bcd_reg[27:24]>4'd4) number_bcd_reg[27:24] <= number_bcd_reg[27:24]+2'd3;
					if(number_bcd_reg[31:28]>4'd4) number_bcd_reg[31:28] <= number_bcd_reg[31:28]+2'd3;
			//		if(number_bcd_reg[35:32]>4'd4) number_bcd_reg[35:32] <= number_bcd_reg[35:32]+2'd3;
					state <= 1'b0;
				end
			endcase
		end
	end
	
endmodule 
