module finalProject(
		input CLK_50,
		input button_left,
		input button_right,
		input button_reset,
		output reg [3:0]vga_red,
		output reg [3:0]vga_green,
		output reg [3:0]vga_blue,
		output reg vga_v_sync,
		output reg vga_h_sync,
		output reg [9:0]led_debug
		);
		
		
wire VGA_CLK;
wire TIME_CLK;

reg [15:0]v_pos = 0;
reg [15:0]h_pos = 0;
reg [3:0]player_pos = 3;
reg enemy_pos = 0;
reg [1:0]player_input = 0;
wire [1:0]player_input_wire;

reg [3:0] start_delay = 10;

reg end_screen = 1;

localparam [10:0]end_offset_x = 313 + hor_back_porch;
localparam [10:0]end_offset_y = 288 + ver_back_porch;

reg [3:0]bullet_pos_x = 0;
reg [3:0]bullet_pos_y = 6;
reg [2:0]bullet_stats=0;
//reg [10:0]enemy_stats = 10'b11111_11111;
reg [10:0]enemy_stats = 6'b111_111;

reg [5:0]explosion_pos = -1;
reg [12:0]explosion_stats = 0;

localparam [3:0]enemy_count = 6;
localparam [3:0]enemy_width = 10;
localparam [3:0]enemy_height = 10;
		
localparam [15:0]hor_active_pixels = 800;
localparam [7:0]hor_front_porch = 40;
localparam [7:0]hor_sync_width = 128;
localparam [7:0]hor_back_porch = 88;
localparam [15:0]hor_total_pixels = hor_active_pixels + hor_back_porch + hor_front_porch + hor_sync_width;
localparam [10:0]hor_interval_pixels = hor_active_pixels / (enemy_count*2 + 1);

localparam [15:0]ver_active_pixels = 600;
localparam [7:0]ver_front_porch = 1;
localparam [7:0]ver_sync_width = 4;
localparam [7:0]ver_back_porch = 23;
localparam [15:0]ver_total_pixels = ver_active_pixels + ver_back_porch + ver_front_porch + ver_sync_width;
localparam [10:0]ver_interval_pixels = ver_active_pixels / 7;

integer i,j,k;

freq_divider_40MHz(CLK_50,VGA_CLK);
GAME_CLK(CLK_50,TIME_CLK);

