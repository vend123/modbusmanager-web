# ModbusManager Pro - ebm-papst 16-fan demo

A ready-made ModbusManager Pro workspace that monitors sixteen ebm-papst EC fans
over Modbus RTU on one dashboard - speed, motor status and power for every fan.

Run it with NO hardware (built-in slave simulator) or against real ebm-papst fans.

## What's inside
- `ebmpapst_16fans_workspace.json` - the Pro workspace: 16 poll windows, tags,
  the motor-status script and a finished dashboard page (fan widget + power value
  + status lamp per fan).

## Register map

ebm-papst EC fans use Modbus and decimal register addresses (the parameter "D"
numbers are hexadecimal, e.g. D010 = 53264). The feedback parameters below are
read with function code 04 (input registers); the speed setpoint is written with
function code 06 (holding register). The demo uses the four highlighted rows.

| Addr (dec) | Param | Value                         | Access     | Notes                         |
|------------|-------|-------------------------------|------------|-------------------------------|
| 53249      | D001  | **Speed setpoint**            | FC06 write | 0-65535 = 0-100% of max speed |
| 53264      | D010  | **Actual speed**              | FC04 read  | 0-65535 = 0-100%; 0xFFF0 cap  |
| 53265      | D011  | **Motor status** (0 = OK)     | FC04 read  | fault bitfield - see below    |
| 53266      | D012  | Warning                       | FC04 read  | warning bitfield (precursors) |
| 53267      | D013  | DC-link voltage               | FC04 read  | -                             |
| 53268      | D014  | DC-link current               | FC04 read  | -                             |
| 53269      | D015  | **Module temperature**        | FC04 read  | signed, degC                  |
| 53270      | D016  | Motor temperature             | FC04 read  | signed, degC                  |
| 53271      | D017  | Electronics temperature       | FC04 read  | signed, degC                  |
| 53272      | D018  | Direction of rotation         | FC04 read  | -                             |
| 53273      | D019  | Modulation level              | FC04 read  | -                             |
| 53274      | D01A  | Current set value             | FC04 read  | speed or other, by mode       |
| 53281      | D021  | **Current power**             | FC04 read  | W                             |

### Motor-status bits (D011) - 0 means healthy
A set bit means that fault is active:
- UzLow  - DC-link undervoltage
- RL_Cal - rotor-position sensor calibration error
- n_Limit- speed limit exceeded
- HLL    - Hall-sensor error
- FB     - Fan Bad (general fault; set whenever any error is active)
- SKF    - internal master/slave controller communication error
- PHA    - phase failure (3-phase) or line undervoltage (single-phase)

The demo's status script treats status = 0 as OK (lamp green) and anything else
as a fault (lamp red).

### Bus settings
Modbus RTU, 19200 baud, 8 data bits, even parity, 1 stop bit (8E1).
Up to 247 fans on one RS-485 bus. The demo uses slave addresses 1-16.

NOTE: the setpoint (D001) is stored in EEPROM (limited write cycles). Write it
only when it changes, never continuously.

> The table above lists the parameters the demo uses, in our own words. It is not
> a substitute for the manufacturer documentation. For the complete and
> authoritative register map - all parameters, exact bit layouts, scaling and any
> model-specific differences - refer to the official ebm-papst Modbus
> documentation for your fan (the "MODBUS parameter / Series" manual), available
> from ebm-papst. Always verify addresses against your specific fan type before
> writing to it.

## How to run it

1. Open the workspace in ModbusManager Pro (Workspace -> open the .json).
   It loads 16 poll windows, the tags, the status script and the dashboard page.

2. Pick a source:
   - No fans: open the Slave tab. The workspace defines 16 input-register blocks
     (53264-53281) on slave IDs 1-16. Start the TCP server and drive the speed
     register (53264) on a fan - e.g. add a Simulate counter (Min 0, Max 64000,
     Step 1) so the dashboard looks alive.
   - Real fans: wire the fans on RS-485 and skip the simulator.

3. Connect:
   - Real fans: connect over Modbus RTU at 19200, 8E1 to your USB-RS485 adapter.
   - Simulator: connect over Modbus TCP to 127.0.0.1:502.
   Each fan is one slave address (1-16).

4. Start the script loop (Tags -> Start loop) and switch the dashboard to Runtime.
   Speed, power and the status lamps update live across all 16 fans.

## Notes
- The actual-speed feedback (D010) is capped at 0xFFF0 (1.02 x max speed); the fan
  widget shows it as a rounded percentage.
- Input registers are read-only. To change speed, write the setpoint (D001, FC06).

ModbusManager Pro - https://modbusmanager.com
