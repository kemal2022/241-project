module KeylessEntry (
    input wire clk,
    input wire reset,
    input wire [3:0] digit_in,
    input wire submit,
    output reg door_unlocked
);

parameter [15:0] STORED_CODE = 16'b1001_0010_1100_0111;

reg [15:0] entered_code;
reg [1:0] digit_count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        entered_code <= 16'b0;
        digit_count <= 2'b0;
        door_unlocked <= 1'b0;
    end else if (submit) begin
        if (entered_code == STORED_CODE) begin
            door_unlocked <= 1'b1;
        end else begin
            door_unlocked <= 1'b0;
        end
        entered_code <= 16'b0;
        digit_count <= 2'b0;
    end else if (digit_count < 4) begin
        entered_code <= {entered_code[11:0], digit_in};
        digit_count <= digit_count + 1;
    end
end

endmodule














module PeopleCounter (
    input wire clk,
    input wire reset,
    input wire sensor_in,
    input wire sensor_out,
    output reg [7:0] people_count,
    output reg door_locked
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        people_count <= 8'b0;
        door_locked <= 1'b1;
    end else begin
        if (sensor_in && !sensor_out) begin
            if (people_count < 255) begin
                people_count <= people_count + 1;
            end
        end else if (sensor_out && !sensor_in) begin
            if (people_count > 0) begin
                people_count <= people_count - 1;
            end
        end
        
        if (people_count == 0) begin
            door_locked <= 1'b1;
        end else begin
            door_locked <= 1'b0;
        end
    end
end

endmodule



















module RemoteControlSystem (
    input wire clk,
    input wire reset,
    input wire [2:0] command,
    output reg refrigerator_on,
    output reg oven_on,
    output reg others_on
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        refrigerator_on <= 1'b0;
        oven_on <= 1'b0;
        others_on <= 1'b0;
    end else begin
        case (command)
            3'b001: refrigerator_on <= 1'b1;
            3'b010: refrigerator_on <= 1'b0;
            3'b011: oven_on <= 1'b1;
            3'b100: oven_on <= 1'b0;
            3'b101: others_on <= 1'b1;
            3'b110: others_on <= 1'b0;
            default: begin
                refrigerator_on <= refrigerator_on;
                oven_on <= oven_on;
                others_on <= others_on;
            end
        endcase
    end
end

endmodule















module AutomaticAirConditioning (
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,
    output reg ac_on,
    output reg heater_on
);

parameter COOL_THRESHOLD = 8'd25;
parameter HEAT_THRESHOLD = 8'd18;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ac_on <= 1'b0;
        heater_on <= 1'b0;
    end else begin
        if (temperature > COOL_THRESHOLD) begin
            ac_on <= 1'b1;
            heater_on <= 1'b0;
        end else if (temperature < HEAT_THRESHOLD) begin
            ac_on <= 1'b0;
            heater_on <= 1'b1;
        end else begin
            ac_on <= 1'b0;
            heater_on <= 1'b0;
        end
    end
end

endmodule











module WindowControlSystem (
    input wire clk,
    input wire reset,
    input wire window_open,
    output reg heating_off,
    output reg cooling_off
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        heating_off <= 1'b0;
        cooling_off <= 1'b0;
    end else begin
        if (window_open) begin
            heating_off <= 1'b1;
            cooling_off <= 1'b1;
        end else begin
            heating_off <= 1'b0;
            cooling_off <= 1'b0;
        end
    end
end

endmodule














module SecuritySystem (
    input wire clk,
    input wire reset,
    input wire people_count_zero,
    output reg security_on
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        security_on <= 1'b0;
    end else begin
        if (people_count_zero) begin
            security_on <= 1'b1;
        end else begin
            security_on <= 1'b0;
        end
    end
end

endmodule