always @(posedge VGA_CLK)
begin
	h_pos <= h_pos + 1;
	
	if(h_pos >= hor_total_pixels)
	begin
		h_pos <= 0;
		v_pos <= v_pos + 1;
		
		if(v_pos >= ver_total_pixels)
			v_pos <= 0;
	end
	
	if( v_pos >= ver_back_porch &
		 v_pos < ver_back_porch + ver_active_pixels &
		 h_pos >= hor_back_porch &
		 h_pos < hor_back_porch + hor_active_pixels & start_delay == 0)

	begin
		
		vga_red <= 4'h0;
		vga_green <= 4'h0;
		vga_blue <= 4'h0;
		
		
		if(enemy_stats == 0)
		begin
			if(end_screen)
			begin
				if( // Y
					(
					h_pos >= end_offset_x + 0 & h_pos <= end_offset_x + 4 &
					v_pos >= end_offset_y + 0 & v_pos <= end_offset_y + 4
					)|(
					h_pos >= end_offset_x + 5 & h_pos <= end_offset_x + 9 &
					v_pos >= end_offset_y + 5 & v_pos <= end_offset_y + 9
					)|(
					h_pos >= end_offset_x + 10 & h_pos <= end_offset_x + 14 &
					v_pos >= end_offset_y + 10 & v_pos <= end_offset_y + 24
					)|(
					h_pos >= end_offset_x + 15 & h_pos <= end_offset_x + 19 &
					v_pos >= end_offset_y + 5 & v_pos <= end_offset_y + 9
					)|(
					h_pos >= end_offset_x + 20 & h_pos <= end_offset_x + 24 &
					v_pos >= end_offset_y + 0 & v_pos <= end_offset_y + 4
					)
					)
				begin
						vga_red <= 4'hE;
						vga_green <= 4'hF;
						vga_blue <= 4'h5;
				end
				
				
				if( // O
					(
					h_pos >= end_offset_x + 30 & h_pos <= end_offset_x + 49 &
					v_pos >= end_offset_y + 0 & v_pos <= end_offset_y + 24
					)&!(
					h_pos >= end_offset_x + 35 & h_pos <= end_offset_x + 44 &
					v_pos >= end_offset_y + 5 & v_pos <= end_offset_y + 19
					)
					)
				begin
						vga_red <= 4'hE;
						vga_green <= 4'hF;
						vga_blue <= 4'h5;
				end
				
				if( // U
					(
					h_pos >= end_offset_x + 55 & h_pos <= end_offset_x + 74 &
					v_pos >= end_offset_y + 0 & v_pos <= end_offset_y + 24
					)&!(
					h_pos >= end_offset_x + 60 & h_pos <= end_offset_x + 69 &
					v_pos >= end_offset_y + 0 & v_pos <= end_offset_y + 19
					)
					)
				begin
						vga_red <= 4'hE;
						vga_green <= 4'hF;
						vga_blue <= 4'h5;
				end
				
				if( // W
					(
					h_pos >= end_offset_x + 90 & h_pos <= end_offset_x + 94 &
					v_pos >= end_offset_y + 0 & v_pos <= end_offset_y + 19
					)|(
					h_pos >= end_offset_x + 95 & h_pos <= end_offset_x + 99 &
					v_pos >= end_offset_y + 20 & v_pos <= end_offset_y + 24
					)|(
					h_pos >= end_offset_x + 100 & h_pos <= end_offset_x + 104 &
					v_pos >= end_offset_y + 10 & v_pos <= end_offset_y + 19
					)|(
					h_pos >= end_offset_x + 105 & h_pos <= end_offset_x + 109 &
					v_pos >= end_offset_y + 5 & v_pos <= end_offset_y + 9
					)|(
					h_pos >= end_offset_x + 110 & h_pos <= end_offset_x + 114 &
					v_pos >= end_offset_y + 10 & v_pos <= end_offset_y + 19
					)|(
					h_pos >= end_offset_x + 115 & h_pos <= end_offset_x + 119 &
					v_pos >= end_offset_y + 20 & v_pos <= end_offset_y + 24
					)|(
					h_pos >= end_offset_x + 120 & h_pos <= end_offset_x + 124 &
					v_pos >= end_offset_y + 0 & v_pos <= end_offset_y + 19
					)
					)
				begin
						vga_red <= 4'hE;
						vga_green <= 4'hF;
						vga_blue <= 4'h5;
				end
				
				if( // I
					(
					h_pos >= end_offset_x + 130 & h_pos <= end_offset_x + 144 &
					v_pos >= end_offset_y + 0 & v_pos <= end_offset_y + 4
					)|(
					h_pos >= end_offset_x + 135 & h_pos <= end_offset_x + 139 &
					v_pos >= end_offset_y + 5 & v_pos <= end_offset_y + 19
					)|(
					h_pos >= end_offset_x + 130 & h_pos <= end_offset_x + 144 &
					v_pos >= end_offset_y + 20 & v_pos <= end_offset_y + 24
					)
					)
				begin
						vga_red <= 4'hE;
						vga_green <= 4'hF;
						vga_blue <= 4'h5;
				end
				
				if( // I
					(
					h_pos >= end_offset_x + 150 & h_pos <= end_offset_x + 154 &
					v_pos >= end_offset_y + 0 & v_pos <= end_offset_y + 24
					)|(
					h_pos >= end_offset_x + 155 & h_pos <= end_offset_x + 159 &
					v_pos >= end_offset_y + 5 & v_pos <= end_offset_y + 9
					)|(
					h_pos >= end_offset_x + 160 & h_pos <= end_offset_x + 164 &
					v_pos >= end_offset_y + 10 & v_pos <= end_offset_y + 14
					)|(
					h_pos >= end_offset_x + 165 & h_pos <= end_offset_x + 169 &
					v_pos >= end_offset_y + 15 & v_pos <= end_offset_y + 19
					)|(
					h_pos >= end_offset_x + 170 & h_pos <= end_offset_x + 174 &
					v_pos >= end_offset_y + 0 & v_pos <= end_offset_y + 24
					)
					)
				begin
						vga_red <= 4'hE;
						vga_green <= 4'hF;
						vga_blue <= 4'h5;
				end
			end
			
		end
		else
		begin
			// playing render
			
			// enemy render
			if(enemy_pos)
			begin // left side
				for(i = 0 ; i < enemy_count;i = i + 1) // all enemy
				begin
					if(h_pos >= (i*2 + 1) * hor_interval_pixels + hor_back_porch - 17 &
						h_pos <= (i*2 + 1) * hor_interval_pixels + hor_back_porch - 11&
						v_pos >= 1 * ver_interval_pixels + ver_back_porch - 10 &
						v_pos <= 1 * ver_interval_pixels + ver_back_porch - 4 &
						enemy_stats[i])
					begin
						vga_red <= 4'hE;
						vga_green <= 4'h8;
						vga_blue <= 4'h0;
					end
					
					if(h_pos >= (i*2 + 1) * hor_interval_pixels + hor_back_porch + 11 &
						h_pos <= (i*2 + 1) * hor_interval_pixels + hor_back_porch + 17&
						v_pos >= 1 * ver_interval_pixels + ver_back_porch - 10 &
						v_pos <= 1 * ver_interval_pixels + ver_back_porch - 4 &
						enemy_stats[i])
					begin
						vga_red <= 4'hE;
						vga_green <= 4'h8;
						vga_blue <= 4'h0;
					end
					
					if(h_pos >= (i*2 + 1) * hor_interval_pixels + hor_back_porch - 10 &
						h_pos <= (i*2 + 1) * hor_interval_pixels + hor_back_porch + 10&
						v_pos >= 1 * ver_interval_pixels + ver_back_porch - 3 &
						v_pos <= 1 * ver_interval_pixels + ver_back_porch + 3 &
						enemy_stats[i])
					begin
						vga_red <= 4'hE;
						vga_green <= 4'h8;
						vga_blue <= 4'h0;
					end
					
					if(h_pos >= (i*2 + 1) * hor_interval_pixels + hor_back_porch - 3 &
						h_pos <= (i*2 + 1) * hor_interval_pixels + hor_back_porch + 3&
						v_pos >= 1 * ver_interval_pixels + ver_back_porch + 4 &
						v_pos <= 1 * ver_interval_pixels + ver_back_porch + 10 &
						enemy_stats[i])
					begin
						vga_red <= 4'hE;
						vga_green <= 4'h8;
						vga_blue <= 4'h0;
					end
				end
				
			end
			else
			begin // right side
				for(i = 0 ; i < enemy_count;i = i + 1) // all enemy
				begin
					if(h_pos >= (i+1)* 2 * hor_interval_pixels + hor_back_porch - 17 &
						h_pos <= (i+1)* 2 * hor_interval_pixels + hor_back_porch - 10&
						v_pos >= 1 * ver_interval_pixels + ver_back_porch - 11 &
						v_pos <= 1 * ver_interval_pixels + ver_back_porch - 4 &
						enemy_stats[i])
					begin
						vga_red <= 4'hE;
						vga_green <= 4'h8;
						vga_blue <= 4'h0;
					end
					
					if(h_pos >= (i+1)* 2 * hor_interval_pixels + hor_back_porch + 11 &
						h_pos <= (i+1)* 2 * hor_interval_pixels + hor_back_porch + 17&
						v_pos >= 1 * ver_interval_pixels + ver_back_porch - 10 &
						v_pos <= 1 * ver_interval_pixels + ver_back_porch - 4 &
						enemy_stats[i])
					begin
						vga_red <= 4'hE;
						vga_green <= 4'h8;
						vga_blue <= 4'h0;
					end
					
					if(h_pos >= (i+1)* 2 * hor_interval_pixels + hor_back_porch - 10 &
						h_pos <= (i+1)* 2 * hor_interval_pixels + hor_back_porch + 10&
						v_pos >= 1 * ver_interval_pixels + ver_back_porch - 3 &
						v_pos <= 1 * ver_interval_pixels + ver_back_porch + 3 &
						enemy_stats[i])
					begin
						vga_red <= 4'hE;
						vga_green <= 4'h8;
						vga_blue <= 4'h0;
					end
					
					if(h_pos >= (i+1)* 2 * hor_interval_pixels + hor_back_porch - 3 &
						h_pos <= (i+1)* 2 * hor_interval_pixels + hor_back_porch + 3&
						v_pos >= 1 * ver_interval_pixels + ver_back_porch + 4 &
						v_pos <= 1 * ver_interval_pixels + ver_back_porch + 10 &
						enemy_stats[i])
					begin
						vga_red <= 4'hE;
						vga_green <= 4'h8;
						vga_blue <= 4'h0;
					end
				end
			end
			
			
			// player render
			for(i=0;i< enemy_count*2 + 1;i=i+1)
				if(player_pos == i)
				begin
					if(h_pos >= (i+1) * hor_interval_pixels + hor_back_porch - 3 &
						h_pos <= (i+1) * hor_interval_pixels + hor_back_porch + 4 &
						v_pos >= enemy_count * ver_interval_pixels + ver_back_porch - 10 &
						v_pos <= enemy_count * ver_interval_pixels + ver_back_porch + 3)
					begin
						vga_red <= 4'h3;
						vga_green <= 4'hC;
						vga_blue <= 4'hF;
					end
					if(h_pos >= (i+1) * hor_interval_pixels + hor_back_porch + 4 &
						h_pos <= (i+1) * hor_interval_pixels + hor_back_porch + 10 &
						v_pos >= enemy_count * ver_interval_pixels + ver_back_porch - 3 &
						v_pos <= enemy_count * ver_interval_pixels + ver_back_porch + 10)
					begin
						vga_red <= 4'h3;
						vga_green <= 4'hC;
						vga_blue <= 4'hF;
					end
					if(h_pos >= (i+1) * hor_interval_pixels + hor_back_porch - 10 &
						h_pos <= (i+1) * hor_interval_pixels + hor_back_porch - 4 &
						v_pos >= enemy_count * ver_interval_pixels + ver_back_porch - 3 &
						v_pos <= enemy_count * ver_interval_pixels + ver_back_porch + 10)
					begin
						vga_red <= 4'h3;
						vga_green <= 4'hC;
						vga_blue <= 4'hF;
					end
				end
			
			for(i = 0 ; i < enemy_count * 2 + 1;i = i + 1) // x
			
				
				if(explosion_pos == i)
				begin // explosion render

					if(explosion_stats == 1)
					begin // second frame explosion animation
						for(j=-12;j <= 8 ;j = j + 5)
						begin
							if(h_pos >= (i+1) * hor_interval_pixels + hor_back_porch + j &
								h_pos <= (i+1) * hor_interval_pixels + hor_back_porch + j + 5 &
								((
								v_pos >= 1 * ver_interval_pixels + ver_back_porch + j &
								v_pos <= 1 * ver_interval_pixels + ver_back_porch + j  + 5
								)
								||
								(
								v_pos >= 1 * ver_interval_pixels + ver_back_porch + (-4 - j) &
								v_pos <= 1 * ver_interval_pixels + ver_back_porch + (-4 - j) + 5
								)) &
								j != 2)
							begin
								vga_red <= 4'hF;
								vga_green <= 4'h2;
								vga_blue <= 4'h4;
							end
						end
					end
					else 
					begin // first and third frame explosion animation
						for(j=-17;j <= 13 ;j = j + 5)
						begin
							if(h_pos >= (i+1) * hor_interval_pixels + hor_back_porch + j &
								h_pos <= (i+1) * hor_interval_pixels + hor_back_porch + j + 5 &
								((
								v_pos >= 1 * ver_interval_pixels + ver_back_porch + j &
								v_pos <= 1 * ver_interval_pixels + ver_back_porch + j  + 5
								)
								||
								(
								v_pos >= 1 * ver_interval_pixels + ver_back_porch + (-4 - j) &
								v_pos <= 1 * ver_interval_pixels + ver_back_porch + (-4 - j) + 5
								)) &
								(j < -7 || j > 3))
							begin
								vga_red <= 4'hF;
								vga_green <= 4'h2;
								vga_blue <= 4'h4;
							end
						end
					end
					
				end
				else if(bullet_pos_x == i) 
					// bullet render
					for(j = 0 ; j < enemy_count - 1;j = j + 1) // y
					begin
						if(h_pos == (i + 1) * hor_interval_pixels + hor_back_porch &
							v_pos >= (j + 1) * ver_interval_pixels + ver_back_porch - 12 &
							v_pos <= (j + 1) * ver_interval_pixels + ver_back_porch - 2 &
							bullet_pos_y == j)
						begin
							vga_red <= 4'hE;
							vga_green <= 4'hF;
							vga_blue <= 4'h2;
						end
						
						
						if(h_pos == (i + 1) * hor_interval_pixels + hor_back_porch &
							v_pos >= (j + 1) * ver_interval_pixels + ver_back_porch + 2 &
							v_pos <= (j + 1) * ver_interval_pixels + ver_back_porch + 12 &
							bullet_pos_y == j)
						begin
						vga_red <= 4'hE;
						vga_green <= 4'hF;
						vga_blue <= 4'h2;
						end
					end
		end
	end
	else
	begin
		 vga_red <= 0;
		 vga_blue <= 0;
		 vga_green <= 0;
	end
	
	if( v_pos < ver_total_pixels - ver_sync_width)
		vga_v_sync <= 1;
	else
		vga_v_sync <= 0;
		
	if(h_pos < hor_total_pixels - hor_sync_width)
		vga_h_sync <= 1;
	else
		vga_h_sync <= 0;
		
