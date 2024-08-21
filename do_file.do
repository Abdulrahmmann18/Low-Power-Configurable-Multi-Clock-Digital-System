vlib work
vlog -f source_list.txt
vsim -voptargs=+accs work.System_TOP_tb
add wave *
add wave -position insertpoint  \
sim:/System_TOP_tb/DUT/RX_Data_valid_OUT_top \
sim:/System_TOP_tb/DUT/ALU_OUT_VALID_top \
sim:/System_TOP_tb/DUT/reg_file_RdData_valid_top \
sim:/System_TOP_tb/DUT/SYNC_RX_DATA_VALID_top \
sim:/System_TOP_tb/DUT/ALU_Enable_top \
sim:/System_TOP_tb/DUT/CLK_GATE_Enable_top \
sim:/System_TOP_tb/DUT/reg_file_WrEn_top \
sim:/System_TOP_tb/DUT/reg_file_RdEn_top \
sim:/System_TOP_tb/DUT/FULL_top \
sim:/System_TOP_tb/DUT/EMPTY_top \
sim:/System_TOP_tb/DUT/W_INC_top \
sim:/System_TOP_tb/DUT/R_INC_top \
sim:/System_TOP_tb/DUT/Busy_top \
sim:/System_TOP_tb/DUT/ALU_FUNC_top \
sim:/System_TOP_tb/DUT/Reg_file_Adderss_top \
sim:/System_TOP_tb/DUT/reg_file_WrData_top \
sim:/System_TOP_tb/DUT/RX_P_DATA_OUT_top \
sim:/System_TOP_tb/DUT/reg_file_RdData_top \
sim:/System_TOP_tb/DUT/SYNC_RX_P_DATA_top \
sim:/System_TOP_tb/DUT/fifo_WR_DATA_top \
sim:/System_TOP_tb/DUT/fifo_RD_DATA_top \
sim:/System_TOP_tb/DUT/ALU_OUT_top
add wave -position insertpoint  \
sim:/System_TOP_tb/DUT/uart_inst/TX_CLK
add wave -position insertpoint  \
sim:/System_TOP_tb/DUT/alu_inst/A \
sim:/System_TOP_tb/DUT/alu_inst/B
add wave -position insertpoint  \
sim:/System_TOP_tb/DUT/sys_cntrol_inst/TX_P_DATA \
sim:/System_TOP_tb/DUT/sys_cntrol_inst/TX_DATA_VALID \
sim:/System_TOP_tb/DUT/sys_cntrol_inst/CS \
sim:/System_TOP_tb/DUT/sys_cntrol_inst/Reg_file_Adderss_temp
add wave -position insertpoint  \
sim:/System_TOP_tb/DUT/fifo_inst/F_MEM/fifo_mem
add wave -position insertpoint  \
sim:/System_TOP_tb/DUT/fifo_inst/W_INC \
sim:/System_TOP_tb/DUT/fifo_inst/R_INC
add wave -position insertpoint  \
sim:/System_TOP_tb/DUT/rfile_inst/R_FILE
run -all