# ⚡ Control Proporcional (P) de un Sistema RC de Primer Orden

### 🔬 Implementación con Arduino + MATLAB/Simulink

![Arduino](https://img.shields.io/badge/Arduino-Control%20y%20adquisición-00979D?style=for-the-badge&logo=arduino&logoColor=white)
![MATLAB](https://img.shields.io/badge/MATLAB-Análisis-orange?style=for-the-badge&logo=mathworks&logoColor=white)
![Simulink](https://img.shields.io/badge/Simulink-Modelado-red?style=for-the-badge)
![Control](https://img.shields.io/badge/Control-Proporcional%20(P)-blue?style=for-the-badge)

---

## 📌 1. Descripción

Este proyecto presenta el diseño e implementación de un **controlador proporcional (P) para un sistema RC de primer orden**, utilizando Arduino para el control y la adquisición de datos, y MATLAB/Simulink para el modelado, análisis y simulación del comportamiento dinámico.

El sistema utiliza la tensión medida en el capacitor como variable de proceso. Esta señal se compara con una referencia establecida por el usuario para calcular el error de control.

El controlador proporcional genera una señal de salida directamente relacionada con la magnitud del error:

$$
u(t)=K_p e(t)
$$

La señal de control se aplica al circuito RC para modificar su respuesta y reducir la diferencia entre la referencia y la variable medida.

A diferencia del controlador ON/OFF, el controlador proporcional puede generar diferentes valores de salida dentro del intervalo de operación permitido.

---

## 🎯 2. Objetivo

Implementar y analizar un controlador proporcional para regular la tensión de un circuito RC de primer orden, con una constante de tiempo aproximada de:

$$
\tau \approx 1\ \text{s}
$$

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
3. **Controlador proporcional:** multiplica el error por la ganancia proporcional.
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
               | e(t)                       |
               v                            |
        +-------------+                     |
        | Controlador |                     |
        |      P      |                     |
        | u(t)=Kp*e(t)|                     |
        +------+------+                     |
               | u(t)                       |
               v                            |
        +-------------+                     |
        |  Proceso RC |                     |
        |             |                     |
        | G(s)=1/(τs+1)|                    |
        +------+------+                     |
               |                            |
               v                            |
           Salida y(t)----------------------+
```

La variable medida $y(t)$ constituye simultáneamente la salida del proceso y la señal de retroalimentación.

---

## 📐 4. Fundamento teórico

### 4.1. Modelo matemático del sistema RC

Un circuito RC puede aproximarse mediante un sistema dinámico de primer orden:

$$
G(s)=\frac{K}{\tau s+1}
$$

Para un circuito RC ideal con ganancia unitaria:

$$
G(s)=\frac{1}{\tau s+1}
$$

La constante de tiempo está determinada por:

$$
\tau=RC
$$

Para este proyecto se considera:

$$
\tau\approx1\ \text{s}
$$

Donde:

| Parámetro | Descripción | Unidad |
|---|---|---|
| $G(s)$ | Función de transferencia | Adimensional |
| $K$ | Ganancia estática del proceso | Según la normalización |
| $\tau$ | Constante de tiempo | s |
| $R$ | Resistencia | Ω |
| $C$ | Capacitancia | F |
| $s$ | Variable de Laplace | s⁻¹ |

### 4.2. Señal de error

El controlador calcula la diferencia entre la referencia y la salida medida:

$$
e(t)=r(t)-y(t)
$$

Donde:

- $r(t)$: tensión de referencia.
- $y(t)$: tensión medida en el capacitor.
- $e(t)$: error del sistema.

Cuando la salida es menor que la referencia, el error es positivo y el controlador incrementa la acción de control.

Cuando la salida es mayor que la referencia, el error es negativo y el controlador reduce la acción de control.

### 4.3. Ley de control proporcional

La acción de control está determinada por:

$$
u(t)=K_p e(t)
$$

Donde:

- $u(t)$: señal de control.
- $K_p$: ganancia proporcional.
- $e(t)$: señal de error.

La ganancia proporcional determina cuánto cambia la señal de control ante una determinada magnitud de error.

### 4.4. Efecto de la ganancia proporcional

| Ganancia | Comportamiento esperado |
|---|---|
| $K_p$ pequeño | Acción de control reducida y respuesta generalmente más lenta. |
| $K_p$ moderado | Respuesta más rápida. |
| $K_p$ elevado | Mayor acción de control, con posibilidad de saturación y problemas de desempeño según la planta. |

Un controlador proporcional convencional no garantiza eliminar completamente el error en estado estable.

---

## 📊 5. Función de transferencia en lazo cerrado

Considerando realimentación unitaria negativa, la función de transferencia en lazo cerrado es:

$$
T(s)=\frac{K_pG(s)}{1+K_pG(s)}
$$

Sustituyendo el modelo del proceso:

$$
T(s)=
\frac{K_p\left(\frac{1}{\tau s+1}\right)}
{1+K_p\left(\frac{1}{\tau s+1}\right)}
$$

Simplificando:

$$
T(s)=\frac{K_p}{\tau s+1+K_p}
$$

Para una constante de tiempo de un segundo:

$$
T(s)=\frac{K_p}{s+1+K_p}
$$

La constante de tiempo equivalente del sistema en lazo cerrado es:

$$
\tau_{CL}=\frac{\tau}{1+K_p}
$$

La ganancia estática en lazo cerrado es:

$$
K_{CL}=\frac{K_p}{1+K_p}
$$

Para una referencia escalón constante de amplitud $r$, el error en estado estable es:

$$
e_{ss}=\frac{r}{1+K_p}
$$

Estas expresiones consideran un proceso de ganancia unitaria, un controlador proporcional ideal y ausencia de saturación.

---

## 🔌 6. Implementación con Arduino

La implementación considera las siguientes señales:

| Señal | Función | Elemento |
|---|---|---|
| Entrada analógica | Medición de tensión del capacitor | Analog Read |
| Referencia | Valor deseado del voltaje | Potenciómetro o variable |
| Cálculo del error | Diferencia entre referencia y medición | Operación matemática |
| Ganancia $K_p$ | Ajuste de la acción proporcional | Variable |
| Salida PWM | Generación de la señal de control | PWM |
| Comunicación serial | Registro de mediciones | Puerto COM |

### 6.1. Conversión de la lectura analógica

Para un Arduino con ADC de 10 bits y referencia de 5 V, la conversión aproximada es:

$$
V_{in}=\frac{N}{1023}V_{ref}
$$

Donde:

- $N$: lectura del ADC, entre 0 y 1023.
- $V_{ref}$: tensión de referencia del ADC.
- $V_{in}$: tensión estimada en la entrada analógica.

Si la referencia del ADC es de 5 V:

$$
V_{in}=\frac{5N}{1023}
$$

### 6.2. Algoritmo de control

El procedimiento de control es:

1. Leer la tensión del capacitor.
2. Convertir la lectura analógica a voltaje.
3. Leer o establecer la referencia.
4. Calcular el error.
5. Multiplicar el error por $K_p$.
6. Limitar la salida al intervalo permitido.
7. Aplicar la señal de control mediante PWM o una etapa de salida apropiada.
8. Registrar referencia, medición, error y señal de control.

La ecuación implementada será:

$$
u(t)=\operatorname{sat}\left(K_p e(t)\right)
$$

Para una salida limitada entre 0 y 5 V:

$$
u(t)=
\begin{cases}
5, & K_p e(t)>5\\
K_p e(t), & 0\leq K_p e(t)\leq5\\
0, & K_p e(t)<0
\end{cases}
$$

Esta expresión supone que la señal de control está expresada en voltios y que la ganancia $K_p$ tiene unidades compatibles con dicha salida.

**Nota técnica:** una salida PWM de Arduino representa un ciclo de trabajo, no un voltaje analógico continuo. Para obtener una excitación aproximadamente analógica se requiere un filtro pasa bajas o un DAC, según la plataforma y el montaje.

La etapa de excitación debe ser compatible con el circuito RC. Si se utiliza una excitación unipolar, debe existir una trayectoria eléctrica adecuada para permitir la descarga del capacitor cuando sea necesario.

---

## 🧪 7. Metodología experimental

### Etapa 1. Preparación del circuito

1. Montar el circuito RC.
2. Verificar las conexiones de resistencia y capacitor.
3. Identificar el nodo de medición de tensión.
4. Conectar la salida de control a la etapa de excitación.
5. Conectar la medición a una entrada analógica de Arduino.
6. Verificar que todas las tensiones sean compatibles con la placa.

### Etapa 2. Configuración de parámetros

1. Establecer una referencia de voltaje.
2. Configurar el valor inicial de $K_p$.
3. Configurar la entrada analógica.
4. Configurar la salida PWM.
5. Establecer el periodo de muestreo.
6. Inicializar las variables del controlador.

### Etapa 3. Ejecución del control

1. Leer la tensión del capacitor.
2. Comparar la medición con la referencia.
3. Calcular el error.
4. Aplicar la ley de control proporcional.
5. Limitar la salida de control.
6. Aplicar la señal al proceso RC.
7. Registrar los valores obtenidos.

### Etapa 4. Análisis de resultados

1. Graficar la referencia y la salida del sistema.
2. Representar el error en función del tiempo.
3. Graficar la señal de control.
4. Identificar el tiempo de establecimiento.
5. Determinar el error en estado estable.
6. Evaluar el sobreimpulso, si existe.
7. Comparar el comportamiento utilizando diferentes valores de $K_p$.

---

## 💻 8. Modelado en MATLAB/Simulink

El sistema puede representarse mediante los siguientes bloques:

| Bloque | Función |
|---|---|
| Step | Generar la referencia |
| Sum | Calcular el error |
| Gain | Implementar $K_p$ |
| Saturation | Limitar la señal de control |
| Transfer Fcn | Modelar el circuito RC |
| Scope | Visualizar las señales |
| To Workspace | Exportar los datos |

La función de transferencia del proceso se configura como:

$$
G(s)=\frac{1}{\tau s+1}
$$

Para $\tau=1\ \text{s}$:

- Numerador: `[1]`
- Denominador: `[1 1]`

El controlador proporcional se implementa mediante un bloque Gain con el valor de $K_p$.

La función de transferencia de lazo cerrado es:

$$
T(s)=\frac{K_p}{s+1+K_p}
$$

Si se incorpora saturación, el comportamiento real deja de corresponder al modelo lineal ideal durante los intervalos en que la salida alcanza sus límites.

---

## 📈 9. Experimentos propuestos

Se recomienda realizar diferentes pruebas modificando únicamente la ganancia proporcional y manteniendo constante la referencia.

| Experimento | $K_p$ | Referencia |
|---|---:|---:|
| 1 | 0.5 | 3 V |
| 2 | 1.0 | 3 V |
| 3 | 2.0 | 3 V |
| 4 | 5.0 | 3 V |
| 5 | 10.0 | 3 V |

Los valores son ilustrativos. La ganancia debe ajustarse de acuerdo con las unidades de las señales, la etapa de excitación y las características del circuito.

### Variables que deberán registrar

- Tiempo.
- Referencia.
- Tensión medida.
- Error.
- Señal de control.
- Ganancia proporcional.

---

## 📋 10. Indicadores de evaluación

| Indicador | Descripción |
|---|---|
| Tiempo de establecimiento | Tiempo requerido para alcanzar y mantenerse cerca de la referencia. |
| Tiempo de subida | Tiempo necesario para alcanzar el intervalo definido de la respuesta. |
| Error en estado estable | Diferencia final entre referencia y salida. |
| Sobreimpulso | Máximo excedente respecto a la referencia. |
| Ganancia proporcional | Valor de $K_p$ aplicado. |
| Señal de control | Magnitud de la acción proporcional. |
| Saturación | Tiempo o frecuencia con que la salida alcanza sus límites. |
| Constante de tiempo | Parámetro dinámico estimado del proceso. |

---

## 🚀 11. Aplicaciones didácticas

Este proyecto permite estudiar:

- Modelado de sistemas de primer orden.
- Sistemas de control en lazo cerrado.
- Referencias y señales de error.
- Control proporcional.
- Ajuste de ganancias.
- Saturación de actuadores.
- Respuesta transitoria.
- Error en estado estable.
- Adquisición de señales analógicas.
- Integración de Arduino con MATLAB/Simulink.

---

## 📚 12. Conclusión

El proyecto permite implementar un controlador proporcional para un circuito RC de primer orden, utilizando la tensión del capacitor como variable de proceso y una referencia ajustable como valor deseado.

La acción proporcional modifica la señal de control de acuerdo con la magnitud del error, permitiendo estudiar la relación entre la ganancia del controlador y la respuesta dinámica del sistema.

La integración de Arduino y MATLAB/Simulink proporciona una plataforma didáctica para analizar la velocidad de respuesta, el error en estado estable y el efecto de la saturación.

---

## 📁 13. Estructura sugerida del proyecto

```text
Control_Proporcional_RC/
│
├── README.md
│
├── Arduino/
│   └── controlador_proporcional.ino
│
├── Simulink/
│   └── modelo_control_proporcional.slx
│
├── MATLAB/
│   └── analizar_resultados.m
│
├── Datos/
│   └── mediciones_experimentales.csv
│
└── Resultados/
    ├── respuesta_rc.png
    ├── senal_control.png
    └── comparacion_kp.png
```

Esta estructura es una propuesta organizativa; los archivos pueden incorporarse conforme se desarrolle el proyecto.

---

### 👨‍💻 Tecnologías utilizadas

- Arduino
- MATLAB
- Simulink
- Circuitos RC
- Control proporcional (P)
- Adquisición de señales analógicas
- Modulación por ancho de pulso (PWM)
- Análisis de sistemas dinámicos

**Proyecto educativo de control automático y sistemas dinámicos.**
