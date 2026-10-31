# ⚡ Control Proporcional (P) de un Sistema RC de Primer Orden

### 🔬 Implementación con Arduino + MATLAB/Simulink

![Arduino](https://img.shields.io/badge/Arduino-Control%20y%20adquisición-00979D?style=for-the-badge&logo=arduino&logoColor=white)
![MATLAB](https://img.shields.io/badge/MATLAB-Análisis-orange?style=for-the-badge&logo=mathworks&logoColor=white)
![Simulink](https://img.shields.io/badge/Simulink-Modelado-red?style=for-the-badge)
![Control](https://img.shields.io/badge/Control-Proporcional%20(P)-blue?style=for-the-badge)

---

## 📌 1. Descripción

Este proyecto presenta el diseño e implementación de un **controlador proporcional (P) para un sistema RC de primer orden**, utilizando Arduino como plataforma de control y adquisición de datos, y MATLAB/Simulink para el modelado, análisis y simulación del comportamiento dinámico.

El sistema utiliza la tensión medida en el capacitor como variable de proceso. Esta señal se compara con una referencia establecida por el usuario para calcular el error de control.

El controlador proporcional genera una señal de salida directamente relacionada con la magnitud del error:

\[
u(t)=K_p e(t)
\]

La señal de control se aplica al circuito RC para modificar su respuesta y reducir la diferencia entre la referencia y la variable medida.

A diferencia del controlador ON/OFF, el controlador proporcional no trabaja únicamente con dos estados. Su salida puede adoptar diferentes valores dentro del intervalo de operación permitido.

---

## 🎯 2. Objetivo

Implementar y analizar un controlador proporcional para regular la tensión de un circuito RC de primer orden, con una constante de tiempo aproximada de:

\[
\tau \approx 1\ s
\]

El proyecto integra los siguientes elementos:

- 🔌 Circuito RC como proceso físico.
- 🤖 Arduino para el control y adquisición de datos.
- 🎚️ Referencia de voltaje ajustable.
- 📐 Cálculo del error de control.
- ⚙️ Algoritmo de control proporcional.
- 🔄 Etapa de acondicionamiento de la señal de control.
- 💻 MATLAB para el procesamiento y análisis de datos.
- 🧩 Simulink para el modelado y simulación del sistema.

---

## 🧱 3. Arquitectura del sistema

El sistema se organiza en cinco bloques funcionales:

1. **Referencia:** establece la tensión deseada para el capacitor.
2. **Punto de suma:** calcula el error entre la referencia y la medición.
3. **Controlador proporcional:** multiplica el error por la ganancia proporcional Kp.
4. **Proceso RC:** responde a la señal de control aplicada.
5. **Salida y retroalimentación:** mide la tensión del capacitor y la devuelve al punto de suma.

### Diagrama funcional

```text
        Referencia r(t)
               |
               v
          +---------+
          |  SUMA   |<----------------------+
          |  +   -  |                       |
          +----+----+                       |
               | e(t)                      |
               v                           |
        +-------------+                    |
        | Controlador |                    |
        |      P      |                    |
        | u(t)=Kp*e(t)|                    |
        +------+------+                    |
               | u(t)                      |
               v                           |
        +-------------+                    |
        |  Proceso RC |                    |
        |             |                    |
        | G(s)=1/(τs+1)|                   |
        +------+------+                    |
               |                           |
               v                           |
           Salida y(t)---------------------+
```

La variable medida \(y(t)\) constituye simultáneamente la salida del proceso y la señal de retroalimentación.

---

## 📐 4. Fundamento teórico

### 4.1. Modelo matemático del sistema RC

Un circuito RC puede aproximarse mediante un sistema dinámico de primer orden:

\[
G(s)=\frac{K}{\tau s+1}
\]

Para un circuito RC ideal con ganancia unitaria:

\[
G(s)=\frac{1}{\tau s+1}
\]

La constante de tiempo está determinada por:

\[
\tau=RC
\]

Para este proyecto se considera:

\[
\tau\approx1\ s
\]

### 4.2. Señal de error

El controlador necesita conocer la diferencia entre la referencia y la salida medida:

\[
e(t)=r(t)-y(t)
\]

Donde:

- \(r(t)\): tensión de referencia.
- \(y(t)\): tensión medida en el capacitor.
- \(e(t)\): error del sistema.

Cuando la salida es menor que la referencia, el error es positivo y el controlador debe incrementar la acción de control.

Cuando la salida es mayor que la referencia, el error es negativo y el controlador debe reducir la acción de control.

### 4.3. Ley de control proporcional

La acción de control está determinada por:

\[
\boxed{u(t)=K_p e(t)}
\]

Donde:

- \(u(t)\): señal de control.
- \(K_p\): ganancia proporcional.
- \(e(t)\): señal de error.

La ganancia proporcional determina cuánto responde el controlador ante una determinada magnitud de error.

### 4.4. Efecto de la ganancia proporcional

| Ganancia | Comportamiento esperado |
|---|---|
| Kp pequeño | Respuesta más lenta y menor acción de control. |
| Kp moderado | Respuesta más rápida. |
| Kp elevado | Mayor rapidez, pero puede provocar sobreimpulso o saturación. |

Un controlador proporcional convencional no garantiza eliminar completamente el error en estado estable.

---

## 📊 5. Función de transferencia en lazo cerrado

Considerando realimentación unitaria negativa, el sistema presenta la siguiente estructura:

\[
T(s)=\frac{K_pG(s)}{1+K_pG(s)}
\]

Sustituyendo el modelo del proceso:

\[
T(s)=
\frac{K_p\left(\frac{1}{\tau s+1}\right)}
{1+K_p\left(\frac{1}{\tau s+1}\right)}
\]

Simplificando:

\[
\boxed{T(s)=\frac{K_p}{\tau s+1+K_p}}
\]

Para una constante de tiempo de un segundo:

\[
T(s)=\frac{K_p}{s+1+K_p}
\]

La constante de tiempo equivalente del sistema en lazo cerrado es:

\[
\tau_{CL}=\frac{\tau}{1+K_p}
\]

La ganancia estática en lazo cerrado es:

\[
K_{CL}=\frac{K_p}{1+K_p}
\]

Para una referencia escalón constante, el error en estado estable es:

\[
e_{ss}=\frac{r}{1+K_p}
\]

Estas expresiones consideran un proceso de ganancia unitaria y un controlador proporcional ideal, sin saturación.

---

## 🔌 6. Implementación con Arduino

La implementación considera las siguientes señales:

| Señal | Función | Elemento |
|---|---|---|
| Entrada analógica | Medición de tensión del capacitor | Analog Read |
| Referencia | Valor deseado del voltaje | Potenciómetro o variable |
| Cálculo del error | Diferencia entre referencia y medición | Operación matemática |
| Ganancia Kp | Ajuste de la acción proporcional | Variable |
| Salida PWM | Generación de la señal de control | PWM |
| Comunicación serial | Registro de mediciones | Puerto COM |

### 6.1. Conversión de la lectura analógica

Para un Arduino con ADC de 10 bits y referencia de 5 V:

\[
V_{in}=\frac{N}{1023}V_{ref}
\]

Donde:

- \(N\): lectura del ADC.
- \(V_{ref}\): tensión de referencia del ADC.
- \(V_{in}\): tensión estimada en la entrada analógica.

### 6.2. Algoritmo de control

El procedimiento de control es:

1. Leer la tensión del capacitor.
2. Convertir la lectura analógica a voltaje.
3. Leer o establecer la referencia.
4. Calcular el error.
5. Multiplicar el error por Kp.
6. Limitar la salida al intervalo