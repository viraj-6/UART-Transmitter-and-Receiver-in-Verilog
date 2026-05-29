# UART Transmitter and Receiver in Verilog

## Overview
This project implements a UART communication system using Verilog HDL. The design includes UART Transmitter (TX), UART Receiver (RX), and Baud Rate Generator modules.

## Features
- UART Transmitter (TX)
- UART Receiver (RX)
- Start and Stop Bit Detection
- Configurable Baud Rate
- Verilog Testbench
- Functional Simulation Verification

## Project Structure
UART/
├── UART_tx.v
├── UART_rx.v
├── baud_rate_generator.v
├── uart_tb.v
└── README.md

## Protocol Format
- Start Bit: 1
- Data Bits: 8
- Parity: None
- Stop Bit: 1

## Simulation Results
Successfully transmitted and received multiple data bytes with correct UART timing.

## Tools Used
- Verilog HDL
- ModelSim / Vivado / Xilinx ISE

## Author
Viraj
