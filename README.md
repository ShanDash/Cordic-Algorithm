# Verilog CORDIC Sin/Cos Calculator

This repository contains a simple Verilog implementation of the **CORDIC (COordinate Rotation DIgital Computer) algorithm** to calculate sine and cosine values for a given input angle.  
It uses an iterative shift-add method suitable for FPGA or ASIC designs where hardware multipliers are expensive.

---

## 📌 **How It Works**

- The algorithm rotates an initial vector `(K, 0)` by the desired input angle using a series of micro-rotations.
- Each rotation uses only shifts and additions.
- The constant `K` compensates for the CORDIC gain.
- The angle is given in **Q1.14 fixed-point format** (1 sign bit, 1 integer bit, 14 fraction bits).
- After 8 iterations, the outputs `sin` and `cos` are available in the same Q1.14 format.

---

## 🔑 **Module I/O**

| Signal | Width | Description |
|--------|-------|--------------|
| `clk` | 1 | Clock signal |
| `reset` | 1 | Asynchronous reset |
| `start` | 1 | Start signal for operation |
| `angle_radian` | 16 | Signed input angle in radians (Q1.14) |
| `sin` | 16 | Calculated sine output (Q1.14) |
| `cos` | 16 | Calculated cosine output (Q1.14) |
| `done` | 1 | High when calculation is complete |

---

## ⚙️ **CORDIC Parameters**

- `K` is the CORDIC gain factor ≈ 0.60725.
- `tan_table` stores `atan(2^-i)` values in Q1.14 format for 8 iterations.

---

## ✅ **Usage**

1. Set `reset` high to reset the module.
2. Set `angle_radian` to the desired angle (in radians, scaled to Q1.14).
3. Set `start` high for 1 clock cycle.
4. Wait for `done` to go high.
5. Read `sin` and `cos`.

---

## 🧮 **Example Angle Encoding**

- `π/4` rad ≈ 0.785398 rad
- To convert to Q1.14: `0.785398 * 2^14 ≈ 12867`
- So `angle_radian = 16'sd12867` ≈ 45°.

---

## 🚦 **Key Points**

- Only uses shifts and adds — no multipliers.
- Easy to expand: Add more iterations for higher accuracy.
- Designed for hardware synthesis.
- Fully synchronous.