end

always @(posedge TIME_CLK)
begin
	led_debug[0] <= 0;
	led_debug[6] <= 0;
	led_debug[9] <= 0;
	if(!button_reset)
	begin
		start_delay <= 3;
		led_debug[6] = 1;
		
		for(i=0;i<enemy_count;i = i + 1)
			enemy_stats[i] = 1;
		
		player_pos <= 3;
		bullet_pos_y = enemy_count;
	end
	else if(start_delay)
	begin
		start_delay <= start_delay - 1;
	end
	else
	begin
	
		enemy_pos <= !enemy_pos;
		if(explosion_pos != -1)
		begin
			explosion_stats <= explosion_stats + 1;
			if(explosion_stats == 2)
			begin
				explosion_stats <= 0;
				explosion_pos <= -1;
			end
		end
		
		// deal player pos
		if(!button_right & player_pos != enemy_count * 2 - 1)
		begin
			led_debug[0] = 1;
			player_pos <= player_pos + 1;
		end
		else if(!button_left & player_pos != 0)
		begin
			led_debug[9] = 1;
			player_pos <= player_pos - 1;
		end
		
		
		
		if(enemy_stats == 0)
			end_screen <= ~end_screen;
		
		// deal bullet
		if(bullet_pos_y == 0) // at end of line
		begin
			bullet_pos_x <= player_pos;
			bullet_pos_y <= enemy_count;
		end
		else if(bullet_pos_y == 1) // prepare to hit enemy
		begin
		
			// check if enemy and bullet at the same line
			if(!enemy_pos ^ bullet_pos_x[0])
			begin
				if(enemy_stats[bullet_pos_x>>1])
				begin
					explosion_pos <= bullet_pos_x;
					explosion_stats <= 0;
				end
				enemy_stats[bullet_pos_x>>1] <= 0;
			end
				
			// set bullet to end of the line
			bullet_pos_y <= 0;
		end
		else if(bullet_pos_y == enemy_count)
		begin
			bullet_pos_x <= player_pos;
			bullet_pos_y <= bullet_pos_y - 1;
		end
		else
		begin
			bullet_pos_y <= bullet_pos_y - 1;
		end
		
		
			
	end
	
	
end

endmodule 


module GAME_CLK(input clk,output reg led);

reg [27:0] counter;
reg clkout;

always @(posedge clk)
begin
    if (counter == 0)
	 begin
        counter <= 10000000;
        led <= ~led;
    end
	 else
	 begin
        counter <= counter - 1;
    end
end
	
	 
endmodule	