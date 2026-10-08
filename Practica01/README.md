# ⚡ Identificación de un Modelo RC de Primer Orden
### 🔬 Adquisición experimental con Arduino + MATLAB/Simulink

![Arduino](https://img.shields.io/badge/Arduino-Adquisición-00979D?style=for-the-badge&logo=arduino&logoColor=white)
![MATLAB](https://img.shields.io/badge/MATLAB-Identificación-orange?style=for-the-badge&logo=mathworks&logoColor=white)
![Simulink](https://img.shields.io/badge/Simulink-Simulación-red?style=for-the-badge&logo=mathworks&logoColor=white)
![Control](https://img.shields.io/badge/Control-Sistemas-blue?style=for-the-badge)

---

## 📌 Descripción

Este proyecto presenta la **identificación experimental de un circuito RC de primer orden** mediante la adquisición de datos con **Arduino** y el procesamiento e identificación del modelo utilizando **MATLAB/Simulink**.

El procedimiento se basa en aplicar un **escalón de entrada de 5 V** al circuito RC y registrar experimentalmente la respuesta de voltaje del capacitor.

Los datos obtenidos mediante Arduino son posteriormente utilizados en **MATLAB**, específicamente mediante **System Identification Toolbox** y la herramienta **Ident**, con el propósito de obtener un modelo matemático que represente el comportamiento dinámico del proceso.

Finalmente, el modelo identificado puede implementarse en **Simulink** para comparar la respuesta simulada con la respuesta experimental.

---

## 🎯 Objetivo

Obtener experimentalmente un **modelo matemático de primer orden** que represente el comportamiento dinámico de un circuito RC, utilizando:

- 🔌 Un circuito RC como proceso físico.
- 🤖 Arduino como sistema de adquisición.
- 💻 MATLAB para procesamiento de datos.
- 🧩 System Identification Toolbox para identificación.
- 📊 Ident para estimación del modelo.
- 🔄 Simulink para simulación y validación.

La identificación se realiza a partir de la respuesta del sistema ante un **escalón de 5 V**.

---

# ⚡ Fundamento teórico

Un circuito RC puede modelarse como un sistema dinámico de primer orden.

La forma general del modelo es:

$$
G(s)=\frac{K}{\tau s+1}
$$

donde:

| Parámetro | Descripción | Unidad |
|---|---|---|
| `K` | Ganancia estática | — |
| `τ` | Constante de tiempo | s |
| `s` | Variable de Laplace | — |

Para un circuito RC ideal:

$$
\tau=RC
$$

donde:

- `R` = resistencia [Ω]
- `C` = capacitancia [F]
- `τ` = constante de tiempo [s]

---

# 📈 Respuesta al escalón

La entrada utilizada durante el experimento es un escalón de:

$$
V_{in}=5V
$$

Para un sistema de primer orden con ganancia unitaria, la respuesta ideal es:

$$
V_{out}(t)=5(1-e^{-t/\tau})
$$

Esta respuesta permite determinar experimentalmente la dinámica del circuito.

---

# ⏱️ Criterio de estabilización

Para este proyecto se utiliza como criterio práctico de estabilización:

$$
t_s \approx 5\tau
$$

Después de cinco constantes de tiempo, la respuesta de un sistema de primer orden ideal alcanza aproximadamente el:

$$
99.3\%
$$

del valor final.

### 📊 Evolución aproximada de la respuesta

| Tiempo | % del valor final |
|---|---:|
| `1τ` | 63.2 % |
| `2τ` | 86.5 % |
| `3τ` | 95.0 % |
| `4τ` | 98.2 % |
| `5τ` | 99.3 % |

Para un escalón de 5 V:

$$
V_{out}(5\tau) = 5(1-e^{-5}) \approx 4.97V 
$$

Por lo tanto, el proceso de adquisición debe mantenerse durante un tiempo suficiente para observar aproximadamente **5τ**.

---

# 🔬 Metodología experimental

El procedimiento general es:

```text
        ⚡ Escalón de 5 V
               │
               ▼
        ┌─────────────┐
        │  Circuito RC │
        │   Proceso    │
        └──────┬──────┘
               │
               │ Vout(t)
               ▼
        ┌─────────────┐
        │   Arduino   │
        │ Adquisición  │
        └──────┬──────┘
               │
               │ Datos
               ▼
        ┌─────────────┐
        │    MATLAB   │
        └──────┬──────┘
               │
               ▼
       ┌─────────────────┐
       │ System          │
       │ Identification  │
       │      / Ident    │
       └──────┬──────────┘
              │
              ▼
       ┌─────────────────┐
       │ Modelo de       │
       │ primer orden    │
       └──────┬──────────┘
              │
              ▼
        ┌─────────────┐
        │   Simulink  │
        │  Validación │
        └─────────────┘
