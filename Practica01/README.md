# 🔬 Identificación Experimental de un Sistema RC de Primer Orden

<p align="center">

  <img src="https://img.shields.io/badge/Arduino-00979D?style=for-the-badge&logo=arduino&logoColor=white">
  <img src="https://img.shields.io/badge/MATLAB-orange?style=for-the-badge&logo=mathworks&logoColor=white">
  <img src="https://img.shields.io/badge/Simulink-0076A8?style=for-the-badge&logo=mathworks&logoColor=white">
  <img src="https://img.shields.io/badge/System%20Identification-Toolbox-4CAF50?style=for-the-badge">
  
</p>

<p align="center">
  <b>Adquisición experimental con Arduino + Identificación de sistemas mediante MATLAB/Simulink</b>
</p>

---

## 🎯 Objetivo

Identificar experimentalmente el **modelo dinámico de un sistema RC de primer orden** a partir de datos reales adquiridos mediante **Arduino**, utilizando **MATLAB/Simulink y System Identification Toolbox**.

La metodología establece la siguiente relación:

```text
       📥 ENTRADA              ⚙️ PROCESO              📤 SALIDA
       Vin(t)                    Sistema RC              Vout(t)
          │                      1er orden                  │
          │                           │                     │
          └──────────────► 🧪 ────────┴──────────► 📊 ─────┘

| 🔹 Característica | 📌 Descripción                        |
| ----------------- | ------------------------------------- |
| 🧪 Planta         | Sistema RC de primer orden            |
| 🔌 Entrada        | Escalón de **5 V**                    |
| 📈 Salida         | Voltaje en el capacitor               |
| 🤖 Adquisición    | Arduino                               |
| 💻 Procesamiento  | MATLAB / Simulink                     |
| 🔎 Identificación | System Identification Toolbox         |
| 🖥️ Herramienta   | `ident`                               |
| 📐 Modelo         | Función de transferencia de 1er orden |
| ⏱️ Estabilización | Aproximadamente **5τ**                |
| 🎯 Valor final    | Aproximadamente **5 V**               |
