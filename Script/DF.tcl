# Set working directory
set workdir c:/Verilog/UART
cd $workdir
set projectname prj
file mkdir ./$projectname
set part xc7a35tcpg236-1
create_project $projectname ./$projectname -part $part
# Add design source to this project
# header
read_verilog ./RTL/uart_rx.v
read_verilog ./RTL/uart_tx.v
read_verilog ./RTL/uart.v
# Add testbench to this project
read_verilog ./TB/uart_tb.v
puts "CREATE PROJECT CORRECTLY!"
# Open GUI
start_gui
