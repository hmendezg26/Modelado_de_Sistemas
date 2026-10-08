# ⚡ Control ON/OFF de un Sistema RC de Primer Orden

### 🔬 Implementación con Arduino + MATLAB/Simulink

![Arduino](https://img.shields.io/badge/Arduino-Control%20y%20adquisición-00979D?style=for-the-badge\&logo=arduino\&logoColor=white)
![MATLAB](https://img.shields.io/badge/MATLAB-Análisis-orange?style=for-the-badge\&logo=mathworks\&logoColor=white)
![Simulink](https://img.shields.io/badge/Simulink-Modelado-red?style=for-the-badge\&logo=mathworks\&logoColor=white)
![Control](https://img.shields.io/badge/Control-ON%2FOFF-blue?style=for-the-badge)

---

## 📌 Descripción

Este proyecto presenta el diseño e implementación de un **controlador ON/OFF con histéresis para un sistema RC de primer orden**, utilizando Arduino como plataforma de control y adquisición de datos, y MATLAB/Simulink para el modelado, análisis y simulación del comportamiento dinámico.

El sistema utiliza la tensión medida en el capacitor como variable de proceso. Esta señal se adquiere mediante una entrada analógica de Arduino y se compara con dos niveles de operación:

* **HL (High Level):** límite superior de conmutación.
* **LL (Low Level):** límite inferior de conmutación.

La lógica de control establece dos estados de operación:

* 🔴 **OFF:** cuando la tensión medida alcanza o supera el nivel superior HL.
* 🟢 **ON:** cuando la tensión medida desciende hasta el nivel inferior LL.

Cuando la señal se encuentra entre ambos umbrales, el controlador conserva su estado anterior mediante una memoria lógica. Este comportamiento genera una banda de histéresis que evita conmutaciones innecesarias ante pequeñas variaciones de la señal.

La salida digital de Arduino controla la excitación del circuito RC, mientras que la tensión del capacitor se utiliza como señal de retroalimentación.

**Importante:** el sistema no utiliza una referencia analógica externa ni un punto de suma para calcular el error. La decisión de control se basa directamente en los umbrales HL y LL.

---

## 🎯 Objetivo

Implementar y analizar un controlador ON/OFF con histéresis para regular la tensión de un circuito RC de primer orden, con una constante de tiempo aproximada de:

$$
\tau \approx 1\ \text{s}
$$

El proyecto integra los siguientes elementos:

* 🔌 Circuito RC como proceso físico.
* 🤖 Arduino para el control y la adquisición de señales.
* 📏 Comparadores de nivel superior e inferior HL/LL.
* 🔄 Memoria lógica para conservar el estado del controlador.
* 💻 MATLAB para el procesamiento y análisis de datos.
* 🧩 Simulink para el modelado y la simulación del sistema de control.

---

## 🧱 Arquitectura del sistema

El sistema se organiza en cinco bloques funcionales:

1. **Entrada del controlador:** tensión del proceso adquirida mediante `Analog Read`.
2. **Comparadores HL/LL:** determinan si la variable medida ha alcanzado alguno de los umbrales.
3. **Controlador ON/OFF:** establece el estado de la salida y conserva el estado anterior dentro de la banda de histéresis.
4. **Proceso RC:** responde a la excitación eléctrica aplicada por la salida digital.
5. **Salida y retroalimentación:** la tensión del capacitor se mide y regresa a los comparadores.

### Diagrama funcional

```text
                  ┌───────────────────────┐
                  │   Comparadores HL/LL  │
                  │                       │
                  │  HL: y(t) >= HL       │
                  │  LL: y(t) <= LL       │
                  └───────────┬───────────┘
                              │
                              ▼
                  ┌───────────────────────┐
                  │   Controlador ON/OFF  │
                  │                       │
                  │  Memoria de estado    │
                  │  ON / OFF             │
                  └───────────┬───────────┘
                              │ u(t)
                              ▼
                  ┌───────────────────────┐
                  │       Proceso RC      │
                  │                       │
                  │  G(s) = 1/(τs + 1)    │
                  │       τ ≈ 1 s         │
                  └───────────┬───────────┘
                              │
                              ▼
                  ┌───────────────────────┐
                  │   Salida medida y(t)  │
                  │     Analog Read       │
                  └───────────┬───────────┘
                              │
                              │ Retroalimentación
                              └───────────────►
                                  HL / LL
```

La variable medida \(y(t)\) constituye simultáneamente la salida del proceso y la señal de retroalimentación del controlador.

---

## ⚡ Fundamento teórico

### 1. Modelo matemático del sistema RC

Un circuito RC puede aproximarse mediante un sistema dinámico de primer orden cuya función de transferencia es:

$$
G(s)=\frac{K}{\tau s+1}
$$

Para un circuito RC ideal con ganancia unitaria:

$$
G(s)=\frac{1}{\tau s+1}
$$

donde:

| Parámetro | Descripción              | Unidad     |
| --------- | ------------------------ | ---------- |
| \(G(s)\)  | Función de transferencia | —          |
| \(K\)     | Ganancia estática        | —          |
| \(\tau\)  | Constante de tiempo      | s          |
| \(R\)     | Resistencia              | \(\Omega\) |
| \(C\)     | Capacitancia             | F          |
| \(s\)     | Variable de Laplace      | —          |

La constante de tiempo está determinada por:

$$
\tau=RC
$$

Para este proyecto se considera una constante de tiempo aproximada de un segundo:

$$
\tau\approx1\ \text{s}
$$

El valor real debe verificarse experimentalmente, ya que depende de los componentes utilizados y de las condiciones de operación.

### 2. Respuesta dinámica del proceso

La respuesta de un sistema RC ideal ante un escalón de amplitud \(V_s\) es:

$$
V_C(t)=V_s\left(1-e^{-t/\tau}\right)
$$

durante la carga, suponiendo que el capacitor inicia descargado.

Durante la descarga desde un voltaje inicial \(V_0\):

$$
V_C(t)=V_0e^{-t/\tau}
$$

Estas ecuaciones describen el comportamiento exponencial del proceso. En el sistema de control, la carga y la descarga se alternan según el estado del controlador ON/OFF.

---

## 🔁 Lógica del controlador ON/OFF

El controlador emplea dos umbrales para establecer una banda de histéresis.

Se definen:

* \(y(t)\): tensión medida en el capacitor.
* \(HL\): umbral superior.
* \(LL\): umbral inferior.
* \(u(t)\): señal de control aplicada al proceso.

Debe cumplirse:

$$
HL>LL
$$

### Reglas de conmutación

| Condición de la variable medida | Acción del controlador       | Salida     |
| ------------------------------- | ---------------------------- | ---------- |
| \(y(t)\geq HL\)                 | Apagar el proceso            | OFF        |
| \(LL<y(t)<HL\)                  | Conservar el estado anterior | Sin cambio |
| \(y(t)\leq LL\)                 | Encender el proceso          | ON         |

Considerando una salida digital nominal de 5 V:

$$
u(t)=
\begin{cases}
5\ \text{V}, & y(t)\leq LL\\
u(t^-), & LL<y(t)<HL\\
0\ \text{V}, & y(t)\geq HL
\end{cases}
$$

Aquí, \(u(t^-)\) representa el estado de control inmediatamente anterior. Esta expresión representa una lógica con memoria: dentro de la banda de histéresis no se cambia el estado de la salida.

### Ejemplo de umbrales

Si se seleccionan los siguientes valores ilustrativos:

$$
HL=3\ \text{V}
$$

$$
LL=1\ \text{V}
$$

el comportamiento esperado es:

* Cuando el capacitor alcanza 3 V, la salida cambia a OFF.
* Cuando el capacitor desciende hasta 1 V, la salida cambia a ON.
* Entre 1 V y 3 V, el controlador conserva el estado previo.

Los umbrales son parámetros de configuración y pueden modificarse de acuerdo con el experimento.

---

## 📐 Banda de histéresis

La amplitud de la banda de histéresis se calcula como:

$$
H=HL-LL
$$

Para los umbrales ilustrativos de 3 V y 1 V:

$$
H=3-1=2\ \text{V}
$$

Una banda de histéresis adecuada reduce las conmutaciones repetitivas causadas por ruido eléctrico o pequeñas fluctuaciones de la señal medida.

La elección de los umbrales determina el intervalo de operación del proceso y afecta la frecuencia de conmutación, el tiempo de carga y descarga y la forma de la señal de salida.

---

## 🔌 Implementación con Arduino

La implementación considera dos tipos de señales:

| Señal               | Función                                     | Bloque o elemento                 |
| ------------------- | ------------------------------------------- | --------------------------------- |
| Entrada analógica   | Medición de la tensión del capacitor        | `Analog Read`                     |
| Comparador HL       | Detectar el nivel superior                  | Comparador `>=`                   |
| Comparador LL       | Detectar el nivel inferior                  | Comparador `<=`                   |
| Memoria lógica      | Conservar el estado entre umbrales          | Biestable SR o lógica equivalente |
| Salida digital      | Encender o apagar la excitación del proceso | `Digital Write`                   |
| Comunicación serial | Configuración y registro, si se utiliza     | Puerto COM                        |

### Conversión de la lectura analógica

Para un Arduino con ADC de 10 bits y una referencia analógica de 5 V, la lectura ideal se encuentra entre 0 y 1023.

La conversión aproximada a voltaje es:

$$
V_{in}=\frac{N}{1023}V_{ref}
$$

donde:

* \(N\) es la lectura del ADC.
* \(V_{ref}\) es la tensión de referencia del convertidor.
* \(V_{in}\) es la tensión estimada en la entrada analógica.

Para \(V_{ref}=5\ \text{V}\):

$$
V_{in}=\frac{5N}{1023}
$$

Si los umbrales se configuran en 3 V y 1 V, los valores digitales ideales aproximados son:

$$
N_{HL}\approx614
$$

$$
N_{LL}\approx205
$$

Estos valores son aproximados. La referencia real del ADC y las tolerancias del hardware pueden modificar la conversión.

**Nota de seguridad eléctrica:** la tensión aplicada a las entradas de Arduino debe permanecer dentro de los límites admitidos por la placa. El circuito de potencia, si existe, debe conectarse mediante una etapa de manejo apropiada. No debe asumirse que una salida digital puede alimentar directamente cualquier carga.

---

## 🧪 Metodología experimental

El procedimiento propuesto comprende las siguientes etapas:

### Etapa 1. Preparación del circuito

1. Montar el circuito RC y verificar sus conexiones.
2. Identificar el nodo correspondiente a la tensión del capacitor.
3. Conectar la salida de control al circuito de excitación.
4. Conectar la tensión del capacitor a una entrada analógica de Arduino.
5. Verificar que las tensiones sean compatibles con la placa utilizada.

### Etapa 2. Configuración de parámetros

1. Establecer los umbrales HL y LL.
2. Configurar la entrada analógica y la salida digital.
3. Inicializar el estado del controlador.
4. Configurar la comunicación serial cuando se requiera registrar las mediciones.
5. Verificar que HL sea mayor que LL.

### Etapa 3. Ejecución del control

1. Leer la tensión del capacitor.
2. Convertir la lectura del ADC a voltaje, si es necesario.
3. Comparar la medición con HL y LL.
4. Actualizar la salida cuando se alcance alguno de los umbrales.
5. Mantener el estado previo dentro de la banda de histéresis.
6. Registrar la tensión medida, la salida de control y el tiempo transcurrido.

### Etapa 4. Análisis de resultados

1. Graficar la tensión del capacitor en función del tiempo.
2. Representar la señal de control ON/OFF.
3. Identificar los instantes de conmutación.
4. Analizar los ciclos de carga y descarga.
5. Comparar los resultados experimentales con el modelo RC.
6. Evaluar el efecto de modificar los umbrales HL y LL.

---

## 💻 Modelado en MATLAB/Simulink

El sistema puede representarse en Simulink mediante los siguientes bloques:

| Bloque                              | Función                                      |
| ----------------------------------- | -------------------------------------------- |
| `Analog Input` o señal medida       | Representar la tensión del capacitor         |
| `Compare To Constant`               | Evaluar los umbrales HL y LL                 |
| `SR Flip-Flop` o lógica equivalente | Implementar la memoria del controlador       |
| `Digital Output` o señal de control | Representar la acción ON/OFF                 |
| `Transfer Fcn`                      | Modelar la dinámica del circuito RC          |
| `Scope`                             | Visualizar la respuesta temporal             |
| `To Workspace`                      | Exportar las señales para análisis en MATLAB |

La función de transferencia del proceso se configura como:

$$
G(s)=\frac{1}{\tau s+1}
$$

Para \(\tau=1\ \text{s}\), los coeficientes del numerador y denominador son:

* Numerador: `[1]`
* Denominador: `[1 1]`

Para reproducir la respuesta de un proceso físico, la señal de control debe convertirse en una excitación compatible con el modelo, considerando los niveles de tensión y las condiciones iniciales.

Si se implementa el controlador dentro de Simulink, la salida del modelo RC se conecta a los comparadores HL/LL, cerrando el lazo de retroalimentación.

---

## 📊 Resultados esperados

Durante la operación del controlador se espera observar:

* Una señal de control digital con dos estados: ON y OFF.
* Una tensión del capacitor con variaciones exponenciales de carga y descarga.
* Conmutaciones de apagado al alcanzar el límite HL.
* Conmutaciones de encendido al alcanzar el límite LL.
* Una banda de operación delimitada por ambos umbrales.
* Una reducción de conmutaciones rápidas respecto a una estrategia que cambie de estado ante un único umbral sin memoria.

La frecuencia de conmutación depende de la constante de tiempo del circuito, de los umbrales seleccionados, de la tensión de excitación y de las condiciones iniciales.

Los resultados deben validarse con las mediciones experimentales; no se presuponen valores específicos de frecuencia o desempeño.

---

## 📈 Indicadores de evaluación

Para analizar el funcionamiento del sistema se recomienda registrar:

| Indicador                  | Descripción                                                     |
| -------------------------- | --------------------------------------------------------------- |
| Tiempo de carga            | Tiempo requerido para alcanzar HL desde una condición inicial   |
| Tiempo de descarga         | Tiempo requerido para descender hasta LL                        |
| Frecuencia de conmutación  | Número de cambios de estado por unidad de tiempo                |
| Banda de histéresis        | Diferencia entre HL y LL                                        |
| Tensión máxima             | Mayor tensión registrada en el capacitor                        |
| Tensión mínima             | Menor tensión registrada en el capacitor                        |
| Constante de tiempo        | Parámetro dinámico estimado o medido del circuito               |
| Estabilidad de conmutación | Ausencia de cambios excesivamente rápidos cerca de los umbrales |

---

## 📁 Estructura sugerida del proyecto

```text
Control_ON_OFF_RC/
│
├── README.md
│
├── Arduino/
│   └── controlador_on_off.ino
│
├── Simulink/
│   └── modelo_control_on_off.slx
│
├── MATLAB/
│   └── analizar_resultados.m
│
├── Datos/
│   └── mediciones_experimentales.csv
│
└── Resultados/
    ├── respuesta_rc.png
    └── senal_control.png
```

Esta estructura es una propuesta organizativa; los archivos pueden incorporarse conforme se desarrolle el proyecto.

---

## 🚀 Aplicaciones didácticas

Este proyecto permite estudiar conceptos fundamentales de control automático y sistemas dinámicos:

* Modelado de sistemas de primer orden.
* Adquisición de señales analógicas.
* Comparadores de nivel.
* Control ON/OFF con histéresis.
* Memoria lógica y biestables SR.
* Respuesta transitoria de circuitos RC.
* Retroalimentación de variables de proceso.
* Integración de Arduino con MATLAB/Simulink.
* Análisis experimental y validación de modelos.

---

## 📚 Conclusión

El proyecto permite implementar un controlador ON/OFF con histéresis para un circuito RC de primer orden, utilizando la tensión del capacitor como variable de proceso y retroalimentación.

La lógica HL/LL determina los cambios de estado sin requerir una referencia analógica ni un punto de suma. La memoria del controlador conserva el estado de salida mientras la medición permanece entre los umbrales, permitiendo estudiar el efecto de la histéresis sobre el comportamiento dinámico del sistema.

La integración de Arduino y MATLAB/Simulink proporciona una plataforma didáctica para relacionar el modelo matemático, la lógica de control y la respuesta experimental de un sistema físico.

---

### 👨‍💻 Tecnologías utilizadas

* Arduino
* MATLAB
* Simulink
* Circuitos RC
* Control ON/OFF
* Comparadores HL/LL
* Adquisición y análisis de datos

**Proyecto educativo de control automático y sistemas dinámicos.**
